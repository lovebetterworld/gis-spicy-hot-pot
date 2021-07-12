- [使用OpenLayers显示地图](https://www.cnblogs.com/ssjxx98/p/12550830.html)

**前言**：在上一篇博客[JavaWeb和WebGIS学习笔记（四）——使用uDig美化地图，并叠加显示多个图层](https://blog.csdn.net/df1445/article/details/105010161)中，我们使用Layer Preview功能，通过GeoServer自带的OpenLayer预览到了我们发布的地图。预览时的url通常是很长一串字符。

这种方式虽然也能够进行访问，但预览的URL包含了大量请求参数，直接提供这样一个URL链接既不方便访问，也有碍观瞻。因此，我们何不自己使用OpenLayers在自己的网页中显示发布的地图呢。

> **[OpenLayers](https://openlayers.org/)** 是一个专为Web GIS 客户端开发提供的JavaScript 类库包，用于实现标准格式发布的地图数据访问。它 支持Open GIS  协会制定的WMS（Web Mapping Service）和WFS（Web Feature  Service）等网络服务规范。可以在浏览器中帮助开发者实现地图浏览的基本效果，比如放大（Zoom In）、缩小（Zoom  Out）、平移（Pan）等常用操作之外，还可以进行选取面、选取线、要素选择、图层叠加等不同的操作，甚至可以对已有的OpenLayers  操作和数据支持类型进行扩充，为其赋予更多的功能。

# 一、引入OpenLayers

OpenLayers的引入方法有三种。这里是官网[openlayers下载地址](https://openlayers.org/download/)的介绍

- 使用npm安装OpenLayers

  ```npm
  npm install ol
  ```

- 在网页中引入在线地址

  ```html
  <script src="https://cdn.jsdelivr.net/gh/openlayers/openlayers.github.io@master/en/v6.2.1/build/ol.js"></script>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/openlayers/openlayers.github.io@master/en/v6.2.1/css/ol.css">
  ```

- 将OpenLayers下载到本地，并引入

![2345截图20200322134344](https://s1.ax1x.com/2020/03/23/8TAFld.png)

# 二、使用OpenLayers显示地图

关于OpenLayers的使用，官方文档已经很详尽了，也有很多具体的例子。

可以先参考这个[openlayers quick start](https://openlayers.org/en/latest/doc/quickstart.html)做一个简单的入门。

具体使用到的内容可以参考[官方API文档](https://openlayers.org/en/latest/apidoc/)。

显示地图需要Layer Source WMS服务的URL，通过GeoServer中的**Layer Preview**可查看到预览时的URL

```
http://localhost:8080/geoserver/xjs/wms?service=WMS&version=1.1.0&request=GetMap&layers=xjs%3ABoundaryChn2_4p&bbox=73.44696044921875%2C6.318641185760498%2C135.08583068847656%2C53.557926177978516&width=768&height=588&srs=EPSG%3A4326&format=application/openlayers
```

不难看出，WMS服务的URL是：

```
http://localhost:8080/geoserver/工作区名称/wms
```

如果需要公网访问，则对应URL就是：

```
http://ip:port/geoserver/工作区名称/wms
```

其中ip是云服务器的公网ip，port是开放的端口，工作区名称即为你的数据源所在工作区。

这里给出显示地图的全部代码：

```html
<!doctype html>
<html lang="en">
  <head>
    <meta http-equiv="content-type" content="text/html" charset="UTF-8"/>
    <link rel="stylesheet" href="oldist/openlayers/ol.css" type="text/css">
    <style>
      #map {
        clear: both;
        position: relative;
        height: 800px;
        width: 100%;
      }
      #loaction{
          float:right;
      }
    </style>
    <script type="text/javascript" src="oldist/openlayers/ol.js"></script>
    <script type="text/javascript" src="http://apps.bdimg.com/libs/jquery/1.6.4/jquery.js"></script> 
    <title>olmap</title>
  </head>
  <body>
    <div id = mapbox>
        <h2 style="color:burlywood;text-align: center;">China Map</h2>
        <div id="map" class="map"></div>
    </div>
    <div id="wrapper">
        <div id="location"></div>
    </div>
    <script type="text/javascript">
      var envstr = '';
      var urlAdr = 'http://localhost:8080/geoserver/xjs/wms';  //根据自己的需要更改ip和port
      var layerName = 'xjs:BoundaryChn2_4p,xjs:BoundaryChn2_4l,xjs:BoundaryChn1_4l'; //改变图层名
      var tiled;
      var untiled;
      $(function(){
        //设置地图范围
        var extent = [73.44696044921875,6.318641185760498,135.08583068847656,53.557926177978516];
        var envstr = 'color'
        //图像图层
        untiled = new ol.layer.Image({
            visible:true,
            source: new ol.source.ImageWMS({
            ratio: 1,
            url: urlAdr,
            params: {
                    "LAYERS": layerName,
                    'TILED': false,
            		},
                serverType: 'geoserver'
            })
      	});
        //定义图层数组
        tiled = new ol.layer.Tile({
            visible:false,
            source: new ol.source.TileWMS({
            url: urlAdr,  //WMS服务URL
            params: {  //请求参数
                 	'LAYERS': layerName,
                    'TILED': true,
                     },
            serverType: 'geoserver'
            })
        });
        var maplayers = [untiled,tiled];
       //定义地图对象
       var map = new ol.Map({
                layers: maplayers,
                target: 'map',
                view: new ol.View({
                    projection: 'EPSG:4326',
                    //center: [115, 39],
                    //zoom: 5
                }),
                controls: ol.control.defaults({
                    attributionOptions: {
                        collapsible: true
                    }   
                })   
       })
       //自适应地图view
        map.getView().fit(extent, map.getSize());  
       //添加比例尺控件
        map.addControl(new ol.control.ScaleLine());
        //添加缩放滑动控件
        map.addControl(new ol.control.ZoomSlider());
        //添加全屏控件
        map.addControl(new ol.control.FullScreen());
        //添加鼠标定位控件
        map.addControl(new ol.control.MousePosition({
            undefinedHTML: 'outside',
            projection: 'EPSG:4326',
            target:$("#location")[0],
            coordinateFormat: function(coordinate) {
                return ol.coordinate.format(coordinate, '{x}, {y}', 4);
            }              
            })
        );
      })
    </script>
  </body>
</html>
```

![Snipaste_2020-03-23_10-01-57](https://s1.ax1x.com/2020/03/23/8TAk6A.png)

​    