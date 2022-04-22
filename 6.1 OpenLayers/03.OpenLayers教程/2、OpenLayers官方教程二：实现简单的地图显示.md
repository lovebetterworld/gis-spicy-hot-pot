- [OpenLayers官方教程二：实现简单的地图显示](https://blog.csdn.net/qq_35732147/article/details/90719390)



# 一、下载OpenLayers

打开OpenLayers官网：https://openlayers.org/

然后点击Get the Code：

![img](https://img-blog.csdnimg.cn/20190531170031401.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

进入页面下载包含源码包、示例和API文档的压缩文件（我现在下载的是当前最新版5.3.0）：

![img](https://img-blog.csdnimg.cn/20190531170223200.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

下载完后对其解压，然后自己新建一个文件，将解压文件复制到这个文件夹中（我这里复制到E盘下的openlayers文件夹中）：

![img](https://img-blog.csdnimg.cn/20190531170727937.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

可以发现解压文件中包含了几个文件，但是目前我们只会用到build和css中的内容。

其中build文件夹中包含了ol.js文件，它是OpenLayers的核心开发库，集成了OpenLayers的所有功能；css文件夹中包含了ol.css文件，它是样式库，包含了OpenLayers的所有默认样式信息。

# 二、构建简单的地图应用

上面说到了ol.js和ol.css这两个文件，而构建基于OpenLayers的web应用正是需要在代码中引入这两个文件。

首先在刚才新建的openlayers文件夹的根目录中新建一个first文件夹用来放置我们的第一个OpenLayers应用：

![img](https://img-blog.csdnimg.cn/20190531171946123.png)

然后，在first文件夹中新建一个HTML文件simple_map.html:

simple_map.html:

```js
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Simple Map</title>
    <link rel="stylesheet" href="../v5.3.0/css/ol.css" />
</head>
<body>
    
    <script src="../v5.3.0/build/ol.js"></script>
</body>
</html>
```

可以看到，代码里引入了ol.js和ol.css这两个文件！

因为OpenLayers中的地图需要一个div元素作为容器用来放置绘制地图的canvas DOM元素与其他DOM元素，所以我们在simple_map.html中也加入一个div元素。

现在已经把基础代码写完了，接下来开始写最核心的逻辑代码：

simple_map.html:

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
            })
        });
    </script>
</body>
</html>
```
先让我们用浏览器打开simple_map.html文件：

![img](https://img-blog.csdnimg.cn/20190531173317644.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

地图显示出来了！    

你可以用鼠标滚轮来放大和缩小地图，以及使用左键按住地图随意拖动。

那么上面的逻辑代码，也就是JavaScript那部分的代码是什么意思呢？

其实很简单：

首先，调用了ol.Map类生成了一个地图容器对象，通过target参数关联到div容器（id为"map"的div元素）。

然后通过layers参数设置需要加载的瓦片图层（ol.layer.Tile），这个瓦片图层中包含了一个数据源（ol.source.OSM），这个数据源是OpenStreetMap（一个开放数据源的免费地图）的地图数据，也就是ol.source.OSM这个类封装了加载OSM地图数据的详细实现。

最后通过view参数设置地图视图（ol.View），地图视图中也设置了相应的空间参考系统（projection）、地图视图中心点（center），地图视图缩放级别（zoom）。

怎么样，是不是很简单？

什么？很难？。。。。

没有关系，后面还会详细讲解它的原理。。。

# 三、OpenLayers的DOM元素组织结构

那么地图容器（ol.Map类）是如何将设置的图层数据渲染呈现到Web客户端的呢？

我们来看上面那个示例的DOM元素组织结构。

使用浏览器打开simple_map.html，并打开控制台的Elements选项卡，逐一点开DOM元素层次：

![img](https://img-blog.csdnimg.cn/20190531175518621.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

我们可以发现好几层DOM元素层。

首先OpenLayers会在我们自定义的div元素（即id为map的div元素）中创建一个Viewport容器，地图中的所有内容都放置在Viewport中呈现。

在Viewport容器中分别创建了如下三个关键的元素层，分别渲染呈现地图容器中的内容：

- 地图渲染层    ——    这是一个canvas元素，地图基于canvas方式渲染
- 内容叠加层    ——    用于放置叠置层（ol.Overlay，后面会详细介绍）内容，如在地图上添加弹窗、图片等等
- 地图控件层    ——    用于放置控件，默认情况下会放置ol.control.Zoom（用于控制地图放大、缩小）、ol.control.Rotate（用于控制地图旋转）、ol.control.Attribution（用于控制地图右下角标记）这三个控件。