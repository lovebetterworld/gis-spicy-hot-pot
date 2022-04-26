- [openlayers6【二十一】vue addLayer实现点击地图添加图标要素信息_范特西是只猫的博客-CSDN博客_addlayer openlayers](https://xiehao.blog.csdn.net/article/details/118545523)

## 1.写在前面

本文主要是下面的效果，通过点击地图位置，可以直接设置一个mark的位置元素信息，包括图标和文字的样式效果。好了，继续往下看

前面的文章说了，图层使用的[layer](https://so.csdn.net/so/search?q=layer&spm=1001.2101.3001.7020) 对象表示的，主要有 `WebGLPoints Layer`、`热度图(HeatMap Layer)`、`图片图层(Image Layer)`、`切片图层(Tile Layer)`和 `矢量图层(Vector Layer)`五种类型，它们都是继承 Layer 类的。

这个场景依然是使用的`VectorLayer` 的使用场景，下面是点击地图进行mark元素的效果图

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210707142107813.gif)

## 2. 地图点击事件singleclick

### 2.1 点击获取经纬度

```js
//地图的点击事件
clickMap() {
    const _that = this;
    this.map.on("singleclick", function (evt) {
        const coordinate = transform(
            evt.coordinate,
            "EPSG:3857",
            "EPSG:4326"
        );
        _that.addPoints(coordinate);
    });
},
```

### 2.2 实现根据经纬度创建mark要素，设置mark样式，添加到图层

**2.2.2 addPoints()方法代码：**

```js
/**
 * 根据经纬度坐标打点
 */
addPoints(coordinate) {
    // 设置图层
    this.pointLayer = new VectorLayer({
        source: new VectorSource(),
    });
    // 添加图层
    this.map.addLayer(this.pointLayer);
    // 创建feature，一个feature就是一个点坐标信息
    const feature = new Feature({
        geometry: new Point(fromLonLat(coordinate)),
    });
    //设置 图表的样式
    feature.setStyle(this.getIcon(coordinate));
    this.pointLayer.getSource().addFeatures([feature]);
},
```

## 3. 完整代码

```html
<template>
    <div id="app">
        <div id="Map" ref="map" />
    </div>
</template>
<script>
import "ol/ol.css";
import TileLayer from "ol/layer/Tile";
import VectorLayer from "ol/layer/Vector";
import VectorSource from "ol/source/Vector";
import XYZ from "ol/source/XYZ";
import { Map, View, Feature } from "ol";
import { Style, Icon, Fill, Text } from "ol/style";
import { Point } from "ol/geom";
import { defaults as defaultControls } from "ol/control";
import { fromLonLat, transform } from "ol/proj";

// 边界json数据
export default {
    data() {
        return {
            map: null,
            pointLayer: null,
        };
    },
    mounted() {
        this.initMap();
        this.clickMap();
    },
    methods: {
        /**
         * 初始化地图
         */
        initMap() {
            this.map = new Map({
                target: "Map",
                controls: defaultControls({
                    zoom: true,
                }).extend([]),
                layers: [
                    new TileLayer({
                        source: new XYZ({
                            url: "http://map.geoq.cn/ArcGIS/rest/services/ChinaOnlineStreetPurplishBlue/MapServer/tile/{z}/{y}/{x}",
                        }),
                    }),
                ],
                view: new View({
                    center: fromLonLat([108.522097, 37.272848]),
                    zoom: 4.7,
                    maxZoom: 19,
                    minZoom: 4,
                }),
            });
        },
        //地图的点击事件
        clickMap() {
            const _that = this;
            this.map.on("singleclick", function (evt) {
                const coordinate = transform(
                    evt.coordinate,
                    "EPSG:3857",
                    "EPSG:4326"
                );
                _that.addPoints(coordinate);
            });
        },
        /**
         * 批量根据经纬度坐标打点
         */
        addPoints(coordinate) {
            // 设置图层
            this.pointLayer = new VectorLayer({
                source: new VectorSource(),
            });
            // 添加图层
            this.map.addLayer(this.pointLayer);
            // 创建feature，一个feature就是一个点坐标信息
            const feature = new Feature({
                geometry: new Point(fromLonLat(coordinate)),
            });
            //设置 图表的样式
            feature.setStyle(this.getIcon(coordinate));
            this.pointLayer.getSource().addFeatures([feature]);
        },
        //图标的样式设置
        getIcon(coordinate) {
            var styleIcon = new Style({
                // 设置图片效果
                image: new Icon({
                    src: require("../../assets/images/monitor.png"),
                    anchor: [0.5, 1],
                }),
                text: new Text({
                    text: "摄像头" + parseInt(coordinate[0]), // 添加文字描述
                    font: "14px font-size", // 设置字体大小
                    fill: new Fill({
                        // 设置字体颜色
                        color: "#fff",
                    }),
                    offsetY: 10, // 设置文字偏移量
                }),
            });
            return styleIcon;
        },
    },
};
</script>
<style lang="scss" scoped>
// 此处非核心内容，已删除
</style>
```