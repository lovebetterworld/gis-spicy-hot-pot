- [OpenLayers 3地图添加图标_大树下躲雨的博客-CSDN博客_openlayers 添加图标](https://blog.csdn.net/weixin_43521890/article/details/122126151)

## 一、overlay方式在地图添加图标

#### 1、项目结构

![在这里插入图片描述](https://img-blog.csdnimg.cn/9e2b95645aca46458a79089769f02670.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5aSn5qCR5LiL6Lqy6Zuo,size_20,color_FFFFFF,t_70,g_se,x_16)
![在这里插入图片描述](https://img-blog.csdnimg.cn/41b0bf1a273640819ce2042e807d2bd2.png)

#### 2、map.html

```html
<!Doctype html>
<html xmlns='http://www.w3.org/1999/xhtml'>
<head>
    <meta http-equiv='Content-Type' content='text/html;charset=utf-8'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'>
    <meta content='always' name='referrer'>
    <title>OpenLayers 3 :overlay方式在地图添加图标</title>
    <link href='ol.css ' rel='stylesheet' type='text/css'/>
    <script type='text/javascript' src='ol.js' charset='utf-8'></script>
</head>

<body>

<div id='map' style='width: 800px;height: 500px;margin: auto'></div>
<div id="anchor"><img src="images/user.png" alt="图标"/></div>

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
            zoom: 5           // 设置地图显示层级为5
        }),

        // 让id为map的div作为地图的容器
        target: 'map'

    });

    /**
     * 创建覆盖对象，覆盖对象引用的是地图上的图片
     */
    var anchor = new ol.Overlay({
        element: document.getElementById('anchor')
    });

    /**
     * 设置覆盖对象位置
     */
    anchor.setPosition([0, 0])

    /**
     * 将覆盖对象添加到地图上
     */
    map.addOverlay(anchor)


</script>
</body>
</html>
```

#### 3、运行结果

![在这里插入图片描述](https://img-blog.csdnimg.cn/dcabc7d08c3e42638abd13ba5c148294.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5aSn5qCR5LiL6Lqy6Zuo,size_20,color_FFFFFF,t_70,g_se,x_16)

## 二、Feature + Style方式在地图添加图标

#### 1、map2.html

```html
<!Doctype html>
<html xmlns='http://www.w3.org/1999/xhtml'>
<head>
    <meta http-equiv='Content-Type' content='text/html;charset=utf-8'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'>
    <meta content='always' name='referrer'>
    <title>OpenLayers 3 :Feature + Style方式在地图添加图标</title>
    <link href='ol.css ' rel='stylesheet' type='text/css'/>
    <script type='text/javascript' src='ol.js' charset='utf-8'></script>
</head>

<body>

<div id='map' style='width: 800px;height: 500px;margin: auto'></div>

<script>


    /**
     * 创建一个Vector的layer来放置图标
     */
    var layer = new ol.layer.Vector({
        source: new ol.source.Vector()
    })

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
            layer
        ],

        // 设置显示地图的视图
        view: new ol.View({
            center: [0, 0],       // 设置地图显示中心于经度0度，纬度0度处
            zoom: 10           // 设置地图显示层级为5
        }),

        // 让id为map的div作为地图的容器
        target: 'map'

    });

    //创建一个Feature，并设置好在地图的位置
    var anchor = new ol.Feature({
        geometry: new ol.geom.Point([0, 0])
    });

    // 设置Feature样式，在样式中就可以设置图标
    anchor.setStyle(new ol.style.Style({
        image: new ol.style.Icon({
            src: 'images/user.png'
        })
    }));

    // 将Feature添加到之前的创建的layer中去
    layer.getSource().addFeature(anchor);


    // 监听地图层级变化
    map.getView().on('change:resolution', function(){
        //获取图标的样式对象
        var style = anchor.getStyle();

        // 重新设置图标的缩放率，基于层级10来做缩放
        style.getImage().setScale(this.getZoom() / 10);

        anchor.setStyle(style);

    })


</script>
</body>
</html>
```

#### 2、运行结果

![在这里插入图片描述](https://img-blog.csdnimg.cn/9ce58b5307cd41ccb00fceeff94ea5b6.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5aSn5qCR5LiL6Lqy6Zuo,size_20,color_FFFFFF,t_70,g_se,x_16)

## 三、地图添加svg图标

#### 1、map3.html

```html
<!Doctype html>
<html xmlns='http://www.w3.org/1999/xhtml'>
<head>
    <meta http-equiv='Content-Type' content='text/html;charset=utf-8'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'>
    <meta content='always' name='referrer'>
    <title>OpenLayers 3 :地图添加svg图标</title>
    <link href='ol.css ' rel='stylesheet' type='text/css'/>
    <script type='text/javascript' src='ol.js' charset='utf-8'></script>
</head>

<body>

<div id='map' style='width: 800px;height: 500px;margin: auto'></div>

<script>


    /**
     * 创建一个Vector的layer来放置图标
     */
    var layer = new ol.layer.Vector({
        source: new ol.source.Vector()
    })

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
            layer
        ],

        // 设置显示地图的视图
        view: new ol.View({
            center: [0, 0],       // 设置地图显示中心于经度0度，纬度0度处
            zoom: 10           // 设置地图显示层级为5
        }),

        // 让id为map的div作为地图的容器
        target: 'map'
    });


    //创建一个Feature，并设置好在地图的位置
    var anchor = new ol.Feature({
        geometry: new ol.geom.Point([0,0])
    });

    //构建svg的Image对象
    // svg图标代码
    var svg = '<svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="30px" height="30px" viewBox="0 0 30 30" enable-background="new 0 0 30 30" xml:space="preserve">'+
        '<path fill="#156BB1" d="M22.906,10.438c0,4.367-6.281,14.312-7.906,17.031c-1.719-2.75-7.906-12.665-7.906-17.031S10.634,2.531,15,2.531S22.906,6.071,22.906,10.438z"/>'+
        '<circle fill="#FFFFFF" cx="15" cy="10.677" r="3.291"/></svg>';
    //创建图片对象
    var mysvg = new Image();
    mysvg.src = 'data:image/svg+xml,' + escape(svg);


    //图标设置样式
    anchor.setStyle(new ol.style.Style({
        image: new ol.style.Icon({
            img: mysvg,    // 设置Image对象
            imgSize: [30, 30]    // 及图标大小
        })
    }));

    // 将Feature添加到之前的创建的layer中去
    layer.getSource().addFeature(anchor);


</script>
</body>
</html>
```

#### 2、运行结果

![在这里插入图片描述](https://img-blog.csdnimg.cn/bd193869850b42958175c89be8321aad.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5aSn5qCR5LiL6Lqy6Zuo,size_20,color_FFFFFF,t_70,g_se,x_16)

## 四、规则几何体图标

#### 1、map4.html

```html
<!Doctype html>
<html xmlns='http://www.w3.org/1999/xhtml'>
<head>
    <meta http-equiv='Content-Type' content='text/html;charset=utf-8'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'>
    <meta content='always' name='referrer'>
    <title>OpenLayers 3 :规则几何体图标</title>
    <link href='ol.css ' rel='stylesheet' type='text/css'/>
    <script type='text/javascript' src='ol.js' charset='utf-8'></script>
</head>

<body>

<div id='map' style='width: 800px;height: 500px;margin: auto'></div>

<script>

    /**
     * 创建一个Vector的layer来放置图标
     */
    var layer = new ol.layer.Vector({
        source: new ol.source.Vector()
    })


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
            layer
        ],

        // 设置显示地图的视图
        view: new ol.View({
            center: [0, 0],       // 设置地图显示中心于经度0度，纬度0度处
            zoom: 10,           // 设置地图显示层级为10
            projection: 'EPSG:4326' //设置投影
        }),

        // 让id为map的div作为地图的容器
        target: 'map'
    });

    // 添加一个三角形
    var shape = new ol.Feature({
        geometry: new ol.geom.Point([0, 0])
    });
    shape.setStyle(new ol.style.Style({
        image: new ol.style.RegularShape({
            points: 3,    // 顶点数
            radius: 10,    // 图形大小，单位为像素
            stroke: new ol.style.Stroke({ // 设置边的样式
                color: 'red',
                size: 2
            })
        })
    }));

    // 将Feature添加到之前的创建的layer中去
    layer.getSource().addFeature(shape);

    // 添加一个五星
    var star = new ol.Feature({
        geometry: new ol.geom.Point([0.1, 0.1])
    });
    star.setStyle(new ol.style.Style({
        image: new ol.style.RegularShape({
            points: 5,    // 顶点个数
            radius1: 20, // 外圈大小
            radius2: 10, // 内圈大小
            stroke: new ol.style.Stroke({ // 设置边的样式
                color: 'red',
                size: 2
            }),
            fill: new ol.style.Fill({ // 设置五星填充样式
                color: 'blue'
            })
        })
    }));

    // 将Feature添加到之前的创建的layer中去
    layer.getSource().addFeature(star);


</script>
</body>
</html>
```

#### 2、运行结果

![在这里插入图片描述](https://img-blog.csdnimg.cn/03ad9ecbc81e4aca9682aba3b4cd060b.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5aSn5qCR5LiL6Lqy6Zuo,size_20,color_FFFFFF,t_70,g_se,x_16)

## 五、canvas自绘图标

#### 1、map5.html

```html
<!Doctype html>
<html xmlns='http://www.w3.org/1999/xhtml'>
<head>
    <meta http-equiv='Content-Type' content='text/html;charset=utf-8'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'>
    <meta content='always' name='referrer'>
    <title>OpenLayers 3 :canvas自绘图标</title>
    <link href='ol.css ' rel='stylesheet' type='text/css'/>
    <script type='text/javascript' src='ol.js' charset='utf-8'></script>
</head>

<body>

<div id='map' style='width: 800px;height: 500px;margin: auto'></div>

<script>

    /**
     * 创建一个Vector的layer来放置图标
     */
    var layer = new ol.layer.Vector({
        source: new ol.source.Vector()
    })

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
            layer
        ],

        // 设置显示地图的视图
        view: new ol.View({
            center: [0, 0],       // 设置地图显示中心于经度0度，纬度0度处
            zoom: 10           // 设置地图显示层级为5
        }),

        // 让id为map的div作为地图的容器
        target: 'map'

    });

    // 使用canvas绘制一个不规则几何图形
    var canvas =document.createElement('canvas');
    canvas.width = 20;
    canvas.height = 20;
    var context = canvas.getContext("2d");
    context.strokeStyle = "red";
    context.lineWidth = 1;
    context.beginPath();
    context.moveTo(0, 0);
    context.lineTo(20, 10);
    context.lineTo(0, 20);
    context.lineTo(10, 10);
    context.lineTo(0, 0);
    context.stroke();

    // 把绘制了的canvas设置到style里面
    var style = new ol.style.Style({
        image: new ol.style.Icon({
            img: canvas,
            imgSize: [canvas.width, canvas.height],
            rotation: 90 * Math.PI / 180
        })
    });

    //创建一个Feature，并设置好在地图的位置
    var shape = new ol.Feature({
        geometry: new ol.geom.Point([0, 0])
    });

    // 应用具有不规则几何图形的样式到Feature
    shape.setStyle(style);

    // 将Feature添加到之前的创建的layer中去
    layer.getSource().addFeature(shape);


</script>
</body>
</html>
```

#### 2、运行结果

![在这里插入图片描述](https://img-blog.csdnimg.cn/dace4f3f44d84413a813a86a75f5ba09.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5aSn5qCR5LiL6Lqy6Zuo,size_20,color_FFFFFF,t_70,g_se,x_16)

## 六、文字标注

#### 1、map6.html

```html
<!Doctype html>
<html xmlns='http://www.w3.org/1999/xhtml'>
<head>
    <meta http-equiv='Content-Type' content='text/html;charset=utf-8'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'>
    <meta content='always' name='referrer'>
    <title>OpenLayers 3 :文字标注</title>
    <link href='ol.css ' rel='stylesheet' type='text/css'/>
    <script type='text/javascript' src='ol.js' charset='utf-8'></script>
</head>

<body>

<div id='map' style='width: 800px;height: 500px;margin: auto'></div>

<script>


    /**
     * 创建一个Vector的layer来放置图标
     */
    var layer = new ol.layer.Vector({
        source: new ol.source.Vector()
    })

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
            layer
        ],

        // 设置显示地图的视图
        view: new ol.View({
            center: [0, 0],       // 设置地图显示中心于经度0度，纬度0度处
            zoom: 10           // 设置地图显示层级为5
        }),

        // 让id为map的div作为地图的容器
        target: 'map'

    });

    //创建一个Feature，并设置好在地图的位置
    var anchor = new ol.Feature({
        geometry: new ol.geom.Point([0, 0])
    });


    // 设置文字style
    anchor.setStyle(new ol.style.Style({
        text: new ol.style.Text({
            font: '10px sans-serif', //默认这个字体，可以修改成其他的，格式和css的字体设置一样
            text: '你好 OpenLayers 3',
            fill: new ol.style.Fill({
                color: 'red'
            })
        })
    }));

    // 将Feature添加到之前的创建的layer中去
    layer.getSource().addFeature(anchor);


</script>
</body>
</html>
```

#### 2、运行结果

![在这里插入图片描述](https://img-blog.csdnimg.cn/c378bf2de524496aa3356d6586107b54.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5aSn5qCR5LiL6Lqy6Zuo,size_20,color_FFFFFF,t_70,g_se,x_16)

## 七、styleFunction方式在地图添加图标

#### 1、map7.html

```html
<!Doctype html>
<html xmlns='http://www.w3.org/1999/xhtml'>
<head>
    <meta http-equiv='Content-Type' content='text/html;charset=utf-8'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'>
    <meta content='always' name='referrer'>
    <title>OpenLayers 3 :文字标注</title>
    <link href='ol.css ' rel='stylesheet' type='text/css'/>
    <script type='text/javascript' src='ol.js' charset='utf-8'></script>
</head>

<body>

<div id='map' style='width: 800px;height: 500px;margin: auto'></div>

<script>


    /**
     * 创建一个Vector的layer来放置图标
     */
    var layer = new ol.layer.Vector({
        source: new ol.source.Vector()
    })


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
            layer
        ],

        // 设置显示地图的视图
        view: new ol.View({
            center: [0, 0],       // 设置地图显示中心于经度0度，纬度0度处
            zoom: 10           // 设置地图显示层级为5
        }),

        // 让id为map的div作为地图的容器
        target: 'map'

    });

    //创建一个Feature，并设置好在地图的位置
    var anchor = new ol.Feature({
        geometry: new ol.geom.Point([0, 0])
    });

    // 应用style function，动态的获取样式
    anchor.setStyle(function(resolution){
        return [new ol.style.Style({
            image: new ol.style.Icon({
                src: 'images/user.png',
                scale: map.getView().getZoom() / 10
            })
        })];
    });

    // 将Feature添加到之前的创建的layer中去
    layer.getSource().addFeature(anchor);


</script>
</body>
</html>
```

#### 2、运行结果

![在这里插入图片描述](https://img-blog.csdnimg.cn/1a4f809a675c4834b85421a9e09a7305.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5aSn5qCR5LiL6Lqy6Zuo,size_20,color_FFFFFF,t_70,g_se,x_16)