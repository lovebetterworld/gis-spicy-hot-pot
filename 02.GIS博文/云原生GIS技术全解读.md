- [云原生GIS技术全解读](https://blog.csdn.net/supermapsupport/article/details/85988021)



云原生GIS是面向云环境设计的，基于微服务架构思想的，以容器为部署载体的，可自动化编排、运维管理的，更弹性、更稳定、更新更实时的GIS软件体系架构。

云原生GIS是对传统软件架构的一次重构，让GIS更稳定的同时，它还能更多融合云计算的特性，更灵活、高效、智能。

云原生GIS有三个关键技术：

- 微服务架构：避免不同服务之间相互影响，可以以更小粒度弹性伸缩，使应用更稳定、更灵活。
- 容器化部署：资源更集约，通用配置可以运行更多服务。
- 自动化编排：快速建站，实时更新，降低运维成本。



# 云原生GIS带来的收益

功能相互隔离，更稳定。 传统的GIS部署模式中，GIS功能往往是由一个大而全的GIS Server支撑的；在云原生GIS中，GIS功能被分散到多个小而灵活的GIS微服务共同支撑。如由N个节点共同支撑的GIS网站，在用户看来是一个地址、页面，使用起来是一体的。实际上它不仅是由多个GIS Server在支撑，而且还位于多个机器。如此，每个进程相互独立，专注自己的功能，可以在不影响其他功能的同时独立上线更新，还可以自动隔离，一旦有突发故障，每个进程均会控制在自己范围内，不至影响其他功能、使整个站点宕机。
以容器为载体，更通用。 传统GIS为应对不同的操作系统、硬件环境，以及不同的云计算环境，需要各种方案定制，既不统一，又无法做到自动化快速部署建站；云原生GIS利用Docker、Kubernetes、iManager等技术，可实现自动化快速建站。云原生GIS把GIS微服务包装成容器，从而屏蔽了环境差异，可以在任意环境中无差别的运行；为了应对微服务化后多节点部署运维的复杂性，它还引入了Kubernetes容器编排；同时，它利用SuperMap iManager进行GIS业务层面的调度，使得GIS解决方案可以快速落地，并无差别地适应裸物理机集群、私有云、公有云等各类环境。
细粒度伸缩，更灵活、集约。 首先，相比虚拟机，容器的资源损耗天然就很低；其次，云原生GIS可实现细粒度伸缩。在性能出现瓶颈时，云计算时代的常用做法是利用动态伸缩，增加GIS Server的个数，通过后台集群机制来应对高并发。传统GIS中，因为GIS Server无法拆分为更细粒度，即使支持局部功能瓶颈（例如数据服务），伸缩时也需要部署整个GIS Server，造成资源浪费；而云原生GIS进行了GIS微服务化，伸缩时，只需要部署对应功能的GIS微服务而不是整套GIS Server，从而使资源利用更精细。
图1 云原生GIS更集约的资源利用

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190107101135886.jpg?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3N1cGVybWFwc3VwcG9ydA==,size_16,color_FFFFFF,t_70)

图2 GIS微服务动态扩容

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190107101245780.gif)

# SuperMap的全面容器化和多云支持

容器化是云原生的关键技术之一。虽然Docker容器有Windows和Linux容器之分，但Linux容器是目前公认的、应用范围最广的类型，Windows容器在生产环境中使用还不多见。所以跨平台是GIS容器化的基础。SuperMap自2005年就提出了共相式GIS（Universal GIS）内核的概念，打造全系列、全功能的GIS平台体系。


