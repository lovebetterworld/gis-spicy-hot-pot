- [QGIS生成样式文件在geoservr中发布_gis_SSS的博客-CSDN博客](https://blog.csdn.net/gis_zzu/article/details/99827530#:~:text=（1）QGIS将数据打开,（2）双击图层弹窗样式编辑框进行样式编辑 （3）将编辑好的样式保存起来)

## 一、概述

在geoserver中发布的数据，如果不加自定义样式，geoserver发布的数据会采用默认的样式，这种样式往往是无法满足实际地图展示的需求，如何利用[QGIS](https://so.csdn.net/so/search?q=QGIS&spm=1001.2101.3001.7020)编辑好样式使用geoserver发布出来呢？接下来为大家介绍使用QGIS如何制作地图数据样式的设置、数据分级加载、显示标注以及标注的分级加载

## 二、样式的制作

1、样式设置，常常指没一种数据显示的颜色不一样。

（1）QGIS将数据打开

![img](https://img-blog.csdnimg.cn/20190820114142423.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2dpc196enU=,size_16,color_FFFFFF,t_70)

（2）双击图层弹窗样式编辑框进行样式编辑

![img](https://img-blog.csdnimg.cn/20190820114240632.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2dpc196enU=,size_16,color_FFFFFF,t_70)

（3）将编辑好的样式保存起来

![img](https://img-blog.csdnimg.cn/2019082011461383.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2dpc196enU=,size_16,color_FFFFFF,t_70)

2、实现数据的分级加载

（1）打开数据，并显示出样式编辑框 

![img](https://img-blog.csdnimg.cn/20190820114822900.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2dpc196enU=,size_16,color_FFFFFF,t_70)

（2）可以先编辑好样式，然后选择渲染框，进行分级显示数据，编辑好编辑保存好sld样式文件

![img](https://img-blog.csdnimg.cn/20190820115116105.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2dpc196enU=,size_16,color_FFFFFF,t_70) 

3、显示标注信息

（1）打开数据显示，显示样式编辑框（如2的第一图）

（2）选择标签，然后选择单字段显示，接下来选择显示标注的字段，最后保存成sld样式文件

![img](https://img-blog.csdnimg.cn/2019082012225961.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2dpc196enU=,size_16,color_FFFFFF,t_70)

4、标注的分级显示，

（1） 在3的基础上进行标注的分级显示

（2）标注----->单字段----->标注显示字段----->标注渲染-------->设置比例尺------->保存成sld样式文件

![img](https://img-blog.csdnimg.cn/20190820123034853.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2dpc196enU=,size_16,color_FFFFFF,t_70)