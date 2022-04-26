- [适合中小公司搭建基于LBS的GIS应用框架(在线/离线)](https://blog.csdn.net/u011365716/article/details/89716659)

设计思想：

![img](https://img-blog.csdnimg.cn/20190430225432705.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTEzNjU3MTY=,size_16,color_FFFFFF,t_70)

 

 

地图引擎/地图底图设计（便于在线离线）：

**在线百度地图**

百度地图切片+百度地图开放平台WEBURL POI搜索、路径分析和正逆地理解析（服务器）+Tomact（中间件）+PostGIS|MySQL空间扩展（数据库）+Openlayers(JS)(浏览器客户端)。

**在线天地图：**

天地图切片+ 天地图搜索引擎、驾车引擎、逆地理解析（服务器）+Tomact（中间件）+PostGIS|MySQL空间扩展（数据库）+Openlayers(JS)(浏览器客户端)。

**在线高德地图：**

高德地图切片+高德地图开放平台WEBURL POI搜索、路径分析和正逆地理解析（服务器）+Tomact（中间件）+PostGIS|MySQL空间扩展（数据库）+Openlayers(JS)(浏览器客户端)。

**在线ArcGIS_Server**地图：

ArcGIS Server+百度地图开放平台WEBURL POI搜索、路径分析和正逆地理解析（服务器）（服务器）+ ArcGIS  Desktop（桌面软件）+Tomact（中间件）+PostGIS|MySQL空间扩展（数据库）+Openlayers(JS)+(浏览器客户端)。 

**在线**SuperMap_IServer地图：

SuperMap iServer+百度地图开放平台WEBURL  POI搜索、路径分析和正逆地理解析（服务器）+ SuperMap iDesktop（桌面软件）+Tomact（中间件）+PostGIS|MySQL空间扩展（数据库）+Openlayers(JS)(浏览器客户端)。

**离线**ArcGIS_Server类型切片地图：

GeoServer服务器+ArcGIS离散型/压缩型切片数据+下载POI数据+Pgrouting服务（服务端）+Tomact（中间件）+PostGIS|MySQL空间扩展（数据库）+Openlayers(JS)(浏览器客户端)。