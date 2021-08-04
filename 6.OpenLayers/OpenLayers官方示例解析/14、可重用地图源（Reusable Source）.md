- [OpenLayers官方示例详解十四之可重用地图源（Reusable Source）](https://blog.csdn.net/qq_35732147/article/details/85251609)

# 一、示例简介

    这个示例展示如何更新地图中的瓦片。
    
    可以调用source.setUrl()来更新瓦片地图源的URL，请注意，当更改瓦片地图源的URL时，在加载完新的瓦片之前，将不会替换现有的瓦片。
    
    如果想要清除当前呈现的瓦片，则可以调用source.refresh()方法。
# 二、代码详解

```js
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Reusable Source</title>
    <link href="ol_v5.0.0/css/ol.css" rel="stylesheet" type="text/css" />
    <script src="ol_v5.0.0/build/ol.js" type="text/javascript"></script>
</head>
<body>
    <div id="map"></div>
    <button class="switcher" value="0">January</button>
    <button class="switcher" value="1">January (with bathymetry)</button>
    <button class="switcher" value="2">July</button>
    <button class="switcher" value="3">July (With bathymetry)</button>
 
    <script>
        // 有mapbox瓦片地图url组成的数组
        var urls = [
            'https://{a-c}.tiles.mapbox.com/v3/mapbox.blue-marble-topo-jan/{z}/{x}/{y}.png',
            'https://{a-c}.tiles.mapbox.com/v3/mapbox.blue-marble-topo-bathy-jan/{z}/{x}/{y}.png',
            'https://{a-c}.tiles.mapbox.com/v3/mapbox.blue-marble-topo-jul/{z}/{x}/{y}.png',
            'https://{a-c}.tiles.mapbox.com/v3/mapbox.blue-marble-topo-bathy-jul/{z}/{x}/{y}.png'
        ];
 
        // 瓦片地图源
        var source = new ol.source.XYZ();
 
        var map = new ol.Map({
            target: 'map',
            layers: [
                new ol.layer.Tile({
                    source: source
                })
            ],
            view: new ol.View({
                center: [0, 0],
                zoom: 2
            })
        });
 
        function updateUrl(index){
            source.setUrl(urls[index]);     // 改变瓦片地图源的url
        }
 
        var buttons = document.getElementsByClassName('switcher');  
        for(var i = 0, len = buttons.length; i < len; i++){
            var button = buttons[i];
            // 让瓦片地图的url随用户点击按钮而变化
            button.addEventListener('click', updateUrl.bind(null, Number(button.value)));
        }
 
        updateUrl(0);       // 先预设置瓦片地图
    </script>
</body>
</html>
```
