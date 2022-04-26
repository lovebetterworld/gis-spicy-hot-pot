影像校正(GeoReference)指的是将无坐目标影像透过参考图层建立控制点，将其赋予坐标。有许多影像拥有很多有用的信息，但却没有坐标信息，若能赋予这些影像坐标，将可大幅提升其使用效用。

​    

在GIS系统中可能必须整合来自不同来源的许多数据，而这些数据的精确度可能差异很大，当我们要整合这些数据进行分析时，这些数据之间必须先进行校正，而作为校正依据的坐标系统必须相当的精确，我们称之为控制数据，一般基本控制数据都是使用二等或三等测量三角点。

国内（台湾）各单位使用各项服务地理坐标标准不一(如地籍图，都计图、航照图…)，必须经过已知测量控制点或全球卫星定位系统控制点坐标校正，才能将各幅图作正确完整的接合，所完成服务地理坐标符合政府统一使用的横麦卡脱投影二度分带坐标(2° TM)。

## 1.加载参考图层

使用OpenLayers plugin，加载适当图层(在此使用Google Street layer) 当做参考图层。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image249.jpg)

图：载入地图图层

## 2.打开(Georeferencer)工具

1. 打开「几何校正(Georeferencer)」工具，并载入观光地图之电子檔﹝taipeiMap.tiff﹞。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image250.jpg)

图：点击几何校正

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image251.jpg)

图：载入图像文件

  

## 3.增加参考点

点击[新增参考点]，在工作图层中先点击参考点，并选择[从QGIS地图中设定参考点]，即可在QGIS主窗口中的Google Street layer图层中点击相对应的点位。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image252.jpg)

图：添加控制点

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image253.jpg)

图：点击设定参考点

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image254.jpg)

图：标记参考点

## 4.设置影像转换参数

在此使用「一阶多项式」转换方法搭配「立方回旋法」重新取样。由于参考图层为Google Street layer，故设定转出影像坐标系统为  WGS84/Pseudo Mercator (EPSG:3857) 。影像转换参数设定完成，并拥有足够的参考点后，即可进行校正。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image255.jpg)

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image257.jpg)

图：开始几何校正

  

## 5.完成校正

校正完的影像即为带有坐目标数字化图档，可与其他图层套合。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image258.jpg)

## 