- [WFS地图服务_自己的九又四分之三站台的博客-CSDN博客_wfs地图服务](https://qlygmwcx.blog.csdn.net/article/details/120091068)

# 1. WFS地图服务

OGC的WMS和WMTS规范都是有关空间数据显示的标准，而WFS（Web Feature Service）则允许用户在[分布式](https://so.csdn.net/so/search?q=分布式&spm=1001.2101.3001.7020)的环境下通过HTTP对空间数据进行增、删、改、查。

具体来说，WebGIS服务器除了能够返回一张张地图图像之外，还可以返回绘制该地图图像所使用的真实地理数据。用户利用这些传输到客户端的地理数据可以进行数据渲染[可视化](https://so.csdn.net/so/search?q=可视化&spm=1001.2101.3001.7020)、空间分析等操作。而前后端的这种数据交互就是基于WFS规范的。

那么也就能很清楚的说明WMS与WFS之间的区别了。WMS是由服务器将地图图像发送给客户端，而WFS是服务器将矢量数据发送给客户端。也就是在使用WMS时地图由服务器绘制，在使用WFS时地图由客户端绘制。另外最最重要的，使用WFS可以对WebGIS服务器中的地理数据（存储在空间数据库中）直接进行增、删、改、查。

# 2. WFS的种类与操作

WFS服务一般支持如下功能：

- GetCapabilities —— 获取WFS服务的元数据（介绍服务中的要素类和支持的操作）
- DescribeFeatureType —— 获取WFS服务支持的要素类的定义（要素类的元数据，比如要素包含哪些字段）
- GetFeature —— 获取要素数据
- GetGmlObject —— 通过XLink获取GML对象
- Transaction —— 创建、更新、删除要素数据的事务操作
- LockFeature —— 在事务过程中锁定要素

根据依据这些功能的支持与否，可以将WFS分为3类：

- Basic WFS —— 必须支持GetCapabilities、DescribeFeature Type、GetFeature功能
- XLink WFS —— 必须在Basic WFS基础上加上GetGmlObject操作
- Transaction WFS —— 也称为WFS-T，必须在Basic WFS基础上加上Transaction功能以及支持编辑数据，另外也可以加上GetGmlObject或LockFeature功能

# 3. 调用示例汇总

## 3.1. ArcGIS Server

### 3.1.1. GetCapabilities

此请求将通过服务以 GML 格式返回所有可用的要素类型与功能。要使用 GetCapabilities 操作，请复制 WFS 服务 URL 并将其粘贴到地址栏中，然后在 URL 末尾添加 ?request=getcapabilities。

```html
http://192.9.100.194:6080/arcgis/rest/services/ArcGISService_wfs/MapServer?SERVICE=WFS&VERSION=1.1.0&REQUEST=GetCapabilities
```

### 3.1.2. MapServer获取基本信息

```html
http://192.9.100.194:6080/arcgis/rest/services/ArcGISService_wfs/MapServer/0

http://192.9.100.194:6080/arcgis/rest/services/ArcGISService_wfs/MapServer/0?f=pjson
```

### 3.1.3. DescribeFeatureType

该请求描述了有关 WFS 服务中一个或多个要素的字段信息。这包括字段名称、字段类型、允许的最小与最大字段值以及在要素类或者表的字段上所设置的任何其他限制。

```html
http://192.9.100.194:6080/arcgis/services/ArcGISService_wfs/MapServer/WFSServer?SERVICE=WFS&VERSION=2.0.0&REQUEST=DescribeFeatureType
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/1d2ba4957a974de3a595a32b4188dbba.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5oS_5L2g6LWw5Ye65Y2K55Sf,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)

- 添加过滤器

通过将下列带有要素类型名称或表名称的请求添加到 URL 的末尾，您也可以指定您需要其字段信息的单个要素类或表：?SERVICE=WFS&REQUEST=DescribeFeatureType&TypeName=&VERSION=2.0.0。

了解有关 WFS 服务可用的不同过滤器的详细信息，请参阅在 Web 浏览器中与 WFS 服务进行通信。

在下例中，DescribeFeatureType 请求用于识别名为 XZQ 的要素类型的字段信息。

```html
http://192.9.100.194:6080/arcgis/services/ArcGISService_wfs/MapServer/WFSServer?SERVICE=WFS&VERSION=2.0.0&REQUEST=DescribeFeatureType&TYPENAME=XZQ
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/138da5a6774c40b8903c091e46e756d4.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5oS_5L2g6LWw5Ye65Y2K55Sf,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)

### 3.1.4. GetFeature

该请求通过 WFS 服务返回有关可用的指定要素类型的信息。

要在 Web 浏览器中使用 GetFeature 操作，请复制 WFS URL 并将其粘贴到地址栏中，然后在 URL 末尾添加?request=getFeature&typename=<在此输入要素类型>。这将返回有关此要素类型中各个要素和行的所有属性和几何信息。

```html
http://192.9.100.194:6080/arcgis/services/ArcGISService_wfs/MapServer/WFSServer?service=WFS&request=GetFeature&version=1.1.0&typename=XZQ

http://192.9.100.194:6080/arcgis/services/ArcGISService_wfs/MapServer/WFSServer?service=WFS&request=GetFeature&version=1.1.0&typename=XZQ&srsname=EPSG:4529&BBOX=41409557.961,4105360.884
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/827535cc0c624eafa3d858249502eaa8.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5oS_5L2g6LWw5Ye65Y2K55Sf,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)

## 3.2. GeoServer

可参考 https://docs.geoserver.org/latest/en/user/services/wfs/index.html

如何使用GeoServer发布WFS服务请参考：

https://zhuanlan.zhihu.com/p/150262867
https://www.osgeo.cn/tutorial/kc490

### 3.2.1. GetCapabilities 获取元数据

![在这里插入图片描述](https://img-blog.csdnimg.cn/c87cd2441f304e16bc4f5860b476a620.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5oS_5L2g6LWw5Ye65Y2K55Sf,size_19,color_FFFFFF,t_70,g_se,x_16#pic_center)

示例：

```html
-- 获取本机安装的GeoServer中WFS服务的元数据：

http://192.9.100.194:8086/geoserver/cite/wfs?SERVICE=WFS&VERSION=1.1.0&REQUEST=GetCapabilities
```

### 3.2.2. DescribeFeatureType 获取要素类的元数据

示例：

```html
-- 获取本机GeoServer中guangdong:gd_roads要素类的元数据：

http://192.9.100.194:8086/geoserver/cite/wfs?SERVICE=WFS&VERSION=1.1.0&REQUEST=DescribeFeatureType

http://192.9.100.194:8086/geoserver/cite/wfs?SERVICE=WFS&VERSION=1.1.0&REQUEST=DescribeFeatureType&TYPENAME=DLTB
```

### 3.2.3. GetFeature 获取要素数据

示例：

```html
-- cite:DLTB要素类的要素ID为DLTB.1的要素，返回数据格式指定为json：

http://192.9.100.194:8086/geoserver/cite/wfs?SERVICE=WFS&VERSION=1.1.0&REQUEST=GetFeature&TYPENAME=DLTB&OUTPUTFORMAT=application/json&FEATUREID=DLTB.1

-- 返回本机GeoServer的cite:DLTB要素类中的10个要素，返回数据格式指定为json：

http://192.9.100.194:8086/geoserver/cite/wfs?SERVICE=WFS&VERSION=1.1.0&REQUEST=GetFeature&TYPENAME=DLTB&OUTPUTFORMAT=application/json&MAXFEATURES=10

-- 返回本机GeoServer的cite:DLTB要素类中的要素，返回数据格式指定为json：如果不指定MAXFEATURES则为最大
http://192.9.100.194:8086/geoserver/cite/wfs?SERVICE=WFS&VERSION=1.1.0&REQUEST=GetFeature&TYPENAME=DLTB&OUTPUTFORMAT=application/json
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/367166d976ed498eb7d099073661a278.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5oS_5L2g6LWw5Ye65Y2K55Sf,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)

- 属性查询

在请求中，可通过cql_filter参数输入过滤条件，对图层进行查询，查询的格式可移步 http://docs.geoserver.org/latest/en/user/tutorials/cql/cql_tutorial.html#cql-tutorial 看看相关具体的说明，在此我简单的举两个例子来说明。

```bash
http://192.9.100.194:8086/geoserver/cite/wfs?SERVICE=WFS&VERSION=1.1.0&REQUEST=GetFeature&TYPENAME=DLTB&OUTPUTFORMAT=application/json&cql_filter=DLBM='0307'

http://192.9.100.194:8086/geoserver/cite/wfs?SERVICE=WFS&VERSION=1.1.0&REQUEST=GetFeature&TYPENAME=DLTB&OUTPUTFORMAT=application/json&cql_filter=DLBM='0307'
```

