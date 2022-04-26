- [openlayers6【十三】地图矢量图层 Vector 详解_范特西是只猫的博客-CSDN博客_openlayers vector](https://xiehao.blog.csdn.net/article/details/107037647)

## 1. 认识什么是矢量地图

在 GIS 中，地图一般分为两大类：栅格地图和矢量地图

`栅格地图`：它们有一个共同特征，就是它们都是由很多个像素组成，像素大小是一致的，行高和列宽是一致的，从这个角度看，一幅遥感影像就像栅格。我们可以把一幅[栅格图](https://so.csdn.net/so/search?q=栅格图&spm=1001.2101.3001.7020)像考虑为一个矩阵，矩阵中的任一元素对应于图像中的一个点，而相应的值对应于该点的灰度级，数字矩阵中的元素叫做像素。

`矢量地图`：[矢量图](https://so.csdn.net/so/search?q=矢量图&spm=1001.2101.3001.7020)使用直线和曲线来描述图形，这些图形的元素是一些点、线、矩形、多边形、圆和弧线等等，矢量地图放大和缩小不会失真。为了便于存储，传递，使用，矢量地图会按照一定的格式来表达，比如常见的GeoJSON，TopoJSON，GML，KML，ShapeFile等等。 除了最后一个ShapeFile，其他几个格式的矢量地图OpenLayers 都支持，使用起来也是非常的简单。

利用矢量地图可以实现非常多的功能，如 动态标绘、调用 WFS 服务、编辑要素、可点击的要素、动态加载要素 等等。

## 2. 矢量图层的构成

**构成一个矢量图层的包含一个数据（source）和一个样式（style）**，数据构成矢量图层的要素，样式规定要素显示的方式和外观。

一个初始化成功的矢量图层包含一个到多个要素（feature），每个要素由地理属性（geometry）和多个其他的属性，可能包含名称等。结构如下图：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200630111305774.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200630111124681.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)

## 3. 矢量图层的常用参数

在初始化矢量图层时，可以有很多选项配置矢量图层的行为和外观，常用的有：(红色的最常用的)

- brightness、contrast，图层亮度和对比度，都是一个数值；
- renderOrder，一个指定规则的函数 (function(ol.Feature, ol.Feature))；
- hue，色调，是一个数值；
- minResolution，可见的最小分辨率；
- maxResolution，可见的最大分辨率；
- `opacity`，图层的透明度，0～1之间的数值，1表示不透明；
- saturation，饱和度；
- `source`，图层数据来源；
- `style`，图层样式，一个ol.style.Style或者一个ol.style.Style数组，或者一个返回 ol.style.Style 的函数；
- visible，图层可见性，默认为 true。

## 4. 初始化一个矢量图层

### **4.1 初始化一个矢量图层**

```csharp
var vector = new ol.layer.Vector({
  source: new ol.source.Vector({
    url: 'data/china.geojson',
    projection: 'EPSG:3857',
    format: new ol.format.GeoJSON({
        extractStyles: false
    })
  }),
  style: style
});
```

> 例中的 source url 设置了数据的来源，projection 设置了地理坐标系，format 设置 数据的解析器，因为 url 规定的数据来源是 geojson 格式，所以解析器也是 geojson 解析器 new ol.format.GeoJSON。

### **4.2 取得要素**

那么，在一个矢量图层中怎么取得它的某个 feature 呢，一般的想法是 [vector](https://so.csdn.net/so/search?q=vector&spm=1001.2101.3001.7020).getFeature()，其实不是的，vector 的数据包含在 source 中，要取得 vector 的 feature 数据，要在 source 中，例如 `vector.getSource().getFeatures()`，该函数会返回一个 feature array，直接使用 [ ]，取用即可，或者根据要素的 ID 取得`getFeatureById()`。

同样的，只要数据相关的操作，都要得到 vector 的 source 实例，然后进行操作，例如 添加要素`addFeature`、删除要素`removeFeature`，对每个要素进行相同的操作`forEachFeature`。

### **4.3 取得要素的 geometry**

利用 getGeometry() 可以获得要素的地理属性，这个函数当然返回要素包含的 geometry，geometry 包含很多类型，主要有 point、multi point、linear ring、line string、multi line string、polygon、multi polygon、circle。

取得 geometry 后，就可以获得要素的坐标了，可以根据坐标做一些地理判断，比如判断 一个坐标是否位于要素内（containsCoordinate(coordinate) 或者 containsXY(x, y)），取得要素的中心坐标等。

## 5. 总结

使用矢量图层，可以实现很多功能，比如动态加载矢量数据、调用 WFS 服务、动态标绘、编辑要素，分别是在图层级别和要素级别进行的操作。 

例如可以实现，在矢量图层上绘制不同的图形，并添加属性，然后更新至数据库，即动态标绘系统；或者动态加载要素级数据，比如跟踪汽车的轨迹。