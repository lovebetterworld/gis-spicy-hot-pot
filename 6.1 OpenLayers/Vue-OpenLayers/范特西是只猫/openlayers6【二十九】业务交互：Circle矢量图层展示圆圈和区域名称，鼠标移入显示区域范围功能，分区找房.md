- [openlayers6【二十九】业务交互：Circle矢量图层展示圆圈和区域名称，鼠标移入显示区域范围功能，分区找房_范特西是只猫的博客-CSDN博客](https://xiehao.blog.csdn.net/article/details/120888205)

## 1. 写在前面

最近在看房子，打算买房子，就看到某系统的这个功能，`按照区域选房`，比如上图为重庆市下面的所有区，默认显示的是区和该区域的房产有多少套。现在我们就来实现一下他。

![在这里插入图片描述](https://img-blog.csdnimg.cn/bd1a667dae5045ef8b84ba3c6c34e68e.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAQOW_heaEj-eOsg==,size_20,color_FFFFFF,t_70,g_se,x_16)

## 2. 实现思路

1. 以重庆市为列，需要显示下面的区的名称和圆圈的图层。
2. 鼠标悬浮到该地区的时候，需要默认渲染出来该区的管辖范围。
3. 下面是实现的效果
4. ![请添加图片描述](https://img-blog.csdnimg.cn/24781282d90148ca8555e00eed1f5059.gif)

## 3. 实现代码

首先需要获取`重庆市的地图数据源`，可以参考我之前的文章 [openlayers6【十七】vue VectorLayer矢量图层画地图省市区，多省市区(粤港澳大湾区)效果详解](https://blog.csdn.net/qq_36410795/article/details/107456645?spm=1001.2014.3001.5501) ，这里不做过多的阐述。

this.initMap(); //初始化加载地图

this.addCircle(); //初始化设置添加区域圆圈的图层

this.pointermove(); //初始化鼠标悬浮地图事件

### 3.1 初始化地图方法 initMap()

```js
// 这个很简单，不明白可以看之前的文章
initMap() {
  this.map = new Map({
    target: "Map",
    controls: defaultControls({
      zoom: true,
    }).extend([]),
    layers: [
      new TileLayer({
        source: new OSM(),
      }),
    ],
    view: new View({
      center: fromLonLat([106.523121, 29.547298]),//设置中心点
      zoom: 12,
      maxZoom: 14,
      minZoom: 12,
    }),
  });
},
```

### 3.2 加载圆圈和区域名称的图层 addCircle()

```js
import areaGeo from "@/geoJson/chongqing.json";

/**
 * 设置圆圈的图层circleLayer,设置圆圈的字体
 */
addCircle() {
  // 创建圆圈和名称的图层
  this.circleLayer = new VectorLayer({
    source: new VectorSource({
      features: [],
    }),
  });
  let features = areaGeo.features;
  // 遍历数据源，紧张图层上图
  features.forEach((g) => {
  	// g: 代表的是每个月区的数据
    let f = new Feature({
      geometry: new Circle(fromLonLat(g.properties.center), 1400),//设置中心点和圆的大小
    });
    f.set("coordinates", g.geometry.coordinates); //设置该区域的区域数据,等哈鼠标悬浮的时候使用
    f.setStyle(
      new Style({
        fill: new Fill({ color: "rgba(113, 175, 16, 0.7)" }),
        text: new Text({
          text: g.properties.name + Math.ceil(Math.random() * 10) + "万", // 添加文字描述
          font: "14px font-size", // 设置字体大小
          fill: new Fill({
            color: "#fff", // 设置字体颜色
          }),
        }),
        stroke: new Stroke({
          width: 2,
          color: [113, 175, 16],
        }),
      })
    );
    // 把每个要素添加到circleLayer图层
    this.circleLayer.getSource().addFeatures([f]);
  });
  // 把circleLayer图层添加到map
  this.map.addLayer(this.circleLayer);
},
```

### 3.3 鼠标移动到圆圈，展示该区域的范围

```js
// 监听鼠标移动到地图的方法
pointermove() {
  this.map.on("pointermove", (e) => {
    var pixel = this.map.getEventPixel(e.originalEvent);
    var feature = this.map.forEachFeatureAtPixel(pixel, (feature) => {
      return feature;
    });
    // feature 图层存在，设置区域数据，添加区域数据
    if (feature != null && typeof feature != "undefined") {
      let geoCoordinates = feature.get("coordinates");
      this.addArea(geoCoordinates);
    } else {
    // feature 图层不存在，移除删除区域数据
      this.map.removeLayer(this.areaLayer);
    }
  });
},

 /**
 * 鼠标悬浮到圆圈的图层显示该区域下的范围图层
 */
addArea(geoCoordinates) {
  if (!geoCoordinates) return;
  let areaFeature = null;
  if (this.areaLayer) this.map.removeLayer(this.areaLayer);
  // 设置图层
  this.areaLayer = new VectorLayer({
    source: new VectorSource({
      features: [],
    }),
  });
  // 添加图层
  this.map.addLayer(this.areaLayer);
  areaFeature = new Feature({
    geometry: new MultiPolygon(geoCoordinates).transform(
      "EPSG:4326",
      "EPSG:3857"
    ),
  });
  areaFeature.setStyle(
    new Style({
      fill: new Fill({ color: "#4e98f444" }),
      stroke: new Stroke({
        width: 2,
        color: [71, 137, 227, 1],
      }),
    })
  );
  this.areaLayer.getSource().addFeatures([areaFeature]);
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
import { Map, View, Feature } from "ol";
import { Style, Stroke, Fill, Text } from "ol/style";
import { MultiPolygon, Circle } from "ol/geom";
import { defaults as defaultControls } from "ol/control";
import { fromLonLat } from "ol/proj";
import OSM from "ol/source/OSM";
import areaGeo from "@/geoJson/chongqing.json";
export default {
  data() {
    return {
      map: null,
      circleLayer: null, //圆和文字的图层
      areaLayer: null, //区域图层
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
          zoom: true,
        }).extend([]),
        layers: [
          new TileLayer({
            source: new OSM(),
          }),
        ],
        view: new View({
          center: fromLonLat([106.523121, 29.547298]),
          zoom: 12,
          maxZoom: 14,
          minZoom: 12,
        }),
      });
    },
    /**
     * 设置圆圈的图层circleLayer,设置圆圈的字体
     */
    addCircle() {
      this.circleLayer = new VectorLayer({
        source: new VectorSource({
          features: [],
        }),
      });
      let features = areaGeo.features;
      features.forEach((g) => {
        let f = new Feature({
          geometry: new Circle(fromLonLat(g.properties.center), 1400),
        });
        f.set("coordinates", g.geometry.coordinates); //设置该区域的区域数据,等哈鼠标悬浮的时候使用
        f.setStyle(
          new Style({
            fill: new Fill({ color: "rgba(113, 175, 16, 0.7)" }),
            text: new Text({
              text: g.properties.name + Math.ceil(Math.random() * 10) + "万", // 添加文字描述
              font: "14px font-size", // 设置字体大小
              fill: new Fill({
                color: "#fff", // 设置字体颜色
              }),
            }),
            stroke: new Stroke({
              width: 2,
              color: [113, 175, 16],
            }),
          })
        );
        this.circleLayer.getSource().addFeatures([f]);
      });
      // 添加图层
      this.map.addLayer(this.circleLayer);
    },

    /**
     * 鼠标悬浮到圆圈的图层显示该区域下的范围图层
     */
    addArea(geoCoordinates) {
      if (!geoCoordinates) return;
      let areaFeature = null;
      if (this.areaLayer) this.map.removeLayer(this.areaLayer);
      // 设置图层
      this.areaLayer = new VectorLayer({
        source: new VectorSource({
          features: [],
        }),
      });
      // 添加图层
      this.map.addLayer(this.areaLayer);
      areaFeature = new Feature({
        geometry: new MultiPolygon(geoCoordinates).transform(
          "EPSG:4326",
          "EPSG:3857"
        ),
      });
      areaFeature.setStyle(
        new Style({
          fill: new Fill({ color: "#4e98f444" }),
          stroke: new Stroke({
            width: 2,
            color: [71, 137, 227, 1],
          }),
        })
      );
      this.areaLayer.getSource().addFeatures([areaFeature]);
    },
    // 监听地图移动的方法，
    pointermove() {
      this.map.on("pointermove", (e) => {
        var pixel = this.map.getEventPixel(e.originalEvent);
        var feature = this.map.forEachFeatureAtPixel(pixel, (feature) => {
          return feature;
        });
        // feature 图层存在，设置区域数据，添加区域数据
        if (feature != null && typeof feature != "undefined") {
          let geoCoordinates = feature.get("coordinates");
          this.addArea(geoCoordinates);
        } else {
        // feature 图层不存在，移除删除区域数据
          this.map.removeLayer(this.areaLayer);
        }
      });
    },
  },
  mounted() {
    this.initMap(); //初始化加载地图
    this.addCircle(); //初始化设置添加区域圆圈的图层
    this.pointermove(); //初始化鼠标悬浮地图事件
  },
};
</script>
<style lang="scss" scoped>
// 非主要代码，已删除
</style>
```