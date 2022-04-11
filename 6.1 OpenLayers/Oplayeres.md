一、OpenLayers 3 中有一个对应的数据源（ol.source）类 – `ol.source.TileImage，但是天地图的切片方式和google地图的切片的方式一样，`

```
OpenLayer定义一个类专门门加载此类地图- ol.source.XYZ，这个类是 ol.source.TileImage 的一个特例，继承了 ol.source.TileImage，其中 XYZ 分别对应切片所在的 x y 坐标和当前的缩放级别 z。
```

二、全部源码：很简单没几步（坐标系3857）

```html
一、OpenLayers 3 中有一个对应的数据源（ol.source）类 – ol.source.TileImage，但是天地图的切片方式和google地图的切片的方式一样，

OpenLayer定义一个类专门门加载此类地图- ol.source.XYZ，这个类是 ol.source.TileImage 的一个特例，继承了 ol.source.TileImage，其中 XYZ 分别对应切片所在的 x y 坐标和当前的缩放级别 z。

二、全部源码：很简单没几步（坐标系3857）

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>天地图加载</title>
    <link href="Script/ol.css" rel="stylesheet" />
    <script src="Script/ol-debug.js"></script>
    <script src="../Scripts/jquery-1.7.1.js"></script>
    <script type="text/javascript">
        $(function () {
            //天地图底图
            var source =new ol.source.XYZ({
                url: "http://t4.tianditu.com/DataServer?T=vec_w&x={x}&y={y}&l={z}"
            });
            var tileLayer =new  ol.layer.Tile({
                title:"天地图",
                source:source
            });
            //标注图层
            var sourceMark = new ol.source.XYZ({ url: 'http://t3.tianditu.com/DataServer?T=cva_w&x={x}&y={y}&l={z}' });
            var tileMark = new ol.layer.Tile({
                title:"标注图层",
                source: sourceMark,
                
            });
            //卫星图像
            var sourceSatellite = new ol.source.XYZ({ url: 'http://t3.tianditu.com/DataServer?T=img_w&x={x}&y={y}&l={z}' });
            var tileSatellite = new ol.layer.Tile({
                title: "卫星图",
                source:sourceSatellite
 
            });
            map = new ol.Map({
                layers: [
                    tileLayer,
                    tileMark
                    //tileSatellite
 
                ],
                view: new ol.View({
                    zoom: 11,
                    center:ol.proj.transform( [116.40769, 39.89945], 'EPSG:4326', 'EPSG:3857')
                }),
                target: 'map'
            })
        });
    </script>
</head>
<body>
    <div id="map">   </div>
</body>
</html>
三、最后的图：



四、总结

一定要官方给定的语法去写！一定要官方给定的语法去写！一定要官方给定的语法去写！重要的说三遍
```

三、最后的图：

![img](https://img-blog.csdn.net/20180620210532246?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MDE4NDI0OQ==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

四、总结

一定要官方给定的语法去写！一定要官方给定的语法去写！一定要官方给定的语法去写！重要的说三遍