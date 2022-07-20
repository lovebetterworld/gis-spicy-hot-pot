- [OSM地图本地发布(四)-----Geoserver发布自定义地图_DXnima的博客-CSDN博客](https://blog.csdn.net/qq_40953393/article/details/120608112)

# 一、准备工作

1. 安装jdk 1.8、tomcat

2.安装Geoserver，下载地址：https://sourceforge.net/projects/geoserver/files/GeoServer/2.19.2/

3.自定义图层准备，[OSM本地发布(三)-----自定义图层提取](https://blog.csdn.net/qq_40953393/article/details/120605543)

4.下载osmsld.zip样式文件，链接: https://pan.baidu.com/s/1qbVC5Jbsa42rbP-p_i5XxQ 提取码: w2pf

# 二、安装步骤

## 1.安装jdk、tomcat

​     安装教程网上很多，可以找一个照着安装，推荐：[Jdk安装教程](https://blog.csdn.net/Marvin_996_ICU/article/details/106240065)、[Tomcat安装教程](https://blog.csdn.net/wsjzzcbq/article/details/87953594)。

## 2.安装Geoserver

​     官网安装方式有两种：Tomcat运行war包方式、单独运行方式，我采用第一种方式war包。

![img](https://img-blog.csdnimg.cn/20211004210930365.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

1.下载war包，[geoserver-2.19.2-war.zip](https://sourceforge.net/projects/geoserver/files/GeoServer/2.19.2/)

2.解压将war包放在.../tomcat/webapps/ 目录下

![img](https://img-blog.csdnimg.cn/20211004211135197.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

 3.启动Tomcat，双击.../tomcat/bin/startup.bat启动。

![img](https://img-blog.csdnimg.cn/20211004211312854.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

 4.浏览器打开网址：http://localhost:8080/geoserver 查看是否打开成功，默认登录用户名：admin 、密码：geoserver

![img](https://img-blog.csdnimg.cn/2021100421153138.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

登录成功后点击“图层”查看有很多默认图层：

![img](https://img-blog.csdnimg.cn/20211004211735979.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

点击 “Layer Preview” ，再点击任意图层的“OpenLayers”预览图层：

![img](https://img-blog.csdnimg.cn/2021100421190056.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

![img](https://img-blog.csdnimg.cn/20211004211912576.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16) 到此Geoserver安装成功，接下来发布自定义图层

#  三、发布自定义图层

## 1.创建名为“taiwan”的工作区

![img](https://img-blog.csdnimg.cn/20211004212457533.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

 ![img](https://img-blog.csdnimg.cn/2021100421254167.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

## 2.创建数据存储

![img](https://img-blog.csdnimg.cn/20211004212611694.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

 选择PostGIS:

![img](https://img-blog.csdnimg.cn/20211004212633130.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

输入数据库名、用户名、密码连接数据库：

![img](https://img-blog.csdnimg.cn/20211004212828731.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

 连接成功后将看到需要发布的图层：

![img](https://img-blog.csdnimg.cn/20211004212910710.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

## 3.执行脚本生成图层

下载osmsld.zip，链接: https://pan.baidu.com/s/1qbVC5Jbsa42rbP-p_i5XxQ 提取码: w2pf

解压osmsld.zip文件。

1.打开osmsld/sld/SLD_create.sh，修改工作空间名称和数据存储名称，如果按上方设置不需修改。

![img](https://img-blog.csdnimg.cn/20211004214400758.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

 2.执行osmsld/sld/SLD_create.sh生成图层

![img](https://img-blog.csdnimg.cn/20211004214504178.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

 3.执行完成，打开Geoserver搜索taiwan查看图层

![img](https://img-blog.csdnimg.cn/20211004214628452.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

 4.随便打开一个图层预览一下

![img](https://img-blog.csdnimg.cn/20211004214721731.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

![img](https://img-blog.csdnimg.cn/20211004214757274.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

##  4.生成图层组

1.打开osmsld/layergroup.[xml](https://so.csdn.net/so/search?q=xml&spm=1001.2101.3001.7020)修改工作空间名称，若按上述设置不用修改。

![img](https://img-blog.csdnimg.cn/20211004215018140.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_18,color_FFFFFF,t_70,g_se,x_16)

 2.执行osmsld/create_layergroup.sh生成图层组，geoserver查看图层组是否生成成功。

![img](https://img-blog.csdnimg.cn/20211004220735563.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

 3.预览图层组

![img](https://img-blog.csdnimg.cn/20211004220820634.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

![img](https://img-blog.csdnimg.cn/20211004220916219.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16) 到此自定义地图发布基本完成，不过地图开始没有边界轮廓和海洋，下一节将完成海洋发布！ 