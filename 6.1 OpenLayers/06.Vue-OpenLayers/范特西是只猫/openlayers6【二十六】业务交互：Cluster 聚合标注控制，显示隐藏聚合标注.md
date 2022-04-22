- [openlayers6【二十六】业务交互：Cluster 聚合标注控制，显示隐藏聚合标注_范特西是只猫的博客-CSDN博客_openlayers6 聚合](https://xiehao.blog.csdn.net/article/details/119946664)

## 1. 聚合标注常见业务需求交互

**`业务需求：在地图场景中，通常是多种业务场景（点位图标，边界图层，热力图层等）在地图上同时展示，但是为了用户体验及业务需求，通过可以人为去控制图层的显示，达到更佳的业务分析效果。工作中也是常见的需求之一。`**

> 比如在如下场景中，看上去会很乱，所有通常会控制标注的显示和隐藏达到更好的展示效果。

![[外链图片转存失败,源站可能有防盗链机制,建议将图片保存下来直接上传(img-JpoBnMzd-1630031716177)(https://img-blog.csdnimg.cn/6755a3b094ad4a8d9c13a8182c845c6a.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAQOW_heaEj-eOsg==,size_20,color_FFFFFF,t_70,g_se,x_16)]](https://img-blog.csdnimg.cn/d159d3c73d6b46888479eb538a0fcead.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAQOW_heaEj-eOsg==,size_20,color_FFFFFF,t_70,g_se,x_16)

**如果添加聚合标注添加详解可以看：** [openlayers6【二十】vue Cluster类实现聚合标注效果](https://xiehao.blog.csdn.net/article/details/107467701)

## 2. 实现效果

通过切换实现聚合标注在地图上显示和隐藏
![请添加图片描述](https://img-blog.csdnimg.cn/986757c6f29947678ba27ca1608b8c87.gif)

## 3. 核心代码

```html
<div class="radio">
	<el-radio-group v-model="radio" @change="change(radio)">
	  <el-radio :label="1">添加聚合标注</el-radio>
	  <el-radio :label="2">移除聚合标注</el-radio>
	</el-radio-group>
</div>
123456
//按钮切换控制图层
change() {
  this.radio == 1 ? this.addFeatures() : this.removeFeatures();
},
//添加聚合标注
addFeatures() {
  var currentFeatures = this.clusterSource.getSource().getFeatures();
  //如果聚合标注数据源中没有要素，则重新添加要素
  if (currentFeatures.length == 0) {
    this.addCluster(this.clusterData, this.points);
  } else {
    alert("要素已经存在");
  }
},
//移除聚合标注
removeFeatures() {
  this.clusterSource.getSource().clear(); //移除聚合标注数据源中的所有要素
  this.map.removeLayer(this.layer); //移除标注图层
},
```

## 4. 完整代码

```html
<template>
  <div id="app">
    <div id="Map" ref="map"></div>
    <div class="radio">
      <el-radio-group v-model="radio" @change="change(radio)">
        <el-radio :label="1">添加聚合标注</el-radio>
        <el-radio :label="2">移除聚合标注</el-radio>
      </el-radio-group>
    </div>
  </div>
</template>
<script>
import "ol/ol.css";
import TileLayer from "ol/layer/Tile";
import VectorLayer from "ol/layer/Vector";
import VectorSource from "ol/source/Vector";
import XYZ from "ol/source/XYZ";
import { Map, View, Feature } from "ol";
import { Style, Stroke, Fill, Text, Circle as CircleStyle } from "ol/style";
import { Point } from "ol/geom";
import { defaults as defaultControls } from "ol/control";
import { Cluster } from "ol/source";
import { fromLonLat } from "ol/proj";

export default {
  data() {
    return {
      radio: 1,
      map: null,
      layer: null,
      clusterSource: null,
      feature: null,
      clusterData: {
        成都市: { center: { lng: 104.061902, lat: 30.609503 } },
        广安市: { center: { lng: 106.619126, lat: 30.474142 } },
        绵阳市: { center: { lng: 104.673612, lat: 31.492565 } },
        雅安市: { center: { lng: 103.031653, lat: 30.018895 } },
        自贡市: { center: { lng: 104.797794, lat: 29.368322 } },
        宜宾市: { center: { lng: 104.610964, lat: 28.781347 } },
        内江市: { center: { lng: 105.064555, lat: 29.581632 } },
      },
      points: [
        { name: "成都市", value: 85 },
        { name: "绵阳市", value: 36 },
        { name: "广安市", value: 50 },
        { name: "雅安市", value: 555 },
        { name: "自贡市", value: 55 },
        { name: "宜宾市", value: 666 },
        { name: "内江市", value: 777 },
      ],
    };
  },
  methods: {
    //按钮切换控制图层
    change() {
      this.radio == 1 ? this.addFeatures() : this.removeFeatures();
    },
    //添加聚合标注
    addFeatures() {
      var currentFeatures = this.clusterSource.getSource().getFeatures();
      //如果聚合标注数据源中没有要素，则重新添加要素
      if (currentFeatures.length == 0) {
        this.addCluster(this.clusterData, this.points);
      } else {
        alert("要素已经存在");
      }
    },
    //移除聚合标注
    removeFeatures() {
      this.clusterSource.getSource().clear(); //移除聚合标注数据源中的所有要素
      this.map.removeLayer(this.layer); //移除标注图层
    },
    //初始化地图
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
          center: fromLonLat([104.065735, 30.659462]),
          zoom: 6.5,
          maxZoom: 19,
          minZoom: 3,
        }),
      });
    },
    addCluster(clusterData, points) {
      let source = new VectorSource();
      this.clusterSource = new Cluster({
        distance: parseInt(20, 10),
        source: source,
      });
      this.layer = new VectorLayer({
        source: this.clusterSource,
        style: this.clusterStyle.call(this),
      });
      this.map.addLayer(this.layer);
      for (const key in clusterData) {
        points.forEach((e) => {
          if (e.name == key) {
            let point = fromLonLat([
              clusterData[key].center.lng,
              clusterData[key].center.lat,
            ]);
            this.feature = new Feature({
              geometry: new Point(point),
            });
            this.feature.set("name", e.name);
            this.feature.set("value", e.value);
            source.addFeature(this.feature);
          }
        });
      }
    },
    //设置聚合样式
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
              color: "blue",
            }),
            fill: new Fill({
              color: "rgba(24,144,255,100)",
            }),
          }),
          text: new Text({
            text: total.toString(),
            fill: new Fill({
              color: "#FFF",
            }),
            font: "12px Calibri,sans-serif",
            stroke: new Stroke({
              color: "red",
              width: 5,
            }),
          }),
        });
        return style;
      };
    },
    /**
     * 鼠标悬浮改变图标样式
     */
    pointerMove() {
      this.map.on("pointermove", (evt) => {
        var hit = this.map.hasFeatureAtPixel(evt.pixel);
        this.map.getTargetElement().style.cursor = hit ? "pointer" : "";
      });
    },
  },
  mounted() {
    //初始化地图
    this.initMap();
    //添加鼠标移入事件
    this.pointerMove();
    //添加聚合效果
    this.addCluster(this.clusterData, this.points);
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
  .radio {
    position: absolute;
    top: 20px;
    left: 50px;
  }
  .el-radio {
    color: #fff;
  }
}
</style>
```