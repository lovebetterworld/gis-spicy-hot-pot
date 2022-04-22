- [利用Openlayers4简单实现地图遮罩效果（一）](https://blog.csdn.net/u012413551/article/details/85225098)
- [利用Openlayers4实现地图遮罩效果（二）](https://blog.csdn.net/u012413551/article/details/88937819)



# 利用Openlayers4简单实现地图遮罩效果（一）

地图遮罩通常用来突出显示某一块特定区域，先来看下效果。(中间带白边的为遮罩层)

![地图遮罩](https://img-blog.csdnimg.cn/20181223195515424.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTI0MTM1NTE=,size_16,color_FFFFFF,t_70)

原理：在原地图上增加一个矢量图层，在图层中添加一个面要素，并对面要素使用半透明的样式。

```js
var map,baseLayer;

//定义图层样式
var mystyle = new ol.style.fill({
    fill: new ol.style.Fill({
        color:"rgba(72,61,139, 0.2)",//重点在这里，采用rgba颜色，最后一个值用来表示透明度
    }),
    stroke: new ol.style.Stroke({
        color:"#BDBDBD",
        width:2
    }) 
})
var vectorSource = new ol.source.Vector();
var vectorLayer = new ol.layer.Vector({
    source: vectorSource,
    style: mystyle
})

/**
 * 初始化地图
 */
function initMap(){
    baseLayer = new ol.layer.Tile({
        source: new ol.source.TileWMS({
            url: "http://localhost:8080/geoserver/china/wms",
            params:{
                'LAYERS': "china:baseMap;",
                'TILED': false
            },           
        })
    });
    
    var view = new ol.View({
        center: [116.727085860608, 35.20619600133295],
        zoom:10.5,
        projection: "EPSG:4326"
    });

    map = new ol.Map({
        target: "map",
        view: view,
        layers:[baseLayer,vectorLayer]
    });
}

/**
 * 根据名称加载遮罩层
 * @param {*} name1 
 */
function addCoverLayer(name1){
	//清除原来的要素
    vectorSource.clear();

    $.getJSON('/region.geojson',function(data){
        var features = (new ol.format.GeoJSON()).readFeatures(data);        
        features.forEach(function(element) {
            //从数据中取出name字段值为name1的区域,进行加载
            if(element.get("name") === name1){
                vectorSource.addFeature(element);
            }
        });
    })
}
```

其中，在开头新建了一个样式，并且使用透明填充。然后将样式应用到矢量图层上。通过函数过滤出遮罩区域，并将区域范围加载到矢量图层上。
遮罩的数据来源是geojson格式，里面为面类型的数据，采用name字段来进行数据过滤。
在页面加载完地图后，调用addConverLayer并传如name参数就即可。
如果需要在外围添加遮罩，参考另一篇博文：《[利用Openlayers4实现地图遮罩效果（二）](https://blog.csdn.net/u012413551/article/details/88937819)》

# 利用Openlayers4简单实现地图遮罩效果（二）

## 效果对比

在之前实现的遮罩效果《[利用Openlayers4简单实现地图遮罩效果（一）](https://blog.csdn.net/u012413551/article/details/85225098)》，在深色背景的底图上，对要突出的区域采用半透明遮罩，以此来突出该区域。暂且称之为**中心遮罩**，遮罩前后对比如下图：

![遮罩前](https://img-blog.csdnimg.cn/20190627220727752.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTI0MTM1NTE=,size_16,color_FFFFFF,t_70)

![遮罩后](https://img-blog.csdnimg.cn/20190627220805438.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTI0MTM1NTE=,size_16,color_FFFFFF,t_70)

但是有时底图颜色偏白，这时候不再适合对要突出的区域采用遮罩，而是要对突出区域之外进行遮罩处理。暂且称为**四周遮罩**如下图：

![遮罩前](https://img-blog.csdnimg.cn/20190627220242118.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTI0MTM1NTE=,size_16,color_FFFFFF,t_70)

![遮罩后](https://img-blog.csdnimg.cn/20190627213337381.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTI0MTM1NTE=,size_16,color_FFFFFF,t_70)

## 代码实现

实现代码如下：
 js代码

```js
(function(){
    
    var map, converLayer;
    function initMap() {
        var baselayer = new ol.layer.Tile({
            source: new ol.source.XYZ({
                url: 'https://map.geoq.cn/ArcGIS/rest/services/ChinaOnlineStreetGray/MapServer/tile/{z}/{y}/{x}'
            })
        });
    
        map = new ol.Map({
            target: 'map',
            layers: [baselayer],
            view: new ol.View({
                projection: 'EPSG:4326',
                center: [112, 36],
                zoom: 6
            })
        });

        var mystyle = new ol.style.Style({
            fill: new ol.style.Fill({
                color:"rgba(72,61,139, 0.4)",
            }),
            stroke: new ol.style.Stroke({
                color:"#BDBDBD",
                width:2
            })
        });
        converLayer = new ol.layer.Vector({
            source: new ol.source.Vector(),
            style: mystyle
        });
        map.addLayer(converLayer);
    }

    //todo
    //添加遮罩
    function addconver(data) {
        $.getJSON(data, function(data) {
            var fts = new ol.format.GeoJSON().readFeatures(data);
            var ft = fts[0];
            var converGeom = erase(ft.getGeometry());

            var convertFt = new ol.Feature({
                geometry: converGeom
            })
            converLayer.getSource().addFeature(convertFt);
        })
    }

    // 擦除操作,生产遮罩范围
    function erase(geom) {
        var extent = [-180,-90,180,90];
        var polygonRing = ol.geom.Polygon.fromExtent(extent);
        var coords = geom.getCoordinates();
        coords.forEach(coord =>{ 
            var linearRing = new ol.geom.LinearRing(coord[0]);
            polygonRing.appendLinearRing(linearRing);
        })
        return polygonRing;
    }

    initMap();
    var dataURL = '/static/data/shanxi.geojson'
    addconver(dataURL);
})();
```

html代码

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>周边遮罩</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://openlayers.org/en/v4.6.5/css/ol.css" type="text/css">
    <script src="/static/js/node_modules/jquery/dist/jquery.min.js"></script>
    <script src="https://openlayers.org/en/v4.6.5/build/ol.js"></script>
    <style>
        head,body,#map{
            width: 100%;
            height: 100%;
            background-color: black;
        }
    </style>
</head>
<body>
    <div id="map"></div>
    <script src="/static/js/conver.js"></script>
</body>
</html>
```

## 原理

利用GIS空间运算中的擦除操作，熟悉GIS数据处理的同学应该不陌生这个操作。在Openlayers中，虽然并不支持空间运算，但是我们可以取构建擦除运算的结果。正常情况下，擦除运算的结果类似一个空心环，分为外环和内环，内外环之间为填充区域。

## 环装几何

openlayers支持环状几何，我们将地图周边视为外环，将中心视为内环，构建环，在利用半透明填充即可实现四周遮罩。具体方法见js代码中的erase函数。