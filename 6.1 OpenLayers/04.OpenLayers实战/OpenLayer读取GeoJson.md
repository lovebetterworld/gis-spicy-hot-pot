- [openlayer中加载geojson的几种方式_~疆的博客-CSDN博客_openlayer 加载geojson](https://blog.csdn.net/qq_40323256/article/details/107817399)
- [openlayer中geojson要素图层设置style样式_~疆的博客-CSDN博客_geojson style](https://blog.csdn.net/qq_40323256/article/details/108237626)

## 1 自己写的demo代码

```
import { Vector as SourceVec } from 'ol/source'
import { Vector as LayerVec } from 'ol/layer'
import jiangsuJson from "@/assets/geojson/jiangsu.json";

import GeoJSON from "ol/format/GeoJSON";
```

```js
addJiangSuProvinceLayer(){
    let SourceVecLayer = null;
    SourceVecLayer = new SourceVec({
        features: (new GeoJSON()).readFeatures(jiangsuJson)
    });
    this.jiangsuLayer = new LayerVec({
        source: SourceVecLayer,
    })
    // 添加图层
    this.map.addLayer(this.jiangsuLayer);
},
```

## 2 其他参考内容

- [openlayer中加载geojson的几种方式_~疆的博客-CSDN博客_openlayer 加载geojson](https://blog.csdn.net/qq_40323256/article/details/107817399)

> 推荐使用openlayer5，不要使用openlayer6，否则不能使用矢量切片和new GeoJSON()

```bash
cnpm i -S ol@5.3.3
```

先贴一个经常需要导入的模块 

```bash
import "ol/ol.css";
import { Map, View, Overlay } from "ol";
import { TileWMS, OSM, Vector as VectorSource } from "ol/source";
import { Tile as TileLayer, Vector as VectorLayer } from "ol/layer";
import {altKeyOnly, click, pointerMove,platformModifierKeyOnly} from 'ol/events/condition';
import { Fill, Stroke, Style, Text , Circle, Icon} from "ol/style";
import { Select,DragBox } from "ol/interaction";
import { transform } from "ol/proj";
 
import {
  defaults as defaultControls,
  OverviewMap,
  FullScreen,
  ScaleLine,
  ZoomSlider,
  MousePosition,
  ZoomToExtent
} from "ol/control";
import GeoJSON from "ol/format/GeoJSON";
```

### 2.1 加载本地geojson文件

```js
new VectorSource({
    features:new GeoJSON().readFeatures(this.geojsonData)
})
```

或者：

```js
//推荐方式
import sichuan from "@/assets/sichuan.json";
 
source: new VectorSource({
   features: new GeoJSON().readFeatures(sichuan),
}),
```

public中的文件

注意：使用new GeoJSON()需要ol@5.3.3，而ol@6.1.1不能用

```js
new VectorSource({
    url: "sichuan_shp.json",
    format: new GeoJSON()
});
```

### 2.2 示例

```html
 
<template>
    <div id="map"></div>
</template>
 
<script>
import "ol/ol.css";
import { Map, View } from "ol";
import { OSM, Vector as VectorSource } from "ol/source";
import { Tile as TileLayer, Vector as VectorLayer } from "ol/layer";
import GeoJSON from "ol/format/GeoJSON";
 
export default {
  components: {},
  data() {
    return {
      map: {}
    };
  },
  created() {},
  mounted() {
    this.initMap();
  },
  computed: {},
  methods: {
    initMap() {
      var layers = [
        new TileLayer({
          source: new OSM()
        }),
        new VectorLayer({
          source: new VectorSource({
            url: "sichuan.json",
            format: new GeoJSON()
          })
        })
      ];
      this.map = new Map({
        layers: layers,
        target: "map",
        view: new View({
          projection: "EPSG:4326",
          center: [115, 39],
          zoom: 4
        })
      });
    }
  }
};
</script>
 
<style lang="scss" scoped>
  #map {
    height: 700px;
    width: 100%;
  }
</style>
```

**这里千万要注意： osm地图放在图层数组的第一个位置！！！否则其他图层会被遮住！！**

或者给图层设置**zIndex**属性

![img](https://img-blog.csdnimg.cn/20200825193050824.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQwMzIzMjU2,size_16,color_FFFFFF,t_70)

### 2.3 加载geoserver发布的geojson数据

