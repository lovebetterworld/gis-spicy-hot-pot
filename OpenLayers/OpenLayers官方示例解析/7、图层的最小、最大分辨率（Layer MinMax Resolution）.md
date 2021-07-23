- [图层的最小、最大分辨率（Layer Min/Max Resolution）](https://blog.csdn.net/qq_35732147/article/details/84959088)

# 一、示例简介

    这个示例加载了一个MapBox的瓦片图层和一个Open Street Map的瓦片图层，同时使用最小、最大分辨率限制图层加载的比例级别。
    
    使用鼠标放大两次：MapBox图层就会被隐藏而OSM图层就会显示出来
    
    如果继续放大，OSM图层也会消失。
    
    这里使用了图层的minResolution和maxResolution选项来控制。
# 二、代码详解

```js
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Layer Min/Max Resolution</title>
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
                    source: new ol.source.OSM(),
                    minResolution: 200,             // 图层的最小分辨率，小于这个分辨率的瓦片不会被加载
                    maxResolution: 2000,            // 图层的最大分辨率，大于这个分辨率的瓦片不会被加载
                }),
                new ol.layer.Tile({
                    // 使用TileJSON的方式加载MapBox图层
                    source: new ol.source.TileJSON({
                        url: 'https://api.tiles.mapbox.com/v3/mapbox.natural-earth-hypso-bathy.json?secure',
                        crossOrigin: 'anonymous'
                    }),
                    minResolution: 2000,            // 图层的最小分辨率，小于这个分辨率的瓦片不会被加载
                    maxResolution: 20000            // 图层的最大分辨率，大于这个分辨率的瓦片不会被加载
                })
            ],
            view: new ol.View({
                center: [653600, 5723680],
                zoom: 5
            })
        });
    </script>       
</body>
</html>
```
