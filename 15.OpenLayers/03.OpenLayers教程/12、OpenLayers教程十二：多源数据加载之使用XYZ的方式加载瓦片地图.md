- [OpenLayers教程十二：多源数据加载之使用XYZ的方式加载瓦片地图](https://blog.csdn.net/qq_35732147/article/details/94973411)



# 一、XYZ方式加载瓦片地图简介

前面已经讲过瓦片地图使用金字塔结构组织瓦片，可以说这是一个三维的结构，使用XYZ这样的坐标来精确定位一张瓦片。即Z用于表示地图层级，XY表示某个层级内的平面，X为横坐标，Y为纵坐标，类似于数学上常见的笛卡尔坐标系。

现在我们在浏览器中打开任意一个在线的网页地图，然后打开浏览器的开发者工具，再随意拖动、放大、缩小地图。之后在开发者工具里查看新发起的请求，是否有一些图片请求，查看请求返回的图片，是否为正在浏览的地图的一部分。如果是，则基本为瓦片地图。下面以百度地图为例，说明一下在线瓦片地图请求信息：

![img](https://img-blog.csdn.net/20180731175225825?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

在请求的url中，我们可以很明显地看到xyz这三个参数，这进一步说明了百度地图就是用了瓦片地图。如果你多分析一下现有的在线网页地图，基本都是瓦片地图。正因为如此，OpenLayers提供了ol.source.XYZ类这种通用的Source来加载广大的在线瓦片地图数据源，具备很好的适用性。通常情况下，开发者想要加载不同的在线瓦片地图源，则只需要更改ol.source.XYZ的构造参数中的url就可以了。

# 二、使用XYZ方式加载OpenStreetMap

比如我们就可以不用ol.source.OSM类，而用ol.source.XYZ来加载Open Street Map地图，结果一样：

![img](https://img-blog.csdnimg.cn/20190707115103110.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

loadOSM_XYZ.html:

```js
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>使用XYZ的方式加载OpenStreetMap</title>
    <link rel="stylesheet" href="../../v5.3.0/css/ol.css" />
    <script src="../../v5.3.0/build/ol.js"></script>
</head>
<body>
    <div id="map"></div>
    
    <script>
        var map = new ol.Map({
            target: 'map',
            layers: [
              new ol.layer.Tile({               // 使用XYZ的方式加载OpenStreetMap
                source: new ol.source.XYZ({
                    url: 'http://{a-c}.tile.openstreetmap.org/{z}/{x}/{y}.png'
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

# 三、使用XYZ方式加载高德地图

除了Open Street Map可以使用XYZ方式加载外，还有很多其他的在线瓦片地图源也可以，比如高德地图：

![img](https://img-blog.csdnimg.cn/20190707115842350.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

loadGaode_XYZ.html:

```js
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>使用XYZ方式加载高德地图</title>
    <link rel="stylesheet" href="../../v5.3.0/css/ol.css" />
    <script src="../../v5.3.0/build/ol.js"></script>
</head>
<body>
    <div id="map"></div>
    
    <script>
        var map = new ol.Map({
            target: 'map',
            layers: [
              new ol.layer.Tile({               // 使用XYZ方式加载高德地图
                source: new ol.source.XYZ({
                    url:'http://webst0{1-4}.is.autonavi.com/appmaptile?lang=zh_cn&size=1&scale=1&style=7&x={x}&y={y}&z={z}'
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

目前高德的瓦片地址有如下两种：

- http://wprd0{1-4}.is.autonavi.com/appmaptile?x={x}&y={y}&z={z}&lang=zh_cn&size=1&scl=1&style=7和
- http://webst0{1-4}.is.autonavi.com/appmaptile?style=7&x={x}&y={y}&z={z}

前者是高德的新版地址，后者是老版地址。

高德新版的参数：

- lang可以通过zh_cn设置中文，en设置英文；
- size基本无作用；
- scl设置标注还是底图，scl=1代表注记，scl=2代表底图（矢量或者影像）；
- style设置影像和路网，style=6为影像图，style=7为矢量路网，style=8为影像路网。

总结之：

- http://wprd0{1-4}.is.autonavi.com/appmaptile?x={x}&y={y}&z={z}&lang=zh_cn&size=1&scl=1&style=7 为矢量图（含路网、含注记）
- http://wprd0{1-4}.is.autonavi.com/appmaptile?x={x}&y={y}&z={z}&lang=zh_cn&size=1&scl=2&style=7 为矢量图（含路网，不含注记）
- http://wprd0{1-4}.is.autonavi.com/appmaptile?x={x}&y={y}&z={z}&lang=zh_cn&size=1&scl=1&style=6 为影像底图（不含路网，不含注记）
- http://wprd0{1-4}.is.autonavi.com/appmaptile?x={x}&y={y}&z={z}&lang=zh_cn&size=1&scl=2&style=6 为影像底图（不含路网、不含注记）
- http://wprd0{1-4}.is.autonavi.com/appmaptile?x={x}&y={y}&z={z}&lang=zh_cn&size=1&scl=1&style=8 为影像路图（含路网，含注记）
- http://wprd0{1-4}.is.autonavi.com/appmaptile?x={x}&y={y}&z={z}&lang=zh_cn&size=1&scl=2&style=8 为影像路网（含路网，不含注记）

高德旧版可以通过style参数设置影像、矢量、路网。

总结之：

- http://webst0{1-4}.is.autonavi.com/appmaptile?style=6&x={x}&y={y}&z={z} 为影像底图（不含路网，不含注记）
- http://webst0{1-4}.is.autonavi.com/appmaptile?style=7&x={x}&y={y}&z={z} 为矢量地图（含路网，含注记）
- http://webst0{1-4}.is.autonavi.com/appmaptile?style=8&x={x}&y={y}&z={z} 为影像路网（含路网，含注记）

# 四、使用XYZ方式加载雅虎地图（Yahoo）

![img](https://img-blog.csdnimg.cn/20190707120717341.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

loadYahoo_XYZ.html:

```js
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>使用XYZ方式加载雅虎地图</title>
    <link rel="stylesheet" href="../../v5.3.0/css/ol.css" />
    <script src="../../v5.3.0/build/ol.js"></script>
</head>
<body>
    <div id="map"></div>
    
    <script>
        var map = new ol.Map({
            target: 'map',
            layers: [
              new ol.layer.Tile({               // 使用XYZ方式加载雅虎地图
                source: new ol.source.XYZ({
                    url:'https://{0-3}.base.maps.api.here.com/maptile/2.1/maptile/newest/normal.day/{z}/{x}/{y}/512/png8?lg=ENG&ppi=250&token=TrLJuXVK62IQk0vuXFzaig%3D%3D&requestid=yahoo.prod&app_id=eAdkWGYRoc4RfxVo0Z4B',
                    tileSize: 512               // 设置对应的瓦片大小
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
大同小异，非常简单。上面的三个例子，只有Yahoo地图的代码有点不一样：多了tileSize参数的设置。

默认情况下，tileSize为256，这也是现在绝大多数瓦片采用的大小。但Yahoo地图使用的是512，所以我们需要指定。