- [关于WebGIS开源解决方案的探讨](https://www.cnblogs.com/naaoveGIS/p/4187679.html)

## 1.背景

公司目前的多数项目采用的是ArcGIS产品+Oracle+WebLogic/Tomcat/APUSIC/WebShpere这样的架构。由于公司从事的是政府项目，甲方单位普遍均采购有以上产品，所以很多时候忽略购买以上产品所需要的费用。并且很多项目的推广，ARCGIS、IBM还有联通或者移动是公司的合作伙伴，涉及到商务问题，对开源的需求并不是很大。再则，政府项目一般侧重的是系统的稳定和易维护，所以他们在基础建设上投资比较大方。

不过随着政府经费的控制趋于严格，管理者水平的提高，对相关软件的购买开始谨慎起来。目前，公司越来越多的项目现场是没有ArcGIS产品的，虽然，我们已能利用GeoServer来代替ArcGIS Server使用，也推出了相应的产品，并且在很多个项目中已经运用，但是仍然是有不足的。

## 2.目前公司GIS开源项目的不足——没有全套的开源解决方案

A.底图的整体处理还是用ArcGIS Desktop来进行的配置，然后将配置好的底图用ArcGIS切图。

B.虽然利用本地瓦片文件作为底图，绕开了地图的在线服务，但是就切图工具来说，虽然公司有自己的切图软件，但是普遍采用的还是ArcGIS的工具切好图了再给现场实施。

C.涉及到空间数据的管理时，依然是用的ArcGIS Catalog+SDE导入到Oracle数据库中。不涉及到大量空间数据库管理时，是采用的直接通过GeoServer来修改shp数据。并没有统一管理，也不利于其他业务组获取数据。

D.目前基于GeoServer的项目，空间分析能力不强。部分功能已经探索出来，但是还没有在专门的空间分析产品上做出GeoServer版本。

## 3.WebGIS通用型全套开源解决方案

根据开发环境，可以将主流的WebGIS开源解决方案分成两派，一派是C/C++，一派是java。

C/C++的解决方案为：Mapserver（服务器）+QGIS（桌面软件）+Tomcat（中间件）+PostGIS|MySQL空间扩展（数据库）+[Openlayers](http://www.opengeo.cn/bbs/thread.php?fid=5)(JS)/ openscale (FLex)(浏览器客户端)

JavaEE的解决方案为：Geoserver（服务器）+uDig（桌面软件）+Tomact（中间件）+PostGIS|MySQL空间扩展（数据库）+[Openlayers](http://www.opengeo.cn/bbs/thread.php?fid=5)(JS)/ openscale (FLex)(浏览器客户端)

### 3.1MapServer和GeoServer的总体对比

功能上：MapServer弱于GeoServer，QGIS要强于UDIG。

效率上：Mapserver对WMS（Web Map service）的支持更为高效，而Geoserver则更擅长于结合WFS（Web Feature service）规范的属性查询。

以下是来自于http://www.cnblogs.com/mazhenyu/archive/2013/03/16/2963177.html统计的MapServer和GeoServer的使用量趋势图。

 ![img](https://images0.cnblogs.com/blog/656746/201412/262307593431026.png)            

#### 3.1.1 MapServer的特点

提供两种工作方式，CGI方式（适用于CGI、AJAX、FLEX开发人员）和MapScript方式（适用于Php、Java、  C#、Python开发人员）。以原生CGI方式效率最高，配合TileCache，可以快速生成大范围的地图瓦片数据。比较基于.Net和J2EE的商 业或开源平台，MapServer更适合高负荷的大型互联网地图应用。MapServer  是基于C写的地图服务软件，比用JAVA写的GeoServer速度要快。而且 MapServer 历史要比 GeoServer  悠久，甚至MapServer 的性能与商业的 ArcIMS 的功能可以娉美。

#### 3.1.2 GeoServer的特点

GeoServer(http://geoserver.org/)是一个符合J2EE规范，且实现了WCS、WMS及WFS规格，支持TransactionWFS(WFS-T)，其技术核心是整合了颇负盛名的JavaGISolkit--GeoTools。对于空间信息存储，它支持ESRI  Shapefile及PostGIS、Oracle、ArcSDE等空间数据库，输出的GML档案满足GML2.1的要求。由于它是纯Java的，所以更适合于复杂的环境要求，而且由于它的开源，所以开发组织可以基于GeoServer灵活实现特定的目标要求，而这些都是商业GIS组件所缺乏的。GeoServer作为一个纯粹的Java实现，被部署在应用服务器中，简单的如Tomcat等；它的WMS和WFS组件响应来自于浏览器或uDig的请求，访问配置的空间数据库，如PostGIS、OracleSpatial等，产生地图和GML文档传输至客户端。

具有以下优点： 1） 用 java 语言编写、标准的 J2EE 框架、基于 ser vlet 和 STRUTS  框架、 支持高效的 Spring 框架开发； 2） 兼容 WMS 和 WFS 特性、支持 WFS-T 规范； 3） 高效的数据库支持  PostGIS、ShapeFile、ArcSDE,Oracle、MySQL 等； 4） 支持上百种投影； 5） 能够将网络地图输出为  jpeg、gif、png 等格式；

### 3.2QGIS和uDig的比较

A.界面：QGIS优于uDig。

B.空间分析能力：QGIS优于uDig。

C.发展趋势上：uDig优于QGIS。

D.操作上：uDig优于QGIS。

E.支持的数据源上：uDig优于QGIS。

 

QGIS的界面：

 ![img](https://images0.cnblogs.com/blog/656746/201412/262308109999233.jpg)

uDig的界面：

 ![img](https://images0.cnblogs.com/blog/656746/201412/262308234527095.jpg)

### 3.3 PostGIS和MySQL空间扩展的对比

根据http://www.cnblogs.com/shanyou/p/3256906.html所提供的观点，下面将其截取总结。

#### 3.3.1 PostGIS的特点

A.PostgreSQL 的稳定性极强。

B. 任何系统都有它的性能极限，在高并发读写，负载逼近极限下，PG的性能指标仍可以维持双曲线甚至对数曲线，到顶峰之后不再下降，而 MySQL 明显出现一个波峰后下滑。

C. PostGIS多年来在 GIS 领域处于优势地位，因为它有丰富的几何类型，实际上不止几何类型，PG有大量字典、数组、bitmap  等数据类型，相比之下MySQL就差很多，instagram就是因为PostGIDS的空间数据库扩展POSTGIS远远强于MySQL的my  spatial而采用PGSQL的。

D.  对于WEB应用来说，复制的特性很重要，mysql到现在也是异步复制，pgsql可以做到同步，异步，半同步复制。还有MySQL的同步是基于binlog复制，类似oracle golden  gate,是基于stream的复制，做到同步很困难，这种方式更加适合异地复制，pgsql的复制基于wal，可以做到同步复制。同时，pgsql还提供stream复制。

#### 3.3.2mySql空间扩展的特点

A.MySQL有一些实用的运维支持，如 slow-query.log ，这个PostGIS肯定可以定制出来，但是如果可以配置使用就更好了。
B. MySQL的innodb引擎可以充分优化利用系统所有内存，超大内存下PostGIS对内存使用的不那么充分，
C.MySQL的复制可以用多级从库，但是在9.2之前，PostgreSQL不能用从库带从库。
D.从测试结果上看，MySQL5.5的性能提升很大，单机性能强于PostgreSQL，5.6应该会强更多.
E.对于web应用来说, MySQL5.6 的内置MC API功能很好用，PostgreSQL差一些。

# 4.适合公司的解决方案

### 4.1原因

公司的后台均由Java编写，所以选择肯定更偏向于基于JavaEE的解决方案。且我们GIS组已经在GeoServer的开源框架上进行了相关开发，比如最短路径服务的开发和道路优化的开发等，并且已经能很好的利用GeoServer提供的WMS服务和WFS服务来进行替AGS化，而且还编写了面向GeoServer的项目配置和发布工具。

同时，公司的V14GIS产品前端采用的是ArcGIS_JS，并且已经对其方法进行了大量封装和整合。

所以，适合目前公司的GIS开源化的解决方案应该是首选：

Geoserver（服务器）+uDig（桌面软件）+Tomact（中间件）+PostGIS（数据库）+ArcGIS_JS (JS)。

对于老项目，只需要将js部分换成我们已有的基于Flex的产品即可。

### 4.2具体解决方案

A．利用PostGIS将shp数据入库管理。

B．利用uDig连接PostGIS后进行配图。uDig可以生成sld文件，以及发布到GeoServer的样式服务上去，从而实现对服务的配图控制。

C．利用GeoServer来代替ArcGIS  Server。通过WMS服务可以实现类似于AGS中的export出图方式，实现部件图层的动态出图。通过WFS服务能实现与类似于AGS中的Query服务。通过WFS服务也可以实现类似于AGS中的FeatureServer服务，从而进行图层的编辑。同时，通过WFS服务还能实现类似于AGS中的GeometryServer服务，实现比如union等功能。

D. 利用GeoWebCache插件，可以实现类似于AGS中的cache功能。同时支持切图。

E.利用GeoTools，可以在后台开发复杂的空间分析和相关操作的功能。

# 5.亟待解决的问题

## 5.1技术问题

A．需要验证GeoWebCache的配置和切图功能。以及对GB以上数据的切图效果。

B.需要验证PostGIS对中文的支持（目前测试是支持的）。以及大数据入库时的稳定性。

C.配图的易用性。目前已测试uDig可以配图生成sld，且能配置比较复杂的图。但是如何能直接将所配的图层发布到GeoServer后，让此sld自动与该图层关联，还没测试。后期还需考虑是否有必要开发一个更简易的配图及发布工具。

D.基于GeoServer的空间分析功能还没有验证，目前只开发了部分。

## 5.2业务问题

如果GIS方面彻底换成开源方案，MIS、工作流、统计、手机等等业务如何和GIS业务结合？

目前公司对固定业务基本采用同一标准库。不同的业务使用标准库中的不同用户空间。有交互的部分的表共用一个业务用户空间。假如我们GIS部分全部采用了开源方案，甚至空间数据的管理都采用开源的数据库来进行管理。如何做到和其他业务的整合，也是一个需要思考和通力解决的地方。

我个人觉得，是可以将GIS的空间数据用开源数据库存放，GIS的业务表还是放入到主版本的数据库中，应该是可以解决以上问题的。

但是问题又来了，既然都有主版本所用的数据库了，比如Oracle，又何必还采用开源数据库呢。

不过，经过我最近的研究，GeoServer也是支持Oracle中的数据的发布的，只是有相关的插件要安装。同时，也有不通过SDE将空间数据导入Oracle的方法。

但是，这种方案，有个最大的问题就是操作相对复杂。

## 5.3 项目实施人员的实施难度加大问题

开源项目的部署实施问题，是对工程人员的一个巨大挑战。同时，维护的难度也会加大。人的问题其实是最大的问题。

而且工程人员的培训所需要的开销也应该是公司必须考虑的一个方面。