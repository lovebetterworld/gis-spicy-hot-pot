- [OpenLayers - Vector绘制地图省市区（十） - 掘金 (juejin.cn)](https://juejin.cn/post/7001099135348654094)

## 简介

本文讲解经常在开发中出现的功能，绘制地图省市区。主要使用`Vector`图层通过绘制多边行的方法，绘制出省市区的多边行，把该图层添加到地图图层上，就实现了绘制省市区图形。

## Vector

- **矢量图层**： 在客户端呈现的矢量数据。构成一个矢量图层需要一个数据源(`source`)和一个样式(`style`)，数据源构成矢量图层的要素，样式规定要素显示的方式和外观。一个矢量图层包含一个到多个要素(`feature`)，每个要素由地理属(`geometry`)和其他属性组成。
- 常用于从数据库中请求数据，接受数据，并将接收的数据解析成图层上的信息。如将鼠标移动到中国，相应的区域会以红色高亮显示出来，高亮便是矢量图层的行为。

## 绘制省市区

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
      center: ol.proj.fromLonLat([130.41, 28.82]),
      zoom: 4
    })

    map.setView(view)
    map.addLayer(layerTile)
  </script>
</html>
```

### 组装数据源

- 在网上获取省市区的边界数据，[地图数据选择器](https://link.juejin.cn?target=http%3A%2F%2Fdatav.aliyun.com%2Ftools%2Fatlas%2Findex.html%23%26lat%3D31.769817845138945%26lng%3D104.29901249999999%26zoom%3D4)。

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/8e76221959e646aa86c5be24d13767a1~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

- 得到数据后第一步组装数据。直接下载下来的数据是对象格式的。由于我们需要同时绘制多个省市区，这里创建一个数组把每个数据加入进去。

```js
var geo = [{...上海市.json},{...重庆市.json}]
```

### 绘制图层

```js
    // 设置图层
    var areaLayer = new ol.layer.Vector({
      source: new ol.source.Vector({
        features: []
      })
    })
    // 添加图层
    map.addLayer(areaLayer)

    let areaFeature = []
    geo.forEach((g) => {
      var areaFeatureTem = null
      let lineData = g.features[0]
      if (lineData.geometry.type == 'MultiPolygon') {
        areaFeatureTem = new ol.Feature({
          geometry: new ol.geom.MultiPolygon(lineData.geometry.coordinates).transform('EPSG:4326', 'EPSG:3857')
        })
      } else if (lineData.geometry.type == 'Polygon') {
        areaFeatureTem = new ol.Feature({
          geometry: new ol.geom.Polygon(lineData.geometry.coordinates).transform('EPSG:4326', 'EPSG:3857')
        })
      }
      areaFeatureTem.setStyle(
        new ol.style.Style({
          fill: new ol.style.Fill({ color: '#4e98f444' }),
          stroke: new ol.style.Stroke({
            width: 3,
            color: [71, 137, 227, 1]
          })
        })
      )
      areaFeature.push(areaFeatureTem)
    })

    // 加入组装好的数据
    areaLayer.getSource().addFeatures([...areaFeature])
```

- 先创建图层，然后创建要素。多边行在要素中主要分为两种，`MultiPolygon`、`Polygon`，都是表示多边行的。不同的是`MultiPolygon`数据格式是4维数组，`Polygon`是3维数组。最后把创建好的要素放入图层中。

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/1a74b54aa40e440da594fb7ccd7acd37~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

## 总结

矢量图层就是通过很多坐标点来绘制图形，除了绘制省市区也可以通过他来绘制扇形、圆形等。与交互事件联合使用可以实现，自定义绘图、省市区高亮显示等。