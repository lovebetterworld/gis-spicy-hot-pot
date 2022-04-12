- [openlayers 6【四】地图图层Layers详解_范特西是只猫的博客-CSDN博客](https://xiehao.blog.csdn.net/article/details/105864505)

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200604173827267.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)

**①** 官方文档：https://[openlayers](https://so.csdn.net/so/search?q=openlayers&spm=1001.2101.3001.7020).org/en/latest/apidoc/module-ol_layer_Layer-Layer.html

**②** 图层的使用是占到了80%的。所以这篇是 **`非常重要的文章`**

**③** 在 openlayers 中，图层是使用 [layer](https://so.csdn.net/so/search?q=layer&spm=1001.2101.3001.7020) 对象表示的，主要有 `WebGLPoints Layer`、`热度图(HeatMap Layer)`、`图片图层(Image Layer)`、`切片图层(Tile Layer)`和 `矢量图层(Vector Layer)`五种类型，它们都是继承 Layer 类的。

**④** **openlayers 初始化一幅地图(map)，至少需要一个可视区域(view)，一个或多个图层( layer)， 和 一个地图加载的目标 HTML 标签(target)**，其中`最重要的是图层(layer)`

## 1. 什么是图层？？？

### 1.1 线状图层

其实可以根据 `“图层”` 的中文含义已经理解了很大部分，为了更深的便于大家对 Layers 的理解，可以看下下面这张图。其实 openlayers 简单的新建map只是相当于一张可以移动，缩放的图片。但是实际项目需求往往需要在地图上添加各种图层来丰富我们的地图。（下面是已百度地图应用为例）

**`线状地物：道路、河流、线路、运行轨迹`等应用（如下搜索的一段行车线路）**
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200605090310789.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)

### 1.2 点状图层

**`点状图层：建筑、店铺、学校、红绿灯等场景`等应用（如下搜索的是某个景点地名）**

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200605091014552.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)

### 1.3 面状图层

**`面状图层：诸如行政区域等有一定范围的地物`（如下是用openlayers描绘的粤港澳大湾区的行政区域）

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200605091333122.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)

好了，下面开始正式讲图层的`属性、事件、及有哪些图层类型`等。

## 2. 图层存在一个或者多个

```js
import "ol/ol.css";
import { Map, View } from "ol";
import { defaults as defaultControls } from "ol/control";
import Tile from "ol/layer/Tile";
import { fromLonLat } from "ol/proj";
import OSM from "ol/source/OSM";

// 初始化一个地图
initMap() {
    let target = "map"; //跟页面元素的 id 绑定来进行渲染
    let tileLayer = [
        new Tile({
            source: new OSM()
        })
    ];
    let view = new View({
        center: fromLonLat([104.912777, 34.730746]), //地图中心坐标
        zoom: 4.5 //缩放级别
    });
    this.map = new Map({
        target: target, //绑定dom元素进行渲染
        layers: tileLayer, //配置地图数据源
        view: view //配置地图显示的options配置（坐标系，中心点，缩放级别等）
    });
}
```

上面代码我们可以看到，`new Map()`里面的 `layers` 属性接收的`tileLayer`值是一个数组，也就是说可以在地图上叠加一个或者多个图层。好下面我们慢慢看下图层有哪些内容！！！

## 3. Layers 的常见属性

初始化时，所有图层类型都具有的参数，如下：(红色为常用的属性)

- `source`，指定了图层的数据来源，图层作用是以一定的样式渲染数据，source则指定了数据；
- `className`，图层各个元素的样式；
- `zIndex`，图层的叠加次序，默认是0，最底层，如果使用setMap方法添加的图层，zIndex值是Infinity，在最上层；
- `extent`，图层渲染的区域，即浏览器窗口中可见的地图区域。extent 是一个矩形范围，格式是[number, number, number, number] 分别代表 [left, bottom, right, top]为了提升渲染效率和加载速度，extent范围之外的瓦片是不会请求的，当然也不会渲染；
- opacity，不透明度（0，1），默认为 1 ，即完全透明； visible，是否可见；
- visible，布尔值 （默认为true） 能见度。
- render，渲染功能。将框架状态作为输入，并期望返回HTML元素。将覆盖该图层的默认渲染。
- map，地图。
- minResolution，图层可见的最小分辨率；
- maxResolution，图层可见的最大分辨率；
- minZoom，最小视图缩放级别（不包括），在该级别之上，该层将可见。
- maxZoom，该图层可见的最大视图缩放级别（包括该级别）。

