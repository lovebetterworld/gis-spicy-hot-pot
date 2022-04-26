- [OpenLayers 3 事件应用_大树下躲雨的博客-CSDN博客_openlayers事件](https://blog.csdn.net/weixin_43521890/article/details/122684705)

# [OpenLayers](https://so.csdn.net/so/search?q=OpenLayers&spm=1001.2101.3001.7020) 3 事件应用

```html
常用鼠标事件
    地图鼠标左键单击事件
    对应的类为ol.Map，事件名为singleclick。

    地图鼠标左键双击事件
    对应的类为ol.Map，事件名为dblclick。

    地图鼠标点击事件
    对应的类为ol.Map，事件名为click。

    地图鼠标移动事件
    对应的类为ol.Map，事件名为pointermove。

    地图鼠标拖拽事件
    对应的类为ol.Map，事件名为pointerdrag。

    地图移动事件
    对应的类为ol.Map，事件名为moveend。
```

## 一、简单事件应用：鼠标左键单击事件

#### 1、项目结构

![在这里插入图片描述](https://img-blog.csdnimg.cn/6890917991754591abbf167f8e115464.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5aSn5qCR5LiL6Lqy6Zuo,size_20,color_FFFFFF,t_70,g_se,x_16)

#### 2、map.html

```html
<!Doctype html>
<html xmlns='http://www.w3.org/1999/xhtml'>
<head>
    <meta http-equiv='Content-Type' content='text/html;charset=utf-8'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'>
    <meta content='always' name='referrer'>
    <title>OpenLayers 3 :鼠标左键单击事件</title>
    <link href='ol.css ' rel='stylesheet' type='text/css'/>
    <script type='text/javascript' src='ol.js' charset='utf-8'></script>
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
            center: [0, 0],       // 设置地图显示中心于经度0度，纬度0度处
            zoom: 0            // 设置地图显示层级为0
        }),

        // 让id为map的div作为地图的容器
        target: 'map'

    });


    // 监听singleclick（鼠标左键单击）事件
    map.on('singleclick', function (event) {
        console.log("鼠标左键点击了")
    })

</script>
</body>
</html>
```

#### 3、运行截图

![在这里插入图片描述](https://img-blog.csdnimg.cn/1e53b135713443828adf23cea40fc7bb.png)

## 二、事件注销

#### 1、map2.html

```html
<!Doctype html>
<html xmlns='http://www.w3.org/1999/xhtml'>
<head>
    <meta http-equiv='Content-Type' content='text/html;charset=utf-8'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'>
    <meta content='always' name='referrer'>
    <title>OpenLayers 3 :事件注销</title>
    <link href='ol.css ' rel='stylesheet' type='text/css'/>
    <script type='text/javascript' src='ol.js' charset='utf-8'></script>
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
            center: [0, 0],       // 设置地图显示中心于经度0度，纬度0度处
            zoom: 0            // 设置地图显示层级为0
        }),

        // 让id为map的div作为地图的容器
        target: 'map'

    });


    
    // 监听dblclick（鼠标左键双击）事件
    var dblclickListener = function (event) {
        console.log("鼠标左键双击了")
        // 在响应一次后，注销dblclick事件监听
        map.un('dblclick', dblclickListener);
        console.log("dblclick事件注销")
    };
    map.on('dblclick', dblclickListener);


    // 监听pointerdrag(地图鼠标拖拽)事件
    // 使用once函数，只会响应一次事件，之后自动注销事件监听
    map.once('pointerdrag', function (event) {
        console.log("地图发生拖拽")
        console.log("pointerdrag事件注销")
    })


</script>
</body>
</html>
```

#### 2、运行截图

![在这里插入图片描述](https://img-blog.csdnimg.cn/d45fb673c7304a13811ff3681a88efdf.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5aSn5qCR5LiL6Lqy6Zuo,size_20,color_FFFFFF,t_70,g_se,x_16)

## 三、常用事件

#### 1、map3.html

```html
<!Doctype html>
<html xmlns='http://www.w3.org/1999/xhtml'>
<head>
    <meta http-equiv='Content-Type' content='text/html;charset=utf-8'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'>
    <meta content='always' name='referrer'>
    <title>OpenLayers 3 :常用事件</title>
    <link href='ol.css ' rel='stylesheet' type='text/css'/>
    <script type='text/javascript' src='ol.js' charset='utf-8'></script>
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
            center: [0, 0],       // 设置地图显示中心于经度0度，纬度0度处
            zoom: 0            // 设置地图显示层级为0
        }),

        // 让id为map的div作为地图的容器
        target: 'map'

    });

    // 响应单击事件
    map.on('singleclick', function (event) {
        console.log("触发了map的单击事件：singleclick")
    });

    // 响应双击事件
    map.on('dblclick', function (event) {
        console.log("触发了map的双击事件：dblclick")
    });

    // 响应点击事件
    map.on('click', function (event) {
        console.log("触发了map的点击事件：click")
    });

    //响应鼠标移动事件
    map.on('pointermove', function (event) {
        console.log("触发了map的鼠标移动事件：pointermove")
    });

    // 响应拖拽事件
    map.on('pointerdrag', function (event) {
        console.log("触发了map的拖拽事件：pointerdrag")
    });

    // 地图移动事件
    map.on('moveend', function (event) {
        console.log("触发了map的地图移动事件：moveend")
    });

</script>
</body>
</html>
```

#### 2、运行截图

![在这里插入图片描述](https://img-blog.csdnimg.cn/2740a101bd5c4ad5bb740aa55c7feb9d.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5aSn5qCR5LiL6Lqy6Zuo,size_20,color_FFFFFF,t_70,g_se,x_16)

## 四、自定事件

#### 1、map4.html

```html
<!Doctype html>
<html xmlns='http://www.w3.org/1999/xhtml'>
<head>
    <meta http-equiv='Content-Type' content='text/html;charset=utf-8'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'>
    <meta content='always' name='referrer'>
    <title>OpenLayers 3 :自定义事件</title>
    <link href='ol.css ' rel='stylesheet' type='text/css'/>
    <script type='text/javascript' src='ol.js' charset='utf-8'></script>
</head>

<body>

<div id='map' style='width: 1000px;height: 800px;margin: auto'></div>

<script>

    // 在原点处创建一个feature
    var feature = new ol.Feature({
        geometry: new ol.geom.Point([0, 0])
    });

    // 并设置为半径为100像素的圆，用红色填充
    feature.setStyle(new ol.style.Style({
        image: new ol.style.Circle({
            radius: 100,
            fill: new ol.style.Fill({
                color: 'red'
            })
        })
    }));


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
            // 把创建的feature放到另一个图层里
            new ol.layer.Vector({
                source: new ol.source.Vector({
                    features: [feature]
                })
            })
        ],

        // 设置显示地图的视图
        view: new ol.View({
            center: [0, 0],       // 设置地图显示中心于经度0度，纬度0度处
            zoom: 0            // 设置地图显示层级为0
        }),

        // 让id为map的div作为地图的容器
        target: 'map'

    });


    // 为地图注册鼠标移动事件的监听
    map.on('pointermove', function (event) {
        //鼠标与feature交互
        if (map.hasFeatureAtPixel(event.pixel)) {
            map.forEachFeatureAtPixel(event.pixel, function (f) {
                //当鼠标为移入feature时，发送自定义的mousein消息
                if (f === feature){
                    f.dispatchEvent({type: 'mousein', event: event});
                    console.log("鼠标移入圆")
                }
            });
        } else {
            //鼠标与map交互
            //当鼠标为移出feature时，发送自定义的mousemove消息
            feature.dispatchEvent({type: 'mouseout', event: event});
            console.log("鼠标移出圆")
        }
    });


    // 为feature注册自定义事件mousein的监听
    feature.on('mousein', function (event) {
        // 修改feature的样式为半径150像素的园，用蓝色填充
        this.setStyle(new ol.style.Style({
            image: new ol.style.Circle({
                radius: 150,
                fill: new ol.style.Fill({
                    color: 'blue'
                })
            })
        }));
    });


    // 为feature注册自定义事件mouseout的监听
    feature.on('mouseout', function (event) {
        // 修改feature的样式为半径100像素的园，用蓝色填充
        this.setStyle(new ol.style.Style({
            image: new ol.style.Circle({
                radius: 100,
                fill: new ol.style.Fill({
                    color: 'yellow'
                })
            })
        }));
    });

</script>
</body>
</html>
```

#### 2、运行截图

![在这里插入图片描述](https://img-blog.csdnimg.cn/9896f0877a8948a7900f9cdb962a0433.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5aSn5qCR5LiL6Lqy6Zuo,size_20,color_FFFFFF,t_70,g_se,x_16)