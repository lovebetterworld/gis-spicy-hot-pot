- [基于Postgresql和PostGIS实现火星坐标系、百度坐标系、WGS84坐标系、CGCS2000坐标系互转](https://hanbo.blog.csdn.net/article/details/105383981)



## 背景

最近有一个需求，需要将WGS84转成火星坐标系。个人觉得在代码中逐个点坐标进行转换，太麻烦，而且效率低。PostGIS的***st_transform\***虽然可以进行坐标转换，但是不支持国内这些坐标系。最后在网上找了有人编写的一个***[pg-coordtransform](https://links.jianshu.com/go?to=https%3A%2F%2Fgithub.com%2Fgeocompass%2Fpg-coordtransform)
 ***库，可以在火星坐标系、百度坐标系、WGS84坐标系、CGCS2000坐标系之间互转，部署也很简单。

## 使用过程

- 部署PostGIS(已有直接下一步)
- 直接把[github](https://links.jianshu.com/go?to=https%3A%2F%2Fgithub.com%2Fgeocompass%2Fpg-coordtransform%2Fblob%2Fmaster%2Fgeoc-pg-coordtransform.sql)
   )上的sql拿下来运行一下，然后就可以用了

```plsql
-- 如果转换后结果为null，查看geom的srid是否为4326或者4490
WGS84转GCJ02
select geoc_wgs84togcj02(geom) from test_table
GCJ02转WGS84
select geoc_gcj02towgs84(geom) from test_table

WGS84转BD09
select geoc_wgs84tobd09(geom) from test_table
BD09转WGS84
select geoc_bd09towgs84(geom) from test_table

CGCS2000转GCJ02
select geoc_cgcs2000togcj02(geom) from test_table
GCJ02转CGCS2000
select geoc_gcj02tocgcs2000(geom) from test_table

CGCS2000转BD09
select geoc_cgcs2000tobd09(geom) from test_table
BD09转CGCS2000
select geoc_bd09tocgcs2000(geom) from test_table

GCJ02转BD09
select geoc_gcj02tobd09(geom) from test_table
BD09转GCJ02
select geoc_bd09togcj02(geom) from test_table
```

## 使用demo

```plsql
select st_asgeojson(geoc_wgs84togcj02(st_setsrid(shape,4326))) from dt_cbdk where shape is not null limit 1
```

![img](https://imgconvert.csdnimg.cn/aHR0cHM6Ly91cGxvYWQtaW1hZ2VzLmppYW5zaHUuaW8vdXBsb2FkX2ltYWdlcy8xOTg1Mzc1NC1lZjQyMTdhMzAwMjA4MWIwLnBuZw?x-oss-process=image/format,png)

 

- 原来的坐标系统必须为4326或4490，否在转换结果为null
- 可以使用st_setsrid()给空间字段添加srid

