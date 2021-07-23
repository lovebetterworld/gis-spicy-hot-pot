- [线串箭头样式（LineString Arrows）](https://blog.csdn.net/qq_35732147/article/details/84860007)

# 一、示例简介

    为每一个线串（LineString）的子线段绘制箭头。
# 二、代码详解 

```js
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>LineString Arrows</title>
    <link href="ol_v5.0.0/css/ol.css" rel="stylesheet" type="text/css" />
    <script src="ol_v5.0.0/build/ol.js" type="text/javascript"></script>
</head>
<body>
    <div id="map"></div>
 
    <script>
        // Open Street Map地图
        var raster = new ol.layer.Tile({    
            source: new ol.source.OSM()
        });
        
        // 用于绘制线串的矢量图层源
        var source = new ol.source.Vector();
 
        // 用于绘制线串的矢量图层
        var vector = new ol.layer.Vector({
            source: source,
            style: styleFunction
        });
 
        var map = new ol.Map({
            target: 'map',
            layers: [
                raster, vector
            ],
            view: new ol.View({
                center: [-11000000, 4600000],
                zoom: 4
            })
        });
        
        // 添加一个绘制线串的控件
        map.addInteraction(new ol.interaction.Draw({
            source: source,
            type: 'LineString'
        }));
 
        // 用于设置线串所在的矢量图层样式的函数
        var styleFunction = function(feature){
            var geometry = feature.getGeometry();
            var styles = [
                new ol.style.Style({                    // 线串的样式
                    stroke: new ol.style.Stroke({
                        color: '#FC3',
                        width: 2
                    })
                })
            ];
            
            // 对线段的每一个子线段都设置箭头样式
            geometry.forEachSegment(function(start, end){
                var dx = end[0] - start[0];
                var dy = end[1] - start[1];
                var rotation = Math.atan2(dy, dx);      // 获取子线段的角度（弧度）
                //arrows
                styles.push(new ol.style.Style({        // 与线串的各个子线段对应的样式
                    geometry: new ol.geom.Point(end),
                    image: new ol.style.Icon({
                        src: 'data/arrow.png',
                        anchor: [0.75, 0.5],        // 图标锚点
                        rotateWithView: true,       // 与地图视图一起旋转
                        // 设置子线段箭头图标样式的角度
                        rotation: rotation         // 因为角度以顺时针旋转为正值，所以前面添加负号
                    })
                }));
            });
 
            return styles;
        };
    </script>
</body>
</html>
```
