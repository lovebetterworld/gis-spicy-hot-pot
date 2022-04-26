- [OpenLayers - 使用Cluster绘制聚合标注（十一） - 掘金 (juejin.cn)](https://juejin.cn/post/7001476859116388359)

## 简介

本文介绍如何绘制聚合标注。在开发中往往需要我们绘制大量的标注点，当地图层级缩放到最大时就需要加载全部的点。看上去比较密集不能直接知道大概位置有多少数据。为了解决这一问题`OpenLayers`提供了`ol.source.Cluster`

### ol.source.Cluster

- 它是对矢量数据进行聚类的图层源。没错它不是图层，只是矢量图层的数据源。

使用方式就是实例化`Cluster`，作为要素加入矢量图层中。

```js
ol.source.Cluster({ 
    distance: 10, // 标注元素之间的间距，单位是像素。 
    source: source,//数据源 
});
```

## 开始使用

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
      center: ol.proj.fromLonLat([0, 0]),
      zoom: 4
    })

    map.setView(view)
    map.addLayer(layerTile)
  </script>
</html>
```

### 加入集合数据源

```js
    const e = 4500000
    const count = 2000
    const features = new Array(count)
    for (let i = 0; i < count; ++i) {
      const coordinates = [2 * e * Math.random() - e, 2 * e * Math.random() - e]
      features[i] = new ol.Feature(new ol.geom.Point(coordinates))
    }
    // 矢量数据源
    let source = new ol.source.Vector({
      features: features
    })
    // 实例化聚合数据源 并设置 聚合距离
    let clusterSource = new ol.source.Cluster({
      distance: 40,
      source: source
    })
    // 创建图层
    let layer = new ol.layer.Vector({
      source: clusterSource,
      style: clusterStyle.call(this)
    })
    map.addLayer(layer)

    function clusterStyle() {
      return (feature, solution) => {
        const size = feature.get('features').length
        let style = new ol.style.Style({
          image: new ol.style.Circle({
            radius: 15,
            stroke: new ol.style.Stroke({
              color: '#fff'
            }),
            fill: new ol.style.Fill({
              color: '#3399CC'
            })
          }),
          text: new ol.style.Text({
            text: size.toString(),
            fill: new ol.style.Fill({
              color: '#fff'
            })
          })
        })
        return style
      }
    }
```

![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/a68d4c69096843a68a2eeee93ef0d6e3~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

1. 先创建点要素数组，把点要素数组加入矢量数据源中。
2. 把矢量数据源放入聚合数据源中。通过参数设置聚合的距离和参数。

- `distance` 要素将聚集在一起的距离（以像素为单位）。
- `minDistance` 簇之间的最小距离（以像素为单位）。不能大于配置的距离。
- `source` 矢量数据源

1. 创建矢量图层，这里要注意的是样式使用方法的形式返回，在方法中我们能实时获取当前聚合要素的数据，来生成不同的样式。

### 根据数量修改集合颜色

```js
    ...
    let style = new ol.style.Style({
      image: new ol.style.Circle({
        radius: 15,
        stroke: new ol.style.Stroke({
          color: '#fff'
        }),
        fill: new ol.style.Fill({
          color: getColor(size)
        })
      }),
      text: new ol.style.Text({
        text: size.toString(),
        fill: new ol.style.Fill({
          color: '#fff'
        })
      })
    })
    ...
    
    function getColor(val) {
      if (val < 100) {
        return '#444693'
      } else if (val >= 100 && val < 500) {
        return '#f47920'
      } else if (val >= 500) {
        return '#ef5b9c'
      }
    }
```

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/755af1f4c2e6473eb60e28ff98da4a01~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

- 非常简单，我们先定义好一个判断颜色的函数。在`Style`中使用这个函数就行了。因为地图的每一次改变都会重新绘制，所以颜色也会根据数量变化而变化。
- 除了点聚合还可以[实现多边形聚合](https://link.juejin.cn?target=https%3A%2F%2Fwww.jianshu.com%2Fp%2F330b45f1c9ac)有兴趣的同学可以去看看。