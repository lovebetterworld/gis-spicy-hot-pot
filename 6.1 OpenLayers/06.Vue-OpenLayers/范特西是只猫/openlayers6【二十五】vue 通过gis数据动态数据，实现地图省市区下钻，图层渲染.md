- [openlayers6【二十五】vue 通过gis数据动态数据，实现地图省市区下钻，图层渲染_范特西是只猫的博客-CSDN博客_gis动态数据](https://xiehao.blog.csdn.net/article/details/119250726)

![请添加图片描述](https://img-blog.csdnimg.cn/7752b723d6f54b48997b354f594bb213.gif)

## 1. 写在前面

结合上文 [openlayers6【二十四】vue 通过gis数据显示省的区域图层，地图下钻到可视中间区域效果](https://xiehao.blog.csdn.net/article/details/119243299) 进行广东省初始化页面加载一层(省)的数据，就可以继续做第二层(市)，第三层(区)及后面四层五层到街道的地图下钻操作。`csdn 限制了文件大小，只能随便录点gif图效果`

> 本文主要是[openlayers](https://so.csdn.net/so/search?q=openlayers&spm=1001.2101.3001.7020)最常用的场景，即地图下钻。可以结合很多其他热力图，聚合图及点位图进行很多的功能业务操作。主要效果如上图gif所示。

## 2. 实现逻辑

### 2.1 先获取广东省的区域，进行图层渲染到map上

加载广东省的时候 根据接口参数比如 `.1.` 是加载广东省的数据。拿到地图数据后 可以通过 [openlayers6【二十四】vue 通过gis数据显示省的区域图层，地图下钻到可视中间区域效果](https://xiehao.blog.csdn.net/article/details/119243299) 的方式，在地图上先进行渲染。渲染结果如下图所示
![在这里插入图片描述](https://img-blog.csdnimg.cn/704b32020f894bb3bc27250d65fca60d.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)
![在这里插入图片描述](https://img-blog.csdnimg.cn/929b724ba6294938bc2aba84b0188b6c.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)

### 2.2：就是通过点击地图的区域，拿去到地图下有哪些市及区，进行[遍历](https://so.csdn.net/so/search?q=遍历&spm=1001.2101.3001.7020)渲染市和区

这里肯定是多个市和区，比如点击广东省，下钻有很多市和区(深圳市，广州市，佛山市等等等。。。。) 然后通过遍历区渲染广东省的方法去渲染这些市就ok了。基本逻辑就是这样子，只是需要注意一些细节，比如重新渲染的时候需要把之前渲染的广东省的图层删除掉，否则就会出现图层重叠。

### 2.3 通过接口查询广东省下面有哪些市和区

![在这里插入图片描述](https://img-blog.csdnimg.cn/1fd8418675644b42a42d78ea5c00d85c.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)

### 2.4 然后通过遍历去生成图层添加到map里面

![在这里插入图片描述](https://img-blog.csdnimg.cn/0c8a488145184892ab6350ffe172d5b6.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)

### 2.5 每次添加图层之前把之前的图层先删除

> `new CreateArea` 是我自己封装的遍历添加图层的方法
> ![在这里插入图片描述](https://img-blog.csdnimg.cn/3b020e5e4c3149198620295de5873587.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)

## 3. map.vue

```js
<template>
  <div id="app">
    <div id="Map" ref="map"></div>
  </div>
</template>
<script>
import "ol/ol.css";
import TileLayer from "ol/layer/Tile";
import XYZ from "ol/source/XYZ";
import { Map, View } from "ol";
import { defaults as defaultControls } from "ol/control";
import { fromLonLat } from "ol/proj";
import CreateArea from "@/lib/CreateArea";
import { axiosRest } from "@/api/api.js";

export default {
  data() {
    return {
      map: null,
      areaLayer: null,
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
          new TileLayer(
            {
              source: new XYZ({
                url: "http://map.geoq.cn/ArcGIS/rest/services/ChinaOnlineStreetPurplishBlue/MapServer/tile/{z}/{y}/{x}",
              }),
            },
            { zoomOffset: 1 }
          ),
        ],
        view: new View({
          center: fromLonLat([108.522097, 37.272848]),
          zoom: 4.7,
          maxZoom: 19,
          minZoom: 4,
        }),
      });
    },
    async selectCode(obj = { citys: [".1."], name: "广东省" }) {
      if (this.areaLayer && this.areaLayer.getSource()) {
        this.areaLayer
          .getSource()
          .getFeatures()
          .forEach((feature) => {
            this.areaLayer.getSource().removeFeature(feature);
          });
        this.gatherFeature = [];
        this.map.removeLayer(this.areaLayer); //在移除图层
      }
      this.areaLayer = new CreateArea({
        selectedCallBack: this.selectCode,
        belongMap: this.map,
        citys: obj.citys,
        name: obj.name,
        optstyles: obj.optstyles,
      });
      this.map.addLayer(this.areaLayer);
    },
    mapClick() {
      this.map.on("click", (event) => {
        var pixel = this.map.getEventPixel(event.originalEvent);
        var feature = this.map.getFeaturesAtPixel(pixel);
        var layer = this.map.forEachFeatureAtPixel(
          event.pixel,
          function (feature, layer) {
            return layer;
          }
        );
        this.getOrgData(feature[0].get("code"));
      });
    },
    async getOrgData(code) {
      let result = await axiosRest(
        "/organization/list",
        {
          areaTypeCode: code,
        },
        "post"
      );
      if (result.ret == "200") {
        let citys = result.data.map((e) => {
          return e.orginternalcode;
        });
        setTimeout(() => {
          this.selectCode({
            citys: citys,
          });
        }, 100);
      }
    },
  },
  mounted() {
    this.initMap();
    this.selectCode({
      citys: [".1."],
      name: "广东省",
    });
    this.mapClick();
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

## 4. 核心代码：CreateArea.js

```js
import { Fill, Icon, Text, Stroke, Style } from 'ol/style';
import VectorLayer from 'ol/layer/Vector';
import VectorSource from 'ol/source/Vector';
import { axiosRest } from "../api/api.js";
import { Polygon, MultiPolygon } from 'ol/geom';
import Feature from 'ol/Feature';
import settings from './Setting.js';

class CreateArea extends VectorLayer {
  constructor(options) {
    super(options)
    this.setSource(new VectorSource());
    if (options)
    {
      console.log(options)
      this.map = options.belongMap;
      this.selectedCallBack = options.selectedCallBack;
      this.set("name", options.name);
    }
    this.Init(options.citys, options.optstyles, options.selectedCallBack, options.belongMap);
  }

  GetStyle (feature) {
    let optstyles = feature.get("optstyles");
    let color1 = Math.floor(Math.random() * 255);
    let color2 = Math.floor(Math.random() * 255);
    let color3 = Math.floor(Math.random() * 255);
    var opts = {
      fill: new Fill({ color: "#4e98f444" }), //区域填充颜色
      stroke: new Stroke({
        width: 3, //线的宽度
        color: [71, 137, 227, 1], //线的颜色
      }),
    };
    var textContent = feature.get("name") ? feature.get("name") : "";
    if (optstyles.hideText || (feature.get("selected"))) { textContent = "" }
    if (textContent)
    {
      opts.text = new Text({
        text: textContent,
        fill: new Fill({
          color: optstyles.textColor ? optstyles.textColor : '#fff'
        }),
        stroke: new Stroke({
          color: '#000',
          width: 0
        }),
      });
    }

    var style = new Style(opts);
    return style;
  }

  Init (citys, optstyles = [], callback, map) {
    var source = this.getSource();
    // console.log(source);
    source.clear(true);
    let i = 0;
    console.log(citys)
    if (citys)
    {
      citys.forEach((e) => {
        axiosRest(settings.MapCoords + e, {}, "get").then((res) => {
          if (res.code == '0')
          {
            let geometry = null;
            if (res.data.features[0].geometry.type == 'MultiPolygon')
            {
              geometry = new MultiPolygon(res.data.features[0].geometry.coordinates).transform(
                "EPSG:4326",
                "EPSG:3857"
              )
            } else if (res.data.features[0].geometry.type == 'Polygon')
            {
              geometry = new Polygon(res.data.features[0].geometry.coordinates).transform(
                "EPSG:4326",
                "EPSG:3857"
              )
            }
            let f = new Feature({
              geometry: geometry
            })
            f.set("level", res.data.features[0].properties.level);
            f.set("name", res.data.features[0].properties.name);
            f.set("center", [res.data.features[0].properties.center.lng, res.data.features[0].properties.center.lat]);
            f.set("optstyles", optstyles[i] ? optstyles[i] : {});
            f.set("code", e);
            f.set("type", "area");
            window.sessionStorage.setItem(e, res.data.features[0].properties.center.lng + ',' + res.data.features[0].properties.center.lat);
            console.log(res.data)
            if (citys.length == 1)
            {
              map
                .getView()
                .fit(geometry, { duration: 1500, padding: [100, 100, 100, 100] });
            }

            i++;
            source.addFeature(f);
          }
        })
      });
    }
    this.setStyle(this.GetStyle);
    source.refresh();
  }
}

export default CreateArea;
```