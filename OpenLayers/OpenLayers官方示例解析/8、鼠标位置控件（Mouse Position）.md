- [鼠标位置控件（Mouse Position）](https://blog.csdn.net/qq_35732147/article/details/84988943)

# 一、示例简介

    使用鼠标位置控件（ol/control/MousePosition）来动态显示地图上鼠标光标的坐标
    
    并且可以由用户调整投影和坐标精度。
# 二、代码详解

```js
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Mouse Position</title>
    <link href="ol_v5.0.0/css/ol.css" rel="stylesheet" type="text/css" />
    <script src="ol_v5.0.0/build/ol.js" type="text/javascript"></script>
</head>
<body>
    <div id="map"></div>
    <div id="mouse-position"></div>
    <form>
        <label>Projection</label>
        <select id="projection">
            <option value="EPSG:4326">EPSG:4326</option>
            <option value="EPSG:3857">EPSG:3857</option>
        </select>
        <label>Precision</label>
        <input id="precision" type="number" min="0" max="12" value="4" />
    </form>
 
    <script>
        // 创建MousePosition控件
        var mousePositionControl = new ol.control.MousePosition({   
            coordinateFormat: ol.coordinate.createStringXY(4),      // 将坐标保留4位小数位，并转换为字符串
            projection: 'EPSG:4326',                                // 定义投影
            className: 'custom-mouse-position',                     // 控件的CSS类名
            target: document.getElementById('mouse-position'),      // 将控件渲染在该DOM元素中
            undefinedHTML: '&nbsp;'                                 // 鼠标离开地图时，显示空格
        });
 
        var map = new ol.Map({
            target: 'map',
            controls: ol.control.defaults().extend([mousePositionControl]),  // 将鼠标位置控件加入到地图默认控件中
            layers: [
                new ol.layer.Tile({
                    source: new ol.source.OSM()     // 加入Open Street Map图层
                })
            ],
            view: new ol.View({
                center: [0, 0],
                zoom: 2
            })
        });
 
        var projectionSelect = document.getElementById("projection");   // 选取投影的控件
        projectionSelect.addEventListener('change', function(event){
            // 使mousePositionControl控件的投影与选取投影控件选取的投影一致
            mousePositionControl.setProjection(event.target.value);    
        });
        
        var precisionInput = document.getElementById('precision');
        precisionInput.addEventListener('change', function(event){
            // 设置mousePositionControl控件的坐标格式
            var format = ol.coordinate.createStringXY(event.target.valueAsNumber);
            mousePositionControl.setCoordinateFormat(format);
        });
    </script>
</body>
</html>
```
    ol.coordinate.createStringXY()这个方法可以用于设置坐标的格式，
    
    这个方法接收要保留的坐标小数位位数参数，并返回一个可以将坐标格式化为保留特定小数位的坐标字符串。