- [开源WebGIS架构](https://www.cnblogs.com/wangsongbai/p/13444667.html)

目前国际上著名的地理空间信息生产商大都拥有了成熟的产品线，  基本涵盖了从数据采集、数据编辑、数据管理、空间数据互操作、空间分析到网络地理信息服务注册、发布、聚合等所有地理信息工程相关的功能模块  。有时候，在商业软件价格比较昂贵的情况下，使用开源WebGIS也是一个不错的选择。

一套WebGIS架构方案包含以下三个部分：

# 一、WebGIS架构

## 1.1 地理信息数据库和业务数据库

- 地理信息数据库用于存储地理信息数据（包含矢量、地名地址、专题及瓦片数据）；

- 业务数据库用于存储前端网站或者行业应用的关系型数据；

## 1.2 GIS服务器              

- GIS服务器则用于提供WMS、WTMS、WFS和WCS等GIS服务；

## 1.3 Web应用服务器

 Web应用服务器主要针对行业应用，用于调取GIS服务和后台的业务数据，并在前端展示。

 提供Web信息浏览服务，通常你看到的是一个网站。

## 1.4 开源WebGIS解决方案

针对WebGIS以上组成部分，一套开源WebGIS有着相应的解决方案，其架构方式如下 ：

- <font color='red'>数据生产（桌面软件--uDig、QGIS等）</font>

- <font color='red'>数据存储（关系型或非关系型数据库：postgreSQL、mySQL、mongodb）</font>

- <font color='red'>GIS服务（GIS服务器：mapserver、Geoserver）</font>

- <font color='red'>Web服务（Web服务器：tomcat、apache、nginx）</font>

- <font color='red'>前端渲染（OpenLayers ）</font>

当然还需要提供这一整套架构方式的外围软件环境：

- 虚拟化或者云环境(*VirtualBox、OpenStack、docker*)

- 操作系统（linux：centos、ubuntu）

### 1.4.1 地图数据生产

- 使用[uDig](http://udig.refractions.net/)、[QGIS](http://www.qgis.org/)、Grass等开源桌面GIS软件采集、加工地理信息数据

- [uDig](http://udig.refractions.net/)：http://udig.refractions.net/

- [QGIS](http://www.qgis.org/)：https://www.qgis.org/

- Grass：https://grass.osgeo.org/

- OpenEV：http://openev.sourceforge.net/

- gvSIG ：[http://www.gvsig.com/](http://www.gvsig.com/en/products/gvsig-desktop/downloads)

- OpenJUMP：http://www.openjump.org/

- OSSIM：http://trac.osgeo.org/ossim/

- InterImage：http://www.lvc.ele.puc-rio.br/projects/interimage/（专注影像解译）

- PolSARPro：https://earth.esa.int/web/polsarpro（极化雷达处理）

- E-foto：http://www.efoto.eng.uerj.br/en 航空摄影测量



### 1.4.2 地理信息数据存储

关系型数据使用PostGIS或者MySQL Spatial数据库存储地理信息数据和关系型业务数据，

- 非关系型数据使用mongodb数据库（瓦片、图像）

- PostGIS：http://postgis.net/

- PostgreSQL：https://www.postgresql.org/

- MySQL：[https://www.mysql.com](https://www.mysql.com/)

- mongodb ： https://www.mongodb.com/

- rasdaman：http://www.rasdaman.org/ （栅格数据库）

- SpatiaLite:http://www.gaia-gis.it/gaia-sins/ (轻量级数据库SQLite空间扩展)



### 1.4.3 GIS服务器

使用GeoServer、MapServer生产地图瓦片，注册、发布地理信息服务。

- GeoServer：http://geoserver.org/

- MapServer：http://mapserver.org/

- Mapnik：http://mapnik.org/

- TileCache：http://tilecache.org/

- MapTiler:https://www.maptiler.com/

### 1.4.4 Web服务器应用

使用Geomajas、Tomcat或apache搭建网站，在网页中嵌入地图容器加载地图；使用niginx作为反向代理或者负载均衡。               

- Tomcat：http://tomcat.apache.org/ （网站服务器）

- apache:https://www.apache.org/(apache即可做网站服务器又可作反向代理、负载均衡)

​                [nginx](http://nginx.org/)： http://nginx.org/  （负载均衡、反向代理）

- 地图网站专用服务器

- GeoMoose：https://demo.geomoose.org/ 

- Geomajas：http://www.geomajas.org/ 

### 1.4.5 个人客户端或者web应用服务器的前端展示：

地理信息服务使用OpenScales、支持Javascript的Openlayers或Leaflet地图容器前端展示。前端其他数据展示使用Javascript、vue等流行网页API。

- openlayers(Javascript): [http://openlayers.org/](http://rrurl.cn/j6dBdB)

- openscales(Flex): [http://openscales.org/](http://rrurl.cn/mPk1p2)

- LeafLet：[ ](http://leafletjs.com/index.html)[https://leafletjs.com](https://leafletjs.com/download.html)

注：这里的web应用服务器相对于GIS服务器而言是客户端，相对于浏览者而言是服务器。



以上给出使用开源软件实现WebGIS各个环节可采用的软件，在实际项目中，应根据项目需要做一下筛选。

比如：<font color='red'>uDig (QGIS)+ PostgreSQL/PostGIS （mongodb）+ GeoServer + Tomcat +Openlayers组合。</font>

倘若有高性能、高可用的需求，还应使用集群技术，搭建数据库集群、GIS服务器集群和web应用服务器集群生态，增加服务的冗余，提高服务性能，毕竟地图服务不是简单的网页服务，其消耗的资源是非常大的，即便是一个空间查询语句，对数据库的性能消耗也是非常可观的。

# 二、开源地理数据函数库

以下列出所有开源软地理信息软件或者商业地理信息软件都可能有到的开源地理信息函数库。其中，GDAL/ORG、PROJ.4、GEOS是地理信息软件或者系统开发的三架马车，它们搭建了地理信息软件的基础。

- GDAL/OGR:https://gdal.org/ 开源栅格/矢量空间数据转换库

- PROJ.4:https://proj.org/ 地图投影库

- GEOS:http://trac.osgeo.org/geos 开源地理空间数据引擎

- pyshp:https://pypi.org/project/pyshp/ 用于处理shapfile的简单函数库

- Shapely:https://pypi.org/project/Shapely/ 基于[ GEOS](https://trac.osgeo.org/geos/)，用于操作和分析平面几何对象的函数库

- Fiona:https://pypi.org/project/Fiona/ 基于GDAL,用于读取空间矢量数据的函数库

- Rasterio:https://pypi.org/project/rasterio/ 基于GDAL和Numpy，用于读取地理空间栅格数据的函数库

- PIL:https://pypi.org/project/PIL/  用于处理影像的python库

- NumPy：https://pypi.org/project/numpy/ 用于矩阵科学计算的函数库

- [Scikit-image](https://github.com/scikit-image/scikit-image)：基于scipy的一款图像处理python库

- GeoPandas:http://geopandas.org/ 用于空间分析的函数库

- SPy:http://www.spectralpython.net/ 用于高光谱遥感影像处理的python库

- GML4J：http://gml4j.sourceforge.net/ 用于读取[gml](http://gml4j.sourceforge.net/)数据的函数库

- GSLIB：http://www.gslib.com/ 用于空间统计的函数库

- JTS：https://sourceforge.net/projects/jts-topo-suite/ （支持JAVA的空间分析包）

- GeoTools：https://www.geotools.org/ （支持JAVA的地理处理工具箱） 

-  GeoMesa：https://www.geomesa.org/ 分布式时空大数据分析工具，配合hadoop使用



# 三、开放网络地图引擎

- OSM:[https://www.openstreetmap.org/](https://www.openstreetmap.org/#map=4/36.96/104.17) 地图

- Navit:https://www.navit-project.org/   导航

# 四、开放三维引擎

- Cesium：https://cesium.com/

- OSG earth:http://www.openscenegraph.org/

- ogre:https://www.ogre3d.org/

- marble[:https://marble.kde.org/](https://marble.kde.org/)



# 五、开放地理处理工具

- GeoTools：https://www.geotools.org/ 地理处理工具箱

- GeoNetwork：https://geonetwork-opensource.org/ 网络地图查看和目录工具

- Orfeo ToolBox：https://www.orfeo-toolbox.org/ 可以处理TB级的高分辨率光学，多光谱和雷达图像。

# 六、开放协会或组织

- https://www.osgeo.org/ 开源地理空间基金会

- https://www.osgeo.cn/  中国开放地理空间实验室

- https://www.opengeospatial.org/ OGC开放地理空间信息联盟

加利福利亚大学荧光动力学实验室python 库:

https://www.lfd.uci.edu/~gohlke/pythonlibs/

也可参见grss-ieee地球科学与遥感学会与遥感相关的开源函数库和软件列表：

http://www.grss-ieee.org/open-source-software-related-to-geoscience-and-remote-sensing/

OSGeoLive 目录：

http://live.osgeo.org/en/overview/overview.html

/////////////////////////////////////////////////////////////////////////

# 附件一：OSGeo项目

Web地图服务：

deegree  http://www.deegree.org/

geomajas  http://www.geomajas.org/

GeoServer  [http://geoserver.org/display/GEOS/Welcome](http://www.geomajas.org/)

Mapbender  http://www.mapbender.org/

MapBuilder  http://communitymapbuilder.osgeo.org/

MapFish  http://www.mapfish.org/

MapGuide Open Source http://mapguide.osgeo.org/

MapServer  http://www.mapserver.org/

OpenLayers  http://openlayers.org/

## 地理信息桌面软件：

GRASS GIS http://grass.osgeo.org/

Quantum GIS [http://www.qgis.org](http://www.qgis.org/)

gvSIG  [http://www.gvsig.org](http://www.gvsig.org/)

地理空间支撑函数库：

FDO  http://fdo.osgeo.org/

GDAL/OGR http://www.gdal.org/

GEOS http://trac.osgeo.org/geos/

GeoTools  http://www.geotools.org/

MetaCRS http://trac.osgeo.org/metacrs/

OSSIM  http://www.ossim.org/

PostGIS http://www.postgis.org/
/////////////////////////////////////////////////////////////////////////////////////////////////

# 附件二：开源GIS简史

数字制图和地理空间信息系统（Geographic Information  System,GIS）的出现彻底改变了人们和对周围世界思考、互动的方式。将位置信息分层重叠用于决策的概念首先是由 Ian  McHarg（景观设计师）在上世纪60年代提出。大约在同一时间，Roger Tomlinson —— 人们普遍称之为“GIS  之父”（Father of GIS）  完成了他的博士论文，主要研究使用计算方法处理分层的地理空间信息。罗杰随后致力于创建第一个计算机化的地理信息系统——加拿大地理信息系统（the  Canada Geographic Information System），主要用于勘探测绘。

开源 GIS 的起源可以追溯到 1978 年的美国内政部（U.S. Department of the Interior）。从那时起，开源 GIS 基于不同的知识产权许可证，深入影响到许多行业的发展，包括政府和商业领域。美国劳工部称 GIS  技术为二十一世纪最重要的三大高增长产业之一。开源 GIS 技术在过去四十年的发展，直到今天演变出许多具有开创性和影响力的应用。

## 1.1、GIS 的起源: MOSS and GRASS

1978年，美国内政部创建了 MOSS 系统（the Map Overlay and Statistical System  ，地图叠加和统计系统）。MOSS  系统主要用于跟踪和评估矿山开发对环境、野生植物、野生动物及其迁徙方式的影响。这是第一个广泛部署，基于矢量（Vector  Based）、可互动的地理信息系统。第一套 GIS 生产部署在小型机上。

随后不久，GRASS (“草” ，Geographic Resources Analysis Support  System，地理资源分析支持系统）诞生。GRASS 系统拥有 350  多个模块用于处理栅格、拓扑向量、图像和图形数据，该软件最初设计提供给美国军方使用，以协助土地管理和环境规划。GRASS  系统广泛应用于科学研究和商业领域，包括地理空间数据管理和分析、图像处理、空间和时间建模以及创建图形和地图。

## 1.2、GIS 的发展：GeoTools, GDAL, PostGIS 和 GeoServer

1996，利兹大学（the University of Leeds）在一个项目上开始创建基于 Java  开发语言的地理信息库，设计可以被纳入不同的应用需要。最终的成果是  GeoTools，一个可以操纵空间数据的开源库，在今天广泛应用于Web地理空间信息服务，网络地图服务和桌面应用程序

四年后，一个跨平台的地理信息库 GDAL (Geospatial Data Abstraction Library, 地理空间数据抽象库) 出现了 。GDAL 使得 GIS 应用程序可以支持不同的数据格式，它还附带了各种有用的命令行工具，用于处理和转换各种数据格式。GDAL  支持超过 50 个栅格格式和20 个矢量格式的数据，它是全世界使用最广泛的地理空间数据访问库，支持的应用程序包括谷歌地球（Google  Earth），GRASS，QGIS、FME（the Feature Manipulation Engine）和ArcGIS。

2001年，[Refractions Research(加拿大 IT 咨询机构，创建于1998年)](http://www.refractions.net/)， 研发了开源项目 PostGIS ，使得空间数据可以存储在 Postgres 数据库。同年，GeoServer 创建，一个基于 Java  语言开发的应用程序，用于将空间数据发布为标准的Web服务。PostGIS 和 GeoServer  项目都取得了令人难以置信的成功，今天广泛应用于开源 GIS 数据库和 GIS 服务器。

## 1.3、创新和教育：开源项目驱动

QGIS 被认为是在开源桌面 GIS 的鼻祖。QGIS 在2002发布，它集成了GRASS 系统的分析功能，以及 GDAL  对于数据格式支持，提供一个用户友好的桌面应用程序进行数据编辑、地图制图与分析。QGIS 可以和其他开源 GIS 互相操作，例如；管理  PostGIS 数据库，将数据发布到 GeoServer 作为 Web 服务。

在21世纪初，开源GIS 继续获得发展动力， 创建的开源孵化项目是 OSGeo 和 LocationTech。OSGeo 在 2006  年被推出，设计目标是支持开源 GIS 软件的协同开发，以及促进相关软件的广泛应用。LocationTech 是在 Eclipse 基金会(the Eclipse Foundation ) 中设立的一个工作组，旨在促进 GIS 技术在学术研究者，产业和社区之间的合作。

2011 年，“Geo for All” 创建。他是是[开源地理空间基金会（Open Source Geospatial Foundation）](http://www.osgeo.org/)的教育推广项目，目的是使人人都能接触到地理空间技术教育的机会。作为该基金会的工作成果，许多开源 GIS 的教育资源能在互联网上免费提供，包括 FOSS4G Academy 和 GeoAcademy。最后，“Geo for All”  致力于在世界各地建立了开源地理空间实验室和研究中心，以支持开源的地理空间技术开发、培训和研究。

# 附件三：开源GIS拓展

开源GIS软件最早的开发一半是基于某个商业GIS软件不支持的功能、特性及开放接口，因此不同开源GIS特点不一样， 也适用于不同的GIS应用需求和不同的开发环境。

### 主要开源GIS软件

开源GIS 在仅仅20年时间里，产生了许多功能突出、性能优越和用户体验良好的软件， 从1982年第一个开源GIS 软件GRASS 发布截至到2008年12月中旬， 在地理空间信息开源界著名的 [http://www.freegis.org](http://www.freegis.org/) 索引系统中 可以寻找到开源地理空间信息软件项目多达347个， 其中2008年新的开源GIS 软件达到97个， 占到开源GIS软件的 27% ， 可见开源GIS软件的发展速度非常迅猛。

目前开源地理信息软件的体系架构已经非常清晰，每个项目都有特有的定位， 每个开源家族都有与商业软件对应的功能特性，可以实现绝大多数的功能。

在桌面领域，QGIS以及Dig项目完全可以满足普通制图和数据采集人员的需要， 完成对地理空间信息简单编辑、查询等功能， 可以取代价格昂贵的Arc GIS Desktop和Map Info Professional等。

在工作站以及服务器级， 由美国军方建筑工程研究实验室研发的GRASS完全可以充当科学家、 研究人员专业的操作工具，  复杂的空间分析算法以及栅格处理功能可以与ARC/INFO相媲美。 它是Unix平台的第一个GIS软件，同其他Unix软件一样，  吸引了多家联邦机构、大学和公司的参与研发。 1988年，GRASS3.0软件包的发行达1000余个。  GRASS软件曾经三次获得美国联邦政府的有关奖项。

OSSIM（Open Source Soft Image）是一个用于遥感、 图像处理、地理信息系统、摄影测量领域的高性能软件。  作为一个成熟的开源软件库， 它的设计目的是为摄影测量与遥感软件包的开发人员提供一套整合的并且是最佳的方法及流程。 自1996年至今，由[http://www.ossim.org](http://www.ossim.org/)/进行该开源项目的维护， 现在隶属于地理空间开源基金会http://www.osgeo.org/。 项目的开发人员拥有商业和政府遥感系统和应用软件领域多年的经验， 由美国多个情报、防务领域的政府部门提供资助。

下面列出了常用的开源GIS：

- 空间数据库： 基于PostgreSQL数据库的PostGIS, 带有地理目标扩展的Ingres数据库。
- GIS服务器：MapServer、GeoServer、Deegree
- WebGIS：OpenLayer、MapGuide
- 元数据目录系统：GeoNetwork
- GIS开发库：GeoTools、JTS、TerraLib、Proj.4（地图投影库）
- 桌面GIS：uDig、GRASS、OpenJump、Quantum GIS
- 遥感图像处理系统：OSSIM（Open Source Software Image Map）、GDAL （Geospatial Data Abstraction Library）、 OpenCV
- 三维地球：WorldWind、OSSIMPlanet、Earth3

### 开源GIS使用语言的情况

开源GIS 软件的分类，按照开发语言，主要包括C 、C++、Python、Java、.NET、  JavaScript、PHP、VB、Delphi 等。 无论是采用哪种语言，  当前开源GIS软件都力求最大程度的支持跨平台，其中支持Windows的开源GIS软件为 67.7%，  82.7%的开源软件能够在Linux环境下运行， 这与Linux本身是一个开源的操作系统有关。

### 开源GIS的国外应用现状

目前，开源GIS软件的主要用户是大学、科研机构和非政府组织。  同时，国内的GIS公司也开始举办开源GIS研发大赛，围绕着开源GIS软件的应用越来越多。  综合近年来国内外开源GIS软件的应用，可见，当前开源GIS的应用仍集中在大学、科研机构，  一些行业用户也主要利用开源GIS进行WebServer应用，开源WebGIS平台的应用较多，占开源GIS应用80%以上。  随着更多的行业用户对开源GIS的熟悉和认知以及开源GIS软件的进一步稳定可靠， 开源GIS的应用将会越来越多。

### 开源GIS的版权许可制度

### 开源的概念

所谓自由软件（Free Software）指允许任何人可以自由使用、复制、修改、分发的软件， 但它不能保证免费获得的软件。 自由软件在分发/获得方面是双模式的，就是说， 可以免费共享，也可以商业买卖。

所谓开源软件（Open source software）指软件的源代码（软件程序的原始文件）是对任何人都完全开放的，  即任何人在有关许可协议方式的规范下，都具有获得、使用、复制、修改和分发源代码的自由， 但为了保护初始源代码的完整性，有关许可协议规定：  原创者对源代码修改者的后续行为的自由有一定限制。

自由软件和开源的软件具有广泛的共同点，在一般情况下我们统称为“自由开源软件”； 考虑到当今它们愈来愈广泛地参与务实的商业活动，我们也可将其简称为“开源软件”。

### 开源GIS的特点

使用开源软件，有下面的一些特点：

1. 无需支付昂贵的软件购买费，可以节省大量成本，免费升级，并广泛推广应用。
2. 资源丰富，底层全部开放，可以自由选择进行组合应用， 进行无缝融合和改造，充分满足应用需求，也便于维护。
3. 开源软件由大量顶级行业精英设计开发， 设计理念和系统构架先进、功能新、升级快。 支持行业标准（OGC、SOA、 J2EE等）、开放性和扩展性好。
4. 因为底层源程序开放，没有安全性问题（后门问题）， 利于政府、军事和安全部门采用。

开源 GIS 优势不仅仅是免费，更在于其免费和开放的真正含义， 前者代表自由与免费，后者代表开放和扩展。 与商业GIS产品不同，由于开源  GIS 软件的免费和开放， 用户可以根据需要增加功能，当所有人都这样做的时候， 开源产品的性能与功能也就超过了很多商业产品，  因而也造就了开源的优势和活力。 此外，和一般的商业GIS 平台相比， 开源GIS产品大多都具有跨平台的能力，  可以运行于Linux、Windows等系统。 因此开源GIS 软件得到学术界和GIS 平台厂商越来越多的重视， 成为GIS  研究和应用创新的一个重要领域。

### 开源软件的许可制度

开源GIS软件的版权许可制度通常采用开源软件许可制度。 经 Open Source Initiative  组织通过批准的开源协议目前有58种， 其中最著名的许可制度有 GPL(the GNU General Public License)， LGPL (the GNULesser GeneralPublic License)， BSD（the Berkley Software  Distribution license family）和 MIT（Massachusetts Institute of  Technology）等四种。

1. GPL协议和BSD许可具有一定的差异。

   GPL的出发点是代码开源/免费使用和引用/修改/衍生代码的开源/免费使用，但不允许修改后和衍生的代码作为闭源商业软件发布和销售。  GPL协议的主要内容是只要在一个软件中使用（“使用指类库引用，修改后的代码或者衍生代码”）GPL协议的产品， 则该软件产品必须也采用GPL协议， 即必须也是开源和免费。 这就是所谓的“传染性”，  由于GPL严格要求使用了GPL类库的软件产品必须使用GPL协议，对于使用GPL协议的开源代码，  商业软件或者对代码有保密要求的部门就不适合集成/采用作为类库和二次开发的基础。

2. LGPL是GPL的一个主要为类库使用设计的开源协议。

   和GPL要求任何使用/修改/衍生之GPL类库的软件必须采用GPL协议不同， LGPL允许商业软件通过类库引用（link）方式使用LGPL类库而不需要开源商业软件代码， 这使得采用LGPL协议的开源代码可以被商业软件作为类库引用并发布和销售。

3. BSD是一个给予使用者很大自由鼓励代码共享的协议，但需要尊重代码作者的著作权。

   BSD允许使用者修改和重新发布代码，也允许使用或在BSD代码上开发商业软件发布和销售。

4. MIT是和BSD一样宽泛的许可协议，作者只保留版权而无任何其他限制。

   即必须在开源的发行版本中包含原许可协议的声明，无论你是以二进制发布的还是以源代码发布的。

GPL与Linux 类似，由于能够保护开源机构的利益，比较适合开源GIS软件的市场推广和研发支持，  因此被许多开源GIS平台采用，如GRASS，QGIS，uDig。  对开源GIS软件版权许可制度的统计结果表明超过一半的开源GIS采用了GPL版权许可。 但也有一些非政府机构支持的基于MIT、LGPL的开源项目， 如SAGA、Map-Window。

### OGC与OpenGIS

谈到开源GIS，不得不提到 GIS 的一些数据、接口标准。除了技术的发展，标准的兼容对于 GIS 的发展，尤其是开源 GIS 的发展起到了重要的促进作用。

开放地理联合会 （OGC）是一个参与一致进程以开发公开地理处理规格的384家公司、政府机构、大学和个人组成的国际行业联合会。  OpenGIS(Open Geodata Interoperation Specification,OGIS-开放的地理数据互操作规范)由  OGC 提出。由OpenGIS规格定义的开放接口和协议，支持可互操作的解决方案，  网络、无线和定位服务以及主流IT，让复杂的空间信息和服务在各种应用中可以被授权技术开发人员使用。  开放地理联合会协议包括网络地图服务WMS和网络功能服务WFS。

地理信息系统将OGC产品划分为两大类型，基于遵循OGC规格的完整准确的软件。地理信息系统技术标准促进GIS工具进行交流。  兼容的产品是符合OpenGIS规范的软件产品。 当一个产品经过测试，并通过 OGC 测试项目证明是兼容的，  这个产品就在这个地点上自动注册为“兼容”。 现实软件产品,即实现OpenGIS规格但还没有通过兼容测试的软件产品。  合规测试不可作用于所有的规格。 开发者可以注册他们的产品为实施草案或经核准的规范， 而OGC有权审查和确认每个条目。

### 开源GIS的发展趋势

GIS技术发展趋势是开放和互操作的，包括体系结构的开放、数据模型的开放以及开发者思想观念的开放。  开源GIS作为GIS研究的新热点，其趋势必将是集开放、集成、标准和互操作为一体，从软件向服务（Server Oriented  Architecture,SOA）转变的方向发展。  通过开源GIS项目建设，可以减少GIS软件的开发周期，降低软件开发成本，提高软件开发效率，同时可以降低GIS平台软件使用成本，促进GIS社会化和大众化。  随着开源GIS项目越来越成熟，并且取得越来越多的应用，开源GIS软件目前已经形成了一个比较齐全的产品线，在一些特定的功能方面优于商业GIS平台软件。 尽管开源GIS软件在稳定性、实用性和功能全面方面存在欠缺， 但是其免费和开放的优势使得越来越多的企业、  科研机构和非政府组织投入到开源GIS软件的研究、开发和应用推广中，  开源GIS软件将成为理论教学、科学研究、中小企业GIS应用的一个最好选择，从而也将会有更好的发展。