- [OpenLayers教程四：归属控件与全屏控件](https://blog.csdn.net/qq_35732147/article/details/90906111)



  经过上一篇文章的介绍，大家一定对OpenLayers的地图控件有一定了解了，现在接着介绍归属控件和全屏控件。

# 一、归属控件

归属控件（ol.control.Attribution）用于展示地图资源的版权或者归属，它会默认加入到地图中，现在我们来看看归属控件。

拷贝一份first文件夹中的simple_map.html到controls文件夹中，并修改文件名为attribution.html:

![img](https://img-blog.csdnimg.cn/20190605173624956.png)

可以用浏览器直接打开Attribution.html，就可以再地图中看到归属控件了：

![img](https://img-blog.csdnimg.cn/2019060517385020.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

由于归属控件比较简单，就不详细介绍了。。。

# 二、全屏控件

通常情况下我们的地图视图都是在浏览器的客户区进行展示，就像这样：

![img](https://img-blog.csdnimg.cn/20190605175456769.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

但是如果我们想让地图全屏展示该怎么办呢？

全屏控件就能使地图全屏展示。

拷贝一份first文件夹中的simple_map.html到controls文件夹中，并修改文件名为fullScreen.html:

![img](https://img-blog.csdnimg.cn/20190605175710890.png)

接着我们修改fullScreen.html的代码来添加全屏控件：

fullScreen.html：

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
            controls: ol.control.defaults().extend([
                new ol.control.FullScreen()
            ])
        });
    </script>
</body>
</html>
```

修改的代码也很简单，就是初始化了一个ol.control.FullScreen类的实例，然后添加到地图保存控件的ol.Collection中。    

然后使用浏览器打开fullScreen.html，可以发现全屏控件显示在地图的右上角，点击它可以让地图全屏显示：

![img](https://img-blog.csdnimg.cn/2019060610190768.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)



![img](https://img-blog.csdnimg.cn/20190606101934836.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)