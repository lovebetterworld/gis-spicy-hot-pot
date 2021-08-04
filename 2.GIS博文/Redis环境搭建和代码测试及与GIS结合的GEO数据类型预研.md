- [Redis环境搭建和代码测试及与GIS结合的GEO数据类型预研](https://www.cnblogs.com/naaoveGIS/p/6728459.html)

## 1.背景

### 1.1传统MySQL+ Memcached架构遇到的问题

MySQL本身是适合进行海量数据存储的，通过Memcached将热点数据加载到cache从而加速访问，很多公司目前都采用这样的架构，但随着业务数据量和访问量的持续增长，我们遇到了很多问题：

a.MySQL需要不断进行拆库拆表，Memcached也需不断跟着扩容，扩容和维护工作占据大量开发时间。

b.Memcached与MySQL数据库数据一致性问题。

c.Memcached数据命中率低或宕机，大量访问直接穿透到DB，MySQL无法支撑。

d.跨机房cache同步问题。

为解决以上问题，我们开始选择用Redis来替代Memcached。

### 1.2Redis简介

Redis是一种典型的NoSQL数据库服务器，它可以作为服务程序独立运行于自己的服务器主机。在很多时候，人们只是将Redis视为Key/Value数据库服务器，但是在目前的版本中，Redis除了Key/Value之外还支持List、Hash、Set和Ordered Set等数据结构，因此它的用途也更为宽泛。Redis的License是Apache License，就目前而言，它是完全免费。

我们经常会将memcached（数据缓存服务器）与Redis来进行对比，因为他们在使用方式上比较相似，而且也均是免费，均使用了内存来进行数据缓存。但是它们之间的最大区别在于memcached只是提供了数据缓存服务，一旦服务器宕机，之前在内存中缓存的数据也将全部消失，  memcached没有提供任何形式的数据持久化功能，而Redis则提供了这样的功能。第二，Redis提供了更为丰富的数据存储结构，如Hash和Set等。

项目中经常在如下几个场景中使用Redis：Session共享，数据采集统计等。

## 2.Redis环境搭建 

### 2.1下载安装

Redis对于Linux是官方支持的,安装和使用参考官网(http://redis.io/download)，但是Redis官方是不支持windows的，好在 Microsoft Open Tech group 在  GitHub上开发了一个Win64的版本,项目地址是：https://github.com/MSOpenTech/redis。打开后，直接使用浏览器下载或Git克隆即可：

 ![img](https://images2015.cnblogs.com/blog/656746/201704/656746-20170418160854962-1610343953.png)

直接双击redis-server.exe即启动一个redis服务实例，但是如果想以windows服务形式运行，需要执行一下命令：

//注册至服务管理中

redis-server --service-install redis.windows.conf --loglevel verbose --service-name Redis6379

成功后，开启服务即可：

 ![img](https://images2015.cnblogs.com/blog/656746/201704/656746-20170418160909384-556834848.png)

### 2.2主从配置

Redis如mysql数据库一样，可以支持主从数据库配置，而且配置方式十分简单。将原有Redis安装文件再复制一份，打开Config文件，修改对应slaveof配置即可：

 ![img](https://images2015.cnblogs.com/blog/656746/201704/656746-20170418161004712-2053737597.png)

以上面提到的指令注册服务，运行该从数据库：

![img](https://images2015.cnblogs.com/blog/656746/201704/656746-20170418161104368-491996199.png)

### 2.3密码和权限配置

Redis默认是没有密码的，为了数据的安全性需要我们自己启动权限控制和密码配置等。

#### 2.3.1设置访问权限

打开config文件，找到bind关键字，修改其中绑定的IP即可：

 ![img](https://images2015.cnblogs.com/blog/656746/201704/656746-20170418161118837-1099957491.png)

#### 2.3.2设置密码

同样打开config文件，找到requirepass关键字，将对应部分修改为指定密码：

 ![img](https://images2015.cnblogs.com/blog/656746/201704/656746-20170418161134649-1071691627.png)

注意，如果我们对主数据库设定了密码，那么slave数据库上在监听主数据库的配置中也要加上对应的密码：

 ![img](https://images2015.cnblogs.com/blog/656746/201704/656746-20170418161146884-1069792646.png)

### 2.4Redis可视化管理工具

这里我们使用RedisDesktopManager来管理Redis数据库。在官网上(https://redisdesktop.com/download)下载完该工具后，本地安装后连接至数据库上：

![img](https://images2015.cnblogs.com/blog/656746/201704/656746-20170418161210118-1940382308.png) 

单击主数据库文件中的redis-cli.exe，输入测试命令：

 ![img](https://images2015.cnblogs.com/blog/656746/201704/656746-20170418161418696-971501414.png)

在输入获取Value的命令，发现已经成功：

 ![img](https://images2015.cnblogs.com/blog/656746/201704/656746-20170418161428243-128963851.png)

同时，在可视化工具中能看到，主从数据库中均已同步：

 ![img](https://images2015.cnblogs.com/blog/656746/201704/656746-20170418161437212-1225774283.png)

## 3.Java操作

### 3.1依赖环境

使用Java操作Redis需要jedis-2.1.0.jar，下载地址：http://files.cnblogs.com/liuling/jedis-2.1.0.jar.zip。

如果需要使用Redis连接池的话，还需commons-pool-1.5.4.jar，下载地址:http://files.cnblogs.com/liuling/commons-pool-1.5.4.jar.zip。

### 3.2常用据类型使用

Redis中可以存储各种数据类型，不同数据类型有其使用场景，具体各数据类型的使用在操作文档中均能查找（http://redisdoc.com/index.html）：

 ![img](https://images2015.cnblogs.com/blog/656746/201704/656746-20170418161532571-129305074.png)

![img](https://images2015.cnblogs.com/blog/656746/201704/656746-20170418161556993-926005543.png)

 这里以几个常用类型作为介绍。

#### 3.2.1连接

 ![img](https://images2015.cnblogs.com/blog/656746/201704/656746-20170418161623477-726281807.png)

#### 3.2.2String

String是最常用的一种数据类型，普通的key/value存储都可以归为此类，value其实不仅是String，也可以是数字：比如想知道什么时候封锁一个IP地址(访问超过几次)。INCRBY命令让这些变得很容易，通过原子递增保持计数。 

 ![img](https://images2015.cnblogs.com/blog/656746/201704/656746-20170418161638993-2024774772.png)

 ![img](https://images2015.cnblogs.com/blog/656746/201704/656746-20170418161706243-685098028.png)

![img](https://images2015.cnblogs.com/blog/656746/201704/656746-20170418161720665-2102052772.png)

#### 3.2.3List

在Redis中，List类型是按照插入顺序排序的字符串链表。和数据结构中的普通链表一样，我们可以在其头部(left)和尾部(right)添加新的元素。在插入时，如果该键并不存在，Redis将为该键创建一个新的链表。与此相反，如果链表中所有的元素均被移除，那么该键也将会被从数据库中删除。List中可以包含的最大元素数量是4294967295。
 从元素插入和删除的效率视角来看，如果我们是在链表的两头插入或删除元素，这将会是非常高效的操作，即使链表中已经存储了百万条记录，该操作也可以在常量时间内完成。然而需要说明的是，如果元素插入或删除操作是作用于链表中间，那将会是非常低效的。相信对于有良好数据结构基础的开发者而言，这一点并不难理解。

 ![img](https://images2015.cnblogs.com/blog/656746/201704/656746-20170418161748243-1435702466.png)

![img](https://images2015.cnblogs.com/blog/656746/201704/656746-20170418161809618-402359810.png)

#### 3.2.4Set

在Redis中，我们可以将Set类型看作为没有排序的字符集合，和List类型一样，我们也可以在该类型的数据值上执行添加、删除或判断某一元素是否存在等操作。需要说明的是，这些操作的时间复杂度为O(1)，即常量时间内完成次操作。Set可包含的最大元素数量是4294967295。
和List类型不同的是，Set集合中不允许出现重复的元素，这一点和C++标准库中的set容器是完全相同的。换句话说，如果多次添加相同元素，Set中将仅保留该元素的一份拷贝。和List类型相比，Set类型在功能上还存在着一个非常重要的特性，即在服务器端完成多个Sets之间的聚合计算操作，如unions、intersections和differences。由于这些操作均在服务端完成，因此效率极高，而且也节省了大量的网络IO开销。

 ![img](https://images2015.cnblogs.com/blog/656746/201704/656746-20170418161840977-1799170819.png)

![img](https://images2015.cnblogs.com/blog/656746/201704/656746-20170418161853727-283331803.png)

#### 3.2.5Hash

我们可以将Redis中的Hashes类型看成具有String Key和String  Value的map容器。所以该类型非常适合于存储值对象的信息。如Username、Password和Age等。如果Hash中包含很少的字段，那么该类型的数据也将仅占用很少的磁盘空间。每一个Hash可以存储4294967295个键值对。

 ![img](https://images2015.cnblogs.com/blog/656746/201704/656746-20170418161958321-933860182.png)

![img](https://images2015.cnblogs.com/blog/656746/201704/656746-20170418162010634-1877222941.png) 

## 4.redis的持久化问题

Redis提供了以下几种持久化方式：

a.RDB持久化：
 该机制是指在指定的时间间隔内将内存中的数据集快照写入磁盘。  
 b.AOF持久化:

该机制将以日志的形式记录服务器所处理的每一个写操作，在Redis服务器启动之初会读取该文件来重新构建数据库，以保证启动后数据库中的数据是完整的。

c.无持久化：

我们可以通过配置的方式禁用Redis服务器的持久化功能，这样我们就可以将Redis视为一个功能加强版的memcached了。

d.同时应用AOF和RDB。

## 5.Redis与GIS的结合：GEO数据类型

Redis3.2版本中增加了对GEO（地理位置）的支持。目前其提供了以下几种操作方式：

a.geoadd：增加某个地理位置的坐标。

b.geopos：获取某个地理位置的坐标。

c.geodist：获取两个地理位置的距离。

d.georadius：根据给定地理位置坐标获取指定范围内的地理位置集合。

e.georadiusbymember：根据给定地理位置获取指定范围内的地理位置集合。

f.geohash：获取某个地理位置的geohash值。

因为其面向的为主流互联网环境，所以其支持的地理坐标系指定为WGS84坐标系，其中的geohash编码算法与我在之前的博客中所提到的一致：WebGIS中GeoHash编码的研究和扩展（http://www.cnblogs.com/naaoveGIS/p/5164187.html）。除了我们自己写代码完成该算法，也有已经开源封装好的源码：https://github.com/kungfoo/geohash-java。