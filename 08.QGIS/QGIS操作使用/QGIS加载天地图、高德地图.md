- [QGIS加载天地图、高德地图](https://www.cnblogs.com/googlegis/p/14986844.html)



在ArcGIS中加载地图很麻烦，一来是国内的数据源太少，二是地图显示速度太慢。

不过在QGIS中加载地图，然后把shp文件加载，效果好很多。后来在 https://zhuanlan.zhihu.com/p/353888644

这篇文章里写的很全，而且目前来说内容都有效。

我这里只贴几个我在用的地址。

# 一、加载矢量地图

## 1.1 高德矢量图

https://webrd02.is.autonavi.com/appmaptile?lang=zh_cn&size=1&scale=1&style=8&x={x}&y={y}&z={z}

![img](https://img2020.cnblogs.com/blog/59231/202107/59231-20210708163605466-704579386.png)

## 1.2 高德影像图

https://webst01.is.autonavi.com/appmaptile?style=6&x={x}&y={y}&z={z}

![img](https://img2020.cnblogs.com/blog/59231/202107/59231-20210708163649825-1930539892.png)

## 1.3 高德路网图

https://wprd01.is.autonavi.com/appmaptile?x={x}&y={y}&z={z}&lang=zh_cn&size=1&scl=2&style=8&ltype=11%0A%0A

 ![img](https://img2020.cnblogs.com/blog/59231/202107/59231-20210708163746755-1902333995.png)

## 1.4 天地图影像图

https://t3.tianditu.gov.cn/img_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=img&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TILECOL={x}&TILEROW={y}&TILEMATRIX={z}&tk=天地图注册浏览器端tk

![img](https://img2020.cnblogs.com/blog/59231/202107/59231-20210708163842527-1921986010.png)

 

## 1.5 天地图影像图标注，里面包含了路网和标注。

https://t2.tianditu.gov.cn/cia_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=cia&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TILECOL={x}&TILEROW={y}&TILEMATRIX={z}&tk=天地图注册浏览器端tk

![img](https://img2020.cnblogs.com/blog/59231/202107/59231-20210708164004289-340724062.png)

 

## 1.6 天地图矢量地图

https://t6.tianditu.gov.cn/vec_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=vec&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TILECOL={x}&TILEROW={y}&TILEMATRIX={z}&tk=天地图注册浏览器端tk

![img](https://img2020.cnblogs.com/blog/59231/202107/59231-20210708164122759-149179939.png)

## 1.7 天地图矢量标注

 https://t2.tianditu.gov.cn/cva_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=cva&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TILECOL={x}&TILEROW={y}&TILEMATRIX={z}&tk=天地图注册浏览器端tk

![img](https://img2020.cnblogs.com/blog/59231/202107/59231-20210712105718510-1262123453.png)

以下内容来自：https://zhuanlan.zhihu.com/p/353888644， 在此转载做个备份。 

QGIS有加载WMS、WMTS、WFS，以及XYZ形式的瓦片等地图服务的能力，通常可以作为空间数据的底图一起可视化出来。

# 二、QGIS使用地图服务

本文列举一些例子记录QGIS如何使用地图服务，具体包括：

- XYZ
- XYZ的链接获取
- WMTS服务，以Mapbox为例
- 天地图(XYZ和WFS)

URL列表：

```text
XYZ参考:
http://openwhatevermap.xyz/
高德参考：https://blog.csdn.net/ldlzhy1984/article/details/81015180
https://blog.csdn.net/fredricen/article/details/77189453
高德矢量图：https://webrd02.is.autonavi.com/appmaptile?lang=zh_cn&size=1&scale=1&style=8&x={x}&y={y}&z={z}
高德遥感图：http://webst02.is.autonavi.com/appmaptile?style=6&x={x}&y={y}&z={z}

OSM标准底图：https://tile.openstreetmap.org/{z}/{x}/{y}.png
Staman水彩图：http://a.tile.stamen.com/watercolor/{z}/{x}/{y}.jpg
Mapbox底图：https://api.mapbox.com/styles/v1/mapbox/streets-v10/tiles/256/{z}/{x}/{y}?access_token=<mapbox key>

天地图矢量图：https://t6.tianditu.gov.cn/vec_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=vec&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TILECOL={x}&TILEROW={y}&TILEMATRIX={z}&tk=<tianditu key>
天地图矢量注记：https://t2.tianditu.gov.cn/cva_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=cva&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TILECOL={x}&TILEROW={y}&TILEMATRIX={z}&tk=<tianditu key>
天地图遥感图：https://t3.tianditu.gov.cn/img_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=img&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TILECOL={x}&TILEROW={y}&TILEMATRIX={z}&tk=<tianditu key>
天地图遥感注记：https://t2.tianditu.gov.cn/cia_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=cia&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TILECOL={x}&TILEROW={y}&TILEMATRIX={z}&tk=<tianditu key>

WMTS:
Mapbox：https://api.mapbox.com/styles/v1/mapbox/streets-v11/wmts?access_token=<mapbox key>

WFS:
天地图：http://gisserver.tianditu.gov.cn/TDTService/wfs

注：Mapbox现在都用矢量瓦片了，还不知道怎么加
```

## 2.1 XYZ

地图底图发布服务通常是以瓦片的形式，一种提供调用的方式是按照“行、列、级别”三个参数确定一个瓦片图片，通常是X-列；Y-行；Z-级别。在QGIS中，用这样一个URL表示。如OSM地图的链接如下：

> [https://tile.openstreetmap.org/](https://link.zhihu.com/?target=https%3A//tile.openstreetmap.org/){z}/{x}/{y}.png

![img](https://pic4.zhimg.com/80/v2-fd3a306694809366ffa928e151b8c093_720w.jpg)

 

其效果为：

![img](https://pic1.zhimg.com/80/v2-38148fc4dda3f94b6e07cee63b12325c_720w.jpg)

 

### 2.1.1 XYZ链接的获取

一般如果网络地图是以XYZ的URL形式请求得到的话，获取一个请求示例即可还原出我们要的URL

- 首先推荐一个网站，集合了一些底图的xyz链接。[http://openwhatevermap.xyz/](https://link.zhihu.com/?target=http%3A//openwhatevermap.xyz/)
- 注意：
- 链接中的{s}可能需要手动补一下
- 部分链接可能由于网络原因加载的很慢或加不出来

![img](https://pic2.zhimg.com/80/v2-8ca1c551d5130b80ab0657f558ac75f1_720w.jpg)

下图的URL为：[http://a.tile.stamen.com/watercolor/](https://link.zhihu.com/?target=http%3A//a.tile.stamen.com/watercolor/){z}/{x}/{y}.jpg

![img](https://pic3.zhimg.com/80/v2-8aede62ce90c80cce4082953685f42d2_720w.jpg)

 

- 更可靠的方式是从浏览器开发者模式(F12-Network)中查看地图瓦片的真实请求地址并替换XYZ。
- 如打开OSM地图:[https://www.openstreetmap.org/](https://link.zhihu.com/?target=https%3A//www.openstreetmap.org/)
- 拖动地图使其发起瓦片请求，得到瓦片链接：[https://tile.openstreetmap.org/4/14/8.png](https://link.zhihu.com/?target=https%3A//tile.openstreetmap.org/4/14/8.png)
- 用XYZ替换相应位置得到我们要的URL：[https://tile.openstreetmap.org/](https://link.zhihu.com/?target=https%3A//tile.openstreetmap.org/){z}/{x}/{y}.png

![img](https://pic4.zhimg.com/80/v2-8d01de4e1f792607b608de7dfe50653f_720w.jpg)

 

![img](https://pic4.zhimg.com/80/v2-60193f11b886ec3220823bc9adf1e44f_720w.jpg)

## 2.2 WMTS服务，以Mapbox为例

[Add Mapbox maps as layers in ArcGIS and QGIS with WMTS](https://link.zhihu.com/?target=https%3A//docs.mapbox.com/help/tutorials/mapbox-arcgis-qgis/)

- 如该链接所述，可以用WMTS服务调用Mapbox底图，新建WMTS服务并配置URL为[https://api.mapbox.com/styles/v1/mapbox/streets-v11/wmts?access_token=](https://link.zhihu.com/?target=https%3A//api.mapbox.com/styles/v1/mapbox/streets-v11/wmts%3Faccess_token%3D)，其中需要自己到官网申请
- 一个WMTS服务是可以包括多个图层的

![img](https://pic3.zhimg.com/80/v2-edeec9ca7eec9ef960a6946a8a506d66_720w.jpg)

 

## 2.3 天地图(XYZ和WFS)

常用的底图包括OSM、Mapbox、GoogleMap、高德等，天地图是国家队做的一款电子地图，数据准确性上可能会更好一些，区别于百度、高德的加密坐标，天地图是WGS84的。

- 首先，获取XYZ，按照上文的方法可以得到天地图的demo链接，我们按照X-列；Y-行；Z-级别的方式得到天地图的XYZ链接

[https://t6.tianditu.gov.cn/vec_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=vec&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TILECOL=](https://link.zhihu.com/?target=https%3A//t6.tianditu.gov.cn/vec_w/wmts%3FSERVICE%3DWMTS%26REQUEST%3DGetTile%26VERSION%3D1.0.0%26LAYER%3Dvec%26STYLE%3Ddefault%26TILEMATRIXSET%3Dw%26FORMAT%3Dtiles%26TILECOL%3D){x}&TILEROW={y}&TILEMATRIX={z}&tk=

- 天地图现在也需要申请开发者key才能使用，注意选择js端(如果选择服务端会报错)

![img](https://pic1.zhimg.com/80/v2-09eb0bfa462321bf374a2230d816c288_720w.jpg)

 

- 天地图的其他数据资源：[http://lbs.tianditu.gov.cn/data/dataapi.html](https://link.zhihu.com/?target=http%3A//lbs.tianditu.gov.cn/data/dataapi.html)

包括交通、水系、居民地数据，但是都是综合过的所以粒度会比较粗，且数据可能比较旧。这里作为WFS的例子展示，这些数据以WFS服务形式提供矢量数据，如水系：

![img](https://pic1.zhimg.com/80/v2-0792afb2b204eb74a8eef8a051c737a8_720w.jpg)

 

![img](https://pic2.zhimg.com/80/v2-233832f3c9da00e48ddaa8bb4d5eddb5_720w.jpg)

## 2.4 插件

- 这里推荐一个QGIS的插件可以加载网络地图，并提供了搜索

![img](https://pic3.zhimg.com/80/v2-2e7f4355923f140c779419ac218db166_720w.jpg)