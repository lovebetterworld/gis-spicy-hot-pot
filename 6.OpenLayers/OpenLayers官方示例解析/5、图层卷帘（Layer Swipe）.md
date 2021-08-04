- [图层卷帘（Layer Swipe）](https://blog.csdn.net/qq_35732147/article/details/84839101)

# 一、示例简介

在地图视口中构建一个卷帘，鼠标拉动这个卷帘，能够同时改变两个图层显示的大小。
    
图层卷帘效果：

![img](https://img-blog.csdnimg.cn/20181205165459359.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

# 二、代码详解

```js
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Layer Swipe</title>
    <link href="ol_v5.0.0/css/ol.css" rel="stylesheet" type="text/css" />
    <script src="ol_v5.0.0/build/ol.js" type="text/javascript"></script>
</head>
<body>
    <div id="map"></div>
    <!-- 用于控制卷帘位置的元素 -->
    <input id="swipe" type="range" />
 
    <script>
        // oepn street map
        var osm = new ol.layer.Tile({
            source: new ol.source.OSM()
        });
        
        // 微软Bing地图
        var bing = new ol.layer.Tile({
            source: new ol.source.BingMaps({
                key: '-- Bing地图的key，可以直接去官网申请',
                imagerySet: 'Aerial'
            })
        });
 
        var map = new ol.Map({
            target: 'map',
            layers: [
                osm, bing           
            ],
            view: new ol.View({
                center: [0, 0],
                zoom: 2
            })
        });
        
        var swipe = document.getElementById('swipe');   // 用于控制卷帘位置的DOM元素
 
        bing.on('precompose', function(event){          // 在Bing地图渲染之前触发
            var ctx = event.context;                 //获得canvas渲染上下文
            var width = ctx.canvas.width * (swipe.value / 100);  // 用于保存卷帘的位置
            
            ctx.save();                 // 保存canvas设置
            ctx.beginPath();            // 开始绘制路径
            ctx.rect(width, 0, ctx.canvas.width - width, ctx.canvas.height);    // 绘制矩形
            ctx.clip();                 // 裁剪Bing地图，以形成卷帘效果
        })
        
        bing.on('postcompose', function(event){     // 在Bing地图渲染之后触发
            var ctx = event.context;
            ctx.restore();              // 恢复canvas设置
        });
 
        swipe.addEventListener('input', function(){     // 在每次用户改变swipe控件时触发
            map.render();               // 渲染地图
        }, false);
    </script>
</body>
</html>
```
官方示例地址：http://openlayers.org/en/latest/examples/layer-swipe.html