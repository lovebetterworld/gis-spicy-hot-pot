# OGC标准WMTS服务概念与地图商的瓦片编号流派-web地图切片加载

原文地址：https://www.zhoulujun.cn/html/GIS/GIS-Science/8217.html



## OGC概念

**OGC全称——开放地理空间信息联盟([Open Geospatial Consortium](http://www.opengeospatial.org)),   它的主要目的就是制定与空间信息、基于位置服务相关的标准**。而这些所谓的标准其实就是一些接口或编码的技术文档，不同的厂商、各种GIS产品都可以对照这些文档来定义开放服务的接口、空间数据存储的编码、空间操作的方法。

OGC已经是一个比较“官方”的标准化机构了，它不但包括了ESRI、Google、Oracle等业界强势企业作为其成员，同时还和W3C、ISO、IEEE等协会或组织结成合作伙伴关系。因此，OGC的标准虽然并不带有强制性，但是因为其背景和历史的原因，它所制定的标准天然地具有一定的权威性。

OGC目前提供的标准多达几十种，包括我们常用到的WMS、WFS、WCS、WMTS等等，还有一些地理数据信息的描述文档，比如KML、SFS(简单对象描述)、GML、SLD(地理数据符号化)等。

- **WMS服务**，全称是Web Map Service （web地图服务）
- **WFS服务**，全称是Web Feature Service (web 要素服务)
- **WCS服务**，全称为Web Coverage Service（web栅格服务）
- **WMTS服务**，全称是Web Map Tile Service    (web地图切片服务)，WMTS是OGC首个支持restful风格的服务标准

以上就是OGC提供的四种常用服务接口介绍，我们主要讲WMTS

## [WMTS](https://baike.baidu.com/item/WMTS/1091367?fr=aladdin) 概念

[**WMTS**](https://www.opengeospatial.org/standards/wmts)  **是 [OGC](https://www.opengeospatial.org/) 提出的缓存技术标准**，即在服务器端缓存被切割成一定大小瓦片的地图，对客户端只提供这些预先定义好的单个瓦片的服务，将更多的数据处理操作如图层叠加等放在客户端，从而缓解 GIS 服务器端数据处理的压力，改善用户体验。

WMTS提供了一种采用预定义图块方法发布数字地图服务的标准化解决方案。**WMTS弥补了WMS不能提供分块地图的不足。WMTS牺牲了提供定制地图的灵活性，代之以通过提供静态数据（基础地图）来增强伸缩性**，这些静态数据的范围框和比例尺被限定在各个图块内。这些固定的图块集使得对WMTS服务的实现可以使用一个仅简单返回已有文件的Web服务器即可，同时使得可以利用一些标准的诸如分布式缓存的网络机制实现伸缩性。

## WMTS接口支持的三类资源

1. 一个服务元数据（ServiceMetadata）资源（面向过程架构风格下对GetCapabilities操作的响应）（服务器方必须实现）。ServiceMetadata资源描述指定服务器实现的能力和包含的信息。在面向过程的架构风格中该操作也支持客户端与服务器间的标准版本协商。
2. 图块资源（对面向过程架构风格下GetTile操作的响应）（服务器方必须实现）。图块资源表示一个图层的地图表达结果的一小块。
3. 要素信息（FeatureInfo）资源（对面向过程架构风格下GetFeatureInfo操作的响应）（服务器方可选择实现）。该资源提供了图块地图中某一特定像素位置处地物要素的信息，与WMS中GetFeatureInfo操作的行为相似，以文本形式通过提供比如专题属性名称及其取值的方式返回相关信息。

## WMTS 使用瓦片矩阵集（Tile matrix set）

WMTS 使用瓦片矩阵集（Tile matrix  set）来表示切割后的地图，如图1所示。瓦片就是包含地理数据的矩形影像，一幅地图按一定的瓦片大小被切割成多个瓦片，形成瓦片矩阵，一个或多个瓦片矩阵即组成瓦片矩阵集。不同的瓦片矩阵具有不同的分辨率，每个瓦片矩阵由瓦片矩阵标识符（一般为瓦片矩阵的序号，分辨率最低的一层为第0层，依次向上排）进行标识。

![瓦片矩阵集](https://www.zhoulujun.cn/uploadfile/images/2019/11/20191118214550348097168.png)![瓦片图解析-瓦片矩阵](https://www.zhoulujun.cn/uploadfile/images/2019/11/20191118214926421378884.png)

每个瓦片矩阵具有：

1. 自己的瓦片尺寸作为比例尺；
2. 通过像素数来定义的每个瓦片的宽（TileWidth）和高（TileHeight），即瓦片的大小。SuperMap iServer    目前提供的瓦片大小是256*256个像素；
3. 边界框的左上角坐标（TileMatrixminX，TileMatrixmaxY）；
4. 以瓦片为单位来定义的矩阵的宽（MatrixWidth）和高（MatrixHeight），如瓦片数。

瓦片矩阵中的每个瓦片由瓦片的行（TileRow）列（TileCol）值进行标识，行列值分别从瓦片矩阵左上角点所在的瓦片开始算起，起始行列值是（0，0），依次向下向右增加

## 比例尺

WMTS 服务器只提供有限种坐标系和有限种比例尺的服务，为了提高客户端和服务器的互操作能力，WMTS 提出通用比例尺集（Well-known scale  set）的概念。通用比例尺集是 WMTS 服务器之间的一个协定，由一个公共的坐标参考系统和一组公共的比例尺集合组成。定义 Well-known scale  set 仅仅是一个协议机制，对于互操作来说在技术上并不是必需的。

WMTS 服务支持发布的坐标参考系可参考iServer OGC 服务支持发布的坐标参考系。

WMTS 服务所提供的瓦片数据是基于一定的比例尺集合来生成的，目前支持的通用比例尺集请参考 WellknownScale。比例尺是通过如下公式来定义的：

比例尺=1: 地面分辨率(a)*屏幕分辨率(pixel/inch)/0.0254(m/inch)  

此公式可以简写为：比例尺=0.0254/(a*dpi)。

其中，地面分辨率(a)是指一个像素所代表的实际地面距离，单位为米，屏幕分辨率(dpi)是指屏幕上每英寸长度内包含的像素数量，而0.0254(m/inch)是指米与英寸的单位转换。

对于 WMTS 1.0.0  标准服务来说，其分辨率是通过像元大小（0.28mm=0.00028m）来界定的，转换为屏幕分辨率，即每英寸像元数为：1inch/(0.00028m/0.0254(m/inch))=0.0254/0.00028≈90.714。

## 左上角 TopLeftCorner

WMTS 标准中，TopLeftCorner 是描述比例尺集（TileMatrixSet）的左上角坐标的字符序列，由坐标 X 和坐标 Y  组成。在地理坐标系中，经度在纬度之前的顺序是不符合国际惯例的。航空和海运部门通常期望纬度在经度之前，在紧急情况下，不同的坐标显示可能会导致不安全的因素。虽然没有标准明确规定纬度必须在经度之前，但是一般来说都会采用纬度在经度之前的顺序。

### 常见坐标系的 TopLeftCorner 顺序

| **坐标系**                 | 4326 | 3857 | 4490**(国家大地坐标系)** | **EPSG:0****(自定义坐标系)** | **平面坐标系** |
| -------------------------- | ---- | ---- | ------------------------ | ---------------------------- | -------------- |
| **TopLeftCorner 坐标顺序** | YX   | XY   | YX                       | XY                           | XY             |

推荐参看超图的 《[WMTS 概述](http://support.supermap.com.cn/DataWarehouse/WebDocHelp/iPortalHelp_8cSp2/API/WMTS/wmts_introduce.htm)》。WMTS 概述，此段就是摘抄而来。

## 地图底图瓦片

使用XYZ这样的坐标来精确定位一张瓦片。**即XY表示某个层级内的平面，X为横坐标，Y为纵坐标**，类似于数学上常见的笛卡尔坐标系。Z一般表示缩放比率zoom，不同地图商定义有分歧、这是目前主流互联网地图商分歧最大的地方。总结起来分为四个流派：

### 瓦片编号

谷歌XYZ：Z表示缩放层级，Z=zoom；XY的原点在左上角，X从左向右，Y从上向下。

TMS：开源产品的标准，Z的定义与谷歌相同；XY的原点在左下角，X从左向右，Y从下向上。

QuadTree：微软Bing地图使用的编码规范，Z的定义与谷歌相同，同一层级的瓦片不用XY两个维度表示，而只用一个整数表示，该整数服从四叉树编码规则

百度XYZ：Z从1开始，在最高级就把地图分为四块瓦片；XY的原点在经度为0纬度位0的位置，X从左向右，Y从下向上。

## 高德地图WMS/WMTS

[AMap.TileLayer.WMS](https://lbs.amap.com/api/javascript-api/reference/wms/#wms) 用于加载OGC标准的WMS图层

[AMap.TileLayer.WMTS](https://lbs.amap.com/api/javascript-api/reference/wms/#wmts) 用于加载OGC标准的WMTS图层

js-api接口案例：https://lbs.amap.com/api/javascript-api/reference/wms/

示列：https://lbs.amap.com/api/javascript-api/example/thirdlayer/wmts

### xyz加载高德地图：

目前高德的瓦片地址有如下两种：

- **新版地址**：http://wprd0{1-4}.is.autonavi.com/appmaptile?x={x}&y={y}&z={z}&lang=zh_cn&size=1&scl=1&style=7和
- **老版地址**：http://webst0{1-4}.is.autonavi.com/appmaptile?style=7&x={x}&y={y}&z={z}

#### 高德新版的参数设置：

- lang可以通过zh_cn设置中文，en设置英文；
- size基本无作用；
- scl设置标注还是底图，scl=1代表注记，scl=2代表底图（矢量或者影像）；
- style设置影像和路网，style=6为影像图，style=7为矢量路网，style=8为影像路网。

总结之：

http://wprd0{1-4}.is.autonavi.com/appmaptile?x={x}&y={y}&z={z}&lang=zh_cn&size=1&scl=1&style=7  为矢量图（含路网、含注记）

http://wprd0{1-4}.is.autonavi.com/appmaptile?x={x}&y={y}&z={z}&lang=zh_cn&size=1&scl=2&style=7  为矢量图（含路网，不含注记）

http://wprd0{1-4}.is.autonavi.com/appmaptile?x={x}&y={y}&z={z}&lang=zh_cn&size=1&scl=1&style=6  为影像底图（不含路网，不含注记）

http://wprd0{1-4}.is.autonavi.com/appmaptile?x={x}&y={y}&z={z}&lang=zh_cn&size=1&scl=2&style=6  为影像底图（不含路网、不含注记）

http://wprd0{1-4}.is.autonavi.com/appmaptile?x={x}&y={y}&z={z}&lang=zh_cn&size=1&scl=1&style=8  为影像路图（含路网，含注记）

http://wprd0{1-4}.is.autonavi.com/appmaptile?x={x}&y={y}&z={z}&lang=zh_cn&size=1&scl=2&style=8  为影像路网（含路网，不含注记）

#### 高德地图旧版参数参数：

高德旧版可以通过style参数设置影像、矢量、路网。

总结之：

http://webst0{1-4}.is.autonavi.com/appmaptile?style=6&x={x}&y={y}&z={z}  为影像底图（不含路网，不含注记）

http://webst0{1-4}.is.autonavi.com/appmaptile?style=7&x={x}&y={y}&z={z}  为矢量地图（含路网，含注记）

http://webst0{1-4}.is.autonavi.com/appmaptile?style=8&x={x}&y={y}&z={z}  为影像路网（含路网，含注记）

## 天地图WMTS

url地址：http://t0.tianditu.com/ter_c/wmts

- ter为地形
- img为影像
- vec 为矢量
- cia 影像注记
- cva 矢量注记
- cta 地形注记
- c 为经纬度直投
- w 为web墨卡托投影

案例：ter_c，经纬度投影

示范：http://t0.tianditu.gov.cn/img_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=img&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TILEMATRIX={z}&TILEROW={x}&TILECOL={y}&tk=您的密钥

图层列表：

| **图层名称**                                     | **服务地址**                                     | **投影类型** |
| ------------------------------------------------ | ------------------------------------------------ | ------------ |
| 矢量底图                                         | http://t0.tianditu.gov.cn/vec_c/wmts?tk=您的密钥 | 经纬度投影   |
| http://t0.tianditu.gov.cn/vec_w/wmts?tk=您的密钥 | 球面墨卡托投影                                   |              |
| 矢量注记                                         | http://t0.tianditu.gov.cn/cva_c/wmts?tk=您的密钥 | 经纬度投影   |
| http://t0.tianditu.gov.cn/cva_w/wmts?tk=您的密钥 | 球面墨卡托投影                                   |              |
| 影像底图                                         | http://t0.tianditu.gov.cn/img_c/wmts?tk=您的密钥 | 经纬度投影   |
| http://t0.tianditu.gov.cn/img_w/wmts?tk=您的密钥 | 球面墨卡托投影                                   |              |
| 影像注记                                         | http://t0.tianditu.gov.cn/cia_c/wmts?tk=您的密钥 | 经纬度投影   |
| http://t0.tianditu.gov.cn/cia_w/wmts?tk=您的密钥 | 球面墨卡托投影                                   |              |
| 地形底图                                         | http://t0.tianditu.gov.cn/ter_c/wmts?tk=您的密钥 | 经纬度投影   |
| http://t0.tianditu.gov.cn/ter_w/wmts?tk=您的密钥 | 球面墨卡托投影                                   |              |
| 地形注记                                         | http://t0.tianditu.gov.cn/cta_c/wmts?tk=您的密钥 | 经纬度投影   |
| http://t0.tianditu.gov.cn/cta_w/wmts?tk=您的密钥 | 球面墨卡托投影                                   |              |
| 境界（省级以上）                                 | http://t0.tianditu.gov.cn/ibo_c/wmts?tk=您的密钥 | 经纬度投影   |
| http://t0.tianditu.gov.cn/ibo_w/wmts?tk=您的密钥 | 球面墨卡托投影                                   |              |
| 矢量英文注记                                     | http://t0.tianditu.gov.cn/eva_c/wmts?tk=您的密钥 | 经纬度投影   |
| http://t0.tianditu.gov.cn/eva_w/wmts?tk=您的密钥 | 球面墨卡托投影                                   |              |
| 影像英文注记                                     | http://t0.tianditu.gov.cn/eia_c/wmts?tk=您的密钥 | 经纬度投影   |
| http://t0.tianditu.gov.cn/eia_w/wmts?tk=您的密钥 | 球面墨卡托投影                                   |              |

**天地图地图服务二级域名包括t0-t7**，您可以随机选择使用，如http://t2.tianditu.gov.cn/vec_c/wmts?tk=您的密钥

## 谷歌地图WMTS

http://mt0.google.cn/vt/lyrs=s&x=0&y=0&z=1

z即为瓦片的层次，0层覆盖全球；y为行，从上往下为0~2^z-1；x为列，从左往右依次为0~2^z-1

地址中mt0.google.cn为服务器地址，可用的包括mt1.google.cn、mt2.google.cn、mt3.google.cn等。

lyrs=s为地图类型，如下：

- m：路线图
- t：地形图
- p：带标签的地形图
- s：卫星图
- y：带标签的卫星图
- h：标签层（路名、地名等）

## OpenStreetMap

'http://{a-c}.tile.openstreetmap.org/{z}/{x}/{y}.png'

## 雅虎地图

https://{0-3}.base.maps.api.here.com/maptile/2.1/maptile/newest/normal.day/{z}/{x}/{y}/512/png8?lg=ENG&ppi=250&token=TrLJuXVK62IQk0vuXFzaig%3D%3D&requestid=yahoo.prod&app_id=eAdkWGYRoc4RfxVo0Z4B

### 中国主要地图商的瓦片编号流派

有这个列表，可能再也不用担心瓦片的问题了

| 地图商        | 瓦片编码 | 图层 | 链接                                                         |
| ------------- | -------- | ---- | ------------------------------------------------------------ |
| 高德地图      | 谷歌XYZ  | 道路 | `http://webrd02.is.autonavi.com/appmaptile?lang=zh_cn&size=1&scale=1&style=8&x=105&y=48&z=7` |
| 高德地图      | 谷歌XYZ  | 卫星 | `http://webst04.is.autonavi.com/appmaptile?style=6&x=843&y=388&z=10` |
| 谷歌地图      | 谷歌XYZ  | 道路 | `http://mt2.google.cn/vt/lyrs=m&hl=zh-CN&gl=cn&x=105&y=48&z=7` |
| 谷歌地图      | 谷歌XYZ  | 卫星 | `http://mt2.google.cn/vt/lyrs=s&hl=zh-CN&gl=cn&x=105&y=48&z=7` |
| 谷歌地图      | 谷歌XYZ  | 地形 | `http://mt0.google.cn/vt/lyrs=t&hl=zh-CN&gl=cn&x=420&y=193&z=9` |
| OpenStreetMap | 谷歌XYZ  | 道路 | `http://a.tile.openstreetmap.org/7/105/48.png`               |
| 腾讯地图      | TMS      | 道路 | `http://rt1.map.gtimg.com/realtimerender?z=7&x=105&y=79&type=vector&style=0` |
| Bing地图      | QuadTree | 道路 | `http://r1.tiles.ditu.live.com/tiles/r1321001.png?g=100&mkt=zh-cn` |
| 百度地图      | 百度XYZ  | 道路 | `http://online4.map.bdimg.com/tile/?qt=tile&x=98&y=36&z=9&;styles=pl&scaler=1&udt=20170406` |
| 百度地图      | 百度XYZ  | 交通 |                                                              |

http://its.map.baidu.com:8002/traffic/TrafficTileService?level=19&x=99052&y=20189&time=1373790856265&label=web2D&;v=017



## maptalks WMTS 服务

maptalks加载瓦片地图示例参考：

```
{
  name: '谷歌地图',
 map: {
    opacity: 1,
 urlTemplate: 'http://mt2.google.cn/vt/lyrs=m@167000000&hl=zh-CN&gl=cn&x={x}&y={y}&z={z}&s=Galil',
 subdomains: [1, 2, 3, 4]
  }
},
{
  name: 'OpenStreetMap',
 map: {
    urlTemplate: 'http://{a-c}.tile.openstreetmap.org/{z}/{x}/{y}.png',
 subdomains: [1, 2, 3, 4]
  }
},
{
  name: 'carto灰色',
 map: {
    urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
 subdomains: ['a', 'b', 'c', 'd']
  }
},
{
  name: 'yahoo',
 map: {
    urlTemplate: 'https://{0-3}.base.maps.api.here.com/maptile/2.1/maptile/newest/normal.day/{z}/{x}/{y}/512/png8?lg=ENG&ppi=250&token=TrLJuXVK62IQk0vuXFzaig%3D%3D&requestid=yahoo.prod&app_id=eAdkWGYRoc4RfxVo0Z4B,
 subdomains: [1, 2, 3, 4]
  }
},
{
  name: '百度地图',
 map: {
    opacity: 1,
 urlTemplate: 'http://api{s}.map.bdimg.com/customimage/tile?&x={x}&y={y}&z={z},
 subdomains: [0, 1, 2],
 spatialReference: {projection: 'baidu'}
  }
},
{
  name: '高德地图',
 map: {
    opacity: 1,
 urlTemplate: 'http://wprd0{s}.is.autonavi.com/appmaptile?x={x}&y={y}&z={z}&lang=zh_cn&size=1&scl=1&style=6',//'http://webst0{1-4}.is.autonavi.com/appmaptile?x={x}&y={y}&z={z}&lang=zh_cn&size=1&scale=1&style=6'
 subdomains: [1, 2, 3, 4]
  }
},
{
  name: '腾讯地图',
 map: {
    opacity: 1,
 urlTemplate: 'http://rt{s}.map.gtimg.com/realtimerender?z={z}&x={x}&y={y}&type=vector&style=0',
 tileSystem: 'tms-global-mercator',
 subdomains: [0, 1, 2, 3]
  }
}
}
```

## arcgis使用 WMTS 服务

http://desktop.arcgis.com/zh-cn/arcmap/10.3/map/web-maps-and-services/using-wmts-services.htm

## 超图使用 WMTS 服务

http://support.supermap.com.cn/DataWarehouse/WebDocHelp/iPortalHelp_8cSp2/API/WMTS/wmts_introduce.htm



摘录文章：

开源GIS（十七）——OGC标准 https://blog.csdn.net/xcymorningsun/article/details/86649604

WMTS服务初步理解与读取 https://blog.csdn.net/supermapsupport/article/details/50423782

瓦片地图原理 https://segmentfault.com/a/1190000011276788?utm_source=tag-newest

天地图OGC WMTS服务规则 https://www.cnblogs.com/nodegis/p/10233259.html

谷歌地图OGC WMTS服务规则 https://www.cnblogs.com/nodegis/p/10233235.html