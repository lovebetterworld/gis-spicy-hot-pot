- [OpenLayers教程十四：多源数据加载之离线瓦片地图](https://blog.csdn.net/qq_35732147/article/details/95605978)



 本文转载自：http://weilin.me/ol3-primer/ch05/05-04.html

  其实**离线瓦片地图**和**在线瓦片地图**是一样的原理，都是**瓦片**。只是**离线瓦片地图**存储在本地，而且它的存取方式，可以由开发者自己来定义，而**在线瓦片地图**则不一定。在不理解原理的情况下，很多人拥有了**离线瓦片**，却不知道如何加载，所以这里单独来讲解。

  示例的**瓦片**就只有一张。如果放大或者缩小，就可能看不到**地图瓦片**了：

![img](https://img-blog.csdnimg.cn/20190712123819975.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

  瓦片：

![img](https://img-blog.csdnimg.cn/20190712124442476.png)

  loadOfflineTiledMap.html:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>加载离线瓦片地图</title>
    <link rel="stylesheet" href="../../v5.3.0/css/ol.css" />
    <script src="../../v5.3.0/build/ol.js"></script>
</head>
<body>
    <div id="map"></div>
    
    <script>
        var map = new ol.Map({
            target: 'map',
            layers: [
              new ol.layer.Tile({               // 加载离线瓦片地图
                source: new ol.source.XYZ({
                    // 设置本地离线瓦片所在路径，由于例子里面只有一张瓦片，页面显示时就只看得到一张瓦片。
                    url: './offlineMapTiles/{z}/{x}/{y}.png'
                })
              })
            ],
            view: new ol.View({
              center: ol.proj.fromLonLat([104.06667, 30.66667]),        // 设置成都为地图中心
              zoom: 4
            })
        });
    </script>
</body>
</html>
```

  这个例子中唯一的**瓦片图片**相对路径是：offlineMapTiles/4/12/6.png。

   url必须根据瓦片地图存放路径来编写，比如这个例子里面，4表示的是层级，12表示的是x，6表示的是y，我们的url参数就写成：{z}/{x}/{y}.png。如果瓦片地图都放在一个目录下，采用z-x-y.png的方式命名，那么url参数就得写成：{z}-{x}-{y}.png。

  在开发时，会考虑一个问题：是先在代码里面写url，还是先在本地放好**瓦片地图**？我建议**瓦片地图**数据优先，而且很多瓦片地图都是工具下载的，量大，如果需要修改目录结构，会比较费事。相对的，修改url的代码明显就要简单很多。