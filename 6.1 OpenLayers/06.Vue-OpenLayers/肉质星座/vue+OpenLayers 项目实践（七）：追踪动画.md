- [vue+OpenLayers 项目实践（七）：追踪动画 - 掘金 (juejin.cn)](https://juejin.cn/post/7032188908565692452)

## 前言

由于最近项目需要，需要在**vue**项目中使用**OpenLayers**来进行 GIS 地图的开发，网上对 OpenLayers 文章并不算太多，借此机会分享下自己在项目中实际使用的一些心得。

本系列将陆续分享项目过程中实现的一些功能点。

本文基于前文的轨迹绘制[vue+OpenLayers 项目实践（六）：历史轨迹绘制](https://juejin.cn/post/7031769090515533860)，为其添加个动画追踪效果。

## 具体实现

本文需要实现的功能：

- 丰富轨迹右下角卡片中的选项及按钮，添加自定义速度，开始结束暂停等功能按键；
- 实现动态追踪效果

ok，接下来进行具体实现：

### 1，引入小车icon

首先我们引入一个小车图片：

![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/2c878de458bb440580fda3f46cf77ca8~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp?)

在代码中添加小车的图层，初始位置在第一个坐标点。

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
  // 添加小车
  let car = this.drawCar();
  this.routeSource.addFeatures([route, ...opints, car]);
  // 按轨迹边界缩放
  this.mapFit();
},
...

// 小车
drawCar() {
  const carMarker = new Feature({
    geometry: new Point(this.routeGeometry.getFirstCoordinate()),
  });
  let _style = new Style({
    image: new Icon({
      anchor: [0.5, 0.5],
      src: require("@/assets/img/car.png"),
      imgSize: [20, 36],
    }),
  });
  carMarker.setStyle(_style);
  this.carGeometry = carMarker;
  return carMarker;
},

```

![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/f1be191a728d4f5d929ce2678e4a1f07~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp?) OK,添加了一个绿色小车。

### 2. 拓展右下角控件

```js
<div class="speed">
  速度：
  <div class="speed-input">
    <el-slider
      v-model="speed"
      :min="10"
      :max="1000"
      :step="10"
    ></el-slider>
  </div>
  <el-button type="primary" @click="changeAnimation">{{
    animationText
  }}</el-button>
</div>

```

添加一个速度滑块控件。 ![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/3dc7fd1eb995414791d5c0ef5cc08ab2~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp?)

### 3.动画实现

openlayers轨迹动画的实现原理：

- 通过speed对现有路径进行分割，分割出大量的坐标点。
- 通过监听postrender进行重新设置小车的坐标点来实现动画。

首先封装一下公共的方法：

- 我们需要小车能够转向，所以需要计算出小车旋转的弧度
- 计算出两个点位之间的总长度
- 根据总长度及speed来将两个点位间插入分割点,返回一个新数组

```js
/*
 * @Author: Shao Tao
 * @Date: 2021-11-19 13:38:44
 * @LastEditTime: 2021-11-19 15:53:14
 * @LastEditors: Shao Tao
 * @Description:
 * @FilePath: \vue-openlayers\src\utils\openlayers\route.js
 */
import { getDistance } from "ol/sphere";
import { transform } from "ol/proj";

/**
 * 根据坐标获取弧度
 */
export function getRotation(lng1, lat1, lng2, lat2) {
  let rotation = Math.atan2(lng2 - lng1, lat2 - lat1);
  return rotation;
}
/**
 * 计算坐标2点之间的距离
 */
export function formatLength(map, pointArray) {
  let length = 0;
  if (map.getView().getProjection().code_ == "EPSG:4326") {
    for (let i = 0, ii = pointArray.length - 1; i < ii; ++i) {
      let c1 = pointArray[i];
      let c2 = pointArray[i + 1];

      length += getDistance(c1, c2);
    }
  } else if (map.getView().getProjection().code_ == "EPSG:3857") {
    for (let i = 0, ii = pointArray.length - 1; i < ii; ++i) {
      let c1 = pointArray[i];
      let c2 = pointArray[i + 1];
      c1 = transform(c1, "EPSG:3857", "EPSG:4326");
      c2 = transform(c2, "EPSG:3857", "EPSG:4326");
      length += getDistance(c1, c2);
    }
  }
  return length;
}

/**
 * 计算两点之间的中间点
 * @param {*} map
 * @param {Array} pointDoubleArray 二维数组坐标
 * @param {num} speed 每个点之间的距离
 */
export function getCenterPoint(map, pointDoubleArray, speed) {
  speed = speed == undefined ? 10 : speed;
  let twolength = formatLength(map, pointDoubleArray);
  let rate = twolength / speed; //比例 默认10m/点
  let step = Math.ceil(rate); //步数（向上取整）
  let arr = new Array(); //定义存储中间点数组
  let c1 = pointDoubleArray[0]; //头部点
  let c2 = pointDoubleArray[1]; //尾部点
  let x1 = c1[0],
    y1 = c1[1];
  let x2 = c2[0],
    y2 = c2[1];
  for (let i = 1; i < step; i++) {
    let coor = new Array(2);
    coor[0] = ((x2 - x1) * i) / rate + x1;
    coor[1] = ((y2 - y1) * i) / rate + y1;
    arr.push(coor); //此时arr为中间点的坐标
  }
  arr.push(c2);
  return arr;
}

```

接着修改Route.vue文件，在获取路径后将路径进行分割getRoutesAll

```js
// 修改getList方法，调用getRoutesAll方法
getList() {
  ....
  this.getRoutesAll();
},

// 新增 分割路径点
getRoutesAll() {
  this.lastRouteIndex = 0;
  let _routesAll = [
    {
      coordinate: this.routes[0],
    },
  ];
  for (let i = 0, len = this.routes.length; i < len - 1; i++) {
    const item = this.routes[i];
    const itemNext = this.routes[i + 1];
    const rotation = getRotation(...item, ...itemNext);
    let points = getCenterPoint(this.openMap, [item, itemNext], this.speed);
    points = points.map((item) => {
      return {
        rotation,
        coordinate: item,
      };
    });
    _routesAll = [..._routesAll, ...points];
  }
  this.routesAll = _routesAll;
},

```

这样我们就生成里一个包含弧度以及坐标的轨迹数组。然后实现点位移动。

```js
changeAnimation() {
  this.animating ? this.stopAnimation() : this.startAnimation();
},
// 开始动画
startAnimation() {
  this.animating = true;
  this.lastTime = Date.now();
  this.animationText = "停止";
  this.routeLayer.on("postrender", this.moveFeature);
  this.carFeature.setGeometry(null);
},
// 停止动画
stopAnimation() {
  this.animating = false;
  this.animationText = "开始";
  this.carFeature.setGeometry(this.carGeometry);
  this.routeLayer.un("postrender", this.moveFeature);
},
// 移动动画
moveFeature(event) {
  // 具体移动动画方法
},

```

实现moveFeature方法：

```js
moveFeature(event) {
  const len = this.routesAll.length;
  if (this.lastRouteIndex < len - 1) {
    this.lastRouteIndex++;
  } else {
    this.lastRouteIndex = 0;
  }
  const current = this.routesAll[this.lastRouteIndex];
  this.carGeometry.setCoordinates(current.coordinate);
  const vectorContext = getVectorContext(event);
  let _style = new Style({
    image: new Icon({
      anchor: [0.5, 0.5],
      rotation: current.rotation,
      src: require("@/assets/img/car.png"),
      imgSize: [20, 36],
    }),
  });
  vectorContext.setStyle(_style);
  vectorContext.drawGeometry(this.carGeometry);
  this.openMap.render();
},
```

ok，到此咱们就将整个轨迹移动实现了。

## 最终效果

![map.gif](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/3ddcb4910d744debbd291afce4267099~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp?)

## 往期目录:

1. [vue+OpenLayers 项目实践（一）：基本绘制与点击弹窗](https://juejin.cn/post/7025529005214269470)
2. [vue+OpenLayers 项目实践（二）：多地图切换](https://juejin.cn/post/7026229212725903374)
3. [vue+OpenLayers 项目实践（三）：Cluster 设置集群](https://juejin.cn/post/7026578356699136036)
4. [vue+OpenLayers 项目实践（四）：设置围栏](https://juejin.cn/post/7028076782678966280)
5. [vue+OpenLayers 项目实践（五）：历史围栏](https://juejin.cn/post/7028489983392497701)
6. [vue+OpenLayers 项目实践（六）：历史轨迹绘制](https://juejin.cn/post/7031769090515533860)

## 最后

gitee 地址：[gitee.com/shtao_056/v…](https://link.juejin.cn?target=https%3A%2F%2Fgitee.com%2Fshtao_056%2Fvue-openlayers%2Ftree%2Fpart7)