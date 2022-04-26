- [OpenLayers - Map详解 （二） - 掘金 (juejin.cn)](https://juejin.cn/post/6995343930988462087)

## [Map是什么](https://link.juejin.cn?target=https%3A%2F%2Fopenlayers.org%2Fen%2Flatest%2Fapidoc%2Fmodule-ol_Map-Map.html)

1. 是 `OpenLayers` 的核心组件。用于初始化地图对象。
2. 初始化地图(Map)，需要一个视图(`view`)、一个或多个图层( `layer`)，和一个地图加载的目标 `HTML` 标签(`target`)。

### 参数

- `controls` 添加到地图上的控件。默认加载 `ol/control` 下 `defaults`，默认控件组。
- `pixelRatio` 设备上物理像素与设备无关像素（下降）之间的比率。
- `interactions` 添加到地图的交互事件。默认加载 `ol/interaction` 下 `defaults`，默认交互组。
- `keyboardEventTarget` 监听键盘事件的元素。这决定了`KeyboardPan`和 `KeyboardZoom`互动的触发时间。例如，如果将此选项设置为 `document`键盘，则交互将始终触发。如果未指定此选项，则库在其上侦听键盘事件的元素是地图目标（即，用户为地图提供的div）。如果不是 `document`，则需要重点关注目标元素以发出关键事件，这要求目标元素具有`tabindex`属性。
- `layers` 图层。没定义图层，也会加载，显示空白图层。图层是按顺序加载的，想要在最上层需要放在最后面。
- `maxTilesLoading` 同时加载的最大瓦片数。默认16。
- `moveTolerance` 光标必须移动的最小距离（以像素为单位）才能被检测为地图移动事件，而不是单击。增大此值可以使单击地图更容易。
- `overlays` 覆盖物。默认情况下，不添加任何覆盖物。
- `target` 地图的容器，元素本身或`id`元素的 。必须指定，不指定无法加载地图。
- `view` 视图。需要在构造时或通过方法（`setView`）指定，否则不会加载图层。

### 使用

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Document</title>
  </head>
  <style type="text/css">
    .map {
      height: 500px;
      width: 100%;
    }
  </style>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/openlayers/openlayers.github.io@master/en/v6.6.1/css/ol.css" />
  <script src="https://cdn.jsdelivr.net/gh/openlayers/openlayers.github.io@master/en/v6.6.1/build/ol.js"></script>
  <body>
    <div id="map" class="map"></div>
  </body>
  <script>
    var map = new ol.Map({
      target: 'map'
    })

    // 图层
    var layerTile = new ol.layer.Tile({
      source: new ol.source.XYZ({
        url: 'https://webrd01.is.autonavi.com/appmaptile?lang=zh_cn&size=1&scale=1&style=8&x={x}&y={y}&z={z}'
      })
    })
    // 视图
    var view = new ol.View({
      center: ol.proj.fromLonLat([37.41, 8.82]),
      zoom: 4
    })
    map.setView(view)
    map.setLayerGroup(layerTile)
  </script>
</html>
```

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/cd898e61f61d40e1b3627a370479a197~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

- 视图、图层、控件这些都可以通过函数加入地图中，同样的也可以通过函数获取地图中的这些数据。

### Map的常见属性

- `layerGroup` 地图中图层的图层组。
- `size` DOM 中地图的大小（以像素为单位）。
- `target` 地图的容器。
- `view` 视图。
- `control` 控制地图的控件组。
- `interaction` 交互事件组。

### Map的常用方法

- `addControl(control)` 添加控件。
- `addInteraction(interaction)` 添加交互。
- `addLayer(layer)` 添加图层。
- `addOverlay(overlay)` 添加覆盖物。
- `dispatchEvent(event)` 调度事件并调用所有侦听此类型事件的侦听器。
- `on(type, listener)` 侦听某种类型的事件。
- `getOverlays()` 获取所有覆盖物。
- `removeOverlay(overlay)` 删除指定覆盖物

## 总结

1. 在`OpenLayers`开发中，`Map`代表地图实例。我们可以用它来管理图层的展示，是否添加控件加入地图中等。总之就是后续的图层开发都需要使用它来管理。