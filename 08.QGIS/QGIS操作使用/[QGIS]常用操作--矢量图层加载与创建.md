- [[QGIS\]常用操作--矢量图层加载与创建_young_always的博客-CSDN博客_qgis创建矢量图](https://blog.csdn.net/u012655611/article/details/118878645)

# 矢量图层加载

## 加载CSV文件

我在平时调试程序时,会使用[csv文件](https://baike.baidu.com/item/CSV/10739)将临时结果输出,然后加载到QGIS中查看.这里简单介绍下,怎么加载csv文件.

- 菜单栏点击"图层"->“添加图层”->“添加文本数据图层”
- 在弹出的"数据源管理器"中,选择csv文件,并指定横纵(有高程的可以指定Z)坐标字段(一般QGIS会自动识别这些字段,部分情况如识别错误,可以手动指定)和坐标参考线后,点击"添加",即可将数据加载,如下图
  ![add_csv_layer](https://img-blog.csdnimg.cn/20210718223617316.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTI2NTU2MTE=,size_16,color_FFFFFF,t_70#pic_center)
- 添加后的效果如下
  ![layer_added](https://img-blog.csdnimg.cn/20210718223711871.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTI2NTU2MTE=,size_16,color_FFFFFF,t_70#pic_center)

## 加载SHP文件

- 可以通过直接选中*.shp文件,然后移动鼠标拖入QGIS进行加载
- 也可以在上步的"数据源管理器"界面,选中"矢量",然后指定为文件类型和文件路径后,点击"添加"进行加载,如下图
  ![shp_layer](https://img-blog.csdnimg.cn/20210718224618519.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTI2NTU2MTE=,size_16,color_FFFFFF,t_70#pic_center)

## 重投影与格式互转

- 格式转换是经常遇到的作业,QGIS提供了基于GDAL的数据格式转换,如上步的shp格式数据可以转换为gpkg,geojson,sqlite等格式
- 平时工作中,重投影也是常见操作,如从经纬度的EPSG4326重投影为UTM的EPSG32650等,操作如下图
  *重投影时,通过指定输出文件类型,也可以实现文件格式转换*
  ![reprojection](https://img-blog.csdnimg.cn/20210718231038201.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTI2NTU2MTE=,size_16,color_FFFFFF,t_70#pic_center)

# 新建图层

- 此处简单介绍下,如何通过在QGIS中使用Python代码创建矢量图层,并保存到文件中,一般有以下步骤:
  1. 创建内存图层,此时需要设置图层的几何类型,如点->Point,线->LineString等
  2. 设置图层的字段列表
  3. 打开图层编辑,开始向图层添加数据
  4. 提交数据,关闭图层编辑
  5. 向磁盘写入本图层数据.
     *样例代码如下*

```python
import os
import sys
from qgis.gui import *
from qgis.core import *
import qgis.utils
from qgis.core import QgsProject

mapCanvas = iface.mapCanvas()
minx = 115.4121250000000032
miny = 39.4379350000000031
maxx = 117.5067739999999930
maxy = 41.0583829999999992
layername = "Rectangle"
print("create layer:%s..." % (layername))
lineVecLayer = QgsVectorLayer("LineString", layername, "memory")
lineProvider = lineVecLayer.dataProvider()
lineProvider.addAttributes( [ QgsField("seq", QVariant.Int),QgsField("name",  QVariant.String)] )
lineVecLayer.startEditing()
print("editing layer:%s..." % (layername))
points = [QgsPoint(minx, miny), QgsPoint(minx, maxy), QgsPoint(maxx, maxy), QgsPoint(maxx, miny), QgsPoint(minx, miny)]
# create feature
print("add feature to layer:%s..." % (layername))
line_feature = QgsFeature(lineVecLayer.fields())
line_feature.setGeometry(QgsGeometry().fromPolyline(points))
line_feature.setAttributes([1, "bj_bbox"])
lineVecLayer.addFeature(line_feature)
# Commit changes
lineVecLayer.commitChanges()
# write data to disk
LineFile = "D:\\01_WorkSpace\\05_Data\\blog\\qgis\\Rectangle.gpkg"
crs = QgsCoordinateReferenceSystem("EPSG:4326")
QgsVectorFileWriter.writeAsVectorFormat(lineVecLayer, LineFile, "utf-8", crs, "GPKG")
print("save layer:%s to disk ok!" % (layername))
local_uri = LineFile + "|layername=" + layername
qgsLayer = QgsVectorLayer(local_uri, layername, "ogr")
# add layer to the project
QgsProject.instance().addMapLayer(qgsLayer)
```