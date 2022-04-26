- [OpenLayers学习一：地图加载（以类为接口）_路人甲JIA的博客-CSDN博客](https://blog.csdn.net/u013719339/article/details/77898952)

我的html文件和JS文件分开的，且每一个大功能一个JS文件。

 一般我都使用[JQuery](https://so.csdn.net/so/search?q=JQuery&spm=1001.2101.3001.7020)的语句。

 OpenLayers的ol.css和ol.js我都是下载到本地的。

 一般地图需要设置三个属性：图层layers，存放的容器（div），视图。

 图层分为[矢量图](https://so.csdn.net/so/search?q=矢量图&spm=1001.2101.3001.7020)层Vector，瓦片图层Tile，图片图层Image等等，图层包含一个Source，向地图上添加的东西都要添加到Souce里。

 视图又有两个属性：地图中心center，地图缩放级别zoom。

HTML：

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>OpenLayers3Exercise1</title>
    <link rel="stylesheet" href="ol.css" type="text/css">
    <script src="ol.js"></script>
    <script src="http://code.jquery.com/jquery-3.2.1.min.js"></script>
</head>
<body>
    <div id="map" class="map"></div>
 
    <script type="text/javascript" src="CommonVariable.js"></script>
    <script type="text/javascript" src="SetMap.js"></script>
 
</body>
</html>
```

地图配置 SetMap.js

```javascript
var mapSettiings = $.extend({
    mapSouce: new ol.source.OSM(),
    mapCenter: [0, 0],
    mapZoom: 2
}, mapOptions);
 
var accessibleSource = mapSettiings.mapSouce;
var accessibleLayers = [
    new ol.layer.Tile({
        source: accessibleSource
    })
];
var accessibleView = new ol.View({
    center: mapSettiings.mapCenter,
    zoom: mapSettiings.mapZoom
});
var map = new ol.Map({
    layers: accessibleLayers,
    target: mapSettiings.mapTarget,  //调用CommonVariable.js中的变量
    view: accessibleView
});
```

地图设置 CommonVariable.js

```javascript
/** set map
 * para
 * var mapSettiings = $.extend({
        mapSouce: new ol.source.OSM(),
        mapCenter: [0, 0],
        mapZoom: 2
    }, mapOptions);
 **/
var mapOptions = {
    mapTarget: 'map'
}
```