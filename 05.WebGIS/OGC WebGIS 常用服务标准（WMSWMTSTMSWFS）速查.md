- [OGC WebGIS 常用服务标准（WMS/WMTS/TMS/WFS）速查 - 四季留歌 - 博客园 (cnblogs.com)](https://www.cnblogs.com/onsummer/p/16492518.html)

# 0. 参数传递方式

- 键值对
- RESTful API
- SOAP

三种方式对于下文列举的服务并不是全都存在的，例如 WMS 就只有第一种。

本文不介绍 SOAP 方式（因为太复杂了）。

# 1. WMS 速查

以 `1.1.0` 版本为参考。

## 1.1. 能力

- `GetCapabilities`
- `GetMap`
- `GetFeatureInfo`

## 1.2. 获取地图图片举例（GetMap）

以这样一个请求地址为例：



```http
http://localhost:4800/geoserver/spatial_base/wms?<queryString>
```

`queryString` 即查询字符串，我把它列成表格：

| param   | value                                                        | desc                         |
| :------ | :----------------------------------------------------------- | :--------------------------- |
| service | WMS                                                          | 服务类型                     |
| version | 1.1.0                                                        | 服务版本                     |
| request | GetMap                                                       | 方法                         |
| layers  | spatial_base:guangxi_cities                                  | 哪个图层                     |
| bbox    | 104.450889587402,20.8992862701416,112.061851501465,26.3855667114258 | 要多大范围                   |
| width   | 768                                                          | 要返回的图像像素宽           |
| height  | 553                                                          | 要返回的图像像素高           |
| srs     | EPSG:4326                                                    | 用哪个坐标系                 |
| styles  | ""                                                           | 用什么样式，缺省要给空字符串 |
| format  | image/png                                                    | 格式                         |

> GeoServer 的 layers 参数，是“工作空间名:图层名”这样的组合。

那么，它返回的就是一张图：

[![img](https://img2022.cnblogs.com/blog/1097074/202207/1097074-20220718235305653-1819685855.png)](https://img2022.cnblogs.com/blog/1097074/202207/1097074-20220718235305653-1819685855.png)

这是最常规的使用“键值对”，也就是 queryString 来请求地图的 WMS 用法。

## 1.3. 在 CesiumJS 和 OpenLayers6 中使用 GeoServer WMS

在 CesiumJS 中：

```js
new Cesium.WebMapServiceImageryProvider({
  url: 'http://localhost:4800/geoserver/spatial_base/ows',
  layers: 'spatial_base:guangxi_cities',
  parameters: {
    transparent: true,
    format: 'image/png',
  },
})
```

只需要保证坐标系合适即可，当然，url 的 `ows` 也可以改为 `wms`。

> OWS 只是 GeoServer 上的一个通配符，如果你知道你想用的是什么服务，可以不写 ows，例如本例，可以直接写 'http://localhost:4800/geoserver/spatial_base/wms'

在 OpenLayers6 中：

```js
import TileLayer from 'ol/layer/Tile'
import TileWMS from 'ol/source/TileWMS'

new TileLayer({
  extent: [104.4509, 20.8993, 112.0619, 26.3856], // 坐标系保持与 View 一致
  source: new TileWMS({
    url: 'http://localhost:4800/geoserver/spatial_base/wms',
    params: {
      'LAYERS': 'spatial_base:guangxi_cities',
    },
    serverType: 'geoserver', // 有好几种地理服务器，要明确指定
  }),
})

// View 坐标系的设置
import { View } from 'ol'
new View({
  // ...
  projection: get('EPSG:4326') // 返回一个 Projection 实例即可
})
```

根据 OpenLayers 的文档：

> At least a `LAYERS` param is required. `STYLES` is `''` by default. `VERSION` is `1.3.0` by default. `WIDTH`, `HEIGHT`, `BBOX` and `CRS` (`SRS` for WMS version < 1.3.0) will be set dynamically.

也就是至少要设置 `LAYERS` 参数。如果请求的图层的坐标系与 View 的一致，则不需要设置 `SRS`。

## 1.4. 获取要素信息

WMS 虽然主要的用途是请求地图图片，是一种经典的服务器渲染服务，但是也保留了基本的要素查询功能，也就是 `GetFeatureInfo`，举例：

```http
http://localhost:4800/geoserver/spatial_base/ows
?service=WMS
&version=1.1.1
&request=GetFeatureInfo
&layers=spatial_base:guangxi_cities
&bbox=101.25,22.5,112.50,33.75
&width=256
&height=256
&srs=EPSG:4326
&query_layers=spatial_base:guangxi_cities
&info_format=application/json
&x=181
&y=199
```

`GetFeatureInfo` 是一个可选的功能，GeoServer 有这个功能。简单解释一下，参数 `width` 和 `height` 是参数 `bbox` 范围生成的一小块图片，然后去查询这块图片中像素位置是 `x`、`y` 的要素信息，其它参数不难理解。

# 2. WMTS 速查

## 2.1. 轴向

WMTS 的轴朝向如下图所示。

[![img](https://img2022.cnblogs.com/blog/1097074/202207/1097074-20220718235621471-1996268123.png)](https://img2022.cnblogs.com/blog/1097074/202207/1097074-20220718235621471-1996268123.png)

## 2.2. 能力

- `GetCapabilities`（获取WMTS元数据文档，也叫获取能力文档）
- `GetTile`（获取一张瓦片）
- `GetFeatureInfo` (可选能力)

## 2.3. 示意图

[![img](https://img2022.cnblogs.com/blog/1097074/202207/1097074-20220718235629469-902677491.png)](https://img2022.cnblogs.com/blog/1097074/202207/1097074-20220718235629469-902677491.png)

WMTS 的行列号、瓦片阵（TileMatrix，类似层级的概念，参考第 5 节）是从 0 开始算的，例如 `TileMatrix=EPSG:4326:0&TileCol=0&TileRow=0`。

## 2.4. 请求瓦片举例（GetTile）

以 2.3 小节中的“TileRow=55 & TileCol=103”这张瓦片为例：

[![img](https://img2022.cnblogs.com/blog/1097074/202207/1097074-20220718235638555-1671645236.png)](https://img2022.cnblogs.com/blog/1097074/202207/1097074-20220718235638555-1671645236.png)

它的请求地址是：

```perl
http://localhost:4800/geoserver/gwc/service/wmts?layer=spatial_base%3Aguangxi_cities&style=&tilematrixset=EPSG%3A900913&Service=WMTS&Request=GetTile&Version=1.0.0&Format=image%2Fpng&TileMatrix=EPSG%3A900913%3A7&TileCol=103&TileRow=55
```

把 queryString 列成表格即：

| param         | value                       | desc                          |
| :------------ | :-------------------------- | :---------------------------- |
| layer         | spatial_base:guangxi_cities | 与 WMS 的 layers 意义一致     |
| style         | ""                          | 与 WMS 的 style 意义一致      |
| tilematrixset | EPSG:900913                 | 瓦片阵集，见本文第5节         |
| TileMatrix    | EPSG:900913:7               | 当前级别的瓦片阵，见本文第5节 |
| TileCol       | 103                         | 瓦片列号                      |
| TileRow       | 55                          | 瓦片行号                      |
| Service       | WMTS                        | 与 WMS 的 service 意义一致    |
| Request       | GetTile                     | 与 WMS 的 request 意义一致    |
| Version       | 1.0.0                       | 与 WMS 的 version 意义一致    |
| Format        | image/png                   | 与 WMS 的 format 意义一致     |

聪明的你应该注意到了，参数的名称是大小写任意的，但是**参数值部分大小写敏感**，例如 “EPSG:900913”写成“epsg:900913”是请求不到的（至少 GeoServer 是这样）；但是“GetTile”写成“gettile”又是可以的。

## 2.5. 请求瓦片举例（GetTile）使用 RESTful

图与上一小节返回的是一样的，使用 RESTful 风格的请求是这样的：

```http
http://localhost:4800/geoserver/gwc/service/wmts/rest/spatial_base:guangxi_cities/polygon/EPSG:900913/EPSG:900913:7/55/103?format=image/png
```

## 2.6. 关于 GeoServer 两种获取瓦片的接口风格

- 键值对：在 GeoServer 中使用 OpenLayers 预览，使用浏览器开发者工具查看网络请求，此处的接口风格即键值对形式，使用 queryString；
- RESTful：请求 WMTS 的能力文档，搜索 `ResourceURL` 标签，此处的地址是 REST 风格的。

## 2.7. 在 CesiumJS 和 OpenLayers6 中使用 GeoServer WMTS

在 CesiumJS 中，你要十分小心每一级“TileMatrix”的名称，因为 CesiumJS 使用的是 REST 风格的请求地址，这就意味着，TileMatrix 必须与能力文档中对应图层的 TileMatrix 名称一致，才能拼凑出正确的 URL。

CesiumJS 默认 WMTS 每一级的 TileMatrix 名称就是简单的“0、1、2、3、4...”，但是 GeoServer 默认的 900913 和 4326 这两个 `TileMatrixSet` 的名称却是 “EPSG:4326:0、EPSG:4326:1、EPSG:4326:2...”和“EPSG:900913:0、EPSG:900913:1、EPSG:900913:2...”，面对这种情况也好办，我们可以用 JavaScript 快速生成这样一个有规律的 `TileMatrixLabels` 数组：

```js
const maxLevel = 3 // 别忘了改成你的 WMTS 支持的最大等级，此处演示写个 3
const tileMatrixID = 'EPSG:900913'
const tileMatrixLabels = Object.keys(new Array(maxLevel).fill(0)).map(v => `${tileMatrixID}:${v}`)
// tileMatrixLabels 即 ['EPSG:900913:0', 'EPSG:900913:1', 'EPSG:900913:2']
```

现在，你可以用这个 `tileMatrixLabels` 数组创建 `WebMapTileServiceImageryProvider`：

```js
new Cesium.WebMapTileServiceImageryProvider({
  url: 'http://localhost:4800/geoserver/gwc/service/wmts/rest/spatial_base:guangxi_cities/{style}/{TileMatrixSet}/{TileMatrix}/{TileRow}/{TileCol}?format=image/png',
  style: 'polygon', // 改 'default' 就是默认的样式
  layer: 'spatial_base:guangxi_cities',
  tileMatrixLabels: tileMatrixLabels,
  tileMatrixSetID: 'EPSG:900913',
  rectangle: Cesium.Rectangle.fromDegrees(104.450889587402,20.8992862701416,112.061851501465,26.3855667114258),
})
```

你甚至可以封装一个函数获取这些 TileMatrix 的名称：

```js
/**
 * 创建 TileMatrix 的名称
 * @param {string} tileMatrixID 即 `TileMatrixSet` 的名称
 * @param {number} maxLevel 即 WMTS 的最大等级
 * @returns {string[]}
 */
const createTileMatrixLabels = (tileMatrixID, maxLevel) => 
  Object.keys(new Array(maxLevel).fill(0)).map(v => `${tileMatrixID}:${v}`)
```

至于 OpenLayers6 加载 WMTS，也是需要计算分辨率、TileMatrixIDs 的，略嫌麻烦，以 `EPSG:4326` 为例，你需要计算图层的分辨率列表、TileMatrix 名称列表：



```js
// 计算 22 级别，够用就行
const resolutions = new Array(22)
// EPSG:4326 一级宽度跨 2 个 256 像素的瓦片
const firstLevelPixelWidth = 360 / (256 * 2)
for (let z = 0; z < 22; ++z) {
  // 逐级除以 2
  resolutions[z] = firstLevelPixelWidth / Math.pow(2, z)
}
const tileMatrixLabels = createTileMatrixLabels('EPSG:4326', 22)
```

随后，你就可以用 `resolutions` 和 `tileMatrixLabels` 创建一个 `WMTSTileGrid`，进而创建 WMTS 图层了：

```js
const wmtsTileGrid = new WMTSTileGrid({
  origin: [-180, 90], // origin 即当前坐标系的的左上角
  resolutions: resolutions,
  matrixIds: tileMatrixLabels,
})

new TileLayer({
  extent: [104.4509, 20.8993, 112.0619, 26.3856],
  source: new WMTS({
    // 和 CesiumJS 不太一样，这里不用到模板那么细
    url: 'http://localhost:4800/geoserver/gwc/service/wmts',
    layer: 'spatial_base:guangxi_cities',
    matrixSet: 'EPSG:4326', // 与能力文档中此图层的 TileMatrixSet 一致
    format: 'image/png',
    // 也可以用 `ol/proj` 包导出的 get('EPSG:4326')，返回 Projection 实例即可
    projection: 'EPSG:4326',
    tileGrid: wmtsTileGrid,
    style: 'polygon',
    wrapX: true,
  }),
})
```

而如果是 `EPSG:3857`，也即 `EPSG:900913`，那么你的 `origin`、`extent`、`firstLevelPixelWidth` 就要随之改变了：

```js
const origin = [-20037508.34, 2003708.34]
const extent = [11627419.84177403,2379873.5953122815,12474668.246494522,3046913.9333698303]
const firstLevelPixelWidth = 40075016.68557849 / 256
```

至于为什么是这几个数字，请查看 GeoServer 中相关 Gridset 的数值吧，需要有 Web 墨卡托坐标系相关的基础。

# 3. TMS 速查

TMS 是一种非常接近静态资源的地图瓦片数据集，常见的瓦片格式有 `jpeg`、`png`、`pbf` 等。这个标准比较旧了，但是胜在简单。

## 3.1. 轴向

TMS 轴朝向如下图所示。

[![img](https://img2022.cnblogs.com/blog/1097074/202207/1097074-20220718235701281-1580576306.png)](https://img2022.cnblogs.com/blog/1097074/202207/1097074-20220718235701281-1580576306.png)

## 3.2. 元数据 XML 文档

一般来说，TMS 的地址会指向一个名称是 `tilemapresource.xml` 的文档。当然，GeoServer 就比较例外，仅仅是返回 XML 文档而地址并不指向 XML 文档。

这个 XML 文档是 TMS 最显著的特征，记录了这个瓦片地图集的元数据：

```xml
<TileMap version="1.0.0" tilemapservice="...">
  <!-->...<-->
</TileMap>
```

## 3.3. 请求瓦片举例

请求地址：

```http
http://localhost:4800/geoserver/gwc/service/tms/1.0.0
/spatial_base:guangxi_cities@EPSG:900913@png
/7/103/72.png
```

如下图所示：

[![img](https://img2022.cnblogs.com/blog/1097074/202207/1097074-20220718235731611-462871507.png)](https://img2022.cnblogs.com/blog/1097074/202207/1097074-20220718235731611-462871507.png)

## 3.3. 在 QGIS 中加载 GeoServer 的 TMS

添加一个 XYZ 图层即可，但是在模板链接中要填写的是 `{z}/{x}/{-y}.imageExt`，而不是 `{z}/{x}/{y}.imageExt`。

## 3.4. 在 CesiumJS 和 OpenLayers6 中使用 GeoServer 的 TMS

CesiumJS 在测试中发现对非全范围的 EPSG4326 或 3857 坐标系的 TMS 加载是存在问题的。GeoServer 发布的图层一般没有这个问题。

举例：

```js
new Cesium.TileMapServiceImageryProvider({
  url: "http://localhost:4800/geoserver/gwc/service/tms/1.0.0/spatial_base%3Aguangxi_cities@EPSG%3A900913@png",
  minimumLevel: 0,
  maximumLevel: 15,
  rectangle: Cesium.Rectangle.fromDegrees(104.450889587402,20.8992862701416,112.061851501465,26.3855667114258)
})
```

如果使用的是 `TileMapServiceImageryProvider` 这个类，那么它是遵循正确的 z、x、y 顺序的。如果使用的是 `UrlTemplateImageryProvider`，那么你需要把模板中的 `{y}` 改成 `{reverseY}`：

```js
new Cesium.UrlTemplateImageryProvider({
  url: "http://localhost:4800/geoserver/gwc/service/tms/1.0.0/spatial_base%3Aguangxi_cities@EPSG%3A900913@png/{z}/{x}/{reverseY}.png",
  minimumLevel: 0,
  maximumLevel: 15,
  rectangle: Cesium.Rectangle.fromDegrees(104.450889587402,20.8992862701416,112.061851501465,26.3855667114258)
})
```

CesiumJS 会判断默认的 TMS 描述文件“tilemapresource.xml”，请求失败则降级成 `{z}/{x}/{reverseY}.imageExt`

而在 OpenLayers6 中，使用 TMS 则是通过 `XYZ` 实现的：

```js
new TileLayer({
  source: new XYZ({
    url: 'http://localhost:4800/geoserver/gwc/service/tms/1.0.0/spatial_base%3Aguangxi_cities@EPSG%3A900913@png/{z}/{x}/{y}.png'
  }),
})
```

这只是最简单的用法，即默认是 `EPSG:3857` 或 `EPSG:900913` 切片方案的 TMS，否则要指定其它的参数，例如 `projection`、`tileGrid`、`tileSize` 等，具体参考官方文档。如果不想控制台报没瓦片的地方找不到瓦片的错误，则还要加上 `extent` 参数给 `ol/layer/Tile` 类：

```js
import TileLayer from 'ol/layer/Tile'

const tmslayer = new TileLayer({
  extent: [11627419.84177403,2379873.5953122815,12474668.246494522,3046913.9333698303],
  // ...
})
```

## 3.5. GeoServer 是否可以挂接已有的 TMS

暂时不可以。

参考：[Can I use external TMS service as a store in Geoserver?](https://gis.stackexchange.com/questions/385651/can-i-use-external-tms-service-as-a-store-in-geoserver)

GeoServer 目前只能挂接其它服务器的 WMS 和 WMTS，TMS 作为一种比较静态的瓦片数据服务，建议直接使用 Web 服务器发布即可，不需要再经过 GeoServer。

# 4. WFS 速查

WFS 即使到了 2.0.0 版本，仍然只能用这两种方式发起请求：

- 使用键值对的简单类型请求，通常用 Get 请求，也能用 Post 请求
- 使用 XML 体的复杂数据请求，只能用 Post 请求

这是有问题的，前端的朋友们熟悉什么？他们要什么？JSON 啊！

若不加以限制，WFS 返回的是基于 XML 的 GML 格式。总之，

## 4.1. 能力

- `GetFeature`：获取矢量要素数据
- `DescribeFeatureType`：查询矢量图层的元数据
- `GetCapabilities`：获取能力文档
- `Transaction`：发起矢量图形交互事务，例如增删改等

这只是主要的能力，2.0.0 还新增了其它的能力，有兴趣的可以去看规范，也可以直接参考 GeoServer 的帮助手册，十分详细：

- [GeoServer Docs - Services - WFS - WFS reference#operatioins](https://docs.geoserver.org/stable/en/user/services/wfs/reference.html#operations)

我只是好奇，为什么 GeoServer 本地不能集成一份帮助文档呢？

## 4.2. 获取要素（GetFeature）及常用参数

这里以 WFS 2.0.0 为例。

一个最简单的获取全部矢量要素的请求如下：

```http
http://localhost:4800/geoserver/spatial_base/ows
?service=WFS
&version=2.0.0
&request=GetFeature
&typeNames=spatial_base:guangxi_cities
&outputFormat=application/json
```

参数 `outputFormat` 的指定非常重要，若不指定，默认返回的是 GML 格式数据。

几个常用的参数如下

| 参数名       | 值类型 | 描述                                              |
| :----------- | :----- | :------------------------------------------------ |
| count        | int    | 限制返回的个数，取前 `count` 个                   |
| featureid    | string | 指定要素的 ID 来查询，格式是“图层名.id”           |
| typeNames    | string | 要查询哪个“图层”，GeoServer 是“工作空间”:“图层名” |
| propertyName | string | 需要返回什么属性字段，用英文逗号连接              |
| filter       | string | 一个 XML 文本，即查询信息                         |
| outputFormat | string | 要返回数据的格式类型，能力文档中有                |

其中，`filter` 的 XML 就是 WFS 较为诟病的一点，因为这个 XML 构造起来比较麻烦。

## 4.3. 获取要素时使用过滤（Filtering）

以一个简单的框选查询为例，你需要构造如下的 XML：

```xml
<Filter xmlns:ogc="http://www.opengis.net/ogc" xmlns:gml="http://www.opengis.net/gml">
  <Intersects>
    <PropertyName>geom</PropertyName>
    <gml:Envelope srsName="EPSG:4326">
      <gml:lowerCorner>109 20</gml:lowerCorner>
      <gml:upperCorner>120 30</gml:upperCorner>
    </gml:Envelope>
  </Intersects>
</Filter>
```

对于我这份数据来说，这样一个框选查询能返回 11 个要素。注意，`<Intersects>` 下的 `<PropertyName>` 的值，即 "geom"，指的是要素图层的待相交查询的几何字段名称。如果是 Shapefile，它的几何字段可能是 "SHAPE" 或其它。

关于这个 `filter` 能进行什么空间查询，请参考：

- [GeoServer Docs - Filtering - Supported Filtering Language](https://docs.geoserver.org/stable/en/user/filter/syntax.html)
- [GeoServer Docs - Filtering - Filtering Function References](https://docs.geoserver.org/stable/en/user/filter/function_reference.html)

------

上述的 XML 过滤参数，是通过 `GET` 请求，发送 QueryString 的方式传递到 WFS 的。如果这个过滤的 XML 体积过大，超出了 GET 请求的最大大小（因浏览器而异，普遍较小），那么就需要改成 `POST` 请求，把这个 XML 作为请求体发送到服务器。

请求路径：

```shell
POST http://localhost:4800/geoserver/spatial_base/ows
```

请求体和上面的 `filter` 略有不同，要把其它的请求参数也带上：

```xml
<?xml version='1.0' encoding='UTF-8'?>
<wfs:GetFeature 
  service="WFS"
  version="2.0.0"
  outputFormat="json"
  xmlns:wfs="http://www.opengis.net/wfs/2.0"
  xmlns:fes="http://www.opengis.net/fes/2.0"
  xmlns:gml="http://www.opengis.net/gml/3.2"
  xmlns:sf="http://www.openplans.org/spearfish"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://www.opengis.net/wfs/2.0
                      http://schemas.opengis.net/wfs/2.0/wfs.xsd
                      http://www.opengis.net/gml/3.2
                      http://schemas.opengis.net/gml/3.2.1/gml.xsd"
>
  <wfs:Query typeNames='spatial_base:guangxi_cities'>
  <wfs:PropertyName>geom</wfs:PropertyName>
  <wfs:PropertyName>name</wfs:PropertyName>
    <fes:Filter>
      <fes:PropertyIsEqualTo matchAction="OR">
        <fes:ValueReference>name</fes:ValueReference>
        <fes:Literal>梧州市</fes:Literal>
      </fes:PropertyIsEqualTo>
    </fes:Filter>
  </wfs:Query>
</wfs:GetFeature>
```

WFS 1.0.0 和 1.1.0 的又略有不同，详见：

- [GeoServer Docs - Filtering - Filter functions](https://docs.geoserver.org/stable/en/user/filter/function.html)
- [OGC Standard - Filter Encoding](https://www.ogc.org/standards/filter)

WFS 参考资料之复杂，中文教程、例子之少，其实讲究效率的年代不愿意用它也是情有可原的。

官方的例子，在标准文档的 `Annex B` 章节（附件B）中。

在线的文档，则可以参考 [OGC Standard Examples](https://schemas.opengis.net/) 页面，找到 WFS 目录即可。

## 4.4. 简述事务（Transaction）

WFS 的事务允许你向服务器上的数据进行增删改，能增删改的除了属性数据，当然还包括图形数据。

在 WFS 2.0.0 中，事务支持如下几个动作（Action）：

- delete
- insert
- replace
- update

以更新为例，仍然是请求 4.3 小节中的地址，发送的 XML 请求体则是：

```xml
<?xml version='1.0' encoding='UTF-8'?>
<wfs:Transaction 
  version="2.0.0"
  service="WFS"
  xmlns:fes="http://www.opengis.net/fes/2.0"
  xmlns:wfs="http://www.opengis.net/wfs/2.0"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://www.opengis.net/wfs/2.0 http://schemas.opengis.net/wfs/2.0.0/wfs.xsd">
  <!-->要 Update 的要素是 spatial_base:guangxi_cities<-->
  <wfs:Update typeName="spatial_base:guangxi_cities">
    <!-->更新名称属性为“梧州市_重命名”<-->
    <wfs:Property>
      <wfs:ValueReference>name</wfs:ValueReference>
      <wfs:Value>梧州市_重命名</wfs:Value>
    </wfs:Property>
    <!-->使用 Filtering 只修改第4个要素<-->
    <fes:Filter>
      <fes:ResourceId rid="guangxi_cities.4"/>
    </fes:Filter>
  </wfs:Update>
</wfs:Transaction>
```

有时候你无法发送 `Transaction` 请求，返回的错误是“XXX is readonly”，应该是 GeoServer 对编辑请求作了限制，你可以到管理页面的“Security - Data”下，将“*.*.w”的规则（也就是写规则）赋予合适的角色，即可得到编辑写入的权限。

更多例子请参考文末给的例子链接，或者直接查阅对应 WFS 版本的标准文档中的 Examples 内容。

## 4.5. 推荐与不推荐

WFS 的要务并不是拿来显示大量矢量数据的，大量的矢量图形数据对网络传输、浏览器渲染的性能要求非常高，甚至浏览器超过 1000 个常规的 JavaScript 对象就难以把持 rAF 程序的流畅性（一是遍历性能可能不足，二是浏览器可用操作系统内存可能不够）。

所以，**不推荐** WFS 用来**全量显示矢量图形数据**。

针对“既需要显示、又需要查询”的需求，可将任务分解：

- 使用 WMTS/TMS/VectorTiles 显示图形；
- 使用 WMS/WMTS 的 GetFeatureInfo 或独立存储非空间数据，另写请求接口进行查询非空间数据；
- 有空间图形分析或复杂空间查询需求的，请使用地理数据库；
- 有编辑需求的，不太推荐使用 WFS 的 Transaction 操作，建议使用地理数据库 + 可定制的后端查询接口

OpenLayers6 有几个 WFS 的例子，其使用 JavaScript 函数拼接请求参数之复杂令人困扰，实在令人提不起用标准 WFS 的欲望。

而 CesiumJS 则直接不考虑这个 OGC 服务，让用户自己选择矢量图形数据的加载与否（可请求矢量图形数据后使用 `GeoJsonDataSource` 来加载）。

# 5. 什么是 TileMatrixSet / TileMatrix

> 你在 WMTS 能力文档中，一定能看到这两个东西。但是我觉得官方文档废话太多，索性把自己的理解写了出来。

`TileMatrixSet` 笔者译为“瓦片阵集”，而 `TileMatrix` 即“瓦片阵”。

很多人也许第一次看到这个词，一时半会儿想不通为什么是“Matrix”。直译来说，“Matrix”即矩阵：

[![img](https://img2022.cnblogs.com/blog/1097074/202207/1097074-20220718235756703-347221829.png)](https://img2022.cnblogs.com/blog/1097074/202207/1097074-20220718235756703-347221829.png)

假如这个矩阵的每个元素块上填充的是地图瓦片，那就能理解了。

所以，`TileMatrix` 指的就是某个层级的所有瓦片；自然而然，`TileMatrixSet` 就是所有层级的 `TileMatrix` “集”。

举例，GeoServer 中的内置瓦片阵集有一个是 `EPSG:4326`，那么第 7 级瓦片阵即 `EPSG:4326:7`。

> 在 GeoServer 中还有个类似的词是 `Gridset`，在 TileCaching - Gridsets 下可以找到。

# 6. 常见地图服务接口的轴朝向

## ① 使用 Z-order 降维编码的微软必应地图

`Z-order`，有时候又叫 `莫顿曲线`，参考 [wiki - Z-order](https://en.wikipedia.org/wiki/Z-order_curve) 或 [wikigis - Z-order](http://wiki.gis.com/wiki/index.php/Z-order_(curve))。

在微软 Bing 地图瓦片的编号中使用了这个曲线。这个曲线通常用于四叉树的编码。

## ② 类似 WMTS 的谷歌和 OSM

瓦片的轴和原点均与 WMTS 一样，只不过有一个语义上的等价关系：

- TileCol → x（列 Col 值，即横方向）
- TileRow → y（行 Row 值，即纵方向）
- TileMatrix = z（当前瓦片阵，即瓦片层级）

如下图所示：

[![img](https://img2022.cnblogs.com/blog/1097074/202207/1097074-20220718235812233-68137412.png)](https://img2022.cnblogs.com/blog/1097074/202207/1097074-20220718235812233-68137412.png)

OSM 和 谷歌地图 的 Z、X、Y 也与 WMTS 一样，是从 0 开始算的。

以 WMTS 的 `TileMatrix=EPSG:900913:7`、`TileCol=103`、`TileRow=55` 瓦片为例，那么 OSM 的瓦片应为：

```http
https://a.tile.openstreetmap.org/7/103/55.png
```

得到的瓦片：

[![img](https://img2022.cnblogs.com/blog/1097074/202207/1097074-20220718235822946-52648861.png)](https://img2022.cnblogs.com/blog/1097074/202207/1097074-20220718235822946-52648861.png)

而对应的谷歌地图瓦片链接为：

```http
http://mt2.google.com/vt/lyrs=m@167000000&hl=zh-CN&gl=cn&x=103&y=55&z=7
```

得到的图：

[![img](https://img2022.cnblogs.com/blog/1097074/202207/1097074-20220718235831394-1343097826.png)](https://img2022.cnblogs.com/blog/1097074/202207/1097074-20220718235831394-1343097826.png)

再把原来 WMTS的瓦片搬来看看：

[![img](https://img2022.cnblogs.com/blog/1097074/202207/1097074-20220718235837923-627482152.png)](https://img2022.cnblogs.com/blog/1097074/202207/1097074-20220718235837923-627482152.png)

可以说位置上是一致的。

## ③ 百度地图

原点在 0 度经度、0 度纬度：

[![img](https://img2022.cnblogs.com/blog/1097074/202207/1097074-20220718235846774-1059929017.png)](https://img2022.cnblogs.com/blog/1097074/202207/1097074-20220718235846774-1059929017.png)

百度的 X 和 Y 值如上图所示，有正有负。

瓦片层级，从 3 级起算，最大 21 级。

关于百度的 N 种坐标，参考此文 [百度地图API详解之地图坐标系统](http://www.jiazhengblog.com/blog/2011/07/02/289/)，业务上对高德、百度、腾讯等 LBS 厂商用得不多，故不再列举，有需要的朋友可自行在网络上查找。

# 参考资料

- [OGC e-Learning](http://opengeospatial.github.io/e-learning/index.html)
- [OpenStreetMap/Google/百度/Bing瓦片地图服务(TMS) - 可可西 - 博客园](https://www.cnblogs.com/kekec/p/3159970.html)
- [Gist - WFS 2.0 Examples](https://gist.github.com/SKalt/0f4b757209687331c8a1d40aecbf69f9)
- [OGC Standards' Schemas (Examples)](https://schemas.opengis.net/)
- [GeoServer中WMS、WFS的请求规范 - 李晓晖 - 博客园](https://www.cnblogs.com/naaoveGIS/p/5508882.html)