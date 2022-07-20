- [OSM地图本地发布(一)-----概述_DXnima的博客-CSDN博客](https://blog.csdn.net/qq_40953393/article/details/120601986)

# 一、前言

​    随着互联网技术不断发展，WebGIS领域也有了更好的发展前景；一直想弄清楚在线地图如何发布，实现类似百度地图、高德地图的在线地图服务；由于国内一直以来有这样大型地图服务公司提供地图服务，再者有Esri、SuperMap这样大型GIS公司他们有成熟的技术和解决方案，很少有人去折腾用开源技术如何发布自己的地图服务，提供定制化的地图；网上能找到的资源或教程零零散散没有一个完整的技术路线和解决方案，现从GIS五大功能**数据采集与输入、空间数据管理、地图提取、地图制图、数据输出**一步一步实现[OSM](https://www.openstreetmap.org/)地图本地发布。

​    在探索过程中，《[WebGIS开发学习路线](http://xn--webgis-n67in58ae9qnpik84g9cub/)》、[GIS兵器库](https://blog.csdn.net/gisarmory)的文章《[我的开源GIS解决方案之路](https://blog.csdn.net/gisarmory/article/details/115340206)》对开源技术选取有所帮助；[think8848](https://home.cnblogs.com/u/think8848/)的系列文章《[Geoserver发布OSM地图](https://www.cnblogs.com/think8848/p/6013939.html)》、 [GIS兵器库](https://blog.csdn.net/gisarmory)的文章《[如何实现OSM地图本地发布并自定义配图](https://blog.csdn.net/gisarmory/article/details/110931322)》对地图服务发布流程有所了解；[不睡觉的怪叔叔](https://www.zhihu.com/people/li-yang-qiao-89)提供了关于WebGIS相关技术的《[文章汇总](https://zhuanlan.zhihu.com/p/67232451)》。

# 二、开源GIS介绍

​    当前商业GIS软件的使用和维护费用越来越高，例如包含客户端与服务器端一整套的ESRI ArcGIS软件售价约为70万元人民币。而且其销售策略是，若购买了服务器端软件则必须购买客户端软件，其理由是用户既然使用了其服务器端软件来发布服务，那必然就需要使用其客户端软件来处理数据。这对一些比较小的WebGIS应用来说，远远超出了其可承受的范围。并且众多商业软件GIS的数据和操作并非完全能够转换和共享，造成一些信息孤岛。

​    不过在商业GIS软件的对面活跃着开源GIS。OGC成立于1994年，致力于研究和建立开放地理数据交互操作标准，使用户和开发者能进行互操作。国际地理空间开发基金会（Open Source Geospatial Foundation)成立于2006年2月，其使命是支持开源地理信息软件和遥感软件的开发及推动其更广泛的应用，并对其支持的项目提供组织、法律和财政上的帮助，促进OSGeo基金会基于地理信息开发标准软件及其互操作技术的开发、推广和普及。OSGeo中国中心于2006年9月成立，帮助中国地区的用户和开发者更好地使用OSGeo基金会提供的源代码、产品和服务。

## 1.前端GIS框架

**Openlayers**：一个前端UI库，用于使用javascript创建基于Web的空间应用程序。 它支持各种图层源和后端。 例如，可以从GoogleMaps或自定义磁贴源中提取地图图块。这带来的优势在于它使开发人员能够重用诸如tile源之类的元素，而是将注意力集中在其应用程序的更独特方面，例如“业务逻辑”。平铺源等默认组件可以在以后轻松换出。 它支持位图和矢量图层，包括点，线和多边形。 其最广泛使用的功能之一是能够在基本地图上叠加数据层。推荐的第三方库：[ol-ext](https://viglino.github.io/ol-ext/)是对 Openlayers 的功能扩展，很全面；包括编辑相关的打断、移动、撤销要素等。

官方网站：[http://openlayers.org](http://openlayers.org/)

**Leaflet**：一个Javascript库，强调前端UI。 它支持多种基础层和几何类型的组合。 它覆盖了与OpenLayers有些相似的领域，但功能略有减少。 相对于OpenLayers而言，它的优势在于其对移动设备的出色支持，卓越的产品价值，简洁的简约设计以及对性能的强烈关注。一个小而轻量级的 WebGIS 框架，主要移动端项目比较多；强大的插件扩展，让这个框架功能更丰富；麻雀虽小，但五脏俱全。

官方网站：http://leafletjs.com/

**Mapbox GL**：这个框架是近年来比较火的一个 WebGIS 框架；它是一个 JavaScript 库，使用 WebGL 技术和 Mapbox 样式渲染交互式地图，在渲染速度上比**Openlayers**和**Leaflet**要好。它是 Mapbox生态系统的一部分；其中包括 Mapbox Mobile，它是用 C ++ 编写的兼容渲染器，具有针对台式机和移动平台的绑定。Mapbox 2.0版本后，必须使用官网申请的token使用，它会记录你的使用次数，超过次数要进行收费。

官方网站：https://www.mapbox.com/

**Cesium**：一个用于显示三维地球和地图的开源js库。它可以用来显示海量三维模型数据、影像数据、地形高程数据、矢量数据等等。三维模型格式支持gltf、三维瓦片模型格式支持3d tiles。矢量数据支持geojson、topojson格式。影像数据支持wmts等。高程支持STK格式。

官方网站：https://www.cesium.com/

## 2.后端技术

**GeoTools**：一个开源的 Java GIS 工具包，可利用它来开发符合标准的地理信息系统。GeoTools 提供了 OGC(Open Geospatial Consortium)规范的一个实现来作为他们的开发。GeoTools 被许多项目使用，包括 Web 服务，命令行工具和桌面应用程序。目前的大部分基于Java的开源GIS软件，如udig，geoserver等都是调用GeoTools库来进行空间数据的处理。

官方网站：https://geotools.org/

## 3.空间数据库

**PostGIS**：PostgreSQL数据库的扩展，它支持空间查询。PostgreSQL既是关系数据库又是对象数据库，被广泛认为是最先进的开源数据库，与Oracle和MS-SQL 类似。 PostGIS支持各种空间查询，包括邻近度，半径，边界框，碰撞/重叠检测等。 它是Web GIS项目中经常使用的非常有用的工具。

官方网站：[PostGIS — Spatial and Geographic Objects for PostgreSQL](http://postgis.net/)

## 4.地图服务器

**GeoServer**：OpenGIS Web 服务器规范的 J2EE 实现，利用 GeoServer 可以方便的发布地图数据，允许用户对特征数据进行更新、删除、插入操作，通过 GeoServer 可以比较容易的在用户之间迅速共享空间地理信息。兼容 WMS 和 WFS 特性；支持 PostgreSQL、 Shapefile 、 ArcSDE 、 Oracle 、 [VPF](https://baike.baidu.com/item/VPF) 、 MySQL 、 MapInfo ；支持上百种投影；能够将网络地图输出为 jpeg 、 gif 、 png 、 SVG 、 KML 等格式；能够运行在任何基于 J2EE/Servlet 容器之上；嵌入 MapBuilder 支持 AJAX 的地图客户端OpenLayers；除此之外还包括许多其他的特性。

官方网站：http://geoserver.org/

**MapServer**：由[美国明尼苏达大学](https://baike.baidu.com/item/美国明尼苏达大学/18547774)和[美国太空总署](https://baike.baidu.com/item/美国太空总署/2750291)(NASA)开发的一个开源的WebGIS软件。MapServer作为WebGIS解决方案，它是面向对象的，基本配置文件MapFile和MapScript模块的API组织都是基于对象的。MapServer通过支持OGC协会的若干标准，支持分布和互操作。MapServer是基于胖服务器/瘦客户端模式开发的webgiS平台，读取地理数据，并利用[GD库](https://baike.baidu.com/item/GD库/4565892)绘制好jpg/png/gif格式的图片后再传回客户端浏览器。MapServer支持在[Windows](https://baike.baidu.com/item/Windows/165458)、[UNIX](https://baike.baidu.com/item/UNIX/219943)、[Linux](https://baike.baidu.com/item/Linux/27050)等多种平台。MapServer支持OGC的WMS/WFS服务规范。MapsServer本身是由C语言编写的程序，提供了两种开发模式，一种是基于CGI的，另一种是MapScript方式。MapScript支持的语言：PHP，[Perl](https://baike.baidu.com/item/Perl/851577)，[Python](https://baike.baidu.com/item/Python/407313)，[java](https://baike.baidu.com/item/java/85979)，[Tcl](https://baike.baidu.com/item/Tcl/5779974)，[C#](https://baike.baidu.com/item/C%23/195147)等。MapServer可以看作是两个独立模块的统称：MapServer CGI模块和MapScript模块。在服务器端可以使用任一模块，编写WebGIS程序。功能上MapServer弱于GeoServer，效率上Mapserver对WMS的支持更为高效，而Geoserver则更擅长于结合WFS规范的属性查询。

官方网站：https://mapserver.org/

## 4.GIS软件

**QGIS**：一个用户界面友好的**开源**桌面端软件，支持数据的可视化、管理、编辑、分析以及印刷地图的制作，并支持多种矢量、栅格与数据库格式及功能。可运行在Linux、Unix、Mac OSX和Windows等平台之上。QGIS是基于跨平台的图形工具Qt软件包、使用C++开发的跨平台开源版桌面地理信息系统。目标是成为一个使用简单的GIS，提供了常见的功能。QGIS是开源GIS的集大成者，整合了GRASS、SAGA GIS等多个开源桌面软件工具。

官方网站：https://www.qgis.org/en/site/

**udig**：一个开源的桌面引用程序框架，构建在Eclipse RCP和GeoTools（一个开源的Java GIS工具包）上的桌面GIS；是一款开源桌面GIS软件，基于Java和Eclipse平台，可以进行shp格式地图文件的编辑和查看；是一个开源空间数据查看器/编辑器，对OpenGIS标准，关于互联网GIS、网络地图服务器和网络功能服务器有特别的加强。uDig提供一个一般的java平台来用开源组件建设空间应用。操作没QGIS友好，数据量大了容易崩溃，但生成的样式是GeoServer支持的SLD格式。

官方网站：http://udig.refractions.net/

**SLDEditor**：编辑地图样式的 Java 桌面应用程序，允许使用图形用户界面以交互方式创建和编辑[OGC 样式层描述符](http://www.opengeospatial.org/standards/sld)。该项目的目的是开发一个应用程序，使SLD文件的生成，其中用户可以完全控制OGC SLD标准的所有方面。

官方网站：https://github.com/sldeditor/sldeditor

**Maputnik**：Mapbox样式规范的开源可视化编辑器，它和Mapbox的mapbox studio、百度地图的个性化地图编辑器、高德地图的自定义地图编辑器是类似的东西，都是用来编辑矢量瓦片地图样式，属于在线地图制图工具。相关文章《[让maputnik支持geoserver](https://blog.csdn.net/gisarmory/article/details/116401076)》。

官方网站：https://github.com/maputnik

# 三、技术选型

   基于OSM本地地图发布，我使用的技术组合方案：Openlayers + GeoServer + PostGIS。

### **数据采集与输入、空间数据管理、地图提取**

   在[Geofabrik Download Server](http://download.geofabrik.de/asia.html)中下载OSM数据，使用[osm2pgsql](https://osm2pgsql.org/doc/)工具导入PostGIS数据库。

![img](https://img-blog.csdnimg.cn/2021100413070981.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFjnjovlpq7lmJvmiZPlpaXnibnmm7w=,size_15,color_FFFFFF,t_70,g_se,x_16)

### **地图制图**

   使用[udig](http://udig.refractions.net/)、[SLDEditor](https://github.com/sldeditor/sldeditor)、[maputnik](https://github.com/maputnik)工具调节样式生成SLD文件，导入Geoserver。

![img](https://img-blog.csdnimg.cn/20211004132624950.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFjnjovlpq7lmJvmiZPlpaXnibnmm7w=,size_13,color_FFFFFF,t_70,g_se,x_16)

### **数据输出**

  使用Openlayers加载Geoserver发布的地图服务。

![img](https://img-blog.csdnimg.cn/20211004131158629.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFjnjovlpq7lmJvmiZPlpaXnibnmm7w=,size_12,color_FFFFFF,t_70,g_se,x_16)

###  OSM地图发布流程图

![img](https://img-blog.csdnimg.cn/20211004132706660.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFjnjovlpq7lmJvmiZPlpaXnibnmm7w=,size_19,color_FFFFFF,t_70,g_se,x_16)

# 四、文章目录

## 1.[OSM本地发布(一)-----概述](https://blog.csdn.net/qq_40953393/article/details/120601986)

## 2.[OSM本地发布(二)-----数据准备](https://blog.csdn.net/qq_40953393/article/details/120604270)

## 3.[OSM本地发布(三)-----自定义图层提取](https://blog.csdn.net/qq_40953393/article/details/120605543)

## 4.[OSM本地发布(四)-----Geoserver发布自定义地图](https://blog.csdn.net/qq_40953393/article/details/120608112)

## 5.[OSM本地发布(五)-----Geoserver发布海洋图层](https://blog.csdn.net/qq_40953393/article/details/120609056)