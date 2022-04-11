- [WMS地图服务_自己的九又四分之三站台的博客-CSDN博客_wms地图服务](https://qlygmwcx.blog.csdn.net/article/details/120011022)

# 1. WMS 简介

WMS服务：Web Map Service，网络地图服务，它是利用具有地理空间位置信息的数据制作地图，其中将地图定义为地理数据的[可视化](https://so.csdn.net/so/search?q=可视化&spm=1001.2101.3001.7020)表现，能够根据用户的请求，返回相应的地图，包括PNG、GIF、JPEG等栅格形式，或者SVG或者WEB CGM等矢量形式。WMS支持HTTP协议，所支持的操作是由URL决定的。

# 2. WMS提供如下操作

- `GetCapabitities`：返回服务级元数据，它是对服务信息内容和要求参数的一种描述。
- `GetMap`：返回一个地图影像，其地理空间参考和大小参数是明确定义了的。
- `GetFeatureInfo`：返回显示在地图上的某些特殊要素的信息。
- `GetLegendGraphic`：返回地图的图例信息。

在前面介绍过关于WMS是OpenLayers加载WMS服务：
https://blog.csdn.net/a13407142317/article/details/119896892?spm=1001.2014.3001.5501

## 2.1. ArcGIS调用

关于ArcGIS的调用，具体概念我就不做Copy了，大家可以参考ArcGIS官方文档：
https://enterprise.arcgis.com/zh-cn/server/latest/publish-services/windows/wms-services.htm

我这边就是基于这个发送几个请求：

### 2.1.1 GetCapabitities

http://192.9.10.250:6080/arcgis/rest/services/行政区地类图斑/MapServer?SERVICE=WMS&request=Getcapabilities
![在这里插入图片描述](https://img-blog.csdnimg.cn/741d9a1afacb408cad9c1f018401abc4.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5oS_5L2g6LWw5Ye65Y2K55Sf,size_18,color_FFFFFF,t_70,g_se,x_16#pic_center)

获取关于`行政区地类图斑`服务的基本信息，而在ArcGIS Server服务请求中所有的Layer都需要使用顺序号，而在顺序和上图中Layer后的顺序码(如：DLTB(0))`通过验证不对`

其基本信息为：

http://192.9.10.250:6080/arcgis/services/%E8%A1%8C%E6%94%BF%E5%8C%BA%E5%9C%B0%E7%B1%BB%E5%9B%BE%E6%96%91/MapServer/WMSServer?request=GetCapabilities&service=WMS
![在这里插入图片描述](https://img-blog.csdnimg.cn/214ca5f03b204fb2a8b02763b78555d7.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5oS_5L2g6LWw5Ye65Y2K55Sf,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)

### 2.1.2 获取服务中图层的基本信息

http://192.9.10.250:6080/arcgis/rest/services/行政区地类图斑/MapServer/0?f=pjson

emmm 上述的这个`0`还是使用的`Getcapabilities`的顺序码(DLTB(0))
![在这里插入图片描述](https://img-blog.csdnimg.cn/53821847a57f4495858a210f5159b992.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5oS_5L2g6LWw5Ye65Y2K55Sf,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)

### 2.1.3 Query

http://192.9.10.250:6080/arcgis/rest/services/行政区地类图斑/MapServer/0/query?where=GDLX is null or GDLX = ‘’ &outFields=*

![在这里插入图片描述](https://img-blog.csdnimg.cn/df5adcfe70ab41ddae9![在这里插入图片描述](https://img-blog.csdnimg.cn/669cee0653b544c4842699aba5c829ec.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5oS_5L2g6LWw5Ye65Y2K55Sf,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)
243d33f708915.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5oS_5L2g6LWw5Ye65Y2K55Sf,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)

通过上述的接口或者界面可以向ArcGIS Server发起请求

-指定返回方式为`Json`

http://192.9.10.250:6080/arcgis/rest/services/行政区地类图斑/MapServer/0/query?where=GDLX is null or GDLX = ‘’ &f=json&outFields=*

在ArcGIS中这个接口很强大，可以查询一切ArcEngine可以查询的内容，比如空间查询、范围查询等等。且返回的信息可以返回空间范围，即图斑的坐标信息

`不过在ArcGIS Server中可以通过权限控制禁用改权限`，将下图中的两个权限勾选取消则上述接口请求无效。

### 2.2.4 GetFeatureInfo

通过WMS的服务请求获取属性信息

http://192.9.10.250:6080/arcgis/services/ArcGISService_001/MapServer/WMSServer?request=GetFeatureInfo&service=WMS&version=1.1.1&styles=default&SRS=EPSG:4529&bbox=41398477.406700,4120788.817600,41447440.215300,4160585.149700&width=10&height=10&X=1&Y=1&INFO_FORMAT=text/xml&FEATURE_COUNT=50&query_layers=0

```html
http://192.9.10.250:6080/arcgis/services/ArcGISService_001/MapServer/WMSServer?
request=GetFeatureInfo&             //接口函数
service=WMS&                        //服务类型
version=1.1.1&                      //服务请求版本
styles=default&                     //返回样式
SRS=EPSG:4529&                      //返回的空间参考
bbox=41398477.406700,4120788.817600,41447440.215300,4160585.149700&     //返回数据的空间四至范围
width=10&height=10&                 //返回数据地图的长宽
X=1&Y=1&                            //返回要素的像素
INFO_FORMAT=text/xml&               //返回数据的返回格式
FEATURE_COUNT=50&                   //一次请求最多返回的数据个数
query_layers=0                      //请求的数据名称(对应GetCapabitities中警告[而在顺序和上图中Layer后的顺序码(如：DLTB(0))`通过验证不对`])
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/5317c89b399344428443bfee54ba2cd2.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5oS_5L2g6LWw5Ye65Y2K55Sf,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)

http://192.9.10.250:6080/arcgis/services/ArcGISService_001/MapServer/WMSServer?request=GetFeatureInfo&service=WMS&version=1.1.1&styles=default&SRS=EPSG:4529&bbox=41398477.406700,4120788.817600,41447440.215300,4160585.149700&width=1&height=1&X=1&Y=1&INFO_FORMAT=text/xml&FEATURE_COUNT=50&query_layers=0

![在这里插入图片描述](https://img-blog.csdnimg.cn/e3f9afbda8d442ae9e51db464cc1caf4.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5oS_5L2g6LWw5Ye65Y2K55Sf,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)

## 2.2. GeoServer调用

官方文档借鉴： https://docs.geoserver.org/stable/en/user/services/wms/index.html

一下两个接口类似与ArcGIS Server

### 2.2.1. GetCapabilities

http://192.9.10.250:8086/geoserver/cite/wms?service=wms&request=GetCapabilities

### 2.2.2. GetFeatureInfo

http://192.9.10.250:8086/geoserver/cite/wms?SERVICE=WMS&VERSION=1.1.1&REQUEST=GetFeatureInfo&FORMAT=image/png&TRANSPARENT=true&QUERY_LAYERS=DLTB&STYLES&LAYERS=DLTB&INFO_FORMAT=text/html&FEATURE_COUNT=50&X=50&Y=50&SRS=EPSG:4529&WIDTH=101&HEIGHT=101&BBOX=41398477.406700,4120788.817600,41447440.215300,4160585.149700

# 3. 个人解释一下GetFeatureInfo中几个参数空间上的含义

主要介绍的是以下4个参数

```sql
SRS=EPSG:4529&                      //返回的空间参考
bbox=41398477.406700,4120788.817600,41447440.215300,4160585.149700&     //返回数据的空间四至范围
width=10&height=10&                 //返回数据地图的长宽
X=1&Y=1&                            //返回要素的像素
```

## 3.1. 文字解读

- SRS 代表数据的空间参考信息，展示数据的空间投影方式
- bbox 上述的SRS指定后便为bbox的值上指定了单位和数据的投影方式等空间信息
- width和height 之时上述俩个参数`SRS`和`bbox`所指定的数据映射到怎样的一个`空间范围地图框`中
- X和Y 则表示在上述的`空间范围地图框`取哪一个网格中的数据。

## 3.2. 图片解读方式

![在这里插入图片描述](https://img-blog.csdnimg.cn/fbbaf55efe3646c6a2137f7affda9868.jpg?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5oS_5L2g6LWw5Ye65Y2K55Sf,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)

指定的数据映射到怎样的一个`空间范围地图框`中

- X和Y 则表示在上述的`空间范围地图框`取哪一个网格中的数据。