- [OpenLayers官方示例详解十六之伪造点（Synthetic Points）](https://blog.csdn.net/qq_35732147/article/details/85629690)



# 一、示例简介

    本示例首先随机生成20000个点数据，并加入到地图中，然后实现了将离鼠标最近的点高亮显示的功能。

# 二、代码详解

```js
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Synthetic Points</title>
    <link href="ol_v5.0.0/css/ol.css" rel="stylesheet" type="text/css" />
    <script src="ol_v5.0.0/build/ol.js" type="text/javascript"></script>
</head>
<body>
    <div id="map"></div>
    
    <script>
        var count = 20000;
        var features = new Array(count);
        var e = 18000000;
        // 随机生成20000个点要素
        for(var i = 0; i < count; i++){
            features[i] = new ol.Feature({
                'geometry': new ol.geom.Point(
                    [2 * e * Math.random() - e, 2 * e * Math.random() - e]
                ),
                'i': i,     // 标记主码
                'size': i % 2 ? 10 : 20    // 用于对应样式的标记
            });
        }
 
        // 点样式的命名空间
        var styles = {
            '10': new ol.style.Style({
                image: new ol.style.Circle({
                    radius: 5,
                    fill: new ol.style.Fill({
                        color: '#666'
                    }),
                    stroke: new ol.style.Stroke({
                        color: '#bada55',
                        width: 1
                    })
                })
            }),
            '20': new ol.style.Style({
                image: new ol.style.Circle({
                    radius: 10,
                    fill: new ol.style.Fill({
                        color: '#666'
                    }),
                    stroke: new ol.style.Stroke({
                        color: '#bada55',
                        width: 1
                    })
                })
            })
        };
 
        var vectorSource = new ol.source.Vector({
            features: features,
            wrapX: false
        });
 
        var vector = new ol.layer.Vector({
            source: vectorSource,
            style: function(feature){                   // 对不同大小的要素赋予不同的样式
                return styles[feature.get('size')]; 
            }
        });
 
        var map = new ol.Map({
            target: 'map',
            layers: [
                vector
            ],
            view: new ol.View({
                center: [0, 0],
                zoom: 2
            })
        });
 
        var point = null;
        var line = null;
        // 寻找离鼠标光标最近的点要素，并使用一条线要素连接两者
        var displaySnap = function(coordinate){
            var closestFeature = vectorSource.getClosestFeatureToCoordinate(coordinate);    // 获取与传入的坐标点最接近的要素
            if(closestFeature === null){
                point = null;
                line = null;
            }else{
                var geometry = closestFeature.getGeometry();
                var closestPoint = geometry.getClosestPoint(coordinate);    // 获取与传入坐标最接近的点坐标
                if(point === null){
                    point = new ol.geom.Point(closestPoint);    // 初始化点几何图形
                }else{
                    point.setCoordinates(closestPoint);         // 重新设置点图形的坐标
                }
                if(line === null){
                    line = new ol.geom.LineString([coordinate, closestPoint]);  // 初始化线几何图形
                }else{  
                    line.setCoordinates([coordinate, closestPoint]);            // 重新设置线图形的坐标
                }
            }
            map.render();
        }
 
        map.on('pointermove', function(evt){
            if(evt.dragging){       // 如果鼠标拖拽地图，则不进行其余操作
                return;
            }
            var coordinate = map.getEventCoordinate(evt.originalEvent); // 返回当前鼠标的坐标
            displaySnap(coordinate);        // 显示捕捉
 
            var pixel = map.getEventPixel(evt.originalEvent);
            var hit = map.hasFeatureAtPixel(pixel);         // 判断是否有要素点与鼠标相交
            // 如果鼠标光标与要素点相交，则改变鼠标光标的样式
            if(hit){
                map.getTargetElement().style.cursor = 'pointer';   
            }else{
                map.getTargetElement().style.cursor = '';
            }
        });
 
        map.on('click', function(evt){
            displaySnap(evt.coordinate);
        });
 
        var stroke = new ol.style.Stroke({
            color: 'rgba(255, 255, 0, 0.9)',
            width: 3
        });
        var style = new ol.style.Style({
            stroke: stroke,
            image: new ol.style.Circle({
                radius: 10,
                stroke: stroke
            })
        });
 
        map.on('postcompose', function(evt){
            var vectorContext = evt.vectorContext;  // 获取canvas 2d绘图上下文
            vectorContext.setStyle(style);          // 为绘图上下文设置样式
            if(point !== null){
                vectorContext.drawGeometry(point);  // 使用canvas绘制离鼠标最近的点
            }
            if(line !== null){
                vectorContext.drawGeometry(line);   // 使用canvas绘制鼠标与离鼠标最近点之间的线
            }
        });
    </script>
</body>
</html>
```
