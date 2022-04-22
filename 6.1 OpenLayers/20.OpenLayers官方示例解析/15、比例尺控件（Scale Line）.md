- [OpenLayers官方示例详解十五之比例尺控件（Scale Line）](https://blog.csdn.net/qq_35732147/article/details/85251980)



# 一、示例简介

本示例展示了如何创建一个比例尺控件（ol.control.ScaleLine），同时让比例尺控件的单位根据用户的选择而改变。

OpenLayers中比例尺控件支持的单位有：

- metric    ——    通用的，以千米为单位
- us    ——    美国单位
- nautical    ——    航海单位
- imperial    ——    英制单位
- degrees    ——    以度、分、秒为单位



# 二、代码详解

```js
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Scale Line</title>
    <link href="ol_v5.0.0/css/ol.css" rel="stylesheet" type="text/css" />
    <script src="ol_v5.0.0/build/ol.js" type="text/javascript"></script>
</head>
<body>
    <div id="map"></div>
    <select id="units">
        <option value="degrees">degrees</option>
        <option value="imperial">imperial inch</option>
        <option value="us">us inch</option>
        <option value="nautical">nautical mile</option>
        <option value="metric" selected>metric</option>
    </select>
    
    <script>
        // 创建一个比例尺控件
        var scaleLineControl = new ol.control.ScaleLine({
            units: 'metric'             // 比例尺默认的单位
        });
 
        var map = new ol.Map({
            target: 'map',
            controls: ol.control.defaults().extend([
                scaleLineControl        // 将比例尺控件添加到地图中
            ]),
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
 
        var unitsSelect = document.getElementById('units');
        // 让地图的比例尺单位根据用户的选择而改变
        unitsSelect.addEventListener('change', function(){
            scaleLineControl.setUnits(unitsSelect.value);
        }, false);
    </script>
</body>
</html>
```
