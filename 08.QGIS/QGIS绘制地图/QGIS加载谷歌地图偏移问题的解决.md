- [QGIS加载谷歌地图偏移问题的解决_慢-慢的博客-CSDN博客_qgis地图偏移](https://blog.csdn.net/u011147706/article/details/111597640)

# 1、偏移问题现象描述

批量导入WGS坐标点后发现和底图存在偏移情况

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201223195358937.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTExNDc3MDY=,size_16,color_FFFFFF,t_70)

# 2、偏移矫正过程

下载安装geohey插件，将WGS坐标转换成火星坐标（GCJ02,高德、谷歌地图都是用的这个坐标），然后再显示就正确了。
插件下载：

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201223200155218.png)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20201223200305938.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTExNDc3MDY=,size_16,color_FFFFFF,t_70)

插件安装成功后，调出处理工具箱，

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201223200721849.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTExNDc3MDY=,size_16,color_FFFFFF,t_70)

在【工具箱】找到【GeoHey】

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201223200841653.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTExNDc3MDY=,size_16,color_FFFFFF,t_70)

双击【WGS to GCJ02】选中需要转换坐标的图层

![在这里插入图片描述](https://img-blog.csdnimg.cn/2020122320110948.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTExNDc3MDY=,size_16,color_FFFFFF,t_70)

转换后坐标基本与地图重合

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201223201337959.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTExNDc3MDY=,size_16,color_FFFFFF,t_70)