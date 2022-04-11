- [WKT、WKB和GeoJson_自己的九又四分之三站台的博客-CSDN博客_js wkt转geojson](https://qlygmwcx.blog.csdn.net/article/details/109575727)

## 1. 简介

1. WKT(Well-known text)是开放地理空间联盟OGC（Open GIS Consortium ）制定的一种文本标记语言，用于表示矢量几何对象、空间参照系统及空间参照系统之间的转换。
2. WKB(well-known binary) 是WKT的二进制表示形式，解决了WKT表达方式冗余的问题，便于传输和在数据库中存储相同的信息
3. GeoJSON 一种JSON格式的Feature信息输出格式，它便于被JavaScript等脚本语言处理，OpenLayers等地理库便是采用GeoJSON格式。此外，TopoJSON等更精简的扩展格式

## 2. WKT

WKT可以表示的对象包括以下几种：

Point, MultiPoint

LineString, MultiLineString

Polygon, MultiPolygon

GeometryCollection

可以由多种Geometry组成，如：GEOMETRYCOLLECTION(POINT(4 6),LINESTRING(4 6,7 10)

| Type            | WKT                                                          | GeoJSON                                                      |
| --------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Point           | POINT (30 10)                                                | { “type”: “Point”, “coordinates”: [30, 10] }                 |
| LineString      | LINESTRING (30 10, 10 30, 40 40)                             | { “type”: “LineString”, “coordinates”: [ [30, 10], [10, 30], [40, 40] ] } |
| Polygon         | POLYGON ((30 10, 40 40, 20 40, 10 20, 30 10))                | { “type”: “Polygon”, “coordinates”: [ [[30, 10], [40, 40], [20, 40], [10, 20], [30, 10]] ] } |
| Polygon         | POLYGON ((35 10, 45 45, 15 40, 10 20, 35 10),(20 30, 35 35, 30 20, 20 30)) | { “type”: “Polygon”, “coordinates”: [ [[35, 10], [45, 45], [15, 40], [10, 20], [35, 10]], [[20, 30], [35, 35], [30, 20], [20, 30]] ] } |
| MultiPoint      | MULTIPOINT ((10 40), (40 30), (20 20), (30 10))              | { “type”: “MultiPoint”, “coordinates”: [ [10, 40], [40, 30], [20, 20], [30, 10] ] } |
| MultiPoint      | MULTIPOINT (10 40, 40 30, 20 20, 30 10)                      | { “type”: “MultiPoint”, “coordinates”: [ [10, 40], [40, 30], [20, 20], [30, 10] ] } |
| MultiLineString | MULTILINESTRING ((10 10, 20 20, 10 40),(40 40, 30 30, 40 20, 30 10)) | { “type”: “MultiLineString”, “coordinates”: [ [[10, 10], [20, 20], [10, 40]], [[40, 40], [30, 30], [40, 20], [30, 10]] ] } |
| MultiPolygon    | MULTIPOLYGON (((30 20, 45 40, 10 40, 30 20)),((15 5, 40 10, 10 20, 5 10, 15 5))) | { “type”: “MultiPolygon”, “coordinates”: [ [ [[30, 20], [45, 40], [10, 40], [30, 20]] ], [ [[15, 5], [40, 10], [10, 20], [5, 10], [15, 5]] ] ] } |
| MultiPolygon    | MULTIPOLYGON (((40 40, 20 45, 45 30, 40 40)),((20 35, 10 30, 10 10, 30 5, 45 20, 20 35),(30 20, 20 15, 20 25, 30 20))) | { “type”: “MultiPolygon”, “coordinates”: [ [ [[40, 40], [20, 45], [45, 30], [40, 40]] ], [ [[20, 35], [10, 30], [10, 10], [30, 5], [45, 20], [20, 35]], [[30, 20], [20, 15], [20, 25], [30, 20]] ] ] } |

WKT与geojson的主要区别是wkt是单独用来表示空间点线面数据的，而geojson还可以用来表示空间数据和属性数据的集合，下面是shp面数据转geojson，其中还包含图层信息等，而wkt并不能表示这个。

```json
{
    "type": "FeatureCollection",
    "name": "a",
    "crs": { "type": "name", "properties": { "name": "urn:ogc:def:crs:EPSG::3857" } },
    "features": [
        { "type": "Feature", "properties": { "AREA": 0.0, "PERIMETER": 0.016, "BOU2_4M_": 914, "BOU2_4M_ID": 3089, "ADCODE93": 810000, "ADCODE99": 810000, "NAME": "xiaocaitongxue" }, "geometry": { "type": "Polygon", "coordinates": [ [ [ 12720007.326881121844053, 2544771.959127825684845 ], [ 12720092.256912549957633, 2545226.735669989138842 ], [ 12720510.112667175009847, 2545228.571321710944176 ], [ 12720666.383925, 2544938.081929029431194 ], [ 12720007.326881121844053, 2544771.959127825684845 ] ] ] } },
        { "type": "Feature", "properties": { "AREA": 0.0, "PERIMETER": 0.013, "BOU2_4M_": 915, "BOU2_4M_ID": 3090, "ADCODE93": 810000, "ADCODE99": 810000, "NAME": "xiaocaitongxue" }, "geometry": { "type": "Polygon", "coordinates": [ [ [ 12730249.039371021091938, 2544414.938326342497021 ], [ 12730198.930652478709817, 2544711.384370831772685 ], [ 12730315.28479553386569, 2544832.534102902282029 ], [ 12730576.019992018118501, 2544807.065052719321102 ], [ 12730715.30524355918169, 2544607.902998786885291 ], [ 12730353.503309676423669, 2544404.842732572928071 ], [ 12730249.039371021091938, 2544414.938326342497021 ] ] ] } }]
}
12345678
```

## 3. WKB

WKB是采用[二进制](https://so.csdn.net/so/search?q=二进制&spm=1001.2101.3001.7020)存储表示点线面等

WKB采用二进制进行存储，更方便于计算机处理，因此广泛运用于数据的传输与存储，以二位点Point(1 1)为例，
其WKB表达如下：

```
01  0100 0020 E6100000  000000000000F03F 000000000000F03F
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/e07ee894b250457fb8f0b8035b9c9620.png#pic_center)

### byteOrder

表示编码方式，00为使用big-endian编码(XDR)，01为使用little-endian编码(NDR)。他们的不同仅限于在内存中放置字节的顺序，比如我们将0x1234abcd写入到以0×0000开始的内存中，则结果如下表：

| Address | big-endian | little-endian |
| ------- | ---------- | ------------- |
| 0×0000  | 0x12       | 0xcd          |
| 0×0001  | 0x34       | 0xab          |
| 0×0002  | 0xab       | 0x34          |
| 0×0003  | 0xcd       | 0x12          |

### webTypd

- 第二到第九字节对矢量数据基本信息进行了定义
  第二与第三个字节规定了矢量数据的类型，如例子中的0100代表Point；
  - 第三与第四个字节规定了矢量数据的维数，如例子中的0020代表该点是二位的；
  - 第五到第九个字节规定了矢量数据的空间参考SRID，如例子中的E6100000是4326的整数十六位进制表达

### srid

- 第五到第九个字节规定了矢量数据的空间参考SRID，如例子中的E6100000是4326的整数十六位进制表达

### structPoint

- 第十个字节开始，每16个字节就代表一个坐标对，如例子中的000000000000F03F是浮点型1的十六进制表达

## 4. GeoJson

1. GeoJSON是一种对各种地理数据结构进行编码的格式，基于Javascript对象表示法的地理空间信息数据交换格式。GeoJSON对象可以表示几何、特征或者特征集合。GeoJSON支持下面几何类型：点、线、面、多点、多线、多面和几何集合。GeoJSON里的特征包含一个几何对象和其他属性，特征集合表示一系列特征。
2. 一个完整的GeoJSON数据结构总是一个（JSON术语里的）对象。在GeoJSON里，对象由名/值对–也称作成员的集合组成。对每个成员来说，名字总是字符串。成员的值要么是字符串、数字、对象、数组，要么是下面文本常量中的一个：“true”,“false"和"null”。数组是由值是上面所说的元素组成。
3. GeoJSON总是由一个单独的对象组成。这个对象（指的是下面的GeoJSON对象）表示几何、特征或者特征集合。

- GeoJSON对象可能有任何数目成员（名/值对）。
- GeoJSON对象必须有一个名字为"type"的成员。这个成员的值是由GeoJSON对象的类型所确定的字符串。
- type成员的值必须是下面之一：“Point”, “MultiPoint”, “LineString”, “MultiLineString”, “Polygon”, “MultiPolygon”, “GeometryCollection”, “Feature”, 或者 “FeatureCollection”。
- GeoJSON对象可能有一个可选的"crs"成员，它的值必须是一个坐标参考系统的对象。
- GeoJSON对象可能有一个"bbox"成员，它的值必须是边界框数组。

GeoJSON特征集合：

```json
{
    "type": "FeatureCollection",
    "features": [{
        "type": "Feature",
        "geometry": {
            "type": "Point",
            "coordinates": [102.0, 0.5]
        },
        "properties": {
            "prop0": "value0"
        }
    }, {
        "type": "Feature",
        "geometry": {
            "type": "LineString",
            "coordinates": [[102.0, 0.0], [103.0, 1.0], [104.0, 0.0], [105.0, 1.0]]
        },
        "properties": {
            "prop0": "value0",
            "prop1": 0.0
        }
    }, {
        "type": "Feature",
        "geometry": {
            "type": "Polygon",
            "coordinates": [[100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0]]
        },
        "properties": {
            "prop0": "value0",
            "prop1": {
                "this": "that"
            }
        }
    }
                ]
}
```