- [openlayers6【二十四】vue 通过gis数据显示省的区域图层，地图下钻到可视中间区域效果_范特西是只猫的博客-CSDN博客_openlayers6在vue中使用](https://xiehao.blog.csdn.net/article/details/119243299)

> 本文主要是下面一个简单初始化默认场景，即初始化页面时候，根据接口返回的数据，动态加载广东省的区域并且设置图层，默认下钻到屏幕的可视中间区域。如下面效果图。

![请添加图片描述](https://img-blog.csdnimg.cn/e117c8731ebf482fbba8be99e5338d82.gif)

## 1.写在前面

可以参考前面文章 [openlayers6【十七】vue VectorLayer矢量图层画地图省市区，多省市区(粤港澳大湾区)效果详解](https://xiehao.blog.csdn.net/article/details/107456645) 根据模拟的数据进行画区域，此文章主要是根据动态数据画区域，并且通过加载数据后，把可视区域动画效果放置屏幕中间。

如果觉得对你又帮助，麻烦喜欢的点个赞 👍 谢谢支持

## 2. 初始化地图initMap()方法

这个方法不做过多阐述，之前的文章都说了这个，不清楚的可以看前面的基础

```js
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
```

## 3. 通过接口请求数据，并且实现地图位于屏幕中心的效果展示

**首先在 mounted 里面直接调用了初始化地图方法和drawArea方法去加载画区域**

```js
mounted() {
  this.initMap();
  this.drawArea();
},
```

**drawArea() 方法，调用接口，返回数据后进行地图渲染操作**

```js
/*
* 根据返回的数据，进行地图的渲染
*/
async drawArea() {
  let geometry= await getGeometryByCode(".1.");//通过接口请求gis数据
  let areaFeature = new Feature({ geometry: geometry });//创建Feature要素，把数据添加到要素中
  areaFeature.setStyle(
    new Style({
      fill: new Fill({ color: "#4e98f444" }), //区域填充颜色
      stroke: new Stroke({
        width: 3, //线的宽度
        color: [71, 137, 227, 1], //线的颜色
      }),
    })
  );// 设置区域要素的样式
  this.areaLayer = new VectorLayer({
    source: new VectorSource({
      features: [areaFeature],
    }),
  }); //把Feature要素添加到矢量图层VectorLayer中
  this.map.addLayer(this.areaLayer); //把图层添加到map
  this.map
    .getView()
    .fit(geometry, { duration: 1500, padding: [100, 100, 100, 100] }); //设置把区域移动到可视屏幕中心，duration是多少毫秒，padding是距离屏幕上下左右的大小
},
```

**这个方法就是 使用openlayers把feature 移动到视图范围内**

```js
this.map
    .getView()
    .fit(geometry, { duration: 1500, padding: [100, 100, 100, 100] });
```

## 4. getGeometryByCode 方法

```bash
import { getGeometryByCode } from "@/lib/PolygonUtils";
```

**PolygonUtils.js 文件**

```js
import { Polygon, MultiPolygon } from 'ol/geom';
import { axiosRest } from "../api/api.js"; //自己封装的axios方法
export const getGeometryByCode = async (code) => {
  let url = `http://xxxxxxxx你自己的urlxxxxxx/web/appcloud/api/gis_data/sysGis2DLayer/getBusinessGeonJson?appKey=9ca95aea20204d8e92b9eec41258f128&orgcode=${code}`
  let res = await axiosRest(url, {}, "get");
  if (res.code == '0')
  {
    if (res.data.features[0].geometry.type == 'MultiPolygon')
    {
      console.log(res.data.features[0].geometry.coordinates)
      return new MultiPolygon(res.data.features[0].geometry.coordinates).transform(
        "EPSG:4326",
        "EPSG:3857"
      );
    } else if (res.data.features[0].geometry.type == 'Polygon')
    {
      console.log(res.data.features[0].geometry.coordinates)
      return new Polygon(res.data.features[0].geometry.coordinates).transform(
        "EPSG:4326",
        "EPSG:3857"
      );
    }
  }
  return null;
}
```

## 5. 接口返回[数据结构](https://so.csdn.net/so/search?q=数据结构&spm=1001.2101.3001.7020)

![在这里插入图片描述](https://img-blog.csdnimg.cn/30ecbc5ca37a4854af1acbc9a9a3b5e6.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)