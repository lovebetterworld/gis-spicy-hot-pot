- [Openlayers View 限制显示范围、限制缩放级别、限制拖动等_Southejor的博客-CSDN博客_openlayers view](https://blog.csdn.net/linzi19900517/article/details/124400343)

# [OpenLayers](https://so.csdn.net/so/search?q=OpenLayers&spm=1001.2101.3001.7020) 教程

在 Openlayers 中，View 是对地图视野的操作，有时候也被翻译为视图，主要是鼠标交互操作，如放大缩小拖动等。

本示例主要介绍：**限制显示范围、限制显示级别、限制拖动**。

## Openlayers 视图（View）常用方法介绍

```html
<html lang="en">
<head>
    <meta charset="utf-8">
    <!--注意：openlayers 原版的比较慢，这里引起自己服务器版-->
    <link rel="stylesheet" href="http://openlayers.vip/examples/css/ol.css" type="text/css">
    <style>
        /* 注意：这里必须给高度，否则地图初始化之后不显示；一般是计算得到高度，然后才初始化地图 */
        .map {
            height: 400px;
            width: 100%;
            float: left;
        }
    </style>
    <!--注意：openlayers 原版的比较慢，这里引起自己服务器版-->
    <script src="http://openlayers.vip/examples/resources/ol.js"></script>
    <script src="./tiandituLayers.js"></script>
    <title>OpenLayers example</title>
</head>
<body>
<h2>View</h2>
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
            center: [115.67724700667199, 37.73879478106912],
            // 缩放
            zoom: 6,
            maxZoom: 18,
            minZoom: 1,
        })
    });

    // 获取地图视野对象
    var view = map.getView();

    // 限制显示范围
    function limitExtent(flag) {
        // 设置范围
        let extent = [116.27648, 39.84042, 116.4605, 39.9721];
        let viewExtent = new ol.View({
            projection: "EPSG:4326",
            //必须设置地图中心点
            center: ol.extent.getCenter(extent),
            zoom: 5,
            extent: extent
        })
        flag ? map.setView(viewExtent) : map.setView(view);
    }

    // 限制显示级别
    function limitZoom(flag) {
        view.setMinZoom(flag ? 5 : 1);
        view.setMaxZoom(flag ? 8 : 18);
        view.setZoom(5);
    }

    // 禁止拖拽
    function limitDrag(falg) {
        // 这里是将所有交互都关闭了，可以选择只关闭鼠标，虽然效果不好
        map.getInteractions().forEach(element => {
            element.setActive(falg)//false禁止拖拽，true允许拖拽
        })
    }

</script>
<button id="limitExtent" onclick="limitExtent(true)">限制显示范围</button>
<button id="unLimitExtent" onclick="limitExtent(false)">解除限制显示范围</button>
<button id="limitZoom" onclick="limitZoom(true)">限制显示级别</button>
<button id="unLimitZoom" onclick="limitZoom(false)">解除限制显示级别</button>
<button id="limitDrag" onclick="limitDrag(false)">限制拖拽和滚轮</button>
<button id="unLimitDrag" onclick="limitDrag(true)">解除限制拖拽和滚轮</button>
</body>
</html>
```

## 在线示例

**Openlayers 图层常用操作：**[Openlayers view](http://openlayers.vip/examples/csdn/Openlayers-view.html)