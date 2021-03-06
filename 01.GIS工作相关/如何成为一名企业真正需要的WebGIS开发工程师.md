- [如何成为一名企业真正需要的WebGIS开发工程师](https://hanbo.blog.csdn.net/article/details/106989323)

## 前言

目前博主在郑州的一家GIS公司工作，从事农业大数据相关GIS项目开发。在郑州招聘一个WebGIS开发者不太容易，这可能和郑州的整体大环境有关系，没有几家靠得住的GIS公司。在公司也经常做技术面试，其中包括做一些WebGIS开发的人。也有一些感触，今天就不分享代码了，来谈谈这些感悟。

------

## 什么是WebGIS开发

经常遇到一些人说，"我做过GIS，我开发过高德地图"，也有人说，“我想学习GIS开发，你指导我一下吧！”。凡此种种，不胜枚举。只会高德地图或百度地图开发，恐怕还算不上会GIS开发。任何一个前端开发者，看到百度或者高德的文档，都能轻松的实现一个地图demo。上周一个程序媛来面试WebGIS研发岗，研究生毕业，当看到简历时，我很惊异，简历上写的技术栈都很符合。但是面试时，才知道这个人，只用OpenLayers做过WMTS加载，做过放大缩小功能。

WebGIS开发不等于前端开发，WebGIS开发，首先要有足够的地理信息（GIS）的专业知识作为支撑，其次要掌握前后端的开发技术。了解地图数据，地图服务、了解地图的渲染。

## WebGIS开发者要掌握的基础

在开发过程中，只要你掌握了以下技术，就基本能处理企业所有的WebGIS开发方便的需求：

### 基于OGC标准的地图服务

无论是ArcGIS，还是GeoServer，都是支持OGC标准的，支持发布符合OGC标准的WMS、WFS、WMTS、TMS的地图服务。做WebGIS开发，首先你要了解不同的地图服务，剩下的就是根据地图框架和应用场景去调用地图服务了。

### 坐标系

很多时候，周围的人都会问你是基于什么坐标系的，需要什么坐标系的数据，能不能转换？离开了坐标系，GIS开发也就失去了意义。作为WebGIS开发者，你必须要掌握常用的坐标系（我前面的博文也有提到过）。

### 主流地图框架

无论是Openlayers、Leaflet还是MapBox、Cesium，这些地图框架都有其优点与缺点，针对不同的应用场景，应该合理地选择不同类型的地图开发框架。

### 地图渲染

如果只了解，如何引用各地图引擎的库，复制代码，WebGIS开发者很快就会遇到瓶颈。只有你了解瓦片、矢量是如何在浏览器上进行渲染的，如何从投影坐标系或地理坐标系转到画布坐标系的，你才能开发出更优秀的系统，甚至于开发出自己的地图框架。

### 了解地图绘制的极限

虽然目前PC配置高了，浏览器可使用本地硬件加速了。但使用浏览器进行地图展示时，依然是有极限的。你是否了解，浏览器最大能同时绘制多少个栅格瓦片，能同时绘制多少个矢量点或线。只有了解这些，才能做出更好的用户体验。

## 结尾

前些天，我在网上看到，居然还有培训GIS开发的。说真的，我不觉得短时间能像Java开发那样培训出什么。WebGIS开发更多的只能依靠实践、依靠自己的探索。