# GIS开发实战图谱

原文地址：https://zhuanlan.zhihu.com/p/151445930

![img](https://pic2.zhimg.com/80/v2-2bb34347bd6693140d1b77528b584881_720w.jpg)

## 一、理论

学好理论知识非常重要，尤其是GIS还是相对来说比较偏冷门的内容。

刚入门看不出来，但时间长了，基础才决定一个人的技术之路能走多远。

学理论和基础，手头需要备几本专业书，谁知道网上找的是对是错。

推荐《地理信息系统导论》、《测量学基础》、《地图学》等书。

[https://www.zrzyst.cn/fgwj/index.jhtml](https://link.zhihu.com/?target=https%3A//www.zrzyst.cn/fgwj/index.jhtmlhttps%3A//www.zrzyst.cn/gjbtdtzs/index.jhtml)

[https://www.zrzyst.cn/gjbtdtzs/index.jhtml](https://link.zhihu.com/?target=https%3A//www.zrzyst.cn/fgwj/index.jhtmlhttps%3A//www.zrzyst.cn/gjbtdtzs/index.jhtml)。

要是觉得不够的话，可以看下《武汉大学测绘专业本科专业课程》，总有一门课，会派上用场。

[https://wenku.baidu.com/view/caf7acf6ec3a87c24128c46b.html](https://link.zhihu.com/?target=https%3A//wenku.baidu.com/view/caf7acf6ec3a87c24128c46b.html)

![img](https://pic3.zhimg.com/80/v2-0cb74118877746a4147088499a8288a2_720w.jpg)



## 二、规范

熟悉理论知识后。

GIS开发主要看OCG规范，CIM是城市信息模型，BIM是建筑物信息模型，这两个都是城市建模相关的。

其余的可以参考《webGIS开发背景知识索引--瓦片原理与数据规范等》https://zhuanlan.zhihu.com/p/144767787。

如果做数据挖掘和算法，要多了解数据结构、数据规格、数据精度等方面内容，[https://www.ogc.org/docs/as](https://link.zhihu.com/?target=https%3A//www.ogc.org/docs/as)。

了解规范，多看官网没坏处：[https://www.ogc.org/docs/is](https://link.zhihu.com/?target=https%3A//www.ogc.org/docs/is)



![img](https://pic3.zhimg.com/80/v2-b4bcdf291da3c008200b1650e1cfc6a6_720w.jpg)





## 三、数据

GIS开发数据是很重要的一项，如何获取开源GIS数据，可参见《GIS数据源汇总》https://zhuanlan.zhihu.com/p/144792968。

Postgresql、spatialite都是对GIS数据兼容比较好的数据库，工程化应用可以使用postgresql，spatialite适合轻量级测试。

Postgresql官网：[https://www.postgresql.org/](https://link.zhihu.com/?target=https%3A//www.postgresql.org/)	PostGIS是postgresql最常用的空间拓展插件：[http://www.postgis.org/](https://link.zhihu.com/?target=http%3A//www.postgis.org/)

![img](https://pic3.zhimg.com/80/v2-7bbf184e765f77d048eca8d582934dc2_720w.jpg)





## 四、算法

说实话，GIS应用和实践的书，能看的不多，GIS算法这块，可以看科学出版社出版的Stephen Wise写的《GIS数据结构与算法基础》，中国工信出版社出版的Joel Lawhead写的《Python地理空间分析指南》。

Java、Python、js的程序实现，可参见《GIS算法索引目录》https://zhuanlan.zhihu.com/p/147689100。

GIS相关的算法一般都用在数据处理和建模上。

![img](https://pic2.zhimg.com/80/v2-9246f385694a4ea93764449ae08fc6a9_720w.jpg)





## 五、软件

软件的熟练程度，是考察一个GIS工程师的标准之一。

我们比较熟悉的GIS软件是arcgis和supermap，但这两个都是收费的商业软件。

但一个行业要发展，开源是大势所趋。

QGIS是一个跟arcgis功能差不多的开源GIS软件，且有更好的拓展性。

如何使用QGIS，可参见《QGIS入门与简单实用----索引目录》https://zhuanlan.zhihu.com/p/138593960。

GIS软件很多，但底层原理都是一样的，一通百通，arcgis、supermap、QGIS这种大而全的软件，会一个就行了。

（不过，在GIS软件领域，还是没有能够超越arcgis的存在。）

smart3D、blender、3DMAX等，都是三维建模的软件，可用于BIM、CIM和三维地图的数据加工。

![image-20210707170931432](https://gitee.com/AiShiYuShiJiePingXing/img/raw/master/img/image-20210707170931432.png)



## 六、后端+前端

webGIS开发不太好区分前端后端，经常是顺手都做了。

开发一定要实践，只看，是看不会的。

新手入门，可以参考两个示例。

一个是后端采用Java的springboot2框架，前端使用vue框架集成leaflet，数据库使用postgresql的《从零开始，构建电子地图网站----索引目录》https://zhuanlan.zhihu.com/p/145423630。

这个写得非常细，从软件安装到服务器部署，零基础的可以照着做一遍。

另一个是后端采用Python django框架，地图使用geoserver发布，前端使用openlayer JavaScript库的《webGIS实践：geoserver+openlayer+django目录索引》https://zhuanlan.zhihu.com/p/141644867。

这个相对来说，工程性弱一些，更偏重GIS技术实现，因为有瓦片地图发布，还有坐标系转换、图层设置的内容。

如果能独立完成这两个demo，说明webGIS开发入门了。

Arcgis和supermap都有全套的GIS开发环境，但这两个都是商业软件，完全封闭，不具备扩展性和移植性。不过这两个软件在GIS市场上的占有率还是非常高的，尤其是企事业单位，有很多人用这两个软件做开发。

二维webGIS开发熟练后，可以接着学一学空间大数据可视化和三维地图开发。

Geomesa：[https://www.geomesa.org/](https://link.zhihu.com/?target=https%3A//www.geomesa.org/)	cesium：[https://cesium.com/cesiumjs/](https://link.zhihu.com/?target=https%3A//cesium.com/cesiumjs/)	

![img](https://pic1.zhimg.com/80/v2-8f839c297bae0f29f32a3324279ebf5c_720w.jpg)

![img](https://pic3.zhimg.com/80/v2-9052769cb4de46f1d5bd8dcb4ff88f5e_720w.jpg)

## 七、方向

GIS开发，职业上区分为两个方向，webGIS开发和数据分析师。但webGIS开发目的也是为了呈现数据，最好两者都有些了解。GIS开发相对于通用的前后端开发来说，就业面会窄一些，天花板也会低一些，所以可以持续的学习计算机知识和热门的程序框架，拓展一下职业广度，工作一段时间后，根据自己的选择，决定未来方向。

GIS开发的就业方向可以统分为体制内外，体制内就是传统地信测绘单位，加上接政府项目的GIS企业，这些地方使用商业软件arcgis和supermap比较多。地图厂商高德、四维图新、腾讯、百度这样的，会招一些GIS背景的产品经理、数据工程师，研发还是会招计算机相关专业的。不过出行、物流、网约车、购物平台这些需要地图服务的行业，会有一定的GIS研发需求。

随着5G、航天航空、物联网的发展，时空大数据可视化、三维地球建模，会是比较好的互联网工程化方向。

遥感影像分析一直是学术领域的热门。高精地图、高精定位、自动驾驶前几年是比较火的，但还是有很长一段路要走。

至于发展前景，时代是瞬息万变的，个人努力很重要，选择方向也很重要。保持对市场的敏锐，保持自己的竞争力，且行且珍惜吧。

![img](https://pic2.zhimg.com/80/v2-b5385be5c114cf5c7859262ad338d641_720w.jpg)

## 八、总结

人需要保持持续学习的状态，我们总有不会的东西，总有需要增进的地方。

GIS基础薄弱，就买书看书补充基础。

规范不了解，就去看OGC官网。

程序框架薄弱，就去学springboot或vue。

地图审美不行，就多去欣赏。