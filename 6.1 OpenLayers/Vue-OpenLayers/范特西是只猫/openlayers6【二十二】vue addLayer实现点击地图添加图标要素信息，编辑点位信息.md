- [openlayers6【二十二】vue addLayer实现点击地图添加图标要素信息，编辑点位信息_范特西是只猫的博客-CSDN博客](https://xiehao.blog.csdn.net/article/details/119204525)

## 1.写在前面

本文主要基于上篇文章的扩展，通过在地图上点击，创建一个要素，点击要素的标题对要素的信息进行编辑操作。

上篇文章地址 [openlayers6【二十一】vue addLayer实现点击地图添加图标要素信息](https://editor.csdn.net/md/?articleId=118545523)

下面是点击地图进行mark元素，然后进行编辑操作的效果图

![请添加图片描述](https://img-blog.csdnimg.cn/1dbf2f4b7ade4f25ba1dc877a239f666.gif)

## 2. 地图点击事件singleclick

### 2.1 点击获取经纬度，调用创建mark要素的方法

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

### 2.2 实现根据经纬度创建mark要素，设置mark样式，添加到图层，创建要素标题的信息

**2.2.2 addPoints()方法代码：**

```js
/**
 * 根据经纬度坐标打点
 */
addPoints(coordinate) {
    // 创建图层
    this.pointLayer = new VectorLayer({
        source: new VectorSource(),
    });
    // 图层添加到地图上
    this.map.addLayer(this.pointLayer);
    // 创建feature要素，一个feature就是一个点坐标信息
    const feature = new Feature({
        geometry: new Point(fromLonLat(coordinate)),
    });
    // 设置要素的图标
    feature.setStyle(this.getIcon());
    // 要素添加到地图图层上
    this.pointLayer.getSource().addFeatures([feature]);
    // 设置文字信息
    this.addText(coordinate);
},
```

**2.2.3 addText()方法代码：**

> 就是添加了一个文本，只是文本的载体是 div的contentEditable属性，设置这个属性就是div可以编辑操作。

```js
/**
 * 根据经纬度坐标添加文字
 */
addText(coordinate) {
    const overlayBox = document.getElementById("overlay-box"); //创建一个div
    const oDiv = document.createElement("span"); //创建一个span
    oDiv.contentEditable = true; //设置文字是否可编辑
    oDiv.id = coordinate[0]; //创建一个id
    var pText = document.createTextNode(
        "摄像头" + parseInt(coordinate[0])
    ); //创建span的文本信息
    oDiv.appendChild(pText); //将文本信息添加到span
    overlayBox.appendChild(oDiv); //将span添加到div中
    var textInfo = new Overlay({
        position: fromLonLat(coordinate), //设置位置
        element: document.getElementById(coordinate[0]),
        offset: [-35, 10], //设置偏移
    });
    this.map.addOverlay(textInfo);//把信息添加到addOverlay
},
```

## 3. 完整代码

```html
<template>
    <div id="app">
        <div id="Map" ref="map" />
        <div id="overlay-box" />
    </div>
</template>
<script>
import "ol/ol.css";
import TileLayer from "ol/layer/Tile";
import VectorLayer from "ol/layer/Vector";
import VectorSource from "ol/source/Vector";
import XYZ from "ol/source/XYZ";
import { Map, View, Feature } from "ol";
import { Style, Icon } from "ol/style";
import { Point } from "ol/geom";
import { defaults as defaultControls } from "ol/control";
import { fromLonLat, transform } from "ol/proj";
import Overlay from "ol/Overlay";
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
        /**
         * 点击地图添加摄像头要素
         */
        clickMap() {
            this.map.on("singleclick", (evt) => {
                const coordinate = transform(
                    evt.coordinate,
                    "EPSG:3857",
                    "EPSG:4326"
                );
                this.addPoints(coordinate);
            });
        },
        /**
         * 根据经纬度坐标添加摄像头要素
         */
        addPoints(coordinate) {
            // 创建图层
            this.pointLayer = new VectorLayer({
                source: new VectorSource(),
            });
            // 图层添加到地图上
            this.map.addLayer(this.pointLayer);
            // 创建feature要素，一个feature就是一个点坐标信息
            const feature = new Feature({
                geometry: new Point(fromLonLat(coordinate)),
            });
            // 设置要素的图标
            feature.setStyle(this.getIcon());
            // 要素添加到地图图层上
            this.pointLayer.getSource().addFeatures([feature]);
            // 设置文字信息
            this.addText(coordinate);
        },
        /**
         * 设置要素的图标
         */
        getIcon() {
            var styleIcon = new Style({
                // 设置图片效果
                image: new Icon({
                    src: require("../../assets/images/monitor.png"),
                    anchor: [0.5, 1],
                }),
            });
            return styleIcon;
        },
        /**
         * 根据经纬度坐标添加文字
         */
        addText(coordinate) {
            const overlayBox = document.getElementById("overlay-box"); //创建一个div
            const oDiv = document.createElement("span"); //创建一个span
            oDiv.contentEditable = true; //设置文字是否可编辑
            oDiv.id = coordinate[0]; //创建一个id
            var pText = document.createTextNode(
                "摄像头" + parseInt(coordinate[0])
            ); //创建span的文本信息
            oDiv.appendChild(pText); //将文本信息添加到span
            overlayBox.appendChild(oDiv); //将span添加到div中
            var textInfo = new Overlay({
                position: fromLonLat(coordinate), //设置位置
                element: document.getElementById(coordinate[0]),
                offset: [-35, 10], //设置偏移
            });
            this.map.addOverlay(textInfo);
        },
    },
};
</script>
<style lang="scss" scoped>
// 此处非核心内容，已删除
</style>
```