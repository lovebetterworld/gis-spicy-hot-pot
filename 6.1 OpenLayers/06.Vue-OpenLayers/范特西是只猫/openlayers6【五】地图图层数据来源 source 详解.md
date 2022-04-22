- [openlayers6【五】地图图层数据来源 source 详解_范特西是只猫的博客-CSDN博客_openlayers 获取source](https://xiehao.blog.csdn.net/article/details/106361074)

## 1. 写在前面

在 [openlayers 6【二】vue 初始化map地图详解](https://blog.csdn.net/qq_36410795/article/details/105272407) 中，我们讲了初始化一个地图，必不可少的三要素。`target`，`view`，`layers`。在前面的两片文章中也讲了 `view` 和 `layers` 是什么。source 是 Layer 的重要组成部分。当然，layers图层里面也是有一个必不可少的属性，那就是 `source` 数据源，如果没有数据源你就不能渲染处地图的底图，也就没有任何含义 (这里的必不不是说是必须有，没有这属性也能显示)

## 2. source 数据源都有哪些类型

1. ol.source.BingMaps ，必应地图的切片数据，继承自ol.source.TileImage；
2. ol.source.Cluster，聚簇矢量数据，继承自ol.source.Vector；
3. ol.source.ImageCanvas，数据来源是一个 canvas 元素，其中的数据是图片，继承自 ol.source.Image；
4. ol.source.ImageMapGuide，Mapguide 服务器提供的图片地图数据，继承自 ol.source.Image，触发ol.source.ImageEvent；
5. ol.source.ImageStatic，提供单一的静态图片地图，继承自ol.source.Image；
6. ol.source.ImageVector，数据来源是一个 canvas 元素，但是其中的数据是矢量来源
7. ol.source.Vector，继承自 ol.source.ImageCanvas；
8. ol.source.ImageWMS，WMS 服务提供的单一的图片数据，继承自 ol.source.Image，触发
   ol.source.ImageEvent；
9. ol.source.MapQuest，MapQuest 提供的切片数据，继承自 ol.source.XYZ；
10. ol.source.OSM，OpenStreetMap 提供的切片数据，继承自 ol.source.XYZ；
11. ol.source.Stamen，Stamen 提供的地图切片数据，继承自 ol.source.XYZ；
12. ol.source.TileVector，被切分为网格的矢量数据，继承自 ol.source.Vector；
13. ol.source.TileDebug，并不从服务器获取数据，而是为切片渲染一个网格，继承自 ol.source.Tile；
14. ol.source.TileImage，提供切分成切片的图片数据，继承自 ol.source.Tile，触发
    ol.source.TileEvent；
15. ol.source.TileUTFGrid，TileJSON 格式 的 UTFGrid 交互数据，继承自 ol.source.Tile；
16. ol.source.TileJSON，TileJSON 格式的切片数据，继承自 ol.source.TileImage；
17. ol.source.TileArcGISRest，ArcGIS Rest 服务提供的切片数据，继承自 ol.source.TileImage；
18. ol.source.WMTS，WMTS 服务提供的切片数据。继承自 ol.source.TileImage；
19. ol.source.XYZ，XYZ 格式的切片数据，继承自 ol.source.TileImage；
20. ol.source.Zoomify，Zoomify 格式的切片数据，继承自 ol.source.TileImage。
21. ol.source.Image，提供单一图片数据的类型，直接继承自 ol.source.Source；
22. ol.source.Tile，提供被切分为网格切片的图片数据，继承自 ol.source.Source；
23. ol.source.Vector，提供矢量图层数据，继承自 ol.source.Source；

## 2. source 用法实例

> 可以看到，source 存在很多种，我们也不可能都去讲一遍，下面挑几个大家常用的 来写

### 2.1 ol.source.Vector 的使用（矢量图层的数据来源）

#### 2.1.1 基本事件(重要)

`addfeature`，当一个要素添加到 source 中触发；

`removefeature`，当要素移除时候发生；

`changefeature`，当要素变化时触发；

`clear`，当 source 的 clear 方法调用时候触发；

#### 2.1.2 接受的参数(重要)

```bash
/**
 * @typedef {{attributions: (Array.<ol.Attribution>|undefined),
 *     features: (Array.<ol.Feature>|undefined),
 *     format: (ol.format.Feature|undefined),
 *     loader: (ol.FeatureLoader|undefined),
 *     logo: (string|olx.LogoOptions|undefined),
 *     strategy: (ol.LoadingStrategy|undefined),
 *     url: (string|undefined),
 *     wrapX: (boolean|undefined)}}
 * @api
 */
```

- attribution，地图右下角的 logo 包含的内容；
- features，地理要素，从字符串读取的数据；
- format，url属性设置后，加载要素使用的数据格式，采用异步的 AJAX 加载；
- loader，加载要素使用的加载函数；
- logo，logo包含的内容；
- strategy，加载要素使用的策略，默认是 一次性加载所有要素；
- url，要素数据的地址；
- wrapX，是否在地图水平坐标轴上重复，默认是 true。

#### 2.1.3 实例

##### 2.1.3.1 features 方法实现

这里是一个中国地图的geoJson数据。格式也是GeoJSON字符串格式。那么我们可以用来初始化一个图层。（这里只是贴了核心的部分代码，完整的请看后面博客会写）

```bash
import areaGeo from "@/geoJson/china.json";

var vectorSource = new ol.source.Vector({
    features: (new ol.format.GeoJSON()).readFeatures(areaGeo )
});
var vectorLayer = new ol.layer.Vector({
    source: vectorSource,
    style: style
});
map.addLayer(vectorLayer);
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200605111813694.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)

##### 2.1.3.2 url + format 方法实现

```js
var vectorLayer = new ol.layer.Vector({
  source: new ol.source.Vector({
    url: '../geoJson/china.json',
    format: new ol.format.GeoJSON()
  })
});
```

这两种方法中都会指定数据来源格式， 矢量数据源支持的格式包含很多：`gml、EsriJSON、geojson、gpx、igc、kml、osmxml、ows、polyline、topojson、wfs、wkt、wms capabilities（兼容 wms 的格式）、 wms getfeatureinfo、 wmts capabilities、xlink、xsd`等格式。这些格式都有`readFeatures`、`readFeature`和`readGeometry`方法用于读取数据。

### 2.2 ol.source.Image的使用（提供单一的图片地图）

#### 2.2.1 基本事件

`imageloadstart`，图片地图开始加载触发的事件；

`imageloadend`，图片地图加载完毕触发的事件；

`imageloaderror`，图片地图加载出错时触发的事件。

#### 2.2.2 接受的参数

```vue
/**
	* @typedef {{attributions: (Array.<ol.Attribution>|undefined),
	* 	extent: (null|ol.Extent|undefined),
	*   logo: (string|olx.LogoOptions|undefined),
	*   projection: ol.proj.ProjectionLike,
	*   resolutions: (Array.<number>|undefined),
	*   state: (ol.source.State|undefined)}}
 */
```

resolutions，地图分辨率。其他的选项都与以上的一样。

## 3. 写在后面

上面只是简单的讲了两个案例，还要更多的没有说到，后面会补充一些。根据后面实际业务需求去写，大家更能理解

source 是 layer 中必须的选项，定义着地图数据的来源，与数据有关的函数，如addfeature、getfeature等函数都定义在 source 中，而且数据源支持多种格式。