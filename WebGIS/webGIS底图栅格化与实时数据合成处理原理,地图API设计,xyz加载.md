# webGIS底图栅格化与实时数据合成处理原理,地图API设计,xyz加载

原文地址：https://www.zhoulujun.cn/html/GIS/WebGIS/433.html

很多地图客户端**底图使用了矢量渲染**，而WebGIS普通采用栅格地图，而移动端才有二者结合模式

## 采用栅格地图的优势

### 为什么最初的底图使用基于金字塔结构的栅格数据？

说实话，tile真是一个伟大的东西，它直接秒杀了GIS界的那些学究们。当OGC委员会的大爷们还在为所谓的WMS服务如何才能够支持更多的空间语义而在推出一版又一版更加复杂的标准时，Google Maps证明了tile是一个非常简洁的方案来为公众提供基础地理信息服务。它的优点有：

1. 兼容性极强，对于浏览器而言，只需要能够显示图片、支持css、异步传输、DOM和javascript，它就能够显示Google Maps。google  Map是AJAX的一个经典应用，直接从服务器端搞到切片，传输到客户端，客户端仅仅排序展示就行了。总之一句话，浏览器实时绘制能力不够。
2. 对于服务器的负载同样很低，由于地图都是预先渲染好的，用户的请求对服务器来讲只有IO代价，而几乎没有CPU代价，相比WMS那种需要实时切图，实时渲染的机制来讲，这种设计的负载真得低了太多了。记住：还有内存数据库可以减少磁盘IO，还有浏览器缓存可以减少图片的请求。矢量引擎要耗费大量的服务器运算资源（因为有完整的空间数据引擎），哪怕只是几十上百的并发用户，都需要极其夸张的服务器运算能力了。矢量引擎是无法满足公众互联网服务的要求的。
3. 由于地图美工介入的渲染工作，瓦片图可以做得非常好看漂亮和易读，比较适合普通用户的浏览

### 为什么覆盖物图层使用的是矢量数据？

google提供的覆盖物图层几乎都是点图层和线图层，虽然理论上它支持多边形矢量数据的展现，但是在很长的一段时间里，其实多边形矢量数据都很少被应用(底图中的建筑轮廓最初是底图栅格数据的一部分).

## 地图底图栅格化技术浅解

### 一，地图缩放分级

我们回想传统纸质地图，比例尺是固定的，在有限的纸张范围上，既想表现大的地理范围，又需要显示更详细的地理元素，那只有一个方式，就是增加元素的排列密度，所以一般我们看到纸质地图的字特别小。

而电子地图采用分级的方式解决这个问题

也就是电子地图其实提供了若干个固定的比例尺，比例尺每增加一次，同样的屏幕范围上，能表现的地理范围就变小了，但是能表现的地物元素更细致了。比如在比较小的比例尺下，我们只能看到国家边界，而在较大比例尺下我们能看某个理发店的名称和位置。

经过行业里的长期发展，业内逐渐采用了分级代替了比例尺，**一般使用0~18这样得分级数表示。级数每增加1级，那么比例尺实际是变大2倍。 这个分级数一般用z表示**，楼主给出的链接的z参数就是这个。

至于每个z表示何种比例尺，这个涉及到地图的投影方式问题。

现在业内流行的投影方式是谷歌发明的**web墨卡托**

#### Web墨卡托投影

地图是显示在平面上的，因此需要将球面坐标转换为平面坐标，这个转换过程称为投影。最常见的投影是墨卡托（Mercator）投影，它具有等角性质，即球体上的两点之间的角度方位与平面上的两点之间的角度方位保持不变，因此特别适合用于导航。

所以墨卡托(Mercator)投影，又名“等角正轴圆柱投影”，是荷兰地图学家墨卡托（Mercator）在1569年拟定，假设地球被围在一个中空的圆柱里，其赤道与圆柱相接触，然后再假想地球中心有一盏灯，把球面上的图形投影到圆柱体上，再把圆柱体展开，这就是一幅标准纬线为零度（即赤道）的“墨卡托投影”绘制出的世界地图。

