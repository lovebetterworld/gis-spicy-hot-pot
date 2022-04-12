- [vue+OpenLayers 项目实践（六）：历史轨迹绘制 - 掘金 (juejin.cn)](https://juejin.cn/post/7031769090515533860)

## 前言

由于最近项目需要，需要在**vue**项目中使用**OpenLayers**来进行 GIS 地图的开发，网上对 OpenLayers 文章并不算太大，借此机会分享下自己在项目中实际使用的一些心得。

本系列将陆续分享项目过程中实现的一些功能点。

本文主要讲解地图上的轨迹绘制，以及相关的一些功能。

## 具体实现

本文需要实现的功能：

- 修改文章一中的弹窗卡片添加历史轨迹按钮
- 点击历史轨迹弹出轨迹地图弹窗
- 添加时间筛选，可通过筛选时间进行查询
- 绘制轨迹

ok，接下来一步步进行实现：

### 1. 添加按钮

修改[vue+OpenLayers 项目实践（一）：基本绘制与点击弹窗](https://juejin.cn/post/7025529005214269470)中实现的弹窗，添加上按钮。

```js
// Home.vue
<!-- 信息弹框 -->
<div ref="popup" class="popup" v-show="showPopup">
  <div class="info">
    <ul>
      <li>信息1：xxx</li>
      <li>信息2：xxx</li>
      <li>信息3：xxx</li>
    </ul>
    <div class="btns-box">
      <el-button @click.native="handleOperate('dialog-route')">
        历史轨迹
      </el-button>
    </div>
  </div>
</div>

```

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/3bca36ce880e4d8a9066a03866677929~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp?) 实际项目中还需要去传点位id等参数，根据不同的点位，获取不同的轨迹路线，此处由于只是教学demo,就不具体去实现，同学们可以根据自己的项目实际需求去完善代码。

这里需要将左键点击的位置传给position,方便弹窗view的center设置,修改Home.vue中的mouseClick方法

![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/631204b13a614196b27866104818415e~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp?)

### 2. 添加弹窗组件

接下来实现弹窗组件dialog-route，在components文件夹下新建Route.vue文件，同时在Home.vue文件夹中引入。

```js
components: {
  DialogFence: () => import("@/components/Fences"),
  DialogRoute: () => import("@/components/Route"),
},

```

新增Route.vue

```js
<!--
 * @Author: Shao Tao
 * @Date: 2021-11-18 10:28:33
 * @LastEditTime: 2021-11-18 10:47:59
 * @LastEditors: Shao Tao
 * @Description: 
 * @FilePath: \vue-openlayers\src\components\Route.vue
-->
<template>
  <el-dialog
    title="历史轨迹"
    :visible="dialogVisible"
    custom-class="route"
    append-to-body
    @close="handleClose"
    width="1200px"
    destroy-on-close
  >
    <div id="fence-map" class="map-box"></div>
    <div class="map-area">
      <el-card class="tool-window" style="width: 380px"> </el-card>
    </div>
  </el-dialog>
</template>

<script>
import { Map, View } from "ol";
import { Tile as TileLayer } from "ol/layer";

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
      routeSource: null,
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
      this.openMap = new Map({
        target: "fence-map",
        layers: [_tileLayer],
        view: new View({
          center: this.location,
          zoom: 10,
        }),
        controls: [],
      });
    },
    handleClose() {
      this.$emit("close");
    },
  },
};
</script>

<style lang="scss" scoped>
.route {
  .el-dialog__header {
    padding: 20px;
  }
  .el-dialog__body {
    padding: 0;
    .map-area {
      box-shadow: inset 5em 1em #000000;
      position: relative;
      .tool-window {
        width: 200px;
        position: absolute;
        bottom: 20px;
        right: 20px;
        .button {
          font-size: 20px;
        }
      }
    }
  }
}
.map-box {
  width: 100%;
  height: 60vh;
}
</style>


```

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/e233261cbe904fc29752fdefb9835354~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp?) OK,点击按钮后弹窗功能实现，接下来修改弹窗左下角的card，添加一个时间选择。

### 3. 添加时间筛选

时间项目中，历史轨迹往往会有大量的数据，如果一次性的请求渲染显然不现实，所以需要通过时间进行分割，根据时间区间进行请求。

**el-card**中添加时间选择组件以及一个查询按钮。

```js
<el-card class="tool-window" style="width: 380px">
    <el-date-picker
      v-model="dateRange"
      type="daterange"
      value-format="yyyy-MM-dd"
      start-placeholder="开始时间"
      end-placeholder="结束时间"
      style="width: 100%"
    >
    </el-date-picker>
    <div style="margin-top: 15px">
      <el-button type="primary" @click="getList">查询</el-button>
    </div>
</el-card>

```

添加getList方法，去请求数据，这里就直接用假数据演示了。

```js
getList() {
  let _data = [
    [108.945951, 34.465262],
    [109.04724, 34.262504],
    [108.580321, 34.076162],
    [110.458983, 35.071209],
    [105.734862, 35.49272],
  ];
  this.routes = _data.map((item) => {
    return olProj.fromLonLat(item);
  });
  this.drawRoute();
},
// 绘制轨迹
drawRoute() {},

```

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/2bf0410b2f244a24bb385b131fbe72a1~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp?) 接下来继续实现drawRoute方法。

### 4. 绘制轨迹

绘制轨迹需要调用LineString类，同时需要在轨迹上描绘出点标记，还需要用到Point；

```js
// 绘制轨迹
drawRoute() {
  if (this.routeGeometry) {
    this.routeSource.clear();
  }
  this.routeGeometry = new LineString(this.routes);
  let route = new Feature(this.routeGeometry);
  // 绘制点
  let opints = this.drawPoint();
  this.routeSource.addFeatures([route, ...opints]);
},
// 画点
drawPoint() {
  let iconFeatures = [];
  this.routes.forEach((item) => {
    let _feature = new Feature(new Point(item));
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
    _feature.setStyle(_style);
    iconFeatures.push(_feature);
  });
  return iconFeatures;
},

```

最后将view定位到轨迹的位置，使得整条轨迹能够在地图上居中显示。

```js
// 绘制轨迹
drawRoute() {
  ...
  // 按轨迹边界缩放
  this.mapFit();
},
mapFit() {
  let view = this.openMap.getView();
  view.fit(this.routeGeometry, {
    padding: [120, 120, 120, 120],
  });
},

```

ok,到此整条轨迹就显示在地图上了。

![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/f7c188caf9d1448b8c20beed713f56d0~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp?)

需要注意的是在getList里，我们拿到的经纬度数组一定要通过olProj.fromLonLat去转换一下，不然无法正常的在地图上展示。

## 最终效果

![map.gif](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/13195f9b6fb9452e95938ffd1043103a~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp?)

## 往期目录:

1. [vue+OpenLayers 项目实践（一）：基本绘制与点击弹窗](https://juejin.cn/post/7025529005214269470)
2. [vue+OpenLayers 项目实践（二）：多地图切换](https://juejin.cn/post/7026229212725903374)
3. [vue+OpenLayers 项目实践（三）：Cluster 设置集群](https://juejin.cn/post/7026578356699136036)
4. [vue+OpenLayers 项目实践（四）：设置围栏](https://juejin.cn/post/7028076782678966280)
5. [vue+OpenLayers 项目实践（五）：历史围栏](https://juejin.cn/post/7028489983392497701)

## 最后

gitee 地址：[gitee.com/shtao_056/v…](https://link.juejin.cn?target=https%3A%2F%2Fgitee.com%2Fshtao_056%2Fvue-openlayers%2Ftree%2Fpart6)