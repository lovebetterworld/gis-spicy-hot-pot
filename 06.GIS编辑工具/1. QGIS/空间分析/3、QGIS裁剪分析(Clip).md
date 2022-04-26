两图层中，在空间重复的范围进行切割，所得的图元仅有切割范围内的。

​    

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image279.jpg)

图：裁剪分析图

1.练习: 找出台北市内有哪些捷运站。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image280.jpg)

图：台北市捷运站分布

欲求出台北市内有哪些捷运站，需要下面的步骤

1. [输入矢量图层]：[捷运站.shp] 。
2. [裁切形状图层]：[台北市.shp]。
3. [输出 shape檔]：输出位置与文件名

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image281.jpg)

蓝色点为Clip后的捷运站

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image283.jpg)

## QGIS比较 Intersect 与 Clip layer 结果

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image284.jpg)

## 