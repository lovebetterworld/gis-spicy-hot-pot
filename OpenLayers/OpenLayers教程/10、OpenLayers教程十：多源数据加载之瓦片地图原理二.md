- [OpenLayers教程十：多源数据加载之瓦片地图原理二](https://blog.csdn.net/qq_35732147/article/details/94595658)



# 一、瓦片计算

## 1.1、切片方式

如果对整个地球图片进行切片，需要考虑的是整个地球图片大小，以及切片规则，切片（瓦片）大小。

对于WebGIS而言，在线地图几乎都采用Web墨卡托投影坐标系（EPSG:3857，后面会详解介绍)，地球投影到平面上就是一个正方形。为了方便使用，切片时大多按照正方形的方式来进行切片，比如大小为256*256的瓦片（单位像素），一个1024*1024的地图，就可以切片4张小的256*256的瓦片。

瓦片大小几乎都是256*256，有一些则会增加到512*512（由于以前的屏幕分辨率通常比较低，所以256*256的瓦片在低分辨率的屏幕上显示效果比较好，随着屏幕分辨率的提高，瓦片大小自然就会增加到512*512。但目前主流仍是256*256大小的瓦片）。

LOD会使得不同层级下的全球地图大小不一致，结合瓦片地图技术一起，就出现了金字塔瓦片结构：

