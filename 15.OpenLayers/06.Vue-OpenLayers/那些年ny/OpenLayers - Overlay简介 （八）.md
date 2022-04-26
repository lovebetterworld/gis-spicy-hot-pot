- [OpenLayers - Overlay简介 （八） - 掘金 (juejin.cn)](https://juejin.cn/post/6997634867882131464)

## Overlay是什么

让HTML元素显示在地图上某个位置。他和控件很像都是在地图上添加可见元素，不同的是，它不是根据屏幕位置固定的，而是与地理坐标相关联，因此平移地图将移动 `Overlay`。
 常用的大致有三类，**弹窗**、**标注**、**文本信息**。每个覆盖物都会生成对应的HTML元素，所以我们也可以使用`css`来修改去样式。

## overlay 常用属性

- `id`，覆盖物的唯一标识 ，便于 `getOverlayById` 方法取得相应的 `overlay`。
- `element`，要添加到覆盖物元素。
- `offset`，偏移量，像素为单位。`overlay` 相对于放置位置（`position`）的偏移量，默认值是 `[0, 0]`，正值分别向右和向下偏移。
- `position`，在地图所在的坐标系框架下，overlay 放置的位置。
- `positioning`，`overlay` 对于 `position` 的相对位置，可能的值是`'bottom-left'`，`'bottom-center'`，`'bottom-right'`， `'center-left'`，`'center-center'`，`'center-right'`，`'top-left'`， `'top-center'`，和`'top-right'`。
- `stopEvent`，是否应停止事件传播到地图视口。
- `autoPanAnimation`，用于将叠加层平移到视图中的动画选项。此动画仅在`autoPan`启用时使用。可以提供A`duration`和`easing`来自定义动画。如果`autoPan`作为对象提供，则弃用并忽略。
- `className`，CSS 类名。

## overlay 常用事件

- `change`，当引用计数器增加时，触发；
- `change:element`，`overlay` 对应的 element 变化时触发；
- `change:map`，`overlay` 对应的 map 变化时触发；
- `change:offset`，`overlay` 对应的 offset 变化时触发；
- `change:position`，`overlay` 对应的 position 变化时触发；
- `change:positioning`，`overlay` 对应的 positioning 变化时触发；
- `propertychange`，`overlay` 对应的属性变化时触发；

绑定方式：

```js
var overlay = new ol.Overlay({ // 创建 overlay});
// 事件 
overlay.on("change:element", function(){ console.log("获取变化"); })
```

## overlay 常用方法

- `getElement`，获取传入的元素节点。
- `getId`，获取 `overlay` 的 id。
- `getMap`，获取与 `overlay` 关联的 map对象。
- `getOffset`，获取 `offset` 属性。
- `getPosition`，获取 `position` 属性。
- `getPositioning`，获取 `positioning` 属性。
- `setElement`, 设置元素节点。
- `setMap`，设置map对象。
- `setOffset`，设置 `offset`。
- `setPosition`，设置 `position` 属性。
- `setPositioning`，设置 `positioning` 属性。

## 使用overlay

### 初始化地图

```js
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
      center: ol.proj.fromLonLat([130.41, 28.82]),
      zoom: 4
    })

    map.setView(view)
    map.addLayer(layerTile)
  </script>
</html>
```

### 添加元素

- 直接在`Overlay`中添加一个元素节点，文本、动画都可以通过它添加到地图上。

```html
   ...
   .tag {
      width: 30px;
      height: 30px;
      background-color: aquamarine;
      border-radius: 100%;
    }
    ...
    <div id="tag" class="tag"></div>
    ...
    var tag = new ol.Overlay({
      position: ol.proj.fromLonLat([120.41, 28.82]),
      positioning: 'center-center',
      element: document.getElementById('tag'),
      stopEvent: false
    })
    map.addOverlay(tag)
    ...
```

![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/67aaa2dc33784691af4cd1f81f94f2ec~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

### 添加事件

```js
document.getElementById('tag').onclick = function () {
    tag.setPosition(undefined)
    return false
}
map.on('singleclick', function (evt) {
    tag.setPosition(evt.coordinate) // 把 overlay 显示到指定的 x,y坐标
})
```

![1.gif](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b1cc7b599ce54a1b895a6846d574c23c~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

- 通过给元素添加监听事件，修改坐标位置，让元素离开地图。然后监听地图单击事件，修改元素坐标位置，实现在点击位置加载元素。

### 总结

覆盖物的使用方式非常简单，通过它我们可以实现很多功能。如在地图上添加云层移动的gif图片，实现动态效果等。不过它的缺点也比较明显，一个覆盖物最少需要一个元素，当数据量大时，元素节点过多会导致页面加载卡顿。大数据量的绘制图还是使用图层最好。