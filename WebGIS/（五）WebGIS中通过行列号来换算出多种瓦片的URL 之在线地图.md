- [（五）WebGIS中通过行列号来换算出多种瓦片的URL 之在线地图](https://www.cnblogs.com/naaoveGIS/p/3905523.html)

## 1.前言

这篇文章里，我主要针对OGC标准中的WMS、WMTS以及ArcGIS的在线地图服务来进行解析。

写之前，我先来给大家提一下OGC是什么。OGC的全名是Open GIS  Consortium，中文名是开放地理空间信息联盟，它是一个是非盈利、志愿的国际标准化组织。在空间数据互操作领域，基于公共接口访问模式的互操作方法是一种基本的操作方法。通过国际标准化组织（ISO/TC211）或技术联盟（如OGC）制定空间数据互操作的接口规范，GIS软件商开发遵循这一接口规范的空间数据的读写函数，从而可以实现异构空间数据库的互操作（来自百度百科）。

目前OGC制定的标准有：WMS（地图服务）、WMTS(地图瓦片服务)、WFS(要素服务)、WCS(栅格服务)。在下面我介绍的地图请求方式皆是RESTFUL下的请求方式。

## 2.WMS服务的URL

WMS服务可以提供以下几种服务：

GetCapabilities返回服务级元数据。

 ![img](https://images0.cnblogs.com/i/656746/201408/112002251234101.png)

GetMap返回一个地图影像。

 ![img](https://images0.cnblogs.com/i/656746/201408/112002344204208.png)

GetFeatureinfo返回显示在地图上的某些特殊要素的信息等。

 ![img](https://images0.cnblogs.com/i/656746/201408/112002459835972.png)

### 2.1例子

我们来看一下WMS服务请求地图时的URL例子：http://172.18.0.154:7001/ServiceRight/proxy/f446aabb04a59af336901290d615e16b/xzcg/WMS/XZ500DLG_BZWGS84?LAYERS=XZ500DLG_BZWGS84&FORMAT=image/gif&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&STYLES=&SRS=EPSG:4326

&WIDTH=256&HEIGHT=256&bbox=117.21879147492814,34.240704396544345,117.22000975886715,34.24192268048341。

 ![img](https://images0.cnblogs.com/i/656746/201408/112003025774841.png)

 ![img](https://images0.cnblogs.com/i/656746/201408/112003165301238.png)

观察这个URL，很多参数在实际运用中可以根据提供的服务而固定，比如FORMAT、LAYERS、REQUEST、SRS、STYLES、VERSION、WIDTH、HEIHT参数。而真正需要我们实际上去不停换算的便是BBOX了。

### 2.2原理

WMS请求是一种可以动态出图的请求，原则上它可以显示原始图像在任意比例尺下的地图，它不像瓦片服务，只能显示切图时所设定好的比例尺下的的地图。在我们使用二次开发包时，比如用esri提供的开发包时，其中只需要我们设置需要显示的级别数，而不需要我们设置每个级别所对应的比例尺，便是因为WMS是一个动态出图服务。在二次开发中，直接使用提供的WMS类是非常简单的，只需要提供显示的范围和需要显示的级别数即可，此类的内部会自动的划分每一个级别的比例尺，而WMS是动态出图的，所以完全可以支持这种方式。

### 2.3 注意

但是，实际中，有的服务商提供的WMS服务却并不是这样的，他们很有可能会在某个比例尺很小的地方做出限制，让我们只能以某几个固定的比例尺去访问得到瓦片，其他比例尺均不可以。之前替其他组同事处理过的一个利用基于FlexViewer框架下的WMS类加载地图时，在特定的某几个级别上不显示地图，便是这个原因了。而解决这个问题的方法是重新扩展这个类，使扩展的WMSEX类能够通过设定好的每个级别的比例尺来换算出对应的Bbox，这里我们之前得到的行列号的算法就终于有用途了。

minX=resolution*tileSize*col;

minY=resolution*tileSize*row;

maxX=resolution*tileSize*(col+1);

maxY=resolution*tileSize*(row +1);

Bbox=“minX,minY,maxX,maxY”；

## 3.WMTS服务

WMTS服务的全称是Web Map Tile Service，故名思议，不同于之前的WMS的动态出图，WMTS服务是基于瓦片思想的。WMTS一样支持提供一定的标准服务，比如：

GetCapabilities（获取服务的元信息，在这个元信息中我们可以看到切图的详细配置）。

 ![img](https://images0.cnblogs.com/i/656746/201408/112003316705564.png)

GetTile（获取切片）。

GetFeatureInfo（可选，获取点选的要素信息）。

可以看到这些操作和WMS的操作非常的相同。

### 3.1例子

我们再来看一下WMTS下请求地图瓦片的URL例子，这里我以天地图中的URL为范例：http://srv.zjditu.cn/ZJEMAP_2D/wmts?SERVICE=WMTS&VERSION=1.0.0&REQUEST=GetTile&LAYER=ZJEMAP&FORMAT=image/png&TILEMATRIXSET=TileMatrixSet0&TILEMATRIX=17&STYLE=default&TILEROW=21747&TILECOL=109282。

 ![img](https://images0.cnblogs.com/i/656746/201408/112003431555072.jpg)

 ![img](https://images0.cnblogs.com/i/656746/201408/112003552644639.jpg)

观察这个URL所包含的参数，在获取瓦片前我们是可以将FORMAT、LAYER、REQUEST、SERVICE、STYLE、VERSION根据需求而写定的，在不断变化的是TILEMATRIX、TILEROW、TILECOL。

### 3.2原理

WMTS服务和我们之前反复讨论的瓦片思想是符合的，观察参数也能看出，TILEMATRIX、TILEROW、TILECOL其实就是Level、row、col。于是WMTS服务下的瓦片请求的URL也变顺理成章的可以拼出来了：固定格式URL+“&TILEMATRIX=”+level+“&TILEROW=”+row+“&TILECOL=”+col。

## 4.常见地图服务器发布的地图中的URL——以AGS服务为例

AGS中，在对发布的服务进行了切图后，地图的请求URL成了一种固定的格式。如：http://172.29.0.74:8399/arcgis/rest/services/HFTile/MapServer/tile/2/957/834。

 ![img](https://images0.cnblogs.com/i/656746/201408/112004106557806.png)

 显而易见，在tile后的便是Level、row、col。所以AGS下的URL写法便是：restMapService地址/Level/row/col。

## 5.提几个问题

问题一：

一个地图需要前几个级别地图是来源于A服务，它的服务地址是AURL。中间几个级别地图来源于B服务，它的服务地址是BURL，后面几个别地图是来源于C服务，它的服务地址是CURL。这个时候我们该如何让系统可以在每个级别正常的出图呢？

问题二：

一个地图需要同时显示地形图和注记图层，且地形图服务来源于A服务，注记图层来源于B服务。如何能正常的加载两个服务，并且让注记图层正常的叠加在地形图上呢？

问题三：

还是一个地图需要同时显示地形图和注记图层，但是此时地形图服务是WMTS服务，而注记图层是WMS服务。如何将两种不同服务的瓦片获取后叠加呢？

问题我就只提这三个吧，这种类似的问题特别特别多，但是我想只要我们知道了各种服务的URL获得原理，再加上一点点自己解决问题的思路，应该都不难解决的。在以后的栅格图层（瓦片图层）设计的章节里，我会给出一个我们解决此类问题的方法，该方法能很通用的解决这一系列问题。

## 6.总结

讲到这里时，整个系列中，我们已经讲了行列号是什么、如何获取行列号、通过行列号得到瓦片URL。可以说我们现在距离如何在前端显示出栅格图像，是万事俱备只欠东风了。那么下一章节里，我将给大家借来这个东风。下一节内容是：瓦片在前端拼接显示的原理。