> source是一个非常重要的参数，图层中渲染的数据来自于source参数指定的地址，可能是文件，可能是返回地理数据的网络API，不同的source对象类型不一样。
> zoom的边界情况也需要注意：是 (minZoom, maxZoom]，图层可见的zoom level大于minZoom，小于等于maxZoom。这与resolution的情况刚好相反[minResolution, maxResolution)。

## 4. Layers 各种图层及图层类型

> 从渲染发生的地方来看，openlayers的图层主要分为两类：`Vector（矢量）和Raster（栅格）`。

**矢量图层是指在渲染发生在浏览器的图层，source返回的数据类型是矢量，如geojson的坐标串；**

**栅格图层则是由服务器渲染，返回到浏览器的是一张张的瓦片图片，栅格图层主要是展示。**

**矢量图层类型有：**

-  **Graticule**，地图上覆盖的网格标尺图层
-  **HeatMap**，热力图
-  **Vector**，矢量图
-  **VectorImage**，单张的矢量图层
-  **VectorTile**，矢量瓦片图层
-  **WebGLPoints**，WebGL渲染的海量点图层

**栅格图层类型有：**

-  **栅格图层类型较为简单，只有Tile图层**

所有的图层都继承了 Layer 类，监听和触发的事件都在 ol.render.Event 中定义，共用的属性和状态都是在 layerbase 中定义的，它们除了从ol.layer.Layer 类继承而来的参数外，还定义了自己的属性和方法。下面我们来分别看看这几个图层类型。

注：不管使用什么图层类型，初始化 map 同时，如果不明确指定 control 对象，那么就会默认包含 缩放 和 鼠标拖拽 功能，关于这个 Control 对象，在后面的博客中会讲到，现在认为 Control 就是一个控制与地图交互的工具就好。

### 4.1 `Graticule` 地图上覆盖的网格标尺图层

> https://openlayers.org/en/latest/examples/graticule.html

在地图上渲染一层类似于经纬线的网格层，更有利于准确的确定区域，在WGS84坐标系下，以度，分，秒为单位，称之为“经纬网”，其网格是以经纬线来划分的。在OpenLayers6中，渲染网格的类是“`ol.Graticule`”。

```js
import Graticule from 'ol/layer/Graticule';

new Graticule({
  // the style to use for the lines, optional.
  strokeStyle: new Stroke({
    color: 'rgba(255,120,0,0.9)',
    width: 2,
    lineDash: [0.5, 4]
  }),
  showLabels: true,
  wrapX: false
})
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200605092838181.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)

### 4.2 `HeatMap`，[热力图](https://so.csdn.net/so/search?q=热力图&spm=1001.2101.3001.7020)层

> https://openlayers.org/en/latest/examples/heatmap-earthquakes.html

将矢量数据渲染成热度图的类，继承了 `ol.layer.Vector` 类，`ol.layer.Vector` 继承了`ol.layer.Layer` 类， 额外的参数是 `olx.layer.HeatmapOptions` ，其定义如下：

```js
import {Heatmap as HeatmapLayer, Tile as TileLayer} from 'ol/layer';
<input id="radius" type="range" min="1" max="50" step="1" value="5"/>
<input id="blur" type="range" min="1" max="50" step="1" value="15"/>
var blur = document.getElementById('blur');
var radius = document.getElementById('radius');

var vector = new HeatmapLayer({
  source: new VectorSource({
    url: 'data/kml/2012_Earthquakes_Mag5.kml',
    format: new KML({
      extractStyles: false
    })
  }),
  blur: parseInt(blur.value, 10),
  radius: parseInt(radius.value, 10),
  weight: function(feature) {
    var name = feature.get('name');
    var magnitude = parseFloat(name.substr(2));
    return magnitude - 5;
  }
});
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200605094514172.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)

### 4.3 `Vector`，矢量图层

> https://openlayers.org/en/latest/examples/hitdetect-[vector](https://so.csdn.net/so/search?q=vector&spm=1001.2101.3001.7020).html

矢量图层：矢量图层是用来渲染矢量数据的图层类型，在OpenLayers里，它是可以定制的，可以控制它的`透明度，颜色`，以及加载在上面的`要素形状`等。

