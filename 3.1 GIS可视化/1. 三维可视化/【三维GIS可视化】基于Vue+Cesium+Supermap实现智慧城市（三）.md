- [【三维GIS可视化】基于Vue+Cesium+Supermap实现智慧城市（一）](https://juejin.cn/post/6953968499089735711)
- [【三维GIS可视化】基于Vue+Cesium+Supermap实现智慧城市（二）](https://juejin.cn/post/6955011037070360589)
- [【三维GIS可视化】基于Vue+Cesium+Supermap实现智慧城市（三）](https://juejin.cn/post/6958708504618237960)
- [【三维GIS可视化】基于Vue+Cesium+Supermap实现智慧城市（四）](https://juejin.cn/post/6965347246061649934)
- [【三维GIS可视化】基于Vue+Cesium+Supermap实现智慧城市（五）](https://juejin.cn/post/6969369288247361572)



### Entity实体

------

在Cesium中，有几种添加实体的方式，例如利用Entity添加，以及Primitive添加。后者更接近渲染引擎底层所以今天先不介绍。Cesium中利用Entity可以添加许多形状：点、线、面、管道、圆柱体等等，在Cesium官网的[Sandcastle](https://sandcastle.cesium.com/index.html?src=Box.html&label=Geometries)中都有对应的例子，有需要的可以自行查看。

#### 点`Billboard`

在Cesium中，点的是通过`Billboard`的方式呈现的，顾名思义就是广告牌。`Billboard`会在指定坐标位置生成一个面朝屏幕的指定图片。话不多说，我们通过代码来了解一下：

```js
viewer.entities.add({
    position: Cesium.Cartesian3.fromDegrees(121.54035, 38.92146,100),
    billboard: {
      image: require("@/views/images/blueCamera.png"), // default: undefined
      show: true, // default
      pixelOffset: new Cesium.Cartesian2(0, -50), // default: (0, 0)
      eyeOffset: new Cesium.Cartesian3(0.0, 0.0, 0.0), // default
      horizontalOrigin: Cesium.HorizontalOrigin.CENTER, // default
      verticalOrigin: Cesium.VerticalOrigin.BOTTOM, // default: CENTER
      scale: 2.0, // default: 1.0
      color: Cesium.Color.LIME, // default: WHITE
      rotation: Cesium.Math.PI_OVER_FOUR, // default: 0.0
      alignedAxis: Cesium.Cartesian3.ZERO, // default
      width: 100, // default: undefined
      height: 25, // default: undefined
    },
});
复制代码
```

可以看到在这里我们用了`Viewer`下`entities`下的一个方法`add`，entity通过这个方法添加到`viewer`内。

我在坐标转换的时候给了它一点高程值，以便显示的更完整。效果如下

![1.gif](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/773e0178f68546a8b6b41bba82392299~tplv-k3u1fbpfcp-watermark.image)

#### 线`Polyline`

同`Billboard`一样，线也是通过`viewer.add()`方法进行添加的。接下来先放代码：

```js
viewer.entities.add({
        // name:entity.name,
    polyline: {
      positions: Cesium.Cartesian3.fromDegreesArray([121.534575,38.926131, 121.537579,38.92543,121.541784,38.924578,121.543973,38.924144,121.545947,38.923944]),
      width: 2,
      material: Cesium.Color.DARKORANGE.withAlpha(0.7),
      // clampToGround: true,
      // show: true,
    },
});
复制代码
```

`positions`需要一个笛卡尔做表集用来绘制线，`width`是线宽，`material`是线的材质（它就是我们生成动效线的关键），`clamToGround`是选择线是否贴地渲染，在有地形的底图上贴地模式会贴着地形起伏进行绘制，而绝对高度则会穿过地形，最后的`show`就是是否显示了。

基本效果（为了显示效果好，换了一个深色底图）

![2.gif](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/467e77a280b34a81a5fb67d62c2373b7~tplv-k3u1fbpfcp-watermark.image)

这时候你可能就说了，这个线也太丑了吧，我看人家的线都是那种发光的（你说的是奥特曼吗？这个世界上真的有奥特曼吗？）。别急，接下来我提供一种实现发光的思路，当然思路不仅于此，感兴趣的小伙伴可以多上网搜搜。上代码！

```js
// 在上边添加过的线基础上我们再添加一条动效线
viewer.entities.add({
        // name:entity.name,
    polyline: {
      positions: Cesium.Cartesian3.fromDegreesArray([
        121.534575,
        38.926131,
        121.537579,
        38.92543,
        121.541784,
        38.924578,
        121.543973,
        38.924144,
        121.545947,
        38.923944,
      ]),
      width: 4, // 线的宽度，像素为单位
      material: new Cesium.PolylineTrailMaterialProperty({
        // 尾迹线材质
        color: Cesium.Color.GOLD,
        trailLength: 0.4,
        period: 3.0,
      }),
    },
});
复制代码
```

效果如下

![3.gif](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/26b83bdb5dc742c0ae0dc4f028bd11a2~tplv-k3u1fbpfcp-watermark.image)

一条线看着效果感觉还好，但是如果是下边这种路网效果其实是不错的。

![4.gif](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/4a7041548c9144548916d2bd990ff272~tplv-k3u1fbpfcp-watermark.image)

相信聪明的小伙伴已经发现了，诶你添加点，线用的都是add方法而且传递的参数结构基本上都是一个`position`和一个对应的实体配参。不错，其实我们可以基于这样的结构自己封装一个`Entity`对象，后续二次进行实体的绘制类和编辑类，这里就不进行说明了。

#### 面`Polygon`

上边那个图其实已经向我们展示了面元素，你肯定会认为我说的是那个绿色的区域，格局小了！其实那些楼房本质上也是一个个面，只不过我们通过拉伸将他拉伸出了一定高度形成了所谓的面。它的添加方式和点、线一样，我就不多赘述了，直接上代码。

```js
viewer.entities.add({
    polygon: {
      hierarchy: Cesium.Cartesian3.fromDegreesArray([
        121.539208,
        38.924962,
        121.539176,
        38.924737,
        121.540195,
        38.924486,
        121.540281,
        38.924737,
      ]),
      extrudedHeight: 50,
      material: Cesium.Color.WHITE,
      // closeTop: false,
      // closeBottom: false,
    },
});
复制代码
```

看效果：

![5.gif](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/2cc8cf3450d84f5386fce77650bc375a~tplv-k3u1fbpfcp-watermark.image)

这只是生成建筑的一种方式，同样，这也是面众多用途中的一种，我只负责抛砖，大家才是玉。

### 点击获取面、广告牌

在项目中我们不可能只是将这些点线面呈现在眼前，我们的要素上一定承载着对应的数据或属性，我们需要通过点击对应要素获取到数据、属性或自定义的操作。

我们先通过`ScreenSpaceEventHandler`注册一个全局`handler`，然后利用`setInputAction`注册`LEFT_CLICK`鼠标左键点击事件，在它的回调中我们可以获取到鼠标的点击对象。然后通过`viewer.scene.pick`方法（`场景拾取，返回在场景中该窗口位置对应的第一个图元对象，如果该位置没有任何物体则返回undefined`），传入坐标，获取到点击位置的实体。

```js
handler = new Cesium.ScreenSpaceEventHandler(viewer.scene.canvas);
handler.setInputAction((e) => {
    var pick = viewer.scene.pick(e.position);
    console.log(e , pick);
}, Cesium.ScreenSpaceEventType.LEFT_CLICK);

复制代码
```

![6.gif](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/951f125ebf7740dfbe6e8eaf60f273ff~tplv-k3u1fbpfcp-watermark.image)

我们来看看打印出了什么

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/e419d7fa2d634df3ba07e647c7b72f05~tplv-k3u1fbpfcp-watermark.image)

`e`为我们鼠标在屏幕上的屏幕二维坐标组，`pick`则是返回的图元对象，其中的`id`则是我们拾取到的实体。

### 完整代码

```js
<template>
  <div class="container">
    <div id="cesiumContainer"></div>
  </div>
</template>

<script>
var viewer, camera, handler;
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
        new Cesium.UrlTemplateImageryProvider({
          url:
            "https://map.geoq.cn/arcgis/rest/services/ChinaOnlineStreetPurplishBlue/MapServer/tile/{z}/{y}/{x}",
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

      handler = new Cesium.ScreenSpaceEventHandler(viewer.scene.canvas);
      handler.setInputAction((e) => {
        var pick = viewer.scene.pick(e.position);
        console.log(e, pick);
      }, Cesium.ScreenSpaceEventType.LEFT_CLICK);

      this.addBillboard();
      this.addPolyline();
      this.addPolygon();
    },
    addBillboard() {
      viewer.entities.add({
        position: Cesium.Cartesian3.fromDegrees(121.54035, 38.92146, 50),
        billboard: {
          image: require("./images/blueCamera.png"), // default: undefined
          // show: true, // default
          // pixelOffset: new Cesium.Cartesian2(0, -50), // default: (0, 0)
          // eyeOffset: new Cesium.Cartesian3(0.0, 0.0, 0.0), // default
          // horizontalOrigin: Cesium.HorizontalOrigin.CENTER, // default
          // verticalOrigin: Cesium.VerticalOrigin.BOTTOM, // default: CENTER
          // scale: 2.0, // default: 1.0
          // color: Cesium.Color.LIME, // default: WHITE
          // rotation: Cesium.Math.PI_OVER_FOUR, // default: 0.0
          // alignedAxis: Cesium.Cartesian3.ZERO, // default
          // width: 100, // default: undefined
          // height: 25, // default: undefined
        },
      });
    },
    addPolyline() {
      viewer.entities.add({
        polyline: {
          positions: Cesium.Cartesian3.fromDegreesArray([
            121.534575,
            38.926131,
            121.537579,
            38.92543,
            121.541784,
            38.924578,
            121.543973,
            38.924144,
            121.545947,
            38.923944,
          ]),
          width: 4,
          material: Cesium.Color.DARKORANGE.withAlpha(0.3),
          // clampToGround: true,
          // show: true,
        },
      });
      viewer.entities.add({
        // name:entity.name,
        polyline: {
          positions: Cesium.Cartesian3.fromDegreesArray([
            121.534575,
            38.926131,
            121.537579,
            38.92543,
            121.541784,
            38.924578,
            121.543973,
            38.924144,
            121.545947,
            38.923944,
          ]),
          width: 4, // 线的宽度，像素为单位
          material: new Cesium.PolylineTrailMaterialProperty({
            // 尾迹线材质
            color: Cesium.Color.GOLD,
            trailLength: 0.4,
            period: 3.0,
          }),
          // clampToGround: true,
          // show: true,
        },
      });
    },
    addPolygon() {
      viewer.entities.add({
        polygon: {
          hierarchy: Cesium.Cartesian3.fromDegreesArray([
            121.539208,
            38.924962,
            121.539176,
            38.924737,
            121.540195,
            38.924486,
            121.540281,
            38.924737,
          ]),
          extrudedHeight: 50,
          material: Cesium.Color.WHITESMOKE,
          // closeTop: false,
          // closeBottom: false,
        },
      });
    },
  },
};
</script>

<style lang="scss" scoped>
</style>
```