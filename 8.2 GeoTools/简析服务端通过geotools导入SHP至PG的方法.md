- [简析服务端通过geotools导入SHP至PG的方法](https://www.cnblogs.com/naaoveGIS/p/6098515.html)

## 1.背景

项目中需要在浏览器端直接上传SHP后服务端进行数据的自动入PG库以及发布至geoserver。本方法是以geotools为开发工具实现入库，以geoserver manager来实现服务的自动发布。这里着重描述geotools编写SHP入库的方法。

## 2.Geotools介绍

### 2.1总体介绍

Geotools是[Java](http://lib.csdn.net/base/javaee)语言编写的开源GIS工具包，其功能涵盖了地理信息数据读写、处理、坐标转换、查询分析、格式化输出等多个方面。该项目已有十多年历史，生命力旺盛，代码非常丰富，包含多个开源GIS项目，并且基于标准的GIS接口。Geotools主要提供各种GIS[算法](http://lib.csdn.net/base/datastructure)，各种数据格式的读写和显示。在显示方面要差一些，只是用Swing实现了地图的简单查看和操作。但是用户可以根据Geotools提供的算法自己实现地图的可视化。OpenJump和udig就是基于Geotools的。
  Geotools用到的两个较重要的开源GIS工具包是JTS和GeoAPI。前者主要是实现各种GIS拓扑算法，也是基于GeoAPI的。但是由于两个工具包的GeoAPI分别采用不同的Java代码实现，所以在使用时需要相互转化。Geotools又根据两者定义了部分自己的GeoAPI，所以代码显得臃肿，有时容易混淆。由于GeoAPI进展缓慢，Geotools自己对其进行了扩充。另外，Geotools现在还只是基于2D图形的，缺乏对3D空间数据算法和显示的支持。

Geotools The Open Source [Java ](http://lib.csdn.net/base/java)GIS Toolkit的相关学习网站如下：

http://geotools.org/  Geotools官方网站
http://docs.geotools.org/latest/javadocs/     Geotools API在线文档
http://docs.codehaus.org/display/GEOTDOC/Home　Geotools用户指南
[http://repo.opengeo.org](http://repo.opengeo.org/)　　　              Geotools的maven仓库
[http://download.osgeo.org/webdav/geotools/ ](http://download.osgeo.org/webdav/geotools/)    maven仓库地址

### 2.2整体架构

 ![img](https://images2015.cnblogs.com/blog/656746/201611/656746-20161124165346846-2077548353.png)

org.geotools.data包负责地理数据的读写(如:ShapefileReader用于读取shpfile数据)。

org.geotools.geometry包负责提供对JTS的调用接口，以将地理数据封装成JTS中定义的几何对象(Geometry)。

org.geotools.feature包负责封装空间几何要素对象(Feature)，对应于地图中一个实体，包含:空间数据(Geometry)、属性数据(Aitribute)、参考坐标系(Refereneedsystem)、最小外包矩形(EnveloPe)等属性，是GlS操作的核心数据模型。

### 2.3geotools中的核心Jar说明

a.GT核心库

 ![img](https://images2015.cnblogs.com/blog/656746/201611/656746-20161124165355206-557578974.png)

其中红色的包含了要素定义、SHP读取、EPSG获取等相关方法的jar。

b.hsqldb

 ![img](https://images2015.cnblogs.com/blog/656746/201611/656746-20161124165405846-1117732640.png)

需要配合gt-epsg-hsql来使用，可以查询对应的epsg编码。

c. Image I/O-Ext

 ![img](https://images2015.cnblogs.com/blog/656746/201611/656746-20161124165413081-1127895747.png)

支持跟GIS有关的图片格式。

d.jts

 ![img](https://images2015.cnblogs.com/blog/656746/201611/656746-20161124165423128-1965715722.png)

JTS提供了这些空间数据类Point、MultiPointLineString、LinearRing(封闭的线条)、MultiLineString (多条线)、PolygonMultiPolygon 、 GeometryCollection(包括点，线，面)。JTS包结构为计算交点（noding包）、几何图形操作（operation包）、平面图（planargraph包）、多边形化（polygnize包）、精度（precision）、工具（util包）。

e.jsr、vecmath

 ![img](https://images2015.cnblogs.com/blog/656746/201611/656746-20161124165431128-1130921068.png)

做投影相关运算时需要这两个jar: jsr-275-1.0-beta-2.jar和vecmath-1.3.1.jar。

f. opengis库

 ![img](https://images2015.cnblogs.com/blog/656746/201611/656746-20161124165448331-2076903593.png)

h.其他各类jar

包含数据库驱动的jar，log4j，XML解析的jar等等。可以实现读取不同数据库的数据，对xml格式的文件比如SLD的解析等等。

## 3.SHP各文件的简介

shape文件由ESRI开发，一个ESRI（Environmental Systems Research Institute)的shape文件包括一个主文件，一个索引文件，和一个[dBASE](http://baike.baidu.com/view/684011.htm)表，其中主文件的后缀就是.shp。

主文件是一个直接存取，变量记录长度文件，其中每个记录描述一个有它自己的vertices列表的shape。

索引文件中，每个记录包含对应主文件记录离主文件头开始的偏移。

dBASE表包含记录的feature的特征。几何和属性间的一一对应关系是基于记录数目的。在dBASE文件中的属性记录必须和主文件中的记录是相同顺序的。

 ![img](https://images2015.cnblogs.com/blog/656746/201611/656746-20161124165456096-1117637626.png)

## 4.ST_Geometry函数

ST_Geometry SQL 数据类型用于存储在 DB2、Informix、Oracle 和 PostgreSQL 的地理数据库中。此数据类型可在地理数据库中使用，另外还可通过 SQL 访问第三方应用程序的简单要素类几何。ST_Geometry 执行空间的 OGC 和 ISO SQL 多媒体规范。

Oracle中安装了SDE后，能支持ST_Geometry函数。Oracle Spatial版本则有其自带的SDO_Geometry相关函数。这里，我们在PostgreSQL上安装了PostGIS，使其支持ST_Geometry函数。对于空间数据的描述，PG中支持标准的OpenGIS的两种空间数据组织格式：Well-Known Text (WKT) 和 Well-Known Binary (WKB) 。

PostGIS在线文档：http://postgis.net/docs/manual-1.4/

空间函数文档：http://postgis.net/docs/manual-1.4/ch04.html

## 5.具体实现

### 5.1读取所有格式SHP并入库

 ![img](https://images2015.cnblogs.com/blog/656746/201611/656746-20161124165504831-2109983212.png)

![img](https://images2015.cnblogs.com/blog/656746/201611/656746-20161124165513284-1924250822.png)

![img](https://images2015.cnblogs.com/blog/656746/201611/656746-20161124165521346-2078071879.png)

### 5.2读取SHP的DBF文件

 ![img](https://images2015.cnblogs.com/blog/656746/201611/656746-20161124165539503-423195585.png)