常用于从数据库中请求数据，接受数据，并将接收的数据解析成图层上的信息。如将鼠标移动到巴西，相应的区域会以红色高亮显示出来，高亮便是矢量图层的行为。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200605094450343.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)

### 4.4 `Image Layer` 单张图片的矢量图层

继承了 `ol.layer.Image` 类，主要是指服务器端渲染的图像，可能是已经渲染好的图像，或者是每一次请求，都根据请求内容定制化地生成一幅图片，该图层类型支持任意的范围和分辨率。

```js
<script>
	var extent = [0, 0, 1024, 968];//表示图片的尺寸
	var projection = new ol.proj.Projection({
	    code: 'EPSG:3857',
	    extent: extent
	});
	var imageLayer = new ol.layer.Image({
	    source: new ol.source.ImageStatic({
	        url: 'image/home.png',
	        projection: projection,
	        imageExtent: extent
	    })
	});
	var map = new ol.Map({  //初始化map
	    target: 'map',
	    layers: [
	        imageLayer
	    ],
	    view: new ol.View({
	        projection: projection,
	        center: ol.extent.getCenter(extent),
	        zoom: 2
	    })
	});
</script>
```

首先需要传入 `url`参数，即图片地址，这里可以是网络图片的地址，或者是本地的文件地址；然后需要传入参考坐标系 `projection`，`code`是一个标识，可以是任何字符串，如果是EPSG：4326 或者是 EPSG：3857 ，那么就会使用这两个坐标系，如果不是，就使用默认的坐标系，`extent`是一个矩形范围，上面已经提到；imageLayer 的第三个参数是 `imageExtent`表示图片的尺寸，这里我们不能改变图片的原来的比例，图片只会根据原来的比例放大或缩小。

### 4.5 `VectorTile Layer`，矢量瓦片图层

切片地图是比较常用的图层类型，切片的概念，就是利用网格将一幅地图切成大小相等的小正方形，如图：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200605100133267.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)
这样就明白我们使用百度地图等地图时为什么网速慢时候，会一块一块的加载的原因了吧！对，因为是切片。当请求地图的时候，会请求视口（也就是浏览器可见的区域）可见的区域内包含的切片，其余的切片不会请求，这样就节省了网络带宽，而且一般这些切片都是预先切好的，且分为不同的缩放级别，根据不同的缩放级别分成不同的目录。如果将这些切片地图放到缓存中，那访问速度会更快。
继承了 `ol.layer.Layer`，额外的参数是 `ol.layer.TileOptions` ，其定义如下：

```vue
/**
 * @typedef {{brightness: (number|undefined),
 *     contrast: (number|undefined),
 *     hue: (number|undefined),
 *     opacity: (number|undefined),
 *     preload: (number|undefined),
 *     saturation: (number|undefined),
 *     source: (ol.source.Tile|undefined),
 *     visible: (boolean|undefined),
 *     extent: (ol.Extent|undefined),
 *     minResolution: (number|undefined),
 *     maxResolution: (number|undefined),
 *     useInterimTilesOnError: (boolean|undefined)}}
 * @api
 */
```

可以看出，多出了 preload 和 useInterimTilesOnError 两个参数，preload 是在还没有将相应分辨率的渲染出来的时候，将低分辨率的切片先放大到当前分辨率（可能会有模糊），填充到相应位置，默认是 0，现在也就明白了当网速慢时，为什么地图会先是模糊的，然后再变清晰了吧，就是这个过程！useInterimTilesOnError是指当加载切片发生错误时，是否用一个临时的切片代替，默认值是 true。

```bash
import Tile from "ol/layer/Tile";
import OSM from "ol/source/OSM";
12
// 初始化一个 openlayers 地图
initMap() {
    let target = "map"; //跟页面元素的 id 绑定来进行渲染
    let tileLayer = [
        new Tile({
            source: new OSM()
        })
    ];
    let view = new View({
        center: fromLonLat([104.912777, 34.730746]), //地图中心坐标
        zoom: 4.5 //缩放级别
    });
    this.map = new Map({
        target: target, //绑定dom元素进行渲染
        layers: tileLayer, //配置地图数据源
        view: view //配置地图显示的options配置（坐标系，中心点，缩放级别等）
    });
}
```

其中的 `ol.layer.Tile` 就是切片图层类型，来源是 `OSM`。

