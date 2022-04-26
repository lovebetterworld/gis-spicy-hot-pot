- [PostGIS总结_HPUGIS的博客-CSDN博客_postgis圆弧](https://hpugis.blog.csdn.net/article/details/82953392)

## 一、PostGIS中的几何类型

PostGIS支持所有OGC规范的“Simple Features”类型，同时在此基础上扩展了对3DZ、3DM、4D坐标的支持。

### 1. OGC的WKB和WKT格式

OGC定义了两种描述几何对象的格式，分别是WKB（Well-Known Binary）和WKT（Well-Known Text）。

在[SQL语句](https://so.csdn.net/so/search?q=SQL语句&spm=1001.2101.3001.7020)中，用以下的方式可以使用WKT格式定义几何对象：

- POINT(0 0) ——点
- LINESTRING(0 0,1 1,1 2) ——线
- POLYGON((0 0,4 0,4 4,0 4,0 0),(1 1, 2 1, 2 2, 1 2,1 1)) ——面
- MULTIPOINT(0 0,1 2) ——多点
- MULTILINESTRING((0 0,1 1,1 2),(2 3,3 2,5 4)) ——多线
- MULTIPOLYGON(((0 0,4 0,4 4,0 4,0 0),(1 1,2 1,2 2,1 2,1 1)), ((-1 -1,-1 -2,-2 -2,-2 -1,-1 -1))) ——多面
- GEOMETRYCOLLECTION(POINT(2 3),LINESTRING((2 3,3 4))) ——几何集合

以下语句可以使用WKT格式插入一个点要素到一个表中，其中用到的GeomFromText等函数在后面会有详细介绍：
INSERT INTO table ( SHAPE, NAME )
VALUES ( GeomFromText('POINT(116.39 39.9)', 4326), '北京');

### 2. EWKT、EWKB和Canonical格式

EWKT和EWKB相比OGC WKT和WKB格式主要的扩展有3DZ、3DM、4D坐标和内嵌空间参考支持。

以下以EWKT语句定义了一些几何对象：
POINT(0 0 0) ——3D点
SRID=32632;POINT(0 0) ——内嵌空间参考的点
POINTM(0 0 0) ——带M值的点
POINT(0 0 0 0) ——带M值的3D点
SRID=4326;MULTIPOINTM(0 0 0,1 2 1) ——内嵌空间参考的带M值的多点

以下语句可以使用EWKT格式插入一个点要素到一个表中：
INSERT INTO table ( SHAPE, NAME )
VALUES ( GeomFromEWKT('SRID=4326;POINTM(116.39 39.9 10)'), '北京' )

Canonical格式是16进制编码的几何对象，直接用SQL语句查询出来的就是这种格式。

### 3. SQL-MM格式

SQL-MM格式定义了一些插值曲线，这些插值曲线和EWKT有点类似，也支持3DZ、3DM、4D坐标，但是不支持嵌入空间参考。

以下以SQL-MM语句定义了一些插值几何对象：
CIRCULARSTRING(0 0, 1 1, 1 0) ——插值圆弧
COMPOUNDCURVE(CIRCULARSTRING(0 0, 1 1, 1 0),(1 0, 0 1)) ——插值复合曲线
CURVEPOLYGON(CIRCULARSTRING(0 0, 4 0, 4 4, 0 4, 0 0),(1 1, 3 3, 3 1, 1 1)) ——曲线多边形
MULTICURVE((0 0, 5 5),CIRCULARSTRING(4 0, 4 4, 8 4)) ——多曲线
MULTISURFACE(CURVEPOLYGON(CIRCULARSTRING(0 0, 4 0, 4 4, 0 4, 0 0),(1 1, 3 3, 3 1, 1 1)),((10 10, 14 12, 11 10, 10 10),(11 11, 11.5 11, 11 11.5, 11 11))) ——多曲面

## 二、 PostGIS中空间信息处理的实现

### 1. spatial_ref_sys表

在基于PostGIS模板创建的数据库的public模式下，有一个spatial_ref_sys表，它存放的是OGC规范的空间参考。我们取我们最熟悉的4326参考看一下：

它的srid存放的就是空间参考的Well-Known ID，对这个空间参考的定义主要包括两个字段，srtext存放的是以字符串描述的空间参考，proj4text存放的则是以字符串描述的PROJ.4 投影定义（PostGIS使用PROJ.4实现投影）。

4326空间参考的srtext内容：
GEOGCS["WGS 84",DATUM["WGS_1984",SPHEROID["WGS 84",6378137,298.257223563,AUTHORITY["EPSG","7030"]],TOWGS84[0,0,0,0,0,0,0],AUTHORITY["EPSG","6326"]],PRIMEM["Greenwich",0,AUTHORITY["EPSG","8901"]],UNIT["degree",0.01745329251994328,AUTHORITY["EPSG","9122"]],AUTHORITY["EPSG","4326"]]

4326空间参考的proj4text内容：
+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs

### 2. geometry_columns表

geometry_columns表存放了当前数据库中所有几何字段的信息，比如我当前的库里面有两个空间表，在geometry_columns表中就可以找到这两个空间表中几何字段的定义：

其中f_table_schema字段表示的是空间表所在的模式，f_table_name字段表示的是空间表的表名，f_geometry_column字段表示的是该空间表中几何字段的名称，srid字段表示的是该空间表的空间参考。

### 3. 在PostGIS中创建一个空间表

在PostGIS中创建一个包含几何字段的空间表分为2步：第一步创建一个一般表，第二步给这个表添加几何字段。

以下先在test模式下创建一个名为cities的一般表：
create table test.cities (id int4, name varchar(20))

再给cities添加一个名为shape的几何字段（二维点）：
select AddGeometryColumn('test', 'cities', 'shape', 4326, 'POINT', 2)

### 4. PostGIS对几何信息的检查

PostGIS可以检查几何信息的正确性，这主要是通过IsValid函数实现的。
以下语句分辨检查了2个几何对象的正确性，显然，(0, 0)点和(1,1)点可以构成一条线，但是(0, 0)点和(0, 0)点则不能构成，这个语句执行以后的得出的结果是TRUE,FALSE。

select IsValid('LINESTRING(0 0, 1 1)'), IsValid('LINESTRING(0 0,0 0)')
默认PostGIS并不会使用IsValid函数检查用户插入的新数据，因为这会消耗较多的CPU资源（特别是复杂的几何对象）。当你需要使用这个功能的时候，你可以使用以下语句为表新建一个约束：
ALTER TABLE cities
ADD CONSTRAINT geometry_valid
CHECK (IsValid(shape))

这时当我们往这个表试图插入一个错误的空间对象的时候，会得到一个错误：
INSERT INTO test.cities ( shape, name )
VALUES ( GeomFromText('LINESTRING(0 0,0 0)', 4326), '北京');

ERROR: new row for relation "cities" violates check constraint "geometry_valid"
SQL 状态: 23514

### 5. PostGIS中的空间索引

数据库对多维数据的存取有两种索引方案，R-Tree和GiST（Generalized Search Tree），在PostgreSQL中的GiST比R-Tree的健壮性更好，因此PostGIS对空间数据的索引一般采用GiST实现。

以下的语句给sde模式中的cities表添加了一个空间索引shape_index_cities，在pgAdmin中也可以通过图形界面完成相同的功能。
CREATE INDEX shape_index_cities
ON sde.cities
USING gist
(shape);

另外要注意的是，空间索引只有在进行基于边界范围的查询时才起作用，比如“&&”操作

## 三、 PostGIS中的常用函数

首先需要说明一下，这里许多函数是以ST_[X]yyy形式命名的，事实上很多函数也可以通过xyyy的形式访问，在PostGIS的函数库中我们可以看到这两种函数定义完全一样。

### 1. OGC标准函数

管理函数：
添加几何字段 AddGeometryColumn(, , , , , )
删除几何字段 DropGeometryColumn(, , )
检查数据库几何字段并在geometry_columns中归档 Probe_Geometry_Columns()
给几何对象设置空间参考（在通过一个范围做空间查询时常用） ST_SetSRID(geometry, integer)

几何对象关系函数 ：
获取两个几何对象间的距离 ST_Distance(geometry, geometry)
如果两个几何对象间距离在给定值范围内，则返回TRUE ST_DWithin(geometry, geometry, float)
判断两个几何对象是否相等
（比如LINESTRING(0 0, 2 2)和LINESTRING(0 0, 1 1, 2 2)是相同的几何对象） ST_Equals(geometry, geometry)
判断两个几何对象是否分离 ST_Disjoint(geometry, geometry)
判断两个几何对象是否相交 ST_Intersects(geometry, geometry)
判断两个几何对象的边缘是否接触 ST_Touches(geometry, geometry)
判断两个几何对象是否互相穿过 ST_Crosses(geometry, geometry)
判断A是否被B包含 ST_Within(geometry A, geometry B)
判断两个几何对象是否是重叠 ST_Overlaps(geometry, geometry)
判断A是否包含B ST_Contains(geometry A, geometry B)
判断A是否覆盖 B ST_Covers(geometry A, geometry B)
判断A是否被B所覆盖 ST_CoveredBy(geometry A, geometry B)
通过DE-9IM 矩阵判断两个几何对象的关系是否成立 ST_Relate(geometry, geometry, intersectionPatternMatrix)
获得两个几何对象的关系（DE-9IM矩阵） ST_Relate(geometry, geometry)

几何对象处理函数：
获取几何对象的中心 ST_Centroid(geometry)
面积量测 ST_Area(geometry)
长度量测 ST_Length(geometry)
返回曲面上的一个点 ST_PointOnSurface(geometry)
获取边界 ST_Boundary(geometry)
获取缓冲后的几何对象 ST_Buffer(geometry, double, [integer])
获取多几何对象的外接对象 ST_ConvexHull(geometry)
获取两个几何对象相交的部分 ST_Intersection(geometry, geometry)
将经度小于0的值加360使所有经度值在0-360间 ST_Shift_Longitude(geometry)
获取两个几何对象不相交的部分（A、B可互换） ST_SymDifference(geometry A, geometry B)
从A去除和B相交的部分后返回 ST_Difference(geometry A, geometry B)
返回两个几何对象的合并结果 ST_Union(geometry, geometry)
返回一系列几何对象的合并结果 ST_Union(geometry set)
用较少的内存和较长的时间完成合并操作，结果和ST_Union相同 ST_MemUnion(geometry set)

几何对象存取函数：
获取几何对象的WKT描述 ST_AsText(geometry)
获取几何对象的WKB描述 ST_AsBinary(geometry)
获取几何对象的空间参考ID ST_SRID(geometry)
获取几何对象的维数 ST_Dimension(geometry)
获取几何对象的边界范围 ST_Envelope(geometry)
判断几何对象是否为空 ST_IsEmpty(geometry)
判断几何对象是否不包含特殊点（比如自相交） ST_IsSimple(geometry)
判断几何对象是否闭合 ST_IsClosed(geometry)
判断曲线是否闭合并且不包含特殊点 ST_IsRing(geometry)
获取多几何对象中的对象个数 ST_NumGeometries(geometry)
获取多几何对象中第N个对象 ST_GeometryN(geometry,int)
获取几何对象中的点个数 ST_NumPoints(geometry)
获取几何对象的第N个点 ST_PointN(geometry,integer)
获取多边形的外边缘 ST_ExteriorRing(geometry)
获取多边形内边界个数 ST_NumInteriorRings(geometry)
同上 ST_NumInteriorRing(geometry)
获取多边形的第N个内边界 ST_InteriorRingN(geometry,integer)
获取线的终点 ST_EndPoint(geometry)
获取线的起始点 ST_StartPoint(geometry)
获取几何对象的类型 GeometryType(geometry)
类似上，但是不检查M值，即POINTM对象会被判断为point ST_GeometryType(geometry)
获取点的X坐标 ST_X(geometry)
获取点的Y坐标 ST_Y(geometry)
获取点的Z坐标 ST_Z(geometry)
获取点的M值 ST_M(geometry)

几何对象构造函数 ：
参考语义：
Text：WKT
WKB：WKB
Geom:Geometry
M:Multi
Bd:BuildArea
Coll:Collection ST_GeomFromText(text,[])

ST_PointFromText(text,[])
ST_LineFromText(text,[])
ST_LinestringFromText(text,[])
ST_PolyFromText(text,[])
ST_PolygonFromText(text,[])
ST_MPointFromText(text,[])
ST_MLineFromText(text,[])
ST_MPolyFromText(text,[])
ST_GeomCollFromText(text,[])
ST_GeomFromWKB(bytea,[])
ST_GeometryFromWKB(bytea,[])
ST_PointFromWKB(bytea,[])
ST_LineFromWKB(bytea,[])
ST_LinestringFromWKB(bytea,[])
ST_PolyFromWKB(bytea,[])
ST_PolygonFromWKB(bytea,[])
ST_MPointFromWKB(bytea,[])
ST_MLineFromWKB(bytea,[])
ST_MPolyFromWKB(bytea,[])
ST_GeomCollFromWKB(bytea,[])
ST_BdPolyFromText(text WKT, integer SRID)
ST_BdMPolyFromText(text WKT, integer SRID)

## 四、简单demo

```sql
----创建一个表
CREATE TABLE gtest ( gid serial primary key, name varchar(20) , geom geometry(LINESTRING) );
 
INSERT INTO gtest (gid, NAME, GEOM) VALUES ( 1001, 'First Geometry', ST_GeomFromText('LINESTRING(2 3,4 5,6 5,7 8)') ); 
 
SELECT gid, name, ST_AsText(geom) AS geom FROM gtest; 
 
----首先建立一个常规的表格存储有关城市（cities）的信息。这个表格有两栏，一个是 ID 编号，一个是城市名：
CREATE TABLE cities ( id int4, name varchar(50) );
 
----现在添加一个空间栏用于存储城市的位置。习惯上这个栏目叫做 the_geom 。
----它记录了数据为什么类型（点、线、面）、有几维（这里是二维）以及空间坐标系统。此处使用 EPSG:4326 坐标系统：
SELECT AddGeometryColumn ('cities', 'the_geom', 4326, 'POINT', 2);
 
----为添加记录，需要使用 SQL 命令。对于空间栏，
----使用 PostGIS 的 ST_GeomFromText 可以将文本转化为坐标与参考系号的记录：
INSERT INTO cities (id, the_geom, name) VALUES (1,ST_GeomFromText('POINT(-0.1257 51.508)',4326),'London, England');
INSERT INTO cities (id, the_geom, name) VALUES (2,ST_GeomFromText('POINT(-81.233 42.983)',4326),'London, Ontario');
INSERT INTO cities (id, the_geom, name) VALUES (3,ST_GeomFromText('POINT(27.91162491 -33.01529)',4326),'East London,SA');
----简单查询
SELECT *,ST_AsText(the_geom) FROM cities;
----这里的坐标是无法阅读的 16 进制格式。
----要以 WKT 文本显示，使用 ST_AsText(the_geom) 或 ST_AsEwkt(the_geom) 函数。
----也可以使用 ST_X(the_geom) 和 ST_Y(the_geom) 显示一个维度的坐标：
SELECT id, ST_AsText(the_geom), ST_AsEwkt(the_geom), ST_X(the_geom), ST_Y(the_geom) FROM cities;
 
----空间查询
-----PostGIS 为 PostgreSQL 扩展了许多空间操作功能。
-----以上已经涉及了转换空间坐标格式的 ST_GeomFromText 。
-----多数空间操作以 ST（spatial type）开头，在 PostGIS 文档相应章节有罗列。
-----这里回答一个具体的问题：以米为单位并假设地球是完美椭球，上面三个城市相互的距离是多少
SELECT p1.name,p2.name,ST_Distance_Sphere(p1.the_geom,p2.the_geom) FROM cities AS p1, cities AS p2 WHERE p1.id > p2.id;
 
----注意 ‘WHERE’ 部分防止了输出城市到自身的距离（0）
----或者两个城市不同排列的距离数据（London, England 到 London, Ontario 和 London, Ontario 到 London, England 的距离是一样的）。
----尝试取消 ‘WHERE’ 并查看结果。
 
----这里采取不同的椭球参数（椭球体名、半主轴长、扁率）计算：
SELECT p1.name,p2.name,ST_Distance_Spheroid(
        p1.the_geom,p2.the_geom, 'SPHEROID["GRS_1980",6378137,298.257222]'
        )
       FROM cities AS p1, cities AS p2 WHERE p1.id > p2.id;
----缓冲区分析
select ST_AsText(ST_Buffer(ST_GeomFromText('POINT(27.91162491 -33.01529)',4326),3));
```

 