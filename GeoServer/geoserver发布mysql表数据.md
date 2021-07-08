- [geoserver发布mysql表数据](https://www.cnblogs.com/naaoveGIS/p/9673134.html)

# 1.环境部署

Geoserver中并不自带mysql数据发布功能，需要下载对应插件。

 ![img](https://img2018.cnblogs.com/blog/656746/201809/656746-20180919102545113-663947828.png)

 ![img](https://img2018.cnblogs.com/blog/656746/201809/656746-20180919102558907-188092664.png)

将其放入geoserver的lib中，发布，查看添加数据源会出现mysql数据源：

 ![img](https://img2018.cnblogs.com/blog/656746/201809/656746-20180919102605631-456803816.png)

# 2.Mysql数据发布

## 2.1配置数据源

 ![img](https://img2018.cnblogs.com/blog/656746/201809/656746-20180919102621255-412690405.png)

## 2.2发布图层

### 2.2.1原始表发布

需要有geometry类型的字段。

 ![img](https://img2018.cnblogs.com/blog/656746/201809/656746-20180919102631994-1646573174.png)

点击发布即可：

 ![img](https://img2018.cnblogs.com/blog/656746/201809/656746-20180919102643369-1501196265.png)

### 2.2.2视图发布

有些情况下，我们可能没有the_geom字段，或者表中的数据并不是我们需要全部发布，此时mysql数据源支持视图发布。

点击创建视图：

 ![img](https://img2018.cnblogs.com/blog/656746/201809/656746-20180919102654022-995128776.png)

SQL后可增加过滤条件，如下所示：

select t.*,POINTFROMTEXT(CONCAT('POINT(',revised_coord_x,' ',revised_coord_y,')')) as  the_geom from tc_test t where flag=1

 ![img](https://img2018.cnblogs.com/blog/656746/201809/656746-20180919102707983-76271444.png)

# 3.功能测试汇总

a.点、线、面类型的geometry均可以支持。

b.WFS中数据编辑和空间查询均可以，精度无误。

c.WMS出图可以支持。

 ![img](https://img2018.cnblogs.com/blog/656746/201809/656746-20180919102719041-1650760961.png)

# 4.mysql中Geometry类型总结

## 4.1 WKT介绍

Geometry中几何要素的描述与PG一样，均为WKT（Well-known text）标记语言。WKT可以表示的几何对象包括：点，线，多边形，TIN（不规则三角网）及多面体。以下为字串样例：

 

POINT(6 10) 
 LINESTRING(3 4,10 50,20 25) 
 POLYGON((1 1,5 1,5 5,1 5,1 1),(2 2,2 3,3 3,3 2,2 2)) 
 MULTIPOINT(3.5 5.6, 4.8 10.5) 
 MULTILINESTRING((3 4,10 50,20 25),(-5 -8,-10 -8,-15 -4)) 
 MULTIPOLYGON(((1 1,5 1,5 5,1 5,1 1),(2 2,2 3,3 3,3 2,2 2)),((6 3,9 2,9 4,6 3))) 
 GEOMETRYCOLLECTION(POINT(4 6),LINESTRING(4 6,7 10)) 
 POINT ZM (1 1 5 60) 
 POINT M (1 1 80) 
 POINT EMPTY 
 MULTIPOLYGON EMPTY

 

但是mysql中geometry类型的最终存储却需要是WKB(well-known-binary)，二进制格式占用空间更小。

总结，MySQL遵守OGC的OpenGIS Geometry Model，支持以下空间数据对象
 Geometry (non-instantiable) 
     Point (instantiable)

​     Curve (non-instantiable)

​          LineString (instantiable)

​          Line

​          LinearRing

​     Surface (non-instantiable)

​          Polygon (instantiable)

​     GeometryCollection (instantiable)

​          MultiPoint (instantiable)

​          MultiCurve (non-instantiable)

​          MultiLineString (instantiable)

​          MultiSurface (non-instantiable)

​          MultiPolygon (instantiable)

 

 

## 4.2空间函数

 

目前mysql5中还有部分空间关系函数未实现，具体罗列为：

CONTAINS、CROSSES、DISJOINT、DISTANCE、EQUALS、INTERSECTS、OVERLAPS、RELATED、TOUCHES、WITHIN以及空间分析操作函数，包括作缓冲区、联合、切割等操作。

 

但是大部分函数均以实现，包含格式类函数WKT与WKB互转，空间拓扑类、空间计算类。总结如下：

### 4.2.1转换WTK函数

的GEOMFROMTEXT和ASTEXT函数。

 

### 4.2.2几何类的函数


 DIMENSION，返回对象的尺寸，-1为空，0为点（没有长度没有面积），1为线（有长度而没有面积），2为多边形（有面积）
 ENVELOPE，返回最小边界矩形
 GEOMERYTYPE，返回几何类型（字符串）
 SRID，所谓SRID是空间基准坐标指示符，表示一个几何类型的坐标系统

 

### 4.2.3点对象的函数


 X，Y两个函数用于返回点的X坐标和Y坐标

 

### 4.2.4线对象的函数


 GLENGTH，返回线长
 ISCLOSED，是否为封闭线段
 NUMPOINTS，线段包含点的数目
 STARTPOINT，ENDPOINT，POINTN，分别返回起点，终点和指定位置的点

### 4.2.5多边形对象的函数

AREA，返回多边形面积
 EXTERIORRING，返回线型的外环
 INTERIORRINGN，返回指定的内环（对于包含空洞的多边形）
 NUMINTERIORRINGS，返回空洞数目

 

### 4.2.6几何集合对象的函数


 GEOMETRYN，返回指定位置的几何类型
 NUMGEOMETRIES，返回对象数目

 

### 4.2.7最小边界矩形空间关系函数


 MySQL提供了一组函数来判断几个对象和最小边界矩形的位置关系
 MBRCONTAINS
 MBRDISJOINT
 MBREQUAL
 MBRINTERSECTS
 MBROVERLAPS
 MBRTOUCHES
 MBRWITHIN

## 4.3其他函数参考

 

具体请查看：

https://dev.mysql.com/doc/refman/5.7/en/func-op-summary-ref.html