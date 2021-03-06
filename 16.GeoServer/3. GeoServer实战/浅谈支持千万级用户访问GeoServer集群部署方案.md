- [浅谈支持千万级用户访问GeoServer集群部署方案 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/536352496)

## 一、前言

GeoServer是一个非常强大的开源GIS地图服务器，它是 OpenGIS Web 服务器规范的 J2EE 实现，利用 GeoServer 可以方便的发布地图数据，允许用户对特征数据进行更新、删除、插入操作，通过 GeoServer 可以比较容易的在用户之间迅速共享空间地理信息。

在一个经典的GIS系统中，GeoServer是一个不可或缺的角色，它在后台负责读取 业务图层数据，把他们渲染成图片，然后传送给前台，用于在地图上进行叠加展示。

以最常用的WMS服务为例

![img](https://pic1.zhimg.com/80/v2-53d1bb63cd50a21eac68a374bdf73dd4_720w.jpg)

每一次wms服务的请求，GeoServer都要查询数据+渲染，这个过程比较耗费性能，因此GeoServer的单机吞吐量有限，根据我的测试，geoserver部署在8核16G的机器上，发布一个有5万个要素的面图层的WMS服务，测试他的tps 最高在1100左右。（**tps，即秒钟处理的交易次数，在这里1100tps可以理解为每秒钟最多可以处理完成1100个wms服务请求**）

显然这样的吞吐量，部署单机GeoServer是无法满足千万级用户的高并发要求，必须把GeoServer做成集群，提供高并发的能力。

## 二、GeoServer集群需要考虑的几个问题

**如何测算集群需要部署多少台机器？**

**如何进行集群部署？**

**如何监控集群中的geoserver节点是否正常，不正常如何剔除？**

针对这些问题，我以我目前设计、开发的全国级GIS平台为例，一一说明。

### **2.1集群要部署多少台机器？**

这个问题，需要测算我们平台在使用过程中可能达到的最大TPS是多少。

我们的测算过程是这样的。

第一步：我们系统总用户量有5000多万，但是不是同时在线，根据 监控系统统计的在线用户量历史数据分析，在每天的10点钟，最大在线用户量有120万的样子，所以计算最大tps的时候，就以120万作为参考，而不是5000万。

第二步：我们模拟单个用户使用我们的系统进行 正常的业务操作，测试出单位时间内调用GeoServer wms服务的频率，得出结论，平均每秒钟调用0.02次。意味着 **最大tps = 1200000\*0.02 = 24000**

第三步：单机GeoServer吞吐量在1100，因此要支持24000的tps,理论上最少要部署24台机器，但是又要考虑 集群部署后，在统一入口处做分发，会有性能损耗，因为需要多部署几台机器，最后初步估算需要部署 **30 台机器**。

### 2.2如何进行集群部署？

集群部署，首先要考虑的两个问题

**问题1：如何进行负载均衡？**

可以使用nginx、阿里云的SLB等负载均衡器，按照ip hash负载或者是轮询负载等等，这个比较简单，不做探讨。

**问题2：各个节点之间的数据如何同步？**

这个是GeoServer集群的重点，难点。

GeoServer集群数据同步问题，常用的两个解决方案如下：

**方案1：基于共享文件夹的GeoServer集群**

GeoServer有一个数据目录，叫做data_dir，所有的配置数据都会写入这个目录对应的文件中。共享文件夹集群部署的方式就是，把每一个GeoServer节点的data_dir目录配置成一个共用的data_dir文件夹，这样其中一个GeoServer节点，修改了配置，就会把共享的data_dir修改了，其他的GeoServer节点重启后，就会读到data_dir最新的配置了。

![img](https://pic1.zhimg.com/80/v2-a9932b4781e288939a46cd178dee6994_720w.jpg)

优点：配置简单

缺点：需要重启或者是编写代码调用各个节点的/reload接口才能生效，使用麻烦。

单个GeoServer节点修改了配置数据，并把新的配置持久化到了data_dir目录中，但是其他的GeoServer节点无法及时生效最新的配置，因为GeoServer的配置是放在内存里面，只有进行重启或者是调用它的RestAPI 接口/reload 才会重新读取data_dir目录下的配置，因此，这个方案，对于频繁修改GeoServer配置的应用场景来说，不友好。

（说明一下 所谓的修改GeoServer配置 指的是，用户操作GeoServer进行业务处理，如新建 工作空间，新建 数据存储，发布wms服务等等操作 导致GeoServer的配置得到了修改。）

**方案2：基于JMS的GeoServer集群**

这个是官网推荐的GeoServer集群方案

![img](https://pic2.zhimg.com/80/v2-6678983dc9b3f098daa446128bce4f41_720w.jpg)

原理是：

使用MQ中间件，GeoServer集群中，分为主节点和从节点，主节点负责配置的新增、修改、删除操作，把操作包装成消息发送给MQ，从节点GeoServer监听对应的Topic，消费MQ的消息，进行对应配置的 新增，修改，删除操作，这样 GeoServer的各个节点就可以及时同步他们的配置数据。

**这个配置流程有点复杂，并且坑比较多，后面我会专门拿出一个专栏来讲，感兴趣的朋友可以先关注一下。**

### **2.3**如何监控集群中的geoserver节点是否正常，不正常如何剔除？

这是一个非常重要的问题，在集群部署高并发的系统中，必须要考虑各个服务节点是否健康的问题，以及如果不健康了，如何剔除的问题，以达到最小的影响。

解决这个问题有几种方式可以考虑:

**1.nginx插件**

这是在使用nginx作为GeoServer集群负载均衡的情况下可以这么做，就是开发nginx插件，监听各个geoserver 8080端口是否正常，不正常就剔除，不再往那边发送请求。但是开发nginx插件需要使用到lua语言，我对这个语言和生态不熟悉，当时研究了一下，发现难度较大，不可控因素很多，就没有继续了。

**2.使用阿里云的SLB**

在阿里云控制台上配置 GeoServer节点就可以了，它有监控检测机制，GeoServer节点要是不健康了，就不会王那边发送，没啥缺点，就是贵！

**3.使用Nacos服务中心**

改造GeoServer源码，引入SpringCloud Alibaba框架，把GeoServer注册到Nacos中，可以实时查看GeoServer各个节点的监控状态，还可以动态扩容GeoServer。这个是我目前的做法，效果很不错，已经平稳运行了4年了。