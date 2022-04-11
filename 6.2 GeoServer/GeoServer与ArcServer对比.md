- [GeoServer与ArcServer对比](https://www.cnblogs.com/boonya/p/14861022.html)

## 一、GeoServer与ArcServer简介

### 1、 GeoServer简介

GeoServer是OpenGIS Web服务器规范的J2EE实现的社区开源项目，利用GeoServer可以方便的发布地图数据，允许用户对特征数据进行更新、删除、插入操作，通 过GeoServer可以比较容易的在用户之间迅速共享空间地理信息。

### 2、ArcServer简介

ArcServer是ESRI公司推出的一个基于服务器的ArcGIS工具，主要可以实现两大功能：
（1）强大的WebGIS系统的开发。
（2）分布式GIS系统的开发。

## 二、GeoServer与ArcServer比较

### （1）开源性

GeoServer是一个开源GIS服务器，而ArcServer不是一个开源GIS服务器，所有想在Web地图应用开发中使用ArcServer就需要付费，而且价格比较高。

### （2）服务器功能

GeoServer中包括一些GIS服务器的基本功能，基本满足大多数的Web地图应用开发，而ArcServer中的几乎涵盖所有GIS服务器应该具备的功能，这一点是ArcServer 的优点也是缺点，就类似于Oracle之于MySQL数据库，一个是企业级的数据库，功能强大，覆盖面广，但相对来说比较“笨重”，而MySQL是轻量级的数据库，附带一些常 用的数据库功能，对于一般的业务需求来说，它自带的一些功能已经足以支撑。类似于MySQL数据库，GeoSerVer自带的一些功能已经足以支撑大多数Web地图应用开 发。

### （3）访问速度                                      

ArcServer相对于其他开源的GIS服务器（包括GeoServer）来说，它的访问速度是比较快的。

### （4）操作性

GeoServer复杂、操作比较困难，且本身不具备对应的桌面软件，所以前期对于待处理地理数据的编辑整饰必须借助第三方软件，目前比较常用的是uDig。而 ArcServer简单、可操作性强，自身具备对应的桌面软件ArcMap，所以对于前期地理数据的编辑整饰比较方便，ArcServer相对GeoServer来说比较容易上手。

### （5）稳定性

与绝大多数商业软件相同，ArcServer比其他一些开源GIS服务器相对来说能更稳定一些。

### （6）应用性

就目前来说ArcGIS的发展已经比较成熟，使用ArcGIS的人比较多，所以市场上、网络上关于ArcGIS系列产品的教材、应用实例非常多，基本上你能用到的GIS功能， 在网上都能找到相应的Demo。国内的很多大学的GIS教材也都是ArcGIS的，这也导致ArcGIS的人才好找一点。

## 总结：

就ArcServer与GeoServer的优势而言，ArcServer有大量的GP（Geoprocessing）服务，GP服务提供了大量的地理处理和分析工具，功能强大，发展比较成熟，操作 简单，但是不开源。而GeoServer与OpenLayers集成比较好，而且开源，虽然是一个轻量级的GIS服务器，但“麻雀虽小，五脏俱全”，可以满足大部分的Web地图应用开 发，而且可以帮助程序员理解GIS服务器的运行机理，但是操作复杂，不易于上手。