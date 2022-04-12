- [vue+OpenLayers 项目实践（四）：设置围栏 - 掘金 (juejin.cn)](https://juejin.cn/post/7028076782678966280)

## 一、前言

由于最近项目需要，需要在**vue**项目中使用**OpenLayers**来进行 GIS 地图的开发，网上对 OpenLayers 文章并不算太大，借此机会分享下自己在项目中实际使用的一些心得。

本系列将陆续分享项目过程中实现的一些功能点。 往期目录:

1. [vue+OpenLayers 项目实践（一）：基本绘制与点击弹窗](https://juejin.cn/post/7025529005214269470)
2. [vue+OpenLayers 项目实践（二）：多地图切换](https://juejin.cn/post/7026229212725903374)
3. [vue+OpenLayers 项目实践（三）：Cluster设置集群](https://juejin.cn/post/7026578356699136036)

今天我们来学习下围栏功能，围栏即在地图上绘制一块规则或不规则的区域，通过判断坐标是否在区域内来处理位置与区域之间的关系，常见的应用场景有：

- 签到打卡，在打卡操作前，判断用户是否已经在对应的地理围栏区域内；
- 范围监控，比如共享单车是否驶出了规定地理围栏区域；
- 等等...

老样子，看看官方有没有提供基础的案例：

[draw-shapes](https://link.juejin.cn?target=https%3A%2F%2Fopenlayers.org%2Fen%2Flatest%2Fexamples%2Fdraw-shapes.html)

[draw-features](https://link.juejin.cn?target=https%3A%2F%2Fopenlayers.org%2Fen%2Flatest%2Fexamples%2Fdraw-features.html)

## 二、具体实现

分析咱们需要实现的功能：

1. 实现右键菜单，打开新增围栏弹窗
2. 新增围栏
3. 查看围栏
4. 判断点位是否在围栏区域内

本篇先介绍上半部分。

### 1. 实现右键菜单

首先实现一个右键菜单，在地图上右键时，直接以右键的位置为中心弹出一个围栏绘制弹层。

具体实现步骤：

- 添加右键菜单overlay到map上
- 通过getViewport()获取地图所在的Dom，重写它的右键事件

第一步可直接查看之前的文章[vue+OpenLayers 项目实践（一）：基本绘制与点击弹窗](https://juejin.cn/post/7025529005214269470)，这里不过多说明，此处主要提供下右键相关的代码

```js
// 右键点击
this.openMap.getViewport().oncontextmenu = (e) => {
    // 取消默认右键事件
    e.preventDefault();
    this.showMenuPopup = true;
    // 设置弹窗位置跟随鼠标
    let coordinates = this.openMap.getEventCoordinate(e);
    this.position = coordinates;
    this.menuPopup.setPosition(coordinates);
};
```

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/8cae166412c24989a6a4ee9d7fe931a0~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp?)

### 2. 新增围栏

通过点击新增围栏，弹出弹窗。在components文件夹下新增Fences.vue。

```css
<template>
<el-dialog
title="编辑围栏"
:visible="dialogVisible"
custom-class="fence"
append-to-body
@close="handleClose"
    width="1200px"
    destroy-on-close
    >
    <div id="fence-map" class="map-box"></div>
    </el-dialog>
    </template>

    <script>
    import { Map, View } from "ol";
import { Tile as TileLayer, Vector as VectorLayer } from "ol/layer";
import { Vector as VectorSource } from "ol/source";
import { Style, Fill, Stroke, Circle as sCircle } from "ol/style";
import { getMap } from "@/utils/webStorage";
import mapType from "@/utils/openlayers/maptype";
export default {
    props: {
        visible: {
            type: Boolean,
                default: false,
        },
        location: {
            type: Array,
                default: () => {
                    return [];
            },
        },
    },
    data() {
        return {
            dialogVisible: false,
                locaMap: null,
                openMap: null,
                fenceSource: null
        };
    },
    watch: {
        visible: {
            handler: function (value) {
                if (value) {
                    this.dialogVisible = true;
                    this.locaMap = getMap() || "0";
                    this.$nextTick(() => {
                        this.initMap();
                    });
                }
            },
            immediate: true,
        },
    },
    mounted() {},
    methods: {
        initMap() {
            const _maplist = mapType;
            const _tileLayer = new TileLayer({
                source: _maplist.find((e) => e.id === this.locaMap).value,
            });
            this.fenceSource = new VectorSource({ wrapX: false });

            const _vector = new VectorLayer({
                source: this.fenceSource,
                    style: new Style({
                        fill: new Fill({
                            color: "rgba(49,173,252, 0.2)",
                        }),
                        stroke: new Stroke({
                            color: "#0099FF",
                                width: 3,
                        }),
                        image: new sCircle({
                            radius: 7,
                                fill: new Fill({
                                    color: "#0099FF",
                            }),
                        }),
                }),
            });
            this.openMap = new Map({
                target: "fence-map",
                    layers: [_tileLayer, _vector],
                    view: new View({
                        center: this.location,
                            zoom: 10,
                }),
                controls: [],
            });
        },
        handleClose() {
            this.$emit("close");
        }
    },
};
</script>

<style lang="scss" scoped>
.fence {
    .el-dialog__header {
        padding: 20px;
    }
    .el-dialog__body {
        padding: 0;
    }
}
.map-box {
    width: 100%;
    height: 60vh;
}
</style>
```

同时需要在Home.vue中设置弹窗：

```js
<template>
    ...
    <!-- 组件容器 -->
    <component
v-if="operateDialogVisible"
:is="currentComponent"
:visible="operateDialogVisible"
:location="position"
@close="handleOperateClose"
></component>
    ...
        </template> 

data(){
    ...
    operateDialogVisible: false,
        currentComponent: null,
            position: null,
}

// 添加方法
// 打开弹窗
handleOperate(component) {
    this.showMenuPopup = false;
    this.operateDialogVisible = true;
    this.currentComponent = component;
},
    // 关闭弹窗
    handleOperateClose() {
        this.operateDialogVisible = false;
    },
```

在fences组件中添加围栏，主要api为"ol/interaction/Draw"，首先在页面上加入设置围栏的按钮，实现圆形跟多边形绘制。

```html
<div class="map-area">
    <el-card class="tool-window" style="width: 380px">
        <el-form label-width="80px">
            <el-form-item label="围栏名称">
                <el-input
                          size="small"
                          v-model="name"
                          placeholder="请输入围栏名称"
                          ></el-input>
            </el-form-item>
            <el-form-item label="围栏样式">
                <el-radio-group v-model="tool" size="small" @change="setType">
                    <el-radio-button label="Circle">圆形</el-radio-button>
                    <el-radio-button label="Polygon">多边形</el-radio-button>
                </el-radio-group>
            </el-form-item>
            <el-form-item>
                <el-button type="warning" size="small" @click="handleClear"
                           >清除</el-button
                    >
                <el-button type="primary" size="small" @click="handleSave"
                           >保存</el-button
                    >
                <el-button size="small" @click="handleClose">取消</el-button>
            </el-form-item>
        </el-form>
    </el-card>
</div>
```

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/d4febc77eab6447381281733ef84dadb~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp?) 

页面样式如图。 现在来实现围栏绘制。

首先引入Draw

```javascript
import Draw from "ol/interaction/Draw";
// data中添加属性
data() {
    return {
        ...
        fenceSource: null,
        fenceDraw: null,
        tool: "Circle",
        name: "",
    };
},
    // 实现addInteraction方法
    addInteraction() {
        this.fenceDraw = new Draw({
            source: this.fenceSource,
            type: this.tool,
        });
        this.openMap.addInteraction(this.fenceDraw);
    },
        // 切换类型
        setType() {
            this.fenceSource.clear();
            this.openMap.removeInteraction(this.fenceDraw);
            this.addInteraction();
        },
            // 按钮方法
            handleClear() {
                this.fenceSource.clear();
            },
                handleSave() {
                    // 保存
                },
                    // initMap中调用
                    initMap(){
                        ...
                        this.addInteraction();
                    }
```

![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/f3fe321750214d678fae590232efadd2~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp?)

OK,本篇实现了围栏的前期绘制功能，下篇继续介绍围栏其他的功能点。

## 最后

gitee 地址：[gitee.com/shtao_056/v…](https://link.juejin.cn?target=https%3A%2F%2Fgitee.com%2Fshtao_056%2Fvue-openlayers%2Ftree%2Fpart4)