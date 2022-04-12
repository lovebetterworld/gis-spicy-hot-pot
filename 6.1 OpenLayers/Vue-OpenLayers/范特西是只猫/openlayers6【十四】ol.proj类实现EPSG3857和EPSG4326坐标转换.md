- [openlayers6【十四】ol.proj类实现EPSG:3857和EPSG:4326坐标转换_范特西是只猫的博客-CSDN博客_ol/proj](https://xiehao.blog.csdn.net/article/details/107151438)

## 1. 写在前面：

`EPSG:3857即投影坐标，EPSG:4326即地理坐标。`

如果不了解什么是EPSG:3857和EPSG:4326请先看下这篇文章。[openlayers6【十】EPSG:3857和EPSG:4326区别详解](https://blog.csdn.net/qq_36410795/article/details/106429109)

`ol.proj` 类主要实现以下功能，说通俗点就是实现坐标转换的类。

- 转换为指定的坐标系坐标
- 坐标系间坐标互相转换
- 转换Extent为指定坐标系

## 2. ol.proj类常用方法

下面可以看下这个类里面都有哪些方法（红色方法为常用的方法，方法参数没有写，具体[可以查看](https://openlayers.org/en/latest/apidoc/module-ol_proj.html)）。

- addCoordinateTransforms 注册坐标转换功能以在源投影和目标投影之间转换坐标。正向和反向函数转换坐标对；该函数将这些转换为内部使用的函数，这些函数还可以处理范围和坐标数组。
- addEquivalentProjections 注册不改变坐标的变换函数。这些允许在具有相同含义的投影之间进行转换。
- addProjection 将Projection对象添加到可以通过其代码查找的受支持投影列表。
- equivalent 检查两个投影是否相同，即一个投影中的每个坐标确实代表与另一个投影中的相同坐标相同的地理点。
- get 为指定的代码获取一个Projection对象。
- getPointResolution
- getTransform 给定类似投影的对象，搜索转换函数以将坐标数组从源投影转换为目标投影。
- toLonLat 将坐标转换为经度/纬度。
- transformExtent 将范围从源投影转换为目标投影。这将返回一个新范围（并且不会修改原始范围）。
- `fromLonLat` 将坐标从经度/纬度转换为其他投影。
- `transform` 将坐标从源投影转换为目标投影。这将返回一个新坐标（并且不会修改原始坐标）。

> 下面主要讲`transform`这个方法

## 3. EPSG:4326和EPSG:3857坐标互相转换

使用 `transform` 转换。**ol.proj.transform(coordinate, source, destination)**
将坐标从源投影转换为目标投影。这将返回一个新的坐标（并且不会修改原始坐标）。

vue 页面引入

```js
import { transform, get } from "ol/proj";
```

1：将地理坐标转为投影坐标

```js
//坐标，源投影，目标投影
transform(coordinate, 'EPSG:4326', 'EPSG:3857')
```

2：将投影坐标转为地理坐标

```js
//坐标，源投影，目标投影
transform(coordinate, 'EPSG:3857', 'EPSG:4326')
```

如果是 geoJSON数据格式转换，则`MultiPolygon`和`Polygon`方法可以直接点出`transform`方法直接转换。

```javascript
geometry: new MultiPolygon(
    lineData.geometry.coordinates
).transform("EPSG:4326", "EPSG:3857")
//或者
geometry: new Polygon(
	lineData.geometry.coordinates
).transform("EPSG:4326", "EPSG:3857")
```