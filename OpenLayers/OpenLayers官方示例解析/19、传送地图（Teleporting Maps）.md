- [OpenLayers官方示例详解十九之传送地图（Teleporting Maps）](https://blog.csdn.net/qq_35732147/article/details/85779168)



# 一、示例简介

    单击"Teleport"按钮，将地图从一个目标要素移动到另一个目标要素。
# 二、代码详解

```js
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Teleporting Maps</title>
    <link href="ol_v5.0.0/css/ol.css" rel="stylesheet" type="text/css" />
    <script src="ol_v5.0.0/build/ol.js" type="text/javascript"></script>
</head>
<body>
    <div id="map1"></div>
    <div id="map2"></div>
    <button id="teleport">Teleport</button>
 
    <script>
        var map = new ol.Map({
            layers: [
                new ol.layer.Tile({
                    source: new ol.source.OSM()
                })
            ],
            view: new ol.View({
                center: [0, 0],
                zoom: 2
            })
        });
        map.setTarget('map1');      // 设置要呈现地图的目标要素
 
        var teleportButton = document.getElementById('teleport');
 
        teleportButton.addEventListener('click', function(){
            // 改变要呈现地图的目标要素
            var target = map.getTarget() === 'map1' ? 'map2' : 'map1';
            map.setTarget(target);
        }, false);
    </script>
</body>
</html>
```