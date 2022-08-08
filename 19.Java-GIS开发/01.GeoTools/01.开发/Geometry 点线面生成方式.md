- [Geometry 点线面生成方式_weixir123的博客-CSDN博客](https://blog.csdn.net/weixir123/article/details/84602138)

## Creating a Point

```java
 GeometryFactory geometryFactory = JTSFactoryFinder.getGeometryFactory();
    
    Coordinate coord = new Coordinate(1, 1);
    Point point = geometryFactory.createPoint(coord);
```

 或者WKTReader

```java
 GeometryFactory geometryFactory = JTSFactoryFinder.getGeometryFactory();
    
    WKTReader reader = new WKTReader(geometryFactory);
    Point point = (Point) reader.read("POINT (1 1)");
```

## Creating a LineString

```java
GeometryFactory geometryFactory = JTSFactoryFinder.getGeometryFactory( null );
 
Coordinate[] coords  =
 new Coordinate[] {new Coordinate(0, 2), new Coordinate(2, 0), new Coordinate(8, 6) };
 
LineString line = geometryFactory.createLineString(coordinates);
```

 或者WKTReader

```java
GeometryFactory geometryFactory = JTSFactoryFinder.getGeometryFactory( null );
 
WKTReader reader = new WKTReader( geometryFactory );
LineString line = (LineString) reader.read("LINESTRING(0 2, 2 0, 8 6)");
```

## Creating a Polygon

```java
GeometryFactory geometryFactory = JTSFactoryFinder.getGeometryFactory( null );
 
Coordinate[] coords  =
   new Coordinate[] {new Coordinate(4, 0), new Coordinate(2, 2),
                     new Coordinate(4, 4), new Coordinate(6, 2), new Coordinate(4, 0) };
 
LinearRing ring = geometryFactory.createLinearRing( coords );
LinearRing holes[] = null; // use LinearRing[] to represent holes
Polygon polygon = geometryFactory.createPolygon(ring, holes );
```

  或者WKTReader

```java
GeometryFactory geometryFactory = JTSFactoryFinder.getGeometryFactory( null );
 
WKTReader reader = new WKTReader( geometryFactory );
Polygon polygon = (Polygon) reader.read("POLYGON((20 10, 30 0, 40 10, 30 20, 20 10))");
```