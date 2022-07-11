- [OGC基础 · GeoTools使用文档 (gitee.io)](http://shengshifeiyang.gitee.io/geotools-learning/ogc/)

## 1 OGC简介

 OGC全称——开放地理空间信息联盟(Open Geospatial Consortium), 它的主要目的就是制定与空间信息、基于位置服务相关的标准。而这些所谓的标准其实就是一些接口或编码的技术文档，不同的厂商、各种GIS产品都可以对照这些文档来定义开放服务的接口、空间数据存储的编码、空间操作的方法。

 OGC目前提供的标准多达几十种，包括我们常用到的WMS、WFS、WCS、WMTS等等，还有一些地理数据信息的描述文档，比如KML、SFS(简单对象描述)、GML、SLD(地理数据符号化)等。

## 2 OpenGis简介

 OpenGIS(Open Geodata Interoperation Specification,OGIS-开放的地理数据互操作规范)由美国OGC(OpenGIS协会，Open Geospatial Consortium)提出。OGC是一个非盈利性组织，目的是促进采用新的技术和商业方式来提高地理信息处理的互操作性(Interoperability)，它致力于消除地理信息应用（如地理信息系统，遥感，土地信息系统，自动制图/设施管理(AM/FM)系统）之间以及地理应用与其它信息技术应用之间的藩篱，建立一个无“边界”的、分布的、基于构件的地理数据互操作环境。

 OpenGIS定义了一组基于数据的服务，而数据的基础是要素（Feature）。所谓要素简单地说就是一个独立的对象，在地图中可能表现为一个多边形建筑物，在数据库中即一个独立的条目。要素具有两个必要的组成部分，几何信息和属性信息。OpenGIS将几何信息分为点、边缘、面和几何集合四种：其中我们熟悉的线（Linestring）属于边缘的一个子类，而多边形（Polygon）是面的一个子类。也就是说OpenGIS定义的几何类型并不仅仅是我们常见的点、线、多边形三种，它提供了更复杂更详细的定义，增强了未来的可扩展性。另外，几何类型的设计中采用了组合模式（Composite），将几何集合（GeometryCollection）也 定义为一种几何类型，类似地，要素集合（FeatureCollection）也是一种要素。属性信息没有做太大的限制，可以在实际应用中结合具体的实现进行设置。 相同的几何类型、属性类型的组合成为要素类型（FeatureType），要素类型相同的要素可以被存放在一个数据源中。而一个数据源只能拥有一个要素类型。因此，可以用要素类型来描述一组属性相似的要素。在面向对象的模型中，完全可以把要素类型理解为一个类，而要素则是类的实例。 通过GIS中间件可以从数据源中取出数据，供WMS服务器和WFS服务器使用。

## 3 WMS服务简介

 WMS服务全称是Web Map Service （web地图服务），目前OGC提供的WMS最新版本为1.3.0，并提供了如下的操作接口：请求格式支持KVP和SOAP

1. GetCapabilities：获取服务中的要素及支持的操作

   ![img](http://shengshifeiyang.gitee.io/geotools-learning/assets/capabilities.jpg)

2. GetMap：获取地图数据

   ![img](http://shengshifeiyang.gitee.io/geotools-learning/assets/map.jpg)

3. GetFeatureInfo：获取getMap响应地图上某一点的特征数据信息

![img](http://shengshifeiyang.gitee.io/geotools-learning/assets/featureinfo.jpg)

## 4 wfs服务

WFS服务，全称是Web Feature Service (web 要素服务)，目前OGC提供的WFS最新版本为2.0.2，并且提供如下几种操作：

1. GetCapabilities： 获取服务中的要素及支持的操作

   ![wfs-captbilities](http://shengshifeiyang.gitee.io/geotools-learning/assets/wfs-captbilities.jpg)

2. DescribeFeatureType： 获取地理要素类型的GML应用模式描述文档

   ![wfs-featuretype](http://shengshifeiyang.gitee.io/geotools-learning/assets/wfs-featuretype.jpg)

3. GetFeature： 根据条件查询地理要素信息

![wfs-feature](http://shengshifeiyang.gitee.io/geotools-learning/assets/wfs-feature.jpg)

## 5 wcs服务简介

WCS服务，全称为Web Coverage Service（web栅格服务），目前OGC提供的WCS的最新版本为2.1，并提供了如下几种操作：

1. Getcapabilities: 获取服务中的要素及支持的操作

   ![wcs-capability](http://shengshifeiyang.gitee.io/geotools-learning/assets/wcs-capability.jpg)

2. DescribeCoverage: 返回标识覆盖范围的文档描述

   ![wcs-decriptioncoverage](http://shengshifeiyang.gitee.io/geotools-learning/assets/wcs-decriptioncoverage.jpg)

3. GetCoverage: 获取服务器上元数据与请求数据的覆盖数据

![wcs-coverage](http://shengshifeiyang.gitee.io/geotools-learning/assets/wcs-coverage.jpg)

## 6 wmts服务简介

WMTS服务，全称是Web Map Tile Service (web地图切片服务)，目前OGC提供的最新版本是1.0.0，WMTS是OGC首个支持restful风格的服务标准，提供了如下几种操作：

1. GetCapabilities：获取服务的元数据信息，请求格式支持KVP，SOAP和RESTFUL，其请求参数如下

   ![wmts-capabilityjpg](http://shengshifeiyang.gitee.io/geotools-learning/assets/wmts-capabilityjpg.jpg)

2. GetTile：获取服务的切片信息，GetTile：获取服务的切片信息

   ![wmts-title](http://shengshifeiyang.gitee.io/geotools-learning/assets/wmts-title.jpg)

3. GetFeatureInfo：获取点选的要素信息，GetFeatureInfo：获取点选的要素信息

![wmts-feature](http://shengshifeiyang.gitee.io/geotools-learning/assets/wmts-feature.jpg)