- [【三维GIS可视化】基于Vue+Cesium+Supermap实现智慧城市（一）](https://juejin.cn/post/6953968499089735711)
- [【三维GIS可视化】基于Vue+Cesium+Supermap实现智慧城市（二）](https://juejin.cn/post/6955011037070360589)
- [【三维GIS可视化】基于Vue+Cesium+Supermap实现智慧城市（三）](https://juejin.cn/post/6958708504618237960)
- [【三维GIS可视化】基于Vue+Cesium+Supermap实现智慧城市（四）](https://juejin.cn/post/6965347246061649934)
- [【三维GIS可视化】基于Vue+Cesium+Supermap实现智慧城市（五）](https://juejin.cn/post/6969369288247361572)



国家现在大力推行网格化管理，各地也基于网格化管理诞生了很多系统，现如今智慧城市或数字城市中，必不可少的功能就是网格展示及相关功能。今天我们就网格相关的样式和操作来复习一下关于面`polygon`的点击操作。同样的，行政区划也可以利用这样的效果和操作进行下沉。

我们先来看一下效果，实现了面的渐变填充样式，鼠标悬浮效果、点击效果。

![grid.gif](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/aade526c35914ce4b319be056980283b~tplv-k3u1fbpfcp-watermark.image)

### 思路及实现

我们想要实现面的点击、悬浮效果以及样式的修改。需要用到的基本上就是Cesium的`ScreenSpaceEventHandler`来监听鼠标的操作，而样式修改可能会对填充图片或者`material`进行处理。好了，既然想到了如何实现我们就开始动手吧！

#### 获取数据

网格实质上也是面，所以我们需要首先有网格的面数据，我们可以去 [DataV.Geoatlas](http://datav.aliyun.com/tools/atlas/#&lat=30.332329214580188&lng=106.72278672066881&zoom=3.5)地图中获取面的geojson数据。这里我们采用北京市的行政区划数据,地址我这里贴出来，想寻找其他数据的小伙伴可以自行寻找。

```txt
https://geo.datav.aliyun.com/areas_v2/bound/110000_full.json
复制代码
```

#### 加载geoJSON格式数据

利用Cesium的`GeoJsonDataSource`来加载geoJSON数据，注意：它返回的是一个promise对象，所以接收时需要使用`.then(cb)`。

```js
var promise=Cesium.GeoJsonDataSource.load('https://geo.datav.aliyun.com/areas_v2/bound/110000_full.json')
promise.then((datasource) => {
    viewer.dataSources.add(datasource);
    var entities = datasource.entities.values;
    for (var i = 0; i < entities.length; i++){
      var entity = entities[i];
      entity.polygon.material = Cesium.Color.RED;
      entity.polygon.extrudedHeight = 100
    }
})
复制代码
```

在这里我们看到datasource就是我们通过url获取到的数据集，加载完毕后我们需要通过循环数据集中的实体集来对每一个实体进行样式的修改，这里我们暂时设置了它的颜色为红色，拉伸高度为100。

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b4e9e1de45ba445880effd74e7769dab~tplv-k3u1fbpfcp-watermark.image)

可以看到我们的带有高度的面已经渲染出来了，接下来我们可以思考一下如何变成我们最开始的效果图那样半透明渐变的呢？

#### `polygon`样式修改

我们知道，`entity`是通过`matrial`材质进行样式的修改。透明度我们可以通过`Cesium.Color`自带的`withAlpha`进行修改，但我们想呈现出的效果是区域渐变加透明，我当时的第一想法是既然`material`可以加载图片，那我们能不能用一张区域渐变的图片对它进行填充呢？结论是可以的。我们只需要`           entity.polygon.material = require('./images/color.jpg');`就可以利用图片填充。

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/9c1500f8080d4aa3b4f7458f7a931c3c~tplv-k3u1fbpfcp-watermark.image)

这时候你可能会说，这就好办了，把图片变成半透明的不就实现了吗。这有什么难的。对，但是我们思考一下，如果这时候客户说：不行，这个颜色不好看，给我多换几个我看看效果，你该怎么办？做好几张图片挨个替换吗，这未免也太麻烦了吧。所以我们需要一个能够指定颜色并快速生成图片的方式供我们使用。`canvas`这时候站出来了，利用`canvas`，我们可以使用代码来快生成指定样式的图片，这不比制图快多了。

`canvas`关于渐变、角度的知识在这就不介绍了，网上比比皆是，我们直接通过代码讲解。

```js
getColorRamp(rampColor,centerColor) {
    var ramp = document.createElement("canvas");
    ramp.width = 50;
    ramp.height = 50;
    var ctx = ramp.getContext("2d");

    var grd = ctx.createRadialGradient(25, 25, 0, 25, 25, 50);
    grd.addColorStop(0, centerColor); // "rgba(255,255,255,0)"
    grd.addColorStop(1, rampColor);

    ctx.fillStyle = grd;
    ctx.fillRect(0, 0, 50, 50);

    // return ramp;

    return new Cesium.ImageMaterialProperty({
      image: ramp,
      transparent: true
    });
}
复制代码
```

可以看到我们封装了一个函数，入参是渐变两端的颜色（当然如果你的需求中需要改变角度、方向等可以自定义参数），生成一个`50*50`的canvas画布，`createRadialGradient`创建一个渐变对象，规定渐变颜色和位置，绘制到画布上，最后返回一个Cesium的`ImageMaterialProperty`图片材质类，记得配置`transparent`为`true`。

这样我们就可以自定义颜色来生成半透明渐变效果的材质了，看效果！

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/75a5a24c5f554b798c3fb2c8f8eb2320~tplv-k3u1fbpfcp-watermark.image)

边缘的黄线是面的`outline`，我们可以将其设置为`null`以展示更好效果。

#### 鼠标悬浮及点击事件

我们想实现的效果为点击高亮和鼠标移入时面外围有动效线的效果，其实很简单，也就是我们点击这个面的时候获取到这个面，改变这个面的材质，利用这个面的外围坐标集生成一个`polyline`，添加动态线的材质。现在我们来看看代码吧。

```js
handler = new Cesium.ScreenSpaceEventHandler(viewer.scene.canvas);
handler.setInputAction((e) => {
  var pick = viewer.scene.pick(e.position);
  if (Cesium.defined(pick) && pick.id) {
    var feature = pick.id;
    viewer.entities.removeById("select_grid");
    viewer.entities.removeById(`line_${feature.id}`);
    let positions = feature.polygon.hierarchy.getValue(
        Cesium.JulianDate.now()
    ).positions;
    viewer.entities.add({
    id: "select_grid",
    polygon: {
      hierarchy: positions,
      material: this.getColorRamp(
        "rgba(0, 255, 255,1)",
        "rgba(255,0,0,0.3)"
      ),
      height: 499,
    },
    });
  }
}, Cesium.ScreenSpaceEventType.LEFT_CLICK);

handler.setInputAction((movement) => {
    var pickFeature =
      viewer.scene.pick(movement.endPosition) &&
      viewer.scene.pick(movement.endPosition).id;
    if (Cesium.defined(pickFeature) && this.preLineId !== pickFeature.id) {
      this.preLineId &&viewer.entities.removeById(`line_${this.preLineId}`);
      this.preLineId = pickFeature.id;
      viewer.entities.add({
        id: "line_" + pickFeature.id,
        name: "line_" + pickFeature.name,
        polyline: {
          positions: pickFeature.polygon.hierarchy.getValue(
            Cesium.JulianDate.now()
          ).positions,
          width: 8,
          material: new Cesium.PolylineTrailMaterialProperty({
            // 尾迹线材质
            color: Cesium.Color.AQUA,
            trailLength: 0.9,
            period: 1,
          }),
        },
      });
    } else {
      this.preLineId && viewer.entities.removeById(`line_${this.preLineId}`);
      this.preLineId = null;
    }
}, Cesium.ScreenSpaceEventType.MOUSE_MOVE);
复制代码
```

效果：

![6.gif](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/c23f4fb6f1704739b9a1ddf1a1cb8eaf~tplv-k3u1fbpfcp-watermark.image)

其实总结一下就是获取到当前鼠标位置下的`entity`，根据面的外围坐标集生成一个新的面和新的线，添加到球体上。就是先我们的效果了。