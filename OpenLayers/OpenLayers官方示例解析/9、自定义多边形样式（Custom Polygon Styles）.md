- [自定义多边形样式（Custom Polygon Styles）](https://blog.csdn.net/qq_35732147/article/details/85003777)

# 一、示例简介

    这个示例演示怎样为多边形要素创建自定义的样式。
    
    在这个示例中，将为多边形创建两种不同的样式：
    
    第一个样式是多边形的整体样式
    第二个样式是为多边形的各个顶点创建的样式

![img](https://img-blog.csdnimg.cn/20181214145654493.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

# 二、代码详解

```js
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Custom Polygon Styles</title>
    <link href="ol_v5.0.0/css/ol.css" rel="stylesheet" type="text/css" />
    <script src="ol_v5.0.0/build/ol.js" type="text/javascript"></script>
</head>
<body>
    <div id="map"></div>
 
    <script>
        var styles = [
            new ol.style.Style({
                stroke: new ol.style.Stroke({       // 线样式
                    color: 'blue',
                    width: 3
                }),
                fill: new ol.style.Fill({           // 填充样式
                    color: 'rgba(0, 0, 255, 0.1)'
                })
            }),
            new ol.style.Style({
                image: new ol.style.Circle({   // 点样式
                    radius: 5,          // 圆形符号的半径
                    fill: new ol.style.Fill({   // 圆形符号的填充样式
                        color: 'orange'
                    })
                }),
                // 将样式设置为多边形外环独有的样式
                geometry: function(feature){
                    // 返回多变形第一个外环的坐标（数组形式）
                    var coordinates = feature.getGeometry().getCoordinates()[0];
                    // 将返回的多边形外环的坐标以MultiPoint的形式重新创建为多点图形
                    return new ol.geom.MultiPoint(coordinates); 
                }
            })
        ];
 
        // GeoJson格式的数据
        var geojsonObject = {
            'type': 'FeatureCollection',
            'crs': {
            'type': 'name',
            'properties': {
                'name': 'EPSG:3857'
            }
            },
            'features': [{
            'type': 'Feature',
            'geometry': {
                'type': 'Polygon',
                'coordinates': [[[-5e6, 6e6], [-5e6, 8e6], [-3e6, 8e6],
                [-3e6, 6e6], [-5e6, 6e6]]]
            }
            }, {
            'type': 'Feature',
            'geometry': {
                'type': 'Polygon',
                'coordinates': [[[-2e6, 6e6], [-2e6, 8e6], [0, 8e6],
                [0, 6e6], [-2e6, 6e6]]]
            }
            }, {
            'type': 'Feature',
            'geometry': {
                'type': 'Polygon',
                'coordinates': [[[1e6, 6e6], [1e6, 8e6], [3e6, 8e6],
                [3e6, 6e6], [1e6, 6e6]]]
            }
            }, {
            'type': 'Feature',
            'geometry': {
                'type': 'Polygon',
                'coordinates': [[[-2e6, -1e6], [-1e6, 1e6],
                [0, -1e6], [-2e6, -1e6]]]
            }
            }]
        };
 
        // 读取GeoJson数据并将其初始化为矢量图层源
        var source = new ol.source.Vector({
            features: (new ol.format.GeoJSON()).readFeatures(geojsonObject)
        });
 
        // 承载GeoJson数据的矢量图层
        var layer = new ol.layer.Vector({
            source: source,
            style: styles           // 图层可以接受一个样式数组作为渲染的样式
        });
 
        var map = new ol.Map({
            target: 'map',
            layers: [
                layer   
            ],
            view: new ol.View({
                center: [0, 3000000],
                zoom: 2
            })
        });
    </script>
</body>
</html>
```
这里需要了解的是，矢量图层可以接受一个由多个样式对象所构成的样式数组作为渲染样式。

同时，样式数组中的样式也与要渲染的几何图形一一对应。