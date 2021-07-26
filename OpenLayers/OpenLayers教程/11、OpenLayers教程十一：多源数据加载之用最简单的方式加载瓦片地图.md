- [OpenLayers教程十一：多源数据加载之用最简单的方式加载瓦片地图](https://blog.csdn.net/qq_35732147/article/details/94844440)


OpenLayers封装了一些瓦片地图源类用于加载瓦片地图，这些类包括：

- ol.source.OSM    ——    用于加载OpenStreetMap

- ol.source.Stamen    ——    用于加载Stamen Map

- ol.source.BingMaps    ——    用于加载Bing Map

# 一、加载OpenStreetMap

![img](https://img-blog.csdnimg.cn/20190706131045286.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

loadOSM.html:
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>加载OpenStreetMap</title>
    <link rel="stylesheet" href="../../v5.3.0/css/ol.css" />
    <script src="../../v5.3.0/build/ol.js"></script>
</head>
<body>
    <div id="map"></div>
    
    <script>
        var map = new ol.Map({
            target: 'map',
            layers: [
              new ol.layer.Tile({               // 加载OpenStreetMap
                source: new ol.source.OSM()
              })
            ],
            view: new ol.View({
              center: [0, 0],
              zoom: 3
            })
        });
    </script>
</body>
</html>
```

打开浏览器控制台，可以发现瓦片一块一块从服务器被取回到浏览器：

![img](https://img-blog.csdnimg.cn/20190706123705185.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

# 二、加载Stamen Map

![img](https://img-blog.csdnimg.cn/20190706125122787.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

loadStamenMap.html:
    
```js
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>加载Stamen Map</title>
    <link rel="stylesheet" href="../../v5.3.0/css/ol.css" />
    <script src="../../v5.3.0/build/ol.js"></script>
</head>
<body>
    <div id="map"></div>
    
    <script>
        var map = new ol.Map({
            target: 'map',
            layers: [
              new ol.layer.Tile({               // 加载Stamen Map
                source: new ol.source.Stamen({
                    layer: 'watercolor'         // 指定加载的图层名，可以被替换为'toner'或'terrain'
                })
              })
            ],
            view: new ol.View({
              center: [0, 0],
              zoom: 3
            })
        });
    </script>
</body>
</html>
```

# 三、加载Bing Map

![img](https://img-blog.csdnimg.cn/20190706130353873.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

loadBingMap.html:

```js
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>加载Bing Map</title>
    <link rel="stylesheet" href="../../v5.3.0/css/ol.css" />
    <script src="../../v5.3.0/build/ol.js"></script>
</head>
<body>
    <div id="map"></div>
    
    <script>
        var map = new ol.Map({
            target: 'map',
            layers: [
              new ol.layer.Tile({               // 加载Bing Map
                source: new ol.source.BingMaps({
                    // Bing Map的key，可以去官网申请
                    key: 'AkjzA7OhS4MIBjutL21bkAop7dc41HSE0CNTR5c6HJy8JKc7U9U9RveWJrylD3XJ',    
                    imagerySet: 'AerialWithLabels'  // 指定加载的图层名，还可以替换为'Aerial'或'Road'
                })
              })
            ],
            view: new ol.View({
              center: [0, 0],
              zoom: 3
            })
        });
    </script>
</body>
</html>
```