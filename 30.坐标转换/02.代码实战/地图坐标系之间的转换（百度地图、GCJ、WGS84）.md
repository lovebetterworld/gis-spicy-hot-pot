- [地图坐标系之间的转换（百度地图、GCJ、WGS84） - 掘金 (juejin.cn)](https://juejin.cn/post/6990647685711659015)

# 文章参考

1. [常用的几种在线地图（天地图、百度地图、高德地图）坐标系之间的转换算法](https://link.juejin.cn?target=https%3A%2F%2Fblog.csdn.net%2Fqq_36377037%2Farticle%2Fdetails%2F86479796)

# 坐标系介绍

## 常见坐标系

### WGS84坐标系（标准的GPS坐标）

GPS，WGS-84，原始坐标体系。一般用国际标准的GPS记录仪记录下来的坐标，都是GPS的坐标。

![在这里插入图片描述](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/3c6299e0f3e543c8a3fe59096ccdf741~tplv-k3u1fbpfcp-zoom-in-crop-mark:3024:0:0:0.awebp)

**EPSG:4326 与WGS84的关系？** 在国际上，每个坐标系统都会被分配一个 EPSG 代码，`EPSG:4326 就是 WGS84 的代码`

### WGS84 Web墨卡托（平面地图）

```
EPSG:3857（WGS 84 / Pseudo-Mercator） 代号是web墨卡托的正式代号
```

![在这里插入图片描述](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/2640dfc29ca1484d9030bcec23c107c1~tplv-k3u1fbpfcp-zoom-in-crop-mark:3024:0:0:0.awebp)

### GCJ02经纬度投影（火星坐标系）

GCJ-02是由中国国家测绘局（G表示Guojia国家，C表示Cehui测绘，J表示Ju局）制订的地理信息系统的坐标系统。

GCJ-02是国测局02年发布的坐标体系。又称`“火星坐标”`

`这里的GCJ02经纬度投影，也就是在WGS84经纬度的基础之上，进行GCJ-02加偏。`加偏处理是按照特殊的算法，将真实的坐标加密成虚假的坐标，而`这个加偏并不是线性的加偏，所以各地的偏移情况都会有所不同`。

该坐标系的坐标值为经纬度格式，`单位为度`。

### GCJ02 Web 墨卡托投影

该坐标系的坐标值为Web墨卡托格式，`单位为米`。

> **国内政策的原因，国内地图会有加密要求，一般有两种情况:**
>
> 1. 一种是在 Web墨卡托的基础上经过国家标准加密的国标02坐标系，熟称“火星坐标系”；
> 2. 另一种是在国标的02坐标系下进一步进行加密，如百度地图的BD09坐标系

### BD09 经纬度投影

BD09经纬度投影属于百度坐标系，

它是在标准经纬度的基础上进行GCJ-02加偏之后，再加上百度自身的加偏算法，也就是在标准经纬度的基础之上`进行了两次加偏`。

该坐标系的坐标值为经纬度格式，`单位为度`。

## 常用坐标系区分?

1. EPSG:4326，等同于WGS84坐标系
2. CGCS2000，天地图坐标系，与GPS一样，偏移较小
3. GCJ02，火星坐标系，将GPS坐标做偏移之后的数据
4. EPSG:3857，等同于900913，由墨卡托投影而来(最初 Web Mercator 被拒绝分配EPSG 代码。于是大家普遍使用 EPSG:900913（Google的数字变形） 的非官方代码来代表它)
5. BD-09:，百度地图使用坐标系

# 地图偏移

## 为什么要地图偏移？

一言以蔽之：`为了国家安全`。可以想象，如果地图不加密，在百度上找到关键（军事、科研所等）目标，导弹空袭，损失不可估量

## 偏移在哪里？

设备一般是标准的GPS信息 —— 我们也很难要求外国各个厂商按照中国的要求制造GPS设备

```
中国政府加密的是地图，而非GPS 信号
```

## 地图做了偏移，为什么地图定位很精准（百度地图说明）

1. 百度地图供应商是思维图新，地图提供给百度之前，需要先提交给测绘局，测绘局对地图做偏移加密，加密地图的坐标系就变成了GCJ-02(火星坐标系)
2. 百度收到思维图新的地图之后发现，在地图上，GPS位置会偏很远
3. 百度再把地图软件拿到测绘局，请他们加入一个“保密插件”，对GPS做同样的偏移 对GPS偏移

总结：`地图偏移 和 GPS 偏移，保证了地图和GPS重合了`

# 坐标转换

## 为什么要做坐标转换

工作中，开发的项目使用的是`openlayers或者leaflet` 开源地图引擎，使用地图的业务逻辑已经写好了，为了提高业务组件的复用性，当地图切换的时候，`最好的方式就是切换地图图层，关于业务的API不要变化，那么剩下的工作就是坐标系转换即可`；

比如，要使用百度地图，使用百度的地图引擎（bmap.js），那么业务逻辑的代码就要使用百度的API来实现，等于重新开发了一次，降低了效率，不利于代码复用

让地图提供 WMTS 服务，就可以实现只换图层，不换API 的要求

## 地图服务（后台地图引擎可提供的能力）

### TMS——Tile Map Service 即TMS，切片地图服务

将地图切割成多个级别的图片金字塔（四叉树形式分割）， ![在这里插入图片描述](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/68d40716a71e46ccbe52636a1b58d1fb~tplv-k3u1fbpfcp-zoom-in-crop-mark:3024:0:0:0.awebp) 它通常需要一种遵循REST原则的URI结构去标识每一张切片。

- TMS是纯RESTful的；
- TMS瓦片是正方形

### WMTS——Web Map Tile Service即WMTS，网络地图切片服务，

它是一种在互联网上预渲染或进行实时地图瓦片计算的服务。

例如，在浏览器中输入 [maponline0.bdimg.com/tile/?qt=vt…](https://link.juejin.cn?target=https%3A%2F%2Fmaponline0.bdimg.com%2Ftile%2F%3Fqt%3Dvtile%26x%3D1579%26y%3D589%26z%3D13%26styles%3Dpl%26scaler%3D1%26udt%3D20210506%26from%3Djsapi2_0),就可以查看到图片 ![在这里插入图片描述](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/df7746f41d5d47a7994f779ac5b9e115~tplv-k3u1fbpfcp-zoom-in-crop-mark:3024:0:0:0.awebp)

WMTS可以有三种协议：KVP、SOAP、RESTful；

WMTS瓦片是矩形；

WMTS中对应的不同比例尺瓦片可以尺寸不同

另外WMTS可以获取以下信息

- 可以获取地图瓦片；
- 可以获取WMTS服务的元数据；
- 可以获取单一瓦片的FeatureInfo；
- 可以获取地图的图例；

### WMS——Web Map Service，网络地图服务

当客户端请求WMS服务时，返回给客户端是一张完整的图片，它不能让客户端知道瓦片布局，客户端取到直接展示，故WMS仅是重在灵活性。

但是复用的概率低之又低，当并发增大，服务端性能就随之大大下降。

有不同的请求类型：

- GetCapabilities：返回WMS服务的元数据和可获取的图层
- GetMap ：返回地图图片
- GetFeatureInfo ：如果图层被标记为“queryable”，就可以通过坐标请求地图图片数据
- DescribeLayer ：返回指定图层的要素类型
- GetLegendGraphic：返回地图图例图片

## 常用坐标系的转换工具（百度地图、GCJ、WGS84）

```javascript
const mapTools = (function () {
  const x_pi = (3.14159265358979324 * 3000.0) / 180.0;

  var pi = 3.14159265358979324;
  var a = 6378245.0;
  var ee = 0.00669342162296594323;

  var LLBAND = [75, 60, 45, 30, 15, 0];
  var LL2MC = [
    [
      -0.0015702102444, 111320.7020616939, 1704480524535203, -10338987376042340,
      26112667856603880, -35149669176653700, 26595700718403920,
      -10725012454188240, 1800819912950474, 82.5,
    ],
    [
      0.0008277824516172526, 111320.7020463578, 647795574.6671607,
      -4082003173.641316, 10774905663.51142, -15171875531.51559,
      12053065338.62167, -5124939663.577472, 913311935.9512032, 67.5,
    ],
    [
      0.00337398766765, 111320.7020202162, 4481351.045890365,
      -23393751.19931662, 79682215.47186455, -115964993.2797253,
      97236711.15602145, -43661946.33752821, 8477230.501135234, 52.5,
    ],
    [
      0.00220636496208, 111320.7020209128, 51751.86112841131, 3796837.749470245,
      992013.7397791013, -1221952.21711287, 1340652.697009075,
      -620943.6990984312, 144416.9293806241, 37.5,
    ],
    [
      -0.0003441963504368392, 111320.7020576856, 278.2353980772752,
      2485758.690035394, 6070.750963243378, 54821.18345352118,
      9540.606633304236, -2710.55326746645, 1405.483844121726, 22.5,
    ],
    [
      -0.0003218135878613132, 111320.7020701615, 0.00369383431289,
      823725.6402795718, 0.46104986909093, 2351.343141331292, 1.58060784298199,
      8.77738589078284, 0.37238884252424, 7.45,
    ],
  ];
  var MCBAND = [12890594.86, 8362377.87, 5591021, 3481989.83, 1678043.12, 0];
  var MC2LL = [
    [
      1.410526172116255e-8, 0.00000898305509648872, -1.9939833816331,
      200.9824383106796, -187.2403703815547, 91.6087516669843,
      -23.38765649603339, 2.57121317296198, -0.03801003308653, 17337981.2,
    ],
    [
      -7.435856389565537e-9, 0.000008983055097726239, -0.78625201886289,
      96.32687599759846, -1.85204757529826, -59.36935905485877,
      47.40033549296737, -16.50741931063887, 2.28786674699375, 10260144.86,
    ],
    [
      -3.030883460898826e-8, 0.00000898305509983578, 0.30071316287616,
      59.74293618442277, 7.357984074871, -25.38371002664745, 13.45380521110908,
      -3.29883767235584, 0.32710905363475, 6856817.37,
    ],
    [
      -1.981981304930552e-8, 0.000008983055099779535, 0.03278182852591,
      40.31678527705744, 0.65659298677277, -4.44255534477492, 0.85341911805263,
      0.12923347998204, -0.04625736007561, 4482777.06,
    ],
    [
      3.09191371068437e-9, 0.000008983055096812155, 0.00006995724062,
      23.10934304144901, -0.00023663490511, -0.6321817810242, -0.00663494467273,
      0.03430082397953, -0.00466043876332, 2555164.4,
    ],
    [
      2.890871144776878e-9, 0.000008983055095805407, -3.068298e-8,
      7.47137025468032, -0.00000353937994, -0.02145144861037, -0.00001234426596,
      0.00010322952773, -0.00000323890364, 826088.5,
    ],
  ];

  function getRange(cC, cB, T) {
    if (cB != null) {
      cC = Math.max(cC, cB);
    }
    if (T != null) {
      cC = Math.min(cC, T);
    }
    return cC;
  }
  function getLoop(cC, cB, T) {
    while (cC > T) {
      cC -= T - cB;
    }
    while (cC < cB) {
      cC += T - cB;
    }
    return cC;
  }
  function convertor(cC, cD) {
    if (!cC || !cD) {
      return null;
    }
    let T = cD[0] + cD[1] * Math.abs(cC.x);
    const cB = Math.abs(cC.y) / cD[9];
    let cE =
      cD[2] +
      cD[3] * cB +
      cD[4] * cB * cB +
      cD[5] * cB * cB * cB +
      cD[6] * cB * cB * cB * cB +
      cD[7] * cB * cB * cB * cB * cB +
      cD[8] * cB * cB * cB * cB * cB * cB;
    T *= cC.x < 0 ? -1 : 1;
    cE *= cC.y < 0 ? -1 : 1;
    return [T, cE];
  }

  /**
   * 百度墨卡托坐标转百度经纬度坐标：
   * @param {*} cB
   * @returns
   */
  function convertBdMC2LL(lnglat) {
    const cB = {
      x: lnglat.lng,
      y: lnglat.lat,
    };
    const cC = {
      x: Math.abs(cB.x),
      y: Math.abs(cB.y),
    };
    let cE;
    for (let cD = 0, len = MCBAND.length; cD < len; cD++) {
      if (cC.y >= MCBAND[cD]) {
        cE = MC2LL[cD];
        break;
      }
    }
    const T = convertor(cB, cE);
    return T;
  }

  /**
   * 百度BD09经纬度坐标转百度墨卡托坐标：
   * @param {*} T
   * @returns
   */
  function convertBdLL2MC(lnglat) {
    const T = {
      x: lnglat.lng,
      y: lnglat.lat,
    };
    let cD, cC, len;
    T.x = getLoop(T.x, -180, 180);
    T.y = getRange(T.y, -74, 74);
    const cB = T;
    for (cC = 0, len = LLBAND.length; cC < len; cC++) {
      if (cB.y >= LLBAND[cC]) {
        cD = LL2MC[cC];
        break;
      }
    }
    if (!cD) {
      for (cC = LLBAND.length - 1; cC >= 0; cC--) {
        if (cB.y <= -LLBAND[cC]) {
          cD = LL2MC[cC];
          break;
        }
      }
    }
    const cE = convertor(T, cD);
    // return cE;
    return {
      lng: cE[0],
      lat: cE[1],
    };
  }

  /*判断是否在国内，不在国内则不做偏移*/
  function outOfChina(lon, lat) {
    if ((lon < 72.004 || lon > 137.8347) && (lat < 0.8293 || lat > 55.8271)) {
      return true;
    } else {
      return false;
    }
  }
  function transformLat(x, y) {
    var ret =
      -100.0 +
      2.0 * x +
      3.0 * y +
      0.2 * y * y +
      0.1 * x * y +
      0.2 * Math.sqrt(Math.abs(x));
    ret +=
      ((20.0 * Math.sin(6.0 * x * pi) + 20.0 * Math.sin(2.0 * x * pi)) * 2.0) /
      3.0;
    ret +=
      ((20.0 * Math.sin(y * pi) + 40.0 * Math.sin((y / 3.0) * pi)) * 2.0) / 3.0;
    ret +=
      ((160.0 * Math.sin((y / 12.0) * pi) + 320 * Math.sin((y * pi) / 30.0)) *
        2.0) /
      3.0;
    return ret;
  }

  function transformLon(x, y) {
    var ret =
      300.0 +
      x +
      2.0 * y +
      0.1 * x * x +
      0.1 * x * y +
      0.1 * Math.sqrt(Math.abs(x));
    ret +=
      ((20.0 * Math.sin(6.0 * x * pi) + 20.0 * Math.sin(2.0 * x * pi)) * 2.0) /
      3.0;
    ret +=
      ((20.0 * Math.sin(x * pi) + 40.0 * Math.sin((x / 3.0) * pi)) * 2.0) / 3.0;
    ret +=
      ((150.0 * Math.sin((x / 12.0) * pi) + 300.0 * Math.sin((x / 30.0) * pi)) *
        2.0) /
      3.0;
    return ret;
  }
  function delta(lat, lon) {
    let a = 6378245.0; //  a: 卫星椭球坐标投影到平面地图坐标系的投影因子。
    let ee = 0.00669342162296594323; //  ee: 椭球的偏心率。
    let dLat = transformLat(lon - 105.0, lat - 35.0);
    let dLon = transformLon(lon - 105.0, lat - 35.0);
    let radLat = (lat / 180.0) * pi;
    let magic = Math.sin(radLat);
    magic = 1 - ee * magic * magic;
    let sqrtMagic = Math.sqrt(magic);
    dLat = (dLat * 180.0) / (((a * (1 - ee)) / (magic * sqrtMagic)) * pi);
    dLon = (dLon * 180.0) / ((a / sqrtMagic) * Math.cos(radLat) * pi);
    return {
      lat: dLat,
      lon: dLon,
    };
  }

  // 地球坐标系(WGS-84)转火星坐标系(GCJ)：
  function transformWGS2GCJ(lnglat) {
    const wgLat = lnglat.lat;
    const wgLon = lnglat.lng;
    var mars_point = {};
    if (outOfChina(wgLon, wgLat)) {
      mars_point.lat = wgLat;
      mars_point.lon = wgLon;
      return;
    }
    var dLat = transformLat(wgLon - 105.0, wgLat - 35.0);
    var dLon = transformLon(wgLon - 105.0, wgLat - 35.0);
    var radLat = (wgLat / 180.0) * pi;
    var magic = Math.sin(radLat);
    magic = 1 - ee * magic * magic;
    var sqrtMagic = Math.sqrt(magic);
    dLat = (dLat * 180.0) / (((a * (1 - ee)) / (magic * sqrtMagic)) * pi);
    dLon = (dLon * 180.0) / ((a / sqrtMagic) * Math.cos(radLat) * pi);
    mars_point.lat = wgLat + dLat;
    mars_point.lng = wgLon + dLon;
    return mars_point;
  }

  // 火星坐标系GCJ02转地球坐标系WGS84：
  function transformGCJ2WGS(lnglat) {
    const gcjLat = lnglat.lat;
    const gcjLon = lnglat.lng;
    let d = delta(gcjLat, gcjLon);
    return {
      lat: gcjLat - d.lat,
      lng: gcjLon - d.lon,
    };
  }

  /**
   * 百度坐标转火星坐标：
   * @param {*} baidu_point
   * @returns
   */
  function baiduTomars(baidu_point) {
    var mars_point = { lng: 0, lat: 0 };
    var x = baidu_point.lng - 0.0065;
    var y = baidu_point.lat - 0.006;
    var z = Math.sqrt(x * x + y * y) - 0.00002 * Math.sin(y * x_pi);
    var theta = Math.atan2(y, x) - 0.000003 * Math.cos(x * x_pi);
    mars_point.lng = z * Math.cos(theta);
    mars_point.lat = z * Math.sin(theta);
    return mars_point;
  }

  /**
   * 火星坐标转百度坐标：
   * @param {*} mars_point
   * @returns
   */
  function marsTobaidu(mars_point) {
    var baidu_point = { lng: 0, lat: 0 };
    var x = mars_point.lng;
    var y = mars_point.lat;
    var z = Math.sqrt(x * x + y * y) + 0.00002 * Math.sin(y * x_pi);
    var theta = Math.atan2(y, x) + 0.000003 * Math.cos(x * x_pi);
    baidu_point.lng = z * Math.cos(theta) + 0.0065;
    baidu_point.lat = z * Math.sin(theta) + 0.006;
    return baidu_point;
  }
  // 测试百度和火星坐标系的转换
  function testBaiduMars() {
    const lng = 116.01965;
    const lat = 40.043425;
    const lnglat = {
      lng,
      lat,
    };
    let result;
    result = mapTools.baiduTomars(lnglat);
    console.log(result); // { lng: 116.01318467451765, lat: 40.037373017166615 }
    result = mapTools.marsTobaidu(result);
    console.log(result);
  }
  // 测试火星坐标系和WGS 相互转换
  function testWGSMars() {
    const lng = 116.01965;
    const lat = 40.043425;
    const lnglat = {
      lng,
      lat,
    };
    let result;
    result = mapTools.transformWGS2GCJ(lnglat); // 地球坐标系(WGS-84)转火星坐标系(GCJ)：
    console.log(result); // { lng: 116.01318467451765, lat: 40.037373017166615 }
    result = mapTools.transformGCJ2WGS(result);
    console.log(result);
  }

  // 测试百度经纬度和墨卡托坐标的相互转换
  function testBdMC2LL() {
    const lng = 116.01965;
    const lat = 40.043425;
    const lnglat = {
      lng,
      lat,
    };
    let result;
    result = mapTools.convertBdLL2MC(lnglat); // 地球坐标系(WGS-84)转火星坐标系(GCJ)：
    console.log(result); // { lng: 116.01318467451765, lat: 40.037373017166615 }
    result = mapTools.convertBdMC2LL(result);
    console.log(result);
  }

  return {
    test: {
      testBaiduMars, // 百度经纬度和GCJ坐标系的相互转换
      testWGSMars, // WGS84 和 GCJ 坐标系的转换
      testBdMC2LL //测试百度经纬度和墨卡托坐标的相互转换
    },
    convertBdMC2LL, // 百度墨卡托坐标转百度经纬度坐标：
    convertBdLL2MC, // 百度BD09经纬度坐标转百度墨卡托坐标：
    transformWGS2GCJ, // 地球坐标系(WGS-84)转火星坐标系(GCJ)：
    transformGCJ2WGS, // 火星坐标系GCJ02转地球坐标系WGS84：
    baiduTomars, // 百度坐标转火星坐标：
    marsTobaidu, // 火星坐标转百度坐标：
  };
})();
// mapTools.test.testBaiduMars()
// mapTools.test.testWGSMars()
// mapTools.test.testBdMC2LL()

export default mapTools
```