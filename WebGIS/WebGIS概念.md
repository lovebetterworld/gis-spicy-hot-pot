# WebGis开发体系

![image-20210712152158690](https://gitee.com/AiShiYuShiJiePingXing/img/raw/master/img/image-20210712152158690.png)

# WebGIS概念

原文地址：https://www.jianshu.com/p/7ac9aa68750c

- Web + GIS 就是，在Web网页上的GIS系统，我们可以在网页（浏览器）上进行GIS数据处理操作、可视化展示等。
   WebGIS 三层架构主要为展示层、地图服务层、数据层，通过UML图形进行理解：

  ![img](https:////upload-images.jianshu.io/upload_images/5479420-305f928744cab142.png?imageMogr2/auto-orient/strip|imageView2/2/w/519)

  

- 3D WebGIS是近期未来的方向，因为大数据可视化，最佳配合展示方式是3D地图

- 地图要素展示（建筑、路线信息），空间分析（最短路径、最快路径），数据分析可视化（交通实时情况），POI兴趣点（附近景点、商家、美食等）。

- Web服务器一般指网站服务器，简单的可以理解为，电脑上的文件资源，可以通过Web服务器部署后，让通过因特网的人都能访问预览。

- Nginx 和 Tengine服务器

- 目前行业上流行的，有些用户基数的地图JS库，主要有：ArcGIS API for JavaScript、OpenLayers、Leaflet、Mapbox、maptalks.js

![img](https:////upload-images.jianshu.io/upload_images/5479420-b2cfe05243e288d7.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200)

从图中可以看出，地图视图支持2D/3D，3D的效果主要是 SceneView 类提供。
 然后到地图图层Layers，提供了丰富的类和接口，各种各样的图层要素，Graphic还是Geometry，还是栅格、图片等都应有尽有，我们可以通过这些接口去绘制图形或者展示图层元素、符号渲染等。
 在工具组件Widgets提供了常用的控件，比如地图的缩放，测量，打印等等；
 查询检索 Tasks 里边就是比较高级的分析功能了，这些分析功能大多基于地图服务，有最短路径分析，缓冲区分析，几何分析，空间要素查询等等
 ol本身没有提供3D的功能，但官方团队有提供基于 ol+ Cesium的三维实现，开源仓库见[ol3-cesium](https://github.com/openlayers/ol-cesium)。（Cesium是国外一个基于JavaScript编写的使用WebGL的地图引擎，可以简单认为是一个Web端的三维球，然后提供了一些接口去展示渲染模型和地图要素）

[Leaflet](https://github.com/Leaflet/Leaflet) 是一款轻量级，用于移动友好交互式地图的JavaScript库。轻量级的意思就是代码总大小比较小。Leaflet利用HTML5和CSS3在现代浏览器上的优势，同时也可以在旧浏览器上访问。它可以通过大量插件进行扩展，具有漂亮的、易于使用的、文档丰富的API，使用上也比较简单

- 可视化图表库常用有 Echarts、Highcharts、Chart.js、G2、D3.js等。
   其中Echarts和G2是国内的，分别是百度和阿里，Highcharts商业使用需要收费，其他都是免费。Echarts出来的毕竟早，推荐优先使用，D3.js的话多用于复杂图形和3D可视化效果。
- 前端工程化内容主要有：前端规范化、模块化、组件化、自动化等.
   规范化
   规范化包含开发流程，文档规范、开发方式、代码管理方式、编码规范等内容，如果一个大的项目工程没有规范约束的话，这个项目的代码管理和开发流程方式都会比较乱，设计上也不会很好，开发人员没规范，随便玩，代码质量也可能受到影响，最终造成的就是项目维护成本较高，开发效率低等，动不动可能就重构。
   编码规范，在前端的话主要是js编写规范，比如目前流行用ES6、TypeScript编写前端的话，对应有 eslint 、tslint 工具，原生JavaScript编码开发也有jsLint，jsHint。这些工具可以限制编码规范，规则都是可以自定义配置的，每个团队都有不同的规范要求，根据团队情况灵活调整规则限制即可。
   同样CSS也可以通过StyleLint等工具做好规范检查。

AMD 与 CMD的模块化规范