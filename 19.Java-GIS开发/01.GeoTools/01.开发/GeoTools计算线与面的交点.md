- [GeoTools计算线与面的交点_一壶清茶i的博客-CSDN博客_线和面的交点怎么求](https://blog.csdn.net/zuorichongxian_/article/details/110260923)

# 一、[maven](https://so.csdn.net/so/search?q=maven&spm=1001.2101.3001.7020)引入GeoTools依赖

项目中用到的Geotools中的依赖都在这了，如果只是实现本文的线与面的交点功能，则不需要全部添加。

```java
<repositories>
	<repository>
		<id>osgeo</id>
		<name>Open Source Geospatial Foundation Repository</name>
		<url>http://download.osgeo.org/webdav/geotools/</url>
	</repository>
</repositories>

<properties>
	<geotools.version>17.0</geotools.version>
</properties>

<dependencies>
	<dependency>
		<groupId>org.geotools</groupId>
		<artifactId>gt-shapefile</artifactId>
		<version>${geotools.version}</version>
	</dependency>
	<dependency>
		<groupId>org.geotools</groupId>
		<artifactId>gt-main</artifactId>
		<version>${geotools.version}</version>
	</dependency>
	<dependency>
		<groupId>org.geotools</groupId>
		<artifactId>gt-geojson</artifactId>
		<version>${geotools.version}</version>
	</dependency>
	<dependency>
		<groupId>org.geotools</groupId>
		<artifactId>gt-swing</artifactId>
		<version>${geotools.version}</version>
	</dependency>
</dependencies>

```

# 二、方法实现

这里考虑了面状数据为Polygon和MultiPolygon的情况，其中MultiPolygon中考虑每个Polygon中包含环的情况。

## 1.实现思路

将面状数据（Polygon/MultiPolygon）转换为线状数据（MultiLineString），然后使用GeoTools提供的intersection方法，计算两条线的交点坐标。

## 2.面转换为线

面转换为线代码如下：

```java
public static Geometry polygon2LineString(Geometry geoms) {
		GeometryFactory gf = JTSFactoryFinder.getGeometryFactory();
		String type = geoms.getGeometryType().toUpperCase();
		Geometry res;

		if ("MULTIPOLYGON".equals(type)) {
			int geomNum = geoms.getNumGeometries();
			List<LineString> lineList = new ArrayList<>();
			if (geomNum > 1) {
				// 包含多个面，面中包含环
				for (int i = 0; i < geomNum; i++) {
					Polygon geo = (Polygon) geoms.getGeometryN(i);
					lineList.add(gf.createLineString(geo.getExteriorRing().getCoordinates()));
					for (int j = 0; j < geo.getNumInteriorRing(); j++) {
						lineList.add(gf.createLineString(geo.getInteriorRingN(i).getCoordinates()));
					}
				}
				LineString[] lines = new LineString[lineList.size()];
				lineList.toArray(lines);
				res = gf.createMultiLineString(lines);
			} else {
				// 包含一个面，面中包含环
				Polygon poly = (Polygon) geoms.getGeometryN(0);
				lineList.add(gf.createLineString(poly.getExteriorRing().getCoordinates()));
				for (int i = 0; i < poly.getNumInteriorRing(); i++) {
					lineList.add(gf.createLineString(poly.getInteriorRingN(i).getCoordinates()));
				}
				LineString[] lines = new LineString[lineList.size()];
				lineList.toArray(lines);
				res = gf.createMultiLineString(lines);
			}
		} else if ("POLYGON".equals(type)) {
			// 只包含一个面
			res = gf.createLineString(geoms.getCoordinates());
		} else {
			res = null;
		}
		return res;
	}
```

## 3.计算交点坐标

```java
public static Geometry getPointOfIntersection(Geometry geom, Geometry line) {
	//面转换为线
	Geometry lines = polygon2LineString(geom);
	return lines.intersection(line);
}
```

## 4.wkt转Geometry

此部分代码在代码测试中用到。

```java
public static Geometry wkt2Geometry(String wktString) {
	GeometryFactory gc = JTSFactoryFinder.getGeometryFactory();
    WKTReader reader = new WKTReader(gc);
    Geometry geom = null;
    try {
        geom = reader.read(wktString);
    } catch (ParseException e) {
        e.printStackTrace();
    }
    return geom;
}
```

## 5.完整代码

```java
import java.util.ArrayList;
import java.util.List;
import org.geotools.geometry.jts.JTSFactoryFinder;
import com.vividsolutions.jts.geom.Geometry;
import com.vividsolutions.jts.geom.GeometryFactory;
import com.vividsolutions.jts.geom.LineString;
import com.vividsolutions.jts.geom.Polygon;
import com.vividsolutions.jts.io.ParseException;
import com.vividsolutions.jts.io.WKTReader;

public class PointOfIntersectionTest {
	/**
	 * Polygon转换为LineString
	 * @param geoms
	 * @return
	 */
	public static Geometry polygon2LineString(Geometry geoms) {
		GeometryFactory gf = JTSFactoryFinder.getGeometryFactory();
		String type = geoms.getGeometryType().toUpperCase();
		Geometry res;

		if ("MULTIPOLYGON".equals(type)) {
			int geomNum = geoms.getNumGeometries();
			List<LineString> lineList = new ArrayList<>();
			if (geomNum > 1) {
				// 包含多个面，面中包含环
				for (int i = 0; i < geomNum; i++) {
					Polygon geo = (Polygon) geoms.getGeometryN(i);
					lineList.add(gf.createLineString(geo.getExteriorRing().getCoordinates()));
					for (int j = 0; j < geo.getNumInteriorRing(); j++) {
						lineList.add(gf.createLineString(geo.getInteriorRingN(i).getCoordinates()));
					}
				}
				LineString[] lines = new LineString[lineList.size()];
				lineList.toArray(lines);
				res = gf.createMultiLineString(lines);
			} else {
				// 包含一个面，面中包含环
				Polygon poly = (Polygon) geoms.getGeometryN(0);
				lineList.add(gf.createLineString(poly.getExteriorRing().getCoordinates()));
				for (int i = 0; i < poly.getNumInteriorRing(); i++) {
					lineList.add(gf.createLineString(poly.getInteriorRingN(i).getCoordinates()));
				}
				LineString[] lines = new LineString[lineList.size()];
				lineList.toArray(lines);
				res = gf.createMultiLineString(lines);
			}
		} else if ("POLYGON".equals(type)) {
			// 只包含一个面
			res = gf.createLineString(geoms.getCoordinates());
		} else {
			res = null;
		}
		return res;
	}
	
	/**
	 * wkt转Geometry
	 * @param wktString
	 * @return
	 */
	public static Geometry wkt2Geometry(String wktString) {
		GeometryFactory gc = new GeometryFactory();
        WKTReader reader = new WKTReader(gc);
        Geometry geom = null;
        try {
            geom = reader.read(wktString);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return geom;
    }
	
	public static void main(String[] args) {
		String poly = "Polygon((1.0 1.0, 2.0 1.0, 2.0 2.0, 1.0 2.0, 1.0 1.0))";
		//String poly = "MultiPolygon(((1.0 1.0, 2.0 1.0, 2.0 2.0, 1.0 2.0, 1.0 1.0),(1.2 1.2, 1.8 1.2, 1.8 1.8, 1.2 1.8, 1.2 1.2)))";
		Geometry geoms = wkt2Geometry(poly);
		Geometry polyGeo = polygon2LineString(geoms);
		// 面转线结果
		System.out.println(polyGeo.toText());
		
		String line1 = "LineString(1.5 0.0, 1.5 1.5)";
		Geometry lineGeo = wkt2Geometry(line1);
		Geometry points = polyGeo.intersection(lineGeo);
		System.out.println(points.toText());
	}
}
```

## 6.测试结果

上述代码运行完的结果为：

```javascript
LINESTRING (1 1, 2 1, 2 2, 1 2, 1 1)
POINT (1.5 1)
```

使用QGIS对上述结果可视化：
![图1结果可视化1](https://img-blog.csdnimg.cn/2020112811491585.jpg?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3p1b3JpY2hvbmd4aWFuXw==,size_16,color_FFFFFF,t_70#pic_center)
使用main函数中注释的MultiPolygon数据做测试，运行结果为：

```javascript
MULTILINESTRING ((1 1, 2 1, 2 2, 1 2, 1 1), (1.2 1.2, 1.8 1.2, 1.8 1.8, 1.2 1.8, 1.2 1.2))
MULTIPOINT ((1.5 1), (1.5 1.2))
```

使用QGIS对上述结果可视化：

![图2 结果可视化2](https://img-blog.csdnimg.cn/20201128115346189.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3p1b3JpY2hvbmd4aWFuXw==,size_16,color_FFFFFF,t_70)