我们可以打开浏览器f12查看下，其实就是加载的，一块块的，按照一定规则编号规则的网格图片。有时放大地图我们会感觉地图底图格子部分加载慢，也是因为精度越细小，需要重新加载更精细的网格图片。所有我们会考虑缓存网格图片解决此问题。

![在这里插入图片描述](https://img-blog.csdnimg.cn/2020060510081795.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)

### 4.6 `WebGLPoints，WebGL` 渲染的海量点图层

> https://openlayers.org/en/latest/examples/[webgl](https://so.csdn.net/so/search?q=webgl&spm=1001.2101.3001.7020)-points-layer.html

`顾名思义，海量，海量，当数据量大的时候解决问题的办法之一`，先看下来着其他网站的摘要：

WebGLPoint Layer 是由 WebGL 作为渲染引擎的点图层，众所周知，WebGL在渲染大量数据（>10k）效率明显优于Canvas或SVG，所以对于有大数据量前端渲染需求的，WebGL作为渲染引擎几乎是唯一的选择。以前openlayers一直没有webgl作为渲染引擎的图层类型，虽然openlayer自从3.x重构以来就一直将支持三维作为目标，但是进展较慢，对比隔壁mapboxgl.js，进度差的不是一点。严格来说，openlayers和leaflet是一个时代的产品，mapboxgl.js很早支持三维，且是leaflet的作者写的“下一代”前端地图可视化库。

WebGLPoint Layer本质上是矢量图层，在浏览器端渲染，然而，问题是：如果数据量较大，从服务器传来浏览器将会耗费很长时间，虽然只需要传输一次，虽然渲染快，但是用户感受到的是一直在等待。如果传输需要2分钟，渲染只需10ms，用户感知到的仍然是等了2分钟渲染。所以以当前的网速来看，可能更适合内网应用。当然，如果5G时代来的足够快，也可能真火了。

那么有的同学会问，我在服务器端渲染不比webgl性能高，它不香吗？当然香，但是服务器与客户端是1对多的关系，每个客户端都需要服务器渲染，并发量高了，服务器垮不垮？又有小伙伴说了，切片不就是解决这个问题的吗？对，但现在需求往往是样式随时会变，缓存了切片，样式一变，又要重新切，意义不大。矢量切片出现不就是这个问题的证据么？

```js
import WebGLPointsLayer from 'ol/layer/WebGLPoints';
```

代码太多，具体 [点击此处](https://openlayers.org/en/latest/examples/webgl-points-layer.html) 查询详情

```js
function refreshLayer(newStyle) {
  var previousLayer = pointsLayer;
  pointsLayer = new WebGLPointsLayer({
    source: vectorSource,
    style: newStyle,
    disableHitDetection: true
  });
  map.addLayer(pointsLayer);

  if (previousLayer) {
    map.removeLayer(previousLayer);
    previousLayer.dispose();
  }
  literalStyle = newStyle;
}
```

图层中指定的数据源world-cities.geojson包含了19321个点要素，Style中指定的是根据每个点要素包含的人口数量属性决定要素的半径大小和要素展示的透明度。如果使用Canvas，性能会查差一些，虽然差的不多，但是随着数据量的继续变大，WebGL还是可以轻松应对，Canvas就到极限了。最终的渲染结果是这样的：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200605101541521.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)

## 5. Layers 事件触发

有的同学问：我想在图层加载完成时，做一些事情，如何知道图层加载完成呢？图层初始化时，我们可以指定很多hook，用以当某些事件触发时做出一定的动作，这些事件中有一个`postrender`，会在图层渲染完成后触发，我们可以对这个事件传入回调。类似的事件还有`prerender`。

包含的方法其实没有什么好说的，一般就是对属性的`getter`和`setter`，详细的列表可以参考 这里

## 6. 写在最后

图层大致可以按照渲染的位置分为两类，

1. 一类是在服务器端渲染好，以图片形式返回浏览器的， `imagelayer` 和 `tilelayer`都是属于这种类型
2. 一类是在浏览器渲染的图层类型，`vectorlayer` 和 `heatmaplayer`就是这种类型。

到此：初始化 map 的三要素 `view`，`layers`， `target`，已经写完了两个，还是 `target`。其实 `target` 就是与页面渲染的 map 的 div 做绑定，没有其他更多功能。后面就不单独写了。至此都讲完了。