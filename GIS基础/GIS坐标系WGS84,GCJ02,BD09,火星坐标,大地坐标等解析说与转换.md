# GIS坐标系:WGS84,GCJ02,BD09,火星坐标,大地坐标等解析说与转换

原文地址：https://www.zhoulujun.cn/html/GIS/GIS-Science/2702.html



在我朝，地理坐标转换有：WGS84转GCJ02、GCJ02转BD009、BD09转GCJ02。

# 一、WGS84大地坐标系

GPS全球定位系统使用的坐标系统，GPS设备直接返回的坐标即为WGS84。随GPS通用，能正确套到现在大部分基于这套坐标建立的卫星地图上。全球初神州外，几乎所有地图商都是使用这个坐标系，比如Google地图使用的就是WGS84坐标。

# 二、GCJ02火星坐标系

由中国国家测绘局制定的地理信息系统的坐标，国内出版的各种地图坐标系统（包括电子地图），必须至少采用GCJ02对WGS84进行首次加密。

## 2.1 为什么叫火星坐标

据说说是为了国家安全保密需要，要求全部国内地图测绘单位必须使用这套坐标系统，对GPS的坐标系统进行调整，所以会导致使用国内测绘的地理地图数据对不上使用GPS坐标测绘的地图数据，甚至是卫星地图，也就是国际版G.map的卫星图和地图对不上的原因。所以戏称火星坐标。知友的回答：https://www.zhihu.com/question/29806566/answer/136724509

## 2.2 被强制使用的火星坐标

比较鸡贼的是：**GCJ-02转WGS84的算法，居然是\**收费项目**。对于民用：地球坐标->火星坐标是不可逆的。

所有的电子地图所有的导航设备，都需要加入国家保密插件。《导航电子地图安全处理技术基本要求》。这是一个国家标准，标准号为GB 20263—2006。该标准的第4节第4.1款规定：4.1　导航电子地图在公开出版、销售、传播、展示和使用前，必须进行空间位置技术处理。

## 2.3 国内测绘公司都需要将坐标加密为火星坐标

地图公司测绘地图，测绘完成后，送到国家测绘局，将真实坐标的电子地图，加密成“火星坐标”，这样的地图才是可以出版和发布的，然后才可以让GPS公司处理。

## 2.4 所用GPS相关公司都需要用火星坐标工作

所有的GPS公司，只要需要汽车导航的，需要用到导航电子地图的，统统需要在软件中加入国家保密算法，将COM口读出来的真实的坐标信号，加密转换成国家要求的保密的坐标，这样，GPS导航仪和导航电子地图就可以完全匹配啦，GPS也就可以正常工作啦。"

# 三、国内地图坐标使用注意事项

火星坐标与地球通用坐标系WGS84，偏差一般为 300~500 米。也就是说，你手机GPS获取的坐标，直接叠加到这个“火星坐标系”的地图上，会有 300~500 米的偏差。偏移的絕對值可以參見下圖（最紅處接近 700 m，最藍處大約 20 米）：

![img](https://www.zhoulujun.cn/uploadfile/net/2019/0906/20190906170330838649507.jpg)

具体参考：

如何看待「地形图非线性保密处理技术」？ https://www.zhihu.com/question/29806566/answer/46099380

# 四、GCJ02百度坐标系

百度在火星坐标系GCJ02的基础上进行的二次加密格式。个人称为冥王星坐标系，简称冥王坐标系。

百度坐标转换官方文档：http://lbsyun.baidu.com/index.php?title=webapi/guide/changeposition 

追求准确度还是以这个方法为准。

# 五、三大坐标系转换

坐标系转换库：https://www.npmjs.com/package/coordinate-convert

```js
var coord = CoordinateConvert.wgc2gcj(116.3997, 39.9158)
```

## 5.1 经纬度转坐标geographic-coordinate-converter 

 https://www.npmjs.com/package/geographic-coordinate-converter 

```js
import { CoordinateConverter } from "coordinate-converter";
CoordinateConverter.fromDecimal([-36.01011, -2.34856])
.toDegreeMinutes() //"36º 00.607' S 002º 20.914' W"

CoordinateConverter.fromDegreeMinutes("36º 00.607' S 002º 20.914' W")
.toDegreeMinutesSeconds() //"36º 00' 36.4'' S 002º 20' 54.8'' W"

CoordinateConverter.fromDegreeMinutesSeconds("36º 00' 36.4'' S 002º 20' 54.8'' W")
.toDecimal() //"-36.01011 -2.34856"

CoordinateConverter.fromDegreeMinutes("36º 00.607' S 002º 20.914' W")
.toDecimalArray() //[-36.01012, -2.34857]
```

经纬度转坐标轻量库：https://www.npmjs.com/package/coordinates-converter

```js
const coordWithSymbols = new Coordinate('19°25\'57.3"N 99°07\'59.5"W')
const coordWithSpaces = new Coordinate('19 25 57.3 N 99 07 59.5 W')
coordWithSpaces.toGeoJson() // [-99.133194, 19.432583]
```

## 5.2 百度高德地图地图数据转GeoJSON

高德地图数据坐标点一般格式为{P,Q,lng,lat}对象。需要手工吧lng lat转为GeoJSON数组，geojson库提供了方法

```js
// 样例代码 https://lbs.amap.com/api/javascript-api/example/line/obj3d-thinline
var opts = {
  subdistrict: 1,
  extensions: 'all',
  level: 'province'
}
var district = new AMap.DistrictSearch(opts)
district.search('广东省', function (status, result) {
  console.log(JSON.stringify(result))
  var boundaries = result.districtList[0].boundaries
  console.log(JSON.stringify(boundaries))
})
// [[{"P":39.032683,"Q":118.61805600000002,"lng":118.618056,"lat":39.032683},{"P":39.032682,"Q":118.61749199999997,"lng":118.617492,"lat":39.032682},
```

https://www.npmjs.com/package/geojson 方法

```js
var GeoJSON = require('geojson')
var data = [{name: 'Location A', category: 'Store', street: 'Market', lat: 39.984, lng: -75.343}]
var data2 = { name: 'Location A', category: 'Store', street: 'Market', lat: 39.984, lng: -75.343 }

GeoJSON.parse(data, {Point: ['lat', 'lng']})
GeoJSON.parse(data2, {Point: ['lat', 'lng'], include: ['name']})
var data3 = [
  {
    x: 0.5,
    y: 102.0,
    prop0: 'value0'
  },
  {
    line: [[102.0, 0.0], [103.0, 1.0], [104.0, 0.0], [105.0, 1.0]],
    prop0: 'value0',
    prop1: 0.0
  },
  {
    polygon: [
      [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0] ]
    ],
    prop0: 'value0',
    prop1: {"this": "that"}
  }
]
GeoJSON.parse(data3, {'Point': ['x', 'y'], 'LineString': 'line', 'Polygon': 'polygon'});
```

免了手工写循环

个人的批量坐标转换库：https://www.npmjs.com/package/coordinates_convert 