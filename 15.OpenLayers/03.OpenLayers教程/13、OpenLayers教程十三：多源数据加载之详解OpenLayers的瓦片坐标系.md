- [OpenLayers教程十三：多源数据加载之详解OpenLayers的瓦片坐标系](https://blog.csdn.net/qq_35732147/article/details/95061747)



前面的文章已经简单介绍了瓦片坐标系是瓦片地图的组织框架，现在我们来详细探讨OpenLayers中的瓦片坐标系，从而让我们在加载各种瓦片地图的过程中能得心应手。

# 一、OpenLayers中定义瓦片坐标系的接口

前面的文章介绍了使用ol.source.TileDebug类可以让我们清晰的看到每一个瓦片的坐标，我们来看一下TileDebug这个类的API文档：

![img](https://img-blog.csdnimg.cn/20190708152312264.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

可以看到实例化类的参数中有一个tileGrid参数，这个参数就是用于指定ol.source.TileDebug的瓦片坐标系，而ol.tilegrid.TileGrid类就是瓦片坐标系的抽象表示，即在OpenLayers中就是用这个类来定义瓦片坐标系。

那我们就来看看ol.tilegrid.TileGrid类的API：

![img](https://img-blog.csdnimg.cn/20190708152851956.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

上面各个初始化类的参数分别表示：

- extent    ——    请求加载的瓦片的范围，不在这个范围内的瓦片不会被请求并加载。默认是全球范围

- minZoom    ——    瓦片坐标系的最小层级，比minZoom更小层级的瓦片不会被请求并加载。

- origin    ——    瓦片坐标系水平方向上的起始点（原点）。默认的原点为extent的左上角（top-left）。其中，瓦片坐标在x方向从左到右递增，在y方向从下到上递增。

- origins    ——    瓦片坐标系各个层级的水平方向上的起始点（原点），即每个层级可以指定不同的水平方向上的原点。

- resolutions    ——    瓦片坐标系各个层级的瓦片分辨率，即不同层级的瓦片的分辨率可以不同。

- tileSize    ——    瓦片的大小。

- tileSizes    ——    瓦片坐标系各个层级的瓦片大小，即不同层级的瓦片的大小可以不同。

# 二、通过自定义OpenLayers的瓦片坐标系来加载百度地图

前面一篇文章讲到可以使用XYZ的方式非常简单的加载瓦片地图，但遗憾地是，这种简单方法并不适用于所有的在线瓦片地图，总有一些是特殊的，比如百度地图。

瓦片地图加载的关键在于找对瓦片，但要找对瓦片，就得知道瓦片的坐标，而瓦片坐标又需要明确的瓦片坐标系。

通过前面的API文档，我们可以知道OpenLayer的默认瓦片坐标系的原点在左上角，从左到右为x轴正方向，从下到上为y轴正方向。

具体到地图上来讲，地球经过投影，投影到一个平面上，平面最左边对应地球最西边，平面最上边对应地球最北边。原点就处于整个平面的左上角，即地球的西北角，从北向南为y轴负方向，从西向东为x轴正方向。理解这一点非常重要，因为并不是所有在线的瓦片地图都是采用这样的瓦片坐标系。用OpenLayers加载它们的时候，如果瓦片坐标系不同，计算出来的瓦片地址就获取不到对应的瓦片，为解决这个问题，我们必须要先对瓦片坐标进行转换。

那么，具体该怎么实现转换？最详细明了的方式还是看实例，下面我们看一下加载百度地图的一种实现方式：

![img](https://img-blog.csdnimg.cn/20190709113503184.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

loadBaidu.html:
    
```js
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>加载百度地图</title>
    <link rel="stylesheet" href="../../v5.3.0/css/ol.css" />
    <script src="../../v5.3.0/build/ol.js"></script>
</head>
<body>
    <div id="map"></div>
    
    <script>
        // 百度地图图层
        var baiduMapLayer = new ol.layer.Tile({
            source: new ol.source.XYZ({
                tilePixelRatio: 2,
                tileUrlFunction: function(tileCoord){
                    let z = tileCoord[0];
                    let x = tileCoord[1];
                    let y = tileCoord[2];
 
                    // 计算当前层级下X或Y方向上瓦片总数的一半，用于定位整个地图的中心点
                    let halfTileNum = Math.pow(2, z - 1);
 
                    // 原点从左上角移到中心点后，计算xy方向上新的坐标位置
                    let baiduX = x - halfTileNum;
                    let baiduY = y + halfTileNum;
 
                    // 百度瓦片服务url将负数使用M前缀来标识
                    if(baiduX < 0){
                        baiduX = 'M' + (-baiduX);
                    }
                    if(baiduY < 0){
                        baiduY = 'M' + (-baiduY);
                    }
 
                    // 返回经过转换后，对应于百度在线瓦片的url
                    return 'http://online2.map.bdimg.com/onlinelabel/?qt=tile&x=' + baiduX + '&y=' + baiduY + '&z=' + z + '&styles=pl&udt=20160321&scaler=2&p=0';
                }
            })
        });
 
        let map = new ol.Map({
            target: 'map',
            layers: [
              baiduMapLayer
            ],
            view: new ol.View({
              center: ol.proj.fromLonLat([104.06, 30.67]),  // 设置成都为中心点
              zoom: 4
            })
        });
    </script>
</body>
</html>
```

首先我们需要理解一下tilePixelRatio参数，它表示瓦片服务使用的像素比，例如，如果瓦片服务发布256px * 256px的瓦片，但是实际发送的却是512px * 512px的图像，则tilePixelRatio需要设置为2。百度地图这个例子就是这个情况。

和前面几个加载在线瓦片地图的例子不一样的地方在于，我们没有设置url，而是设置了tileUrlFunction，这是一个获取瓦片url的函数。如果自定义这个函数，就可以实现不同瓦片坐标系之间的转换，从而返回在线地图服务对应的url。通过代码可以看到，函数参数是一个瓦片坐标，然后进行一系列的转换，得到百度在线地图的瓦片地址。

tileUrlFunction这个自定义函数的代码实现有可能看不懂，虽然知道在进行坐标转换，但并不知道为什么要这样实现。为了彻底弄明白代码，我们必须得把之前遗漏的一个重要环节补上：弄明白待加载的在线瓦片地图的坐标系。

对百度在线瓦片坐标系进行简单分析发现，它是以某一个位置为原点，向右为x正方向，向上为y正方向的瓦片坐标系。进一步分析发现，原点应该在中心位置，在此基础上编写函数tileUrlFunction的实现。halfTileNum表示的是在当前缩放层级之下，x方向或y方向的瓦片个数的一半，意味着它就是中心位置。对于baiduX小于0的情况，百度使用了M来表示负号，所以要特殊处理一下。想必这下应该更加理解代码实现了。不同的在线瓦片地图的转换代码可能不同，需要根据对应的瓦片坐标系来确定。

但上面这个地图并不完美，因为我们设定的地图中心为成都，然而实际上显示的地图中心并不在成都。虽然无缝拼接，但位置偏差有点远。由此基本可以排除坐标转换的问题，看起来应该是OpenLayers的分辨率和百度在线瓦片地图使用的分辨率对不上。经过分析发现，确实如此，在网上也有很多分析文章可以查询。那么我们是否可以重新定义分辨率呢？答案是肯定的。

我们可以通过自定义瓦片坐标系来修改分辨率：

![img](https://img-blog.csdnimg.cn/20190710120911391.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

loadBaidu2.html:
    
```js
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>加载百度地图</title>
    <link rel="stylesheet" href="../../v5.3.0/css/ol.css" />
    <script src="../../v5.3.0/build/ol.js"></script>
</head>
<body>
    <div id="map"></div>
    
    <script>
        // 自定义分辨率和瓦片坐标系
        var resolutions = [];
        var maxZoom = 18;
 
        // 计算百度使用的分辨率
        for(var i=0; i<=maxZoom; i++){
            resolutions[i] = Math.pow(2, maxZoom-i);
        }
        var tilegrid  = new ol.tilegrid.TileGrid({
            origin: [0, 0],                     // 将原点设置成和百度瓦片坐标系一致
            resolutions: resolutions            // 设置分辨率
        });
 
        // 百度地图图层
        var baiduMapLayer = new ol.layer.Tile({
            source: new ol.source.XYZ({
                tilePixelRatio: 2,
                tileGrid: tilegrid,
                tileUrlFunction: function(tileCoord){
                    let z = tileCoord[0];
                    let x = tileCoord[1];
                    let y = tileCoord[2];
 
                    // 百度瓦片服务url将负数使用M前缀来标识
                    if(x < 0){
                        x = 'M' + (-x);
                    }
                    if(y < 0){
                        y = 'M' + (-y);
                    }
 
                    // 返回经过转换后，对应于百度在线瓦片的url
                    return 'http://online2.map.bdimg.com/onlinelabel/?qt=tile&x=' + x + '&y=' + y + '&z=' + z + '&styles=pl&udt=20160321&scaler=2&p=0';
                }
            })
        });
        console.log(baiduMapLayer.getSource().getTileGrid());
        let map = new ol.Map({
            target: 'map',
            layers: [
              baiduMapLayer
            ],
            view: new ol.View({
              center: ol.proj.fromLonLat([104.06, 30.67]),  // 设置成都为中心点
              zoom: 10
            })
        });
    </script>
</body>
</html>
```
由于将瓦片坐标系的原点设置成百度瓦片坐标系一致，所以tileUrlFunction里就不需要对针对原点进行瓦片坐标的转换操作了。

# 三、分析瓦片地图的瓦片坐标系

如何分析不同在线瓦片地图的瓦片坐标系呢？非常重要的一点是，先从特例触发，找简单的情况分析，比如选择z为2或者3进行分析，这种情况下，瓦片的数量比较少，可以查看整个地球范围内的地图的瓦片请求，注意分析其请求的url参数。

瓦片的url解析对于想直接使用在线瓦片服务的开发者而言，是一项经常要做的事。根据难度，大致可以分为三种情况：

- 第一种情况最简单，请求瓦片的url明确有xyz参数，比如高德地图和百度地图。
- 第二种稍微难一点，xyz作为路径直接存在url里面，没有明确的参数表明哪些是xyz，比如Open Street Map和Yahoo地图，这种情况下，地图服务器收到请求后，就直接在服务器按照这个路径获取图片，按照这个逻辑，一般第一个参数表示是z，第二个参数为x，第三个参数为y。要想确认是否真是这样，可以写一个小程序来验证一下，如果还有问题，建议按照上面分析地图坐标系中的方法，从z比较小的情况入手来分析x、y、z的位置。
- 第三种则最难，地图服务提供商为了防止大家直接非法使用瓦片地图，对瓦片的url进行了加密，比如现在的微软Bing中文地图和Google地图，这种情况下只有知道如何解密才能使用。

前面两种url的实例已经有了，此处分享一下第三种情况的url解密，以微软Bing中文地图为例：



## 3.1、加载微软Bing中文地图

![img](https://img-blog.csdn.net/2018080211365660?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

图中显示的瓦片地图请求的url，没有明显的xyz参数，最有可能的存放xyz参数的地方在于url前面那一串数字，真实情况确实是这样的，经过分析和解码，最终实现了加载Bing中文地图：

![img](https://img-blog.csdnimg.cn/20190710122647938.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

loadBingMap_XYZ.html:

```js
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>加载微软Bing中文地图</title>
    <link rel="stylesheet" href="../../v5.3.0/css/ol.css" />
    <script src="../../v5.3.0/build/ol.js"></script>
</head>
<body>
    <div id="map"></div>
    
    <script>
        var map = new ol.Map({
            target: 'map',
            layers: [
                new ol.layer.Tile({
                    source: new ol.source.XYZ({
                        tileUrlFunction: function(tileCoord){
                            let z = tileCoord[0];
                            let x = tileCoord[1];
                            let y = -tileCoord[2] - 1;
                            let result='', zIndex=0;
                    
                            for(zIndex = 0; zIndex < z; zIndex++) {
                                result = ((x & 1) + 2 * (y & 1)).toString() + result;
                                x >>= 1;
                                y >>= 1;
                            }
                            return 'http://dynamic.t0.tiles.ditu.live.com/comp/ch/' + result + '?it=G,VE,BX,L,LA&mkt=zh-cn,syr&n=z&og=111&ur=CN';
                        }
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
需要注意的是地图数据是非常昂贵的，如果使用某一个在线地图服务，请先核实对方的版权和数据使用申明，不要侵犯对方的权益，按照要求合法使用地图。几乎所有的在线地图服务都提供了响应的服务接口，强烈建议在商用项目中使用这些接口。对于这些接口的使用，服务商都有详细的说明，在此不赘述。



## 3.2、加载Google中文地图

![img](https://img-blog.csdnimg.cn/20190710123028663.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

loadGoogle.html:

```js
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>加载微软Bing中文地图</title>
    <link rel="stylesheet" href="../../v5.3.0/css/ol.css" />
    <script src="../../v5.3.0/build/ol.js"></script>
</head>
<body>
    <div id="map"></div>
    
    <script>
        var map = new ol.Map({
            target: 'map',
            layers: [
                new ol.layer.Tile({
                    source: new ol.source.XYZ({
                        url:'http://www.google.cn/maps/vt/pb=!1m4!1m3!1i{z}!2i{x}!3i{y}!2m3!1e0!2sm!3i345013117!3m8!2szh-CN!3scn!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0'
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