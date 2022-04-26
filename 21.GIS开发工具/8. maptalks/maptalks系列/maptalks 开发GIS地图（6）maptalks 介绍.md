- [maptalks 开发GIS地图（6）maptalks 介绍](https://www.cnblogs.com/googlegis/p/14720892.html)

51. geoJson to geometry

```js
var json = {
    'type': 'Feature',
    'geometry': {
      'type': 'Point',
      'coordinates': [-0.113049,51.498568]
    },
    'properties': {
      'name': 'point marker'
    }
  };
  var marker = maptalks.GeoJSON.toGeometry(json).addTo(map.getLayer('v'));
```

52. marker to geojson

```js
var marker = new maptalks.Marker([-0.113049,51.498568], {
    'properties': {
      'name': 'point marker'
    }
  }).addTo(map.getLayer('v'));

  document.getElementById('info').innerHTML = JSON.stringify(marker.toGeoJSON());
```

53. map to json

```js
var mapJSON = map.toJSON();

document.getElementById('json').innerHTML = JSON.stringify(mapJSON);
```

54. map from json

```js
var mapJSON = {
    "version":"1.0",
    "options":{
      "center":{ "x":-0.113049,"y":51.49856800000001 },
      "zoom":13
    },
    "baseLayer":{
      "type":"TileLayer",
      "id":"base",
      "options":{
        "urlTemplate":"http://{s}.tile.osm.org/{z}/{x}/{y}.png",
        "subdomains":["a","b","c"]
      }
    },
    "layers":[
      {
        "type":"VectorLayer",
        "id":"v",
        "geometries":[
          {
            "feature":{
              "type":"Feature",
              "geometry":{
                "type":"Point",
                "coordinates":[-0.113049,51.498568]
              }
            }
          }
        ]
      }
    ]
  };

  maptalks.Map.fromJSON('map', mapJSON);
```

55. echart3-bus

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210430094835860-375321215.gif)

```js
var ecOption = {
                'series': [ {
                    'type': 'lines',
                    'polyline': true,
                    'data': busLines,
                    'lineStyle': {
                        'normal': {
                            'width': 0
                        }
                    },
                    'effect': {
                        'constantSpeed': 20,
                        'show': true,
                        'trailLength': 0.5,
                        'symbolSize': 1.5
                    },
                    'zlevel': 1
                }]
            };
            var e3Layer = new maptalks.E3Layer('e3', ecOption, { hideOnZooming : true, hideOnRotating : true, hideOnMoving : true })
            .addTo(map);
```

56.point-cluster

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210430095014297-439736008.gif)

```js
var clusterLayer = new maptalks.ClusterLayer('cluster', markers, {
        'noClusterWithOneMarker' : false,
        'maxClusterZoom' : 18,
        //"count" is an internal variable: marker count in the cluster.
        'symbol': {
            'markerType' : 'ellipse',
            'markerFill' : { property:'count', type:'interval', stops: [[0, 'rgb(135, 196, 240)'], [9, '#1bbc9b'], [99, 'rgb(216, 115, 149)']] },
            'markerFillOpacity' : 0.7,
            'markerLineOpacity' : 1,
            'markerLineWidth' : 3,
            'markerLineColor' : '#fff',
            'markerWidth' : { property:'count', type:'interval', stops: [[0, 40], [9, 60], [99, 80]] },
            'markerHeight' : { property:'count', type:'interval', stops: [[0, 40], [9, 60], [99, 80]] }
        },
        'drawClusterText': true,
        'geometryEvents' : true,
        'single': true
    });

    map.addLayer(clusterLayer);
```

57. fly-echart3

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210430095232811-1906744442.gif)

```js
var e3Layer = new maptalks.E3Layer('e3', getECOption())
    .addTo(map);
```

 58.heatmap

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210430095327236-1649895150.png)

```js
var data = addressPoints.map(function (p) { return [p[1], p[0]]; });
var heatlayer = new maptalks.HeatLayer('heat', data, {
    'heatValueScale': 0.7,
    'forceRenderOnRotating' : true,
    'forceRenderOnMoving' : true
}).addTo(map);
```

