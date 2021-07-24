- [OpenLayers教程五：地图控件之坐标拾取控件和鹰眼控件](https://blog.csdn.net/qq_35732147/article/details/91377382)



# 一、坐标拾取控件

很多时候我们想要实时获取鼠标光标指示处对应的坐标，就像高德地图的坐标拾取：https://lbs.amap.com/console/show/picker

OpenLayers提供的ol.control.MousePosition类也能够实现坐标拾取功能。

MousePosition.html:

```js
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>mousePosition</title>
    <link rel="stylesheet" href="../v5.3.0/css/ol.css" />
    <script src="../v5.3.0/build/ol.js"></script>
</head>
<body>
    <div id="map"></div>
 
    <script>
        let map = new ol.Map({
            target: 'map',                          // 关联到对应的div容器
            layers: [
                new ol.layer.Tile({                 // 瓦片图层
                    source: new ol.source.OSM()     // OpenStreetMap数据源
                })
            ],
            view: new ol.View({                     // 地图视图
                projection: 'EPSG:3857',
                center: [0, 0],
                zoom: 0
            }),
            controls: ol.control.defaults().extend([
                new ol.control.MousePosition()      // 实例化坐标拾取控件，并加入地图
            ])
        });
    </script>
</body>
</html>
```

 上面代码初始化了一个ol.control.MousePosition类的实例，并加入到地图。

坐标拾取控件效果：

![img](https://img-blog.csdnimg.cn/20190610151813906.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

# 二、鹰眼控件

鹰眼图是GIS中的一个基本的功能，鹰眼图，顾名思义，在鹰眼图上可以像从空中俯视一样查看地图框中所显示的地图在整个图中的位置。

OpenLayers提供的ol.control.OverviewMap类可以实现鹰眼图。

overviewMap.html:

```js
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>overviewMap</title>
    <link rel="stylesheet" href="../v5.3.0/css/ol.css" />
    <script src="../v5.3.0/build/ol.js"></script>
</head>
<body>
    <div id="map"></div>
 
    <script>
        let map = new ol.Map({
            target: 'map',                          // 关联到对应的div容器
            layers: [
                new ol.layer.Tile({                 // 瓦片图层
                    source: new ol.source.OSM()     // OpenStreetMap数据源
                })
            ],
            view: new ol.View({                     // 地图视图
                projection: 'EPSG:3857',
                center: [0, 0],
                zoom: 0
            }),
            controls: ol.control.defaults().extend([
                new ol.control.OverviewMap({        // 实例化一个OverviewMap类的对象，并加入到地图中
                    collapsed: false
                })        
            ])
        });
    </script>
</body>
</html>
```

鹰眼图效果：

![img](https://img-blog.csdnimg.cn/20190610153043499.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)