- [GeoPackage - 一个简便轻量的本地地理数据库 - 四季留歌 - 博客园 (cnblogs.com)](https://www.cnblogs.com/onsummer/p/11223618.html)

> GeoPackage（以下简称gpkg），内部使用SQLite实现的一种单文件、与操作系统无关的地理数据库。
>
> 当前标准是1.2.1，该版本的html版说明书：https://www.geopackage.org/spec121/index.html。

## 1. 简介

### 1.1 扩展名与数据库识别方法

它在非编辑、非连接状态时，扩展名是*.gpkg；在数据连接或编辑状态时，会多出来两个同名不同拓展名的文件：*.gpkg-wal、*.gpkg-shm。

如果不确定获得的gpkg文件是否是SQLite数据库，可以用二进制查看器看最开始的字节信息，前16个字节应为以null结尾的ASCII字符串“SQLite format 3”。有关更多二进制信息，请到OGC官网上查看说明书。

### 1.2 数据存储上限与支持的数据

gpkg最大数据量为140TB（应该没多少项目用得到吧...）

它能存储的数据有：

- 矢量数据
- 栅格数据
- 属性数据（非空间数据）
- 其他

“其他”意味着可以扩展gpkg数据库，但是目前笔者没有这个能力。

### 1.3 与其他类似的本地数据库比较

因为单文件的特点，与ArcGIS家族中的Geodatabase模型的实现——mdb和gdb很像。它们同为本地数据库。

gpkg没有类似ArcGIS中要素数据集的概念，也没有PostGIS中模式的概念（可能我没发现，暂时做狗头处理）

### 1.4 创建gpkg和打开gpkg的方法

- 如果想直接用SQL访问gpkg，请使用[DB Browser for SQLite](http://sqlitebrowser.org/)
- 如果要在网络端访问gpkg，推荐用[NGA’s application](http://ngageoint.github.io/geopackage-js/) 
- 如果想在桌面端访问，那么可以用的工具有很多，比如GDAL、QGIS、ArcGIS等。

gpkg可以直接被ArcGIS识别并增删改查数据（即ArcGIS内置了支持）

gpkg也可以被QGIS识别并增删改查数据。

### 1.5 什么时候用gpkg

因为SQLite“单文件”、“轻量化”的特点，所以gpkg特别适用于小规模的场景和移动场景。比如学生练习、手机等。

如果想多种途径创建gpkg，请阅读此文：[点我](http://www.geopackage.org/guidance/getting-started.html#creating-a-geopackage)

但是，通常使用GIS桌面客户端就可以了。

### 1.6 支持gpkg的GIS客户端、服务器、开发工具

- 客户端：QGIS、ArcGIS（10.2.2及更高版本支持读写，总之用新版本就好了）、GeoTools、FME、Skyline、MapInfo等
- 服务器：GeoServer
- 开发工具：GDAL

此外，SpatialLite 4.2.0以上也支持gpkg。

### 1.7 OGC中GeoPackage官网的常见问题

- gpkg会代替shp吗？

看你怎么想。可以替代，但是没必要。像简单的交换数据和显示简单的数据，GeoJson就可以完成。（详细的看第二节）

- gpkg安全吗？

gpkg只是SQLite的一种编码、规定，没有像其他DBMS一样的安全管理。不过，已经有人实践了SQLite的安全扩展模块，可以考虑一下或者换更安全的数据库管理系统，例如PostgreSQL。

- 为什么gpkg用的WKB编码与PostGIS、SpatialLite的WKB不同？

因为原始的WKB标准不能满足gpkg，所以要扩展。PostGIS和SpatialLite都这么做了。

## 2. gpkg vs shp文件（部分翻译）

QGIS 3.X默认从shp文件切换到gpkg，因此，渲染变得非常快。使用gpkg比使用shp文件在加载，平移和缩放时更快。

### 2.1 gpkg的优缺点

优点：

- 开源
- OGC标准之一
- 软件支持广泛，有GDAL、QGIS、R、Python、Esri家族...
- 比传统意义上的地理数据库轻量化，但是和地理数据库速度相差无几
- 单文件，比shp文件好管理
- 在工作流上比shp快速
- 几乎没有限制（指的是体积）

缺点：

- 还不成熟（现在版本才1.2.1，原文写的时候才是1.0）不过，这个只是时间问题
- 个人体验中栅格数据的支持比较受限制

### 2.2 shp文件的优缺点

优点：

- 通用标准！（2020年就是shp文件的30岁）
- 它就是个矢量数据的标志（GIS矢量数据几乎会问有没有shp文件？）

缺点：

- Esri维护
- 数据访问上有些迟钝
- 是一个多文件格式（有很多GIS菜鸟不知道要发送多个同名文件，只发送了几何数据的shp文件）
- 不能拓扑
- 属性名限制为10字符
- 它使用的是Esri定制的WKT，切换平台时可能会导致不一致
- 每个shp文件只支持最大2GB
- 每个shp文件只能是一种几何类型
- 没有真正的3D支持（gpkg已经根据社区的贡献拓展出了3d支持）

### 2.3 建议

原作者希望更多人使用gpkg而不要再继续使用shp了（笔者注：旧事物还有利用的余地时，新事物的推动就会非常困难；除非使用政治或者垄断手段强行更改（比如当年Esri的Coverage格式被Esri自己干掉了）——不太可能，这些都非常符合马克思主义；而且，是否使用gpkg或者shp或者其他数据库，都要具体问题具体分析）

如果你有庞大的数据需要存储、管理，原作者建议使用PostGIS。如果您喜欢GeoPackage，请与您的同事和合作者分享这些信息！

 

## 3. shp文件必须死！（偏激预警，不喜勿喷，部分翻译）

似乎有一小撮人，正在鼓吹shp必死论（可能是受够了shp的缺点了吧！），我就简单翻译一下。

shp文件具体是什么我就不过多介绍了，它诞生于1990年，马上就是它的30大寿了。

尽管shp文件是Esri维护的，但是它的规范是开放的，也就是说，如果你懂了shp文件的几大数据结构构成，会编程，你也可以手搓一个shp文件读写程序，不需要依赖任何第三方库。

### 3.1 shp文件的缺陷

但是，下面原文开始重点驳斥shp文件的坏处：

为什么Shapefile这么糟糕？以下是Shapefile格式错误的几个原因，您应该避免使用它：

- 要额外使用prj文件定义坐标系统（shp文件规范不包括prj文件来定义坐标系统，这是额外的）
- 多文件格式（至少要3个文件，其他软件还会自己扩充更多同名扩展文件，这就使得数据共享非常麻烦，这也是一个非常致命的弱点）
- 属性名最多为10字符
- dbf属性表最多255个字段
- 数据类型有限，只支持浮点数、整数、日期、文本，一个值最多254字符
- 文字编码有大问题，在ArcGIS中打开shp文件中文乱码的问题大家肯定遇到过
- shp文件和dbf文件最大2GB（虽然GDAL改进了但是毫无卵用）
- 不能拓扑
- 每个shp只能是一种几何类型
- 更复杂的数据结构无法实现，例如不规则三角网等
- 不能用纹理或材质存储3d数据
- ...

不展开了，有兴趣的朋友到他们官网看即可

### 3.2 备选方案

讲道理，现在没有任何一种矢量格式能完全替代shp，但是不得不说其他的格式正在慢慢崛起，有他们的用户。

例如，kml、gml、geojson等

一些Shapefile替代品：

- OGC GeoPackage
- GeoJSON
- OGC GML
- SpatiaLite
- CSV
- OGC KML

其中，第一位列的就是gpkg，而且经过近几年的迭代升级、修订，再加上它可以扩展的特性，使得gpkg更强大。

GeoPackage的一个缺点是，它底层SQLite数据库是一种复杂的二进制格式，不适合流式传输。它必须写入本地文件系统或通过中间服务访问。所以，在本地应用中，gpkg是shp文件的一个不错替代品（如果你有需要）

GeoJson并不是shp文件的代替品，只是地理数据的一种json实现。它的一个特点就是支持流传输；存在的问题是，不是所有的几何都可以表示，高级的坐标系统支持也不算好。

所以，基于XML的GML格式（仅支持矢量数据）就有了用武之地。但是GML也有其缺点，就是数据结构定义标准复杂，较少软件愿意支持它，ArcGIS把它的支持丢进了数据互操作模块。如果GeoJson不能解决问题，可以试试GML。

SpatialLite和gpkg类似，也是一个开源数据库，也是基于SQLite，也是单文件，也支持SQL，但是不如gpkg广泛。究其原因，是因为sl缺乏扩展能力（好比世界之窗vsChrome），也不支持栅格数据。同样的，它也不支持流传输。

csv文件，估计有的同学用过，最大的特点就是简单了。它就是个文本格式的二维数据表格。在非GIS行业中，csv非常受欢迎。作为属性表可能合适，但是它并不具备几何等复杂空间信息的存储能力，而且它没有一个标准。

kml是谷歌在谷歌地球中推荐的格式，基于XML，单文件。它有个特点就是，数据和样式同存在于一个kml文件中。缺点也有，仅支持wgs84坐标。由于它基于XML，所以数据量一大就不好用了。数据和样式存在耦合，这也是个缺点。

当然，除了以上开源格式外，还可以使用更复杂的DBMS或者ArcGIS家使用的面向对象的地理数据库。

笔者的建议是，还是具体问题具体分析。如果你要做真正的GIS项目，通用、标准化、性能高才是不二之选；所以，像kml等非主流但是又有其价值的数据，除了在它本身的平台用外，最好转换到更通用的格式上，例如，就GeoPackage——不然还是老实点用shp文件吧~

项目大的，有高并发、安全要求的，不妨试试PostgreSQL的PostGIS拓展。或者用MySQL、其他商业数据库，那些就不在本文的讨论范围了。



## 参考资料

[1]. OGC的GeoPackage官网：https://www.geopackage.org/

[](http://www.geopackage.org/guidance/getting-started.html)

[2]. OGC的GeoPackage起步文档：http://www.geopackage.org/guidance/getting-started.html

[3]. OGC的GeoPackage标准（类似于白皮书）http://www.geopackage.org/spec120

[4]. 实现了GeoPackage的有关软件：https://www.geopackage.org/implementations.html

[5]. GeoPackage vs Shapefiles：https://www.gis-blog.com/geopackage-vs-shapefile/

[6]. Shp文件必须死！（这个网站有点偏激）：http://switchfromshapefile.org/