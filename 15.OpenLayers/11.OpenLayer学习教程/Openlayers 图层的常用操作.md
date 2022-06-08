- [Openlayers 图层的常用操作_Southejor的博客-CSDN博客_openlayer 保存图层](https://blog.csdn.net/linzi19900517/article/details/123570961)

# [OpenLayers](https://so.csdn.net/so/search?q=OpenLayers&spm=1001.2101.3001.7020) 教程

在 Openlayers 中，图层是非常基础的对象，这里汇总介绍一下图层常用的操作，主要包括：**添加移除、显示隐藏、层级调整、定位**。

图层对象的常用操作基本相同，本示例以**自定义创建的矢量图层**演示。

## Openlayers 图层的常用操作

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
<h2>Layer operating</h2>
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

    // 初始化图层
    var layers = initVectorLayer();
    // 小图层
    var layer = layers[0];
    // 大图层
    var layerLarge = layers[1];

    addFeatures();

    // 添加点线面
    function addFeatures() {

        var features = [];

        features.push(getFeatureByWKT("POINT(116.17983834030585 39.98298600752048)"));
        features.push(getFeatureByWKT("POLYGON((115.13540462521966 37.877850766866445,116.31094173459466 39.042401548116445,117.23379329709466 38.130536313741445,117.10195735959466 37.295575376241445,115.64077571896966 36.976971860616445,115.26724056271966 37.174725766866445,115.13540462521966 37.877850766866445))"));

        layer.getSource().addFeatures(features);
        layerLarge.getSource().addFeatures([getFeatureByWKT("POLYGON((110.55410579709475 49.08932162624148,105.63223079709475 48.12252475124148,102.16055110959475 37.48775912624148,109.67519954709475 33.13717318874148,113.58633235959475 32.25826693874148,116.44277767209475 35.77389193874148,114.11367610959475 45.22213412624148,110.55410579709475 49.08932162624148))")]);
    }

    /**
     * @todo 矢量图层
     * @returns {VectorLayer}
     * @constructor
     */
    function initVectorLayer() {
        //实例化一个矢量图层Vector作为绘制层
        let source = new ol.source.Vector();
        let sourceLarge = new ol.source.Vector();
        //创建一个图层
        let customVectorLayer = new ol.layer.Vector({
            source: source,
            zIndex: 2,
            //设置样式
            style: new ol.style.Style({
                //边框样式
                stroke: new ol.style.Stroke({
                    color: 'red',
                    width: 5,
                    lineDash: [3, 5]
                }),
                //填充样式
                fill: new ol.style.Fill({
                    color: 'rgba(0, 0, 255, 0.7)',
                }),
                image: new ol.style.Circle({
                    radius: 9,
                    fill: new ol.style.Fill({
                        color: 'red',
                    })
                })
            }),
        });
        //将绘制层添加到地图容器中
        map.addLayer(customVectorLayer);

        // 创建线图层，用户展示层级
        let largeVectorLayer = new ol.layer.Vector({
            source: sourceLarge,
            zIndex: 2,
            //设置样式
            style: new ol.style.Style({
                //边框样式
                stroke: new ol.style.Stroke({
                    color: 'black',
                    width: 5,
                    lineDash: [3, 5]
                }),
                //填充样式
                fill: new ol.style.Fill({
                    color: 'rgba(0, 255, 255, 0.7)',
                }),
            }),
        });
        //将绘制层添加到地图容器中
        map.addLayer(largeVectorLayer);

        return [customVectorLayer, largeVectorLayer];
    }

    /**
     * @todo wkt格式数据转化成图形对象
     * @param {string} wkt   "POINT(112.7197265625,39.18164062499999)" 格式数据
     * @param {string|Projection} sourceCode 源投影坐标系
     * @param {string|Projection} targetCode 目标投影坐标系
     * @returns {Feature}
     */
    function getFeatureByWKT(wkt, sourceCode, targetCode) {
        try {
            let view = map.getView();
            if (!wkt) {
                return null;
            }
            let format = new ol.format.WKT();

            let feature;

            feature = format.readFeature(wkt, {
                featureProjection: targetCode || view.getProjection(),
                dataProjection: sourceCode || view.getProjection(),
            });

            return feature;
        } catch (e) {
            console.log(e);
            return null;
        }
    }

    // 显示所有图层
    function showLayer() {
        layer.setVisible(true);
        layerLarge.setVisible(true);
    }

    // 隐藏所有图层
    function hideLayer() {
        layer.setVisible(false);
        layerLarge.setVisible(false);
    }

    // 临时标识
    var temp = true;

    // 设置层级关系，可以循环点
    function setZIndex() {
        if (temp) {
            layer.setZIndex(1)
            layerLarge.setZIndex(0)
            temp = false;
        } else {
            layer.setZIndex(2)
            layerLarge.setZIndex(2)
            temp = true;
        }
    }

    // 移动到小图层
    function moveToLayer1() {
        var extent = layer.getSource().getExtent();
        map.getView().fit(extent, {
            duration: 1,//动画的持续时间,
            callback: null,
        });
    }

    // 移动到大图层
    function moveToLayer2() {
        var extent = layerLarge.getSource().getExtent();
        map.getView().fit(extent, {
            duration: 1,//动画的持续时间,
            callback: null,
        });
    }

    // 地图容器删除图层
    function removeLayer() {
        layerLarge && map.removeLayer(layerLarge);
    }

    // 地图容器添加图层
    function addLayer() {
        layerLarge && map.addLayer(layerLarge);
    }
</script>
<button id="hideLayer" onclick="hideLayer()">隐藏图层</button>
<button id="showLayer" onclick="showLayer()">显示图层</button>
<button id="setZIndex" onclick="setZIndex()">设置图层层级</button>
<button id="moveToLayer1" onclick="moveToLayer1()">定位到图层1</button>
<button id="moveToLayer2" onclick="moveToLayer2()">定位到图层2</button>
<button id="removeLayer" onclick="removeLayer()">地图删除图层</button>
<button id="addLayer" onclick="addLayer()">添加图层到地图</button>
</body>
</html>
```

## 在线示例

**Openlayers 图层常用操作：**[Openlayers layer operate](http://openlayers.vip/examples/csdn/Openlayers-layer-operate.html)