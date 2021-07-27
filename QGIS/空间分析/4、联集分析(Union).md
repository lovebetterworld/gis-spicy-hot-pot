两图层中，在空间重复的范围进行切割，所得的图元仅有切割范围内的。两图层联集的结果，且重复区域彼此互相切割，并带有各自的属性。

​    

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image285.jpg)

图：联集分析

练习：Union台北县市图层 & buffer1000m。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image286.jpg)

图：台北县市图层 & buffer1000m

步骤如下：

1. [输入矢量图层] ：[台北县市.shp]。
2. [联集图层 ]：[Buffer zone 1 km.shp]。
3. [输出 shapefile]：输出图层。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image287.jpg)

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image288.jpg)

图：选择联集功能

完成分析，结果如图：

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image289.jpg)

