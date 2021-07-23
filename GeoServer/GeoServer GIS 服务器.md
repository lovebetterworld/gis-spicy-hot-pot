# GeoServer

Github地址：https://github.com/geoserver/geoserver



GeoServer 是基于 Java 的软件服务器，允许用户查看和编辑地理空间数据。使用开放[地理空间联盟（OGC）](http://www.opengeospatial.org/)提出的开放标准，GeoServer 在地图创建和数据共享方面具有极大的灵活性。

GeoServer允许您向世界显示您的空间信息。实施[Web地图服务（WMS）](http://www.opengeospatial.org/standards/wms)标准，GeoServer可以创建各种输出格式的地图。一个免费的地图库[OpenLayers](http://openlayers.org/)已集成到GeoServer中，从而使地图生成快速简便。GeoServer基于[GeoTools](http://geotools.org/)（一种开放源Java GIS工具包）构建。

除了样式精美的地图外，GeoServer还有很多其他功能。GeoServer符合[Web Feature Service（WFS）](http://www.opengeospatial.org/standards/wfs)标准和[Web Coverage Service（WCS）](http://www.opengeospatial.org/standards/wcs)标准，该标准允许共享和编辑用于生成地图的数据。GeoServer还使用[Web Map Tile Service](http://www.opengeospatial.org/standards/wmts)标准将您发布的地图拆分为图块，以方便Web地图和移动应用程序使用。

GeoServer是一个模块化应用程序，通过扩展添加了附加功能。[Web Processing Service](http://www.opengeospatial.org/standards/wps)扩展扩展了丰富的处理选项，您甚至可以编写自己的处理选项！

使其他人可以将您的数据整合到他们的网站和应用程序中，从而释放您的数据并提高透明度。



GeoServer是基于Java的，它的github topic说明了它涉及的东西：

* web 是作为web服务的
* mapping 测绘，绘图
* web-mapping 网络化地图
* java 使用Java开发
* wms 发布成wms服务
* wfs 同理
* wps 同理
* wcs 同理
* maps 多种地图服务



具备一下特征：
兼容WMS和WFS特性程序员

支持PostGIS、Shapefile、ArcSDE、Oracle、VPF、MySQL、MapInfogithub

支持上百种投影web

可以将网络地图输出为JPEG、GIF、PNG、SVG、KML等格式sql

可以运行在任何基于J2EE/Servlet容器之上数据库



# GeoServer工作流程

geoserver的工作流程是：
导入数据 --> 配置、发布图层. 

可选图层样式编辑，对地图样式编辑以满足用户的需求。

可建图层组，就是将多个图层组合管理，像一个图层一样使用。用户编辑样式可以自定义地图风格。

底层数据几乎支持所有的公开数据格式。


接下来的部分主要是参考资源里面的书。

空间数据如何存储和如何发布为地图的。

底层数据也支持postgis, oracle, mysql.

图层风格自定义，使用sld

>SLD是风格化图层描述器（Styled Layer Descriptor）的简称，是2005年OGC提出的一个标准，这个标准在一定条件下允许WMS服务器对地图可视化的表现形式进行扩展。在没有SLD之前，只能使用一些已经在服务器上规定好的样式来对地图进行可视化。而当使用了实现了SLD标准之后，它允许我们从客户端来对地图进行定义自己的样式，分级显示等操作，极大的扩展了地图可视化的灵活性。
>参考：https://www.cnblogs.com/naaoveGIS/p/4176198.html

支持GeoWebCache

通过rest interface control the GeoServer configuration.
这样就支持远端配置，比如用户自定义图层样式。

security module

支持多用户登录。



# GeoServer系列教程

简书：

- [GeoServer](https://www.jianshu.com/c/9b66660a9be9)

CSDN：

- 不睡觉的怪叔叔：[开源GIS](https://blog.csdn.net/qq_35732147/category_7819503_2.html)
- 韩慧兵：[WebGIS-GeoServer专题](https://blog.csdn.net/xiaohan2826/category_6550220.html)

腾讯云：

- Geoserver：[geoserver系列文章](https://cloud.tencent.com/developer/information/geoserver)



# GeoServer系列文章

- [GeoServer一：GeoServer的安装与初步使用](https://blog.csdn.net/qq_35732147/article/details/81869864) 

- [GeoServer二：使用GeoServer发布shapfile数据](https://blog.csdn.net/qq_35732147/article/details/81127068) 

- [使用GeoServer发布PostGIS中的数据](https://blog.csdn.net/qq_35732147/article/details/96154603)

- [GeoServer三：高级符号与图层组](https://blog.csdn.net/qq_35732147/article/details/81136267)