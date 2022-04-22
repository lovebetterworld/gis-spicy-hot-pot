- [openlayers6【二十三】vue LineString 实现地图轨迹路线，设置起点和终点的标注信息详解_范特西是只猫的博客-CSDN博客](https://xiehao.blog.csdn.net/article/details/119205448)

## 1.写在前面

本文主要是下面一个简单切经典的需求场景，在地图上根据轨迹的经纬度数据，通过[openlayers](https://so.csdn.net/so/search?q=openlayers&spm=1001.2101.3001.7020)的`LineString` 方法创建一条线，并且设置起点和终点的标注信息。下面是效果图。

![在这里插入图片描述](https://img-blog.csdnimg.cn/ccf6ba02196747f5b4902309cfc547f6.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)

## 2. 创建轨迹线段，设置起点和终点位置和样式代码

```js
addTrack() {
  // 根据经纬度点位创建线
  var routeFeature = new Feature({
    type: "route",
    geometry: new LineString(trackCar).transform("EPSG:4326", "EPSG:3857"),
  });
  // 创建开始图标
  const startMarker = new Feature({
    type: "startMarker",
    geometry: new Point(trackCar[0]).transform("EPSG:4326", "EPSG:3857"),
  });
  // 创建结束图标
  const endMarker = new Feature({
    type: "endMarker",
    geometry: new Point(trackCar[trackCar.length - 1]).transform(
      "EPSG:4326",
      "EPSG:3857"
    ),
  });
  // 设置样式
  var styles = {
    // 如果类型是 route 的样式
    route: new Style({
      stroke: new Stroke({
        width: 2, //线的宽度
        color: "#ffc641", //线的颜色
      }),
    }),
    // 如果类型是 geoMarker 的样式
    startMarker: new Style({
      image: new Icon({
        src: require("../../assets/images/start.png"),
        anchor: [0.5, 1.1], // 设置偏移
      }),
    }),
    endMarker: new Style({
      image: new Icon({
        src: require("../../assets/images/end.png"),
        anchor: [0.5, 1.1], // 设置偏移
      }),
    }),
  };
  // 把小车和线添加到图层
  this.vectorLayer = new VectorLayer({
    source: new VectorSource({
      features: [routeFeature, startMarker, endMarker],
    }), //线,起点的图标,终点的图标
    style: function (feature) {
      return styles[feature.get("type")];
    },
  });
},
```

## 3. 完整代码

```html
<template>
  <div id="content">
    <div id="map" ref="map" />
  </div>
</template>

<script>
import "ol/ol.css";
import { Map, Feature } from "ol";
import TileLayer from "ol/layer/Tile";
import VectorLayer from "ol/layer/Vector";
import VectorSource from "ol/source/Vector";
import { Style, Stroke, Icon } from "ol/style";
import { LineString, Point, Polygon } from "ol/geom";
import XYZ from "ol/source/XYZ";
// 一段经纬度数据
import trackCar from "./track-car.json";
export default {
  data() {
    return {
      map: null,
      vectorLayer: null,
    };
  },
  mounted() {
    this.addTrack(); //创建
    this.initMap(); //初始化地图
  },
  methods: {
    addTrack() {
      // 根据经纬度点位创建线
      var routeFeature = new Feature({
        type: "route",
        geometry: new LineString(trackCar).transform("EPSG:4326", "EPSG:3857"),
      });
      // 创建开始图标
      const startMarker = new Feature({
        type: "startMarker",
        geometry: new Point(trackCar[0]).transform("EPSG:4326", "EPSG:3857"),
      });
      // 创建结束图标
      const endMarker = new Feature({
        type: "endMarker",
        geometry: new Point(trackCar[trackCar.length - 1]).transform(
          "EPSG:4326",
          "EPSG:3857"
        ),
      });
      // 设置样式
      var styles = {
        // 如果类型是 route 的样式
        route: new Style({
          stroke: new Stroke({
            width: 2, //线的宽度
            color: "#ffc641", //线的颜色
          }),
        }),
        // 如果类型是 geoMarker 的样式
        startMarker: new Style({
          image: new Icon({
            src: require("../../assets/images/start.png"),
            anchor: [0.5, 1.1], // 设置偏移
          }),
        }),
        endMarker: new Style({
          image: new Icon({
            src: require("../../assets/images/end.png"),
            anchor: [0.5, 1.1], // 设置偏移
          }),
        }),
      };
      // 把小车和线添加到图层
      this.vectorLayer = new VectorLayer({
        source: new VectorSource({
          features: [routeFeature, startMarker, endMarker],
        }), //线,起点的图标,终点的图标
        style: function (feature) {
          return styles[feature.get("type")];
        },
      });
    },
    /**
     * 初始化一个 openlayers 地图
     */
    initMap() {
      const target = "map"; // 跟页面元素的 id 绑定来进行渲染
      const tileLayer = [
        new TileLayer({
          source: new XYZ({
            url: "http://map.geoq.cn/ArcGIS/rest/services/ChinaOnlineStreetPurplishBlue/MapServer/tile/{z}/{y}/{x}",
          }),
          projection: "EPSG:3857",
        }),
        this.vectorLayer, //把线,起点,终点的图标加载到图层
      ];
      this.map = new Map({
        target: target, // 绑定dom元素进行渲染
        layers: tileLayer, // 配置地图数据源
      });
      this.map
        .getView()
        .fit(new Polygon([trackCar]).transform("EPSG:4326", "EPSG:3857"), {
          padding: [100, 100, 100, 100],
        }); //设置地图的缩放距离离屏幕的大小
    },
  },
};
</script>
<style lang="scss" scoped>
// 此处非核心内容，已删除
</style>
```

## 4. track-car.json 轨迹JSON数据

这是我的模拟数据，实际数据根据你们业务需求返回的数据进行获取渲染。

```bash
import trackCar from "./track-car.json";
1
[
    [
        120.97202539443971,
        29.149083495140076
    ],
    [
        120.97365617752077,
        29.147656559944153
    ],
    [
        120.97478270530702,
        29.146594405174255
    ],
    [
        120.97543716430665,
        29.14593994617462
    ],
    [
        120.97596287727357,
        29.145285487174988
    ],
    [
        120.9764349460602,
        29.144577383995056
    ],
    [
        120.97669243812561,
        29.14408653974533
    ],
    [
        120.97699284553528,
        29.143426716327667
    ],
    [
        120.97723960876465,
        29.142654240131378
    ],
    [
        120.97735226154329,
        29.142230451107025
    ],
    [
        120.97756683826448,
        29.141243398189545
    ],
    [
        120.97781896591188,
        29.140020310878754
    ],
    [
        120.97790479660036,
        29.139483869075775
    ],
    [
        120.97804427146912,
        29.138880372047424
    ],
    [
        120.97839832305908,
        29.137893319129944
    ],
    [
        120.97876310348511,
        29.137163758277893
    ],
    [
        120.97941756248474,
        29.13626253604889
    ],
    [
        120.9810483455658,
        29.134342074394226
    ],
    [
        120.9818959236145,
        29.133376479148865
    ],
    [
        120.98270595073701,
        29.132418930530548
    ],
    [
        120.98334968090059,
        29.131678640842438
    ],
    [
        120.98402559757234,
        29.130959808826447
    ],
    [
        120.98470687866212,
        29.13033217191696
    ],
    [
        120.985227227211,
        29.12989765405655
    ],
    [
        120.9860908985138,
        29.129264652729034
    ],
    [
        120.98707258701324,
        29.12864774465561
    ],
    [
        120.9880542755127,
        29.12812203168869
    ],
    [
        120.98936319351196,
        29.127537310123444
    ],
    [
        120.99144458770752,
        29.126807749271393
    ],
    [
        120.99297881126404,
        29.126287400722504
    ],
    [
        120.99447548389435,
        29.125772416591644
    ],
    [
        120.99569857120514,
        29.125321805477142
    ],
    [
        120.99704504013062,
        29.124737083911896
    ],
    [
        120.99830567836761,
        29.12410408258438
    ],
    [
        120.99883675575256,
        29.123830497264862
    ],
    [
        120.99963068962097,
        29.1233691573143
    ],
    [
        121.00059628486633,
        29.122741520404816
    ],
    [
        121.00166380405426,
        29.122038781642914
    ],
    [
        121.00329995155334,
        29.120981991291046
    ],
    [
        121.00475907325745,
        29.120016396045685
    ],
    [
        121.00560128688812,
        29.119447767734528
    ],
    [
        121.00612163543701,
        29.11910980939865
    ],
    [
        121.0070389509201,
        29.11860018968582
    ],
    [
        121.00769877433777,
        29.118267595767975
    ],
    [
        121.00861608982086,
        29.1178759932518
    ],
    [
        121.00979626178741,
        29.117489755153656
    ],
    [
        121.01091742515564,
        29.117216169834137
    ],
    [
        121.01166307926178,
        29.117071330547336
    ],
    [
        121.01268768310547,
        29.116931855678562
    ],
    [
        121.0139536857605,
        29.116878211498264
    ],
    [
        121.01507484912872,
        29.116931855678562
    ],
    [
        121.01689338684082,
        29.117071330547336
    ],
    [
        121.01934492588043,
        29.117291271686558
    ],
    [
        121.02029979228975,
        29.117350280284885
    ],
    [
        121.02101325988771,
        29.117339551448826
    ],
    [
        121.02191984653474,
        29.117242991924286
    ],
    [
        121.02294981479646,
        29.117001593112946
    ],
    [
        121.02402269840242,
        29.116583168506622
    ],
    [
        121.02478981018068,
        29.1161647439003
    ],
    [
        121.0260719060898,
        29.115327894687653
    ]
]
```