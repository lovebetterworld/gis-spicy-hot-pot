- [GeoTools简介_自己的九又四分之三站台的博客-CSDN博客_geotools.net](https://qlygmwcx.blog.csdn.net/article/details/109575751)

# 基本简介

GeoTools是一个开源的Java代码库，其提供一系列处理地理空间数据的标准兼容的方法，比如实现地理信息系统。GeoTools结构是基于开放空间协会（OGC）规范的。

- GeoTools被许多项目使用许多项目，这些项目包括web服务,命令行工具和桌面应用程序。
- GeoTools.NET(http:// geotoolsnet.sourceforge.net/Index.html)则是与Java对应的.NET版本。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201109132302361.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2ExMzQwNzE0MjMxNw==,size_16,color_FFFFFF,t_70#pic_center)

| 包             | 包说明                        |
| -------------- | ----------------------------- |
| gt-render      | 实现了Java2D的渲染引擎画地图  |
| gt-jdbc        | 实现了访问空间数据库的        |
| gt-data        | 实现对空间数据的访问          |
| gt-xml         | 实现对共同的xml数据格式的支持 |
| gt-cql         | 实现简单语句的查询            |
| gt-main        | 针对要素、过滤器等            |
| gt-api         | 定义了处理空间信息的接口      |
| jts            | 定义和处理几何图形            |
| gt-coverage    | 实现了Raster数据格式的访问    |
| gt-referencing | 实现了坐标的定义、转换        |
| gt-metadata    | 元数据的描述和识别            |
| gt-opengis     | 定义了空间概念的接口          |

Geotools项目已有十多年历史，生命力旺盛，代码非常丰富，包含多个开GIS项目，并且基于标准 的GIS接口。Geotools主要提供各种GIS算法，现各种数据格式的读写和显示。在显示方面要差一些，只是用Swing实现地图的简单查看和操作。 但是用户可以根据Geotools提供的算法自己实地图的可视化。OpenJump和udig就是基于Geotools的。

Geotools用到的两个较重要的开源GIS工具包是JTS和GeoAPI。前者主是实现各种GIS拓扑算法，也是基于GeoAPI的。但是由 于两个工具包GeoAPI分别采用不同的Java代码实现，所以在使用时需要相互转化Geotools又根据两者定义了部分自己的GeoAPI，所以 代码显得臃肿，时容易混淆。由于GeoAPI进展缓慢，Geotools自己对其进行了扩充。外，Geotools现在还只是基于2D图形的，缺乏对 3D空间数据算法和显的支持。

# 1. 主要特性

1. Geotools主要提供各种GIS算法，实现各种数据格式的读写和显示。
2. 在显示方面要差一些，只是用Swing实现了地图的简单查看和操作。
3. 用户可以根据Geotools提供的算法自己实现地图的可视化。OpenJump和udig就是基于Geotools的。
4. 目前的大部分开源软件，如udig，geoserver等，对空间数据的处理都是由geotools来做支撑。
5. web服务，命令行工具和桌面程序都可以由geotools来实现。
6. 是构建在OGC标准之上的，是OGC思想的一种实现。而OGC是国际标准，所以geotools将来必定会成为开源空间数据处理的主要工具，
7. Geotools用到的两个较重要的开源GIS工具包是JTS和GeoAPI。前者主要是实现各种GIS拓扑算法[只是图形与图形的九交模型并不是图层或图层间的拓扑算法]，也是基于GeoAPI的。
8. Geotools现在还只是基于2D图形的，缺乏对 3D空间数据算法和显示的支持。

# 2. Geotools支持的数据格式

1. `arcsde`, `arcgrid`, `geotiff`, `grassraster`, `gtopo30`, `image`(`JPEG`, `TIFF`, `GIF`, `PNG`), `imageio-ext-gdal`, `imagemoasaic`, `imagepyramid`, `JP2K`,`matlab`；
2. 支持的数据库“jdbc-ng”：`db2`, `h2`, `mysql`, `oracle`, `postgis`, `spatialite`, `sqlserver`；
3. 支持的矢量格式和数据访问：`app-schema`, `arcsde`, `csv`, `dxf`, `edigeo`, `excel`, `geojson`,`org`, `property`, `shapefile`, `wfs`；
4. `XML`绑定。基于xml的Java数据结构和绑定提供了如下格式`xsd-core` (xml simple types), `fes`,`filter`, `gml2`, `gml3`, `kml`, `ows`, `sld`, `wcs`, `wfs`, `wms`, `wps`, `vpf`。对于额外的`geometry`、`sld`和`filter`的编码和解析可以通过`dom`和`sax`程序。

# 3. 支持大部分的OGC标准

1. OGC中的sld/SE和渲染引擎；
2. OGC一般要素模型包括简单要素支持；
3. OGC中栅格信息的网格影像表达；
4. OGC中WFS，WMS和额外的WPS；
5. ISO 19107 geometry规范；

# 4. Geotools依赖的开源项目

1. JTS：JTS是加拿大的 Vivid Solutions 做的一套开放源码的 Java API。它提供了一套空间数据操作的核心算法,为在兼容OGC标准的空间对象模型中进行基础的几何操作提供2D空间谓词API。
2. GeoAPI：GeoAPI为OpenGIS规范提供一组Java接口。

# 5. GeoTools类库

GeoTools发布的包和其依赖的一些第三方类库总共约有168个，了解GeoTools依赖哪些包和依赖的这些包做什么的，对了解GeoTools这个大家伙一定是有帮助的，具体大家可以下载代码查看，上网搜索一般都能找到一些有用的资料。以下是核心类库的79个jar包：

# 6. 学习地址

1. GeoTools官方网站地址

https://docs.geotools.org/latest/userguide/geotools.html

1. GeoTools GitHub地址

https://github.com/geotools/geotools

# 7. GeoTools的方向

GeoTools GitHub地址

https://github.com/geotools/geotools

# 7. GeoTools的方向

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201109132317844.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2ExMzQwNzE0MjMxNw==,size_16,color_FFFFFF,t_70#pic_center)