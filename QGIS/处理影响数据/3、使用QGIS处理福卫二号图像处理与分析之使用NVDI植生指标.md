侦测植生常使用的另一个方法为使用植生指标(Normalised Difference Vegetation Index, NDVI)，其原理是利用植物会大量吸收红色波段及大量反射近红外波段的特性进行影像运算来找出植生所在位置，其公式如下：

​    

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image268.jpg)

使用QGIS软件中的「影像运算」功能来实做NDVI数值，进行实际操作如下所示：

## 1.影像运算

点击影像，选择影像运算。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image269.jpg)

## 2.输入计算公式

如图输入计算式

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image270.jpg)

  

## 3.得到计算结果

计算结果如下图，植生处会有很高的NDVI植(灰阶值较高呈白色)。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image271.jpg)

