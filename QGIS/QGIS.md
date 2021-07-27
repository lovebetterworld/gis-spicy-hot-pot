# 一、QGIS的简单介绍

  QGIS（原称Quantum GIS）是一个用户界面友好的**开源**桌面端软件，支持数据的可视化、管理、编辑、分析以及印刷地图的制作，并支持多种矢量、栅格与数据库格式及功能。

  QGIS可运行在Linux、Unix、Mac OSX和Windows等平台之上。QGIS是基于跨平台的图形工具Qt软件包、使用C++开发的跨平台开源版桌面地理信息系统。

  QGIS的目标是成为一个使用简单的GIS，提供了常见的功能。QGIS是开源GIS的集大成者，整合了GRASS、SAGA GIS等多个开源桌面软件工具。

  QGIS使用GNU（General Public License）授权，属于Open Source geospatial Foundation（OSGeo）的官方计划。在GNU这个授权下，开发者可以自行检阅与调整程序代码，并保障让所有使用者可以免费且自由地修改程序。

   QGIS是一群自愿者所开发的项目，欢迎全球使用者或开发者将程序代码的缺陷、修复、报告以及提供文件等进行提交贡献。它是由热心的使用者和开发社群所维护的。它提供了交互式的邮件列表，以及通过网络管道传达给其他用户与开发人员帮忙与建议。另外，它也提供商业定制化开发。

# 二、QGIS的历史发展

  2002年Gary Sherman为了找一个适合Linux且可以提供多种数据的读取的GIS系统，于是在5月构想出Quantum  GIS，并和一些有兴趣的GIS程序开发人员开发出QGIS。2002年6月QGIS项目建立在SourceForge上，第一个功能则是支持显示PostGIS提供的数据图层。

  尽管刚开始的目标只是提供用户一个可以浏览GIS数据的界面，但随着需求不断的增大，QGIS目前已经能够支持多种格式的矢量、栅格数据的浏览，以及扩展性高的附加组件。目前QGIS已经有图形化且相当友好的使用界面。

  Qunamtum GIS的名字开头使用Q字母主要是因为QGIS使用了trolltech.com的Qt软件包。

# 三、QGIS的要功能特点

1. 支持多种GIS数据文件格式，通过GDAL/OGR（以后介绍）扩展可以支持多达几十种数据格式。
2. 支持PostGIS数据库。
3. 支持从WMS、WFS服务器中获取数据。
4. 集成了GRASS的部分功能。
5. 支持对GIS数据的基本操纵，如属性的编辑、修改等。
6. 支持创建地图。
7. 通过插件的形式支持功能的扩展

## 3.1 支持数据格式

矢量资料：支持 PostgreSQL/PostGIS，以及 OGR 函式库，包含 ESRI Shapefiles、MapInfo、SDTS 和 GML.

栅格资料：支援 GDAL 函式库，如 GeoTiff、Erdas Img.、ArcInfo Ascii Grid、JPEG、PNG。

支持 GRASS 栅格与矢量数据，同时也支持在线 OGC 数据 Web Map Service（WMS）、Web Map Tile Service、(WMTS)、Web Feature Service（WFS）

## 3.2 浏览数据与地图设计

- 投影坐标实时转换
- 识别/选取图征
- 编辑/检视属性
- 图征文字标签
- 出图设计
- 空间书签

## 3.3 建立、编辑、管理与输出数据

- 支持 OGR 格式及 GRASS 的数化工具
- 建立、编辑 Shapefiles 和 GRASS 矢量图层
- 图像数据定位
- 从 GPS 下载航迹、航线、航点及展示
- Shapefiles 汇出至 PostGIS 图层
- 附加组件 Table Manager 提供属性表管理功能

## 3.4 数据分析

- 透过 PostgerSQL/PostGIS 分析空间数据
- fTools 附加组件提供 OGR 数据格式空间分析
- 使用 GRASS 的功能进行空间分析（超过 300 个模块）

## 3.5 附加组件

- 加入 WFS 图层
- CSV 文本文件汇入
- 坐标撷取
- 加入指北针、比例尺、版权标签
- 图像定位
- Dxf Shp 转换
- GPS 工具
- GRASS 整合
- 地图格网建立
- 内插工具
- OGR 数据转换
- 快速打印
- Shapefile 汇入到 PostgreSQL/PostGIS
- 输出至 Mapserver 格式

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image57.jpg)

图: QGIS与周边相关软件关系图

## 3.6 操作GUI

Quantum GIS 共分为六部分，第一部分为选单列，第二部分为工具栏，第三部分为图层管理，第四部分为图层展示窗口，第五部分为图层全览图，第六章状态栏。

**选单列**

提供下拉式选单，用户所需的功能大都可以在此选单中找到。

**工具栏**

将选单功能以图形化的接口表示，让用户可以更快速地执行所需功能。用户可以依自己的喜好将工具栏固定在界面上或拉出来浮动使用。

**图层管理**

显示加入 QGIS 的各类图层，包含矢量与栅格图层。使用者可以透过此调整图层的排序、显示与否。并可直接在此调整图层属性。

**图层展示窗口**

透过平移、放大、缩小等功能检视图层内容。

**状态栏**

显示坐标值、比例尺、绘图功能的标示、快速启动坐标设定

**属性表格**

检视图层属性。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image58.jpg)

图:操作界面



# 四、QGIS相对于ArcGIS的优势

1. 安装包下，只有ArcGIS的十分之一，但是功能超过ArcGIS的十分之一

2. 无需授权，不需要像破解ArcGIS一样破解软件，而且破解后的ArcGIS有些扩展功能也用不了。

3. 由于我们平时用的功能百分之八十都是基础功能，所以QGIS足够满足日常需要

4. 跨平台，随着Linux和Mac的市场份额不断提升，跨平台连微软都在考虑，ESRI也迟早要考虑。



# 五、相关QGIS参考资源 

## 5.1 相关链接

QGIS 官网：http://www.qgis.org/

下载网站：http://download.qgis.org

WiKi：http://wiki.qgis.org/qgiswiki

Blog：http://blog.qgis.org/

讨论区：http://forum.qgis.org/

电子信箱：info@qgis.org

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image59.jpg)

图： QGIS官网

另外，Ominiverdi.Org整合了 GIS Live CD，包含的软件有 GRASS、QGIS、PostgreSQL/PostGIS、GDGDAL、Proj、R…等等，且附上 QGIS、GRASS、PostGIS 的范例数据提供练习。

1. Ominiverdi.Org：http://ominiverdi.org
2. 下载 LiveCD：http://live.osgeo.org

## 5.2 国内QGIS参考资料

（台湾）中央研究院人社中心地理信息研究专题中心提供 Quantum GIS 部落格交流平台，内容包括 QGIS 的中文操作功能解说，汉化文件，以及繁体中文套件下载等。