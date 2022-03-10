- [优秀的开源GIS软件](https://www.cnblogs.com/hustshu/p/14757272.html)

> 本文转自 https://zhuanlan.zhihu.com/p/265023839
> 谈到GIS软件，首先让我们想到的便是GIS界的龙头大哥ESRI公司旗下的ArcGIS产品，从最初接触的version 9.2到如今的version 10.1，其发展可谓风生水起。MapInfo软件也不错，可是给人的感觉是渐渐被淘汰了似的，周围使用该软件的人并不算多。然后接触了一些的是国内的SuperMap软件，MapGIS软件等，很遗憾的是作为武大的学生，竟然没有使用过GeoStar的产品。这些产品在国内GIS中的份额几乎可以覆盖全部。

介于商业软件的昂贵，我等无产阶级学生自然是消费不起。不过借助网络的强大，如何免费地安装并使用这些商业软件已成为公共的秘密。至于版权问题，在学生范围也不必理会，只是在应用到商业开发时才会有所顾忌。

作为一个无知的Coder，很好奇这一个个地图是如何显示出来的，这一个个投影是如何体现到地图上的，这一系列数据是如何存储到Shapefile、存储到数据库中的，这一个个分析功能是如何解决的，等等。显然这些商业软件不会告诉你答案，他们提供的开发接口都是一个个黑箱。于是将触角转向开源软件界，试图去寻觅这些问题的答案。

回想以前做项目，写代码都缺少整理和归纳，等到用的时候却找不到先前的资料，理解也不够。因此决定通过写日志的方式，将这些信息都记录下来，做一番整理的工作。以下内容是查阅相关资料并结合个人理解总结的。

## 1.GIS开源软件简介

GIS的出现是上个世纪60年代的事，在当代众多IT缩写词出现之前，GIS已经在城市规划、土地管理、军事等行业得到了应用。GIS作为一门交叉学科，它的发展伴随着计算机技术的发展。随着软件的开源化趋势GIS软件也开向开源时代迈进。

不同于商业GIS软件，开源GIS软件不用背负数据兼容、易用性等问题的包袱，开发者能够集中精力于功能的开发，因此开源GIS软件普遍功能很强，技术也非常先进，其背后是来自技术狂热者和学院研究生的大力支持。

开源GIS软件目前已经形成了一个比较齐全的产品线。在[http://www.freegis.org](https://link.zhihu.com/?target=http%3A//www.freegis.org)网站上，我们会发现众多各具特色的GIS软件。老牌的综合GIS软件GRASS，数据转换库OGR、GDAL，地图投影算法库Proj4、Geotrans，也有比较简单易用的桌面软件Quantum GIS，Java平台上有MapTools，MapServer则是优秀的开源WebGIS软件。各种空间分析，模型计算尤其是开源GIS领域的强项。

开源GIS世界虽然繁荣，但其影响还是很小，其身份在外人眼里看来是高莫测的专业工具，现有的Linux发行版中也没有哪个集成了开源GIS工具。开源GIS技术虽然先进，但是缺乏良好的能够满足商用的发行版本，因此涉足开源GIS领域的多是技术爱好者和科学家，而少有商业人士问津。如果能提供一个比较系统的、达到商用要求的开源GIS解决方案，并能获得稳定发行版，如同Linux+Apache+MySQL+PHP那样，开源GIS前途将是不可限量。

## 2.当前较为成熟的GIS开源软件

## 2.1从开发结构角度看

一套GIS的完整开发框架，包括四个组成部分：标准层、数据库层、平台层和组间层。这四个部分从下到上，从底层到高层，共同构成一个完整的体系。

![pic_56610fa3.png](https://www.liangtengyu.com:9998/images/pic_56610fa3.png)

### 2.1.1标准层

标准层主要是用于制定各类标准。开放的GIS标准主要有两大体系：OGC([http://www.opengeospatial.org/](https://link.zhihu.com/?target=http%3A//www.opengeospatial.org/))、ISO/TC211([www.isotc211.org/](https://link.zhihu.com/?target=http%3A//www.isotc211.org/))。前者为那些法律上的国际组织制定的标准添加详细的实现标准，同时也在市场需要的时候扩展那些法律上的标准，其侧重于系统的实现上；后者所制订的ISO19100系列的地理信息标准，是属于基础性的标准，注重概念性规格叙述，独立于执行平台外。

其中，WKT(Well-Known Text)与WKB(Well-Known Binary)是OGC制定的空间数据的组织规范，顾名思义，WKT是以文本形式描述空间数据，而WKB是以二进制形式描述空间数据。目前大部分支持空间数据存储的数据库构造空间数据都采用这两种方式。

### 2.1.2数据库层

数据库层主要是采用开源地理信息标准采用开源方式开发的空间数据库项目，包括POSTGIS、MySQL空间扩展等。

《Simple Features specifications for SQL》是OGC制定的关于在基于SQL的关系数据库中存储空间数据标准。这个标准（如图）定义了数据类型、空间操作符号、输入和输出格式、函数以及其他。大多数SQL数据库的空间扩展都遵循这个标准，包括PostGIS和MySql空间扩展。

![pic_93d21da8.png](https://www.liangtengyu.com:9998/images/pic_93d21da8.png)

### 2.1.2.1PostGIS

PostGIS支持所有的空间数据类型，这些类型包括：点(POINT)、线(LINESTRING)、 多边形(POLYGON)、多点(MULTIPOINT)、 多线(MULTILINESTRING)、 多多边形(MULTIPOLYGON)和集合对象集(GEOMETRYCOLLECTION)等。PostGIS支持所有的对象表达方法，比如WKT和WKB。PostGIS支持所有的数据存取和构造方法，如GeomFromText()、AsBinary()，以及GeometryN()等。PostGIS提供简单的空间分析函数(如Area和Length)同时也提供其他一些具有复杂分析功能的函数，比如Distance。PostGIS提供了对于元数据的支持，如GEOMETRYCOLUMNS和SPATIAL REF SYS，同时，PostGIS也提供了相应的支持函数，如AddGeometryColumn和DropGeometryColumn。PostGIS提供了一系列的二元谓词(如Contains、Within、Overlaps和Touches)用于检测空间对象之间的空间关系，同时返回布尔值来表征对象之间符合这个关系。PostGIS提供了空间操作符(如Union和Difference)用于空间数据操作。比如，Union操作符融合多边形之间的边界。两个交迭的多边形通过Union运算就会形成一个新的多边形，这个新的多边形的边界为两个多边形中最大边界。

### 2.1.2.2MySql空间扩展

MySQL是世界上最流行的开源数据软件。MySQL从4.1开始引入了空间功能，实现和使用方式基本和POSTGIS类似。

### 2.1.3组件层

数据库组件层按照功能可分为两类：数据管理组件和分析组件。

### 2.1.3.1数据管理组件

(1)GDAL

GDAL(http://[www.gdal.org/](https://link.zhihu.com/?target=http%3A//www.gdal.org/))是一个基于C++的栅格格式的空间数据格式解释器。作为一个类库，对于那些用它所支持的数据类型的应用程序来说它代表一种抽象的数据模型。GDAL持大多数的栅格数据类型。

在开发上GDAL支持多种语言的接口如：Perl、Python、VB6、Java、C#。

(2)OGR

OGR([http://www.gdal.org/ogr/](https://link.zhihu.com/?target=http%3A//www.gdal.org/ogr/))是C++的简单要素类库提供对各种矢量数据文件格式的读取(某些时候也支持写)功能。OGR是根据OpenGIS的简单要素数据模型和Simple features for COM(SFCOM)构建的。OGC也支持大多数的矢量数据类型支持数类型。

(3) GeOxygene

GeOxygene([http://www.oxygene-project.sourceforge.net/](https://link.zhihu.com/?target=http%3A//www.oxygene-project.sourceforge.net/))基于Java和开源技术同时提供一个实现OGC规范和ISO标准可扩展的对象数据模型(地理要素、几何对象、拓扑和元数据)。它支持Java开发接口。数据存储在关系数据中(RDBMS)保证用户快速和可靠的访问数据，但用户不用担心SQL描述语句，他们通过为应用程序建立UML和Java代码的模型。在对象和关系数据库之间使用开源软件进行映射。到现在可以使用OJB同时支持Oracle和PostGIS中的数据。

(4) GML4J

GML4J([http://gml4j.sourceforge.net/](https://link.zhihu.com/?target=http%3A//gml4j.sourceforge.net/))是一个作用于Geography Markup Language(GML)的Java API工具。当前GM4J的作用是一个GML数据的扫描器。通过它可以读取和解释那代表地理要素、几何对象、它们的几何、要素的属性、集合对象的属性、复杂属性、坐标系统和其他的GML结构的XML。现阶段GML4J只支持GML读取和访问，在以后将支持GML数据的修改。

### 2.1.3.2分析组件

(1)JTS

JTS Topology Suite([http://sourceforge.net/projects/jts-topo-suite/](https://link.zhihu.com/?target=http%3A//sourceforge.net/projects/jts-topo-suite/))是一套2维的空间谓词和函数的应用程序接口。它由Java语言写成，提供了全的、延续的和健壮的基本的2维空间算法的实现，并且效率非常高。

Net Topology Suite(http;//[http://nts.sourceforge.net/](https://link.zhihu.com/?target=http%3A//nts.sourceforge.net/))则是一个.Net的开源项目，该项目的主要目的是将JTS Topology Suite应用程序提供给.Net应用程序使用。

(2) GSLIB

GSLIB([http://www.gslib.com/](https://link.zhihu.com/?target=http%3A//www.gslib.com/))是一个提供了空间统计的程序包，它是当前最强大和综合的一个统计包，并且具有灵活性和开放的接口。其缺点是缺少用户支持，用户界面不友好且缺少面向对象建模能力。

(3) PROJ.4

PROJ.4([http://trac.osgeo.org/proj/](https://link.zhihu.com/?target=http%3A//trac.osgeo.org/proj/))是一个开源的地图投影库，提供对地理信息数据投影以及动态转换的功能，WMS，WFS或WCS Services也需要它的支持。

(4)GeoTools

GeoTools([http://www.geotools.org/](https://link.zhihu.com/?target=http%3A//www.geotools.org/))是也是遵循OGC规范的GIS工具箱。它拥有一个模块化的体系架构，这保证每个功能部分可以非常容易的加入和删除。 GeoTools目标是支持OGC所有的规范并且各类国际规范和标准。

GeoTools已经在一个统一的框架下开发了一系列的JAVA对象集合，其完全满足了OGC的服务端的各种服务并且提供了OGC兼容的单独应用程序。GeoTools项目由一系列的API接口以及这些接口的实现组成。开发一整套产品或应用程序并不是GeoTools的目的，但是其鼓励其他应用项目使用它以各类工作。

[http://GeoTools.NET](https://link.zhihu.com/?target=http%3A//GeoTools.NET)(http:// [http://geotoolsnet.sourceforge.net/Index.html](https://link.zhihu.com/?target=http%3A//geotoolsnet.sourceforge.net/Index.html))则是与Java对应的.NET版本。

### 2.1.4平台层

平台层主要是构建在标准层、数据库层、中间件层基础上的可以扩展的系统框架。使用平台层可以简化我们搭建GIS框架的工作量。通过对平台的二次开发扩展可以让我们搭建基于GIS开放框架的GIS应用系统。平台多基于开源的GIS标准，同时兼容开源的空间数据库，与整个开放框架体有很好的兼容性。平台层根据应用的不同这里可以分为两大类：桌面平台、平台。桌面平台主要是指用于桌面应用的平台框架，web平台主要是指应于web应用的平台框架。

### 2.1.4.1桌面平台

(1)Grass GIS

GRASS(地理资源分析支持系统, [http://grass.fbk.eu/](https://link.zhihu.com/?target=http%3A//grass.fbk.eu/))是一个栅格／矢量GIS、图像处理系统和图件成图系统。GRASS包括超过350个程序和工具，实现：1)显示器和纸质地或图象的打印显示；2)操作栅格、矢量或点数据；3)处理多光谱图像数据；4)创建、管理和存储空间数据。GRASS支持图形界面或文字界面。 GRASS可以与商用打印机、绘图仪、数字化仪或商用数据库交互。

GRASS基于GNUGPL协议下发行，有超过100万行的C源代码可以自下载得到。GRASS提供了一个复杂的GIS库，可用于开发自己的项目。

(2)OSSIM

OSSIM([http://www.ossim.org/](https://link.zhihu.com/?target=http%3A//www.ossim.org/))是一个用于遥感、图片处理、地理信息系统、照相测量方面的高性能软件。OSSIM库主要使用C++完成，支持多种平台，现在包括Linux、dows、MacOS X和Solaris，并且可以移植到其他平台。由于OSSIM库用了模型一控制器一视图(MCv)的结构，所以算法及实现与GUI是分离的，使得OSSIM可以支持多种GUI接口。第一个GUI的实现使用了QT，其的GUI框架及接口也在开发计划中(如Cocoa/Windows等)。

(3)SharpMap

SharpMap([http://www.codeplex.com/SharpMap](https://link.zhihu.com/?target=http%3A//www.codeplex.com/SharpMap))是一个基于.net 2.0使用c#开发的Map渲染类库，可以渲染各类GIS数据(目前支持ESRIShape和PostGIS格式)，可应用于桌面和Web程序。目前稳定版本为0.9(2.0beta已发布)，代码行数10000行左右，实现了下功能：

①支持的数据格式：PostGreSQL/PostGIS，ESRI Shapefile，支持WMS layers，支持ECW 和JPEG2000 栅格数据格式；
②Windows Forms 控件，可以移动和缩放；
③通过HttpHandler支持[http://ASP.net](https://link.zhihu.com/?target=http%3A//ASP.net)程序；
④点、线、多边形、多点、多线和多多边形等几何类型和几何集合（GeometryCollections）等OpenGIS Simple Features Specification；
⑤可通过Data Providers（增加数据类型支持）、Layer Types（增加层类型）和Geometry Types等扩展；
⑥图形使用GDI+渲染，支持anti-aliased等；
⑦专题图。

SharpMap目前可以算是一个实现了最基本功能的GIS系统，但一些很重要的功能，例如投影，比例尺，空间分析，图形的属性信息，查询检索等等，通过同NTS等开源空间类库的结合可以在SharpMap中实现的空间变换、缓冲区等功能。

(4) World Wind

World Wind([http://worldwind.arc.nasa.gov/](https://link.zhihu.com/?target=http%3A//worldwind.arc.nasa.gov/))是个开放软件，允许用户修改WorldWind软件本身。软件用C#编写，调用微软SQLServer影像库TerrainServer进行全球地形三位显示，低分辨率的Blne marble数据包含的初始安装内，当用户放大到特定区域时，附加的高分辨率数据将会自动从NASA服务器上下载。它通过将遥感影像与RTM高程(航天飞机雷达地形数据库)叠加生成三位地形。在功能方面，软件具有长度测量功能(仅能测量两点间的直线距离)、坐标和高程查询、屏幕截图、添加标注及三位动态显示等功能。

(5) MapWindow

MapWindow GIS([http://mapwindow4.codeplex.com/](https://link.zhihu.com/?target=http%3A//mapwindow4.codeplex.com/))桌面应用程序是一个免费开源基于标准的地理信息软件，使用它可以浏览和编辑多种GIS数据格式。这个软件包括很多地理处理的插件如：缓冲分析、合并处理等，也可以使用脚本编辑器编写VB.NET和C#的脚本。最新版本的MapWindow应用程序完全基于.NET2.0平台和C#。现在又开发出了MapWindow.Web可以让用户更容易开发基于ASP.Net的web应用。这样MapWindow逐渐形成一个完整的体系，从开发嵌入式系统的MapWinGIS.OCX到应用程序框架的MapWindow应用程序再到发布web程序的MapWindow.web。

MapWindow 6([http://mapwindow6.codeplex.com/](https://link.zhihu.com/?target=http%3A//mapwindow6.codeplex.com/))是在MapWindow 4的基础上进行改进，整个框架采用C#完成，代码完整清晰，其优点是：

①完全采用.net平台（不需要COM注册或DLL加载）；

②可以通过使用Mono运行在Mac或Linux平台上；

③大量扩展了符号集，点、线、面的符号化更丰富，而且可以基于属性内容进行专题化，同时支持矢量化的字体符号；

④面向对象的代码：直接对各要素进行重叠分析、相交分析等。支持OGC的几何对象模型，基于System.Data.DataTable的数据集；

⑤可兼容的插件模式：插件的接口就像普通对象的事件对象一样；

⑥组件模式：所有的组件通过MapWindow.dll提供，能够拖放控件就可以定制GIS程序。

### 2.1.4.2 Web平台

(1)GeoServer

GeoServer([http://geoserver.org/](https://link.zhihu.com/?target=http%3A//geoserver.org/))是一个符合J2EE规范，且实现了WCS、WMS及WFS规格，支持TransactionWFS(WFS-T)，其技术核心是整合了颇负盛名的JavaGISolkit--GeoTools。对于空间信息存储，它支持ESRI Shapefile及PostGIS、Oracle、ArcSDE等空间数据库，输出的GML档案满足GML2.1的要求。由于它是纯Java的，所以更适合于复杂的环境要求，而且由于它的开源，所以开发组织可以基于GeoServer灵活实现特定的目标要求，而这些都是商业GIS组件所缺乏的。

GeoServer作为一个纯粹的Java实现，被部署在应用服务器中，简单的如Tomcat等；它的WMS和WFS组件响应来自于浏览器或uDig的请求，访问配置的空间数据库，如PostGIS、OracleSpatial等，产生地图和GML文档传输至客户端。

(2)MapServer

MapServer([http://mapserver.org/](https://link.zhihu.com/?target=http%3A//mapserver.org/))基于C语言，利用GEOS、OGR／GDAL对多种失量和栅格数据的支持，通过Proj.4共享库实时的进行投影变换。同时，还集合PostGIS和开源数据库PostgreSQL对地理空间数据进行存储和SQL查询操作，基于ka.map、MapLab、Cartoweb和Chameleon等一系列客户端JavaScfiptAPI来支持对地理空间数据的传输与表达，并且遵守开放地理空间协会(Open Geospatial Consortium，OGC)制定的WMS、WFS、WCS、WMC、SLD、GML和FilterEncoding等一系列规范。对不同项目的借鉴和运用，增强了MapServer的功能，并使开发团队更多地关注于网络制图的核心功能。

MapServer是一套用来构建空间网络应用的开源开发环境，并不是一套全能的GIS系统，它更擅长于在网络上展示空间数据，在服务器端实时的将地理空间数据处理成地图发送给客户端。MapServer拥有一个庞大的社区，并有一个来自全球的近20名核心开发人员以致力于产品的维护和增强。同时还有各种不同的组织机构为MapServer的开发和维护提供资助。

(3) Mapnik

Mapnik([http://mapnik.org/](https://link.zhihu.com/?target=http%3A//mapnik.org/))是一个用于开发地图应用程序的工具。Mapnik用C++写同时有Python绑定接口。使用Mapnik可以很方便的进行桌面和web应用程序开发。

Mapnik主要提供地图的渲染功能，使用AGC库同时提供世界级的标注引擎。可以说Mapnik是现在最强大的开源地图渲染工具。

(4) OpenLayers

OpenLayers([http://openlayers.org/](https://link.zhihu.com/?target=http%3A//openlayers.org/))是一个开源的jS框架，用于在您的浏览器中实现地图浏览的效果和基本的zoom，pan等功能。OpenLayers支持的地图来源包括了WMS，GoogleMap，KaMap，MSVirtualEarth等等，您也可以用简单的图片作为源，在这一方面OpenLayers提供了非常多的选择。此外，OpenLayers实现了行业标准的地理数据访问方法如OGC的Web Mapping Service(WMS)and Web Feature Service(WFS)协议。OpenLayers可以简单的在任何页面中放入动态的地图。它可以从多种的数据源加载显示地图。MetaCarta公司开始开发了OpenLayers的初始版本同时将它开放给了公众以作为以后各种地理信息系统的应用。

(5) TileCache

TileCache([http://tilecache.org/](https://link.zhihu.com/?target=http%3A//tilecache.org/))是一个实现WMS.C的标准的服务器， TileCache提供了一个基于PythonTile的WMS.C/TMS服务器，同时具有开可插入的缓存和后台渲染机制。在最简单的应用中，只要求TileCache可以访问磁盘可以运行Python的CGI脚本。同时可以连接需要缓存的WMS服务。使用这些资源，你可以创建任何WMS服务在你的本地硬盘的缓存，同时使用支持WMS-C标准的客户端如：OpenLayers或任何支持TMS的客户端如：OpenLayers和wordKit就可以访问这些缓存数据。

## 2.2从语言派系角度看

从软件底层的开发语言角度讲，开源空间信息软件可以被独立的分为以下三种技术体系门类，在每种分类体系内部，开发人员往往是基于不同的项目交叉工作的，所以这种分法仅仅是方便了熟悉某种开发语言的程序员，对于用户和应用人员而言, 意义不大。

| 语言  | 开源软件                                                     |
| ----- | ------------------------------------------------------------ |
| C/C++ | GRASS、GDAL、OGR、GSLIB、OSSIM、Proj4、QGIS、MapWindow4、MapServer、Mapnik等 |
| Java  | GeoTools、GeOxygene 、GML4J、MapTools、GeoServer、JTS等      |
| .NET  | NetTopologySuite、[http://GeoTools.NET](https://link.zhihu.com/?target=http%3A//GeoTools.NET)、SharpMap、World Wind、MapWindow6等 |
| 脚本  | OpenLayers、TileCache等                                      |

一、桌面GIS软件：

QGIS（基于Qt使用C++开发的跨平台桌面软件，最新版本已经整合了网络分析等GIS常用功能） [http://www.qgis.org/](https://link.zhihu.com/?target=http%3A//rrurl.cn/fn0Ymi)

Grass（桌面经典GIS软件，显示引擎使用cario） [http://grass.fbk.eu/](https://link.zhihu.com/?target=http%3A//rrurl.cn/bz8hb2)

二、数据采集与表达：

OpenStreetMap自发式地理信息采集和表达平台 [http://www.openstreetmap.org/](https://link.zhihu.com/?target=http%3A//rrurl.cn/cMUjm2)

三、2-2.5D地图制图工具：

Mapnik(C++)（OpenStreetMap地图用mapnik渲染，显示引擎使用AGG，效率与美感优秀）: [http://mapnik.org/](https://link.zhihu.com/?target=http%3A//rrurl.cn/qx99pl)

OpenMap(Java): [http://openmap.bbn.com/](https://link.zhihu.com/?target=http%3A//rrurl.cn/s6xCqM)

四、3D地图制图工具：

OSGGIS(C++): [http://wush.net/trac/osggis](https://link.zhihu.com/?target=http%3A//rrurl.cn/p4Fva5)

五、互联网地图客户端：

openlayers(Javascript): [http://openlayers.org/](https://link.zhihu.com/?target=http%3A//rrurl.cn/j6dBdB)

openscales(Flex): [http://openscales.org/](https://link.zhihu.com/?target=http%3A//rrurl.cn/mPk1p2)

六、移动互联网地图客户端：

Navit(C语言开发，高效率稳定): [http://www.navit-project.org/](https://link.zhihu.com/?target=http%3A//rrurl.cn/6gpPex)

GpsDrive(C): [http://www.gpsdrive.de/](https://link.zhihu.com/?target=http%3A//rrurl.cn/5zNudh)

Gpsvp（智能手机导航软件） [http://code.google.com/p/gpsvp/](https://link.zhihu.com/?target=http%3A//rrurl.cn/uNEfa6)

LuckyGPS（C++开发，整合了最经典的CH路径规划算法是一款经典的导航软件） [http://wiki.openstreetmap.org/wiki/LuckyGPS](https://link.zhihu.com/?target=http%3A//rrurl.cn/g0RymN)

七、位置服务：

sse4j(Java开发的提供地理信息数据源构建的垂直搜索引擎应用接口、针对在线地图服务(互联网或移动互联网)的服务端，能够提供POI搜索、道路搜索、区域搜索、地址匹配、路径规划、公交换乘和无线定位等功能): [http://code.google.com/p/sse4j/](https://link.zhihu.com/?target=http%3A//rrurl.cn/k2gTv5)

八、WEBGIS客户端：

Cesium：

FGMAP（FGMap是一个仿Google Maps API for Flash 做的WebGIS客户端组件，允许 Flex 开发人员将 Google Maps，MapABC地图，Bing地图，QQ地图 嵌入到 Flash 应用程序中。而不需要使用KEY或验证） [http://code.google.com/p/fgmap-webgis/](https://link.zhihu.com/?target=http%3A//rrurl.cn/8NBgeA)

OSGEO组织内涵盖多数有代表性GIS开源项目，这些GIS开源项目专业性很强（例如）。

Web Mapping：

deegree [http://www.deegree.org/](https://link.zhihu.com/?target=http%3A//rrurl.cn/jSYdb0)

geomajas [http://www.geomajas.org/](https://link.zhihu.com/?target=http%3A//rrurl.cn/akxwjM)

GeoServer [http://geoserver.org/display/GEOS/Welcome](https://link.zhihu.com/?target=http%3A//rrurl.cn/cNEL01)

Mapbender [http://www.mapbender.org/](https://link.zhihu.com/?target=http%3A//rrurl.cn/sO5xvg)

MapBuilder [http://communitymapbuilder.osgeo.org/](https://link.zhihu.com/?target=http%3A//rrurl.cn/ggNU60)

MapFish [http://www.mapfish.org/](https://link.zhihu.com/?target=http%3A//rrurl.cn/q4MUfk)

MapGuide Open Source [http://mapguide.osgeo.org/](https://link.zhihu.com/?target=http%3A//rrurl.cn/vClr9w)

MapServer [http://www.mapserver.org/](https://link.zhihu.com/?target=http%3A//rrurl.cn/m5Rvty)

OpenLayers [http://openlayers.org/](https://link.zhihu.com/?target=http%3A//rrurl.cn/j6dBdB)

Desktop Applications：

GRASS GIS [http://grass.osgeo.org/](https://link.zhihu.com/?target=http%3A//rrurl.cn/v5hsh4)

Quantum GIS [http://www.qgis.org](https://link.zhihu.com/?target=http%3A//rrurl.cn/fn0Ymi)

gvSIG [http://www.gvsig.org](https://link.zhihu.com/?target=http%3A//rrurl.cn/nNALfO)

Geospatial Libraries：

FDO [http://fdo.osgeo.org/](https://link.zhihu.com/?target=http%3A//rrurl.cn/6Sgjum)

GDAL/OGR [http://www.gdal.org/](https://link.zhihu.com/?target=http%3A//rrurl.cn/fAYZoD)

GEOS [http://trac.osgeo.org/geos/](https://link.zhihu.com/?target=http%3A//rrurl.cn/hypMrU)

GeoTools [http://www.geotools.org/](https://link.zhihu.com/?target=http%3A//rrurl.cn/nzlK66)

MetaCRS [http://trac.osgeo.org/metacrs/](https://link.zhihu.com/?target=http%3A//rrurl.cn/8lg1d5)

OSSIM [http://www.ossim.org/](https://link.zhihu.com/?target=http%3A//rrurl.cn/uhkEmy)

PostGIS [http://www.postgis.org/](https://link.zhihu.com/?target=http%3A//rrurl.cn/16Nx5C)

Metadata Catalog：

GeoNetwork [http://geonetwork-opensource.org](https://link.zhihu.com/?target=http%3A//rrurl.cn/5RkUiM)

Other Projects：

Public Geospatial Data [http://www.osgeo.org/geodata](https://link.zhihu.com/?target=http%3A//rrurl.cn/t5I8hC)

Education and Curriculum [http://www.osgeo.org/](https://link.zhihu.com/?target=http%3A//rrurl.cn/7DsLuS)[education](https://link.zhihu.com/?target=http%3A//rrurl.cn/7DsLuS)