- [openlayers4实现的点动态扩散](https://blog.csdn.net/u012413551/article/details/85725916)



原理：连续刷新地图，并且刷新时，修过点样式的半径大小，来实现扩散效果；

```js
//定义底图
var baseLayer = new ol.layer.Vector({
    renderMode: 'image',
    source: new ol.source.Vector({
        url:'/data/shengjie.geojson',
        format: new ol.format.GeoJSON()
    }),
    style: new ol.style.Style({
        fill: new ol.style.Fill({
          color: '#0A122A'
        }),
        stroke: new ol.style.Stroke({
          color: '#6E6E6E',
          width: 1
        })
    })
})

var view = new ol.View({
    center: [108.7,34.8],
    zoom: 4,
    projection: "EPSG:4326"
});

var map = new ol.Map({
    target: 'map',
    view: view,
    layers: [baseLayer]
})


//定义一个矢量图层，用于打点
var pointAnimationLayer = new ol.layer.Vector({
    source: new ol.source.Vector(),
    style: new ol.style.Style({
        image: new ol.style.Circle({
            fill: new ol.style.Fill({
                color: '#E6E6E6'
            }),
            radius: 4
        })
    })
})
map.addLayer(pointAnimationLayer);

//随机写的点坐标
var points=[]
points.push([112.4,33.5]);
points.push([103.8,23.7]);
points.push([89.7,41.6]);

//将点添加到图层
points.forEach(element => {
    var ft = new ol.Feature({
        geometry: new ol.geom.Point(element)
    });
    pointAnimationLayer.getSource().addFeature(ft);
});

//map渲染事件，回调动画
map.on('postcompose',animation);

//样式中的半径变量，通过不断刷新点样式的半径来实现点动态扩散
var radius = 1;

//动画
function animation(event){
    if(radius >= 20){
        radius = 0
    }
    var opacity =  (20 - radius) * (1 / 20) ;//不透明度
    var pointStyle = new ol.style.Style({
        image: new ol.style.Circle({
            radius:radius,
            stroke: new ol.style.Stroke({
                color: 'rgba(255,255,0' + opacity + ')',
                width: 2 - radius / 10
            })
        })
    })

    var features = pointAnimationLayer.getSource().getFeatures();
 
    var vectorContext = event.vectorContext;
    vectorContext.setStyle(pointStyle);
    features.forEach(element => {
        var geom = element.getGeometry();
        vectorContext.drawGeometry(geom);
    });
    radius = radius + 0.3;
    
    //触发map的postcompose事件
    map.render();
}
```

## 实现

### 利用map的渲染事件：postcompose来连续刷新

之前实现地图动画都是用window.setInterval()方法来实现，这次拓展下视野，采用Openlayers内部的方法。主要有两步操作：
 1、事件注册

```js
map.on('postcompose',animation);
```

2、在事件的回调函数中去触发postcompose事件

```js
map.render();
```

postcompose事件第一次触发是在地图初始化时，后续的触发都由animation方法中的map.render()来完成。