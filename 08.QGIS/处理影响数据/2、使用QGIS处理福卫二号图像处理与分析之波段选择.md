福尔摩沙卫星二号（以下简称福卫二号）是由国科会财团法人国家实验研究院国家太空中心主导的计划，为台湾第一个自主性遥测与科学卫星。福卫二号于  2004 年 5 月发射，主要任务在于资源探测与科学研究，每日可对同一地区进行拍摄之高造访率是其特点。 福卫二号之遥测酬载仪器规格如下表所示：

​    

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image259.jpg)

其多光谱态(MS)有四个波段，分别为蓝光段(B)、绿光段(G)、红光段(R)及近红外光段(IR)，在地理信息系统(GIS)的应用上，可依需求进行不同样式的套色，如下图，将显示的红波段套上福卫红波段，蓝波段套上蓝波段，绿波段套绿波段，则可得接近肉眼看到的自然色(即树木为绿色，水为蓝色等)。

## 1.载入影像图层

使用「添加影像图层」功能，将多光谱的福卫影像图层﹝FS2_144102000_02_0001_MS.tiff﹞加载QGIS中，点击右键选择属性。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image260.jpg)

图：添加图层后选择属性

## 2.设计样式

在「样式」设计中，将想套色的波段分别选定后，即可得自然色影像。由于此幅测试影像包含较多光谱值高的云层(可选择「分布图」观看)，会使整体颜色对比减弱，在「输入最小 / 最大值」处自行调整，在此取 33%~98%以避开云层造成的影响。此功能称作「影像增显」。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image261.jpg)

图：选择样式并选择波段

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image264.jpg)

图：波段分布图

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image265.jpg)

图：影像增显成果图

  

## 3.使用特定波段

自然套色符合人眼所见，所以看起来会最「顺眼」，但若要进行科学分析时，人眼有时会骗人，例如，眼睛看到的为绿色的东西，就一定是植物吗？在多光谱的影像中，一般进行植生分析时会使用其近红外波段，其波段范围在 0.76～0.90μm，植物对此波段会产生极大的反射，以下将显示的红波段套上影像的近红外波段：

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image266.jpg)

图：红波段叠加影像的近红外波段

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image267.jpg)

图：叠加影像的近红外波段成果