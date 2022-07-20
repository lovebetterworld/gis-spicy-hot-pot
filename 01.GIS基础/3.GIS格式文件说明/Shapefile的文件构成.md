- [Shapefile的文件构成_万里归来少年心的博客-CSDN博客_shapefile文件组成部分有哪些](https://blog.csdn.net/liyazhen2011/article/details/89138919)

 shapefile 是一种 Esri 矢量数据存储格式，用于存储地理要素的位置、形状和属性。其存储为一组相关文件，并包含一个要素类。 

  一个shapfile包含三个必需的文件和一些可选的文件。

必需有的文件：

- .shp   地理要素的几何实体。
- .shx   地理要素几何实体的位置索引。
- .dbf   地理要素几何实体的属性。

可选文件包括：

- .prj  存储空间参考信息，即地理坐标系统和投影信息。
- .sbnand.sbx 几何体的空间索引。
- .fbnand.fbx 只读的Shapefiles的几何体的空间索引。
- .ainand.aih 列表中活动字段的属性索引。
- .ixs  可读写Shapefile文件的地理编码索引。
- .mxs 可读写Shapefile文件的地理编码索引。
- .atx  .dbf文件的属性索引。
- .shp.xml  以XML格式保存元数据。
- .cpg 用于描述.dbf文件的代码页，指明其使用的字符编码。

  下例中的shapefile包含了三个必须的文件nyc_census_blocks.shp、nyc_census_blocks.shx和nyc_census_blocks.dbf，以及一个可选的nyc_census_blocks.prj。

### ![img](https://img-blog.csdnimg.cn/20190409110638527.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpeWF6aGVuMjAxMQ==,size_16,color_FFFFFF,t_70)

[
  ](https://edu.csdn.net/contest/detail/8?utm_campaign=marketingcard&utm_source=liyazhen2011&utm_content=89138919)