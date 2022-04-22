- [利用openlayer6中实现：图层级别1-4使用热力图，图层5-7使用点图层表示，高于7使用图标图层表示](https://www.freesion.com/article/6241954097/)

分三层：三个图层，实际上是利用同一组坐标数据，不同层级表现形式不同

```js
<!doctype html>
<html lang="en">
 
<head>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/openlayers/openlayers.github.io@master/en/v6.3.1/css/ol.css"
    type="text/css">
  <style>
    .map {
      height: 400px;
      width: 100%;
    }
  </style>
  <script src="https://cdn.jsdelivr.net/gh/openlayers/openlayers.github.io@master/en/v6.3.1/build/ol.js"></script>
  <title>OpenLayers example</title>
</head>
 
<body>
  <h2>My Map</h2>
  <div id="map" class="map"></div>
  <script type="text/javascript">
    var layerMap = new Map();
    var features = [];
    var features2 = [];
    var features3 = [];
 
    let points = [];
 
    for (let i = 0; i < 1100; i++) {
      let point = [130 + 30 * Math.random() - 40 * Math.random(), 262 * Math.random() - 2 * Math.random()]
      points.push(point)
    }
    for (let i = 0; i < 1100; i++) {
 
      features.push(new ol.Feature({
        geometry: new ol.geom.Point(points[i])
      }))
      features2.push(new ol.Feature({
        geometry: new ol.geom.Point(points[i])
      }))
      features3.push(new ol.Feature({
        geometry: new ol.geom.Point(points[i])
      }))
 
    }
 
 
    var pointSource = new ol.source.Vector({
      features: features
    })
    var IconSource = new ol.source.Vector({
      features: features2
    })
    var heatMapSource = new ol.source.Vector({
      features: features3
    })
    //新建点图层
    var pointLayer = new ol.layer.Vector({
      source: pointSource,
      style: function () {
        return new ol.style.Style({
          image: new ol.style.Circle({
            color: 'red',
            radius: 5,
            fill: new ol.style.Fill({
              color: 'red'
            }),
            stroke: new ol.style.Stroke({
              color: 'gray', width: 3
            })
          })
        })
      }
 
    })
 
    pointLayer.layerId = 'pointLayerId'
    layerMap.set(pointLayer.layerId, pointLayer)
 
    //新建热力图层
    var heatMap = new ol.layer.Heatmap({
      source: heatMapSource
    })
    heatMap.layerId = 'heatMapId'
    layerMap.set(heatMap.layerId, heatMap)
 
 
    //新建图标图层
    var iconLayer = new ol.layer.Vector({
      source: IconSource,
      style: function () {
        return new ol.style.Style({
          image: new ol.style.Icon({
            src: 'F:\\workspaces\\precode\\code2\\two\\car.png',
            color: 'red',
            radius: 5,
 
          })
        })
      }
 
    })
    iconLayer.layerId = 'iconLayerId'
    layerMap.set(iconLayer.layerId, iconLayer)
    //现在有三个图层，首先在找到地图上现在呈现出来的图层，然后判断是否删除该图层。
 
    var map = new ol.Map({
      target: 'map',
      layers: [
        new ol.layer.Tile({
          source: new ol.source.OSM()
        }),
        pointLayer
      ],
      view: new ol.View({
        center: [130, 26],
        zoom: 6,
        projection: 'EPSG:4326'
      })
    });
 
 
    //删除地图上多余的图层，然后添加一个正确的图层的id
    var toCurrentLayer = function (layerId) {
      let layers = map.getLayers().getArray();
      let curLayerId;
      for (let i = 0; i < layers.length; i++) {
        if (layers[i].layerId) {
          curLayerId = layers[i].layerId
          break;
        }
      }
 
      if (curLayerId) {
        map.removeLayer(layerMap.get(curLayerId));
        map.addLayer(layerMap.get(layerId))
      }
 
    }
    map.getView().on('change:resolution', zoomCallback);
    var isFindLayerById = function (layerId) {
      let result = false;
 
      let layers = map.getLayers().getArray()
      for (let i = 0; i < layers.length; i++) {
        if (layers[i].layerId == layerId) {
          return true
        }
      }
      return false
 
    }
    function zoomCallback(event) {
      window.viewEvent = event;
      console.log(event);
 
      let zoom = event.target.getZoom()
      console.log(zoom)
      if (zoom <= 5 && !isFindLayerById("heatMapId")) {
        //层级小于5，显示是热力图
        toCurrentLayer("heatMapId");
 
      } else if (5 < zoom && zoom <= 7 && !isFindLayerById("pointLayerId")) {
        //显示点图层
        toCurrentLayer("pointLayerId");
      } else if (zoom > 7 && !isFindLayerById("iconLayerId")) {
        //显示图标图层
        toCurrentLayer("iconLayerId");
      }
    }
  </script>
</body>
 
</html>
```

运行展示如下：

![img](https://www.freesion.com/images/242/4c9a27a15b68912be0a11e6deaa4bef2.png)

![img](https://www.freesion.com/images/398/f06e7c1e64d33dcd67b66ffb33b4e7c6.png)

![img](https://www.freesion.com/images/0/16660aab3fa0f6b56604835cb67a8040.png)

