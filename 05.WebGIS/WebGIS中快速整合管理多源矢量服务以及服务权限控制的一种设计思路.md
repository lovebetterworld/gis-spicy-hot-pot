- [WebGIS中快速整合管理多源矢量服务以及服务权限控制的一种设计思路](https://www.cnblogs.com/naaoveGIS/p/5614215.html)

## 1.背景

在真实项目中，往往GIS服务数据源被其他多个信息中心或者第三方公司所掌控，当需要快速搭建一套能够对所有GIS数据，根据权限不同、需求不同、而进行展示的系统。为了避免在代码层面上过多的定制化开发，我们需要能提出一种可以整合管理多源矢量服务并进行权限控制的架构。

目前商业GIS软件中，Esri公司给出了其Portal产品，可以对arcgis  Server发布的各矢量服务、符合OGC标准的第三方服务，进行整合管理成为针对用户而言的一个整体服务，并且能够配置不同权限人员看到的服务内容各不相同。实现门户的快速开发和资源的管理。

所以，我们现在要进行设计的，可以简单的理解为，做一个我们自己的简单的Portal产品。

## 2.设计思路

### 2.1流程图设计

  ![img](https://images2015.cnblogs.com/blog/656746/201606/656746-20160624145912297-1214491284.png)           

 

### 2.2核心设计

流程图中，核心部分为物理图层元数据库、专题数据库、权限数据库的建立。

**图层元数据库：**是指将各数据源中的核心元数据进行建库，比如地理服务URL地址、服务中各图层和图层组组织信息、图层号、图层组号、图层字段等。

**专题数据库：**是指基于图层元数据库建立的针对用户专题需求的库，用户无需关心各图层出自哪个数据源等，可以进行定制化的快速建库。

**权限控制库：**是指针对不同人员岗位对各专题以及专题中的图层进行控制权限建库。比如岗位A下的人员，只可以看见专题MapA，并且对MapA下的不同图层其管理权限各不相同（查看、编辑）。

## 3.实现方案

### 3.1物理图层元数据库建立

开发工具能够获取各数据源服务中的服务元数据信息，参考界面如下：

 ![img](https://images2015.cnblogs.com/blog/656746/201606/656746-20160624145935078-454048369.png)

### 3.2专题数据库建立

专题中，支持新增图层组，支持对任何图层和图层组进行重组、编辑，参考界面如下：

 ![img](https://images2015.cnblogs.com/blog/656746/201606/656746-20160630170213562-151447682.png)

 

### 3.3权限管理库建立

建立岗位与专题以及专题内容之间的权限关系数据，参考界面如下：

 ![img](https://images2015.cnblogs.com/blog/656746/201606/656746-20160624150029422-2088472391.png)

### 3.4前端展示

不同岗位人员登陆后看到的专题将各不相同，如下所示：

![img](https://images2015.cnblogs.com/blog/656746/201606/656746-20160624151138906-1422198298.png)

 