- [OpenLayers 3的Layer和Source_大树下躲雨的博客-CSDN博客](https://blog.csdn.net/weixin_43521890/article/details/122060016)

## 一、Map、Layer和Source

> 图层Layer与地图源Source是一对一的关系。
>
> 当创建了一个图层Layer，相应的需要给图层添加地图源Source，然后将图层Layer添加到地图Map上，就可以得到我们想要的地图了。

## 二、地图源Source

地图源Source分类：

| 分类             | 描述                                                         |
| ---------------- | ------------------------------------------------------------ |
| ol.source.Tile   | 瓦片数据源，现在网页地图服务中，绝大多数都是使用的瓦片地图   |
| ol.source.Image  | 图片地图源，不像瓦片那样很多张图，从而无需切片，也可以加载一些地图，适用于一些小场景地图。 |
| ol.source.Vector | 矢量地图源，点，线，面等等常用的地图元素(Feature)，就囊括到这里面了 |

[OpenLayers](https://so.csdn.net/so/search?q=OpenLayers&spm=1001.2101.3001.7020) 3支持的`Source`：

![ol.source.Tile类图](https://img-blog.csdnimg.cn/img_convert/ca7c7eec4d865a63b6994afe4e97fee6.png)

上图中的类是按照继承关系，从左向右展开的，左边的为父类，右边的为子类。在使用时，一般来说，都是直接使用叶子节点上的类，基本就可以完成需求。父类需要自己进一步扩展或者处理才能有效使用的。

我们先了解最为复杂的`ol.source.Tile`，其叶子节点类有很多，大致可以分为几类：

- 在线服务的`Source`，包括`ol.source.BingMaps`(使用的是微软提供的Bing在线地图数据)，`ol.source.MapQuest`(使用的是MapQuest提供的在线地图数据)(注: 由于MapQuest开始收费，ol v3.17.0就移除了`ol.source.MapQuest`)，`ol.source.OSM`(使用的是Open Street Map提供的在线地图数据)，`ol.source.Stamen`(使用的是Stamen提供的在线地图数据)。没有自己的地图服务器的情况下，可直接使用它们，加载地图底图。
- 支持协议标准的`Source`，包括`ol.source.TileArcGISRest`，`ol.source.TileWMS`，`ol.source.WMTS`，`ol.source.UTFGrid`，`ol.source.TileJSON`。如果要使用它们，首先你得先学习对应的协议，之后必须找到支持这些协议的服务器来提供数据源，这些服务器可以是地图服务提供商提供的，也可以是自己搭建的服务器，关键是得支持这些协议。
- ol.source.XYZ，这个需要单独提一下，因为是可以直接使用的，而且现在很多地图服务（在线的，或者自己搭建的服务器）都支持xyz方式的请求。国内在线的地图服务，高德，天地图等，都可以通过这种方式加载，本地离线瓦片地图也可以，用途广泛，且简单易学，需要掌握。

`ol.source.Image`虽然有几种不同的子类，但大多比较简单，因为不牵涉到过多的协议和服务器提供商。

而`ol.source.Vector`就更加的简单了，但有时候其唯一的子类`ol.source.Cluster`在处理大量的`Feature`时，我们可能需要使用。

## 三、图层Layer

OpenLayers 3的`Layer`类图：

![ol.layer.Base类图](https://img-blog.csdnimg.cn/img_convert/f47788c6928f104b7ddfda70beb915a5.png)

## 四、加载不同的在线地图（map.html）

#### 1、项目结构

![在这里插入图片描述](https://img-blog.csdnimg.cn/2c7ce014ef9546c8bdd2628c38ec1a6e.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5aSn5qCR5LiL6Lqy6Zuo,size_20,color_FFFFFF,t_70,g_se,x_16)

#### 2、注意事项

> MapQuest开始收费，ol v3.17.0就移除了`ol.source.MapQuest`

#### 3、map.html

```html
<!Doctype html>
<html xmlns='http://www.w3.org/1999/xhtml'>
<head>
    <meta http-equiv='Content-Type' content='text/html;charset=utf-8'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'>
    <meta content='always' name='referrer'>
    <title>OpenLayers_3:加载不同的在线地图</title>
    <link href='ol.css ' rel='stylesheet' type='text/css'/>
    <script type='text/javascript' src='ol.js' charset='utf-8'></script>
</head>


<body>



<div id='map' style='width: 800px;height: 800px;margin: auto'></div>
<br>
<div style="width: 800px;margin: auto">
    <input type='radio' checked='checked' name='mapSource' onclick='switchOSM();'/>OpenStreetMap地图 <br/>
    <input type='radio' name='mapSource' onclick='switchBingMap();'/>Bing地图 <br/>
    <input type='radio' name='mapSource' onclick='switchStamenMap();'/>Stamen地图 <br/>
</div>

<script>


    /**
     开源 Open Street Map 地图层
     */
    var openStreetMapLayer = new ol.layer.Tile({
        source: new ol.source.OSM()
    })

    /**
     微软 Bing地图层
     */
    var bingMapLayer = new ol.layer.Tile({
        source: new ol.source.BingMaps({
            key: 'AkjzA7OhS4MIBjutL21bkAop7dc41HSE0CNTR5c6HJy8JKc7U9U9RveWJrylD3XJ',
            imagerySet: 'Road'
        })
    })

    /**
     Stamen 地图层
     */
    var stamenLayer = new ol.layer.Tile({
        source: new ol.source.Stamen({
            layer: 'watercolor'
        })
    })

    // Map Quest地图(注: 由于MapQuest开始收费，ol v3.17.0就移除了ol.source.MapQuest)
    // var mapQuestLayer = new ol.layer.Tile({
    //   source: new ol.source.MapQuest({
    //     layer: 'osm'
    //   })
    // })


    // 创建地图
    var map = new ol.Map({

        // 设置地图图层
        layers: [
            openStreetMapLayer
        ],

        // 设置显示地图的视图
        view: new ol.View({
            //设置成都为地图中心
            center: [104.06, 30.67],
            //指定投影
            projection: 'EPSG:4326',
            //初始层级
            zoom: 10
        }),

        // 让id为map的div作为地图的容器
        target: 'map'

    })

    /**
     切换为  开源 Open Street Map 地图层
     */
    function switchOSM() {
        //移除第一个图层
        map.removeLayer(map.getLayers().item(0))
        //添加图层
        map.addLayer(openStreetMapLayer)
    }

    /**
     切换为 微软 Bing地图层
     */
    function switchBingMap() {
        //移除第一个图层
        map.removeLayer(map.getLayers().item(0))
        //添加图层
        map.addLayer(bingMapLayer)
    }

    /**
     切换为  Stamen 地图层
     */
    function switchStamenMap() {
        //移除第一个图层
        map.removeLayer(map.getLayers().item(0))
        //添加图层
        map.addLayer(stamenLayer)
    }


</script>
</body>
</html>
```

#### 4、运行结果

![在这里插入图片描述](https://img-blog.csdnimg.cn/bcdd163ce0d74f08a7bebcb8de34eb74.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5aSn5qCR5LiL6Lqy6Zuo,size_20,color_FFFFFF,t_70,g_se,x_16)
![在这里插入图片描述](https://img-blog.csdnimg.cn/9d4d80039e27410bb214221a7da2822f.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5aSn5qCR5LiL6Lqy6Zuo,size_20,color_FFFFFF,t_70,g_se,x_16)
![在这里插入图片描述](https://img-blog.csdnimg.cn/2fe73e1b519a41ec8df73293d81dd284.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5aSn5qCR5LiL6Lqy6Zuo,size_20,color_FFFFFF,t_70,g_se,x_16)

## 五、加载离线瓦片地图（map2.html）

#### 1、离线瓦片地图路径

![在这里插入图片描述](https://img-blog.csdnimg.cn/91fdc3585a934cb9bdd8cdbf6d0df1c0.png)

#### 2、注意事项

> 使用离线瓦片地图，`url`必须根据瓦片地图存放路径来编写，比如下方demo中的url，4表示的是层级，12表示的是x，6表示的是y，我们的`url`参数就写成：
> `{z}/{x}/{y}.png`。 如果瓦片地图都放在一个目录下，采用z-x-y.png的方式命名，那么`url`参数就得写成：
> `{z}-{x}-{y}.png`。

#### 3、map2.html

```html
<!Doctype html>
<html xmlns='http://www.w3.org/1999/xhtml'>
<head>
    <meta http-equiv='Content-Type' content='text/html;charset=utf-8'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'>
    <meta content='always' name='referrer'>
    <title>OpenLayers_3:加载离线瓦片地图</title>
    <link href='ol.css ' rel='stylesheet' type='text/css' />
    <script type='text/javascript' src='ol.js' charset='utf-8'></script>
</head>

<body>
<div id='map' style='width: 800px;height: 1000px;margin: auto'></div>
<script>

    //设置地图中心点，坐标系转换（'EPSG:4326'转'EPSG:3857'）
    var center = ol.proj.transform([104.06667, 30.66667], 'EPSG:4326', 'EPSG:3857')


    // 创建地图
    var map = new ol.Map({
        // 设置显示地图的视图
        view: new ol.View({
            center: center,
            zoom: 4
        }),

        // 让id为map的div作为地图的容器
        target: 'map'

    })

    //创建图层，并获取本地瓦片为地图源
    var tileLayer = new ol.layer.Tile({
        source: new ol.source.XYZ({
            //tiles/4/12/6.pngt
            //4表示的是层级，12表示的是x，6表示的是y，我们的url参数就写成： {z}/{x}/{y}.png
            //如果瓦片地图都放在一个目录下，采用z-x-y.png的方式命名，那么url参数就得写成： {z}-{x}-{y}.png
            url: 'tiles/{z}/{x}/{y}.png'
        })
    })

    //将图层添加到地图
    map.addLayer(tileLayer)

</script>
</body>


</html>
```

#### 4、运行结果

![在这里插入图片描述](https://img-blog.csdnimg.cn/dd44834d24bd44f298f5450305781991.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5aSn5qCR5LiL6Lqy6Zuo,size_20,color_FFFFFF,t_70,g_se,x_16)

## 六、加载静态图片地图（map3.html）

#### 1、静态地图路径

![在这里插入图片描述](https://img-blog.csdnimg.cn/3cea5c565aca491c883d9e5552f36e2a.png)

#### 2、map3.html

```html
<!Doctype html>
<html xmlns='http://www.w3.org/1999/xhtml'>
<head>
    <meta http-equiv='Content-Type' content='text/html;charset=utf-8'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'>
    <meta content='always' name='referrer'>
    <title>OpenLayers_3:加载静态图片</title>
    <link href='ol.css ' rel='stylesheet' type='text/css' />
    <script type='text/javascript' src='ol.js' charset='utf-8'></script>
</head>

<body>
<div id='map' style='width: 800px;height: 800px;margin: auto'></div>
<script>


    // 设置地图中心点，坐标系转换（'EPSG:4326'转'EPSG:3857'）
    var center = ol.proj.transform([104.06667, 30.66667], 'EPSG:4326', 'EPSG:3857')

    // 计算静态图片映射到地图上的范围，图片像素为 607*604，保持比例的情况下，把分辨率放大一些
    var extent = [center[0] - 607 * 1000 / 2, center[1] - 604 * 1000 / 2, center[0] + 607 * 1000 / 2, center[1] + 604 * 1000 / 2]

    // 创建地图
    var map = new ol.Map({

        // 设置显示地图的视图
        view: new ol.View({
            center: center,
            zoom: 7
        }),

        // 让id为map的div作为地图的容器
        target: 'map'

    })

    //创建图层，并获取本地静态图片为地图源
    var imageLayer = new ol.layer.Image({
        source:new ol.source.ImageStatic({
            url:'images/gy.png', //图片
            imageExtent:extent  //映射到地图的范围
        })
    });

    //将图层添加到地图
    map.addLayer(imageLayer)


</script>
</body>


</html>
```

#### 3、运行结果

![在这里插入图片描述](https://img-blog.csdnimg.cn/bd3f682ba87b41e8a1056828a979cbfc.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5aSn5qCR5LiL6Lqy6Zuo,size_20,color_FFFFFF,t_70,g_se,x_16)