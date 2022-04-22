- [OpenLayers 3 内置交互_大树下躲雨的博客-CSDN博客](https://blog.csdn.net/weixin_43521890/article/details/122942656)

## 一、OpenLayers 3 内置交互类

OpenLayers 3提供了最基本的地图放大，缩小，平移等功能，以满足用户浏览地图的需要。 这些功能都是内置的，实现类都放在包`ol.interaction`下面，可以通过官网[API](https://so.csdn.net/so/search?q=API&spm=1001.2101.3001.7020)查询到。

| 交互类                         | 描述                                                |
| ------------------------------ | --------------------------------------------------- |
| 旋转                           |                                                     |
| ol.interaction.DragRotate      | 按住alt+shift键，用鼠标左键拖动地图，就能让地图旋转 |
| ol.interaction.PinchRotate     | 两个手指旋转地图，针对触摸屏                        |
| 平移                           |                                                     |
| ol.interaction.DragPan         | 鼠标或手指拖拽平移地图                              |
| ol.interaction.KeyboardPan     | 使用键盘方向键平移地图                              |
| 缩放                           |                                                     |
| ol.interaction.DragZoom        | 鼠标拖拽缩放，一般配合一个键盘按键辅助              |
| ol.interaction.PinchZoom       | 两个手指缩放地图，针对触摸屏                        |
| ol.interaction.KeyboardZoom    | 使用键盘 + 和 - 按键进行缩放                        |
| ol.interaction.DoubleClickZoom | 鼠标或手指双击缩放地图                              |
| ol.interaction.MouseWheelZoom  | 鼠标滚轮缩放地图                                    |

## 二、创建地图时设置交互

#### 1、默认方式

在创建地图时，`ol.interaction.defaults()`这个函数用于返回默认的交互方式。默认的交互方式会开启所有的交互，可以旋转、平移、缩放

##### （1）map.html

```html
<!Doctype html>
<html xmlns='http://www.w3.org/1999/xhtml'>
<head>
    <meta http-equiv='Content-Type' content='text/html;charset=utf-8'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'>
    <meta content='always' name='referrer'>
    <title>OpenLayers 3 :地图交互默认设置</title>
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
	
		 // 不设置的情况下，默认会设置为ol.interaction.defaults()
        interactions: ol.interaction.defaults(), 

        // 设置地图图层
        layers: [

            //创建一个使用Open Street Map地图源的图层
            new ol.layer.Tile({
                source: new ol.source.OSM()
            })

        ],

        // 设置显示地图的视图
        view: new ol.View({
            center: [0,0],       // 设置地图显示中心于经度0度，纬度0度处
            zoom: 0            // 设置地图显示层级为0
        }),

        // 让id为map的div作为地图的容器
        target: 'map'

    })

</script>
</body>
</html>
```

#### 2、自定义交互

创建地图时自定义关闭指定的交互方式。

##### （1）map2.html

```html
<!Doctype html>
<html xmlns='http://www.w3.org/1999/xhtml'>
<head>
    <meta http-equiv='Content-Type' content='text/html;charset=utf-8'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'>
    <meta content='always' name='referrer'>
    <title>OpenLayers 3 :地图交互自定义</title>
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

        //false:禁用
        //true:启动（默认值）
        interactions: ol.interaction.defaults({
            dragRotate:false,           //按住alt+shift键，用鼠标左键拖动地图，就能让地图旋转；
            pinchRotate:false,          //两个手指旋转地图，针对触摸屏；

            dragPan:false,              //鼠标或手指拖拽平移地图；
            keyboardPan:false,          //使用键盘方向键平移地图；

            dragZoom:false,             //鼠标拖拽缩放，一般配合一个键盘按键辅助；
            pinchZoom:false,            //两个手指缩放地图，针对触摸屏；
            keyboardZoom:false,         //使用键盘 + 和 - 按键进行缩放；
            doubleClickZoom: false,     //鼠标或手指双击缩放地图；
            mouseWheelZoom: false,      //鼠标滚轮缩放地图;

        }),

        // 设置地图图层
        layers: [

            //创建一个使用Open Street Map地图源的图层
            new ol.layer.Tile({
                source: new ol.source.OSM()
            })

        ],

        // 设置显示地图的视图
        view: new ol.View({
            center: [0,0],       // 设置地图显示中心于经度0度，纬度0度处
            zoom: 0            // 设置地图显示层级为0
        }),

        // 让id为map的div作为地图的容器
        target: 'map'

    })

</script>
</body>
</html>
```

## 三、动态设置地图交互

#### 1、项目结构

![在这里插入图片描述](https://img-blog.csdnimg.cn/77f46a7b7d454bd5b411bb132cfdaaab.png)

#### 2、map3.html

```html
<!Doctype html>
<html xmlns='http://www.w3.org/1999/xhtml'>
<head>
    <meta http-equiv='Content-Type' content='text/html;charset=utf-8'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'>
    <meta content='always' name='referrer'>
    <title>OpenLayers 3 :动态设置地图交互</title>
    <link href='ol.css ' rel='stylesheet' type='text/css'/>
    <script type='text/javascript' src='ol.js' charset='utf-8'></script>
</head>

<body>

<div id='map' style='width: 1000px;height: 800px;margin: auto'></div>
<div style="width: 1000px;margin: auto">
    <div>
        旋转:
    </div>
    <button onclick="setMapInteractions(1)">DragRotate</button>
    <button onclick="setMapInteractions(2)">PinchRotate</button>
    <div>
        平移:
    </div>
    <button onclick="setMapInteractions(3)">DragPan</button>
    <button onclick="setMapInteractions(4)">KeyboardPan</button>
    <div>
        缩放:
    </div>
    <button onclick="setMapInteractions(5)">DragZoom</button>
    <button onclick="setMapInteractions(6)">PinchZoom</button>
    <button onclick="setMapInteractions(7)">KeyboardZoom</button>
    <button onclick="setMapInteractions(8)">DoubleClickZoom</button>
    <button onclick="setMapInteractions(9)">MouseWheelZoom</button>
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



    /**
     *      设置地图交互
     *            //旋转
     *       1    DragRotate    //按住alt+shift键，用鼠标左键拖动地图，就能让地图旋转；
     *       2    PinchRotate   //两个手指旋转地图，针对触摸屏；
     *
     *           //平移
     *       3    DragPan   //鼠标或手指拖拽平移地图；
     *       4    KeyboardPan   //使用键盘方向键平移地图；
     *
     *           //缩放
     *       5    DragZoom    //鼠标拖拽缩放，一般配合一个键盘按键辅助；
     *       6    PinchZoom     //两个手指缩放地图，针对触摸屏；
     *       7    KeyboardZoom   //使用键盘 + 和 - 按键进行缩放；
     *       8    DoubleClickZoom   //鼠标或手指双击缩放地图；
     *       9    MouseWheelZoom  //鼠标滚轮缩放地图。
     *
     *
     */
    function setMapInteractions(index) {

        var interactions = null;

        var text = ''


        //获取地图交互对象，并遍历
        this.map.getInteractions().forEach(function (element, i, array) {

            if (interactions === null) {
                switch (index) {
                    case 1:
                        //判断交互对象是否属于DragRotate
                        //按住alt+shift键，用鼠标左键拖动地图，就能让地图旋转；
                        if (element instanceof this.ol.interaction.DragRotate) {
                            interactions = element;
                        }
                        text = "按住alt+shift键，用鼠标左键拖动地图，就能让地图旋转"
                        break;
                    case 2:
                        //判断交互对象是否属于PinchRotate
                        //两个手指旋转地图，针对触摸屏；
                        if (element instanceof this.ol.interaction.PinchRotate) {
                            interactions = element;
                        }
                        text = "两个手指旋转地图，针对触摸屏"
                        break;
                    case 3:
                        //判断交互对象是否属于DragPan
                        //鼠标或手指拖拽平移地图；
                        if (element instanceof this.ol.interaction.DragPan) {
                            interactions = element;
                        }
                        text = "鼠标或手指拖拽平移地图"
                        break;
                    case 4:
                        //判断交互对象是否属于KeyboardPan
                        //使用键盘方向键平移地图；
                        if (element instanceof this.ol.interaction.KeyboardPan) {
                            interactions = element;
                        }
                        text = "使用键盘方向键平移地图"
                        break;
                    case 5:
                        //判断交互对象是否属于DragZoom
                        //鼠标拖拽缩放，一般配合一个键盘按键辅助；
                        if (element instanceof this.ol.interaction.DragZoom) {
                            interactions = element;
                        }
                        text = "鼠标拖拽缩放，一般配合一个键盘按键辅助"
                        break;
                    case 6:
                        //判断交互对象是否属于PinchZoom
                        //两个手指缩放地图，针对触摸屏；
                        if (element instanceof this.ol.interaction.PinchZoom) {
                            interactions = element;
                        }
                        text = "两个手指缩放地图，针对触摸屏"
                        break;
                    case 7:
                        //判断交互对象是否属于KeyboardZoom
                        //使用键盘 + 和 - 按键进行缩放；
                        if (element instanceof this.ol.interaction.KeyboardZoom) {
                            interactions = element;
                        }
                        text = "使用键盘 + 和 - 按键进行缩放"
                        break;
                    case 8:
                        //判断交互对象是否属于DoubleClickZoom
                        //鼠标或手指双击缩放地图；
                        if (element instanceof this.ol.interaction.DoubleClickZoom) {
                            interactions = element;
                        }
                        text = "鼠标或手指双击缩放地图"
                        break;
                    case 9:
                        //判断交互对象是否属于MouseWheelZoom
                        //鼠标滚轮缩放地图。
                        if (element instanceof this.ol.interaction.MouseWheelZoom) {
                            interactions = element;
                        }
                        text = "鼠标滚轮缩放地图"
                        break;
                }
            }
        })

        //设置地图交互
        if (interactions != null) {

            var flag = interactions.getActive()
            interactions.setActive(!flag)

            flag = interactions.getActive()

            if (flag){
                console.log("开启："+text)
            }else{
                console.log("关闭："+text)
            }
            console.log("---------------------")


        }

    }

</script>
</body>
</html>
```

#### 3、运行截图

![在这里插入图片描述](https://img-blog.csdnimg.cn/bc36b6c929764c1e850fb807451dfe1d.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5aSn5qCR5LiL6Lqy6Zuo,size_20,color_FFFFFF,t_70,g_se,x_16)