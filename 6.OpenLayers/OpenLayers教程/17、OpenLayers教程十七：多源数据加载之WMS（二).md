- [OpenLayers教程十七：多源数据加载之WMS（二)](https://blog.csdn.net/qq_35732147/article/details/96474406)



# 一、单一图像WMS

WMS可以作为图像图层来使用，即WMS只从服务器传送一张图像到客户端，这就是Single Image WMS（单一图像WMS）。

WMS也可以作为瓦片图层来使用，即WMS从服务器传送多张瓦片到客户端，这就是Tiled WMS（瓦片WMS）。

瓦片可以在客户端被缓存，所以相比单一图像WMS，瓦片WMS不需要再从服务器请求已经浏览过的范围的地图数据。

然而瓦片在重复注记这一种情况下可能会出现问题，看本文下面的瓦片WMS地图就会发现有的一块区域里含有两个一模一样的注记。在这种情况下，单一图像WMS将会有更好的制图效果。

来看单一图像WMS的一个示例：

![img](https://img-blog.csdnimg.cn/2019071909581289.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

singleImageWMS.html:

```js
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>单一图像WMS</title>
    <link rel="stylesheet" href="../../v5.3.0/css/ol.css" />
    <script src="../../v5.3.0/build/ol.js"></script>
</head>
<body>
    <div id="map"></div>
 
    <script>
        // 创建地图
        let map = new ol.Map({
            target: 'map',
            layers: [
                new ol.layer.Tile({             // 底图
                    source: new ol.source.OSM()
                }),
                new ol.layer.Image({
                    source: new ol.source.ImageWMS({
                        url: 'https://ahocevar.com/geoserver/wms',  // WMS服务的URL.
                        // WMS请求参数
                        params: {
                            'LAYERS': 'topp:states'    // 请求的图层名
                        },
                        ratio: 1,                      // 1表示请求的图像是地图视图的大小。
                        serverType: 'geoserver'        // 服务器类型
                    })
                })
            ],
            view: new ol.View({
                center: [-10997148, 4569099],
                zoom: 4
            })
        });
    </script>
</body>
</html>
```

打开浏览器的控制台，可以发现真的只请求了一张WMS的图片：

![img](https://img-blog.csdnimg.cn/20190719095932210.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

# 二、瓦片WMS

来看瓦片WMS的示例：

![img](https://img-blog.csdnimg.cn/20190719101001148.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

tiledWMS.html:

```js
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>瓦片WMS</title>
    <link rel="stylesheet" href="../../v5.3.0/css/ol.css" />
    <script src="../../v5.3.0/build/ol.js"></script>
</head>
<body>
    <div id="map"></div>
 
    <script>
        // 创建地图
        let map = new ol.Map({
            target: 'map',
            layers: [
                new ol.layer.Tile({             // 底图
                    source: new ol.source.OSM()
                }),
                new ol.layer.Tile({
                    // 注意这里用的是TileWMS类而不是ImageWMS类
                    source: new ol.source.TileWMS({
                        url: 'https://ahocevar.com/geoserver/wms',  // WMS服务的URL.
                        // WMS请求参数
                        params: {
                            'LAYERS': 'topp:states'    // 请求的图层名
                        },
                        serverType: 'geoserver',       // 服务器类型
                        transition: 5000               // 呈现不透明度转换的持续时间
                    })
                })
            ],
            view: new ol.View({
                center: [-10997148, 4569099],
                zoom: 4
            })
        });
    </script>
</body>
</html>
```

可以发现，瓦片WMS使用的图层源类是TileWMS类，单一图像WMS使用的图层源类是ImageWMS类。

另外，这里故意把transition这个参数设置成5000（毫秒），所以打开地图就能明显看到地图不透明度的转换，如果不想要这种转换可以把transition设置成0。

打开浏览器的控制台，可以发现服务器真的是传送了很多张WMS瓦片到客户端：

![img](https://img-blog.csdnimg.cn/20190719101354499.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)