- [WMS、WFS、WCS、WPS、WMTS、WMSC、TMS等常见地图服务的区别](https://www.cnblogs.com/ssjxx98/p/12531525.html)



WebGIS的开发者经常需要面对各种地图服务规范，例如WMS、WFS、WCS、WPS、WMTS、TMS、WMSC等。因此了解这些服务的内容是相当重要的，这里对常见的服务进行了整理。

# OGC联盟

开放地理空间信息联盟 （Open Geospatial  Consortium-OGC），是一个非盈利的国际标准组织，致力于提供地理信息行业软件和数据及服务的标准化工作，它制定了数据和服务的一系列标准，GIS厂商按照这个标准进行开发可保证空间数据的互操作。OGC在1994年到2004年期间机构名为Open GIS Consortium， 后因业务需要更名为OGC。

# WMS服务

WMS是指OGC的**Web地图服务（Web Map Service）**规范，它利用具有地理空间位置信息的数据制作地图，将地图定义为地理数据可视的表现。详细信息可以参考[GeoServer官网的WMS介绍](https://docs.geoserver.org/stable/en/user/services/wms/index.html)。

WMS定义了一个规范的HTTP接口，支持标准HTTP协议的GET和POST请求，但多基于GET方式进行服务请求。能够根据用户请求返回相应的地图（包括**PNG，GIF，JPEG**等栅格形式或者是**SVG和WEB CGM**等矢量形式）。

GeoServer支持WMS 1.1.1 (WMS最广泛使用的版本)和WMS 1.3.0。这个规范定义了一系列操作（请求类型）：

| **Operation**               | **Description**                                              |
| --------------------------- | ------------------------------------------------------------ |
| Exceptions                  | If an exception occur                                        |
| GetCapabilities             | Retrieves metadata about the service, including supported operations and parameters, and a list of the available layers |
| GetMap                      | Retrieves a map image for a specified area and content       |
| GetFeatureInfo (optional)   | Retrieves the underlying data, including geometry and attribute values, for a pixel location on a map |
| DescribeLayer (optional)    | Indicates the WFS or WCS to retrieve additional information about the layer. |
| GetLegendGraphic (optional) | Retrieves a generated legend for a map                       |

- GetCapabilities返回服务级元数据，它是对服务信息内容和要求参数的一种描述；

  - 以一个xml文档形式返回服务级元数据：WMS的参数（图片格式、WMS版本兼容性）；图层（包围盒大小、坐标系统、数据位置以及是否透明）

  - 其参数包括：

    (1) **VERSION=version** ： WMS版本号 （没有指定时，使用当前服务提供商提供的最高的wms版本服务）

    (2) **SERVICE=WMS** ： 当前为WMS服务 （此项在1.3.0 版本中必须要求，之前的版本可选）

    (3) **REQUEST=GetCapabilities** ：请求名称

- GetMap返回一个地图影像，其地理空间参考和大小参数是明确定义了的；

  - 返回一个地图影像（包括PNG、

  - 其主要参数包括：

    (1) **VERSION=version**  ： WMS版本号

    (2) **REQUEST=GetMap** ：请求名称

    (3) **LAYERS=layer_list**  ： 请求图层，多个图层间用逗号分隔（如果SLD存在，该参数可选）

    (4) **STYLES=style_list**： 指定每个图层的渲染风格，多个图层间用逗号分隔（如果SLD存在，该参数可选）

    (5) **SRS=namespace:identifier** ： 空间坐标系统

    (6) **BBOX=minx,miny,maxx,maxy** ： 包围盒（SRS坐标）

    (7) **WIDTH=output_width** ： 图片宽度

    (8) **HEIGHT=output_height** ： 图片高度

    (9) **FORMAT=output_format** ： 图片格式

    可选参数有：

    (1) **SLD=sld_url** ： 图层样式描述文件的URL

    (2) **BGCOLOR=color_value**： 背景颜色 缺省是0xffffff（白色）

    (3) **TRANSPARENT=TRUE | FALSE** ：是否为透明，缺省是不透明

- GetFeatureInfo（可选）返回显示在地图上的某些特殊要素的信息。

- DescribeLayer（可选）图层描述信息

- GetLegendGraphic（可选） 获取Legend（图层管理器）的图片

# WFS服务

WFS是指OGC的Web矢量（要素）服务（Web Feature Service），返回的是矢量级的地理标记语言GML编码，并提供对矢量的**增加、修改、删除**等事务操作，是对Web地图服务的进一步深入。WFS通过OGC Filter构造查询条件，支持基于空间几何关系的查询，基于属性域的查询，还包括基于空间关系和属性域的共同查询。

WMS返回的是图层级的地图影像，而WFS是为了返回纯地理数据而设计的，它不包含任何关于绘制数据的建议。

详细信息可以参考[GeoServer官网的WFS介绍](https://docs.geoserver.org/stable/en/user/services/wfs/index.html)。

所有版本的WFS服务都定义了五个操作：

| Operation           | Description                                                  |
| :------------------ | :----------------------------------------------------------- |
| GetCapabilities     | Generates a metadata document describing a WFS service provided by server as well as valid WFS operations and parameters |
| DescribeFeatureType | Returns a description of feature types supported by a WFS service |
| GetFeature          | Returns a selection of features from a data source including geometry and attribute values |
| LockFeature         | Prevents a feature from being edited through a persistent feature lock |
| Transaction         | Edits existing feature types by creating, updating, and deleting |

- GetCapabilites返回Web矢量服务性能描述文档（用XML描述）；
- DescribeFeatureType返回描述可以提供服务的任何矢量结构的XML文档；
- GetFeature为一个获取矢量实例的请求提供服务；
- Transaction为事务请求提供服务；
- LockFeature处理在一个事务期间对一个或多个矢量类型实例上锁的请求

其他特定版本还定义了一些特有的操作，这里就不介绍了。

# WCS服务

WCS是指OGC的Web栅格服务（Web Coverage Service）面向**空间影像数据**，它将包含地理位置值的地理空间数据作为“**栅格或者说“覆盖”（Coverage）**”在网上相互交换。

详细信息参考[GeoServer官网的WCS介绍](https://docs.geoserver.org/stable/en/user/services/wcs/index.html)。

网络栅格服务由三种操作组成：GetCapabilities，GetCoverage和DescribeCoverageType。

- GetCapabilities操作返回描述服务和数据集的XML文档。
- GetCoverage操作是在GetCapabilities确定什么样的查询可以执行、什么样的数据能够获取之后执行的，它使用通用的栅格格式返回地理位置的值或属性。
- DescribeCoverageType操作允许客户端请求由具体的WCS服务器提供的任一覆盖层的完全描述。

# WPS服务

WPS是指OGC的网络处理服务Web Processing Server（WPS），一种用于在 Web 上提供和执行**地理空间处理**的国际规范。它为网络地理信息处理服务提供了标准化的输入和输出。GeoServer可通过安装插件支持该服务。

详细信息参考[GeoServer官网的WPS介绍](https://docs.geoserver.org/stable/en/user/services/wps/index.html)。

WPS 可用于：

- 使用即插即用的机制降低数据处理流程的复杂性。
- 连接不同的处理操作。
- 开发可以被其它用户重用的处理过程。
- 处理流程和模型集中与服务提供者，方便维护。
- 利用中央服务器集群的高运算性能。
- 方便对复杂模型的公共使用。

# WMTS服务

WMTS指OGC的Web地图瓦片服务（Web Map Tile Service），是OGC提出的缓存技术标准。WMTS标准定义了一些操作，这些操作允许用户访问[瓦片地图](https://baike.baidu.com/item/瓦片地图/8006049)，是OGC首个支持RESTful访问的服务标准。

WMTS提供了一种采用**预定义图块方法**发布数字地图服务的标准化解决方案。WMTS弥补了WMS不能提供分块地图的不足，在服务器端把地图切割为一定不同级别大小的瓦片（瓦片矩阵集合），对客户端预先提供这些预定义的瓦片，将更多的数据处理操作如叠加和切割等放在客户端，降低服务器端的载荷。

WMTS牺牲了提供定制地图的灵活性，代之以通过提供静态数据（基础地图）来增强伸缩性，这些静态数据的范围框和比例尺被限定在各个图块内。这些固定的图块集使得对WMTS服务的实现可以使用一个仅简单返回已有文件的Web服务器即可，同时使得可以利用一些标准的诸如分布式缓存的网络机制实现伸缩性。

WMTS接口支持的三类操作：

| Operation       | Required | Description        |
| --------------- | -------- | ------------------ |
| GetCapabilities | 是       | 获取服务的元信息   |
| GetTile         | 是       | 获取切片           |
| GetFeatureInfo  | 否       | 获取点选的要素信息 |

- 一个服务元数据（ServiceMetadata）资源（面向过程架构风格下对GetCapabilities操作的响应）（服务器方必须实现）。ServiceMetadata资源描述指定服务器实现的能力和包含的信息。在面向过程的架构风格中该操作也支持客户端与服务器间的标准版本协商。
- 图块资源（对面向过程架构风格下GetTile操作的响应）（服务器方必须实现）。图块资源表示一个图层的地图表达结果的一小块。
- 要素信息（FeatureInfo）资源（对面向过程架构风格下GetFeatureInfo操作的响应）（服务器方可选择实现）。该资源提供了图块地图中某一特定像素位置处地物要素的信息，与WMS中GetFeatureInfo操作的行为相似，以文本形式通过提供比如专题属性名称及其取值的方式返回相关信息

------

# OSGeo和OSGeo中国中心

OSGeo是指[开源空间信息基金会](https://www.osgeo.org/)(Open Source Geospatial Foundation，OSGeo)是一个全球性非营利性组织，目标是支持全球性的合作,建立和推广高品质的空间信息开源软件。

[OSGeo中国中心](https://www.osgeo.cn/)是由国家遥感中心发起、Autodesk中国有限公司协助，经OSGeo正式授权的非营利性组织。中心依托在国家遥感中心，与OSGeo理事会紧密合作。OSGeo中国中心的使命是支持开源地理信息软件和遥感软件的开发以及推动其更广泛的应用，尤其是帮助中国地区的用户和开发者更好地使用OSGeo基金会提供的源代码、产品及服务。

# WMS-C

WMS-C全称是Web Mapping Service - Cached，也被称为Web Maping Service Tile Cashe，对它完整的定义来源于[OSGeo Wiki](https://wiki.osgeo.org/wiki/WMS_Tile_Caching)，2006年在FOSS4G会议上提出讨论。目的在于提供一种预先缓存数据的方法，以提升地图请求的速度。它是由OSGeo制定，而非OGC的标准，而且自始至终都没有写入OGC之中。

WMS-C通过bbox和resolutions去决定请求的地图层级，为了更加直观的请求地图瓦片，一些软件做了一些改进，例如WorldWind在请求中使用level/x/y三个参数，直观明了。典型的基于WMS-C的实现是TileCache。

需要注意的是，**WMS-C目前已经被OSGeo Tile地图服务规范(TMS)和OGC Web地图服务标准(WMTS)取代**。

已经使用WMS-C规范的程序目前仍然被支持，但是如果编写新的应用程序，应该考虑TMS和WMTS。

# TMS

TMS是指OSGeo的切片地图服务规范（Tile Map Service），提供的操作允许用户按需访问切片地图。将切片保存到了本地，使得访问速度更快，还支持修改坐标系，是一种纯RESTful的服务。

TMS和WMTS在本质上非常类似，基本上遵循的是同一种切片规则。关于两种服务标准的区别与联系，可参考以下几篇博客：

[TMS和WMTS大概对比（转载）](https://editor.csdn.net/md/?articleId=104997308)

[整理一下常见几种地图服务](https://www.jianshu.com/p/5133093bc993)

[OpenStreetMap/Google/百度/Bing瓦片地图服务(TMS)](https://www.cnblogs.com/kekec/p/3159970.html)

------

概括地来说：

1. WMS：是一种**动态地图**服务，根据用户请求返回相应地图数据的可视化结果，实时切片，因此速度较慢。是GeoServer发布地图时较为常用的服务。
2. WMTS：是一种采用**预定义图块方法**发布数字地图服务，将地图切分成瓦片矩阵集合，牺牲了提供定制地图的灵活性，代之以通过提供静态数据（基础地图）来增强伸缩性，这些静态数据的范围框和比例尺被限定在各个图块内，但是提升了服务速度。例如我国的天地图就是使用这一服务进行组织的，详情见我另一篇博客：[关于天地图的瓦片下载](https://www.cnblogs.com/ssjxx98/p/10877692.html)。
3. WFS：是为了返回**纯地理数据**而设计的，它不包含任何关于绘制数据的建议，它提供了对矢量的**增加、修改、删除**等事务操作。
4. WCS：是面向**空间影像数据**服务，它将包含地理位置值的地理空间数据作为“**栅格或者说“覆盖”（Coverage）**”在网上相互交换。
5. WPS：我理解的是一种提供和执行**地理空间处理**的服务，用于在web上发起空间运算操作。
6. WMSC：是一种预先缓存数据的方法，以提升地图请求的速度。目前已被WMTS和TMS取代。
7. TMS：也是一种瓦片地图服务，与WMTS类似，本质上遵循同样的切片规则。

几种服务中比较常见的是WMS、WFS和WMTS、TMS。

# 参考资料：

https://www.jianshu.com/p/28a00c1faa59

https://blog.csdn.net/qq_35915384/article/details/54573525

https://www.cnblogs.com/kekec/archive/2013/06/11/3131729.html

https://blog.csdn.net/qq_18298439/article/details/93329098

https://baike.baidu.com/item/OGC/6466060?fr=aladdin

https://baike.baidu.com/item/WMTS/1091367?fr=aladdin

http://www.360doc.com/content/17/0829/15/3046928_683030533.shtml

https://docs.geoserver.org/stable/en/user/services/