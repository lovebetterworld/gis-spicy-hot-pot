- [Vue+Openlayers实现网络地图的加载与切换](https://blog.csdn.net/Oruizn/article/details/111130321)



## 前言

## 1、效果图

- 卫星地图

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201213164536175.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L09ydWl6bg==,size_16,color_FFFFFF,t_70#pic_center)

- Open Street Map

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201213164612263.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L09ydWl6bg==,size_16,color_FFFFFF,t_70#pic_center)

- 百度地图

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201213212348879.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L09ydWl6bg==,size_16,color_FFFFFF,t_70#pic_center)

- 百度自定义地图

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201213212416506.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L09ydWl6bg==,size_16,color_FFFFFF,t_70#pic_center)

## 2、实现步骤

步骤1：在main.js文件中添加Openlayers与Ol-ext的样式表；

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201213164207529.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L09ydWl6bg==,size_16,color_FFFFFF,t_70#pic_center)

步骤2：在components文件夹下

- 新建组件BaseMap.vue（用于绑定地图容器）
- 新建baselayer.js（用于管理底图）
- 新建controls.js（用于管理相关地图控件）

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201213172239164.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L09ydWl6bg==,size_16,color_FFFFFF,t_70#pic_center)

- baselayers.js

```js
import {Group as LayerGroup, Tile as TileLayer, Vector as VectorLayer} from "ol/layer"
import {OSM, Stamen, BingMaps, Vector as VectorSource} from "ol/source"
import {Style, Fill, Stroke, Circle} from "ol/style"

export default class Baselayers{
  //创建底图组
  static BaseLayersGroup(layers){
    return new LayerGroup({
        title: 'Base Layers',
      allwaysOnTop: true,
      openInLayerSwitcher: true,
      layers: layers
    });
  }
  //创建Open Street Map
  static OSMLayer(isBaseLayer, isVisible){
    return new TileLayer({
      title: 'OSM',
      baseLayer: isBaseLayer,
      source: new OSM(),
      visible: isVisible
    });
  }
  //https://www.bingmapsportal.com/Application，申请key的地址
  //创建Bing Map
  static BingMapLayer(layerName){
    let apiKey = '自己去申请一个key';
    return new TileLayer({
      preload: Infinity,
      baseLayer: true,
      title: upperCaseFirst.call(this, layerName),
      visible: true,
      source: new BingMaps({
        key: apiKey,
        imagerySet: layerName
      })
    });
  }
}
//Bing Map的类型
Baselayers.BingMapLayerTypes = {
  Road: 'Road',
  Aerial: 'Aerial',
  AerialWithLabels: 'AerialWithLabels',
  collinsBart: 'collinBart',
  ordnanceSurvey: 'ordnanceSurvey'
}

function upperCaseFirst(str){
  return str[0].toUpperCase() + str.substring(1);
}
```

- controls.js

```js
import {defaults} from 'ol/control'
import LayerSwitcher from 'ol-ext/control/LayerSwitcher'

/**
 * 地图控件
 */
export const controls = {
  // 地图图层切换
  switcher: new LayerSwitcher({
    show_progress: true,
    extent: true
  }),
  // 默认控件（）
  default: defaults() // 没有new
};
```

- BaseMap.vue

```js
<template>
  <div>
    <div id="map">
    </div>
  </div>
</template>

<script>
  import Baselayers from "@c/js/baselayers";//地图管理
  import {Map, View} from 'ol';//Openlayers的地图容器
  import {fromLonLat} from 'ol/proj';//经纬度转投影坐标
  import {controls} from "@c/js/controls";//地图交互控件

export default {
  name: "base-map",
  data(){
    return{

    }
  },
  components: {

  },
  methods: {

  },
  computed: {

  },
  mounted() {
    let bingMap = Baselayers.BingMapLayer(Baselayers.BingMapLayerTypes.AerialWithLabels);//卫星地图
    let osm = Baselayers.OSMLayer(true, false);//Open Street Map
    let baseLayerGroup = Baselayers.BaseLayersGroup([bingMap, osm]);//整合为一个地图组

    let centerPoint = fromLonLat([118.8, 32.0]);//南京的经纬度
    //设置定位的点及缩放等级
    let view = new View({
      center: centerPoint,
      zoom: 11
    });
    //配置地图容器
    new Map({
      target: 'map',
      layers: [baseLayerGroup],
      overlays: [],
      controls: [controls.switcher],
      loadTilesWhileInteracting: true,
      view: view
    });
  }
}
</script>

//设置地图为铺满全屏
<style lang="scss" scoped>
  #map {
    height: 100%;
    width: 100%;
    position: fixed;
  }
</style>
```

步骤3：在views文件下新建Index.vue（用于挂载BaseMap.vue组件）

```js
<template>
  <div class="'index">
    <base-map></base-map> 
  </div>
</template>
<script>
import BaseMap from "@c/BaseMap.vue";
export default {
  //用于展示例子
  name: "Index",
  data(){
    return{

    }
  },
  components: {
    BaseMap
  },
  methods: {

  }
}
</script>

<style lang="scss" scoped>

</style>
```

步骤4：在router文件夹下修改router/index.js，添加BaseMap.vue组件

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201213171228850.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L09ydWl6bg==,size_16,color_FFFFFF,t_70#pic_center)

步骤5：修改App.vue，添加router-view，用于实现页面导航

```js
<template>
  <div id="app">
    <router-view> </router-view>
  </div>
</template>

<style lang="scss">
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}
</style>
```

