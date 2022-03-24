- [【三维GIS可视化】基于Vue+Cesium+Supermap实现智慧城市（一）](https://juejin.cn/post/6953968499089735711)
- [【三维GIS可视化】基于Vue+Cesium+Supermap实现智慧城市（二）](https://juejin.cn/post/6955011037070360589)
- [【三维GIS可视化】基于Vue+Cesium+Supermap实现智慧城市（三）](https://juejin.cn/post/6958708504618237960)
- [【三维GIS可视化】基于Vue+Cesium+Supermap实现智慧城市（四）](https://juejin.cn/post/6965347246061649934)
- [【三维GIS可视化】基于Vue+Cesium+Supermap实现智慧城市（五）](https://juejin.cn/post/6969369288247361572)



不久前受命研究开发3D可视化及智慧城市的技术路线，第一个想到的就是[Cesium](https://cesium.com)这个世界级开源库。但是我的业务上可能会有很多关于空间及地理分析相关的功能实现，所以我找到了超图。超图拥有基于Cesium包装和二次封装的三维产品3D-WebGL包（文末附产品下载地址）。一切准备就绪，接下来简单了解一下Cesium是什么神奇的东东吧。

### Cesium

------

#### Cesium是什么

Cesium是一个跨平台，跨浏览器的展示三维地球和地图的JavaScript库。Cesium使用WebGL来进行硬件加速图形，使用时不需要任何插件的支持，但需要浏览器支持WebGL。它提供了依据Javascript的开发包，方便我们高效快速的搭建一个3D项目。

#### Cesium能干什么

- 支持2D，2.5D,3D形式的地图展示
- 可以绘制各种几何图形、高亮区域，支持导入图片，甚至3D模型等多种数据可视化展示。
- 可用于动态数据可视化并提供良好的触摸支持，支持绝大多数浏览器和mobile。
- Cesium还支持基于时间轴的动态数据展示。

#### Cesium怎么用

> 接下来的代码中我使用的是超图基于Cesium二次封装过的产品包，所以在这简单说一下最基本的Cesium如何使用。

将Cesium源码中的Build文件夹，拷入到我们的项目中。然后在项目中静态引入相关文件。

```html
  <link rel="stylesheet" href="./Build/Cesium/Widgets/widgets.css">
  <script src="./Build/Cesium/Cesium.js"></script>
复制代码
```

发布后运行，熟悉的helloworld和地球就出现了。

#### 完整代码

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <!-- Use correct character set. -->
  <meta charset="utf-8">
  <!-- Tell IE to use the latest, best version. -->
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <!-- Make the application on mobile take up the full browser screen and disable user scaling. -->
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no">
  <title>Hello World!</title>
  <script src="../Build/Cesium/Cesium.js"></script>
  <style>
      @import url(../Build/Cesium/Widgets/widgets.css);
      html, body, #cesiumContainer {
          width: 100%; height: 100%; margin: 0; padding: 0; overflow: hidden;
      }
  </style>
</head>
<body>
  <div id="cesiumContainer"></div>
  <script>
    Cesium.Ion.defaultAccessToken='eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI3ZjA2ZDQ2ZS02NTA4LTQ2NTItODE1My1kZjE3MjBkMjFkNzAiLCJpZCI6NDM5NCwic2NvcGVzIjpbImFzciIsImdjIl0sImlhdCI6MTU0MDcyNzI4Nn0.L7P8pJponZfYjdsGnEw2hIHd2AN0h-SuYl6XvzOwLeA';
    var viewer = new Cesium.Viewer('cesiumContainer');
  </script>
</body>
</html>
复制代码
```

### 项目搭建

------

我们选择Vue作为开发框架，所以搭建Vue项目这个我就不多做介绍了，大家能在掘金相遇那证明大家都是优秀的前端（~~摸鱼摸摸~~），不会的xdm就百度一下吧。

#### 引入WebGL包

因为这个包是基于Cesium二次开发的，所以引入方式可以和Cesium一样，只需要将包内的`Build/Cesium`文件夹放到我们的`public/static`下，在`index.html`内静态引入即可。

> widgets.css包含了Ceisum的可视化控件

```html
<link rel="stylesheet" href="static/Cesium/Widgets/widgets.css">
复制代码
```

> Cesium.js定义了Cesium对象，其中包括我们需要的东西

```html
<script src="static/Cesium/Cesium.js"></script>
复制代码
```

#### 经典HelloWorld

像很多的地图api一样，Cesium也需要一个div作为三维场景的唯一容器，并在页面初始化时生成对应的Viewer实例。

#### 强调！强调！强调！

重要的事情说三遍。所有关于Cesium的变量请！一定！**不要放在data中维护**！因为Vue会对data中的状态进行数据劫持，而对象则会递归的进行数据劫持，以此方式监听状态变化。而Cesium实例的属性极多，层级极深，如果将其挂载到data上。不出意外，你的浏览器会崩溃。

如果需要通信的话，最简单的方法就是挂载到window对象上。

#### 完整代码

```html
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
    },
  },
};
</script>

<style lang="scss" scoped>
</style>
复制代码
```

启动项目，我们就能看到下图的效果了。 ![helloworld.gif](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/70b22bd76fd649038222986ee0ec685b~tplv-k3u1fbpfcp-watermark.image)

### 附录

------

#### Cesium相关网址

- [cesium.com/docs/](https://cesium.com/docs/)   Cesium文档
- [cesium.com/docs/cesium…](https://cesium.com/docs/cesiumjs-ref-doc/) Cesium API
- [sandcastle.cesium.com/](https://sandcastle.cesium.com/) Cesium沙盒示例（好多效果都可以在这找到）

#### 超图相关网址

- [support.supermap.com.cn:8090/webgl/web/d…](http://support.supermap.com.cn:8090/webgl/web/downloads/download1.html) 超图WebGL产品包下载
- [support.supermap.com.cn:8090/webgl/examp…](http://support.supermap.com.cn:8090/webgl/examples/webgl/examples.html#layer) 超图3维示例
- [support.supermap.com.cn:8090/webgl/web/a…](http://support.supermap.com.cn:8090/webgl/web/apis/3dwebgl.html) 超图及Cesium相关API属性文档（个人觉得比较方便）