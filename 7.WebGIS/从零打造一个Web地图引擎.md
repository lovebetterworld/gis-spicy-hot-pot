- [从零打造一个Web地图引擎](https://blog.51cto.com/u_15319948/4944408)

说到地图，大家一定很熟悉，平时应该都使用过百度地图、高德地图、腾讯地图等，如果涉及到地图相关的开发需求，也有很多选择，比如前面的几个地图都会提供一套`js API`，此外也有一些开源地图框架可以使用，比如`OpenLayers`、`Leaflet`等。

那么大家有没有想过这些地图是怎么渲染出来的呢，为什么根据一个经纬度就能显示对应的地图呢，不知道没关系，本文会带各位从零实现一个简单的地图引擎，来帮助大家了解`GIS`基础知识及`Web`地图的实现原理。

## 选个经纬度

首先我们去高德地图上选个经纬度，作为我们后期的地图中心点，打开[高德坐标拾取](https://lbs.amap.com/tools/picker)工具，随便选择一个点：

![从零打造一个Web地图引擎_gis](https://s5.51cto.com/images/blog/202201/18223210_61e6cf6a868af57660.png?x-oss-process=image/watermark,size_14,text_QDUxQ1RP5Y2a5a6i,color_FFFFFF,t_100,g_se,x_10,y_10,shadow_20,type_ZmFuZ3poZW5naGVpdGk=)

笔者选择了杭州的雷峰塔，经纬度为：`[120.148732,30.231006]`。

## 瓦片url分析

地图瓦片我们使用高德的在线瓦片，地址如下：

```
https://webrd0{1-4}.is.autonavi.com/appmaptile?x={x}&y={y}&z={z}&lang=zh_cn&size=1&scale=1&style=8
```

目前各大地图厂商的瓦片服务遵循的规则是有不同的：

> 谷歌XYZ规范：谷歌地图、OpenStreetMap、高德地图、geoq、天地图，坐标原点在左上角
>
> TMS规范：腾讯地图，坐标原点在左下角
>
> WMTS规范：原点在左上角，瓦片不是正方形，而是矩形，这个应该是官方标准
>
> 百度地图比较特立独行，投影、分辨率、坐标系都跟其他厂商不一样，原点在经纬度都为0的位置，也就是中间，向右为X正方向，向上为Y正方向

谷歌和`TMS`的瓦片区别可以通过该地址可视化的查看：[地图瓦片](https://www.maptiler.com/google-maps-coordinates-tile-bounds-projection/#1/25.12/-0.61)。 虽然规范不同，但原理基本是一致的，都是把地球投影成一个巨大的正方形世界平面图，然后按照四叉树进行分层切割，比如第一层，只有一张瓦片，显示整个世界的信息，所以基本只能看到洲和海的名称和边界线，第二层，切割成四张瓦片，显示信息稍微多了一点，以此类推，就像一个金字塔一样，底层分辨率最高，显示的细节最多，瓦片数也最多，顶层分辨率最低，显示的信息很少，瓦片数量相对也最少：

![从零打造一个Web地图引擎_gis_02](https://s4.51cto.com/images/blog/202201/18223210_61e6cf6abf0c598289.png?x-oss-process=image/watermark,size_14,text_QDUxQ1RP5Y2a5a6i,color_FFFFFF,t_100,g_se,x_10,y_10,shadow_20,type_ZmFuZ3poZW5naGVpdGk=)

每一层的瓦片数量计算公式：

```
Math.pow(Math.pow(2, n), 2)// 行*列：2^n * 2^n
```

十八层就需要`68719476736`张瓦片，所以一套地图瓦片整体数量是非常庞大的。

瓦片切好以后，通过行列号和缩放层级来保存，所以可以看到瓦片地址中有三个变量：`x`、`y`、`z`

```
x：行号
y：列号
z：分辨率，一般为0-18
```

通过这三个变量就可以定位到一张瓦片，比如下面这个地址，行号为`109280`，列号为`53979`，缩放层级为`17`：

```
https://webrd01.is.autonavi.com/appmaptile?x=109280&y=53979&z=17&lang=zh_cn&size=1&scale=1&style=8
```

对应的瓦片为：

![从零打造一个Web地图引擎_web地图_03](https://s6.51cto.com/images/blog/202201/18223210_61e6cf6aa887c53088.png?x-oss-process=image/watermark,size_14,text_QDUxQ1RP5Y2a5a6i,color_FFFFFF,t_100,g_se,x_10,y_10,shadow_20,type_ZmFuZ3poZW5naGVpdGk=)

关于瓦片的更多信息可以阅读[瓦片地图原理](https://segmentfault.com/a/1190000011276788)。

## 坐标系简介

高德地图使用的是`GCJ-02坐标系`，也称火星坐标系，由中国国家测绘局在02年发布，是在GPS坐标（`WGS-84`坐标系）基础上经加密后而来，也就是增加了非线性的偏移，让你摸不准真实位置，为了国家安全，国内地图服务商都需要使用`GCJ-02坐标系`。

`WGS-84`坐标系是国际通用的标准，`EPSG`编号为`EPSG:4326`，通常GPS设备获取到的原始经纬度和国外的地图厂商使用的都是`WGS-84`坐标系。

这两种坐标系都是地理坐标系，球面坐标，单位为`度`，这种坐标方便在地球上定位，但是不方便展示和进行面积距离计算，我们印象中的地图都是平面的，所以就有了另外一种平面坐标系，平面坐标系是通过投影的方式从地理坐标系中转换过来，所以也称为投影坐标系，通常单位为`米`，投影坐标系根据投影方式的不同存在多种，在`Web`开发的场景里通常使用的是`Web墨卡托投影`，编号为`EPSG:3857`，它基于`墨卡托投影`，把`WGS-84`坐标系投影成正方形：

![从零打造一个Web地图引擎_gis_04](https://s4.51cto.com/images/blog/202201/18223210_61e6cf6ac257d67726.png?x-oss-process=image/watermark,size_14,text_QDUxQ1RP5Y2a5a6i,color_FFFFFF,t_100,g_se,x_10,y_10,shadow_20,type_ZmFuZ3poZW5naGVpdGk=)

这是通过舍弃了南北`85.051129纬度`以上的地区实现的，因为它是正方形，所以一个大的正方形可以很方便的被分割为更小的正方形。

坐标系更详细的信息可参考[GIS之坐标系统](https://juejin.cn/post/6924478988307922957)，`EPSG:3857`的详细信息可参考[EPSG:3857](http://epsg.io/3857)。

## 经纬度定位行列号

上一节里我们简单介绍了一下坐标系，按照`Web`地图的标准，我们的地图引擎也选择支持`EPSG:3857`投影，但是我们通过高德工具获取到的是火星坐标系的经纬度坐标，所以第一步要把经纬度坐标转换为`Web墨卡托`投影坐标，这里为了简单，先直接把火星坐标当做`WGS-84`坐标，后面再来看这个问题。 转换方法网上一搜就有：

```
// 角度转弧度
const angleToRad = (angle) => {
    return angle * (Math.PI / 180)
}

// 弧度转角度
const radToAngle = (rad) => {
    return rad * (180 / Math.PI)
}

// 地球半径
const EARTH_RAD = 6378137

// 4326转3857
const lngLat2Mercator = (lng, lat) => {
    // 经度先转弧度，然后因为 弧度 = 弧长 / 半径 ，得到弧长为 弧长 = 弧度 * 半径 
    let x = angleToRad(lng) * EARTH_RAD; 
    // 纬度先转弧度
    let rad = angleToRad(lat)
    // 下面我就看不懂了，各位随意。。。
    let sin = Math.sin(rad)
    let y = EARTH_RAD / 2 * Math.log((1 + sin) / (1 - sin))
    return [x, y]
}

// 3857转4326
const mercatorTolnglat = (x, y) => {
    let lng = radToAngle(x) / EARTH_RAD
    let lat = radToAngle((2 * Math.atan(Math.exp(y / EARTH_RAD)) - (Math.PI / 2)))
    return [lng, lat]
}
```

`3857`坐标有了，它的单位是`米`，那么怎么转换成瓦片的行列号呢，这就涉及到`分辨率`的概念了，即地图上一像素代表实际多少米，分辨率如果能从地图厂商的文档里获取是最好的，如果找不到，也可以简单计算一下（如果使用计算出来的也不行，那就只能求助搜索引擎了），我们知道地球半径是`6378137`米，`3857`坐标系把地球当做正圆球体来处理，所以可以算出地球周长，投影是贴着地球赤道的：

![从零打造一个Web地图引擎_gis_05](https://s8.51cto.com/images/blog/202201/18223210_61e6cf6ad6f1a86555.png?x-oss-process=image/watermark,size_14,text_QDUxQ1RP5Y2a5a6i,color_FFFFFF,t_100,g_se,x_10,y_10,shadow_20,type_ZmFuZ3poZW5naGVpdGk=)

所以投影成正方形的世界平面图后的边长代表的就是地球的周长，前面我们也知道了每一层级的瓦片数量的计算方式，而一张瓦片的大小一般是`256*256`像素，所以用地球周长除以展开后的世界平面图的边长就知道了地图上每像素代表实际多少米：

```
// 地球周长
const EARTH_PERIMETER = 2 * Math.PI * EARTH_RAD
// 瓦片像素
const TILE_SIZE = 256

// 获取某一层级下的分辨率
const getResolution = (n) => {
    const tileNums = Math.pow(2, n)
    const tileTotalPx = tileNums * TILE_SIZE
    return EARTH_PERIMETER / tileTotalPx
}
```

地球周长算出来是`40075016.68557849`，可以看到`OpenLayers`就是这么计算的：

![从零打造一个Web地图引擎_web地图_06](https://s5.51cto.com/images/blog/202201/18223210_61e6cf6af054365114.png?x-oss-process=image/watermark,size_14,text_QDUxQ1RP5Y2a5a6i,color_FFFFFF,t_100,g_se,x_10,y_10,shadow_20,type_ZmFuZ3poZW5naGVpdGk=)

`3857`坐标的单位是`米`，那么把坐标除以分辨率就可以得到对应的像素坐标，再除以`256`，就可以得到瓦片的行列号：

![从零打造一个Web地图引擎_gis_07](https://s4.51cto.com/images/blog/202201/18223211_61e6cf6b8fc2270659.png?x-oss-process=image/watermark,size_14,text_QDUxQ1RP5Y2a5a6i,color_FFFFFF,t_100,g_se,x_10,y_10,shadow_20,type_ZmFuZ3poZW5naGVpdGk=)

函数如下：

```
// 根据3857坐标及缩放层级计算瓦片行列号
const getTileRowAndCol = (x, y, z) => {
    let resolution = getResolution(z)
    let row = Math.floor(x / resolution / TILE_SIZE)
    let col = Math.floor(y / resolution / TILE_SIZE)
    return [row, col]
}
```

接下来我们把层级固定为`17`，那么分辨率`resolution`就是`1.194328566955879`，雷峰塔的经纬度转成`3857`的坐标为：`[13374895.665697495, 3533278.205310311]`，使用上面的函数计算出来行列号为：`[43744, 11556]`，我们把这几个数据代入瓦片的地址里进行访问：

```
https://webrd01.is.autonavi.com/appmaptile?x=43744&y=11556&z=17&lang=zh_cn&size=1&scale=1&style=8
```

![从零打造一个Web地图引擎_web地图_08](https://s5.51cto.com/images/blog/202201/18223211_61e6cf6b8d0e432688.png?x-oss-process=image/watermark,size_14,text_QDUxQ1RP5Y2a5a6i,color_FFFFFF,t_100,g_se,x_10,y_10,shadow_20,type_ZmFuZ3poZW5naGVpdGk=)

一片空白，这是为啥呢，其实是因为原点不一样，`4326`和`3857`坐标系的原点在赤道和本初子午线相交点，非洲边上的海里，而瓦片的原点在左上角：

![从零打造一个Web地图引擎_gis_09](https://s3.51cto.com/images/blog/202201/18223212_61e6cf6c6420759710.png?x-oss-process=image/watermark,size_14,text_QDUxQ1RP5Y2a5a6i,color_FFFFFF,t_100,g_se,x_10,y_10,shadow_20,type_ZmFuZ3poZW5naGVpdGk=)

再来看下图会更容易理解：

![从零打造一个Web地图引擎_gis_10](https://s6.51cto.com/images/blog/202201/18223213_61e6cf6dcedf286734.png?x-oss-process=image/watermark,size_14,text_QDUxQ1RP5Y2a5a6i,color_FFFFFF,t_100,g_se,x_10,y_10,shadow_20,type_ZmFuZ3poZW5naGVpdGk=)

`3857`坐标系的原点相当于在世界平面图的中间，向右为`x`轴正方向，向上为`y`轴正方向，而瓦片地图的原点在左上角，所以我们需要根据图上【绿色虚线】的距离计算出【橙色实线】的距离，这也很简单，水平坐标就是水平绿色虚线的长度加上世界平面图的一半，垂直坐标就是世界平面图的一半减去垂直绿色虚线的长度，世界平面图的一半也就是地球周长的一半，修改`getTileRowAndCol`函数：

```
const getTileRowAndCol = (x, y, z) => {
  x += EARTH_PERIMETER / 2     // ++
  y = EARTH_PERIMETER / 2 - y  // ++
  let resolution = getResolution(z)
  let row = Math.floor(x / resolution / TILE_SIZE)
  let col = Math.floor(y / resolution / TILE_SIZE)
  return [row, col]
}
```

这次计算出来的瓦片行列号为`[109280, 53979]`，代入瓦片地址：

```
https://webrd01.is.autonavi.com/appmaptile?x=109280&y=53979&z=17&lang=zh_cn&size=1&scale=1&style=8
```

结果如下：

![从零打造一个Web地图引擎_gis_11](https://s6.51cto.com/images/blog/202201/18223212_61e6cf6c651a060202.png?x-oss-process=image/watermark,size_14,text_QDUxQ1RP5Y2a5a6i,color_FFFFFF,t_100,g_se,x_10,y_10,shadow_20,type_ZmFuZ3poZW5naGVpdGk=)

可以看到雷峰塔出来了。

## 瓦片显示位置计算

我们现在能根据一个经纬度找到对应的瓦片，但是这还不够，我们的目标是要能在浏览器上显示出来，这就需要解决两个问题，一个是加载多少块瓦片，二是计算每一块瓦片的显示位置。 渲染瓦片我们使用`canvas`画布，模板如下：

```
<template>
  <div class=undefinedmapundefined ref=undefinedmapundefined>
    <canvas ref=undefinedcanvasundefined></canvas>
  </div>
</template>
```

地图画布容器`map`的大小我们很容易获取：

```
// 容器大小
let { width, height } = this.$refs.map.getBoundingClientRect()
this.width = width
this.height = height
// 设置画布大小
let canvas = this.$refs.canvas
canvas.width = width
canvas.height = height
// 获取绘图上下文
this.ctx = canvas.getContext('2d')
```

地图中心点我们设在画布中间，另外中心点的经纬度`center`和缩放层级`zoom`因为都是我们自己设定的，所以也是已知的，那么我们可以计算出中心坐标对应的瓦片：

```
// 中心点对应的瓦片
let centerTile = getTileRowAndCol(
    ...lngLat2Mercator(...this.center),// 4326转3857
    this.zoom// 缩放层级
)
```

缩放层级还是设为`17`，中心点还是使用雷峰塔的经纬度，那么对应的瓦片行列号前面我们已经计算过了，为`[109280, 53979]`。 中心坐标对应的瓦片行列号知道了，那么该瓦片左上角在世界平面图中的像素位置我们也就知道了：

```
// 中心瓦片左上角对应的像素坐标
let centerTilePos = [centerTile[0] * TILE_SIZE, centerTile[1] * TILE_SIZE]
```

计算出来为`[27975680, 13818624]`。这个坐标怎么转换到屏幕上呢，请看下图：

![从零打造一个Web地图引擎_gis_12](https://s9.51cto.com/images/blog/202201/18223212_61e6cf6c4ba9e57507.png?x-oss-process=image/watermark,size_14,text_QDUxQ1RP5Y2a5a6i,color_FFFFFF,t_100,g_se,x_10,y_10,shadow_20,type_ZmFuZ3poZW5naGVpdGk=)

中心经纬度的瓦片我们计算出来了，瓦片左上角的像素坐标也知道了，然后我们再计算出中心经纬度本身对应的像素坐标，那么和瓦片左上角的差值就可以计算出来，最后我们把画布的原点移动到画布中间（画布默认原点为左上角，x轴正方向向右，y轴正方向向下），也就是把中心经纬度作为坐标原点，那么中心瓦片的显示位置就是这个差值。 补充一下将经纬度转换成像素的方法：

```
// 计算4326经纬度对应的像素坐标
const getPxFromLngLat = (lng, lat, z) => {
  let [_x, _y] = lngLat2Mercator(lng, lat)// 4326转3857
  // 转成世界平面图的坐标
  _x += EARTH_PERIMETER / 2
  _y = EARTH_PERIMETER / 2 - _y
  let resolution = resolutions[z]// 该层级的分辨率
  // 米/分辨率得到像素
  let x = Math.floor(_x / resolution)
  let y = Math.floor(_y / resolution)
  return [x, y]
}
```

计算中心经纬度对应的像素坐标：

```
// 中心点对应的像素坐标
let centerPos = getPxFromLngLat(...this.center, this.zoom)
```

计算差值：

```
// 中心像素坐标距中心瓦片左上角的差值
let offset = [
    centerPos[0] - centerTilePos[0],
    centerPos[1] - centerTilePos[1]
]
```

最后通过`canvas`来把中心瓦片渲染出来：

```
// 移动画布原点到画布中间
this.ctx.translate(this.width / 2, this.height / 2)
// 加载瓦片图片
let img = new Image()
// 拼接瓦片地址
img.src = getTileUrl(...centerTile, this.zoom)
img.onload = () => {
    // 渲染到canvas
    this.ctx.drawImage(img, -offset[0], -offset[1])
}
```

这里先来看看`getTileUrl`方法的实现：

```
// 拼接瓦片地址
const getTileUrl = (x, y, z) => {
  let domainIndexList = [1, 2, 3, 4]
  let domainIndex =
    domainIndexList[Math.floor(Math.random() * domainIndexList.length)]
  return `https://webrd0${domainIndex}.is.autonavi.com/appmaptile?x=${x}&y=${y}&z=${z}&lang=zh_cn&size=1&scale=1&style=8`
}
```

这里随机了四个子域：`webrd01`、`webrd02`、`webrd03`、`webrd04`，这是因为浏览器对于同一域名同时请求的资源是有数量限制的，而当地图层级变大后需要加载的瓦片数量会比较多，那么均匀分散到各个子域下去请求可以更快的渲染出所有瓦片，减少排队等待时间，基本所有地图厂商的瓦片服务地址都支持多个子域。 为了方便看到中心点的位置，我们再额外渲染两条中心辅助线，效果如下：

![从零打造一个Web地图引擎_web地图_13](https://s4.51cto.com/images/blog/202201/18223212_61e6cf6c6561675380.png?x-oss-process=image/watermark,size_14,text_QDUxQ1RP5Y2a5a6i,color_FFFFFF,t_100,g_se,x_10,y_10,shadow_20,type_ZmFuZ3poZW5naGVpdGk=)

可以看到中心点确实是雷峰塔，当然这只是渲染了中心瓦片，我们要的是瓦片铺满整个画布，对于其他瓦片我们都可以根据中心瓦片计算出来，比如中心瓦片左边的一块，它的计算如下：

```
// 瓦片行列号，行号减1，列号不变
let leftTile = [centerTile[0] - 1, centerTile[1]]
// 瓦片显示坐标，x轴减去一个瓦片的大小，y轴不变
let leftTilePos = [
    offset[0] - TILE_SIZE * 1,
    offset[1]
]
```

所以我们只要计算出中心瓦片四个方向各需要几块瓦片，然后用一个双重循环即可计算出画布需要的所有瓦片，计算需要的瓦片数量很简单，请看下图：

![从零打造一个Web地图引擎_gis_14](https://s4.51cto.com/images/blog/202201/18223213_61e6cf6dc2a5591999.png?x-oss-process=image/watermark,size_14,text_QDUxQ1RP5Y2a5a6i,color_FFFFFF,t_100,g_se,x_10,y_10,shadow_20,type_ZmFuZ3poZW5naGVpdGk=)

画布宽高的一半减去中心瓦片占据的空间即可得到该方向剩余的空间，然后除以瓦片的尺寸就知道需要几块瓦片了：

```
// 计算瓦片数量
let rowMinNum = Math.ceil((this.width / 2 - offset[0]) / TILE_SIZE)// 左
let colMinNum = Math.ceil((this.height / 2 - offset[1]) / TILE_SIZE)// 上
let rowMaxNum = Math.ceil((this.width / 2 - (TILE_SIZE - offset[0])) / TILE_SIZE)// 右
let colMaxNum = Math.ceil((this.height / 2 - (TILE_SIZE - offset[1])) / TILE_SIZE)// 下
```

我们把中心瓦片作为原点，坐标为`[0, 0]`，来个双重循环扫描一遍即可渲染出所有瓦片：

```
// 从上到下，从左到右，加载瓦片
for (let i = -rowMinNum; i <= rowMaxNum; i++) {
    for (let j = -colMinNum; j <= colMaxNum; j++) {
        // 加载瓦片图片
        let img = new Image()
        img.src = getTileUrl(
            centerTile[0] + i,// 行号
            centerTile[1] + j,// 列号
            this.zoom
        )
        img.onload = () => {
            // 渲染到canvas
            this.ctx.drawImage(
                img, 
                i * TILE_SIZE - offset[0], 
                j * TILE_SIZE - offset[1]
            )
        }
    }
}
```

效果如下：

![从零打造一个Web地图引擎_gis_15](https://s9.51cto.com/images/blog/202201/18223214_61e6cf6e308db94589.png?x-oss-process=image/watermark,size_14,text_QDUxQ1RP5Y2a5a6i,color_FFFFFF,t_100,g_se,x_10,y_10,shadow_20,type_ZmFuZ3poZW5naGVpdGk=)

很完美。

## 拖动

拖动可以这么考虑，前面已经实现了渲染指定经纬度的瓦片，当我们按住进行拖动时，可以知道鼠标滑动的距离，然后把该距离，也就是像素转换成经纬度的数值，最后我们再更新当前中心点的经纬度，并清空画布，调用之前的方法重新渲染，不停重绘造成是在移动的视觉假象。 监听鼠标相关事件：

```
<canvas ref=undefinedcanvasundefined @mousedown=undefinedonMousedownundefined></canvas>
export default {
    data(){
        return {
            isMousedown: false
        }
    },
    mounted() {
        window.addEventListener(undefinedmousemoveundefined, this.onMousemove);
        window.addEventListener(undefinedmouseupundefined, this.onMouseup);
    },
    methods: {
        // 鼠标按下
        onMousedown(e) {
            if (e.which === 1) {
                this.isMousedown = true;
            }
        },

        // 鼠标移动
        onMousemove(e) {
            if (!this.isMousedown) {
                return;
            }
            // ...
        },

        // 鼠标松开
        onMouseup() {
            this.isMousedown = false;
        }
    }
}
```

在`onMousemove`方法里计算拖动后的中心经纬度及重新渲染画布：

```
// 计算本次拖动的距离对应的经纬度数据
let mx = e.movementX * resolutions[this.zoom];
let my = e.movementY * resolutions[this.zoom];
// 把当前中心点经纬度转成3857坐标
let [x, y] = lngLat2Mercator(...this.center);
// 更新拖动后的中心点经纬度
center = mercatorToLngLat(x - mx, my + y);
```

`movementX`和`movementY`属性能获取本次和上一次鼠标事件中的移动值，兼容性不是很好，不过自己计算该值也很简单，详细请移步[MDN](https://developer.mozilla.org/zh-CN/docs/Web/API/MouseEvent/movementX)。乘以当前分辨率把`像素`换算成`米`，然后把当前中心点经纬度也转成`3857`的`米`坐标，偏移本次移动的距离，最后再转回`4326`的经纬度坐标作为更新后的中心点即可。

为什么`x`是减，`y`是加呢，很简单，我们鼠标向右和向下移动时距离是正的，相应的地图会向右或向下移动，`4326`坐标系向右和向上为正方向，那么地图向右移动时，中心点显然是相对来说是向左移了，因为向右为正方向，所以中心点经度方向就是减少了，所以是减去移动的距离，而地图向下移动，中心点相对来说是向上移了，因为向上为正方向，所以中心点纬度方向就是增加了，所以加上移动的距离。 更新完中心经纬度，然后清空画布重新绘制：

```
// 清空画布
this.clear();
// 重新绘制，renderTiles方法就是上一节的代码逻辑封装
this.renderTiles();
```

效果如下：

![从零打造一个Web地图引擎_gis_16](https://s3.51cto.com/images/blog/202201/18223214_61e6cf6e3b1c651085.gif?x-oss-process=image/watermark,size_14,text_QDUxQ1RP5Y2a5a6i,color_FFFFFF,t_100,g_se,x_10,y_10,shadow_20,type_ZmFuZ3poZW5naGVpdGk=)

可以看到已经凌乱了，这是为啥呢，其实是因为图片加载是一个异步的过程，我们鼠标移动过程中，会不断的计算出要加载的瓦片进行加载，但是可能上一批瓦片还没加载完成，鼠标已经移动到新的位置了，又计算出一批新的瓦片进行加载，此时上一批瓦片可能加载完成并渲染出来了，但是这些瓦片有些可能已经被移除画布，不需要显示，有些可能还在画布内，但是使用的还是之前的位置，渲染出来也是不对的，同时新的一批瓦片可能也加载完成并渲染出来，自然导致了最终显示的错乱。 知道原因就简单了，首先我们加个缓存对象，因为在拖动过程中，很多瓦片只是位置变了，不需要重新加载，同一个瓦片加载一次，后续只更新它的位置即可；另外再设置一个对象来记录当前画布上应该显示的瓦片，防止不应该出现的瓦片渲染出来：

```
{
    // 缓存瓦片
    tileCache: {},
    // 记录当前画布上需要的瓦片
    currentTileCache: {}
}
```

因为需要记录瓦片的位置、加载状态等信息，我们创建一个瓦片类：

```
// 瓦片类
class Tile {
  constructor(opt = {}) {
    // 画布上下文
    this.ctx = ctx
    // 瓦片行列号
    this.row = row
    this.col = col
    // 瓦片层级
    this.zoom = zoom
    // 显示位置
    this.x = x
    this.y = y
    // 一个函数，判断某块瓦片是否应该渲染
    this.shouldRender = shouldRender
    // 瓦片url
    this.url = ''
    // 缓存key
    this.cacheKey = this.row + '_' + this.col + '_' + this.zoom
    // 图片
    this.img = null
    // 图片是否加载完成
    this.loaded = false

    this.createUrl()
    this.load()
  }
    
  // 生成url
  createUrl() {
    this.url = getTileUrl(this.row, this.col, this.zoom)
  }

  // 加载图片
  load() {
    this.img = new Image()
    this.img.src = this.url
    this.img.onload = () => {
      this.loaded = true
      this.render()
    }
  }

  // 将图片渲染到canvas上
  render() {
    if (!this.loaded || !this.shouldRender(this.cacheKey)) {
      return
    }
    this.ctx.drawImage(this.img, this.x, this.y)
  }
    
  // 更新位置
  updatePos(x, y) {
    this.x = x
    this.y = y
    return this
  }
}
```

然后修改之前的双重循环渲染瓦片的逻辑：

```
this.currentTileCache = {}// 清空缓存对象
for (let i = -rowMinNum; i <= rowMaxNum; i++) {
    for (let j = -colMinNum; j <= colMaxNum; j++) {
        // 当前瓦片的行列号
        let row = centerTile[0] + i
        let col = centerTile[1] + j
        // 当前瓦片的显示位置
        let x = i * TILE_SIZE - offset[0]
        let y = j * TILE_SIZE - offset[1]
        // 缓存key
        let cacheKey = row + '_' + col + '_' + this.zoom
        // 记录画布当前需要的瓦片
        this.currentTileCache[cacheKey] = true
        // 该瓦片已加载过
        if (this.tileCache[cacheKey]) {
            // 更新到当前位置
            this.tileCache[cacheKey].updatePos(x, y).render()
        } else {
            // 未加载过
            this.tileCache[cacheKey] = new Tile({
                ctx: this.ctx,
                row,
                col,
                zoom: this.zoom,
                x,
                y,
                // 判断瓦片是否在当前画布缓存对象上，是的话则代表需要渲染
                shouldRender: (key) => {
                    return this.currentTileCache[key]
                },
            })
        }
    }
}
```

效果如下：

![从零打造一个Web地图引擎_web地图_17](https://s8.51cto.com/images/blog/202201/18223215_61e6cf6fa5c0492376.gif?x-oss-process=image/watermark,size_14,text_QDUxQ1RP5Y2a5a6i,color_FFFFFF,t_100,g_se,x_10,y_10,shadow_20,type_ZmFuZ3poZW5naGVpdGk=)

可以看到，拖动已经正常了，当然，上述实现还是很粗糙的，需要优化的地方很多，比如： 1.一般会先排个序，优先加载中心瓦片 2.缓存的瓦片越来越多肯定也会影响性能，所以还需要一些清除策略 这些问题有兴趣的可以自行思考。

## 缩放

拖动是实时更新中心点经纬度，那么缩放自然更新缩放层级就行了：

```
export default {
    data() {
        return {
            // 缩放层级范围
            minZoom: 3,
            maxZoom: 18,
            // 防抖定时器
            zoomTimer: null
        }
    },
    mounted() {
        window.addEventListener('wheel', this.onMousewheel)
    },
    methods: {
        // 鼠标滚动
        onMousewheel(e) {
            if (e.deltaY > 0) {
                // 层级变小
                if (this.zoom > this.minZoom) this.zoom--
            } else {
                // 层级变大
                if (this.zoom < this.maxZoom) this.zoom++
            }
            // 加个防抖，防止快速滚动加载中间过程的瓦片
            this.zoomTimer = setTimeout(() => {
                this.clear()
                this.renderTiles()
            }, 300)
        }
    }
}
```

效果如下：

![从零打造一个Web地图引擎_gis_18](https://s7.51cto.com/images/blog/202201/18223214_61e6cf6e6d34c91574.gif?x-oss-process=image/watermark,size_14,text_QDUxQ1RP5Y2a5a6i,color_FFFFFF,t_100,g_se,x_10,y_10,shadow_20,type_ZmFuZ3poZW5naGVpdGk=)

功能是有了，不过效果很一般，因为我们平常使用的地图缩放都是有一个放大或缩小的过渡动画，而这个是直接空白然后重新渲染，不仔细看都不知道是放大还是缩小。 所以我们不妨加个过渡效果，当我们鼠标滚动后，先将画布放大或缩小，动画结束后再根据最终的缩放值来渲染需要的瓦片。 画布默认缩放值为`1`，放大则在此基础上乘以`2`倍，缩小则除以`2`，然后动画到目标值，动画期间设置画布的缩放值及清空画布，重新绘制画布上的已有瓦片，达到放大或缩小的视觉效果，动画结束后再调用`renderTiles`重新渲染最终缩放值需要的瓦片。

```
// 动画使用popmotion库，https://popmotion.io/
import { animate } from 'popmotion'

export default {
    data() {
        return {
            lastZoom: 0,
            scale: 1,
            scaleTmp: 1,
            playback: null,
        }
    },
    methods: {
        // 鼠标滚动
        onMousewheel(e) {
            if (e.deltaY > 0) {
                // 层级变小
                if (this.zoom > this.minZoom) this.zoom--
            } else {
                // 层级变大
                if (this.zoom < this.maxZoom) this.zoom++
            }
            // 层级未发生改变
            if (this.lastZoom === this.zoom) {
                return
            }
            this.lastZoom = this.zoom
            // 更新缩放比例，也就是目标缩放值
            this.scale *= e.deltaY > 0 ? 0.5 : 2
            // 停止上一次动画
            if (this.playback) {
                this.playback.stop()
            }
            // 开启动画
            this.playback = animate({
                from: this.scaleTmp,// 当前缩放值
                to: this.scale,// 目标缩放值
                onUpdate: (latest) => {
                    // 实时更新当前缩放值
                    this.scaleTmp = latest
                    // 保存画布之前状态，原因有二：
                    // 1.scale方法是会在之前的状态上叠加的，比如初始是1，第一次执行scale(2,2)，第二次执行scale(3,3)，最终缩放值不是3，而是6，所以每次缩放完就恢复状态，那么就相当于每次都是从初始值1开始缩放，效果就对了
                    // 2.保证缩放效果只对重新渲染已有瓦片生效，不会对最后的renderTiles()造成影响
                    this.ctx.save()
                    this.clear()
                    this.ctx.scale(latest, latest)
                    // 刷新当前画布上的瓦片
                    Object.keys(this.currentTileCache).forEach((tile) => {
                        this.tileCache[tile].render()
                    })
                    // 恢复到画布之前状态
                    this.ctx.restore()
                },
                onComplete: () => {
                    // 动画完成后将缩放值重置为1
                    this.scale = 1
                    this.scaleTmp = 1
                    // 根据最终缩放值重新计算需要的瓦片并渲染
                    this.renderTiles()
                },
            })
        }
    }
}
```

效果如下：

![从零打造一个Web地图引擎_web地图_19](https://s7.51cto.com/images/blog/202201/18223218_61e6cf7200da017103.gif?x-oss-process=image/watermark,size_14,text_QDUxQ1RP5Y2a5a6i,color_FFFFFF,t_100,g_se,x_10,y_10,shadow_20,type_ZmFuZ3poZW5naGVpdGk=)

虽然效果还是一般，不过至少能看出来是在放大还是缩小。

## 坐标系转换

前面还遗留了一个小问题，即我们把高德工具上选出的经纬度直接当做`4326`经纬度，前面也讲过，它们之间是存在偏移的，比如手机`GPS`获取到的经纬度一般都是`84`坐标，直接在高德地图显示，会发现和你实际位置不一样，所以就需要进行一个转换，有一些工具可以帮你做些事情，比如[Gcoord](https://github.com/hujiulong/gcoord)、[coordtransform](https://github.com/wandergis/coordtransform)等。

## 总结

上述效果看着比较一般，其实只要在上面的基础上稍微加一点瓦片的淡出动画，效果就会好很多，目前一般都是使用`canvas`来渲染`2D`地图，如果自己实现动画不太方便，也有一些强大的`canvas`库可以选择，笔者最后使用[Konva.js](https://konvajs.org/)库重做了一版，加入了瓦片淡出动画，最终效果如下：

![从零打造一个Web地图引擎_web地图_20](https://s5.51cto.com/images/blog/202201/18223216_61e6cf70be66272966.gif?x-oss-process=image/watermark,size_14,text_QDUxQ1RP5Y2a5a6i,color_FFFFFF,t_100,g_se,x_10,y_10,shadow_20,type_ZmFuZ3poZW5naGVpdGk=)

另外只要搞清楚各个地图的瓦片规则，就能稍加修改支持更多的地图瓦片：

![从零打造一个Web地图引擎_gis_21](https://s5.51cto.com/images/blog/202201/18223217_61e6cf712d4b312946.gif?x-oss-process=image/watermark,size_14,text_QDUxQ1RP5Y2a5a6i,color_FFFFFF,t_100,g_se,x_10,y_10,shadow_20,type_ZmFuZ3poZW5naGVpdGk=)

具体实现限于篇幅不再展开，有兴趣的可以阅读本文源码。 本文详细的介绍了一个简单的`web`地图开发过程，上述实现原理仅是笔者的个人思路，不代表`openlayers`等框架的原理，因为笔者也是`GIS`的初学者，所以难免会有问题，或更好的实现，欢迎指出。

在线`demo`：[https://wanglin2.github.io/web_map_demo/](https://wanglin2.github.io/web_map_demo/)

完整源码：[https://github.com/wanglin2/web_map_demo](https://github.com/wanglin2/web_map_demo)