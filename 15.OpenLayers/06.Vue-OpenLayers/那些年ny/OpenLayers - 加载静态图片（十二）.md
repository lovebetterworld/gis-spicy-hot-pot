- [OpenLayers - 加载静态图片（十二） - 掘金 (juejin.cn)](https://juejin.cn/post/7001811340075483166)

## 简介

本文讲解，如何使用`OpenLayers`在载静态图片上添加标记，预览图片。主要使用`ol.source.ImageStatic`用于显示单个静态图像的图层源。使用`OpenLayers`的好处有，地图的放大、缩小等`view`视图功能都可以使用，根据地理坐标绘制标注也能很好的使用，对于演示而言，无疑加快了开发效率。

## 开始使用

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

    // 地图设置中心
    var center = ol.proj.transform([0, 0], 'EPSG:4326', 'EPSG:3857')
    // 视图
    var view = new ol.View({
      center: ol.proj.fromLonLat([0, 0]),
      zoom: 7
    })

    map.setView(view)

    // 计算图片映射到地图上的范围，保持比例的情况下。 放大100倍 除以2 让图片中心点和地图中心点重合
    var extent = [center[0] - (1080 * 1000) / 2, center[1] - (756 * 1000) / 2, center[0] + (1080 * 1000) / 2, center[1] + (756 * 1000) / 2]
    // 加载图片图层
    map.addLayer(
      new ol.layer.Image({
        source: new ol.source.ImageStatic({
          url: '2.jpg',
          imageExtent: extent //映射到地图的范围
        })
      })
    )
  </script>
</html>
```

![1.gif](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/0ee015e1ecdc41a8b23c3579050b92c5~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

1. 初始化`map`后这里就不需要地图图层了。
2. 用于操作地图放大缩小的视图还是要加入`map`中，需要注意中心点要使用变量保存下来，用于定义图片图层的范围。这里中心点使用的地理坐标`ol.proj.fromLonLat([0, 0])`，并且计算图片映射范围时，使图片中心和中心点重合。不同的中心点标注计算位置时方式是不一样的。
3. 创建图片图层加入`map`中。

### 绘制标注

- 图片已经加载了，添加标注还会远吗。

```js
    // 创建矢量图层 绘制标注
    var vLayer = new ol.layer.Vector({
      source: new ol.source.Vector()
    })

    //创建一个活动图标需要的Feature，并设置位置
    var feature = new ol.Feature({
      geometry: new ol.geom.Point([center[0] + 540 * 1000, center[1] - 378 * 1000])
    })
    //设置Feature的样式，使用小旗帜图标
    feature.setStyle(
      new ol.style.Style({
        image: new ol.style.Icon({
          src: 'https://img2.baidu.com/it/u=3347068028,2336626960&fm=26&fmt=auto&gp=0.jpg',
          anchor: [0, 1],
          scale: 0.2
        })
      })
    )

    vLayer.getSource().addFeature(feature)
    map.addLayer(vLayer)
```

![1.gif](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/fa68ed0b157d44d29bf4ac4493824e11~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

1. 先创建`Vector`矢量图层用户加载标注。
2. 创建点要素，要注意上面使用的`ol.proj.fromLonLat([0, 0])`，所以图片中心就是原点。计算标注位置时使用的是像素坐标，图片放大了1000倍，这里的1像素位置就是1000。最后以原点为中心的十字坐标计算标注位置就行了。
3. 一个简单的标注操作就完成了，当然其他功能也是可以用的就和操作地图没区别，主要是坐标位置需要注意。