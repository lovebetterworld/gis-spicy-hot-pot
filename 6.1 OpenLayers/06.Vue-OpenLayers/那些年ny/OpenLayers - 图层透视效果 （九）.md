- [OpenLayers - 图层透视效果 （九） - 掘金 (juejin.cn)](https://juejin.cn/post/6999202444995461134)

## 简介

本文主要讲解的是，通过控制图层，层级和大小来实现图层透视功能。
 主要使用图层监听事件 `prerender`监听图层渲染之前，`postrender`监听图层渲染之后。

## 实现DEMO

### 初始化地图

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
    // 图层
    var roads = new ol.layer.Tile({
      source: new ol.source.XYZ({
        url: 'https://webrd01.is.autonavi.com/appmaptile?lang=zh_cn&size=1&scale=1&style=8&x={x}&y={y}&z={z}'
      })
    })

    // 图层2
    var imagery = new ol.layer.Tile({
      source: new ol.source.XYZ({
        url: 'http://map.geoq.cn/ArcGIS/rest/services/ChinaOnlineStreetPurplishBlue/MapServer/tile/{z}/{y}/{x}'
      })
    })

    // 实例
    const container = document.getElementById('map')

    var map = new ol.Map({
      target: container,
      layers: [roads, imagery],
      view: new ol.View({
        center: ol.proj.fromLonLat([37.41, 8.82]),
        zoom: 4
      })
    })

  </script>
</html>
```

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/cbcfa6a5e6874f1ca4956cf13fd589af~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

- 这里我们创建了两个图层，记住图层的默认层级都是后面添加的大于前面的层级。
- 要实现图层透视的效果，其实就是在基础图层上固定范围绘制上图层来达到效果。

### 获取鼠标在地图上的坐标位置

```js
    // 地图像素位置
    let mousePosition = null

    container.addEventListener('mousemove', function (event) {
      // getEventPixel(event) 根据事件当前位置 返回地图像素位置。
      mousePosition = map.getEventPixel(event)

      // 重新渲染地图 render()
      map.render()
    })

    container.addEventListener('mouseout', function () {
      mousePosition = null
      map.render()
    })
```

1. 创建全局变量（`mousePosition`）实时保存鼠标地理位置。
2. 通过监听容器的**鼠标移入事件**获取当前位置窗口位置，使用`getEventPixel()`转换为地理位置。
3. 监听容器的**鼠标移出事件**取消地理位置。
4. 每次监听都需要重绘地图，用于透视图层内容的更新。

### 监听图层事件

```js
    // 半径
    let radius = 75
    // 图层渲染之前
    imagery.on('prerender', function (event) {
      const ctx = event.context
      ctx.save() // 保存
      ctx.beginPath()
      if (mousePosition) {
        ctx.arc(mousePosition[0], mousePosition[1], radius, 0, 2 * Math.PI)
        ctx.lineWidth = (5 * radius) / radius
        ctx.strokeStyle = 'rgba(0,0,0,0.5)'
        ctx.stroke()
      }
      // 使用裁剪 只加载 圆内数据
      ctx.clip()
    })

    // 图层渲染之后
    imagery.on('postrender', function (event) {
      const ctx = event.context
      ctx.restore()
    })
```

1. 这里绘制的是圆形，你可以自定义其他图形。
2. 通过图层事件`prerender`图层渲染之前，在监听中返回的图层实例`canvas`。这里一定要先保存状态`ctx.save()`，通过`mousePosition`获取鼠标的坐标，随意绘制图形，使用`clip()`裁剪画布，只展示裁剪后的内容。
3. 通过`postrender`图层渲染之后。恢复保存的`canvas`内容展示。

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/c074dbafaee84a5d8b822484471b3672~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

### 附加功能

```js
document.addEventListener('keydown', function (evt) {
      console.log(100)
      if (evt.keyCode === 38) {
        console.log(1)
        // 如果用户按下'↑'键，望远镜的半径增加5像素
        radius = Math.min(radius + 5, 150)
        map.render()
        evt.preventDefault()
      } else if (evt.keyCode === 40) {
        // 如果用户按下'↓'键，望远镜的半径减少5像素
        radius = Math.max(radius - 5, 25)
        map.render()
        evt.preventDefault()
      }
    })
```

- 监听全局键盘事件，修改我们绘制透视图层的形状。当然这里也要注意修改后也需要`map.render()`重绘地图，展示最新效果。

![1.gif](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/0d6f8227876c4507b265096082e2cc9d~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)