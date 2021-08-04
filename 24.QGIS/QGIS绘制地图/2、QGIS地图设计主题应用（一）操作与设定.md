QGIS 2.2  版地图出版设计功能中新增[地图设计(Atlas)]功能。地图（又称舆地图）为绘有疆域范围之地图，在历史上，各朝代先后绘制有多版舆地图。这个功能类似 ArcGIS 软件中的「data driven pages」功能，也就是可以一次输出整批的地图影像，方便编制地图集。

​    

## 1.资料准备

打开﹝分幅图框﹞文件夹内的分幅图框图层index WGS84.shp，以及制作地图所需之影像底图。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image156.jpg)

分幅图框图层属性表中预先准备地图所需之图名、图号等信息。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image157.jpg)

## 2.地图出版设计

点击上方工具栏→「地图出版设计」→ 输入「设计标题」(可不填)→点击「确定」。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image158.jpg)

  

## 3.添加地图

点击→ ![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image159.jpg)「添加新地图」，按住滑鼠左键拖曳出图范围，并预留空白处标记图名。

![img](https://image.malagis.com/pic/gis/2017-07-29_19_46_27_1501328787.20735.jpg)

## 4.设定地图属性

「地图设计」→选择「产生地图」。指定「Coverage layer」为预先准备好的分幅图框图层。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image161.jpg)

设定属性。「Item Properties」→选择「 Contralled by atlas 」。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image162.jpg)

设定属性。图元周围的边距设定，百分比数值越大，表示图框距离地图边界越远，可依据需求自行调整。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image163.jpg)

  

## 5.添加图名

点击![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image164.jpg)「添加新标记」后，框选欲放置位置。「QGIS」图名为默认文字，可在主要属性中手动修改，或依据域值自动产生图名。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image165.jpg)

## 6.自动产生图名

先将默认文字删除→点击「插入表示式」。在「字段与值」中选择参照的图名字段，点击两下后自动插入表示式框内→「确定」。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image166.jpg)

## 7.编辑图名样式

地图图名会自动插入参数名称。若需更改字体样式，可点击「字体」或「字体颜色」，自行指定。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image167.jpg)

## 8.预览图集

完成后，可利用功能选单上![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image168.jpg)「Preview Atlas」 启动预览图框。此时图名会由参数转换为实际域值。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image169.jpg)

## 9.预览地图

可点击箭头键逐张预览地图。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image170.jpg)

## 