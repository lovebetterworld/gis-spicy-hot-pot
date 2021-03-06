- [什么是shapefile文件_自己的九又四分之三站台的博客-CSDN博客_shapefile](https://qlygmwcx.blog.csdn.net/article/details/115674100)

ESRI Shapefile（shp），或简称shapefile，是美国环境系统研究所公司（ESRI）开发的一种空间数据开放格式。该文件格式已经成为了地理信息软件界的一个开放标准，这表明ESRI公司在全球的[地理信息系统](https://so.csdn.net/so/search?q=地理信息系统&spm=1001.2101.3001.7020)市场的重要性。Shapefile也是一种重要的交换格式，它能够在ESRI与其他公司的产品之间进行数据互操作。
Shapefile文件用于描述几何体对象：点，折线与多边形。例如，Shapefile文件可以存储井、河流、湖泊等空间对象的几何位置。除了几何位置，shp文件也可以存储这些空间对象的属性，例如一条河流的名字，一个城市的温度等等。

Shapefile属于一种矢量图形格式，它能够保存几何图形的位置及相关属性。但这种格式没法存储地理数据的拓扑信息。Shapefile在九十年代初的ArcView GIS的第二个版本被首次应用。许多自由的程序或商业的程序都可以读取Shapefile。

Shapefile是一种比较原始的矢量数据存储方式，它仅仅能够存储几何体的位置数据，而无法在一个文件之中同时存储这些几何体的属性数据。因此，Shapefile还必须附带一个二维表用于存储Shapefile中每个几何体的属性信息。Shapefile中许多几何体能够代表复杂的地理事物，并为他们提供强大而精确的计算能力。

Shapefile文件指的是一种文件存储的方法，实际上该种文件格式是由多个文件组成的。其中，要组成一个Shapefile，有三个文件是必不可少的，它们分别是".shp", ".shx"与 ".dbf"文件。表示同一数据的一组文件其文件名前缀应该相同。例如，存储一个关于湖的几何与属性数据，就必须有lake.shp，lake.shx与lake.dbf三个文件。而其中“真正”的Shapefile的后缀为shp，然而仅有这个文件数据是不完整的，必须要把其他两个附带上才能构成一组完整的地理数据。除了这三个必须的文件以外，还有八个可选的文件，使用它们可以增强空间数据的表达能力。所有的文件名都必须遵循MS DOS的8.3文件名标准（文件前缀名8个字符，后缀名3个字符，如shapefil.shp），以方便与一些老的应用程序保持兼容性，尽管现在许多新的程序都能够支持长文件名。此外，所有的文件都必须位于同一个目录之中。

- 必须的文件:
  - .shp— 图形格式，用于保存元素的几何实体。
  - .shx— 图形索引格式。几何体位置索引，记录每一个几何体在shp文件之中的位置，能够加快向前或向后搜索一个几何体的效率。
  - .dbf— 属性数据格式，以dBase IV的数据表格式存储每个几何形状的属性数据。
- 其他可选的文件：
  - .prj— 投帧式，用于保存地理坐标系统与投影信息，是一个存储well-known text投影描述符的文本文件。
  - .sbnand.sbx— 几何体的空间索引
  - .fbnand.fbx— 只读的Shapefiles的几何体的空间索引
  - .ainand.aih— 列表中活动字段的属性索引。
  - .ixs— 可读写Shapefile文件的地理编码索引
  - .mxs— 可读写Shapefile文件的地理编码索引(ODB格式)
  - .atx—.dbf文件的属性索引，其文件名格式为shapefile.columnname.atx(ArcGIS 8及之后的版本)
  - .shp.xml— 以XML格式保存元数据。
  - .cpg— 用于描述.dbf文件的代码页，指明其使用的字符编码。

# 限制编辑

1. Shapefile与拓扑

- Shapefile无法存储拓扑信息。在ESRI的文件格式中，ArcInfo 的Coverage、以及Personal/File/Enterprise地理数据库，能够保存地理要素的拓扑信息。

1. 空间表达

- 在shapefile文件之中，所有的折线与多边形都是用点来定义，点与点之间采用线性插值，也就是说点与点之间都是用线段相连。在数据采集时，点与点之间的距离决定了该文件所使用的比例。当图形放大超过一定比例的时候，图形就会呈现出锯齿。要使图形看上去更加平滑，那么就必须使用更多的点，这样就会消耗更大的存储空间。在这种情况下，样条函数可以很精确地表达不同形状的曲线而且占据相对更少的空间，但是shapefile并不支持样条曲线。

1. 数据存储

- .shp文件或.dbf文件最大的体积不能够超过2 GB（或2位）。也就是说，一个shapefile最多只能够存储七千万个点坐标。文件所能够存储的几何体的数目取决于单个要素所使用的顶点的数目。
- 属性数据库格式所使用的.dbf文件基于一个比较古老的dBase标准。这种数据库格式天生有许多限制，例如：
- 无法存储空值。这对于数量数据来说是一个严重的问题，因为空值通常都用0来代替，这样会歪曲很多统计表达的结果。
- 对字段名或存储值中的Unicode支持不理想。
- 字段名最多只能够有10个字符。
- 最多只能够有255个字段。
- 只支持以下的数据类型：浮点类型（13字节存储空间），整数（4或9字节存储空间），日期（不能够存储时间，8字节存储空间）和文本（最大254字节存储空间）
- 浮点数有可能包含舍入错误，因为它们以文本的形式保存。

1. 混合几何类型

- 由于在每一条几何记录中都有该记录的几何类型，所以理论上一个shapefile是可以存储混合的几何类型。但实际上规范中指出在同一shapefile之中所有非空的几何体都必须是同一类型 [1] 。因此shapefile被限制为仅仅可以混合存储空几何体和另一单一几何体，该几何体的类型必须与文件头中定义的类型一致。例如，一个shapefile文件不可能同时包含折线与多边形数据，所以，在实际的地理事物描述中，井（点类型）、河（折线类型）与湖（多边形类型）必须分开存储在三个不同的文件之中。