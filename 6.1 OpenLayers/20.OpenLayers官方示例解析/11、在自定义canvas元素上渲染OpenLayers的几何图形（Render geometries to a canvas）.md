- [在自定义canvas元素上渲染OpenLayers的几何图形（Render geometries to a canvas）](https://blog.csdn.net/qq_35732147/article/details/85052581)

# 一、示例简介

    这个示例展示了如何将OpenLayers的几何图形渲染到任意的canvas元素上。

![img](https://img-blog.csdnimg.cn/20181217172908925.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

# 二、代码详解

```js
ol.render.toContext()方法能够将任意canvas元素的绘图上下文对象封装成OpenLayers的ol.render.canvas.CanvasImmediateRender对象。

ol.render.canvas.CanvasImmediateRenderer对象具有绘制OpenLayers的几何图形的功能。

通过这种封装，就可以将OpenLayers的几何图形渲染到任意的canvas元素上了。

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Render geometries to a canvas</title>
    <link href="ol_v5.0.0/css/ol.css" rel="stylesheet" type="text/css" />
    <script src="ol_v5.0.0/build/ol.js" type="text/javascript"></script>
</head>
<body>
    <canvas id="canvas"></canvas>
 
    <script>
        var canvas = document.getElementById('canvas');     // 获得自定的canvas元素对象
 
        // 将自定义的canvas对象的绘图上下文对象封装成openlayers的ol.render.canvas.canvasImmediateRenderer对象
        var vectorContext = ol.render.toContext(canvas.getContext('2d'), {
            size: [100, 100]
        });
 
        // 样式对象
        var fill = new ol.style.Fill({
                color: 'blue'
        });
        var stroke = new ol.style.Stroke({
            color: 'black'
        });
        var style = new ol.style.Style({
            fill: fill,
            stroke: stroke,
            image: new ol.style.Circle({
                radius: 10, 
                fill: fill,
                stroke: stroke
            })
        });
        vectorContext.setStyle(style);      // 为canvasImmediateRenderer对象设置样式
 
        // 在自定义canvas元素上绘制openlayers的图形
        vectorContext.drawGeometry(new ol.geom.LineString([[10, 10], [90, 90]]));
        vectorContext.drawGeometry(new ol.geom.Polygon([[[2, 2], [98, 2], [2, 98], [2, 2]]]));
        vectorContext.drawGeometry(new ol.geom.Point([88, 88]));
    </script>
</body>
</html>
```
