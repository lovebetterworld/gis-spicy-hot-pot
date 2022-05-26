本文用Buffer(s)缓冲区分析来找出捷运沿线1km的范围

​    

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image272.jpg)

图：台北捷运沿线一公里内范围图

以「捷运站」图层为例

1. [输入矢量图层]：选择[捷运站.shp ]以及[台北市.shp ]
2. [缓冲区距离]为指定距离，范例指出1公里（1000公尺）
3. [融合缓冲区结果]：把每个点所产生的buffer 连在一起。
4. [输出shape檔]：产生的Buffer shapefile输出位置与文件名。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image273.jpg)

图：缓冲区设定

特别注意: 在设定Buffer distance 请确认 [设定/项目属性/地图单位]是否已经做好设定。本范例的服务的坐标系统为TWD67，在[地图单位]需勾选[公尺]。