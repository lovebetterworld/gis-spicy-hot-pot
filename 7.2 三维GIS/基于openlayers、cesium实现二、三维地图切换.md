- [基于openlayers、cesium实现二、三维地图切换 - 掘金 (juejin.cn)](https://juejin.cn/post/6874426465060913166)

本文介绍如何在普通2d的gis项目里实现地图的二、三维切换。二维地图引擎市面上比较多，比较有代表性的像openlayers、leaflet等。三维地图目前比较流行的开源方案有cesium，它本身是基于webGL实现的地图引擎。

我之前写过一篇总结，是[基于vuecli2.0实现](https://link.juejin.cn/?target=https%3A%2F%2Fmp.weixin.qq.com%2Fs%2FDLnMMQqb8meMRXyKiUqUqA)的。按步骤一步步实现，问题不大。如果你是用vuecli3搭建的项目，这里有篇文章介绍[用vuecli3实现引用cesium](https://link.juejin.cn/?target=https%3A%2F%2Fmp.weixin.qq.com%2Fs%2F3Of_xKhUOxiwFhJoZ0U-Mg)。如果要实现二三维地图切换，难点是地图引擎的转换，有个插件已经帮忙实现了这个工作：ol-cesium。

### 场景需求

好了，我来捋捋场景，搞清楚需求：

1、openlayers加载地图

2、cesium加载三维地图

3、实现二、三维地图切换

4、在vue框架上实现以上功能

### 实现步骤

#### 一、用openlayers加载地图

此处略过，虽然简单，但是对于没有接触过gis的前端同学还是有入门门槛的。那既然是要实现以上需求，应该就是要做gis项目的人。既然是做gis项目的，那这个ol加载地图就不应该是难点，[官网有很多示例](https://link.juejin.cn/?target=https%3A%2F%2Fopenlayers.org%2F)，所以此处略过。

还是给一个示例代码：

```html
<template>
    <div id = "map"></div>
</template>
<script>
    import 'ol/ol.css';
    import Map from 'ol/Map';
    import OSM from 'ol/source/OSM';
    import TileLayer from 'ol/layer/Tile';
    import View from 'ol/View';


    var olmap = new Map({
        layers: [
            new TileLayer({
                source: new OSM(),
            }) ],
        target: 'map',
        view: new View({
            center: [0, 0],
            zoom: 2,
        }),
    });
</script>
```

#### 二、用cesium加载三维地图

cesium加载三维地图对于gis行业的同学来说也是个麻烦事，更别说要在vue框架上实现了。

以vuecli3为例，引用cesium其实只用几步：

##### 安装vue-cli-plugin-cesium插件

```
// npm
npm install --save-dev vue-cli-plugin-cesium

// yarn
yarn add vue-cli-plugin-cesium
```

##### 直接在vue组件中使用

安装好了就可以直接new出来用，因为它已经绑定了vue实例；

```html
<template>
	<div id= "cesiumContainer">
    </div>
</template>
<script>
export default {
      name: "",
      mounted(){
         var viewer = new Cesium.Viewer("cesiumContainer")
      }
    }
</script>
```

#### 三、实现二、三维地图切换

##### 安装olcs插件

这是一个用于实现openlayers与cesium切换的插件，详细文档移步[官网](https://link.juejin.cn/?target=https%3A%2F%2Fgithub.com%2Fopenlayers%2Fol-cesium)

```
npm i --save olcs
```

##### 实现二、三维切换

```
import OLCesium from 'olcs/OLCesium.js';
const ol3d = new OLCesium({map: ol2dMap}); // ol2dMap 是openlayers绑定的地图对象
ol3d.setEnabled(true);
```

需要注意的就是上面代码中的ol2dMap是openlayers绑定的地图对象，这个业内同学都懂。结合前面的ol示例，就是那个olmap对象。

#### 四、注意要点

如果有这样的需求：本来是二维地图有个矢量地图，比如一个什么专题图；然后切换到了三维地图，我仍然要能在三维地图上看到那个专题图。

现在切换到三维后，效果是有了，平面变三维地球，问题是之前的那个专题图也看不见了！ 原因就是**切换到三维后，二维地图被覆盖了。** 解决办法就是，切换到三维后，再用cesium引擎加载平面专题图；

##### cesium加载平面地图

```js
var ol3dLayers = ol3d.getCesiumScene().imageryLayers;
// eslint-disable-next-line no-undef
ol3dLayers.addImageryProvider(new Cesium.ArcGisMapServerImageryProvider({
    url: 'http://**************/arcgis/rest/services/**/******/MapServer'
}))
```

上面的示例地图是一个aricgis动态服务；

最后上图，来看下效果：

![640.gif](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/a02bb31978e944b4b2bb09394ce4150a~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

参考资料：

1. [blog.csdn.net/u010001043/…](https://link.juejin.cn?target=https%3A%2F%2Fblog.csdn.net%2Fu010001043%2Farticle%2Fdetails%2F74279380)
2. [cesium.com/docs/cesium…](https://link.juejin.cn?target=https%3A%2F%2Fcesium.com%2Fdocs%2Fcesiumjs-ref-doc%2FArcGisMapServerImageryProvider.html)
3. [mp.weixin.qq.com/s/3Of_xKhUO…](https://link.juejin.cn?target=https%3A%2F%2Fmp.weixin.qq.com%2Fs%2F3Of_xKhUOxiwFhJoZ0U-Mg)