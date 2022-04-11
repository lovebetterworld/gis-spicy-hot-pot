- [OpenLayers教程三：地图控件之缩放控件](https://blog.csdn.net/qq_35732147/article/details/90755781)

# 一、地图控件简介

OpenLayers封装了很多控件用于对地图进行操作、显示地图信息等。

具体来说，控件是一个地图上可见的小部件，其DOM元素位于屏幕上的固定位置。它们可以包含用户输入（以按钮的形式），也可以只提供信息。控件的位置是使用CSS来确定，当然也可以使用CSS来调整。默认情况下，控件被放置在地图控件层（地图控件层在上一篇文章讲过），也就是CSS类名为ol-overlayContainer-stopEvent的元素中，但也可以调整，使控件基于外部DOM元素来实现。

从OpenLayers的API来看，具体有如下控件类：

![img](https://img-blog.csdnimg.cn/20190603173212181.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

具体来说，这些控件是干嘛的呢？这里简单介绍一下

- 归属控件（Attribution）    ——    用于展示地图资源的版权或者归属，它会默认加入到地图中。

- 全屏控件（FullScreen）    ——    控制地图全屏展示

- 坐标拾取控件（MousePosition）    ——    用于在地图上拾取坐标

- 鹰眼控件（OverviewMap）    ——    生成地图的一个概览图

- 旋转控件（Rotate）    ——    用于鼠标拖拽旋转地图，它会默认加入到地图中。

- 比例尺控件（ScaleLine）    ——    用于生成地图比例尺

- 滑块缩放控件（ZoomSlider）    ——    以滑块的形式缩放地图

- 缩放至特定位置控件（ZoomToExtent）    ——    用于将地图视图缩放至特定位置

- 普通缩放控件（Zoom）    ——    普通缩放控件，它会默认加入到地图中。

 

# 二、普通缩放控件

现在先在上一篇文章中创建的openlayers文件夹中再创建一个controls文件夹：

![img](https://img-blog.csdnimg.cn/20190604102809786.png)

然后把first文件夹中的simple_map.html复制到controls文件夹中，并将其改名为zoom.html:

![img](https://img-blog.csdnimg.cn/20190604102940811.png)

普通缩放控件具有两个按钮分别用于地图的缩小和放大。因为它会默认加入到地图中，所以在前面一篇文章中，我们其实已经见到它了，用浏览器打开zoom.html：

![img](https://img-blog.csdnimg.cn/20190603175228798.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

可以用鼠标分别点击这两个按钮用于地图缩小和放大。

打开浏览器的开发者工具，可以发现普通缩放控件的DOM元素确实放在地图控件层中：

![img](https://img-blog.csdnimg.cn/20190603175603996.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

将开发者工具的选项卡切换到console，然后输入map.getControls().getArray()，会打印如下内容：

![img](https://img-blog.csdnimg.cn/20190603180123953.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

map.getControls().getArray()会返回一个数组，里面包含了地图中默认的控件实例，而这个数组的第一个元素就是普通缩放控件的实例了。

查看ol.control.Zoom类的API文档，可以发现OpenLayers设计了许多属性以方便开发人员对普通缩放控件进行调整：

![img](https://img-blog.csdnimg.cn/20190603180637865.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)    

可以通过为target属性赋值为自定义的DOM元素来为普通缩放控件绑定指定的DOM元素。

 

# 三、滑块缩放控件

普通缩放控件（ol.control.Zoom）是会被默认加入到地图中的，而滑块缩放控件（ol.control.ZoomSlider）不会被默认加入到地图中，因此我们来编写代码将其加入，修改zoom.html:
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
            // 新增代码
            controls: ol.control.defaults().extend([    // 往地图增加滑块缩放控件
                new ol.control.ZoomSlider()
            ])
        });
    </script>
</body>
</html>
```

OpenLayers实现了一个对原生JavaScript的Array类进行扩展的类ol.Collection，Map对象会保存一个ol.Collection实例用于存放控件。

上面的新增代码中，ol.control.defaults()方法就用于返回保存默认控件的ol.Collection实例，然后使用ol.Collection类的extend()方法往里增加了滑块缩放控件。

现在，使用浏览器打开zoom.html：

![img](https://img-blog.csdnimg.cn/20190604104532986.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

可以发现滑块缩放控件已经渲染在地图界面上了（透明度有点高），可以使用鼠标拖拉滑块来缩放地图！

![img](https://img-blog.csdnimg.cn/20190604104841525.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

打开浏览器的开发者工具，可以发现在地图控件层中增加了一个用于承载滑块缩放控件的DOM元素。



# 四、缩放至特定位置控件

现在让我们来看看缩放至特定位置控件（ol.control.ZoomToExtent）。

打开zoom.html，修改代码：

zoom.html:
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
            controls: ol.control.defaults().extend([    // 往地图增加控件
                new ol.control.ZoomSlider(),            // 滑块缩放控件
                // 新增代码
                new ol.control.ZoomToExtent({           // 缩放至特定位置控件      
                    extent: [
                        12667718, 2562800,
                        12718359, 2597725
                    ]
                })
            ])
        });
    </script>
</body>
</html>
```

这里new了一个ol.control.ZoomToExtent类的实例，从而创建了一个缩放至特定位置控件。其中的extent属性用于指定缩放的目标位置，它是一个数组，前两个元素表示位置矩形的左下角坐标，后两个元素表示位置矩形的右上角坐标：

![img](https://img-blog.csdnimg.cn/20190604110446460.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

最后通过ol.Collectionl类的extend()方法将该控件增加到地图中。

可以用浏览器打开zoom.html:

 ![img](https://img-blog.csdnimg.cn/20190604110601215.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

# 五、修改控件样式

OpenLayers为承载控件的各个DOM元素都自动设置了类名，所以通过CSS的类选择符就可以修改指定的控件样式。

这里我们来修改一下前面介绍的三个控件的样式，打开zoom.html:

zoom.html:
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
    <style>
        #map .ol-zoom .ol-zoom-out {
            margin-top: 204px;
        }
        #map .ol-zoomslider {
            background-color: transparent; 
            top: 2.3em;
        }
        #map .ol-zoom-extent {
            top: 280px;
        }
    </style>
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
            controls: ol.control.defaults().extend([    // 往地图增加控件
                new ol.control.ZoomSlider(),            // 滑块缩放控件
                new ol.control.ZoomToExtent({           // 缩放至特定位置控件      
                    extent: [
                        12667718, 2562800,
                        12718359, 2597725
                    ]
                })
            ])
        });
    </script>
</body>
</html>
```

使用浏览器打开zoom.html，可以发现三个缩放控件得到合理的样式修改：

![img](https://img-blog.csdnimg.cn/20190604111347830.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)