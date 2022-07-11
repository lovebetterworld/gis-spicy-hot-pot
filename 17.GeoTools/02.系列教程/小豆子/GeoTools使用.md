- [GeoTools基本使用 · GeoTools使用文档 (gitee.io)](http://shengshifeiyang.gitee.io/geotools-learning/use-guider/)

## 1 添加依赖

```xml
<?xml version="1.0" encoding="UTF-8"?>

<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>

  <groupId>com.dukk</groupId>
  <artifactId>geotools-learning</artifactId>
  <version>1.0-SNAPSHOT</version>

  <name>geotools-learning</name>
  <!-- FIXME change it to the project's website -->
  <url>http://www.example.com</url>

  <properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <geotools.version>24.0</geotools.version>
    <maven.compiler.source>1.8</maven.compiler.source>
    <maven.compiler.target>1.8</maven.compiler.target>
  </properties>

  <dependencies>
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>4.13.1</version>
      <scope>test</scope>
    </dependency>
    <dependency>
      <groupId>org.geotools</groupId>
      <artifactId>gt-shapefile</artifactId>
      <version>${geotools.version}</version>
    </dependency>
    <dependency>
      <groupId>org.geotools</groupId>
      <artifactId>gt-swing</artifactId>
      <version>${geotools.version}</version>
    </dependency>
  </dependencies>

  <build>
    <plugins>
      <plugin>
        <inherited>true</inherited>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-compiler-plugin</artifactId>
        <configuration>
          <source>1.8</source>
          <target>1.8</target>
        </configuration>
      </plugin>
    </plugins>
  </build>
</project>
```

## 2 创建GeoTools

### 2.1 例如

```
FilterFactory2 factory = CommonFactoryFinder.getFilterFactory2( null );
Filter filter = factory.less( factory.property( "size" ), factory.literal( 2 ) );

if( filter.evaulate( feature )){
   System.out.println( feature.getId() + " had a size larger than 2" );
}
```

In this example we:

1. Found an object which implements the GeoAPI `FilterFactory2` interface using a `FactoryFinder`.

   (`CommonFactoryFinder` gave us `FilterFactoryImpl` in this case)

2. Used the Factory to produce our Instance.

   (`FilterFactoryImpl.less(..)` method was used to create a `PropertyIsLessThan` Filter)

3. Used the instance to accomplish something.

   (we used the filter to check the size of a `Feature` )

### 2.2 `FactoryFinder` Reference

#### 2.2.1 CommonFactoryFinder

- `FilterFactory`
- `StyleFactory`
- `Function`
- `FileDataStore` - factory used to work with file data stores
- `FeatureFactory` - factory used to create features
- `FeatureTypeFactory` - factory used to create feature type description
- `FeatureCollections` - factory used to create feature collection

#### 2.2.2 特征(向量)获取方法

- `DataAccessFinder` - listing `DataAccessFactory` for working with feature data
- `DataStoreFinder` - lists `DataStoreFactorySpi` limited to simple features
- `FileDataStoreFinder` - Create of `FileDataStoreFactorySpi` instances limited to file formats

#### 2.2.3 栅格获取方法

- `GridFormatFinder` - access to `GridFormatFactorySpi` supporting raster formats
- `CoverageFactoryFinder` - access to `GridCoverageFactory`

#### 2.2.4 JTSFactoryFinder

> used to create JTS GeometryFactory and PercisionModel

- `GeometryFactory`
- `PrecisionModel`

#### 2.2.5 ReferencingFactoryFinder

> used to list referencing factories

- `DatumFactory`
- `CSFactory`
- `DatumAuthorityFactory`
- `CSAuthorityFactory`
- `CRSAuthorityFactory`
- `MathTransformFactory`
- `CoordinateOperationFactory`
- `CoordinateOperationAuthorityFactory`

## 3 创建Feature

A feature is something that can be drawn on a map. The strict definition is that a feature is something in the real world – a feature of the landscape - Mt Everest, the Eiffel Tower(特征是可以画在地图上的东西。严格的定义是，特征是现实世界中的一些东西——风景中的一个特征——珠穆朗玛峰、埃菲尔铁塔)

### 3.1 java与geospatial对照关系

| Java     | Geospatial    |
| :------- | :------------ |
| `Object` | `Feature`     |
| `Class`  | `FeatureType` |
| `Field`  | `Attribute`   |
| `Method` | `Operation`   |

### 3.2 FeatureClass

![feature类UML](http://shengshifeiyang.gitee.io/geotools-learning/assets/feature.png)

### 3.3 Geometry

The other difference between an Object and a Feature is that a Feature has some form of location information (if not we would not be able to draw it on a map). The location information is going to be captured by a Geometry (or shape) that is stored in an attribute.

![geometry图片](http://shengshifeiyang.gitee.io/geotools-learning/assets/geometry.png)

We make use of the JTS Topology Suite (JTS) to represent `Geometry`. The JTS library provides an excellent implementation of `Geometry` – and gets geeky points for having a recursive acronym! JTS is an amazing library and does all the hard graph theory to let you work with geometry in a productive fashion.

Here is an example of creating a `Point` using the Well-Known-Text (WKT) format.

```
GeometryFactory geometryFactory = JTSFactoryFinder.getGeometryFactory( null );

WKTReader reader = new WKTReader( geometryFactory );
Point point = (Point) reader.read("POINT (1 1)");
Copy
```

You can also create a `Point` by hand using the `GeometryFactory` directly.

```
GeometryFactory geometryFactory = JTSFactoryFinder.getGeometryFactory( null );

Coordinate coord = new Coordinate( 1, 1 );
Point point = geometryFactory.createPoint( coord );
Copy
```

### 3.4 DataStore

The DataStore API is used to represent a File, Database or Service that has spatial data in it. The API has a couple of moving parts as shown below.

![img](http://shengshifeiyang.gitee.io/geotools-learning/assets/datastore.png)

The `FeatureSource` is used to read features, the sub-class `FeatureStore` is used for read/write access.

The way to tell if a `File` can be written to in GeoTools is to use an `instanceof` check.

```
String typeNames = dataStore.getTypeNames()[0];
SimpleFeatureSource source = store.getfeatureSource( typeName );
if( source instanceof SimpleFeatureStore){
   SimpleFeatureStore store = (SimpleFeatureStore) source; // write access!
   store.addFeatures( featureCollection );
   store.removeFeatures( filter ); // filter is like SQL WHERE
   store.modifyFeature( attribute, value, filter );
}
```

## 4 JTS-Geometry使用说明

### 4.1 JTS-geometry结构图

![结构图](http://shengshifeiyang.gitee.io/geotools-learning/assets/geometry1.png)

### 4.2 GeometryCollections

![结构图](http://shengshifeiyang.gitee.io/geotools-learning/assets/geometry_collection.png)

### 4.3 GeometryFactory

![结构图](http://shengshifeiyang.gitee.io/geotools-learning/assets/geometry_factory.png)

### 4.4 GeoTools extends

曲面扩展

![结构图](http://shengshifeiyang.gitee.io/geotools-learning/assets/geometry2.png)

### 4.5 创建点

```
 //通过 coordinate创建
 GeometryFactory geometryFactory = JTSFactoryFinder.getGeometryFactory();

 Coordinate coord = new Coordinate(1, 1);
 Point point = geometryFactory.createPoint(coord);

 //通过wkt 创建
 GeometryFactory geometryFactory = JTSFactoryFinder.getGeometryFactory();

 WKTReader reader = new WKTReader(geometryFactory);
 Point point = (Point) reader.read("POINT (1 1)");
```

### 4.6 创建线

```
GeometryFactory geometryFactory = JTSFactoryFinder.getGeometryFactory();

Coordinate[] coords  =
 new Coordinate[] {new Coordinate(0, 2), new Coordinate(2, 0), new Coordinate(8, 6) };

LineString line = geometryFactory.createLineString(coordinates);

//wkt方式
GeometryFactory geometryFactory = JTSFactoryFinder.getGeometryFactory();

WKTReader reader = new WKTReader( geometryFactory );
LineString line = (LineString) reader.read("LINESTRING(0 2, 2 0, 8 6)");
```

### 4.7 创建多边形

```
GeometryFactory geometryFactory = JTSFactoryFinder.getGeometryFactory();

Coordinate[] coords  =
   new Coordinate[] {new Coordinate(4, 0), new Coordinate(2, 2),
                     new Coordinate(4, 4), new Coordinate(6, 2), new Coordinate(4, 0) };

LinearRing ring = geometryFactory.createLinearRing( coords );
LinearRing holes[] = null; // use LinearRing[] to represent holes
Polygon polygon = geometryFactory.createPolygon(ring, holes );

//wkt方式
GeometryFactory geometryFactory = JTSFactoryFinder.getGeometryFactory( null );

WKTReader reader = new WKTReader( geometryFactory );
Polygon polygon = (Polygon) reader.read("POLYGON((20 10, 30 0, 40 10, 30 20, 20 10))");

```

Geometry relationships are represented by the following functions returning true or false:

- `disjoint(Geometry)` - same as “not” intersects
- `touches(Geometry)` - geometry have to just touch, crossing or overlap will not work
- `intersects(Geometry)`
- `crosses(Geometry)`
- `within(Geometry)` - geometry has to be full inside
- `contains(Geometry)`
- `overlaps(Geometry)` - has to actually overlap the edge, being within or touching will not work
- `covers(Geometry)`
- `coveredBy(Geometry)`
- `relate(Geometry, String)` - allows general check of relationship see [dim9 page](https://docs.geotools.org/latest/userguide/library/jts/dim9.html)
- `relate(Geometry)`

To actually determine a shape based on two geometry:

- `intersection(Geometry)`
- `union(Geometry)`
- `difference(Geometry)`
- `symDifference(Geometry)`

Some of the most helpful functions are:

- `distance(Geometry)`
- `buffer(double)` - used to buffer the edge of a geometry to produce a polygon
- `union()` - used on a geometry collection to produce a single geometry

The three most difficult methods are here (they will be discussed in detail):

- `equals(Object)` - normal Java equals which checks that the two objects are the same instance
- `equals(Geometry)` - checks if the geometry is the same shape
- `equalsExact(Geometry)` - check if the data structure is the same

There are some book keeping methods to help discovery how the geometry was constructed:

- `getGeometryFactory()`
- `getPreceisionModel()`
- `toText()` - the WKT representation of the Geometry
- `getGeoemtryType()` - factory method called (i.e. `point`, `linestring`, etc..)

A couple of methods are there to store your developer information:

- `getSRID()` - stores the “spatial reference id”, used as an external key when working with databases
- `getUserData()` - intended to be used by developers, a best practice is to store a `java.util.Map`. GeoTools will occasionally use this field to store a `srsName` or full `CoordinateReferenceSystem`.