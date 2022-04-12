- [openlayers6【二十八】批量设置闪烁点，feature要素通过postrender机制批量生成动态点_范特西是只猫的博客-CSDN博客_openlayers 批量撒点](https://xiehao.blog.csdn.net/article/details/119955823)

## 1. 写在前面

实现点的闪烁效果可以有很多种，下面列举几个常见的实现方式：

### 1.1 实现方式一

可以使用overlay去实现，overlay原理就是创建一个div，通过css样式去控制闪烁（如：[如何用css3做openLayers3的闪烁效果](https://blog.csdn.net/jintingbo/article/details/82855924)），想要[遍历](https://so.csdn.net/so/search?q=遍历&spm=1001.2101.3001.7020)实现的话，就创建多个overlay的div。这种也是网上百度出来最多的一种。缺点就是如果批量生成可能会造成卡顿，因为是直接创建的div页面元素。

### 1.2 实现方式二

使用openlayers3 的`postcompose` 机制去实现，原理跟本文的`postrender`机制差不多，只是openlayers3 和 openlayers6的方法不同了。（如：[openlayers3实现点动态扩散](http://www.codeinn.net/misctech/3678.html)）

### 1.3 实现方式三（本文采用的方式）

`使用openlayers6 的`postrender`机制生成，本文采用的这种`。像迁移图等，也是通过`postrender`机制去渲染，[openlayers](https://so.csdn.net/so/search?q=openlayers&spm=1001.2101.3001.7020) 的 内部机制肯定会比 使用overlay去批量生成的更加流畅。

## 2. 效果图

![请添加图片描述](https://img-blog.csdnimg.cn/876b6315811247d78b944ee516c49299.gif)

## 3. 核心代码

> 依靠`render` 机制实现点的闪烁效果，可以控制点的大小，闪烁速度，闪烁颜色等参数。

**分析**

- 遍历生成feature要素点
- 闪烁的动画播放。仍然要依靠render机制，这里我还是使用比较熟悉的postrender事件回调函数。

```js
let radius = 0;
pointLayer.on("postrender", (evt) => {
  if (radius >= 20) radius = 0;
  var opacity = (20 - radius) * (1 / 20); //不透明度
  var pointStyle = new Style({
    image: new Circle({
      radius: radius,
      stroke: new Stroke({
        color: "rgba(255,0,0" + opacity + ")",
        width: 3 - radius / 10, //设置宽度
      }),
    }),
  });
  // 获取矢量要素上下文
  let vectorContext = getVectorContext(evt);
  vectorContext.setStyle(pointStyle);
  pointFeature.forEach((feature) => {
    vectorContext.drawGeometry(feature.getGeometry());
  });
  radius = radius + 0.3; //调整闪烁速度
  //请求地图渲染（在下一个动画帧处）
  this.map.render();
});
```

## 4. 完整代码

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
import { Style, Circle, Stroke } from "ol/style";
import { Point } from "ol/geom";
import { defaults as defaultControls } from "ol/control";
import { fromLonLat } from "ol/proj";
import { getVectorContext } from "ol/render";

// 边界json数据
export default {
  data() {
    return {
      map: null,
      radius: 0,
    };
  },
  mounted() {
    this.initMap();
    const coordinates = [
      { x: "106.918082", y: "31.441314" }, //重庆
      { x: "86.36158200334317", y: "41.42448570787448" }, //新疆
      { x: "89.71757707811526", y: "31.02619817424643" }, //西藏
      { x: "116.31694544853109", y: "39.868508850821115" }, //北京
      { x: "103.07940932026341", y: "30.438580338450862" }, //成都
    ];
    this.addDynamicPoints(coordinates);
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
     * 批量添加闪烁点
     */
    addDynamicPoints(coordinates) {
      // 设置图层
      let pointLayer = new VectorLayer({ source: new VectorSource() });
      // 添加图层
      this.map.addLayer(pointLayer);
      // 循环添加feature
      let pointFeature = [];
      for (let i = 0; i < coordinates.length; i++) {
        // 创建feature，一个feature就是一个点坐标信息
        const feature = new Feature({
          geometry: new Point(fromLonLat([coordinates[i].x, coordinates[i].y])),
        });
        pointFeature.push(feature);
      }
      //把要素集合添加到图层
      pointLayer.getSource().addFeatures(pointFeature);
      // 关键的地方在此：监听postrender事件，在里面重新设置circle的样式
      let radius = 0;
      pointLayer.on("postrender", (evt) => {
        if (radius >= 20) radius = 0;
        var opacity = (20 - radius) * (1 / 20); //不透明度
        var pointStyle = new Style({
          image: new Circle({
            radius: radius,
            stroke: new Stroke({
              color: "rgba(255,0,0" + opacity + ")",
              width: 3 - radius / 10, //设置宽度
            }),
          }),
        });
        // 获取矢量要素上下文
        let vectorContext = getVectorContext(evt);
        vectorContext.setStyle(pointStyle);
        pointFeature.forEach((feature) => {
          vectorContext.drawGeometry(feature.getGeometry());
        });
        radius = radius + 0.3; //调整闪烁速度
        //请求地图渲染（在下一个动画帧处）
        this.map.render();
      });
    },
  },
};
</script>
<style lang="scss" scoped>
html,
body {
  height: 100%;
}
#app {
  min-height: calc(100vh - 50px);
  width: 100%;
  position: relative;
  overflow: none;
  #Map {
    height: 888px;
    min-height: calc(100vh - 50px);
  }
}
</style>
```