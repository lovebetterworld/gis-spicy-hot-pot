- [JTS Java空间几何计算、距离、最近点、subLine等 稳健的一比，持续更新中_lakernote的博客-CSDN博客_java jts](https://blog.csdn.net/abu935009066/article/details/115304685)

# 地理坐标系和投影坐标系

## 地理坐标系

**地理坐标系**（Geographic coordinate system），是**以经纬度为地图的存储单位**。很明显地理坐标系是球面坐标系统。我们要将地球上的数字化信息存放到球面坐标系统上，如何进行操作呢？地球是一个不规则的椭球，如何将数据信息以科学的方法存放到椭球上？这必然要求我们找到这样的一个椭球体。这样的椭球体具有特点：可以量化计算的。具有长半轴，短半轴，偏心率。以下几行便是Krasovsky_1940椭球及其相应参数。

Spheroid: Krasovsky_1940

Semimajor Axis: 6378245.000000000000000000

Semiminor Axis: 6356863.018773047300000000

Inverse Flattening（扁率）: 298.300000000000010000

然而有了这个椭球体以后还不够，还需要一个大地基准面将这个椭球定位。在坐标系统描述中，可以看到有这么一行：Datum: D_Beijing_1954表示，大地基准面是D_Beijing_1954。

## 投影坐标系

投影坐标系统，实质上便是平面坐标系统，其地图单位通常为米。

投影的意义：将球面坐标转化为平面坐标的过程便称为投影。

地理坐标系右下角显示Degrees（度）表示经纬度；投影显示的是Meters（米）

![img](https://img-blog.csdn.net/20180506190942351?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpdWt1bnJz/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)![img](https://img-blog.csdn.net/20180506190948126?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpdWt1bnJz/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

> 平常看到的WGS84、高德、百度坐标系都是地理坐标系，当我们需要计算距离、面积、长度时需要用投影坐标系

## 地图投影

利用一定数学法则把地球表面转换到平面上的理论和方法称为地图投影。由于地球表面是一个不可展平的曲面，所以运用任何数学方法进行投影转换都会产生误差和变形，为按照不同的需求缩小误差，就产生了各种投影方式，如圆柱投影、圆锥投影、等角投影、等面积投影、切投影、割投影等。

![img](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9tbWJpei5xcGljLmNuL3N6X21tYml6X3BuZy9OWFNmWG5LTnZUNnlPTEZ0Y3FHS2g4dlU3MmlibENZdFMzMTZTWHBTdnlBNFkwd2huSGgyUlUzWkJOcWlhb3BtQzZPRkFPR2plNlFOQVRMYXNOZmhTMk1BLzY0MA?x-oss-process=image/format,png)

## 墨卡托/Web墨卡托

一种正轴等角切圆柱投影。

- 等角：保证对象形状不变以及方向位置正确。
- 圆柱：保证纬线经线平行相互垂直且经线间隔相同。
- 缺点：纬线间隔从赤道向两级逐渐增大，面积变形大。
- Web墨卡托：Google首创，把地球模拟为球体而非椭球体，近似等角。

![img](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9tbWJpei5xcGljLmNuL3N6X21tYml6X3BuZy9OWFNmWG5LTnZUNnlPTEZ0Y3FHS2g4dlU3MmlibENZdFN3V2t5WFNUcWo1YmljTmxwTE96bjY4OUV0d3JiSEFneDl2RWE4SHRHSFQ1NUgyQzlyTnRMb253LzY0MA?x-oss-process=image/format,png)

# 常见坐标系

**WGS84坐标系**
地球坐标系，国际上通用的坐标系。设备一般包含GPS芯片或者北斗芯片获取的经纬度为WGS84地理坐标系。

**GCJ02坐标系**
火星坐标系，是由中国国家测绘局制订的地理信息系统的坐标系统。由WGS84坐标系经加密后的坐标系。

**BD09坐标系**
百度地图使用坐标系，GCJ02坐标系经加密后的坐标系。

**转换方法**

国际通用的转换做法：
![img](https://img-blog.csdn.net/20150324224232780?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvZ3VsYW5zaGVuZw==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)
百度的做法：
![img](https://img-blog.csdn.net/20150320202541443)

# 地理坐标系和投影坐标系互转

需要2个依赖库，这里要注意`org.geotool`库的下载源。

```xml
<dependency>
    <groupId>org.locationtech.jts</groupId>
    <artifactId>jts-core</artifactId>
    <version>1.18.1</version>
</dependency>
<dependency>
    <groupId>org.geotools</groupId>
    <artifactId>gt-epsg-hsql</artifactId>
    <version>22-RC</version>
</dependency>
<dependency>
    <groupId>org.geotools</groupId>
    <artifactId>gt-main</artifactId>
    <version>22-RC</version>
</dependency>
<repositories>
        <repository>
            <id>geotools</id>
            <name>geotools</name>
            <url>http://maven.icm.edu.pl/artifactory/repo/</url>
            <releases>
                <enabled>true</enabled>
            </releases>
        </repository>
</repositories>
```

转换代码示例

```java
// WGS84(一般项目中常用的是CSR:84和EPSG:4326)
CoordinateReferenceSystem sourceCRS = CRS.decode("CRS:84");
// Pseudo-Mercator(墨卡托投影)
CoordinateReferenceSystem targetCRS = CRS.decode("EPSG:3857");
MathTransform transform = CRS.findMathTransform(sourceCRS, targetCRS, false);
Geometry geometryMercator = JTS.transform(geometry, transform);

// 面积、周长
System.out.println(geometryMercator.getArea());
System.out.println(geometryMercator.getLength());
```

JTS包下的Geometry等类其实是代表的空间几何，它所提供的**几何计算只是单纯的值计算**，而我们提到的根据GIS经纬度等获取面积周长等其实是需要放到对应坐标系中才有意义。

## EPSG:3857和EPSG:4326

**`墨卡托坐标`** `EPSG:3857` 坐标系。投影坐标系，EPSG:3857 的数据一般是这种的。**`[12914838.35,4814529.9]`**，看上去相对数值较大。不利于存储，比较占内存。

**WGS-84：是国际标准，GPS坐标（Google Earth使用、或者GPS模块）**
EPSG:4326 的数据一般是这种的。**`[22.37，114.05]`**。利于存储，可读性高

> // 2437 GCJ-02：中国坐标偏移标准，Google Map、高德、腾讯使用

## Java各坐标系之间的转换（高斯、WGS84经纬度、Web墨卡托、瓦片坐标）

另一种方式，我未使用

https://blog.csdn.net/u010410697/article/details/110003422

# Geotools

Geotools是一个java类库，它提供了很多的标准类和方法来处理空间数据，同时这个类库是构建在OGC标准之上的，是OGC思想的一种实现。而OGC是国际标准，所以geotools将来必定会成为开源空间数据处理的主要工具，目前的大部分开源软件，如udig，geoserver等，对空间数据的处理都是由geotools来做支撑。而其他很多的web服务，命令行工具和桌面程序都可以由geotools来实现。

# JTS

中文文档：https://max.book118.com/html/2019/0624/6154225215002041.shtm

工具包+相关文档下载：https://download.csdn.net/download/abu935009066/16208250

**JTS**(Java Topology Suite) Java拓扑套件，是Java的处理地理数据的API，它提供以下功能：

1. 实现了OGC关于简单要素SQL查询规范定义的空间数据模型
2. 一个完整的、一致的、基本的二维空间算法的实现，包括二元运算（例如touch和overlap）和空间分析方法（例如intersection和buffer）
3. 一个显示的精确模型，用算法优雅的解决导致dimensional collapse（尺度坍塌–*专业名词不知道对不对，暂时这样译*）的情况。
4. 健壮的实现了关键计算几何操作
5. 提供著名文本格式的I/O接口
6. JTS是完全100%由Java写的

JTS支持一套完整的二元谓词操作。二元谓词方法将两个几何图形作为参数，返回一个布尔值来表示几何图形是否有指定的空间关系。它支持的空间关系有：相等（equals）、分离（disjoint）、相交（intersect）、相接（touches）、交叉（crosses）、包含于（within）、包含（contains）、覆盖/覆盖于（overlaps）。同时，也支持一般的关系（relate）操作符。relate可以被用来确定维度扩展的九交模型（DE-9IM）,它可以完全的描述两个几何图形的关系。

https://locationtech.github.io/jts/

https://github.com/locationtech/jts

## vividsolutions和locationtech jts

**maven仓库**
![img](https://img-blog.csdnimg.cn/20210329163306341.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2FidTkzNTAwOTA2Ng==,size_16,color_FFFFFF,t_70)

看了下vividsolutions于2015年就停在更新了，好像在哪儿看过，jts由vividsolutions变为的locationtech，一个爹 应该是。选**locationtech**这个就完事了

## 创建几何对象

JTS提供了以下空间数据类型：

多数的空间数据模型都是遵从这个的。

![img](https://img-blog.csdnimg.cn/img_convert/5c2a9facccae14d5b5b6ac76f19c6f74.png)

```java
private GeometryFactory geometryFactory = new GeometryFactory();
```

### 点-Point

ByCoordinate坐标

```java
Coordinate coord = new Coordinate(109.013388, 32.715519);
Point point = geometryFactory.createPoint( coord );
```

ByWKT

```java
WKTReader reader = new WKTReader( geometryFactory );
Point point = (Point) reader.read("POINT (109.013388 32.715519)");
```

### 多点-MultiPoint

```java
WKTReader reader = new WKTReader( geometryFactory );
MultiPoint mpoint = (MultiPoint) reader.read("MULTIPOINT(109.013388 32.715519,119.32488 31.435678)");
```

### 线-LineString

```java
Coordinate[] coords  = new Coordinate[] {new Coordinate(2, 2), new Coordinate(2, 2)};
LineString line = geometryFactory.createLineString(coords);
// wkt
WKTReader reader = new WKTReader( geometryFactory );
LineString line = (LineString) reader.read("LINESTRING(0 0, 2 0)");
```

### 多线-MultiLineString

```java
Coordinate[] coords1  = new Coordinate[] {new Coordinate(2, 2), new Coordinate(2, 2)};
LineString line1 = geometryFactory.createLineString(coords1);
Coordinate[] coords2  = new Coordinate[] {new Coordinate(2, 2), new Coordinate(2, 2)};
LineString line2 = geometryFactory.createLineString(coords2);
LineString[] lineStrings = new LineString[2];
lineStrings[0]= line1;
lineStrings[1] = line2;
MultiLineString ms = geometryFactory.createMultiLineString(lineStrings);
// wkt
WKTReader reader = new WKTReader( geometryFactory );
MultiLineString line = (MultiLineString) reader.read("MULTILINESTRING((0 0, 2 0),(1 1,2 2))");
```

### 闭合线-LinearRing

```java
LinearRing lr = new GeometryFactory().createLinearRing(new Coordinate[]{new Coordinate(0, 0), new Coordinate(0, 10), new Coordinate(10, 10), new Coordinate(10, 0), new Coordinate(0, 0)});
```

### 多边形-Polygon

```java
WKTReader reader = new WKTReader( geometryFactory );
Polygon polygon = (Polygon) reader.read("POLYGON((20 10, 30 0, 40 10, 30 20, 20 10))");
```

### 多个多边形-MultiPolygon

```java
WKTReader reader = new WKTReader( geometryFactory );
MultiPolygon mpolygon = (MultiPolygon) reader.read("MULTIPOLYGON(((40 10, 30 0, 40 10, 30 20, 40 10),(30 10, 30 0, 40 10, 30 20, 30 10)))");
```

### 几何[集合](https://so.csdn.net/so/search?q=集合&spm=1001.2101.3001.7020)列表-GeometryCollection

```java
LineString line = createLine();
Polygon poly =  createPolygonByWKT();
Geometry g1 = geometryFactory.createGeometry(line);
Geometry g2 = geometryFactory.createGeometry(poly);
Geometry[] garray = new Geometry[]{g1,g2};
GeometryCollection gc = geometryFactory.createGeometryCollection(garray);
```

## 几何关系判断（返回值 [boolean](https://so.csdn.net/so/search?q=boolean&spm=1001.2101.3001.7020)）

| 关系               | 解释                                                         |
| ------------------ | ------------------------------------------------------------ |
| 相等(Equals)：     | 几何形状拓扑上相等。                                         |
| 不相交(Disjoint)： | 几何形状没有共有的点。                                       |
| 相交(Intersects)： | 几何形状至少有一个共有点（区别于脱节）                       |
| 接触(Touches)：    | 几何形状有至少一个公共的边界点，但是没有内部点。             |
| 交叉(Crosses)：    | 几何形状共享一些但不是所有的内部点。                         |
| 内含(Within)：     | 几何形状A的线都在几何形状B内部。                             |
| 包含(Contains)：   | 几何形状B的线都在几何形状A内部（区别于内含）                 |
| 重叠(Overlaps)：   | 几何形状共享一部分但不是所有的公共点，而且相交处有他们自己相同的区域。 |

举例相交，其他类似

```java
  /**
     * 至少一个公共点(相交)
     * @return
     * @throws ParseException
     */
    public boolean intersectsGeo() throws ParseException{
        WKTReader reader = new WKTReader( geometryFactory );
        LineString geometry1 = (LineString) reader.read("LINESTRING(0 0, 2 0, 5 0)");
        LineString geometry2 = (LineString) reader.read("LINESTRING(0 0, 0 2)");
        Geometry interPoint = geometry1.intersection(geometry2);//相交点
        System.out.println(interPoint.toText());//输出 POINT (0 0)
        return geometry1.intersects(geometry2);
    }
```

## 几何关系分析（返回值 几何对象）

JTS支持基本的空间分析方法。空间分析方法使用一个或两个几何图形作为参数，返回一个新构造的几何图形。

| 分析                          | 解释                                                         |
| ----------------------------- | ------------------------------------------------------------ |
| 缓冲区分析（Buffer）          | 包含所有的点在一个指定距离内的多边形和多多边形               |
| 凸壳分析（ConvexHull）        | 包含几何形体的所有点的最小凸壳多边形（外包多边形）           |
| 交叉分析（Intersection）      | A∩B 交叉操作就是多边形AB中所有共同点的集合                   |
| 联合分析（Union）             | AUB AB的联合操作就是AB所有点的集合                           |
| 差异分析（Difference）        | (A-A∩B) AB形状的差异分析就是A里有B里没有的所有点的集合       |
| 对称差异分析（SymDifference） | (AUB-A∩B) AB形状的对称差异分析就是位于A中或者B中但不同时在AB中的所有点的集合 |

![img](https://img-blog.csdnimg.cn/img_convert/739ab1d96bf2931ce0c3af9b67d7938e.png)

![img](https://img-blog.csdnimg.cn/20210329160151391.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2FidTkzNTAwOTA2Ng==,size_16,color_FFFFFF,t_70)

## 距离、长度、面积计算

- 1.先把坐标系都转成墨卡托
- 2.用jts计算距离
- 3.由于转成墨卡托坐标系，结果比实际偏大，要乘以系数

```java
  		// WGS84(一般项目中常用的是CRS:84和EPSG:4326)
        CoordinateReferenceSystem sourceCRS = CRS.decode("CRS:84");
        // Pseudo-Mercator(墨卡托投影)
        CoordinateReferenceSystem targetCRS = CRS.decode("EPSG:3857");
        MathTransform transform = CRS.findMathTransform(sourceCRS, targetCRS, false);

        GeometryFactory GeometryFactory = new GeometryFactory();

        Coordinate k96 = new Coordinate(117.41722, 31.975379);
        Coordinate k97 = new Coordinate(117.426387, 31.970712);
        Geometry line = JTS.transform(GeometryFactory.createLineString(new Coordinate[]{k96, k97}), transform);
		//double rate1 = Math.cos(Math.toRadians(k96.y)); 距离短的话乘以这个就行, 大概为： 0.8482973000510488
        double rate = Math.cos((Math.toRadians(k96.y) + Math.toRadians(k97.y)) / 2.000000);//距离长的话用这个
        System.out.println("rate: " + rate);
        // 面积、周长
        System.out.println(line.getArea());// 面积未验证是乘以 rate 还是其平方
        System.out.println(line.getLength() * rate);
        Coordinate tmp = new Coordinate(117.417145, 31.975465);
        Geometry point = JTS.transform(GeometryFactory.createPoint(tmp), transform);
        System.out.println(point.distance(line) * rate);
```

## 按照代码包把所有功能介绍下

![img](https://img-blog.csdnimg.cn/20210401165146985.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2FidTkzNTAwOTA2Ng==,size_16,color_FFFFFF,t_70)

## 图形可视化化WKT数据（好用的一比）

工具包+相关文档下载：https://download.csdn.net/download/abu935009066/16208250

偶然间发现可以使用jts中的工具可视化我们的WKT数据。

![img](https://img-blog.csdnimg.cn/2021040114113871.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2FidTkzNTAwOTA2Ng==,size_16,color_FFFFFF,t_70)

> 需要java环境

![img](https://img-blog.csdnimg.cn/20210401141752658.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2FidTkzNTAwOTA2Ng==,size_16,color_FFFFFF,t_70)

## 项目实战

### 几何到另一个几何最近的点

```java
GeometryFactory gf = JTSFactoryFinder.getGeometryFactory(null);
WKTReader reader = new WKTReader(gf);
Geometry line2 = reader.read("LINESTRING(0 0, 10 0, 10 10, 20 10)");
Coordinate c = new Coordinate(5, 5);
PointPairDistance ppd = new PointPairDistance();
DistanceToPoint.computeDistance(line2, c, ppd);
System.out.println(ppd.getDistance());
for (Coordinate cc : ppd.getCoordinates()) {
    System.out.println(cc);
}
```

### 求几何的交点

```java
// create ring: P1(0,0) - P2(0,10) - P3(10,10) - P4(0,10)
LinearRing lr = new GeometryFactory().createLinearRing(new Coordinate[]{new Coordinate(0,0), new Coordinate(0,10), new Coordinate(10,10), new Coordinate(10,0), new Coordinate(0,0)});
// create line: P5(5, -1) - P6(5, 11) -> crossing the ring vertically in the middle
LineString ls = new GeometryFactory().createLineString(new Coordinate[]{new Coordinate(5,-1), new Coordinate(5,11)});
// calculate intersection points
Geometry intersectionPoints = lr.intersection(ls);
// simple output of points
for(Coordinate c : intersectionPoints.getCoordinates()){
    System.out.println(c.toString());
}
```

### 利用缓冲画圆

创建一个包含在设定距离内的所有点的面或多面(想要圆，但是没有。。。)：

```
geometry = point
Geometry buffer = geometry.buffer( 2.0 ); // note distance is in same units as geometry
```

![img](https://img-blog.csdnimg.cn/20210401141021318.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2FidTkzNTAwOTA2Ng==,size_16,color_FFFFFF,t_70)

### 根据起始点求一个线的子线

**已知**：起点、终点、道路
**求解**：其在道路上的子轨迹
![img](https://img-blog.csdnimg.cn/20210401145541607.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2FidTkzNTAwOTA2Ng==,size_16,color_FFFFFF,t_70)

```java
GeometryFactory GeometryFactory = new GeometryFactory();
WKTReader reader = new WKTReader(GeometryFactory);
Geometry geom = reader.read("LINESTRING(0 0, 10 0, 10 10, 20 10)");
LocationIndexedLine lil = new LocationIndexedLine(geom);
LinearLocation start = lil.indexOf(new Coordinate(8, 5));
LinearLocation end = lil.indexOf(new Coordinate(17, 10));
Geometry result = lil.extractLine(start, end);
System.out.println(result.toText());
// 结果        
LINESTRING (10 5, 10 10, 17 10)
```

![img](https://img-blog.csdnimg.cn/20210401150142269.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2FidTkzNTAwOTA2Ng==,size_16,color_FFFFFF,t_70)

### 计算道路与起点之间指定距离之间的交点坐标

**已知**：道路、在道路的距离
**求解**：到起点坐标距离的点

```java
public static Coordinate lengthOnLineString2(Geometry roadLine, double length) {
    LocationIndexedLine locationIndexedLine = new LocationIndexedLine(roadLine);
    LinearLocation linearLocation = LengthLocationMap.getLocation(roadLine, length);
    Coordinate result = locationIndexedLine.extractPoint(linearLocation);
    return result;
}
```

参考：

- https://blog.csdn.net/yatsov/article/details/80215278
- https://geotools.org/
- http://locationtech.github.io/jts/javadoc/overview-summary.html
- https://www.giserdqy.com/geoanalysis/29813/
- http://docs.geotools.org/latest/userguide/welcome/architecture.html
- https://docs.geotools.org/latest/userguide/library/jts/geometry.html
- https://docs.geotools.org/latest/userguide/library/jts/snap.html