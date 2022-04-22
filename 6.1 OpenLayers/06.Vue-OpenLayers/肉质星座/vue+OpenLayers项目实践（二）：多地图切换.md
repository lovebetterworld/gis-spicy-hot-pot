- [vue+OpenLayers项目实践（二）：多地图切换 - 掘金 (juejin.cn)](https://juejin.cn/post/7026229212725903374)

## 一、前言

由于最近项目需要，需要在**vue**项目中使用**OpenLayers**来进行 GIS 地图的开发，网上对 OpenLayers 文章并不算太大，借此机会分享下自己在项目中实际使用的一些心得。

本系列将陆续分享项目过程中实现的一些功能点。 往期目录:

1. [vue+OpenLayers项目实践（一）：基本绘制与点击弹窗](https://juejin.cn/post/7025529005214269470)

由于项目需要支持海外用户，需要引入其他地图，上一篇中我们引入的高德地图，现在需要再引入一个Bing地图，本文主要介绍如何实现多地图切换功能。

## 二、具体实现

### 1、申请BingMap key

使用BingMap需要申请对应的key,在此不多做展开，大家可以直接去 [www.bingmapsportal.com/](https://link.juejin.cn?target=https%3A%2F%2Fwww.bingmapsportal.com%2F) 申请，方法还是比较简单的。

目前BingMap，非商业用途是不会收费的，可以放心使用。

### 2、实现Bing地图展示

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/a63f9470e873411fb910ac8cf4039682~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp?)

在src目录下添加utils常用工具函数文件夹，在utils内添加openlayers文件夹，后续openlayers相关的工具函数都放在此目录下。

openlayers目录下新建maptype.js

```js
// maptype.js

import { XYZ, BingMaps } from "ol/source";

let list = [
    {
        name: "高德地图",
        value: new XYZ({
            url: "https://wprd0{1-4}.is.autonavi.com/appmaptile?lang=zh_cn&size=1&style=7&x={x}&y={y}&z={z}",
        }),
        id: "0",
    },
    {
        name: "必应地图",
        value: new BingMaps({
            key: "BingMap key",
            imagerySet: "RoadOnDemand",
        }),
        id: "1",
    },
];

export default list;
```

将之前Home.vue里配置的高德瓦片地图source跟BingMap的封装成list,后期需要添加其他地图也可直接在此文件中修改。

`new BingMaps()`为Openlayers提供的api,其他api可查阅官方文档。

接下来修改Home.vue:

```js
// import
import mapType from "@/utils/openlayers/maptype";

// data
data() {
    return {
        tileLayer: null, // 地图层
        mapList: null, // 地图列表
        locaMap: "1",
    };
},
    mounted() {
        this.mapList = mapType;
        this.tileLayer = new TileLayer({
            source: mapType.find((e) => e.id === this.locaMap).value,
        });
        this.initMap();
    },

        // methods
        initMap() {
            this.openMap = new Map({
                target: "map",
                layers: [this.tileLayer],
                view: new View({
                    center: olProj.fromLonLat([108.945951, 34.465262]),
                    zoom: 1,
                }),
                controls: [],
            });
            ...
        },

```

当将locaMap改成"1"时，可以看到地图已经变成了Bing地图了。

![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/9437fab4df37408e9609ff06ae6ea272~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp?)

### 3、切换按钮

ok，咱们切换地图的基本功能已经实现，现在我们在页面上实现一个按钮去触发切换地图变换。

这里直接使用element-ui的选择器做，引入element-ui，按需引入Select, Option，然后在页面右下角实现个下拉选择，属于前端基操了，不过多说明 直接贴代码：

```js
// main.js
import "element-ui/lib/theme-chalk/index.css";
import { Select, Option } from "element-ui";
Vue.use(Select);
Vue.use(Option);
// Home.vue
// template
<div class="map-toolbar">
    <!-- 地图选择 -->
    <el-select v-model="locaMap" style="width: 150px">
        <el-option
v-for="item in mapList"
:label="item.name"
:value="item.id"
:key="item.id"
@click.native="setMapSource(item)"
></el-option>
</el-select>
</div>
// methods添加切换地图方法
setMapSource(e) {
    this.tileLayer.setSource(e.value);
},
```

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/f1e8df40548f4762af0e9951bbea3409~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp?)

### 4、存储地图选择

使用过程中往往需要将选择的地图样式存储到本地，这里我们将locaMap存储到localStorage中。

在utils目录下新增webStorage.js

```js
// webStorage.js
const locaMap = "locaMap";

export function getMap() {
    return localStorage.getItem(locaMap);
}

export function setMap(e) {
    return localStorage.setItem(locaMap, e);
}
```

暴露存储方法添加到Home.vue中

```js
import { getMap, setMap } from "@/utils/webStorage";

data() {
    return {
        locaMap: getMap() || "0",
    };
},

    // 切换地图
    setMapSource(e) {
        this.tileLayer.setSource(e.value);
        setMap(e.id)
    },
```

当然，你也可以同时添加到Vuex,这个可以自行去完成。我这里就不去添加了。

## 最后

gitee地址：[gitee.com/shtao_056/v…](https://link.juejin.cn?target=https%3A%2F%2Fgitee.com%2Fshtao_056%2Fvue-openlayers.git)