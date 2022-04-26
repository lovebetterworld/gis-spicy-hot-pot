# Openlayers官方示例详解十二之通过XYZ方式加载瓦片地图

原文地址：https://blog.csdn.net/qq_35732147/article/details/85088639

# 一、示例简介

这个示例展示了通过XYZ格式的URL访问瓦片地图数据，有关XYZ方式加载瓦片地图可以参考这篇文章：万能瓦片加载秘籍。

本示例加载的瓦片地图是Thunderforest的地图数据，Thunderforest的官网地址是：http://www.thunderforest.com/


注意它不是完全免费的开源地图，它的收费规则是：

所以，可以免费使用于个人的爱好项目上。

# 二、代码详解

```js
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>XYZ</title>
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
                    source: new ol.source.XYZ({     // 使用XYZ方式加载瓦片地图
                        url: 'https://tile.thunderforest.com/cycle/{z}/{x}/{y}.png?apikey=你注册的Thunderforest的Key'
                    })
                })
            ],
            view: new ol.View({
                center: [-472202, 7530279],
                zoom: 12
            })
        });
    </script>
</body>
</html>
```
加载结果：

# ![img](https://img-blog.csdnimg.cn/20181219093211633.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)三、补充

许多瓦片地图厂商为了提高瓦片数据加载的效率，往往提供了多个瓦片数据路径（URL），如果为应用程序赋予从多条数据路径选择最优路径的功能，那就能提高瓦片数据加载的效率。

OpenLayers正是有这样的功能，来看通过多条瓦片数据路径加载高德地图的示例：

```js
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>加载高德地图</title>
    <link href="ol_v5.0.0/css/ol.css" rel="stylesheet" type="text/css" />
    <script src="ol_v5.0.0/build/ol.js" type="text/javascript"></script>
</head>
<body>
    <div id="map"></div>
 
    <script>
        var urls = [];      // 用于保存高德瓦片地图的所有数据路径(URL)
        for(var i = 0; i < 4; i++){
            urls[i] = 'http://wprd0' + (i + 1) + '.is.autonavi.com/appmaptile?x={x}&y={y}&z={z}&lang=zh_cn&size=1&scl=1&style=7'
        }
        var map = new ol.Map({
            target: 'map',
            layers: [
                new ol.layer.Tile({
                    source: new ol.source.XYZ({
                        urls: urls,     // 注意这里，这里使用的是所有高德地图瓦片地图路径组成的数组
                    })
                })
            ],
            view: new ol.View({
                center: [0, 0],
                zoom: 5
            })
        });
    </script>
</body>
</html>
```
