- [OpenLayers - View详解 （三） - 掘金 (juejin.cn)](https://juejin.cn/post/6995718860229836807)

## [View是什么](https://link.juejin.cn?target=https%3A%2F%2Fopenlayers.org%2Fen%2Flatest%2Fapidoc%2Fmodule-ol_View-View.html)

1. 表示地图的简单 2D 视图。简单理解就是用来控制地图在容器中移动，方法的。
2. 主要用于更改地图的中心、分辨率和旋转的对象。
3. 视图具有`projection`。投影决定了中心的坐标系，其单位决定了分辨率的单位（每像素的投影单位）。默认投影是球面墨卡托 (EPSG:3857)。
4. 需要注意的是，在构造函数中添加了约束后，在使用方法设置或者获取数据都是在约束内的。

### 常用参数

- `center` 视图的初始中心。
- `constrainRotation` 旋转约束。 `false`意味着没有约束。`true`意味着没有约束，但在零附近捕捉到零。数字将旋转限制为该数量的值，就是设置90只能旋转90度。
- `enableRotation` 是否启用旋转。
- `extent` 限制视图的范围。值表示范围的数字数组：`[minx, miny, maxx, maxy]`。
- `constrainOnlyCenter` 如果为`true`，则范围约束将仅适用于视图中心而不是整个范围。
- `smoothExtentConstraint` 如果为`true`，范围约束将被平滑地应用，即允许视图稍微超出给定的`extent`。
- `maxResolution` 用于确定分辨率约束的最大分辨率。
- `minResolution` 用于确定分辨率约束的最小分辨率。
- `maxZoom` 用于确定分辨率约束的最大缩放级别。
- `minZoom` 用于确定分辨率约束的最小缩放级别。
- `constrainResolution` 如果为 `true`，则视图将始终在交互后以最接近的缩放级别进行动画处理；`false` 表示允许中间缩放级别。
- `resolutions`决定缩放级别的分辨率。
- `zoom` 仅在`resolution`未定义时使用。缩放级别用于计算视图的初始分辨率。
- `rotation` 以弧度为单位的视图初始旋转（顺时针旋转，0 表示北）。

### View常见的方法

- `getCenter` 获取视图中心，返回一个地图中心的坐标。
- `getZoom` 获取当前的缩放级别。如果视图不限制分辨率，或者正在进行交互或动画，则此方法可能返回非整数缩放级别。
- `getMaxZoom` 获取视图的最大缩放级别。
- `getMinZoom` 获取视图的最小缩放级别。
- `getProjection` 获取地图使用的”投影坐标系统”，如EPSG:4326；
- `getMaxResolution` 获取视图的最大分辨率。
- `getMinResolution` 获取视图的最低分辨率
- `getRotation` 获取视图旋转。
- `getZoomForResolution` 获取分辨率的缩放级别。
- `setCenter`  设置当前视图的中心。任何范围限制都将适用。
- `setConstrainResolution` 设置视图是否应允许中间缩放级别。
- `setZoom` 缩放到特定的缩放级别。任何分辨率限制都将适用。
- `setMaxZoom` 为视图设置新的最大缩放级别。
- `setMinZoom` 为视图设置新的最小缩放级别。
- `setRotation` 设置该视图的旋转角度。任何旋转约束都将适用。

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
    <button onclick="setCenter()">修改地图中心</button><button onclick="setZoom()">修改缩放</button><button onclick="setRotation()">修改旋转</button
    ><br />
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

    function setCenter() {
      console.log('中心点===', view.getCenter())
      view.setCenter(ol.proj.fromLonLat([Math.random() * 130 + 20, Math.random() * 20 + 10]))
    }
    function setZoom() {
      // 这里要注意 是不每个级别都有对应的 瓦片图。不同的地图要设置不同的最大最小值
      console.log('缩放===', view.getZoom())
      console.log('缩放最大===', view.getMaxZoom())
      console.log('缩放最小===', view.getMinZoom())
      view.setMaxZoom(9)
      view.setMinZoom(0)
      view.setZoom(Math.ceil(Math.random() * 8))
    }

    function setRotation() {
      console.log('旋转===', view.getRotation())
      view.setRotation(Math.ceil(Math.random() * 180))
    }
  </script>
</html>
```

![1.gif](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/cfc47b4636d945ce86e882dbcb58d447~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

- 需要注意后端瓦片的的层级有多少，超出后地图显示白屏。
- `View`代表视图，我们使用它来操作地图。只要是修改地图2D效果的都需要使用到它。