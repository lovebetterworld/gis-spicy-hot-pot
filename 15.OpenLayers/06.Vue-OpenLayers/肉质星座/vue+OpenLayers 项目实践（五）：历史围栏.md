- [vue+OpenLayers 项目实践（五）：历史围栏 - 掘金 (juejin.cn)](https://juejin.cn/post/7028489983392497701)

## 前言

由于最近项目需要，需要在**vue**项目中使用**OpenLayers**来进行 GIS 地图的开发，网上对 OpenLayers 文章并不算太多，借此机会分享下自己在项目中实际使用的一些心得。

本系列将陆续分享项目过程中实现的一些功能点。

本文接着上篇[vue+OpenLayers 项目实践（四）：设置围栏](https://juejin.cn/post/7028076782678966280)，继续讲解围栏中的一下功能点。

## 具体实现

本文需要实现的功能：

- 设计围栏的数据存储格式，并解析
- 处理重复绘制
- 查看历史围栏

### 设计数据格式

上一篇文章中已经完成绘制围栏功能，那么怎么将绘制的围栏信息存储起来方便后续使用呢？咱们在上一篇文章中预留了一个保存围栏数据的方法，下面就继续完善这部分代码。

```js
handleSave() {
  // 保存
},
```

这里添加个新方法drawEnd,监听绘制完成的时候解析数据：

```js
// 绘制完成解析结构
drawEnd(evt) {
  let geo = evt.feature.getGeometry();
  let type = geo.getType(); //获取类型
  const handle = {
    Circle: () => {
      //获取中心点和半径
      let center = geo.getCenter();
      let radius = geo.getRadius();
      this.circleInfo = {
        center: center,
        radius: parseInt(radius),
      };
    },
    Polygon: () => {
      //获取坐标点
      let points = geo.getCoordinates();
      this.polygonPath = points[0];
    },
  };
  if (handle[type]) handle[type]();
},
```

代码中定义了一个handle对象，用于处理绘制的数据，圆将中心点与半径存储到this.circleInfo，而多边形就将点位path存储到this.polygonPath。在addInteraction中注册监听：

```js
this.fenceDraw.on("drawend", (e) => {
  // 绘制完成的回调
  this.drawEnd(e);
});
```

看看打印的结果：

![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/439aea7fc5ed461dad52757d8c27c1b8~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp?)

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/0dea687f053f48d4af160562ebb0069d~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp?)

可以看到围栏信息已经获取到了，但是坐标并不是我们常见的经纬度信息，我们在保存的时候去进行数据处理。

首先定义数据处理函数

```js
import * as olProj from "ol/proj";
// 数据处理
formatFenceData() {
  const handle = {
    Circle: () => {
      if (!this.circleInfo) {
        this.$message.error(this.$t("lan_map.lan_map_fences.pdrwf"));
        return;
      }
      const center = this.circleInfo.center;
      const radius = this.circleInfo.radius;
      const p = olProj.toLonLat(center);
      return `Circle (${p[0]} ${p[1]}, ${radius})`;
    },
    Polygon: () => {
      if (this.polygonPath.length === 0) {
        this.$message.error(this.$t("lan_map.lan_map_fences.pdrwf"));
        return;
      }
      const path = this.polygonPath;
      const pathArr = [];
      path.forEach((item) => {
        const p = olProj.toLonLat(item);
        pathArr.push(`${p[0]} ${p[1]}`);
      });
      return `Polygon (${pathArr.join(", ")})`;
    },
  };
  const type = this.tool;
  if (handle[type]) {
    return handle[type]();
  }
},

```

通过olProj.toLonLat()方法去转换坐标，分别返回`Circle (${p[0]} ${p[1]}, ${radius})`与`Polygon (${pathArr.join(", ")})`的数据格式，如

*Circle (107.62493031295215 33.55224298744986, 21716)*

*Polygon (107.60051625976537 33.56038110614992, 107.71404159451102 33.612243570978194, 107.77995947944197 33.47591089982609)*

最后修改handleSave方法，这里就存本地了，xdm可以在这直接调后端的接口去存储围栏信息，本文就直接存储到本地vuex中了，vuex添加就不去多做说明了，前端基操。有兴趣的可以直接看源码。

```js
handleSave() {
  // 保存
  if (!this.name) {
    this.$message.error("请输入围栏名称");
    return;
  }
  const area = this.formatFenceData();
  if (area) {
    let data = {
      name: this.name,
      area: area,
    };
    // 可调用后端api进行保存，本文直接就存本地vuex中了
    this.addFences(data);
  }
},

```

![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/7c882ed7fd894037b984742eb9a99af5~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp?)

### 处理重复绘制

使用过程中发现，在绘制围栏时可以绘制多个重叠的区域，显然并不是我们想要的，比如：我们需要在画完一个圆的时候，不允许重叠的去画圆，而是清空重新画一个。

需要加入方法mapOnly

```js
addInteraction() {
  this.fenceDraw = new Draw({
    source: this.fenceSource,
    type: this.tool,
  });
  this.openMap.addInteraction(this.fenceDraw);
  this.fenceDraw.on("drawend", (e) => {
    // 绘制完成的回调
    this.drawEnd(e);
  });
  // 检测是否重复绘制
  this.mapOnly();
},

mapOnly() {
  this.fenceDraw.on("drawstart", () => {
    if (this.tool === "Polygon") {
      // 如果已经存在则删除上一个几何
      if (this.polygonPath)
        this.fenceSource.clear() && (this.polygonPath = []);
    } else {
      if (this.circleInfo)
        this.fenceSource.clear() && (this.circleInfo = null);
    }
  });
},

```

如此在围栏绘制的时候只能绘制一个圆/多边形。

### 查看历史围栏

OK，以上都是新增围栏的功能，那么新增的目的都是为了存储后能够查看历史围栏记录，下面开始实现查看功能。

```js
// Home.vue中通过vuex获取围栏数据
computed: {
  ...mapGetters(["fences"]),
},
```

我们需要跟地图切换一样在右下角添加个下拉来切换展示围栏。可参考[vue+OpenLayers 项目实践（二）：多地图切换](https://juejin.cn/post/7026229212725903374)

```js
<!-- 地图围栏 -->
<el-select v-model="fence" style="width: 150px">
  <el-option
    label="不显示围栏"
    value="-1"
    key="-1"
    @click.native="handleSelectFence(null)"
  ></el-option>
  <el-option
    v-for="(item, index) in fences"
    :label="item.name"
    :value="item.name"
    :key="index"
    @click.native="handleSelectFence(item)"
  ></el-option>
</el-select>

data(){
  return{
    ...
    fence: null,
  }
}
...
// 展示围栏
handleSelectFence() {},
```

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/517fc468bea64fa08424529bcb782c64~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp?)

接下来具体实现handleSelectFence，在地图上绘制围栏。

首先添加数据转换函数

```js
// 围栏数据转换
areaFomart(area) {
  // eslint-disable-next-line
  const point = area.match(/[^\(\)]+(?=\))/g)[0].split(", ");
  if (area.match("Circle")) {
    return {
      type: "Circle",
      center: olProj.fromLonLat(point[0].split(" ")),
      radius: Number(point[1]),
    };
  }
  if (area.match("Polygon")) {
    const path = [];
    point.forEach((item) => {
      path.push(olProj.fromLonLat(item.split(" ")));
    });
    return {
      type: "Polygon",
      path: path,
    };
  }
}
```

修改handleSelectFence方法

```js
// 展示围栏
handleSelectFence(data) {
  // 切换时清除之前的围栏
  if (this.fenceVector) {
    this.openMap.removeLayer(this.fenceVector);
  }
  if (!data) {
    this.fence = null;
    return false;
  }
  // 数据转换
  const area = this.areaFomart(data.area);
  // 围栏绘制
  this.setFenceSource(area);
},
```

setFenceSource方法实现：

```js
// 绘制围栏
setFenceSource(area) {
    let feature;
    switch (area.type) {
        case "Circle": {
            feature = new Feature(new gCircle(area.center, area.radius));
            break;
        }
        case "Polygon": {
            feature = new Feature(new Polygon([area.path]));
            break;
        }
        default:
            break;
    }
    // 缩放到围栏区域
    this.mapFit(feature.getGeometry());
    //矢量图层
    let source = new VectorSource({
        features: [feature],
    });
    let vector = new VectorLayer({
        source,
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
    this.fenceVector = vector;
    this.openMap.addLayer(vector);
},
    // 按边界缩放
    mapFit(extent) {
        this.openMap
            .getView()
            .fit(extent, { duration: 1000, padding: [200, 200, 200, 200] });
    },
```

mapFit方法能将地图zoom自动缩放至围栏。

OK，围栏相关的所有功能已经实现。下面时最终效果图：

![map.gif](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/4c5baab2f19e4cebbe835088e0f7fa5f~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp?)

## 往期目录:

1. [vue+OpenLayers 项目实践（一）：基本绘制与点击弹窗](https://juejin.cn/post/7025529005214269470)
2. [vue+OpenLayers 项目实践（二）：多地图切换](https://juejin.cn/post/7026229212725903374)
3. [vue+OpenLayers 项目实践（三）：Cluster 设置集群](https://juejin.cn/post/7026578356699136036)
4. [vue+OpenLayers 项目实践（四）：设置围栏](https://juejin.cn/post/7028076782678966280)

## 最后

gitee 地址：[gitee.com/shtao_056/v…](https://link.juejin.cn?target=https%3A%2F%2Fgitee.com%2Fshtao_056%2Fvue-openlayers%2Ftree%2Fpart5)