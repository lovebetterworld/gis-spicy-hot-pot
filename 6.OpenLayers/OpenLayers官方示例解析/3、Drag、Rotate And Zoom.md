- [Drag、Rotate And Zoom](https://blog.csdn.net/qq_35732147/article/details/82969495)

# 一、示例简介

    这个示例实现了按键Shift加上鼠标拖拽来围绕中心点旋转和缩放地图的功能
# 二、代码详解

首先了解一下本示例将用到的ol.interaction.DragRotateAndZoom类。

ol.interaction.DragRotateAndZoom控件允许用户通过鼠标点击和拖拽来缩放和旋转地图，默认情况下，该控件仅限于按住Shift键时起作用。

这个控件仅支持鼠标设备，并且这个控件不包括在默认控件中，必须由我们自行添加。

代码比较简单：

```js
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Drag, Rotate, and Zoom</title>
    <link href="ol_v5.0.0/css/ol.css" rel="stylesheet" type="text/css" />
    <script src="ol_v5.0.0/build/ol.js" type="text/javascript"></script>
</head>
<body>
    <div id="map"></div>
 
    <script>
        var map = new ol.Map({
            //将DragRotateAndZoom控件添加到地图
            interactions: ol.interaction.defaults().extend([      
                new ol.interaction.DragRotateAndZoom()
            ]),
            layers: [
                new ol.layer.Tile({
                    source: new ol.source.OSM()
                })
            ],
            target: 'map',
            view: new ol.View({
                center: [0, 0],
                zoom: 2
            })
        });
    </script>
</body>
</html>
```
官方示例地址：http://openlayers.org/en/latest/examples/drag-rotate-and-zoom.html