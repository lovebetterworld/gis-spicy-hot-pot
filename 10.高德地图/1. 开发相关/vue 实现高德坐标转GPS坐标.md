- [欢迎 (cnblogs.com)](https://www.cnblogs.com/wjw1014/p/16168808.html)

# vue 实现高德坐标转GPS坐标

首先介绍一下常见的几种地图的坐标类型：

1. **WGS-84**：这是一个国际标准，也就是GPS坐标（Google Earth、或者GPS模块采集的都是这个类型）。
2. **GCJ-02**：中国坐标偏移标准，像是Google Map、高德、腾讯地图都是采用这种坐标展示。
3. **BD-09**：百度坐标偏移标准，百度地图专用的便宜标准。

所以说这篇博文主要是实现GCJ-02坐标转换成WGS-84坐标。

什么时候会用到需要解决坐标转换的问题呢？起因是一个demo，它使用GPS模块采集经纬度数据，然后使用高德地图进行转换，是的，高德地图官方提供了API，实现了GPS坐标转换到高德坐标进行展示，也就是WGS-84转GCJ-02高德官方已经支持了，看下面。

高德坐标转换地址（[点这里](https://lbs.amap.com/demo/list/jsapi-v2)）
[![img](https://img-blog.csdnimg.cn/d3bb8bd4fc9d4029a56108352c30b00c.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5rWp6ZOW,size_20,color_FFFFFF,t_70,g_se,x_16)](https://img-blog.csdnimg.cn/d3bb8bd4fc9d4029a56108352c30b00c.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5rWp6ZOW,size_20,color_FFFFFF,t_70,g_se,x_16)
通过高德官方提供的两个案例可以实现GPS坐标转换/批量转换成高德坐标展示，但是这种API接口是有访问次数限制的，当日访问次数超限额，是会被禁止访问转换的，所以说如果转换的坐标过多，尽量使用批量，不要一个一个的转换浪费次数。

但是比如说这样一个功能，我需要根据当前地图可视化范围，获取当前可视化范围的点，这样可能会出现问题，因为查询的点是GPS坐标，但是传给后台的可视化范围是高德坐标，两个坐标不统一，就会出现坐标偏差，效果就不是特别的好。

因此，就需要将可视化范围的东北角坐标和西南角坐标转换成GPS坐标在传给后台过滤，这样的话，可以将误差缩到最小。

这种转换的代码在网上很多，各式各样的都存在，但是有的效果不是特别的好，然后我找了一个测试了一下，感觉效果还是可以的，起码我能接受，需要的话看一下最后的效果图，如果接受的话，可以用起来。

首先有一个封装好的js文件，里面的代码就是下面的代码。

```javascript
/**
 * 高德地图坐标转GPS坐标算法
 */

//定义一些常量
const PI = 3.1415926535897932384626;
const a = 6378245.0;  //长半轴
const ee = 0.00669342162296594323; //扁率

/**
 * GCJ02 转换为 WGS84
 * @param lng
 * @param lat
 * @returns {*[]}
 */
function gcj02towgs84(lng, lat) {
  lat = +lat
  lng = +lng
  if (out_of_china(lng, lat)) {
    return [lng, lat]
  } else {
    let dlat = transformlat(lng - 105.0, lat - 35.0)
    let dlng = transformlng(lng - 105.0, lat - 35.0)
    let radlat = lat / 180.0 * PI
    let magic = Math.sin(radlat)
    magic = 1 - ee * magic * magic
    let sqrtmagic = Math.sqrt(magic)
    dlat = (dlat * 180.0) / ((a * (1 - ee)) / (magic * sqrtmagic) * PI)
    dlng = (dlng * 180.0) / (a / sqrtmagic * Math.cos(radlat) * PI)
    let mglat = lat + dlat
    let mglng = lng + dlng
    return [lng * 2 - mglng, lat * 2 - mglat]
  }
}

/**
 * WGS84 转换为 GCJ02
 * @param lng
 * @param lat
 * @returns {*[]}
 */
function wgs84togcj02(lng, lat) {
  lat = +lat
  lng = +lng
  if (out_of_china(lng, lat)) {
    return [lng, lat]
  } else {
    let dlat = transformlat(lng - 105.0, lat - 35.0)
    let dlng = transformlng(lng - 105.0, lat - 35.0)
    let radlat = lat / 180.0 * PI
    let magic = Math.sin(radlat)
    magic = 1 - ee * magic * magic
    let sqrtmagic = Math.sqrt(magic)
    dlat = (dlat * 180.0) / ((a * (1 - ee)) / (magic * sqrtmagic) * PI)
    dlng = (dlng * 180.0) / (a / sqrtmagic * Math.cos(radlat) * PI)
    return [lng + dlng, lat + dlat]
  }
}

/**
 * 判断是否在国内，不在国内则不做偏移
 * @param lng
 * @param lat
 * @returns {boolean}
 */
function out_of_china(lng, lat) {
  lat = +lat
  lng = +lng
  // 纬度3.86~53.55,经度73.66~135.05
  return !(lng > 73.66 && lng < 135.05 && lat > 3.86 && lat < 53.55)
}

function transformlat(lng, lat) {
  lat = +lat
  lng = +lng
  let ret = -100.0 + 2.0 * lng + 3.0 * lat + 0.2 * lat * lat + 0.1 * lng * lat + 0.2 * Math.sqrt(Math.abs(lng))
  ret += (20.0 * Math.sin(6.0 * lng * PI) + 20.0 * Math.sin(2.0 * lng * PI)) * 2.0 / 3.0
  ret += (20.0 * Math.sin(lat * PI) + 40.0 * Math.sin(lat / 3.0 * PI)) * 2.0 / 3.0
  ret += (160.0 * Math.sin(lat / 12.0 * PI) + 320 * Math.sin(lat * PI / 30.0)) * 2.0 / 3.0
  return ret
}

function transformlng(lng, lat) {
  lat = +lat
  lng = +lng
  let ret = 300.0 + lng + 2.0 * lat + 0.1 * lng * lng + 0.1 * lng * lat + 0.1 * Math.sqrt(Math.abs(lng))
  ret += (20.0 * Math.sin(6.0 * lng * PI) + 20.0 * Math.sin(2.0 * lng * PI)) * 2.0 / 3.0
  ret += (20.0 * Math.sin(lng * PI) + 40.0 * Math.sin(lng / 3.0 * PI)) * 2.0 / 3.0
  ret += (150.0 * Math.sin(lng / 12.0 * PI) + 300.0 * Math.sin(lng / 30.0 * PI)) * 2.0 / 3.0
  return ret
}

export {
  gcj02towgs84
}
```

就这些，然后用法大概都知道，就不详细说了。

我特意转换试了一下误差，我先找了一个原始的高德坐标，然后把这个高德坐标通过上面的代码转成GPS的坐标，然后又把转成的GPS坐标再使用高德官方提供的方法转回高德坐标，我感觉前后两个高德坐标是差不多的，起码误差我能接受。

下面是来回转换的效果图。

[![img](https://img-blog.csdnimg.cn/1d93b887907e4ce7b3f97ecf88e7def6.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5rWp6ZOW,size_20,color_FFFFFF,t_70,g_se,x_16)](https://img-blog.csdnimg.cn/1d93b887907e4ce7b3f97ecf88e7def6.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5rWp6ZOW,size_20,color_FFFFFF,t_70,g_se,x_16)

然后封装的方法有 WGS84 转 GCJ02 的，也有 GCJ02 转 WGS84的，需要啥自己用。可以不用高德的，毕竟访问次数有限制，而且批量转化的坐标点多了还会出问题，毕竟是get请求嘛，加油！