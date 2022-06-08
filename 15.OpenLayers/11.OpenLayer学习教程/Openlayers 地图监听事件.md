- [Openlayers 地图监听事件_Southejor的博客-CSDN博客_openlayers 地图事件](https://blog.csdn.net/linzi19900517/article/details/123571074)

# [OpenLayers](https://so.csdn.net/so/search?q=OpenLayers&spm=1001.2101.3001.7020) 教程

地图中的[监听](https://so.csdn.net/so/search?q=监听&spm=1001.2101.3001.7020)事件，也是经常用的功能，一般用于获取坐标点，进而查询数据，或者通过缩放拖动地图完成需求，还有其他事件，比如双击事件、鼠标事件等。

这里介绍地图事件的监听单击双击、地图平移、地图缩放、鼠标悬浮以及取消监听功能等。

## Openlayers 地图监听事件

```html
<html lang="en">
<head>
    <meta charSet="utf-8">
    <!--注意：openlayers 原版的比较慢，这里引起自己服务器版-->
    <link rel="stylesheet" href="http://openlayers.vip/examples/css/ol.css" type="text/css">
    <style>
        /* 注意：这里必须给高度，否则地图初始化之后不显示；一般是计算得到高度，然后才初始化地图 */
        .map {
            height: 400px;
            width: 100%;
        }
        /* 鼠标位置背景 */
        .ol-mouse-position{
            background-color: white;
        }
    </style>
    <!--注意：openlayers 原版的比较慢，这里引起自己服务器版-->
    <script src="http://openlayers.vip/examples/resources/ol.js"></script>
    <script src="./tiandituLayers.js"></script>
    <title>OpenLayers event</title>
</head>
<body>
<h2>OpenLayers event</h2>
<!--地图容器，需要指定 id -->
<div id="map" class="map"></div>

<script type="text/javascript">
    var map = new ol.Map({
        // 地图容器
        target: 'map',
        // 地图图层，比如底图、矢量图等
        layers: [
            getIMG_CLayer(),
            getIBO_CLayer(),
            getCIA_CLayer(),
        ],
        // 地图视野
        view: new ol.View({
            projection: "EPSG:4326",
            // 定位
            center: [116, 39],
            // 缩放
            zoom: 4,
            maxZoom: 18,
            minZoom: 1,
        })
    });

    // 单击双击回调函数
    var func = function (event) {
        // 展示点击坐标
        alert(map.getCoordinateFromPixel(event.pixel));
    }

    // 单击事件
    function clickMap() {
        alert('点击地图试试！');
        map.on('click', func);
    }

    // 关闭单击事件
    function closeClick() {
        map.un('click', func);
    }

    // 记录原始地图双击对象
    var interaction = undefined;

    // 地图双击事件
    function doubleClick() {
        alert('双击地图试试！');
        // 获取地图原始双击事件对象
        interaction = map
            .getInteractions()
            .getArray()
            .find(interaction => {
                return interaction instanceof ol.interaction.DoubleClickZoom;
            });
        // 移除原始地图双击事件
        map.removeInteraction(interaction);
        map.on('dblclick', func);
    }

    // 关闭双击事件
    function closeDoubleClick() {
        // 还原原始地图双击事件
        interaction && map.addInteraction(interaction);
        map.un('dblclick', func);
    }

    //地图缩放回调函数
    let mapZoomEvent = function (event) {
        alert(map.getView().getZoom())
        console.log(event)
    }

    // 监听地图缩放
    function zoom() {
        alert('缩放地图试试！');
        //注册事件
        registerOnZoom(mapZoomEvent, true)
    }

    // 注册地图缩放和拖动事件方法
    // 第一个参数是监听事件，第二个参数为是否开启监听拖动（true为不开启）
    function registerOnZoom(eventListen, notListenMove) {

        // 记录地图缩放，用于判断拖动
        map.lastZoom = map.lastZoom || map.getView().getZoom();

        // 地图缩放事件
        let registerOnZoom = function (e) {
            // 不监听地图拖动事件
            if (notListenMove) {
                if (map.lastZoom != map.getView().getZoom()) {
                    eventListen && eventListen(e);
                }
            } else {
                eventListen && eventListen(e);
            }
            map.lastZoom = map.getView().getZoom();
        }

        // 保存缩放和拖动事件对象，用于后期移除
        let registerOnZoomArr = map.get('registerOnZoom') || [];

        registerOnZoomArr.push(registerOnZoom);

        // 使用地图 set 方法保存事件对象
        map.set('registerOnZoom', registerOnZoomArr);

        // 监听地图移动结束事件
        map.on('moveend', registerOnZoom);

        return eventListen;
    }

    // 关闭缩放
    function closeZoom() {
        removeZoomRegister()
    }

    //地图缩放和平移事件回调函数
    let mapZoomAndMove = function (event) {
        // 展示 extent
        alert(map.getView().calculateExtent(map.getSize()));
        // 展示 zoom
        alert(map.getView().getZoom())
    }

    // 开启缩放和拖动
    function zoomAndMove() {
        alert('拖动缩放地图试试！');
        //注册事件
        registerOnZoom(mapZoomAndMove);
    }

    // 关闭缩放和拖动
    function closeZooomAndMove() {
        removeZoomRegister()
    }

    // 移除缩放和拖动事件对象
    function removeZoomRegister() {

        let registerOnZoomArr = map.get('registerOnZoom');
        if (registerOnZoomArr && registerOnZoomArr.length > 0) {
            for (let i = 0; i < registerOnZoomArr.length; i++) {
                map.un('moveend', registerOnZoomArr[i]);
            }
        }
    }

    var mouseObject = undefined;

    // 添加鼠标位置控件
    function mouse() {
        mouseObject = new ol.control.MousePosition({});
        map.addControl(mouseObject);
    }

    // 关闭鼠标位置控件
    function closeMouse() {
        mouseObject && map.removeControl(mouseObject);
    }
</script>
<button id="button1" onClick="clickMap()">监听地图单击</button>
<button id="button2" onClick="closeClick()">关闭监听单击</button>
<br/>
<button id="button3" onClick="doubleClick()">监听地图双击</button>
<button id="button4" onClick="closeDoubleClick()">关闭地图双击</button>
<br/>
<button id="button5" onClick="zoom()">监听地图缩放</button>
<button id="button6" onClick="closeZoom()">关闭地图缩放</button>
<br/>
<button id="button7" onClick="zoomAndMove()">监听地图缩放和平移</button>
<button id="button8" onClick="closeZooomAndMove()">关闭监听地图缩放和平移</button>
<br/>
<button id="button7" onClick="mouse()">开启显示鼠标位置</button>
<button id="button8" onClick="closeMouse()">关闭显示鼠标位置</button>
</body>
</html>
```

## 在线示例

**地图监听事件：**[Openlayers event](http://openlayers.vip/examples/csdn/Openlayers-event.html)