- [【三维GIS可视化】基于Vue+Cesium+Supermap实现智慧城市（一）](https://juejin.cn/post/6953968499089735711)
- [【三维GIS可视化】基于Vue+Cesium+Supermap实现智慧城市（二）](https://juejin.cn/post/6955011037070360589)
- [【三维GIS可视化】基于Vue+Cesium+Supermap实现智慧城市（三）](https://juejin.cn/post/6958708504618237960)
- [【三维GIS可视化】基于Vue+Cesium+Supermap实现智慧城市（四）](https://juejin.cn/post/6965347246061649934)
- [【三维GIS可视化】基于Vue+Cesium+Supermap实现智慧城市（五）](https://juejin.cn/post/6969369288247361572)



### 前言

接下来会有部分篇幅用来介绍地图元素以及坐标系及其转换相关知识，仅作了解。不想看的就直接跳到Viewer相关配置，直接进行实际操作。

### 地图元素

------

#### 要素

我们首先来看看百度地图上大概都有哪些元素（这里我以路线查询作为例子）

![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/ba13746420fa42f7bfff16a7528c1d24~tplv-k3u1fbpfcp-watermark.image)

首先,地图中最重要的，也是最基本的就是底图，底图负责将地理的基本信息展现在视区中，没有底图，堆多少要素都是无用的。接下来是路线的起点和终点，对应地图中的**点要素Point**，两点之间的路线对应地图中的**线要素LineString**。最后就是右下角的面数据了（是不是格格不入，因为是我自己画的哈哈哈），对应地图中的**面要素Polygon**。而我们的项目中，基本上的信息展示就是由点线面三类要素构成。

### 坐标系

------

只要涉及到地图开发，无论如何关于坐标系的概念是逃不掉的，谁让地球它是个球呢🌏（如果向欧文说的地球是方的那就好了）。

> 想象中的地球vs实际的地球

![想象中的地球vs实际的地球](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/a49e3ec28ff04edd8a80c842fd58178e~tplv-k3u1fbpfcp-watermark.image)

#### 常用坐标系

这里就不列举国内常用的坐标系及转换方法，大家可以自行百度。关于投影坐标系统和地理坐标系统，可以阅读这两篇文章加以了解。我们主要介绍Cesium中的常用坐标系以及对应的转换方式。

[地理坐标系统](https://juejin.cn/post/6930539078488326152#heading-17)

[投影坐标系统](https://juejin.cn/post/6940684126282317861)

#### Cesium中的坐标系

Cesium中常用的坐标有两种：WGS84坐标和笛卡尔空间坐标，我们平时以经纬度来指向一个地点用的就是WGS84坐标，笛卡尔空间坐标则常用来做一些空间位置的变换，如平移、缩放等。二者关系如下图：

![124613_sr4k_1585572.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b626f08dc4824c58b1b7e1735f5f6e82~tplv-k3u1fbpfcp-watermark.image)

WGS84坐标系中包括WGS84经纬度坐标系和WGS84弧度坐标系（`Cartographic`）。

笛卡尔空间坐标系包括笛卡尔空间直角坐标系（`Cartesian3`）、平面坐标系（`Cartesian2`）和4D笛卡尔坐标系（`Cartesian4`）。

##### WGS84坐标系

World Geodetic System 1984，是为GPS全球定位系统使用而建立的坐标系统，坐标原点为地球质心，其地心空间直角坐标系的Z轴指向BIH （国际时间服务机构）1984.O定义的协议地球极（CTP)方向，X轴指向BIH 1984.0的零子午面和CTP赤道的交点，Y轴与Z轴、X轴垂直构成右手坐标系。我们平常手机上的指南针显示的经纬度就是这个坐标系下当前的坐标，进度范围[-180，180],纬度范围[-90，90]。

Cesium目前支持两种坐标系WGS84和WebMercator，但是在Cesium中没有实际的对象来描述WGS84坐标，都是以弧度的方式来进行运用的也就是Cartographic类：

new Cesium.Cartographic(longitude, latitude, height)，这里的参数也叫longitude、latitude，就是经度和纬度，计算方法：弧度= π/180×经纬度角度。

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/2a38ef2fd24245698bdf3ff1dd0a2f6e~tplv-k3u1fbpfcp-watermark.image)

##### 笛卡尔空间直角坐标系（`Cartesian3`）

笛卡尔空间坐标的原点就是椭球的中心，我们在计算机上进行绘图时，不方便使用经纬度直接进行绘图，一般会将坐标系转换为笛卡尔坐标系，使用计算机图形学中的知识进行绘图。这里的Cartesian3，有点类似于三维系统中的Point3D对象，new Cesium.Cartesian3(x, y, z)，里面三个分量x、y、z。

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/2f9e213692d04770929c86349456dda9~tplv-k3u1fbpfcp-watermark.image)

##### 平面坐标系（`Cartesian2`）

平面坐标系也就是平面直角坐标系，是一个二维笛卡尔坐标系，与Cartesian3相比少了一个z的分量，new Cesium.Cartesian2(x, y)。Cartesian2经常用来描述屏幕坐标系，比如鼠标在电脑屏幕上的点击位置，返回的就是Cartesian2，返回了鼠标点击位置的xy像素点分量。

![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/18ddfe6f0c8048ffa51fa2a02538da09~tplv-k3u1fbpfcp-watermark.image)

#### 坐标系转换

##### 经纬度和弧度的转换

```js
var radians=Cesium.Math.toRadians（degrees）;//经纬度转弧度
var degrees=Cesium.Math.toDegrees（radians）;//弧度转经纬度
复制代码
```

##### WGS84经纬度坐标和WGS84弧度坐标系（`Cartographic`）的转换

```js
//方法一：
var longitude = Cesium.Math.toRadians(longitude1); //其中 longitude1为角度
var latitude= Cesium.Math.toRadians(latitude1); //其中 latitude1为角度
var cartographic = new Cesium.Cartographic(longitude, latitude, height)；

//方法二：
var cartographic= Cesium.Cartographic.fromDegrees(longitude, latitude, height);//其中，longitude和latitude为角度

//方法三：
var cartographic= Cesium.Cartographic.fromRadians(longitude, latitude, height);//其中，longitude和latitude为弧度
复制代码
```

##### WGS84坐标系和笛卡尔空间直角坐标系（`Cartesian3`）的转换

```js
var position = Cesium.Cartesian3.fromDegrees(longitude, latitude, height)；//其中，高度默认值为0，可以不用填写；longitude和latitude为角度

var positions = Cesium.Cartesian3.fromDegreesArray(coordinates);//其中，coordinates格式为不带高度的数组。例如：[-115.0, 37.0, -107.0, 33.0]

var positions = Cesium.Cartesian3.fromDegreesArrayHeights(coordinates);//coordinates格式为带有高度的数组。例如：[-115.0, 37.0, 100000.0, -107.0, 33.0, 150000.0]

//同理，通过弧度转换，用法相同，具体有Cesium.Cartesian3.fromRadians，Cesium.Cartesian3.fromRadiansArray，Cesium.Cartesian3.fromRadiansArrayHeights等方法
复制代码
```

##### 笛卡尔空间直角坐标系转换WGS84

```js
var cartographic= Cesium.Cartographic.fromCartesian(cartesian3)；
复制代码
```

##### 平面坐标系（`Cartesian2`）和笛卡尔空间直角坐标系（`Cartesian3`）的转换

平面坐标系转笛卡尔空间直角坐标系

这里注意的是当前的点(Cartesian2)必须在三维球上，否则返回的是undefined；通过ScreenSpaceEventHandler回调会取到的坐标都是Cartesian2。

屏幕坐标转场景坐标-获取倾斜摄影或模型点击处的坐标 这里的场景坐标是包含了地形、倾斜摄影表面、模型的坐标。

通过viewer.scene.pickPosition(movement.position)获取，根据窗口坐标，从场景的深度缓冲区中拾取相应的位置，返回笛卡尔坐标。

```js
var handler = new Cesium.ScreenSpaceEventHandler(viewer.scene.canvas);
handler.setInputAction(function (movement) {
     var position = viewer.scene.pickPosition(movement.position);
     console.log(position);
}, Cesium.ScreenSpaceEventType.LEFT_CLICK);
复制代码
```

注：若屏幕坐标处没有倾斜摄影表面、模型时，获取的笛卡尔坐标不准，此时要开启地形深度检测（`viewer.scene.globe.depthTestAgainstTerrain = true`; //默认为false）。

屏幕坐标转地表坐标-获取加载地形后对应的经纬度和高程 这里是地球表面的世界坐标，包含地形，不包括模型、倾斜摄影表面。

通过`viewer.scene.globe.pick(ray, scene)`获取，其中`ray=viewer.camera.getPickRay(movement.position)`。

```js
var handler = new Cesium.ScreenSpaceEventHandler(viewer.scene.canvas);
handler.setInputAction(function (movement) {
     var ray = viewer.camera.getPickRay(movement.position);
     var position = viewer.scene.globe.pick(ray, viewer.scene);
     console.log(position);
}, Cesium.ScreenSpaceEventType.LEFT_CLICK);
复制代码
```

注：通过测试，此处得到的坐标通过转换成wgs84后，height的为该点的地形高程值。

屏幕坐标转椭球面坐标-获取鼠标点的对应椭球面位置 这里的椭球面坐标是参考椭球的WGS84坐标(Ellipsoid.WGS84)，不包含地形、模型、倾斜摄影表面。

通过 `viewer.scene.camera.pickEllipsoid(movement.position, ellipsoid)`获取，可以获取当前点击视线与椭球面相交处的坐标，其中ellipsoid是当前地球使用的椭球对象：`viewer.scene.globe.ellipsoid`，默认为Ellipsoid.WGS84。

```js
var handler = new Cesium.ScreenSpaceEventHandler(viewer.scene.canvas);
handler.setInputAction(function (movement) {
     var position = viewer.scene.camera.pickEllipsoid(movement.position, viewer.scene.globe.ellipsoid);
     console.log(position);
}, Cesium.ScreenSpaceEventType.LEFT_CLICK);
复制代码
```

注：通过测试，此处得到的坐标通过转换成wgs84后，height的为0(此值应该为地表坐标减去地形的高程)。

### Viewer相关配置项

------

我们在第一篇文章中成功生成了三维球体，但是细心的朋友会发现我们`Viewer`的配置项是一个空对象，接下来我就将基本配置罗列出来，朋友们可根据需要自行添加到自己的`Viewer`配置中

> 这里的配置对应的是超图二次封装过的Viewer,所以有些默认配置可能与原始Ceiusm默认配置不同，原始的配置项可参照[这篇博客](https://blog.csdn.net/shenwuyuexy/article/details/108262789)

| 名称                               | 类型                        | 默认                                       | 描述                                                         |
| ---------------------------------- | --------------------------- | ------------------------------------------ | ------------------------------------------------------------ |
| clock                              | `Clock`                     | `new Clock()`                              | 控制当前时间的时钟                                           |
| selectedImageryProviderViewModel   | `ProviderViewModel`         |                                            | 当前基础图像图层的视图模型，如若未提供，则使用第一个可用基础图层。此值仅在 options.baseLayerPicker 设置为true时有效。 |
| imageryProviderViewModels          | Array.`<ProviderViewModel>` | `createDefaultImageryProviderViewModels()` | ProviderViewModels数组可从BaseLayerPicker中选择。此值仅在 options.baseLayerPicker 设置为true时有效。 |
| selectedTerrainProviderViewModel   | `ProviderViewModel`         |                                            | 当前基础地形图层的视图模型，如若未提供，则使用第一个可用基础图层。此值仅在 options.baseLayerPicker 设置为true时有效。 |
| terrainProviderViewModels          | Array.`<ProviderViewModel>` | `createDefaultTerrainProviderViewModels()` | ProviderViewModels数组可从BaseLayerPicker中选择。此值仅在 options.baseLayerPicker 设置为true时有效。 |
| imageryProvider                    | `ImageryProvider`           | `new BingMapsImageryProvider()`            | 使用的影像提供者。此值仅在 options.baseLayerPicker 设置为 false 时有效。 |
| terrainProvider                    | `TerrainProvider`           | `new EllipsoidTerrainProvider()`           | 使用的地形提供者。                                           |
| skyBox                             | `SkyBox`                    |                                            | 用于渲染星辰的天空盒，未定义时，使用默认星辰效果。           |
| skyAtmosphere                      | `SkyAtmosphere`             |                                            | 环绕地球边缘的蓝天和光晕效果，设置为false可将其关闭。        |
| useDefaultRenderLoop               | `Boolean`                   | `true`                                     | 如果此部件能够控制渲染循环，设置为true，反之设置为false。    |
| targetFrameRate                    | `Number`                    |                                            | 使用默认渲染循环时的目标帧速率。                             |
| showRenderLoopErrors               | `Boolean`                   | `true`                                     | 如果设置为true，发生渲染循环错误时，将自动给用户显示一个包含错误信息的HTML面板。 |
| automaticallyTrackDataSourceClocks | `Boolean`                   | `true`                                     | 如果设置为true，将自动跟踪新添加数据源的时钟设置，如果数据源的时钟变更，则更新。如需单独设置时钟，请将此项设置为false。 |
| contextOptions                     | `Object`                    |                                            | Context and WebGL 创建属性与传递给Scene匹配的选项。增加硬件反走样功能，反走样系数msaalevel使用1到8的整数值，默认是1，值越大反走样效果越好（因为用到了WebGL2.0的特性，所以requestWebgl2参数设置为true。因为WebGL2.0还存在一下缺陷，所以需要先把OIT,FXAA,HDR关掉） |
| mapProjection                      | `MapProjection`             | `new GeographicProjection()	`           | 在二维和Columbus视图模式下所使用的地图投影。                 |
|                                    |                             |                                            |                                                              |
| globe                              | `Globe`                     | `new Globe(mapProjection.ellipsoid)	`   | 场景中的地球，如果此项设置为false，将不添加球体对象。        |
| orderIndependentTranslucency       | `Boolean`                   | `true`                                     | 如果此项设置为true，并且使用设备支持，将使用与顺序无关的半透明。 |
| creditContainer                    | `Element` \ `String`        |                                            | 指定包含CreditDisplay信息的DOM元素或ID。如若未指定，credit信息将添加到部件底部。 |
| dataSources                        | `DataSourceCollection`      | `new DataSourceCollection()`               | 指定由viewer部件可视化的数据源集合。如果提供此参数，实例由调用者拥有，并且viewer被销毁时此实例不被销毁。 |
|                                    |                             |                                            |                                                              |
| terrainExaggeration                | `Number`                    | `1.0`                                      | 用于夸大地形的标量。请注意，设置地形夸张不会修改其它任何数据。 |
|                                    |                             |                                            |                                                              |
| shadows                            | `Boolean`                   | `false`                                    | 确定阴影是否由太阳投射形成。                                 |
|                                    |                             |                                            |                                                              |
| terrainShadows                     | `ShadowMode`                | `ShadowMode.RECEIVE_ONLY`                  | 确定地形是否投射或接受来自太阳的阴影。                       |
|                                    |                             |                                            |                                                              |
| mapMode2D                          | `MapMode2D`                 | `MapMode2D.INFINITE_SCROLL`                | 确定二维地图是可旋转的或是可以在在水平方向上无限滚动。       |
|                                    |                             |                                            |                                                              |
| navigation                         | `Boolean`                   | `false`                                    | 是否显示导航罗盘控件。如需显示，需在初始化viewer时此项设置为true。 |

### 添加图层（`Adding Imagery`）

------

`Imagery`不用说，在Cesium项目中一定是关键元素，瓦片图集合根据不同投影方式映射到三维地球表面，通过相机指向地表的方向距离，Cesium会自动请求不同层级的图层信息进行渲染。

Cesium支持多种图层格式：

- wms
- TMS
- WMTS
- ArcGIS
- BingMaps
- GoogleEarth
- Mapbox
- OpenStreetMap

> 默认地，Cesium使用Bing Maps作为默认的图层。这个图层被打包进Viewer中用于演示。

Cesium中基本的添加底图的方法为`viewer.imageryLayers.addImageryProvider()`

我们在`init()`方法中添加下方代码，尝试一下。

```js
var layer = viewer.imageryLayers.addImageryProvider(new Cesium.ArcGisMapServerImageryProvider({
    url: 'http://cache1.arcgisonline.cn/ArcGIS/rest/services/ChinaOnlineCommunity/MapServer'
}));
复制代码
```

![1.gif](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/86c80980222c4490b0ba10c92bb2961e~tplv-k3u1fbpfcp-watermark.image)

对于天地图WebGL提供了一个天地图影像服务提供者类`TiandituImageryProvider`，具体的使用方法可以[参照示例](http://support.supermap.com.cn:8090/webgl/examples/webgl/editor.html#tianditu)和[api文档](http://support.supermap.com.cn/DataWarehouse/WebDocHelp/iPortal/webgl/docs/Documentation/TiandituImageryProvider.html)

### Camera实体

------

我们已经把自己想要的底图添加到地球上了，但是实际项目中肯定不可能一进项目就给人展示整个地球（如果需求是这样的，那我道歉！）。所以我们需要在地球生成后定位到我们需要的位置，这就不得不说一下`Camera`了。

Cesium中有很多方法可以操作Camera，如旋转(rotate)、缩放(zoom)、平移(pan)和飞到目的地(flyTo)。CesiumJS有鼠标和触摸事件用来处理与Camrea的交互，还有API来以编程方式操作摄像机。

使用`setView`函数可设置Camera的位置和方向。`destination`可以是`Cartesian3`或者`Rectangle`，`orientation`可以是`heading | pitch | roll | direction | up`。航向角、俯仰角和横滚角以弧度定义。航向角是从正角度向东增加的局部北向旋转。俯仰角是指从局部的东北平面开始旋转。正俯仰角在平面上方。负俯仰角在平面以下。

```js
 //   初始化场景位置
viewer.scene.camera.setView({
    // 初始化相机经纬度（这里使用了经纬度转换世界坐标的方法）
    destination: new Cesium.Cartesian3.fromDegrees(
      121.54035,
      38.92146,
      2000
    ),
    orientation: {
      heading: Cesium.Math.toRadians(0.0),
      pitch: Cesium.Math.toRadians(-25.0), //从上往下看为-90
      roll: 0,
    },
});
复制代码
```

`flyTo`方法的参数和`setView`是基本一样的。只是`setView`是直接将视角根据参数定位，而`flyTo`如字面意思，会有一个飞向定位点的动画效果。

两者效果图：

![2.gif](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b4dd71de89504a73a1846edf0bcc9e5f~tplv-k3u1fbpfcp-watermark.image)

![3.gif](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/6a6f904d242e440c86d15c2c874d4cf8~tplv-k3u1fbpfcp-watermark.image)

#### 完整代码

```js
<template>
  <div class="container">
    <div id="cesiumContainer"></div>
  </div>
</template>

<script>
var viewer, camera;
export default {
  data() {
    return {};
  },
  mounted() {
    this.init();
  },
  methods: {
    init() {
      viewer = new Cesium.Viewer("cesiumContainer", {});
      var layer = viewer.imageryLayers.addImageryProvider(
        new Cesium.ArcGisMapServerImageryProvider({
          url:
            "http://cache1.arcgisonline.cn/ArcGIS/rest/services/ChinaOnlineCommunity/MapServer",
        })
      );
      //   初始化场景位置
      viewer.scene.camera.flyTo({
        // 初始化相机经纬度
        destination: new Cesium.Cartesian3.fromDegrees(
          121.54035,
          38.92146,
          2000
        ),
        orientation: {
          heading: Cesium.Math.toRadians(0.0),
          pitch: Cesium.Math.toRadians(-25.0), //从上往下看为-90
          roll: 0,
        },
      });
    },
  },
};
</script>

<style lang="scss" scoped>
</style>
复制代码
```