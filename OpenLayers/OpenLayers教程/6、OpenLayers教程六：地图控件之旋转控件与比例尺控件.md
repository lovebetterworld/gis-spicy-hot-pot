- [OpenLayers教程六：地图控件之旋转控件与比例尺控件](https://blog.csdn.net/qq_35732147/article/details/91431524)

# 一、地图旋转控件

地图旋转控件（ol.control.Rotate）默认被自动加入到地图中，所以每一个使用OpenLayers创建的地图中都包含了旋转控件。

simple_map.html:

    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <title>Simple Map</title>
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
                })
            });
        </script>
    </body>
    </html>
    

 使用浏览器打开simple_map.html，同时按住键盘的Shift键+Alt键，然后用鼠标拖拽地图，可以使地图旋转：

![img](https://img-blog.csdnimg.cn/20190611140608887.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

此时地图右上角会出现一个复位键，点击它可以让地图恢复原始角度。

# 二、比例尺控件

OpenLayers使用ol.control.ScaleLine类实现了地图比例尺功能。

scaleLine.html:

```js
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Simple Map</title>
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
            // 实例化一个ScaleLine类的实例并加入到地图
            controls: ol.control.defaults().extend([
                new ol.control.ScaleLine()         
            ])
        });
    </script>
</body>
</html>
```
用浏览器打开scaleLine.html，可以发现地图的左下角渲染出了一个比例尺控件：

![img](https://img-blog.csdnimg.cn/20190611141616637.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

可以发现，这里比例尺控件使用的单位是km，如果想使用其他单位，可以修改ScaleLine类中的units属性。

units属性接受"degrees"、"imperial"、"us"、"nautical"或"metric"（默认为”metric")。