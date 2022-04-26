- [openlayers5-加载geojson数据的两种方法，并用icon sprite图标来渲染](https://www.jianshu.com/p/7997a6ce4567)



## 加载geoJson数据的两种方法

```js
var vectorSource = new VectorSource({
    url: '/json/air.json',
    format: new GeoJSON()
});
//或者
//用mock模拟geojson数据
let geojsonObject = MockData.createJSONCase(96, 34);
var vectorSource = new VectorSource({
    features: (new ol.format.GeoJSON()).readFeatures(geojsonObject)
});
```

## sprite图标渲染

```js
  addGeojson() {
    var vectorSource = new VectorSource({
      url: '/json/air.json',
      format: new GeoJSON()
    });
    // resolution:分辨率
    var styleFunction = function (feature, resolution) {
      return new Style({
// 添加circle
  /*       image: new CircleStyle({
          radius: 10,
          fill: new Fill({
            color: 'rgba(255, 0, 0, 0.1)'
          }),
          stroke: new Stroke({
            color: 'red',
            width: 1
          })
        }), */
//添加sprite图标
        image: new Icon({
          offset: [56,0],
          opacity: 1.0,
          rotateWithView: 28,
          rotation: 0.0,
          scale: 1.0,
          size: [28,29],
          crossOrigin: 'anonymous',
          src: '/img/sprite.png'
        }),
        text: new Text({
          textAlign: 'center',
          textBaseline: 'top',
          // font: font,
          offsetX: 0,
          offsetY: 12,
          text: resolution < 180 ? feature.get('ZDMC') : '',
          fill: new Fill({
            color: '#149321'
          }),
          // 字体阴影
          // stroke: new Stroke({
          //   color: '#149321',
          //   width: 1
          // }),
        })
      });
    };
```

resolution为分辨率

- `/img/sprite.png`为合成的雪碧图（spri te图片）

## 通过循环添加

```js
var taskLayer = new VectorLayer({
    source: new VectorSource(),
    name: 'task-layer',
    zIndex:99,
});
this.map.addLayer(taskLayer);
var json = MockData.createCase(96, 34);
// console.dir(json);
for (var i in json) {
    var fea = json[i];
    // console.dir(fea);
    let point = transform([fea.lon, fea.lat], "EPSG:4326", "EPSG:3857");
    let marker = new Feature({
        geometry: new Point(point),
        type: 'task',
        name: fea.info.title,
        // 没有效果，必须通过`setId()`来给feature添加Id
        id:fea.index,
        index:fea.index,
        info:fea.info,
        dataTime:fea.dataTime
    });
    // 给feature添加Id
    marker.setId(fea.index);
    marker.setStyle(
        new Style({
            image: new Icon({
                anchor: [0.5, 0.5],
                src: '/img/flag_pink.png'
            }),
            text: new Text({
                font: 'bold 12px Microsoft YaHei',
                text: fea.info.title,
                offsetX: 0,
                offsetY: 20,
                textAlign: 'center',
                textBaseline: 'top',
                backgroundFill: new Fill({
                    color: '#67C23A'
                }),
                padding: [0, 2, 0, 2],
                fill: new Fill({
                    color: '#fff'
                })
            })
        })
    )
    taskLayer.getSource().addFeature(marker);
}
```

