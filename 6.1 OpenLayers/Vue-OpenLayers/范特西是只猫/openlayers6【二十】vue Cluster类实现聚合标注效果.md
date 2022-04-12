- [openlayers6【二十】vue Cluster类实现聚合标注效果_范特西是只猫的博客-CSDN博客_openlayers6 聚合](https://xiehao.blog.csdn.net/article/details/107467701)

## 1. 写在前面

聚合标注，是指在不同地图分辨率下，通过聚合方式展现标注点的一种方法。

其设计目的是为了减少当前视图下加载标注点的数量，提升客户端渲染速度。因为如果在地图上添加很多标注点，当地图缩放到小级别（即大分辨率）时会出现标注重叠的现象，既不美观，渲染效率也会受到影响。此时，可以根据地图缩放级数（zoom）的大小，将当前视图的标注点进行聚合显示。

[OpenLayers](https://so.csdn.net/so/search?q=OpenLayers&spm=1001.2101.3001.7020)也考虑到加载大数据量标注点的情况，提供了相应的聚合标注功能，以提升显示速度，增强用户体验。OpenLayers封装了支持聚合的矢量要素数据源（ol.source.Cluster），通过此数据源实现矢量要素的聚合功能。

前面两篇文章 我们讲了[矢量图](https://so.csdn.net/so/search?q=矢量图&spm=1001.2101.3001.7020)层 VectorLayer的常用的场景，聚合标注这篇我们继续写一篇 VectorLayer矢量图层 的使用，足见矢量图层在openlayers中的应用是很广泛的也是最常用的。可以看下图所示的放大缩小地图聚合分散的实现效果。

**聚合：标注中的数字相加， 分散：标注中的数字相减**

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200720171731760.gif)

## 2. ol.source.Cluster 参数

使用聚合效果就其实就是使用了这个方法，下面是他的两个主要的参数说明

```js
 let clusterSource = ol.source.Cluster({
    distance: parseInt(20, 10), // 标注元素之间的间距，单位是像素。
    source: source,//数据源
});
```

## 3. Cluster类实现聚合分散详解

**3.1 我们先看下mounted方法 ：初始化一些数据**
准备聚合的城市经纬度数据clusterData，和城市聚合值的数据points ，然后调用下实现聚合的方法
this.addCluster()

```js
mounted() {
    let clusterData = {
        成都市: { center: { lng: 104.061902, lat: 30.609503 } },
        广安市: { center: { lng: 106.619126, lat: 30.474142 } },
        绵阳市: { center: { lng: 104.673612, lat: 31.492565 } },
        雅安市: { center: { lng: 103.031653, lat: 30.018895 } },
        自贡市: { center: { lng: 104.797794, lat: 29.368322 } },
        宜宾市: { center: { lng: 104.610964, lat: 28.781347 } },
        内江市: { center: { lng: 105.064555, lat: 29.581632 } }
    };
    let points = [
        { name: "成都市", value: 85 },
        { name: "绵阳市", value: 36 },
        { name: "广安市", value: 50 },
        { name: "雅安市", value: 555 },
        { name: "自贡市", value: 55 },
        { name: "宜宾市", value: 666 },
        { name: "内江市", value: 777 }
    ];
    // 实现聚合分散方法
    this.addCluster(clusterData, points, true);
}
```

**3.2 addCluster() 方法详解**

> 如果看过上面提及的两篇矢量图层文章，其实会发现，使用聚合标注的矢量图层的数据源 `source` 不在单单是 `new VectorSource()` 而是需要在包裹一层，那就是在 `new Cluster` 聚合方法中的 `source` 添加矢量图层的数据 `new VectorSource()`

1. 继续我们创建一个矢量图层 `VectorLayer` 里面有两个参数需要设置，一个是 `source`数据源， 一个是 `style` 样式，先看设置`source` 是clusterSource。也就是，需要配置两个参数第一个标注元素之间的间距；第二个是数据源，这里是数据源就说我们实例的矢量图层的数据源`new VectorSource()`，这里暂时设置为空，后面动态添加即可。

```js
let source = new VectorSource();
let clusterSource = new Cluster({
    distance: parseInt(20, 10),
    source: source
});
let layer = new VectorLayer({
    source: clusterSource,
    style: this.clusterStyle.call(this)
});
```

1. 把标注的图层添加到地图中去
2. 我们根据初始化的数据去遍历匹配。`clusterData` 中的城市名和`points`城市名一致的时候。创建点要素`new Feature` 信息，可以通过 `feature.set(key，value)` 的形式动态设置值在要素信息中。
3. 把要素信息添加到矢量图层 `source` 中。

**3.3 addCluster() 方法完整代码**

```js
// 设置聚合分散效果
addCluster(clusterData, points, clearup) {
    let source = new VectorSource();
    let clusterSource = new Cluster({
        distance: parseInt(20, 10),
        source: source
    });
    let layer = new VectorLayer({
        source: clusterSource,
        style: this.clusterStyle.call(this)
    });
    this.map.addLayer(layer);
    for (const key in clusterData) {
        points.forEach(e => {
            if (e.name == key) {
                let point = fromLonLat([
                    clusterData[key].center.lng,
                    clusterData[key].center.lat
                ]);
                var f = new Feature({
                    geometry: new Point(point)
                });
                f.set("name", e.name);
                f.set("value", e.value);
                source.addFeature(f);
            }
        });
    }
},
```

**3.4 clusterStyle () 矢量图层样式方法详解**

> 更多Style样式属性可以访问 [openlayers6【十五】地图样式 Style类详解](https://blog.csdn.net/qq_36410795/article/details/107152946)
> 这篇也提到了 `动态样式也成为条件样式，条件样式是将样式配置为一个回调函数方法`，其参数包含要素本身和分辨率，可以根据要素本身的属性和地图的分辨率，显示动态的样式:形式如 `style: function(feature, resolution) {}`。

1. total ：通过不断监听获取前面 `set` 的值，进行累加计算。设置到`Text`中。

回到这个案例中，下面我们可以看下，滚动下地图，可以看到，会监听要素的feature的变化。相当于vue的watch一样效果，这也是动态样式的应用场景之一。通过不断监听去 触发`new Cluster()` 方法里面的`distances` 的属性，进行不断监听，判断 `distances` 的分辨率（像素）如果匹配设置的值， 达到放到缩小实现聚合分散的效果的同时，不断重新计算`total`值，并设置到`text`中。

```js
clusterStyle() {
	return (feature, solution) => {
	    console.log(feature);
	    // .... 省略
	})
}
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200721085425134.gif)

**3.5 clusterStyle () 方法完整代码**

```js
// 设置聚合分散的图标样式
clusterStyle() {
    return (feature, solution) => {
        var total = 0;
        feature.get("features").forEach((value, index) => {
        	// 通过value.get("属性名") 获取设置的值
            total += value.get("value"); // 获取累加的数值
        });
        var style = new Style({
            image: new CircleStyle({
                radius: 15, //设置圆角大小
                stroke: new Stroke({
                    color: "blue" //设置园stroke颜色
                }),
                fill: new Fill({
                    color: "rgba(24,144,255,100)" //设置填充颜色
                })
            }),
            text: new Text({
                text: total.toString(), // 文字显示的数值
                fill: new Fill({
                    color: "#FFF" // 文字显示的颜色
                })
            })
        });
        return style;
    };
},
```

## 4. 完整代码

```html
<template>
    <div id="app">
        <div id="Map" ref="map"></div>
    </div>
</template>
<script>
import "ol/ol.css";
import TileLayer from "ol/layer/Tile";
import VectorLayer from "ol/layer/Vector";
import VectorSource from "ol/source/Vector";
import XYZ from "ol/source/XYZ";
import { Map, View, Feature, ol } from "ol";
import {
    Style,
    Stroke,
    Fill,
    Icon,
    Text,
    Circle as CircleStyle
} from "ol/style";
import { Polygon, Point } from "ol/geom";
import { defaults as defaultControls } from "ol/control";
import { Cluster } from "ol/source";
import { fromLonLat } from "ol/proj";

import areaGeo from "@/geoJson/sichuan.json";
export default {
    data() {
        return {
            map: null,
            areaLayer: null
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
                    minZoom: 3
                })
            });
        },
        /**
         * 设置区域
         */
        addArea(geo = []) {
            if (geo.length == 0) return false;
            let areaFeature = null;
            // 设置图层
            this.areaLayer = new VectorLayer({
                source: new VectorSource({
                    features: []
                })
            });
            // 添加图层
            this.map.addLayer(this.areaLayer);
            geo.forEach(g => {
                let lineData = g.features[0];
                if (lineData.geometry.type == "MultiPolygon") {
                    areaFeature = new Feature({
                        geometry: new MultiPolygon(
                            lineData.geometry.coordinates
                        ).transform("EPSG:4326", "EPSG:3857")
                    });
                } else if (lineData.geometry.type == "Polygon") {
                    areaFeature = new Feature({
                        geometry: new Polygon(
                            lineData.geometry.coordinates
                        ).transform("EPSG:4326", "EPSG:3857")
                    });
                }
            });
            areaFeature.setStyle(
                new Style({
                    fill: new Fill({ color: "#4e98f444" }),
                    stroke: new Stroke({
                        width: 3,
                        color: [71, 137, 227, 1]
                    })
                })
            );
            this.areaLayer.getSource().addFeatures([areaFeature]);
        },
        addCluster(clusterData, points, clearup) {
            let source = new VectorSource();
            let clusterSource = new Cluster({
                distance: parseInt(20, 10),
                source: source
            });
            let layer = new VectorLayer({
                source: clusterSource,
                style: this.clusterStyle.call(this)
            });
            this.map.addLayer(layer);
            for (const key in clusterData) {
                points.forEach(e => {
                    if (e.name == key) {
                        let point = fromLonLat([
                            clusterData[key].center.lng,
                            clusterData[key].center.lat
                        ]);
                        var f = new Feature({
                            geometry: new Point(point)
                        });
                        f.set("name", e.name);
                        f.set("value", e.value);
                        source.addFeature(f);
                    }
                });
            }
        },
        clusterStyle() {
            return (feature, solution) => {
                var total = 0;
                feature.get("features").forEach((value, index) => {
                    total += value.get("value");
                });
                var style = new Style({
                    image: new CircleStyle({
                        radius: 15,
                        stroke: new Stroke({
                            color: "blue"
                        }),
                        fill: new Fill({
                            color: "rgba(24,144,255,100)"
                        })
                    }),
                    text: new Text({
                        text: total.toString(),
                        fill: new Fill({
                            color: "#FFF"
                        }),
                        font: "12px Calibri,sans-serif",
                        stroke: new Stroke({
                            color: "red",
                            width: 5
                        })
                    })
                });
                return style;
            };
        }
    },
    mounted() {
        this.initMap();
        let clusterData = {
            成都市: { center: { lng: 104.061902, lat: 30.609503 } },
            广安市: { center: { lng: 106.619126, lat: 30.474142 } },
            绵阳市: { center: { lng: 104.673612, lat: 31.492565 } },
            雅安市: { center: { lng: 103.031653, lat: 30.018895 } },
            自贡市: { center: { lng: 104.797794, lat: 29.368322 } },
            宜宾市: { center: { lng: 104.610964, lat: 28.781347 } },
            内江市: { center: { lng: 105.064555, lat: 29.581632 } }
        };
        let points = [
            { name: "成都市", value: 85 },
            { name: "绵阳市", value: 36 },
            { name: "广安市", value: 50 },
            { name: "雅安市", value: 555 },
            { name: "自贡市", value: 55 },
            { name: "宜宾市", value: 666 },
            { name: "内江市", value: 777 }
        ];
        this.addCluster(clusterData, points, true);
    }
};
</script>
<style lang="scss" scoped>
// 此处非核心，已经删除
</style>
```