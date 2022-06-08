- [Openlayers 高德腾讯、百度、天地图坐标相互转换_Southejor的博客-CSDN博客_openlayers 坐标系转换](https://blog.csdn.net/linzi19900517/article/details/123570916)

# [OpenLayers](https://so.csdn.net/so/search?q=OpenLayers&spm=1001.2101.3001.7020) 教程

在地图开发过程中，坐标的转换是很常用的功能，国内的话一般西安80（EPSG:4610）、北京54（EPSG:2433）转WGS84比较多，不同坐标系转换，只要知道EPSG码，通过 Openlayers 的方法就可以转换。

但是，像国内商用的地图（高德、腾讯、百度），要求数据加密，一般通过 GCJ-02 或者 BD-09 加密，不能简单通过 openlayers 的转换方法实现，需要手动使用算法完成转换。

本教程算法来自网络，目前提供点数据的转换，对于线和面推荐在数据库或者后端实现转换。

**注意：本示例将 高德腾讯坐标设置为黑色；将百度坐标设置为黄色**

**注意：本示例将 高德腾讯坐标转为WGS84颜色设置为粉色；将百度坐标转为WS84颜色设置为绿色**

## Openlayers 腾讯、百度、天地图坐标转换

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
<h2>Feature transfer</h2>
<!--地图容器，需要指定 id -->
<div id="map" class="map"></div>
<!--注意：本示例将 高德腾讯坐标设置为黑色；将百度坐标设置为黄色 -->
<!--注意：本示例将 高德腾讯坐标转为WGS84颜色设置为粉色；将百度坐标转为WS84颜色设置为绿色 -->
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


    var xy = [116.391232637988,39.907157016256974];
    // 初始点
    var originPoint = new ol.Feature({
        geometry: new ol.geom.Point(xy),
        name: 'My Point'
    });

    // 矢量图层
    var layer = initVectorLayer();

    /**
     * @todo 矢量图层
     * @returns {VectorLayer}
     * @constructor
     */
    function initVectorLayer() {
        //实例化一个矢量图层Vector作为绘制层
        let source = new ol.source.Vector();
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
                    color: 'rgba(0, 0, 255, 0.3)',
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

        customVectorLayer.getSource().addFeatures([originPoint]);

        var extent = customVectorLayer.getSource().getExtent();

        map.getView().fit(extent, {
            duration: 1,//动画的持续时间,
            callback: null,
        });
        return customVectorLayer;
    }

    // =====坐标转换工具 start ====================================================================================
    //定义一些常量
    var PI = 3.1415926535897932384626;
    var a = 6378245.0;
    var ee = 0.00669342162296594323;

    let transformlat = function (lng, lat) {
        var ret = -100.0 + 2.0 * lng + 3.0 * lat + 0.2 * lat * lat + 0.1 * lng * lat + 0.2 * Math.sqrt(Math.abs(lng));
        ret += (20.0 * Math.sin(6.0 * lng * PI) + 20.0 * Math.sin(2.0 * lng * PI)) * 2.0 / 3.0;
        ret += (20.0 * Math.sin(lat * PI) + 40.0 * Math.sin(lat / 3.0 * PI)) * 2.0 / 3.0;
        ret += (160.0 * Math.sin(lat / 12.0 * PI) + 320 * Math.sin(lat * PI / 30.0)) * 2.0 / 3.0;
        return ret
    }

    let transformlng = function (lng, lat) {
        var ret = 300.0 + lng + 2.0 * lat + 0.1 * lng * lng + 0.1 * lng * lat + 0.1 * Math.sqrt(Math.abs(lng));
        ret += (20.0 * Math.sin(6.0 * lng * PI) + 20.0 * Math.sin(2.0 * lng * PI)) * 2.0 / 3.0;
        ret += (20.0 * Math.sin(lng * PI) + 40.0 * Math.sin(lng / 3.0 * PI)) * 2.0 / 3.0;
        ret += (150.0 * Math.sin(lng / 12.0 * PI) + 300.0 * Math.sin(lng / 30.0 * PI)) * 2.0 / 3.0;
        return ret
    }

    /**
     * 判断是否在国内，不在国内则不做偏移
     * @param lng
     * @param lat
     * @returns {boolean}
     */
    let out_of_china = function (lng, lat) {
        return (lng < 72.004 || lng > 137.8347) || ((lat < 0.8293 || lat > 55.8271) || false);
    }

    /**
     * WGS84转GCj02
     * @param lng
     * @param lat
     * @returns {*[]}
     */
    let wgs84togcj02 = function (lng, lat) {
        if (out_of_china(lng, lat)) {
            return [lng, lat]
        } else {
            var dlat = transformlat(lng - 105.0, lat - 35.0);
            var dlng = transformlng(lng - 105.0, lat - 35.0);
            var radlat = lat / 180.0 * PI;
            var magic = Math.sin(radlat);
            magic = 1 - ee * magic * magic;
            var sqrtmagic = Math.sqrt(magic);
            dlat = (dlat * 180.0) / ((a * (1 - ee)) / (magic * sqrtmagic) * PI);
            dlng = (dlng * 180.0) / (a / sqrtmagic * Math.cos(radlat) * PI);
            var mglat = lat + dlat;
            var mglng = lng + dlng;
            return [mglng, mglat]
        }
    }

    /**
     * GCJ02 转换为 WGS84
     * @param lng
     * @param lat
     * @returns {*[]}
     */
    let gcj02towgs84 = function (lng, lat) {
        if (out_of_china(lng, lat)) {
            return [lng, lat]
        } else {
            var dlat = transformlat(lng - 105.0, lat - 35.0);
            var dlng = transformlng(lng - 105.0, lat - 35.0);
            var radlat = lat / 180.0 * PI;
            var magic = Math.sin(radlat);
            magic = 1 - ee * magic * magic;
            var sqrtmagic = Math.sqrt(magic);
            dlat = (dlat * 180.0) / ((a * (1 - ee)) / (magic * sqrtmagic) * PI);
            dlng = (dlng * 180.0) / (a / sqrtmagic * Math.cos(radlat) * PI);
            let mglat = lat + dlat;
            let mglng = lng + dlng;
            return [lng * 2 - mglng, lat * 2 - mglat]
        }
    }

    /**
     * 百度坐标系 (BD-09) 与 火星坐标系 (GCJ-02)的转换
     * 即 百度 转 谷歌、高德
     * @param bd_lon
     * @param bd_lat
     * @returns {*[]}
     */
    let bd09togcj02 = function (bd_lon, bd_lat) {
        var x_pi = 3.14159265358979324 * 3000.0 / 180.0;
        var x = bd_lon - 0.0065;
        var y = bd_lat - 0.006;
        var z = Math.sqrt(x * x + y * y) - 0.00002 * Math.sin(y * x_pi);
        var theta = Math.atan2(y, x) - 0.000003 * Math.cos(x * x_pi);
        var gg_lng = z * Math.cos(theta);
        var gg_lat = z * Math.sin(theta);
        return [gg_lng, gg_lat]
    }

    /**
     * 火星坐标系 (GCJ-02) 与百度坐标系 (BD-09) 的转换
     * 即谷歌、高德 转 百度
     * @param lng
     * @param lat
     * @returns {*[]}
     */
    let gcj02tobd09 = function (lng, lat) {
        var x_PI = 3.14159265358979324 * 3000.0 / 180.0;
        var z = Math.sqrt(lng * lng + lat * lat) + 0.00002 * Math.sin(lat * x_PI);
        var theta = Math.atan2(lat, lng) + 0.000003 * Math.cos(lng * x_PI);
        var bd_lng = z * Math.cos(theta) + 0.0065;
        var bd_lat = z * Math.sin(theta) + 0.006;
        return [bd_lng, bd_lat]
    }

    // =====坐标转换工具 end ====================================================================================

    /**
     * 添加点到地图
     * @param geom
     * @param color 颜色
     * @returns {Feature|Feature|null}
     */
    function addFeature(geom, color) {
        let temp = new ol.Feature({
            geometry: new ol.geom.Point(geom),
            name: 'My Point'
        });
        let style = new ol.style.Style({
            image: new ol.style.Circle({
                radius: 9,
                fill: new ol.style.Fill({
                    color: color || 'blue',
                })
            })
        });
        temp.setStyle(style);
        layer.getSource().addFeatures([temp]);
        move();
        return temp;
    }

    // 定位到图层
    function move() {
        var extent = layer.getSource().getExtent();
        map.getView().fit(extent, {
            duration: 1,//动画的持续时间,
            callback: null,
        });
    }

    // 记录高德腾讯坐标对象
    var cjFeature;

    function toCJ02() {
        // 高德腾讯坐标设置为黑色
        cjFeature = addFeature(wgs84togcj02(xy[0], xy[1]), 'black')
    }

    // 高德腾讯坐标转WGS84
    function CJ02TO() {
        if(!cjFeature){
            return;
        }
        let cjGeom = cjFeature.getGeometry().getCoordinates();
        // 还原为WGS坐标，设置为粉色
        addFeature(gcj02towgs84(cjGeom[0], cjGeom[1]), 'pink');
    }

    // 记录百度坐标对象
    var bdFeature;

    function toBD09() {
        // 先将WGS84转为高德腾讯，在转为BD09
        let tempGeom = wgs84togcj02(xy[0], xy[1]);
        // 百度坐标设置为黄色
        bdFeature = addFeature(gcj02tobd09(tempGeom[0], tempGeom[1]), 'yellow');
    }

    // 百度坐标转WGS84
    function BD09TO() {
        if(!bdFeature){
            return;
        }
        let bdGeom = bdFeature.getGeometry().getCoordinates();
        // 现将BD09转为高德腾讯，在转为WGS84
        let tempGeom = bd09togcj02(bdGeom[0], bdGeom[1]);
        // 还原为WGS坐标，设置为粉色
        addFeature(gcj02towgs84(tempGeom[0], tempGeom[1]), 'green');
    }

</script>

<button id="toCJ02" onclick="toCJ02()">WGS84转腾讯/高德</button>
<button id="CJ02TO" onclick="CJ02TO()">高德/腾讯转WGS84</button>
<button id="toBD09" onclick="toBD09()">WGS84转百度</button>
<button id="BD09TO" onclick="BD09TO()">百度转WGS84</button>
</body>
</html>
```

## 在线示例

**Openlayers 高德腾讯、百度、天地图坐标相互转换：**[Openlayers transfer_gcj](http://openlayers.vip/examples/csdn/Openlayers-transfer_gcj.html)