![在这里插入图片描述](https://img-blog.csdnimg.cn/20190107101801473.jpg?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3N1cGVybWFwc3VwcG9ydA==,size_16,color_FFFFFF,t_70)

图3 基于跨平台技术的SuperMap多云支持

SuperMap自2014年就开始引入Docker技术，对GIS产品进行容器化，涵盖GIS应用服务器、GIS门户服务器、GIS运维管理中心、GIS边缘服务器、跨平台GIS桌面等多个产品。容器化使GIS的部署更通用、更标准，同时相比虚拟机性能损耗更低。

在GIS容器化过程中，除了要保障GIS容器的灵活伸缩，还需要支持无状态化或曰状态隔离。GIS产品部署为GIS应用，应用有状态，产品无状态，状态包括GIS数据、用户角色外，还有服务配置、地图缓存、Session信息等。如果这些状态不抽离，在节点发生故障时，虽然产品能恢复，但这些状态都要丢失。弹性伸缩时，新增的GIS容器势必要同步状态，无法自动化且麻烦，而无状态化后，GIS容器的状态通过数据卷的方式被分离到了容器外部，此时无论是容器删除重建还是弹性伸缩，新容器都会自动挂载状态，自动恢复GIS服务。

# SuperMap的微服务治理

微服务是云原生的关键技术之一，是新一代GIS架构的基础。如果不做微服务化，即使在云平台中可以部署，但GIS Server会像以前一样臃肿，无法做到小而灵活，无法快速部署迁移、分布式动态调配、弹性伸缩，更无法在突发灾难到来时，做到故障隔离。

微服务化后，GIS服务之间的依赖被明确，且相互解耦，从单体式应用演变为分布式，给开发部署带来更多灵活性和技术多样性，使GIS能充分利用云计算的优势，在公有云、私有云和混合云等新型动态环境中，构建和运行可弹性扩展的应用。

SuperMap采用微内核+REST接口的面向资源架构，按照GIS功能和接口类型划分服务粒度，现有10大类21小类微服务。这些微服务松耦合，可独立部署，互不影响，微服务之间通过轻量级通信机制REST进行通信。如下图所示，传统的GIS服务器是一体的，只能部署在单个节点上，微服务改造把一体的功能拆分成可独立部署的GIS微服务（图中不同颜色的小圆），不仅可以灵活部署于多个节点，还可以灵活的实现分布式弹性伸缩、调度。

从SuperMap GIS 6R到当前的SuperMap GIS 9D(2019)，SuperMap一直致力于微服务改造和积累，不仅包括GIS功能微服务，还关注基础功能微服务以及微服务治理。下图是SuperMap的微服务发展路线图。


![在这里插入图片描述](https://img-blog.csdnimg.cn/20190107101932172.jpg?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3N1cGVybWFwc3VwcG9ydA==,size_16,color_FFFFFF,t_70)

图4 SuperMap iServer微服务路线图

# SuperMap的自动化管理

GIS微服务带来了快速、稳定、集约等好处，但由单体应用到多个微服务，也会对管理带来挑战，如果不能自动化管理，那么不论是部署上线，还是升级维护，都会很繁琐。

在SuperMap GIS云原生方案中，GIS微服务通过容器化实现通用的快速部署，通过Kubernetes编排实现分布式、自动化的容器部署、扩展和管理，通过SuperMap iManager串联GIS业务，例如存储管理、安全管理、日志管理、监控、弹性伸缩等。iManager是SuperMap动态编排弹性伸缩的GIS中心，它还包装和简化了容器、Kubernetes的使用细节，用户不需要熟悉Kubernetes，依然可以打造一个云原生GIS系统。


![在这里插入图片描述](https://img-blog.csdnimg.cn/2019010710202147.jpg?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3N1cGVybWFwc3VwcG9ydA==,size_16,color_FFFFFF,t_70)

图5 动态编排弹性伸缩的GIS中心

# SuperMap的公有云实践

www.supermapol.com是SuperMap的公有云站点，提供在线的GIS数据、GIS平台，以及应用托管的按需租赁服务，打造一站式在线GIS数据与应用平台。通过以租代建的使用方式，降低GIS服务门槛，协助低成本、便捷、高效的构建GIS应用。后台采用云原生GIS方案构建，并不断滚动更新最新的研发成果。对国内常见的阿里云、腾讯云都有对接适配。

1、微服务拆分，不同功能分散部署于后台10多个服务器，不仅可以精细扩展，而且可以局部无缝升级。

2、服务治理，全部采用容器+Kubernetes部署管理方式，确保资源灵活调度，网站7*24小时在线。

3、GIS云主机，无缝衔接阿里云、京东云，自助式提供GIS云主机。

4、GIS云存储，提高数据可用性和访问速度：

- 适配阿里云对象存储OSS，云数据库RDS PostgreSQL 版，支持矢量数据的存储和发布。
- 适配阿里云表格存储Table Store，云数据库MongoDB版，支持地图瓦片的生产和直接发布。

# 小结

云原生GIS使传统GIS应用从单体变为了微服务，使GIS在云平台中的部署方式从虚拟机变为了容器，使GIS应用的管理模式从手动管理变为了自动化编排，从而在云平台中可以更灵活的伸缩调度、使GIS应用能更好地利用云平台的特性。SuperMap对云原生GIS的实践，使GIS服务更稳定高效，不仅应用于私有云，借助对国内外公有云的对接实践，更能协助客户融入公有云的优势模块/特性，快速高效落地云GIS方案。
