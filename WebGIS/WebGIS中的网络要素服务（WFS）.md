- [WebGIS中的网络要素服务（WFS）](https://blog.csdn.net/qq_35732147/article/details/100628498)



# 一、WFS简介

OGC的WMS和WMTS规范都是有关空间数据显示的标准，而WFS（Web Feature Service）则允许用户在分布式的环境下通过HTTP对空间数据进行增、删、改、查。

具体来说，WebGIS服务器除了能够返回一张张地图图像之外，还可以返回绘制该地图图像所使用的真实地理数据。用户利用这些传输到客户端的地理数据可以进行数据渲染可视化、空间分析等操作。而前后端的这种数据交互就是基于WFS规范的。

那么也就能很清楚的说明WMS与WFS之间的区别了。WMS是由服务器将地图图像发送给客户端，而WFS是服务器将矢量数据发送给客户端。也就是在使用WMS时地图由服务器绘制，在使用WFS时地图由客户端绘制。另外最最重要的，使用WFS可以对WebGIS服务器中的地理数据（存储在空间数据库中）直接进行增、删、改、查。



# 二、WFS的种类与操作

WFS服务一般支持如下功能：

- GetCapabilities    ——    获取WFS服务的元数据（介绍服务中的要素类和支持的操作）
- DescribeFeatureType    ——    获取WFS服务支持的要素类的定义（要素类的元数据，比如要素包含哪些字段）
- GetFeature    ——    获取要素数据
- GetGmlObject    ——    通过XLink获取GML对象
- Transaction    ——    创建、更新、删除要素数据的事务操作
- LockFeature    ——    在事务过程中锁定要素

实际中，WebGIS服务器针对这些功能并不是必须全部实现，而是实现全部或部分。

因此，根据依据这些功能的支持与否，可以将WFS分为3类：

- Basic WFS    ——    必须支持GetCapabilities、DescribeFeature Type、GetFeature功能
- XLink WFS    ——    必须在Basic WFS基础上加上GetGmlObject操作
- Transaction WFS    ——    也称为WFS-T，必须在Basic WFS基础上加上Transaction功能以及支持编辑数据，另外也可以加上GetGmlObject或LockFeature功能



# 三、GetCapabilities（获取元数据）

GetCapabilities的KVP格式请求需要以下参数：

![img](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9pbWFnZXMyMDE1LmNuYmxvZ3MuY29tL2Jsb2cvNjU2NzQ2LzIwMTYwNS82NTY3NDYtMjAxNjA1MTkxNTI3MDQ5MzUtMTY2Mjg5MTc1Ny5wbmc?x-oss-process=image/format,png)

示例：

获取本机安装的GeoServer中WFS服务的元数据：

http://localhost:8080/geoserver/wfs?SERVICE=WFS&VERSION=1.1.0&REQUEST=GetCapabilities

 GeoServer将会返回一个XML文件（由于内容太多，这里就不列出来了），里面包含了关于这个GeoServer服务器的WFS服务的所有元数据，比如，包含哪些要素类，支持哪些操作等等。

# 四、DescribeFeatureType（获取要素类的元数据）

DescribeFeatureType的KVP格式请求需要以下参数：

![img](https://img-blog.csdnimg.cn/20190920183401993.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

示例：

获取本机GeoServer中guangdong:gd_roads要素类的元数据：

http://localhost:8080/geoserver/wfs?SERVICE=WFS&VERSION=1.1.0&REQUEST=DescribeFeatureType&TYPENAME=guangdong:gd_roads



GeoServer返回一个XML文件：

```xml
<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:gml="http://www.opengis.net/gml" xmlns:guangdong="http://localhost:8084/geoserver/guangdong" elementFormDefault="qualified" targetNamespace="http://localhost:8084/geoserver/guangdong">
<xsd:import namespace="http://www.opengis.net/gml" schemaLocation="http://localhost:8080/geoserver/schemas/gml/3.1.1/base/gml.xsd"/>
<xsd:complexType name="gd_roadsType">
<xsd:complexContent>
<xsd:extension base="gml:AbstractFeatureType">
<xsd:sequence>
<xsd:element maxOccurs="1" minOccurs="0" name="the_geom" nillable="true" type="gml:MultiLineStringPropertyType"/>
<xsd:element maxOccurs="1" minOccurs="0" name="osm_id" nillable="true" type="xsd:string"/>
<xsd:element maxOccurs="1" minOccurs="0" name="code" nillable="true" type="xsd:int"/>
<xsd:element maxOccurs="1" minOccurs="0" name="fclass" nillable="true" type="xsd:string"/>
<xsd:element maxOccurs="1" minOccurs="0" name="ref" nillable="true" type="xsd:string"/>
<xsd:element maxOccurs="1" minOccurs="0" name="oneway" nillable="true" type="xsd:string"/>
<xsd:element maxOccurs="1" minOccurs="0" name="maxspeed" nillable="true" type="xsd:int"/>
<xsd:element maxOccurs="1" minOccurs="0" name="layer" nillable="true" type="xsd:double"/>
<xsd:element maxOccurs="1" minOccurs="0" name="bridge" nillable="true" type="xsd:string"/>
<xsd:element maxOccurs="1" minOccurs="0" name="tunnel" nillable="true" type="xsd:string"/>
<xsd:element maxOccurs="1" minOccurs="0" name="type" nillable="true" type="xsd:long"/>
</xsd:sequence>
</xsd:extension>
</xsd:complexContent>
</xsd:complexType>
<xsd:element name="gd_roads" substitutionGroup="gml:_Feature" type="guangdong:gd_roadsType"/>
</xsd:schema>
```
其中，name就是指gd_roads要素类所具有的字段，而type就是该字段数据的数据类型。

# 五、GetFeature（获取要素数据）

GetFeature的KVP格式请求需要以下参数：

![img](https://img-blog.csdnimg.cn/20190920190412460.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

示例：

①返回本机GeoServer中guangdong:gd_roads要素类的要素ID为gd_roads.1的要素，返回数据格式指定为json：

http://localhost:8080/geoserver/wfs?SERVICE=WFS&VERSION=1.1.0&REQUEST=GetFeature&TYPENAME=guangdong:gd_roads&OUTPUTFORMAT=application/json&FEATUREID=gd_roads.1

 ②返回本机GeoServer的guangdong:gd_roads要素类中的10个要素，返回数据格式指定为json：

http://localhost:8080/geoserver/wfs?SERVICE=WFS&VERSION=1.1.0&REQUEST=GetFeature&TYPENAME=guangdong:gd_roads&OUTPUTFORMAT=application/json&MAXFEATURES=10

# 六、Transaction（对要素数据增、删、改）

Transaction的KVP格式请求需要以下参数：

![img](https://img-blog.csdnimg.cn/20190921122155430.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

目前Transaction的KVP格式请求只支持Delete操作（Insert和Update必须通过XML格式请求）。

示例：

删除本机GeoServer的guangdong:gd_roads要素类中的ID为gd_roads.1的要素：

http://localhost:8080/geoserver/wfs?SERVICE=WFS&VERSION=1.1.0&REQUEST=Transaction&TYPENAME=guangdong:gd_roads&FEATUREID=gd_roads.1


