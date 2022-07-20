- [OSM地图本地发布(五)-----Geoserver发布海洋图层_DXnima的博客-CSDN博客](https://blog.csdn.net/qq_40953393/article/details/120609056)

# 一、准备工作

1.下载OSM海洋数据，下载地址：[Water polygons](https://osmdata.openstreetmap.de/data/water-polygons.html)，OSM地图默认坐标系是**EPSG:3857**,即为墨卡托投影（[Mercator](https://osmdata.openstreetmap.de/info/projections.html#)）数据是shp格式，下方有两种海洋数据，Large polygons are [split](https://so.csdn.net/so/search?q=split&spm=1001.2101.3001.7020)是很详细的海洋数据，文件大小>700MB；Simplified polygons, use for zoom level 0-9是比较简单的海洋数据，一般在地图0-9级使用，文件大小20MB左右。这里选用数据量小的做测试，具体地图服务项目使用详细的海洋数据。

![img](https://img-blog.csdnimg.cn/20211004222020661.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

 2.安装Geoserver发布自定义地图，[OSM本地发布(四)-----Geoserver发布自定义地图](https://blog.csdn.net/qq_40953393/article/details/120608112)

3.shp2pgsql工具，将shp数据导入postgres数据库，windows安装PostGIS后自带该工具，Linux需单独安装

![img](https://img-blog.csdnimg.cn/20211004223321816.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_12,color_FFFFFF,t_70,g_se,x_16)

#  二、导入海洋数据

1.将下载的海洋数据解压，QGIS查看海洋数据。

![img](https://img-blog.csdnimg.cn/20211004224649451.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

2.打开shp2pgsql

![img](https://img-blog.csdnimg.cn/20211004224856985.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_12,color_FFFFFF,t_70,g_se,x_16)

![img](https://img-blog.csdnimg.cn/20211004224902523.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_17,color_FFFFFF,t_70,g_se,x_16)

 3.连接Postgres数据库

![img](https://img-blog.csdnimg.cn/20211004224944903.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_17,color_FFFFFF,t_70,g_se,x_16)

![img](https://img-blog.csdnimg.cn/20211004225007746.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_17,color_FFFFFF,t_70,g_se,x_16)

![img](https://img-blog.csdnimg.cn/20211004225043492.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_17,color_FFFFFF,t_70,g_se,x_16)

 出现succeeded,说明连接成功。

4.点击“Add File”选择shp文件导入数据库，SRID设置为3857，点击Import导入 

![img](https://img-blog.csdnimg.cn/20211004225314372.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

![img](https://img-blog.csdnimg.cn/20211004225329719.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

 出现completed，说明导入成功。

#  三、Geoserver发布海洋图层

 1.添加图层

![img](https://img-blog.csdnimg.cn/20211004225445668.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

2.选择taiwan:taiwan图层，找到simplified_water_polygons发布

![img](https://img-blog.csdnimg.cn/20211004225548325.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16) 3.数据标签页设置边框

![img](https://img-blog.csdnimg.cn/20211004225800753.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)





![img](https://img-blog.csdnimg.cn/20211004225722336.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

4.发布标签页设置样式并发布

![img](https://img-blog.csdnimg.cn/20211004225840465.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

![img](https://img-blog.csdnimg.cn/20211004225903826.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_17,color_FFFFFF,t_70,g_se,x_16)

 5.预览海洋图层

![img](https://img-blog.csdnimg.cn/20211004225952763.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

![img](https://img-blog.csdnimg.cn/20211004230035543.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

# 四、图层组添加海洋

1.打开taiwan图层组

![img](https://img-blog.csdnimg.cn/2021100423021153.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

 2.添加simplified_water_polygons图层

![img](https://img-blog.csdnimg.cn/20211004230257318.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

 3.拖动taiwan:simplified_water_polygons图层到最上层

![img](https://img-blog.csdnimg.cn/20211004230402487.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

 4.生成边界，最后保存

![img](https://img-blog.csdnimg.cn/20211004230436835.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

5.预览图层组

![img](https://img-blog.csdnimg.cn/20211004230526148.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16) ![img](https://img-blog.csdnimg.cn/20211004230600269.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

![img](https://img-blog.csdnimg.cn/20211004230617640.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

![img](https://img-blog.csdnimg.cn/20211004230643629.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

到此OSM自定义地图本地发布完成，海洋有了，省份轮廓也有了！

后面将介绍Geoserver如何使用OSM官网样式[发布OSM官网地图](https://blog.csdn.net/qq_40953393/article/details/120611304)，[如何生成maputnik的精灵图](https://blog.csdn.net/qq_40953393/article/details/120882645)。