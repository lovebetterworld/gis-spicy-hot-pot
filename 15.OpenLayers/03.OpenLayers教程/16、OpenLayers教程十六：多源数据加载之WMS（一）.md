- [OpenLayers教程十六：多源数据加载之WMS（一）](https://blog.csdn.net/qq_35732147/article/details/96142436)



# 一、WMS规范简介

在WebGIS中，有多种方法在网页浏览器中显示地图：

- 瓦片地图     ——    事先将地图切割成瓦片，需要时再发送给客户端，瓦片可以存储在服务器或者本地
- 矢量地图    ——    将具有空间信息和属性信息的数据（比如GeoJSON、KML等）发送给浏览器，然后在浏览器渲染，数据可以存储在服务器或者本地
- 矢量切片    ——    一种瓦片地图和矢量地图的中庸之道，结合了两者优势的一种显示地图的方式，后面再介绍。
- 动态绘制地图服务    ——    在服务器端根据请求的内容绘制一个地图图像（在服务器端绘制），然后返回给客户端。

   本文就来介绍动态绘制地图相关的内容。

   因为每次都是根据用户请求参数，随时绘制地图，图像反映数据的最新情况，且在服务器端绘制地图，因此该方式通常称为动态绘制地图服务。而切片地图方式只反映了生成地图切片时的数据状况。

动态绘制地图服务的缺点是在多用户并发请求时，服务器容易超负荷运行，即用户越多，响应越慢。

OGC（开发地理空间联盟）的WMS（Web Map Service）服务规范就是一种动态绘制地图服务的规范，许多WebGIS服务器实现了WMS规范，因此可以结合一些WebGIS服务器发布WMS服务，然后使用OpenLayers调用WMS服务在客户端呈现地图。目前比较流行的WebGIS服务器有GeoServer、ArcGIS Server等。

到目前为止，已发布了4个版本的WMS规范。这些版本是v1.0.0、v1.1.0、v1.1.1和v1.3.0（最新版本）。WMS规范的地址为：http://www.opengeospatial.org/standards/wms 。

   WMS服务主要支持以下操作：

- 请求服务的元数据（GetCapabilities）
- 请求地图图像（GetMap）
- 请求关于地图要素的信息（GetFeatureInfo，可选）
- 请求图例（GetLegendGraphic，可选）
- 请求用户定义的样式（GetStyles，可选）

作为基本WMS服务，必须至少支持GetCapabilities和GetMap操作，如果作为可查询WMS，则需要支持可选的GetFeatureInfo操作。

对于样式化图层描述符WMS服务，还有两种可选的操作，一个是请求图例符号操作，即GetLegendGraphic；第二个是请求用户定义的样式操作，即GetStyles。

# 二、请求WMS服务的元数据

因为要使用到GeoServer，所以请先阅读这篇文章：使用GeoServer发布shapefile数据

GetCapabilities操作返回服务的元数据。根据该服务的元数据来确定该服务支持哪些其他操作。

查看GeoServer的管理页面的首页可以发现它实现了WMS规范：

![img](https://img-blog.csdnimg.cn/20190716161017892.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

接下来，比如我想访问自己本地计算机安装的GeoServer的WMS服务的元数据，就可以直接在浏览器地址栏输入：

    http://localhost:8084/geoserver/wms?service=wms&version=1.3.0&request=GetCapabilities

其中：

- http://localhost:8084/geoserver/wms    ——    是请求的路径
- service=wms    ——    表示服务是WMS
- version=1.3.0    ——    表示WMS规范版本是1.3.0（最新版本）
- request=GetCapabilities    ——    表示请求服务的元数据

上面的地址返回或打开一个XML格式的文件，内容如下（为了节省篇幅，删减了一些重复与不重要的内容）：

```xml

This XML file does not appear to have any style information associated with it. The document tree is shown below.
<WMS_Capabilities xmlns="http://www.opengis.net/wms" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.3.0" updateSequence="158" xsi:schemaLocation="http://www.opengis.net/wms http://localhost:8084/geoserver/schemas/wms/1.3.0/capabilities_1_3_0.xsd">
<Service>
<Name>WMS</Name>
<Title>GeoServer Web Map Service</Title>
<Abstract>
A compliant implementation of WMS plus most of the SLD extension (dynamic styling). Can also generate PDF, SVG, KML, GeoRSS
</Abstract>
<KeywordList>
<Keyword>WFS</Keyword>
<Keyword>WMS</Keyword>
<Keyword>GEOSERVER</Keyword>
</KeywordList>
<OnlineResource xlink:type="simple" xlink:href="http://geoserver.org"/>
<ContactInformation>
<ContactPersonPrimary>
<ContactPerson>Claudius Ptolomaeus</ContactPerson>
<ContactOrganization>The Ancient Geographers</ContactOrganization>
</ContactPersonPrimary>
<ContactPosition>Chief Geographer</ContactPosition>
<ContactAddress>
<AddressType>Work</AddressType>
<Address/>
<City>Alexandria</City>
<StateOrProvince/>
<PostCode/>
<Country>Egypt</Country>
</ContactAddress>
<ContactVoiceTelephone/>
<ContactFacsimileTelephone/>
<ContactElectronicMailAddress>claudius.ptolomaeus@gmail.com</ContactElectronicMailAddress>
</ContactInformation>
<Fees>NONE</Fees>
<AccessConstraints>NONE</AccessConstraints>
</Service>
<Capability>
<Request>
<GetCapabilities>
<Format>text/xml</Format>
<DCPType>
<HTTP>
<Get>
<OnlineResource xlink:type="simple" xlink:href="http://localhost:8084/geoserver/ows?SERVICE=WMS&"/>
</Get>
<Post>
<OnlineResource xlink:type="simple" xlink:href="http://localhost:8084/geoserver/ows?SERVICE=WMS&"/>
</Post>
</HTTP>
</DCPType>
</GetCapabilities>
<GetMap>
<Format>image/png</Format>
<Format>application/atom+xml</Format>
<Format>application/json;type=utfgrid</Format>
<Format>application/pdf</Format>
<Format>application/rss+xml</Format>
<Format>application/vnd.google-earth.kml+xml</Format>
<Format>
application/vnd.google-earth.kml+xml;mode=networklink
</Format>
<Format>application/vnd.google-earth.kmz</Format>
<Format>image/geotiff</Format>
<Format>image/geotiff8</Format>
<Format>image/gif</Format>
<Format>image/jpeg</Format>
<Format>image/png; mode=8bit</Format>
<Format>image/svg+xml</Format>
<Format>image/tiff</Format>
<Format>image/tiff8</Format>
<Format>image/vnd.jpeg-png</Format>
<Format>text/html; subtype=openlayers</Format>
<Format>text/html; subtype=openlayers2</Format>
<Format>text/html; subtype=openlayers3</Format>
<DCPType>
<HTTP>
<Get>
<OnlineResource xlink:type="simple" xlink:href="http://localhost:8084/geoserver/ows?SERVICE=WMS&"/>
</Get>
</HTTP>
</DCPType>
</GetMap>
<GetFeatureInfo>
<Format>text/plain</Format>
<Format>application/vnd.ogc.gml</Format>
<Format>text/xml</Format>
<Format>application/vnd.ogc.gml/3.1.1</Format>
<Format>text/xml; subtype=gml/3.1.1</Format>
<Format>text/html</Format>
<Format>application/json</Format>
<DCPType>
<HTTP>
<Get>
<OnlineResource xlink:type="simple" xlink:href="http://localhost:8084/geoserver/ows?SERVICE=WMS&"/>
</Get>
</HTTP>
</DCPType>
</GetFeatureInfo>
</Request>
<Exception>
<Format>XML</Format>
<Format>INIMAGE</Format>
<Format>BLANK</Format>
<Format>JSON</Format>
</Exception>
<Layer>
<Title>GeoServer Web Map Service</Title>
<Abstract>
A compliant implementation of WMS plus most of the SLD extension (dynamic styling). Can also generate PDF, SVG, KML, GeoRSS
</Abstract>
 <!-- All supported EPSG projections: -->
<!-- 省略 -->
<CRS>EPSG:3857</CRS>
<!-- 省略 -->
<CRS>EPSG:4326</CRS>
<!-- 省略 -->
<CRS>CRS:84</CRS>
<EX_GeographicBoundingBox>
<westBoundLongitude>-180.0</westBoundLongitude>
<eastBoundLongitude>180.0</eastBoundLongitude>
<southBoundLatitude>-90.0</southBoundLatitude>
<northBoundLatitude>90.0</northBoundLatitude>
</EX_GeographicBoundingBox>
<BoundingBox CRS="CRS:84" minx="-180.0" miny="-90.0" maxx="180.0" maxy="90.0"/>
<!-- 省略 -->
<Layer queryable="1" opaque="0">
<Name>nyc:nyc_roads</Name>
<Title>nyc_roads</Title>
<Abstract/>
<KeywordList>
<Keyword>features</Keyword>
<Keyword>nyc_roads</Keyword>
</KeywordList>
<CRS>EPSG:2908</CRS>
<CRS>CRS:84</CRS>
<EX_GeographicBoundingBox>
<westBoundLongitude>-74.00083696924521</westBoundLongitude>
<eastBoundLongitude>-73.97235840001699</eastBoundLongitude>
<southBoundLatitude>40.73668796412016</southBoundLatitude>
<northBoundLatitude>40.76948947044791</northBoundLatitude>
</EX_GeographicBoundingBox>
<BoundingBox CRS="CRS:84" minx="-74.00083696924521" miny="40.73668796412016" maxx="-73.97235840001699" maxy="40.76948947044791"/>
<BoundingBox CRS="EPSG:2908" minx="984018.1663741902" miny="207673.09513056703" maxx="991906.4970533887" maxy="219622.53973435296"/>
<Style>
<Name>line</Name>
<Title>Default Line</Title>
<Abstract>A sample style that draws a line</Abstract>
<LegendURL width="20" height="20">
<Format>image/png</Format>
<OnlineResource xmlns:xlink="http://www.w3.org/1999/xlink" xlink:type="simple" xlink:href="http://localhost:8084/geoserver/ows?service=WMS&request=GetLegendGraphic&format=image%2Fpng&width=20&height=20&layer=nyc%3Anyc_roads"/>
</LegendURL>
</Style>
</Layer>
<!-- 省略 -->
</Layer>
</Capability>
</WMS_Capabilities>
```

其中：

1、<Service>与</Service>之间一段的内容描述的是该服务的名称、关键词以及联系信息等。

2、<Capability>与</Capabilities>之间描述了该服务支持的操作以及包含的图层。其中：

<Request>与<Request>之间描述的是该服务支持的操作，从上述响应可以看出该服务支持GetCapabilities、GetMap（得到地图）、GetFeatureInfo（得到要素信息）操作。
<Layer>与<Layer>之间罗列了该服务所包含的所有图层数据
<GetMap>与</GetMap>中的Format列出了GetMap请求所支持的返回图片的格式，包括PNG、TIFF、GIF、JPEG、WBMP等格式。
<DCPType></DCPType>中规定了请求的方式，上面的例子表示支持HTTP的Get与Post两种方式。根据该响应我们可构造GetMap请求获取图层或某些图层指定范围的地图。

# 二、请求WMS服务的地图图像

根据服务器的元数据，便可构造GetMap操作获取地图。

例如要得到GeoServer中的nyc_roads图层的地图图像，就可以在浏览器地址栏中输入：

http://localhost:8084/geoserver/wms?SERVICE=wms&VERSION=1.3.0&REQUEST=GetMap&LAYERS=nyc:nyc_roads&SRS=EPSG:2908&BBOX=984018.1663741902,207673.09513056703,991906.4970533887,219622.53973435296&FORMAT=image/png&WIDTH=600&HEIGHT=800

该请求返回的结果如下图所示：

![img](https://img-blog.csdnimg.cn/20190717111336318.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

在上述URL中：

- SERVICE=wms    ——    表示使用WMS服务
- VERSION=1.3.0    ——    表示使用1.3.0版本的WMS规范
- REQUEST=GetMap    ——    表示执行GetMap操作
- LAYERS=nyc:nyc_roads    ——    表示请求的图层是nyc_roads
- CRS=EPSG:2908    ——    表示使用的坐标参照系统为EPSG:2908
- BBOX=984018.1663741902,207673.09513056703,991906.4970533887,219622.53973435296    ——    表示需要请求的图层的范围
- FORMAT=image/png    ——    表示返回的地图图像的格式为PNG
- WIDTH与HEIGHT    ——    指定返回图像的宽与高，单位为像素

当从WMS请求地图时，有一些是必需的参数，必须提供，此外还有一些可选参数，如果WMS服务的发布者实现了，也可使用。

在上述URL中所有的参数都是必需的，必须包含。

可通过WMS规范文档（前面已给出下载地址）的7.3.2小节来查看哪些是GetMap请求必需或可选参数，如下所示：

# 四、请求WMS服务的地图要素信息

GetFeatureInfo操作是一个可选的操作。GetFeatureInfo操作仅仅支持可查属性（queryable）等于“1” 的图层，对于其他图层客户端不能发送GetFeatureInfo操作请求。

当WMS服务不支持GetFeatureInfo操作请求时，会返回服务异常信息。

GetFeature操作的主要请求参数如下表所示：

![img](https://img-blog.csdnimg.cn/20190717112608585.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

即：

- VERSION    ——    请求版本号
- REQUEST=GetFeatureInfo    ——    要请求的操作
- map request part    ——    GetMap请求参数的部分副本，就是和GetMap请求中的部分参数是一样的。不包含其中的VERSION和REQUEST参数。决定查询的目标地图，即在哪个地图图片上查询
- QUERY_LAYERS=layer_list    ——    待查询的图层列表，图层之间以英文符号分隔
- INFO_FORMAT=output_format    ——    要素信息的返回格式（MIME类型）
- FEATURE_COUNT=number    ——    要返回信息的要素的数量（默认为1）。以（I，J）参数为中心点，根据GetMap操作中的请求参数BBOX、WIDTH和
- HEIGHT确定初始查找范围半径，对指定的查询图层进行查找。如果查询返回结果小于用户指定的number值，将查找半径扩大一倍继续查找，如果查询结果数目满足用户要求返回的要素数目，返回结果，否则继续扩大半径。当查找半径达到初始搜索半径的8倍时，终止查询，返回查询结果，进入下一图层的查询。图层的查询顺序与待查询图层列表中的顺序一致。
- I=pixel_column    ——    以像素表示的要素X坐标（最左侧为0，向右递增）
- J=pixel_row    ——    以像素表示的要素Y坐标（最上侧为0，向下递增）
- EXCEPTIONS=exception_format    ——    WMS的异常错误报告格式（默认为application/vnd.ogc.se_xml）

例如，要查找GeoServer的nyc_roads图层的要素信息（以像素点（400, 300）为中心点进行查询）

http://localhost:8084/geoserver/wms?SERVICE=wms&VERSION=1.3.0&REQUEST=GetFeatureInfo&LAYERS=nyc:nyc_roads&CRS=EPSG:2908&BBOX=984018.1663741902,207673.09513056703,991906.4970533887,219622.53973435296&WIDTH=600&HEIGHT=800&QUERY_LAYERS=nyc:nyc_roads&INFO_FORMAT=text/plain&I=400&J=300

返回的结果如下图所示：


![img](https://img-blog.csdnimg.cn/20190717113434832.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)