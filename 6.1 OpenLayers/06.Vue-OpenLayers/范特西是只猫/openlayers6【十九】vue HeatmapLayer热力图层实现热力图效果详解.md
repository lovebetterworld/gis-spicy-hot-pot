- [openlayers6【十九】vue HeatmapLayer热力图层实现热力图效果详解_范特西是只猫的博客-CSDN博客_openlayers6 热力图](https://xiehao.blog.csdn.net/article/details/107466089)

## 1. 写在前面

本问下面有[矢量图](https://so.csdn.net/so/search?q=矢量图&spm=1001.2101.3001.7020)层设置的区域，和热力图层设置的热力图的效果，区域绘制效怎么设置详细内容可以访问 [openlayers6【十七】vue VectorLayer矢量图层画地图省市区，多省市区(粤港澳大湾区)效果详解](https://blog.csdn.net/qq_36410795/article/details/107456645)，主要讲解的是[热力图](https://so.csdn.net/so/search?q=热力图&spm=1001.2101.3001.7020)层效果实现。区域绘制只是为了效果更好看。好了，继续往下看

在 [openlayers](https://so.csdn.net/so/search?q=openlayers&spm=1001.2101.3001.7020) 中，图层是使用 layer 对象表示的，主要有 `WebGLPoints Layer`、`热度图(HeatMap Layer)`、`图片图层(Image Layer)`、`切片图层(Tile Layer)`和 `矢量图层(Vector Layer)`五种类型，它们都是继承 [Layer](https://so.csdn.net/so/search?q=Layer&spm=1001.2101.3001.7020) 类的。

前面两篇文章 我们讲了矢量图层 `VectorLayer`的常用的场景，这篇我们写一篇 `HeatMapLayer` 的使用。可以看下图所示的热力图实现效果。 放大缩小地图热力图效果。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200527102818468.gif)

## 2. Heatmap 类实现热力图

### 2.1 Heatmap 参数

```js
var heatmapLayer = new ol.layer.Heatmap({
    source: source,//热力图资源
    opacity:1,//透明度，默认1
    visible:true,//是否显示，默认trur
    zIndex:1,//图层渲染的Z索引,默认按图层加载顺序叠加
    gradient:['#00f','#0ff','#0f0','#ff0','#f00'],//热图的颜色渐变
    blur: 15,//模糊大小(像素为单位)
    radius: 8,//半径大小默认为8(像素为单位)
    extent:[100,30,104,40],//渲染范围，可选值，默认渲染全部
});
```

### 2.2 实现热力图

**2.2.1 addHeatMap()方法详解：**

1. 准备热力图需要的初始化数据，colors 热图的颜色渐变，hatmapData 表示值数量越多显示到页面的热力图颜色越深。codeList 准备的数据的城市对应的经纬度坐标。
2. 创建热力图图层 `HeatmapLayer`
3. 把热力图图层添加到 `map` 中
4. 调用添加热力图要素的方法 `AppendFeatures()`

**2.2.2 addHeatMap()方法代码：**

```js
/**
 * 添加热力图
 */
addHeatMap() {
    let colors = [
        "#2200FF",
        "#16D9CC",
        "#4DEE12",
        "#E8D225",
        "#EF1616"
    ];
    let hatmapData = [
        { name: "成都市" },
        { name: "成都市" },
        { name: "成都市" },
        { name: "成都市" },
        { name: "绵阳市" },
        { name: "广安市" },
        { name: "雅安市" },
        { name: "自贡市" },
        { name: "自贡市" },
        { name: "自贡市" },
        { name: "自贡市" },
        { name: "自贡市" },
        { name: "自贡市" },
        { name: "自贡市" },
        { name: "宜宾市" },
        { name: "甘孜藏族自治州市" }
    ];
    let codeList = {
        成都市: { center: { lng: 104.061902, lat: 30.609503 } },
        广安市: { center: { lng: 106.619126, lat: 30.474142 } },
        绵阳市: { center: { lng: 104.673612, lat: 31.492565 } },
        雅安市: { center: { lng: 103.031653, lat: 30.018895 } },
        自贡市: { center: { lng: 104.797794, lat: 29.368322 } },
        宜宾市: { center: { lng: 104.610964, lat: 28.781347 } },
        甘孜藏族自治州市: {
            center: { lng: 101.592433, lat: 30.426712 }
        }
    };
    this.layer = new HeatmapLayer({
        source: new VectorSource(),
        blur: 30,
        radius: 15,
        gradient: colors
    });
    this.map.addLayer(this.layer);
    this.AppendFeatures(hatmapData, colors, codeList, 50);
},
```

**2.2.3 AppendFeatures()方法详解：**

1. 遍历hatmapData和points数据根据名称一致的 循环创建要素 `new Feature`点`new Point`信息
2. 把要素添加到热力图层的数据源中

**2.2.4 AppendFeatures()方法代码：**

```js
/**
 * 增加要素到热力图
 */
AppendFeatures(hatmapData, colors, points, max) {
    for (var i in hatmapData) {
        if (points[hatmapData[i].name]) {
            var coords = points[hatmapData[i].name];
            this.max = max;
            var f = new Feature({
                geometry: new Point(
                    fromLonLat([coords.center.lng, coords.center.lat])
                )
            });
            this.layer.getSource().addFeature(f);
        }
    }
}
```

## 3. 完整代码

```html
<template>
    <div id="app">
        <div id="Map" ref="map"></div>
    </div>
</template>
<script>
import "ol/ol.css";
import VectorLayer from "ol/layer/Vector";
import VectorSource from "ol/source/Vector";
import { Tile as TileLayer, Heatmap as HeatmapLayer } from "ol/layer";
import Proj from "ol/proj/Projection";
import XYZ from "ol/source/XYZ";
import { Map, View, Feature, ol } from "ol";
import { Style, Stroke, Fill } from "ol/style";
import { Polygon, Point } from "ol/geom";
import { defaults as defaultControls } from "ol/control";
import { fromLonLat } from "ol/proj";

// 四川的边界数据文件
import areaGeo from "@/geoJson/sichuan.json";

export default {
    data() {
        return {
            map: null
        };
    },
    methods: {
        /**
         * 初始化地图
         */
        initMap() {
            this.map = new Map({
                target: "Map",
                controls: defaultControls({
                    zoom: true
                }).extend([]),
                layers: [
                    new TileLayer({
                        source: new XYZ({
                            url:
                                "http://map.geoq.cn/ArcGIS/rest/services/ChinaOnlineStreetPurplishBlue/MapServer/tile/{z}/{y}/{x}"
                        })
                    })
                ],
                view: new View({
                    center: fromLonLat([104.065735, 30.659462]),
                    zoom: 6.5,
                    maxZoom: 19,
                    minZoom: 5
                })
            });
        },
        /**
         * 设置区域
         */
        addArea(geo = []) {
            if (geo.length == 0) {
                return false;
            }
            let features = [];
            geo.forEach(g => {
                let lineData = g.features[0];
                let routeFeature = "";
                if (lineData.geometry.type == "MultiPolygon") {
                    routeFeature = new Feature({
                        geometry: new MultiPolygon(
                            lineData.geometry.coordinates
                        ).transform("EPSG:4326", "EPSG:3857")
                    });
                } else if (lineData.geometry.type == "Polygon") {
                    routeFeature = new Feature({
                        geometry: new Polygon(
                            lineData.geometry.coordinates
                        ).transform("EPSG:4326", "EPSG:3857")
                    });
                }
                routeFeature.setStyle(
                    new Style({
                        fill: new Fill({
                            color: "#4e98f444"
                        }),
                        stroke: new Stroke({
                            width: 3,
                            color: [71, 137, 227, 1]
                        })
                    })
                );
                features.push(routeFeature);
            });
            // 设置图层
            let routeLayer = new VectorLayer({
                source: new VectorSource({
                    features: features
                })
            });
            // 添加图层
            this.map.addLayer(routeLayer);
        },
        /**
         * 添加热力图
         */
        addHeatMap() {
            let colors = [
                "#2200FF",
                "#16D9CC",
                "#4DEE12",
                "#E8D225",
                "#EF1616"
            ];
            let hatmapData = [
                { name: "成都市" },
                { name: "成都市" },
                { name: "成都市" },
                { name: "成都市" },
                { name: "绵阳市" },
                { name: "广安市" },
                { name: "雅安市" },
                { name: "自贡市" },
                { name: "自贡市" },
                { name: "自贡市" },
                { name: "自贡市" },
                { name: "自贡市" },
                { name: "自贡市" },
                { name: "自贡市" },
                { name: "宜宾市" },
                { name: "甘孜藏族自治州市" }
            ];
            let codeList = {
                成都市: { center: { lng: 104.061902, lat: 30.609503 } },
                广安市: { center: { lng: 106.619126, lat: 30.474142 } },
                绵阳市: { center: { lng: 104.673612, lat: 31.492565 } },
                雅安市: { center: { lng: 103.031653, lat: 30.018895 } },
                自贡市: { center: { lng: 104.797794, lat: 29.368322 } },
                宜宾市: { center: { lng: 104.610964, lat: 28.781347 } },
                甘孜藏族自治州市: {
                    center: { lng: 101.592433, lat: 30.426712 }
                }
            };

            this.layer = new HeatmapLayer({
                source: new VectorSource(),
                blur: 30,
                radius: 15,
                gradient: colors
            });
            this.map.addLayer(this.layer);
            this.AppendFeatures(hatmapData, colors, codeList, 50);
        },
        /**
         * 增加要素至热力图
         */
        AppendFeatures(hatmapData, colors, points, max) {
            for (var i in hatmapData) {
                if (points[hatmapData[i].name]) {
                    var coords = points[hatmapData[i].name];
                    this.max = max;
                    var f = new Feature({
                        geometry: new Point(
                            fromLonLat([coords.center.lng, coords.center.lat])
                        )
                    });
                    this.layer.getSource().addFeature(f);
                }
            }
        }
    },
    mounted() {
        this.initMap(); //初始化地图
        this.addArea(areaGeo); //添加四川省的边界描边和填充
        this.addHeatMap(); //添加热力图数据
    }
};
</script>
<style lang="scss" scoped>
// 此处非核心内容，已删除
</style>
```

## 4. 添加删除map图层的方法

```js
//添加热力图层
this.map.addLayer(this.layer)
//删除热力图层
this.map.removeLayer(this.layer)
```

## 5. 热力图自身的get，set方法

```js
//获取-设置，模糊大小
heatmapLayer.getBlur()
heatmapLayer.setBlur(15)
//获取-设置，渲染范围
heatmapLayer.getExtent()
heatmapLayer.setExtent([100,30,104,40])
//获取-设置，热力图渐变色
heatmapLayer.getGradient()
heatmapLayer.setGradient(['#00f','#0ff','#0f0','#ff0','#f00'])
//获取-设置，最大级别
heatmapLayer.getMaxZoom()
heatmapLayer.setMaxZoom(18)
//获取-设置，最小级别
heatmapLayer.getMinZoom()
heatmapLayer.setMinZoom(2)
//获取-设置，透明度
heatmapLayer.getOpacity()
heatmapLayer.setOpacity(0.5)
//获取-设置，半径
heatmapLayer.getRadius()
heatmapLayer.setRadius(5)
//获取-设置，热力源
heatmapLayer.getSource()
heatmapLayer.setSource(source)
//获取-设置，是否可见
heatmapLayer.getVisible()
heatmapLayer.setVisible(true)
//获取-设置，图层的Z-index
heatmapLayer.getZIndex()
heatmapLayer.setZIndex(2)

//绑定事件-取消事件 type事件类型，listener函数体
heatmapLayer.on(type,listener)
heatmapLayer.un(type,listener)
```