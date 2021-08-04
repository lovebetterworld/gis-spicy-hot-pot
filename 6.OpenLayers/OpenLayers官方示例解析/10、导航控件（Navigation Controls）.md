- [导航控件（Navigation Controls）](https://blog.csdn.net/qq_35732147/article/details/85004796)

# 一、示例简介

这个示例展示了如何使用地图定位控件（ol/Control/ZoomToExtent）。
在这个示例中，下面的导航控件将被添加到地图：

- ol/control/Zoom（默认添加）
- ol/control/ZoomToExtent

   ![img](https://img-blog.csdnimg.cn/20181214154011972.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

# 二、代码详解

```js
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Navigation Controls</title>
    <link href="ol_v5.0.0/css/ol.css" rel="stylesheet" type="text/css" />
    <script src="ol_v5.0.0/build/ol.js" type="text/javascript"></script>
</head>
<body>
    <div id="map"></div>
 
    <script>
        var map = new ol.Map({
            target: 'map',
            layers: [
                new ol.layer.Tile({
                    source: new ol.source.OSM()
                })
            ],
            controls: ol.control.defaults().extend([
                // 将用于将地图定位到指定范围的ZoomToExtent控件加入到地图的默认控件中
                new ol.control.ZoomToExtent({
                    extent: [                   // 指定要定位到的范围
                        813079.7791264898, 5929220.284081122,
                        848966.9639063801, 5936863.986909639
                    ]
                })
            ]),
            view: new ol.View({
                center: [0, 0],
                zoom: 2
            })
        });
 
    </script>
</body>
</html>
```
