- [openlayers 6【一】 简介openlayers背景，优势，如何使用及实际使用场景_范特西是只猫的博客-CSDN博客_openlayers6](https://xiehao.blog.csdn.net/article/details/105267039)

### 1. 自己学习openlayers 的背景

最近公司项目需要使用到GIS地图为依托做一些交互（如点 聚合分散，热力图，地图下钻，图层叠加，点位图，地图轨迹，地图图层切换）等功能，于是我临危受命不得不去学习openlayers。

### 2. 现在聊聊 openlayers 是什么？发展历程？优势？怎么使用？

**2.1 openlayers 是干什么的？**

要想在浏览器中显示交互式的地图很难，因为浏览器默认的只是显示静态的图片，如PNG、JPEG等格式，要交互式很难，因为每一个点击和缩放，地图都要做出正确的反应。

OpenLayers是一个JavaScript 类库包，主要是用于开发Web GIS客户端。这就是说，要先在网页中引用OpenLayers的JavaScript文件以及相应的css样式表和资源，根据其提供的功能接口，直接调用。所以关键是了解其提供的接口，这是使用一个类库的关键！如果想要优化相应的功能或者定制化，就要深入地了解其实现细节了，这需要有熟练的JavaScript功底。

OpenLayers支持Google Maps、Yahoo Map、微软Virtual Earth等资源，可以通过WMS服务调用其它服务器上的空间数据，通过WFS服务调用空间服务。在操作方面，OpenLayers 除了可以在浏览器中实现地图浏览的基本效果，如放大、缩小、平移等操作，进行选取面、选取线、要素选择、图层叠加等操作。

**2.2 openlayers 发展历史？**

OpenLayers在2.13版本中引入了Web Processing Services(WPS)标准，可以对空间数据进行地理分析，例如缓冲区分析。

openlayers中文官方站于2012年8月成立，是由一群openlayers爱好者共同维护的，内容包括openlayers中文API和中文帮助文档，OpenLayers源码分析 、 OpenLayers扩展开发 、OpenLayers相关工具 、OpenLayers 3D、 Openlayers Mobile

**2.3 openlayers 相对比其他的前端框架有哪些优势？**

相对于另一个框架 OpenScales，OpenScales 是 OpenLayers 的 ActionScript 翻译，需要 FlashPlayer 支持才行，虽然基本现在浏览器都有这个插件，就好象他已经不是插件了，但是我比较反对插件，要使用一个功能，还要装插件，不如原生的好。总之我觉得 OpenLayers 比较好用！

**2.4 openlayers 怎么使用？**

 vue npm 安装包

```javascript
npm install ol
```

如果您想试用OpenLayers而不下载任何内容（**不建议用于生产环境**），请在html页面的开头添加以下内容

```html
<script src="https://cdn.jsdelivr.net/gh/openlayers/openlayers.github.io@master/en/v6.3.1/build/ol.js"></script>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/openlayers/openlayers.github.io@master/en/v6.3.1/css/ol.css">
```

后面会详细讲解怎么使用....尽请期待

### 3. 最后总结

如果你想在浏览器中进行Web GIS的开发，那么OpenLayers可以大大减少你的工作量，让你快速开发出应用。OpenLayers 6及后面版本，正在朝着3D等一些前沿领域前进，并支持更多的设备终端。

总之，要搞Web GIS，客户端用OpenLayers开发绝对没错！

### 4. 写在最后

基于现在前端流行的框架vue，后面的基础介绍会以文档说明穿插着vue去写，尽量避免使用原生前端三件套去写。常见的功能点会直接使用vue去写。所有对vue有了解的会更加上手。