![img](https://img-blog.csdn.net/20180807111850745?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

在金字塔瓦片结构中，上一层级的一张瓦片，在更大一层级中，会用4张瓦片来表示，依次类推，比如上一篇文章中看到的Google在线瓦片地图的第0级和第1级的瓦片地图就呈现这样的规律。这样做可以维持正方形的投影方式不变，同时按照2的幂次方放大（瓦片的边长），计算效率非常高。

## 1.2、瓦片数量计算

通过上面切片的介绍，我们可以对每一层级拥有的瓦片的数量进行简单的计算：

- 层级0的瓦片数是 1 = 2^0 ∗ 2^0

- 层级1的瓦片数是 4 = 2^1 * 2^1

- 层级2的瓦片数是 16 = 2^2 * 2^2

- 层级3的瓦片数是 64 = 2^3 * 2^3

- 层级z的瓦片数是 2^z * 2^z

## 1.3、瓦片坐标系 

从以上的金字塔瓦片结构可以看出来，瓦片的组织方式是三维的，因此对一幅地图进行切片时，需要给每一块瓦片进行详细的编号，即需要指定每一块瓦片的行号、列号以及层级数。

这个问题就涉及到了瓦片坐标系，瓦片坐标系是瓦片地图的组织参考框架。它规定每一块瓦片的行号、列号以及层级数，另外，在瓦片坐标系中列号一般从左到右方向递增，而在瓦片坐标系中行号有可能沿着从上到下的方向递增，或者从下到上递增，所以不同的瓦片坐标系的起始点（原点）不同。

不同的在线地图服务商，可能定义不一样的瓦片坐标系，瓦片坐标系不一样，那么对应的同一个位置的瓦片的坐标也会不一样。需要引起重视。

OpenLayers提供了一个用于调试瓦片坐标系的ol.source.TileDebug类。借助这个类，我们可以清晰的看到每一个瓦片的坐标：

![img](https://img-blog.csdn.net/20180807113910407?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

代码如下：


```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>查看瓦片坐标</title>
    <link rel="stylesheet" href="../../v5.3.0/css/ol.css" />
    <script src="../../v5.3.0/build/ol.js"></script>
</head>
<body>
    <div id="map"></div>
 
    <script>
        let osmSource = new ol.source.OSM();
        var map = new ol.Map({
            layers: [
                // 加载Open Street Map地图
                new ol.layer.Tile({
                    source: osmSource
                }),
                // 添加一个显示OSM地图的瓦片网格的图层
                new ol.layer.Tile({
                    source: new ol.source.TileDebug({
                        projection: 'EPSG:3857',            // Web墨卡托投影坐标系
                        tileGrid: osmSource.getTileGrid()   // 获取OSM地图的瓦片坐标系
                    })
                })
            ],
            target: 'map',
            view: new ol.View({
                center: ol.proj.transform([104, 30], 'EPSG:4326', 'EPSG:3857'),
                zoom: 10
            })
        });
    </script>
</body>
</html>
```

首先从上图可以看到地图上多了网格，每一个网格对应的就是一个瓦片。

其次网格中有三个数字，这些数字就表示当前瓦片的坐标：

第一个数字是层级z

第二个数字是表示经度方向上的x（列号）

第三个数字是表示纬度方向上的y（行号）

# 二、分辨率

## 2.1、分辨率简介

分辨率的简单定义是屏幕上的1像素表示的现实世界的地面实际距离。

上一节说到了金字塔瓦片结构中每一个层级，会使用不同数量的瓦片来表示整个地球，那么无论是哪一个层级，所表示的实际地理空间范围都是一致的，但使用的瓦片个数却是不一样的。

以Google在线地图为例，层级0使用了一个瓦片，层级1使用了4个瓦片。通过计算可以知道层级0的整个地球图像（瓦片）为256*256像素大小，层级1整个地球图像为512*512像素大小。而层级0和层级1表示的地球范围都是一样的（经度[-180°, 180°]，纬度[-90°, 90°]）。在层级0的时候，一个像素在水平方向就表示360°/256 = 1.40625°这么长的经度范围（以度为单位），在竖直方向就表示180°/256 = 0.703125°这么长的纬度范围（以度为单位）。而这两个数字就是分辨率了，即一个像素所表示的现实世界的范围是多少，这个范围可能是度（在地理坐标系统中），可能是米（在投影坐标系统中），或者其他单位，根据具体的情况而定。

## 2.2、Web墨卡托投影坐标系中的分辨率

我们知道，在WebGIS中使用的在线瓦片地图是采用的Web墨卡托（Mercator）投影坐标系（可以查看这篇文章-墨卡托投影-来了解详细内容），经过投影后，整个地球是一个正方形，所能表示的地球范围为：

经度[-180°, 180°]，纬度[-85°, 85°]，单位为度。

对应的Web墨卡托坐标系的范围为：

x[-20037508.3427892, 20037508.3427892]，范围y同样是[-20037508.3427892, 20037508.3427892]，单位为米。

或许，你会好奇这个范围是怎么计算而来的，如果详细了解过它的定义，应该知道Web墨卡托投影只是简单的把地球球面剖开拉伸为一个正方形，由于南北极两端采用这种拉伸会严重变形，并且南北极在使用过程中很少用到，所以干脆就只投影了地球的[-85, 85]纬度范围。然后在经度-180度（或+180）的地方从上到下剖开地球，然后按照赤道方向来展开成一张平面，那么这个平面的边长，就等于以地球赤道半径按照圆来计算的周长。近似的按照6378137米为地球半径来计算，那么整个赤道周长的一半，即为：

π∗r=3.1415926∗6378137=20037508.0009862

以上就是Web墨卡托投影坐标系范围的完整的计算过程，墨卡托投影也有很多变形，会有细微的不同，OpenLayers默认使用的就是EPSG:3857（Web墨卡托投影坐标系），对于该坐标系的详细定义，可以参见epsg.io.3867。

有了范围之后，要想计算Web墨卡托投影坐标系中的分辨率，按照上面的计算过程就非常简单了，还是以Google在线瓦片地图为例，x、y方向上的各层级瓦片地图分辨率计算公式可以归纳为：

resolution = rang / (256 * 2^z)

rang    ——    表示x方向或y方向上的整个范围，比如20037508.3427892 * 2。

256    ——    表示一个瓦片的边长，单位为像素。

2^z    ——    表示在层级z下，x或y方向上的瓦片个数。

那么整个公式计算出来就是在x或y方向，屏幕上一个像素所能代表的实际地理范围，即分辨率。

## 2.3、OpenLayers默认使用的分辨率

OpenLayers默认设置了加载瓦片地图时采用的分辨率，通过一个示例来看一下：

![img](https://img-blog.csdn.net/20180807140254194?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)


代码如下：

resolution.html:
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>OpenLayers默认使用的分辨率</title>
    <link rel="stylesheet" href="../../v5.3.0/css/ol.css" />
    <script src="../../v5.3.0/build/ol.js"></script>
</head>
<body>
    <div id="map"></div>
    <div><span>当前层级：</span><span id="zoom"></span><span>分辨率：</span><span id="resolution"></span></div>
    
    <script type="text/javascript">
        var map = new ol.Map({
            target: 'map',
            layers: [
              new ol.layer.Tile({
                source: new ol.source.OSM()
              })
            ],
            view: new ol.View({
              center: ol.proj.transform([104, 30], 'EPSG:4326', 'EPSG:3857'),
              zoom: 10
            })
        });
     
        // 监听层级变化，输出当前层级和分辨率
        map.getView().on('change:resolution', function(){
            document.getElementById('zoom').innerHTML =  this.getZoom() + '，';
            document.getElementById('resolution').innerHTML = this.getResolution();
        })
     
        document.getElementById('zoom').innerHTML = map.getView().getZoom() + '，';
        document.getElementById('resolution').innerHTML = + map.getView().getResolution();
    </script>
</body>
</html>
```

缩放上面的地图，从层级0开始，用前面介绍的公式和当前地图显示的分辨率进行比较，你会发现OpenLayers默认采用的分辨率和Google在线瓦片地图一样。    

OpenLayers瓦片地图默认分辨率表（地面比例尺）：

![img](https://gitee.com/er-huomeng/l-img/raw/master/img/20190105170239286.png)


注意事项

为什么我们上面一直以Google在线瓦片地图举例说明？

因为不同的在线瓦片地图可能采用不一样的分辨率，比如百度在线瓦片地图。所以在使用在线瓦片地图或者自己制作的瓦片地图时，都需要知道使用的分辨率是多少。如若不然，可能也会出现位置偏移。