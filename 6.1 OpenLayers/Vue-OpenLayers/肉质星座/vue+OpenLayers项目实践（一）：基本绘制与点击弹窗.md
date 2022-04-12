- [vue+OpenLayers项目实践（一）：基本绘制与点击弹窗 - 掘金 (juejin.cn)](https://juejin.cn/post/7025529005214269470)

## 一、前言

由于最近项目需要，需要在**vue**项目中使用**OpenLayers**来进行GIS地图的开发，网上对OpenLayers文章并不算太大，借此机会分享下自己在项目中实际使用的一些心得。

本系列将陆续分享项目过程中实现的一些功能点，本文主要介绍以下部分：

1. 项目引入
2. 底图渲染
3. 标记绘制
4. 弹窗显示标记信息

[Openlayers](https://link.juejin.cn?target=https%3A%2F%2Fopenlayers.org%2F)

## 二、具体实现

本项目基于vue开发，首先准备一个vue项目，直接vue-cli搭建一个就行，文章用项目版本为vue2+sass ![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/d1b17f4002db46719dbedaa79b703e77~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp?)

### 1、引入Openlayers

Openlayers的npm包名为ol,咱们直接在项目中引入ol就行

```js
npm install ol
// or
yarn add ol
```

将初始文件默认路由的页面更改下

```js
// app.vue
<template>
    <div id="app">
        <router-view />
        </div>
</template>

<style lang="scss">
    #app {
        font-family: Avenir, Helvetica, Arial, sans-serif;
        -webkit-font-smoothing: antialiased;
        -moz-osx-font-smoothing: grayscale;
        text-align: center;
        color: #2c3e50;
    }
</style>

// Home.vue
<template>
    <div class="home">
        </div>
</template>

<script>
        export default {
name: "Home",
    components: {},
};
</script>
```

### 2、底图渲染

在Home.vue文件中进行map渲染，本文采用的是高德地图的切片地图模式，

```js
// Home.vue
<template>
    <div class="home">
        <div id="map" class="map-home"></div>
</div>
</template>

<script>
            import { Map, View } from "ol";
import * as olProj from "ol/proj";
import TileLayer from "ol/layer/Tile";
import XYZ from "ol/source/XYZ";

export default {
    name: "Home",
    components: {},
    data() {
        return {
            openMap: null,
        };
    },
    mounted() {
        this.initMap();
    },
    methods: {
        initMap() {
            this.openMap = new Map({
                target: "map",
                layers: [
                    new TileLayer({
                        source: new XYZ({
                            url: "https://wprd0{1-4}.is.autonavi.com/appmaptile?lang=zh_cn&size=1&style=7&x={x}&y={y}&z={z}",
                        }),
                    }),
                ],
                view: new View({
                    // 将西安作为地图中心 
                    center: olProj.fromLonLat([108.945951, 34.465262]),
                    zoom: 1,
                }),
                controls: [],
            });
        },
    },
};
</script>
<style lang="scss" scoped>
    .map-home {
        width: 100vw;
        height: 100vh;
    }
</style>
```

基本类介绍，Openlayers中4个主要的类：

- Map：地图容器,通过target指定地图绘制的容器id,如代码中的map；
- Layer：图层，map拥有1个获多个图层，可以理解成PS绘图中的图层概念，整个map是由一个个图层堆叠出来的；
- View：可视区域，这个类主要是控制地图与人的交互，如进行缩放，调节分辨率、地图的旋转等控制。同时可以设置投影，默认为球形墨卡托，代码中olProj.fromLonLat方法也是将经纬度转换成对应的坐标，这块不做拓展，有需要的同学可自行去学习GIS的理论。
- source：数据来源，即图层Layers的数据组成部分，上文代码中TileLayer就是使用了一个高德地图XYZ格式的切片数据绘制而成，

此时运行项目已经能够看到地图展示了。

### 3、标记绘制

地图中最常见的需求就是做点位标记，同理，这时我们只需要在之前的地图Layer上再盖一层点位标记的Layer即可，使用的是VectorLayer跟VectorSource，矢量图层以及一个矢量数据

```js
import { Vector as VectorLayer} from 'ol/layer';
import { Vector as VectorSource} from 'ol/source';
```

我们这里简单实现，直接将一个点位添加到openMap的layers数组里；

```js
// import
import { Map, View, Feature } from "ol";
import { Tile as TileLayer, Vector as VectorLayer } from "ol/layer";
import { XYZ, Vector as VectorSource } from "ol/source";
import * as olProj from "ol/proj";
import { Point } from "ol/geom";
import { Style, Fill, Stroke, Circle as sCircle } from "ol/style";

// methods添加setMarker方法
mounted() {
    this.initMap();
    this.setMarker();
},

    // setMarker
    setMarker() {
        let _style = new Style({
            image: new sCircle({
                radius: 10,
                stroke: new Stroke({
                    color: "#fff",
                }),
                fill: new Fill({
                    color: "#3399CC",
                }),
            }),
        });
        let _feature = new Feature({
            geometry: new Point(olProj.fromLonLat([108.945951, 34.465262])),
        });
        _feature.setStyle(_style);
        let _marker = new VectorLayer({
            source: new VectorSource({
                features: [_feature],
            }),
        });
        this.openMap.addLayer(_marker);
    },
```

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/cab1975d8f2c4a379496a3a25e19283c~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp?)

成功在地图上添加了一个点位。

上方代码中import了几个新的类：Feature，Point，Style等，主要是具有几何的地理要素的矢量对象以及具体的样式，然后通过setStyle将样式赋予Feature，主要就在地图上绘制出了一个坐标点。

### 4、点击弹窗

接下来咱们需要给3小节中的坐标点添加点击事件，同时能够在地图上显示一个弹框，展示点位的一些信息。

首先添加点击事件,这里使用单击singleclick

```js
singleclick() {
    this.openMap.on("singleclick", (e) => {
        // 判断是否点击在点上
        let feature = this.openMap.forEachFeatureAtPixel(
            e.pixel,
            (feature) => feature
        );
        console.log(feature);
    });
},
```

当我们没有点击在点上时，会打印undefined，而点击在点上时会打印出对应的feature信息

这里我们同时添加一个事件pointermove，改变鼠标移到到点位上的光标样式。

```js
pointermove() {
    this.openMap.on("pointermove", (e) => {
        if (this.openMap.hasFeatureAtPixel(e.pixel)) {
            this.openMap.getViewport().style.cursor = "pointer";
        } else {
            this.openMap.getViewport().style.cursor = "inherit";
        }
    });
},
```

接着上面的点击事件，当我们点击时希望能够在点位的上方显示出该点的信息弹窗

先在vue添加个弹窗组件，需要引入一个新的类Overlay

```js
import { Overlay } from "ol";
// template
<!-- 弹框 -->
<div ref="popup" class="popup" v-show="shopPopup">
    <div class="info">
        <ul>
        <li>信息1：xxx</li>
<li>信息2：xxx</li>
<li>信息3：xxx</li>
</ul>
</div>
</div>

// script
addOverlay() {
    // 创建Overlay
    let elPopup = this.$refs.popup;
    this.popup = new Overlay({
        element: elPopup,
        positioning: "bottom-center",
        stopEvent: false,
        offset: [0, -20],
    });
    this.openMap.addOverlay(this.popup);
},

    // style
    .popup {
        width: 200px;
        background-color: white;
        padding: 18px;
        border-radius: 10px;
        box-shadow: 0 0 15px rgb(177, 177, 177);
        .info {
            font-size: 14px;
            text-align: left;
            ul {
                padding-left: 0;
            }
        }
    }
```

使用ol的addOverlay方法,将弹出层添加到map的Overlay上，然后修改之前的点击事件函数

```js
singleclick() {
    // 点击
    this.openMap.on("singleclick", (e) => {
        // 判断是否点击在点上
        let feature = this.openMap.forEachFeatureAtPixel(
            e.pixel,
            (feature) => feature
        );
        console.log(feature);
        if (feature) {
            this.shopPopup = true;
            // 设置弹窗位置
            let coordinates = feature.getGeometry().getCoordinates();
            this.popup.setPosition(coordinates);
        } else {
            this.shopPopup = false;
        }
    });
},
```

可以看到有设置弹窗位置的代码

```js
// 设置弹窗位置
let coordinates = feature.getGeometry().getCoordinates();
this.popup.setPosition(coordinates);
```

获取当前点击点的坐标，然后设置给弹窗，同时之前弹窗设置了y轴-30的偏移 以防覆盖掉点位标记。

至此，咱们整个点击弹窗就实现完成了。

![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b28d408adf6f4fcbab619f92df438954~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp?) 最

后，附上完整代码，主要是Home.vue的修改

```js
<template>
    <div class="home">
        <div id="map" class="map-home"></div>
<!-- 弹框 -->
<div ref="popup" class="popup" v-show="shopPopup">
    <div class="info">
        <ul>
        <li>信息1：xxx</li>
<li>信息2：xxx</li>
<li>信息3：xxx</li>
</ul>
</div>
</div>
</div>
</template>

<script>
        import { Map, View, Feature, Overlay } from "ol";
import { Tile as TileLayer, Vector as VectorLayer } from "ol/layer";
import { XYZ, Vector as VectorSource } from "ol/source";
import * as olProj from "ol/proj";
import { Point } from "ol/geom";
import { Style, Fill, Stroke, Circle as sCircle } from "ol/style";

export default {
    name: "Home",
    components: {},
    data() {
        return {
            openMap: null,
            popup: null,
            shopPopup: false,
        };
    },
    mounted() {
        this.initMap();
    },
    methods: {
        initMap() {
            this.openMap = new Map({
                target: "map",
                layers: [
                    new TileLayer({
                        source: new XYZ({
                            url: "https://wprd0{1-4}.is.autonavi.com/appmaptile?lang=zh_cn&size=1&style=7&x={x}&y={y}&z={z}",
                        }),
                    }),
                ],
                view: new View({
                    center: olProj.fromLonLat([108.945951, 34.465262]),
                    zoom: 1,
                }),
                controls: [],
            });
            this.setMarker();
            this.addOverlay();
            this.singleclick();
            this.pointermove();
        },
        setMarker() {
            let _style = new Style({
                image: new sCircle({
                    radius: 10,
                    stroke: new Stroke({
                        color: "#fff",
                    }),
                    fill: new Fill({
                        color: "#3399CC",
                    }),
                }),
            });
            let _feature = new Feature({
                geometry: new Point(olProj.fromLonLat([108.945951, 34.465262])),
            });
            _feature.setStyle(_style);
            let _marker = new VectorLayer({
                source: new VectorSource({
                    features: [_feature],
                }),
            });
            this.openMap.addLayer(_marker);
        },
        addOverlay() {
            // 创建Overlay
            let elPopup = this.$refs.popup;
            this.popup = new Overlay({
                element: elPopup,
                positioning: "bottom-center",
                stopEvent: false,
                offset: [0, -20],
            });
            this.openMap.addOverlay(this.popup);
        },
        singleclick() {
            // 点击
            this.openMap.on("singleclick", (e) => {
                // 判断是否点击在点上
                let feature = this.openMap.forEachFeatureAtPixel(
                    e.pixel,
                    (feature) => feature
                );
                console.log(feature);
                if (feature) {
                    this.shopPopup = true;
                    // 设置弹窗位置
                    let coordinates = feature.getGeometry().getCoordinates();
                    this.popup.setPosition(coordinates);
                } else {
                    this.shopPopup = false;
                }
            });
        },
        pointermove() {
            this.openMap.on("pointermove", (e) => {
                if (this.openMap.hasFeatureAtPixel(e.pixel)) {
                    this.openMap.getViewport().style.cursor = "pointer";
                } else {
                    this.openMap.getViewport().style.cursor = "inherit";
                }
            });
        },
    },
};
</script>
<style lang="scss" scoped>
    .map-home {
        width: 100vw;
        height: 100vh;
    }
.popup {
    width: 200px;
    background-color: white;
    padding: 18px;
    border-radius: 10px;
    box-shadow: 0 0 15px rgb(177, 177, 177);
    .info {
        font-size: 14px;
        text-align: left;
        ul {
            padding-left: 0;
        }
    }
}
</style>
```

## 三、最后

gitee地址：[gitee.com/shtao_056/v…](https://link.juejin.cn?target=https%3A%2F%2Fgitee.com%2Fshtao_056%2Fvue-openlayers.git)

下一篇文章地址：

[vue+OpenLayers项目实践（二）：多地图切换](https://juejin.cn/post/7026229212725903374)

