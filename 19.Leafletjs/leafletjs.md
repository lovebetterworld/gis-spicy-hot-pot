官网地址：https://leafletjs.com/

# 什么是Leaflet.js 

   Leaflet.js是一个开源库，使用它我们可以部署简单，交互式，轻量级的Web地图。 

-    Leaflet JavaScript库允许您使用图层，WMS，标记，弹出窗口，矢量图层（折线，多边形，圆形等），图像叠加层和GeoJSON等图层。 
-   您可以通过拖动地图，缩放（通过双击或滚轮滚动），使用键盘，使用事件处理以及拖动标记来与Leaflet地图进行交互。 
-    Leaflet支持浏览器，如桌面上的Chrome，Firefox，Safari 5 +，Opera 12 +，IE 7-11，以及Safari，Android，Chrome，Firefox等手机浏览器。 



Leaflet 是一个为建设移动设备友好的互动地图，而开发的现代的、开源的 JavaScript 库。 它是由 Vladimir  Agafonkin 带领一个专业贡献者团队开发，代码量很小， 但具有开发人员开发在线地图的大部分功能。  Leaflet设计坚持简便、高性能和可用性好的思想，在所有主要桌面和移动平台能高效运作，  在现代浏览器上会利用HTML5和CSS3的优势，同时也支持旧的浏览器访问。  支持插件扩展，有一个友好、易于使用的API文档和一个简单的、可读的源代码。



# LeafletJS教程：

- [WIKI教程-LeafletJS教程](https://iowiki.com/leafletjs/leafletjs_index.html)



# 在网页上加载地图的步骤 

  按照以下步骤在您的网页上加载地图 -  

##   第1步:创建HTML页面 

  创建一个带有**head**和**body**标签的基本HTML页面，如下所示 - 

```html
<!DOCTYPE html>
<html>
   <head>
   </head>
   <body>
      ...........
   </body>
</html>
```

##   第2步:加载Leaflet CSS脚本 

  在示例中包含Leaflet CSS脚本 -  

```html
<head>
   <link rel = "stylesheet" href = "http://cdn.leafletjs.com/leaflet-0.7.3/leaflet.css" />
</head>
```

##   第3步:加载传单脚本 

  使用脚本标记加载或包含Leaflet API  -  

```html
<head>
   <script src = "http://cdn.leafletjs.com/leaflet-0.7.3/leaflet.js"></script>
</head>
```

##   第4步:创建容器 

  要保存地图，我们必须创建一个容器元素。  通常，

标签（通用容器）用于此目的。 

  创建容器元素并定义其尺寸 -  

```html
<div id = "sample" style = "width:900px; height:580px;"></div>
```

##   第5步:映射选项 

   Leaflet提供了多种选项，例如类型控制选项，交互选项，地图状态选项，动画选项等。通过设置这些值，我们可以根据需要自定义地图。 

  创建一个**mapOptions**对象（它就像文字一样创建）并设置选项中心和缩放的值，其中 

-    **center** - 作为此选项的值，您需要传递一个**LatLng**对象，指定我们想要使地图居中的位置。   （只需指定**[]**括号内的纬度和经度值） 
-    **zoom** - 作为此选项的值，您需要传递一个表示地图缩放级别的整数，如下所示。 

```js
var mapOptions = {
   center: [17.385044, 78.486671],
   zoom: 10
}
```

##   第6步:创建地图对象 

  使用Leaflet API的**Map**类，您可以在页面上创建地图。  您可以通过实例化Leaflet API的调用**Map**来创建地图对象。  在实例化此类时，您需要传递两个参数 -  

-   作为此选项的参数，您需要传递表示DOM id的String变量或

  元素的实例。 

   这里，

  元素是一个用于保存地图的HTML容器。 

-   带有地图选项的可选对象文字。 

  通过传递上一步中创建的

元素和mapOptions对象的id来创建Map对象。 

```js
var map = new L.map('map', mapOptions);
```

##   第7步:创建图层对象 

  您可以通过实例化**TileLayer**类来加载和显示各种类型的地图（切片图层）。  在实例化它时，您需要以String变量的形式传递一个URL模板，该模板从服务提供者处请求所需的tile层（map）。 

  创建切片图层对象，如下所示。 

```js
var layer = new L.TileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png');
```

  这里我们使用了**openstreetmap** 。 

##   第8步:向地图添加图层 

  最后使用**addlayer()**方法将上一步中创建的图层添加到地图对象，如下所示。 

```js
map.addLayer(layer);
```