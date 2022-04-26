- [OpenLayers - 入门 （一） - 掘金 (juejin.cn)](https://juejin.cn/post/6995037193114746894)

## 简介

在地图项目的开发中，有时候也需要不依赖于任何公司来开发项目。那么前端地图展示，图层控制就需要一个开源的框架来开发，我一下就相中了`OpenLayers`（其实是公司要求）。

## 什么是 OpenLayers

- 这里使用的是 **[OpenLayers v6.6.1](https://link.juejin.cn?target=https%3A%2F%2Fopenlayers.org%2Fdownload%2F)**

1. [`OpenLayers`](https://link.juejin.cn?target=https%3A%2F%2Fopenlayers.org%2F) 是一个开源的`JavaScript类库`，主要是用于开发`Web GIS`客户端。要想完整的开发一个地图项目，还需要后端提供地图瓦片的服务，如可以使用`geoserver`等。
2. 它可以轻松地在任何网页中放置动态地图。且能支持移动设备。
3. 它可以显示从任何来源加载的地图图块、矢量数据和标记。
4. 它易于定制和扩展，能通过简单的 CSS 设置地图控件的样式。使用[第三方库](https://link.juejin.cn?target=https%3A%2F%2Fopenlayers.org%2F3rd-party%2F)来自定义和扩展功能。

## 基础概念

一个新的框架，详细了解基础概念，有助于我们快速开发。

### Map

`OpenLayers`的核心组件是`map (ol/Map)`，`Map`就是地图。它被呈现到目标容器中（例如，`div`元素）。可以在构造时配置所有映射属性，也可以使用`setTarget()`来设置。`Layer`、`View`都是定义在`ol/Map`下。

### View

因为地图不对地图的中心、缩放级别和投影等内容负责。 所以这些功能都是有`View`来实现的。它的定义在`ol/View`下。
 `View`有一个`projection`(投影)。投影确定中心的坐标系和地图分辨率计算的单位，默认使用墨卡托投影`EPSG:3857`。
 [坐标系、投影、EPSG:4326、EPSG:3857](https://link.juejin.cn?target=https%3A%2F%2Fwww.pianshen.com%2Farticle%2F7987865406%2F)

### Source

`Source` 就是图层数据的来源，数据格式可以是 XYZ、WMS 或 WMTS 等 OGC 源以及 GeoJSON 或 KML 等格式的矢量数据。它的定义在`ol/source`下。

### Layer

`Layer`表示一个图层。在项目的开发中我们的操作都是在一个个图层上绘制，然后`OpenLayers`根据层级把图层一层层的绘制上去。 它定义在`ol/layer`下，有四种基本类型的层。

- `ol/layer/Tile` - 渲染在网格中提供平铺图像的源，这些网格按特定分辨率的缩放级别组织。栅格图层。
- `ol/layer/Image` - 渲染以任意范围和分辨率提供地图图像的源。栅格图层。
- `ol/layer/Vector` - 在客户端呈现矢量数据。矢量图层。
- `ol/layer/VectorTile` - 渲染作为矢量切片提供的数据。矢量图层。

### control

`control`表示控件，使用按钮来控制地图。 在`ol/control`下，定义了一些内置的控件。如全屏、旋转、缩放、小地图等。
 在内置控件不满足需求时也需要我们自定义控件。

### interaction

`interaction`交互事件，添加地图和用户的交互事件。
 [api 文档](https://link.juejin.cn?target=https%3A%2F%2Fopenlayers.org%2Fen%2Flatest%2Fapidoc%2Fmodule-ol_interaction.html)

## 开始使用

- 引入`OpenLayers`

```html
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/openlayers/openlayers.github.io@master/en/v6.6.1/css/ol.css" />
<script src="https://cdn.jsdelivr.net/gh/openlayers/openlayers.github.io@master/en/v6.6.1/build/ol.js"></script>
复制代码
```

- 设置元素

```html
<style>
  .map {
    height: 500px;
    width: 100%;
  }
</style>

<div id="map" class="map"></div>
```

- 创建地图

```js
var map = new ol.Map({
  target: 'map',
  layers: [
    new ol.layer.Tile({
      // 使用高度瓦片图
      source: new ol.source.XYZ({
            url: 'https://webrd01.is.autonavi.com/appmaptile?lang=zh_cn&size=1&scale=1&style=8&x={x}&y={y}&z={z}'
          })
    })
  ],
  view: new ol.View({
    center: ol.proj.fromLonLat([37.41, 8.82]),
    zoom: 4
  })
})
```

1. 通过`new ol.Map({ ... });`加载地图对象，通过`target`参数绑定元素节点。
2. 通过`layers`参数定义地图中可用的图层列表。后面图层覆盖前面的图层。
3. 通过`View`参数指定地图的中心、分辨率和旋转。

![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/85e07c27cfb94c059a98abf84f96a7a5~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

- `OpenLayers`开发可以简单的理解为，把整个地图看作一个容器 `Map`。把根据`Layer`规则生成的图层加入地图中。在这基础上使用 `View、Control、Interaction`控制地图。