![img](https://www.zhoulujun.cn/uploadfile/net/2019/0910/20190910112652165851417.jpg)

Web墨卡托投影（又称球体墨卡托投影）是墨卡托投影的变种，它接收的输入是Datum为WGS84的经纬度，但在投影时不再把地球当做椭球而当做半径为6378137米的标准球体，以简化计算。

Web墨卡托投影有两个相关的投影标准，经常搞混：

- EPSG4326：Web墨卡托投影后的平面地图，但仍然使用WGS84的经度、纬度表示坐标；
- EPSG3857：Web墨卡托投影后的平面地图，坐标单位为米。

### 二，地图底图分块

现在第0级是256*256的地图图片，当第1级的时候就是512*512，每一级变为2倍。这样当到18级的时候，整个地图的分辨率是个天文数字，这样任意一台计算机都无法在瞬间完成下载，读取和显示。

实际上把某一级地图 完整下载也是没有意义的，因为我们的屏幕分辨率有限，超出屏幕的范围图片都是浪费。

所以在**每一级上都分割为256\*256的块，然后对每块都编码。经度方向使用x编码。纬度方向使用y编码。每次我们只看需要下载屏幕范围内的相关图片即可**。

为什么这个分辨率是256*256，而不是255*255 或者 是32*32，我个人认为有以下几个原因：

1. 在以前的图像显示技术里基本会要求图像的分辨率是2的幂次方，在N年前做windows上显示图片开发的时候基本都要把图像宽度调整2的幂次方才能正常绘制。以及一些老的gpu都要求纹理必须是2的幂次方。所以如果为了兼容老设备和性能上的一点提升，必须采用幂次方的宽度高度
2. 最终选用256  ，还主要考虑到网络的数据传输效率，数据太大容易下载失败，数据太小下载效率又过低。而256的图片压缩后一般是10K左右，而这个数据量在各种网络下还是表现比较好的。另外实际单张图片过大，覆盖整个地图窗口之后，浪费的区域更多。所以业内最终使用了256。

### 三，地图块的生成

电子地图的生成一般是地理几何数据（点，线，面）按照一定的规则， 配置不同的显示样式，预渲染成图片，可以搜一些制图软件，arcgis等。

现在制图软件基本都提供了cache功能，就是可以根据样式和数据自动切块生成预渲染的地图。当然每种制图软件采用的数据存储方式不同，可以百度到arcgis的cache数据格式。

当然对于百度和高德这样的大公司一般不会采用商业的软件的去预渲染地图，因为这块是地图生成的核心，他们都会有专门的团队去做相关的事情。至于他们预渲染的图片是如何保存在服务器的这个都会不同，不过没什么太难的。中国范围全部缓存成18级图片，总量不到1TB，这个量对于一般的服务器存储没什么问题。

再说如果你要下载地图，那也不需要考虑服务器端如何存储的，只需要根据数据链接去组织x，y，z。

当然每种地图的x，y，z编码规则会稍有不同。

就我的了解 谷歌 和 高德是一致的。

腾讯地图的 z 和 上述两种 是一致的，x，y的尺度也是一致的，只是x，y的计数原点不同。上述两种x从左向右计数，0开始。y从上往下计数，0开始。而腾讯可能是经纬度原点往两边去计数，这样可能会存在x和y为负的情况。

百度和其他家各有差异，百度的分级比例尺我记得是不满足乘2的关系的，这个可以具体百度。

## 底图数据矢量化的优势

矢量渲染对比栅格地图的好处，大概有以下几个方面：

- **数据更新更快更及时**——由于地理数据是海量级别的，制作地图切片可能要消耗几个小时、几天甚至更长，而客户端矢量渲染理论上则可以支持实时更新。，当数据以矢量形式表达后，数据的增删改都和栅格底图解耦了，于是，再也不用为修改一个重要地点信息而要重新渲染一大片的数据而忧愁了，数据运维就舒了长长的一口气。
- **释放客户端的缓存空间，节省流量**——原来客户端需要缓存大量的地图切片，而矢量渲染则仅需要传输GeoJson字串，大大节省流量，这一点在移动端显得尤为重要。
- **客户端支持矢量编辑**——以往，在客户端仅为图片展示，编辑数据是不可能的。

## 地图数据处理与合成



### 地图图层的概念

电子地图对我们实际空间的表达，事实上是**通过不同的图层去描述，然后通过图层叠加显示来进行表达的过程**。对于我们地图应用目标的不同，叠加的图层也是不同的，用以展示我们针对目标所需要信息内容。

![地图地图图层](https://www.zhoulujun.cn/uploadfile/net/2019/0904/20190904163616408356398.jpg)![高低地图图层](https://www.zhoulujun.cn/uploadfile/net/2019/0904/20190904172242210751075.png)



**矢量模型和栅格模型的概念**

GIS（电子地图）采用两种不同的数学模型来对现实世界进行模拟：

- **矢量模型**：同多X,Y（或者X,Y,Z）坐标，把自然界的地物通过点，线，面的方式进行表达
- **栅格模型**（瓦片模型）：用方格来模拟实体

![地图图层矢量模型](https://www.zhoulujun.cn/uploadfile/net/2019/0904/20190904163742442390591.jpg)![地图图层网格模型](https://www.zhoulujun.cn/uploadfile/net/2019/0904/20190904163742866795467.jpg)

论任何国家，真正高精度的地图（例如1：200比例或更高）是受限制不会对外公布的。（相对应给大家参照的是，我国规定互联网上可以公开发布的地图，最高精度是1：10000）公开地图位置精度不得高于50米，等高距不得小于50米，数字高程模型格网不得小于100米。

**地图组成与名词解释** ：https://lbs.amap.com/api/javascript-api/guide/abc/components

## 地图实时数据的来源

实际上实时路况的数据获取有几种情况：

1. **与出租车公司或公交公司等合作**，在车上安装GPS和数据回传系统，对车辆的行驶状况的数据回传。但此方法是往往成本过高，而且出租车、公交车等车辆有限，而且大部分都集中在城市的中心地带，或者用车需求大的区域。
2. **交通部门的流量检测系统**，一是对于重点路段会实行流量监控，但目前各大城市的数据往往掌握在交委旗下的公司手里，获取成本也不低。而且往往目前这方面其实给予实时路况的帮助是有限的，毕竟对于整个城市的道路监控能力，即使是政府的职能部门能力也是有限的。二是交通部门会实时收集所有浮动车（大客车、大货车等需要实时发送GPS信息的车）的GPS实时数据。
3. **UGC数据，也就是数以千万计的APP用户**，手机既能接入移动网络，又能利用GPS定位，实际上现在的手机GPS、水平仪等都已经具备了很不错的精度，当你打开地图APP的一瞬间或地图APP在手机后台运行，GPS开始定位，并且移动网络也已经开始工作了，手机会自动计算你在某段距离里行驶的速度，然后回传到APP所在服务器。当然一个人的数据肯定是不够的，但如果面对一个装机量在上千万甚至上亿水平的地图应用，做到这点肯定不在话下。

在国外发达国家，由于建设速度相对比较缓慢，政府的信息化水平以及信息透明做得较好，其实不需要那么多采集工作。因为由于地物变化相对比较缓慢，政府公开和发布的数据比较及时，透明，准确，可用，因此国外这个行业许多数据生产商直接拿政府公布数据做一下加工就可以了，改动的地方也不多，其次国外民众隐私意识强，一般不愿共享信息。具体可以查看 知乎问题：[百度地图、高德地图的数据从哪里得到的?](https://www.zhihu.com/question/21530085)

## 全球十大地图API

- [Google Maps API](https://developers.google.com/maps/)
- [Bing Maps API](http://www.microsoft.com/maps/choose-your-bing-maps-API.aspx)
- [OpenLayers API](http://openlayers.org/)
- [Foursquare API](https://developer.foursquare.com/)
- [OpenStreetMap API](http://wiki.openstreetmap.org/wiki/API)
- [MapQuest API](http://developer.mapquest.com/)
- [MapBox API](https://www.mapbox.com/developers/api/)
- [CartoDB API](http://cartodb.com/develop)
- [Esri ArcGIS API](https://developers.arcgis.com/javascript/)
- [Yahoo BOSS PlaceFinder API](https://developer.yahoo.com/boss/placefinder/)

在墙内无非是高德百度二选一。个人最先开始都是用百度地图。个人使用上，觉得百度在城市用。高德适合开长途导航用。但是百度地图的API系统性方面比高德强，也更容易入手。可能用百度Echart、Ueditor啥的习惯了。高德代码还是简洁些。腾讯的，接过微信和QQ的api，看了开发的文档，自此离腾讯的东西有多远就躲多远。当然，现在用maptalks可以整合他们。





## 地图底图瓦片

推荐阅读《[OpenLayers教程十二：多源数据加载之使用XYZ的方式加载瓦片地图](https://blog.csdn.net/qq_35732147/article/details/94973411)》

使用XYZ这样的坐标来精确定位一张瓦片。**即XY表示某个层级内的平面，X为横坐标，Y为纵坐标**，类似于数学上常见的笛卡尔坐标系。Z一般表示缩放比率zoom，不同地图商定义有分歧、这是目前主流互联网地图商分歧最大的地方。总结起来分为四个流派：

### 瓦片编号

谷歌XYZ：Z表示缩放层级，Z=zoom；XY的原点在左上角，X从左向右，Y从上向下。

TMS：开源产品的标准，Z的定义与谷歌相同；XY的原点在左下角，X从左向右，Y从下向上。

QuadTree：微软Bing地图使用的编码规范，Z的定义与谷歌相同，同一层级的瓦片不用XY两个维度表示，而只用一个整数表示，该整数服从四叉树编码规则

百度XYZ：Z从1开始，在最高级就把地图分为四块瓦片；XY的原点在经度为0纬度位0的位置，X从左向右，Y从下向上。

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

http://wprd0{1-4}.is.autonavi.com/appmaptile?x={x}&y={y}&z={z}&lang=zh_cn&size=1&scl=1&style=7 为矢量图（含路网、含注记）

http://wprd0{1-4}.is.autonavi.com/appmaptile?x={x}&y={y}&z={z}&lang=zh_cn&size=1&scl=2&style=7 为矢量图（含路网，不含注记）

http://wprd0{1-4}.is.autonavi.com/appmaptile?x={x}&y={y}&z={z}&lang=zh_cn&size=1&scl=1&style=6 为影像底图（不含路网，不含注记）

http://wprd0{1-4}.is.autonavi.com/appmaptile?x={x}&y={y}&z={z}&lang=zh_cn&size=1&scl=2&style=6 为影像底图（不含路网、不含注记）

http://wprd0{1-4}.is.autonavi.com/appmaptile?x={x}&y={y}&z={z}&lang=zh_cn&size=1&scl=1&style=8 为影像路图（含路网，含注记）

http://wprd0{1-4}.is.autonavi.com/appmaptile?x={x}&y={y}&z={z}&lang=zh_cn&size=1&scl=2&style=8 为影像路网（含路网，不含注记）

#### 高德地图旧版参数参数：

高德旧版可以通过style参数设置影像、矢量、路网。

总结之：

http://webst0{1-4}.is.autonavi.com/appmaptile?style=6&x={x}&y={y}&z={z} 为影像底图（不含路网，不含注记）

http://webst0{1-4}.is.autonavi.com/appmaptile?style=7&x={x}&y={y}&z={z} 为矢量地图（含路网，含注记）

http://webst0{1-4}.is.autonavi.com/appmaptile?style=8&x={x}&y={y}&z={z} 为影像路网（含路网，含注记）

## xyz加载天地图

地图瓦片获取：

http://t0.tianditu.gov.cn/img_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=img&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TILEMATRIX={z}&TILEROW={x}&TILECOL={y}&tk=您的密钥

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

## xyz加载谷歌地图

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

## XYZ加载OpenStreetMap

'http://{a-c}.tile.openstreetmap.org/{z}/{x}/{y}.png'

## XYZ加载雅虎地图

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
| 百度地图      | 百度XYZ  | 交通 | `http://its.map.baidu.com:8002/traffic/TrafficTileService?level=19&x=99052&y=20189&time=1373790856265&label=web2D&;v=017` |

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



摘录文章：

瓦片地图原理 https://segmentfault.com/a/1190000011276788?utm_source=tag-newest

天地图OGC WMTS服务规则 https://www.cnblogs.com/nodegis/p/10233259.html 

谷歌地图OGC WMTS服务规则 https://www.cnblogs.com/nodegis/p/10233235.html

从一篇知乎问答引发的Web地图探索 https://blog.csdn.net/ahence/article/details/50685959

https://www.zhihu.com/question/20101688/answer/13984912

https://www.zhihu.com/question/27706485/answer/119031993

https://www.zhihu.com/question/21530085/answer/18728706

https://www.zhihu.com/question/25399692/answer/294111240