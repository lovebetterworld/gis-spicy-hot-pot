- [OpenLayers 3加载矢量地图源_大树下躲雨的博客-CSDN博客_openlayers 加载矢量地图](https://blog.csdn.net/weixin_43521890/article/details/122085734)

## 一、矢量地图

[矢量图](https://so.csdn.net/so/search?q=矢量图&spm=1001.2101.3001.7020)使用直线和曲线来描述图形，这些图形的元素是一些点、线、矩形、多边形、圆和弧线等等，它们都是通过数学公式计算获得的。由于矢量图形可通过公式计算获得，所以矢量图形文件体积一般较小。矢量图形最大的优点是无论放大、缩小或旋转等不会失真。在地图中存在着大量的应用，是地图数据中非常重要的组成部分。

为了便于存储，传递，使用，矢量地图会按照一定的格式来表达，比如常见的`GeoJSON`，`TopoJSON`，`GML`，`KML`，`ShapeFile`等等。 除了最后一个`ShapeFile`，其他几个格式的矢量地图OpenLayers 3都支持。

## 二、使用GeoJson格式加载矢量地图

#### 1、项目结构

![在这里插入图片描述](https://img-blog.csdnimg.cn/67b03d92915f4436b01a985b40ba9dbb.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5aSn5qCR5LiL6Lqy6Zuo,size_19,color_FFFFFF,t_70,g_se,x_16)

#### 2、map.geojson

![在这里插入图片描述](https://img-blog.csdnimg.cn/30369cd5029c4abb950895d3b4ec51e8.png)

```json
{"type":"FeatureCollection","features":[{"type":"Feature","properties":{},"geometry":{"type":"Polygon","coordinates":[[[104.08859252929688,30.738294707383368],[104.18060302734375,30.691068801620155],[104.22042846679688,30.739475058679485],[104.08859252929688,30.738294707383368]]]}},{"type":"Feature","properties":{},"geometry":{"type":"Polygon","coordinates":[[[104.08859252929688,30.52323029223123],[104.08309936523438,30.359841397025537],[104.1998291015625,30.519681272749402],[104.08859252929688,30.52323029223123]]]}},{"type":"Feature","properties":{},"geometry":{"type":"Polygon","coordinates":[[[103.70269775390624,30.675715404167743],[103.69308471679688,30.51494904517773],[103.83316040039062,30.51494904517773],[103.86474609375,30.682801890953776],[103.70269775390624,30.675715404167743]]]}}]}
```

#### 3、map.html

```html
<!Doctype html>
<html xmlns='http://www.w3.org/1999/xhtml'>
<head>
    <meta http-equiv='Content-Type' content='text/html;charset=utf-8'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'>
    <meta content='always' name='referrer'>
    <title>OpenLayers 3 :加载矢量地图</title>
    <link href='ol.css ' rel='stylesheet' type='text/css'/>
    <script type='text/javascript' src='ol.js' charset='utf-8'></script>
</head>

<body>

<div id='map' style='width: 1000px;height: 800px;margin: auto'></div>

<script>

    /**
     *  创建地图
     */
    new ol.Map({

        // 设置地图图层
        layers: [

            //创建一个使用Open Street Map地图源的图层
            new ol.layer.Tile({
                source: new ol.source.OSM()
            }),

            //加载一个geojson的矢量地图
            new ol.layer.Vector({
                source: new ol.source.Vector({
                    url: 'geojson/map.geojson',     // 地图来源
                    format: new ol.format.GeoJSON()    // 解析矢量地图的格式化类
                })
            })

        ],

        // 设置显示地图的视图
        view: new ol.View({
            center: [104,30],       // 设置地图显示中心于经度104度，纬度30度处
            zoom: 10,           // 设置地图显示层级为10
            projection: 'EPSG:4326'     //设置投影
        }),

        // 让id为map的div作为地图的容器
        target: 'map'

    })

</script>
</body>
</html>
```

#### 4、运行结果

![在这里插入图片描述](https://img-blog.csdnimg.cn/896566b20d1d408b8db6edf86831a514.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5aSn5qCR5LiL6Lqy6Zuo,size_20,color_FFFFFF,t_70,g_se,x_16)

## 三、获取矢量地图上的所有Feature,并设置样式

#### 1、map2.html

```html
<!Doctype html>
<html xmlns='http://www.w3.org/1999/xhtml'>
<head>
    <meta http-equiv='Content-Type' content='text/html;charset=utf-8'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'>
    <meta content='always' name='referrer'>
    <title>OpenLayers 3 :获取矢量地图上的所有Feature,并设置样式</title>
    <link href='ol.css ' rel='stylesheet' type='text/css'/>
    <script type='text/javascript' src='ol.js' charset='utf-8'></script>
</head>

<body>

<div id='map' style='width: 800px;height:500px;margin: auto'></div>
<br>
<div style='width: 800px;margin: auto'>
    <button type="button" onclick = 'updateStyle()' >修改Feature样式</button>
</div>

<script>

    /**
     *  创建地图
     */
    var map = new ol.Map({

        // 设置地图图层
        layers: [
            //创建一个使用Open Street Map地图源的图层
            new ol.layer.Tile({
                source: new ol.source.OSM()
            }),
        ],

        // 设置显示地图的视图
        view: new ol.View({
            center: [104,30],       // 设置地图显示中心于经度104度，纬度30度处
            zoom: 10,           // 设置地图显示层级为10
            projection: 'EPSG:4326'     //设置投影
        }),

        // 让id为map的div作为地图的容器
        target: 'map'
    });

    //创建一个矢量地图源图层，并设置样式
    var  vectorLayer =  new ol.layer.Vector({
            source: new ol.source.Vector({
                url: 'geojson/map.geojson',     // 地图来源
                format: new ol.format.GeoJSON()    // 解析矢量地图的格式化类
            }),
            // 设置样式，颜色为绿色，线条粗细为1个像素
            style: new ol.style.Style({
                stroke: new ol.style.Stroke({
                    color: 'green',
                    size: 1
                 })
            })
        });


    map.addLayer(vectorLayer);


    /**
     * 获取矢量图层上所有的Feature,并设置样式
     */
    function updateStyle(){

        //创建样式，颜色为红色，线条粗细为3个像素
        var  featureStyle = new ol.style.Style({
            stroke: new ol.style.Stroke({
                color: 'red',
                size: 3
            })
        })

        //获取矢量图层上所有的Feature
        var features =  vectorLayer.getSource().getFeatures()


        //遍历所有的Feature，并为每个Feature设置样式
        for (var i = 0;i<features.length;i++){
            features[i].setStyle(featureStyle)
        }


    }


</script>
</body>
</html>
```

#### 2、运行结果

![在这里插入图片描述](https://img-blog.csdnimg.cn/329c170057594eefb5d99337bff8193e.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5aSn5qCR5LiL6Lqy6Zuo,size_20,color_FFFFFF,t_70,g_se,x_16)

![在这里插入图片描述](https://img-blog.csdnimg.cn/7922b323667f4dc48c02d1f0f21aeaf9.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5aSn5qCR5LiL6Lqy6Zuo,size_20,color_FFFFFF,t_70,g_se,x_16)

## 4、矢量地图坐标系转换

矢量地图用的是`EPSG:4326`，我们可以通过OpenLayers 3内置了地图格式解析器，将坐标转换为`EPSG:3857`

#### 1、map3.html

```html
<!Doctype html>
<html xmlns='http://www.w3.org/1999/xhtml'>
<head>
    <meta http-equiv='Content-Type' content='text/html;charset=utf-8'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'>
    <meta content='always' name='referrer'>
    <title>OpenLayers 3 :矢量地图坐标系转换</title>
    <link href='ol.css ' rel='stylesheet' type='text/css'/>
    <script type='text/javascript' src='ol.js' charset='utf-8'></script>
    <script src="jquery-3.6.0.js"></script>
</head>

<body>

<div id='map' style='width: 1000px;height: 800px;margin: auto'></div>

<script>

    /**
     *  创建地图
     */
    var map = new ol.Map({

        // 设置地图图层
        layers: [

            //创建一个使用Open Street Map地图源的图层
            new ol.layer.Tile({
                source: new ol.source.OSM()
            })
        ],

        // 设置显示地图的视图
        view: new ol.View({
            center: ol.proj.fromLonLat([104,30]),       // 设置地图显示中心于经度104度，纬度30度处
            zoom: 10,           // 设置地图显示层级为10
        }),

        // 让id为map的div作为地图的容器
        target: 'map'

    });


    // 加载矢量地图
    function addGeoJSON(data) {
        var layer = new ol.layer.Vector({
            source: new ol.source.Vector({
                features: (new ol.format.GeoJSON()).readFeatures(data, {     // 用readFeatures方法可以自定义坐标系
                    dataProjection: 'EPSG:4326',                            // 设定JSON数据使用的坐标系
                    featureProjection: 'EPSG:3857'                          // 设定当前地图使用的feature的坐标系
                })
            })
        });
        map.addLayer(layer);
    };


    $.ajax({
        url: 'geojson/map.geojson',
        success: function(data, status) {
            // 成功获取到数据内容后，调用方法将矢量地图添加到地图
            addGeoJSON(data);
        }
    });

</script>
</body>
</html>
```

#### 2、运行结果

![在这里插入图片描述](https://img-blog.csdnimg.cn/65ff305ff0534973bbbd702523b2d843.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5aSn5qCR5LiL6Lqy6Zuo,size_20,color_FFFFFF,t_70,g_se,x_16)