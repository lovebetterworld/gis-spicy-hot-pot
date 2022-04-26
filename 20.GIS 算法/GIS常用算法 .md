- [GIS常用算法](https://mp.weixin.qq.com/s/aQivc1SwkK4QGcNRiagbvA)

作为一个GISer，在日常`WebGIS`开发中，会常用到的`turf.js`，这是一个地理空间分析的`JavaScript`库，经常搭配各种`GIS JS API`使用，如`leaflet`、`mapboxgl`、`openlayers`等；在后台`Java`开发中，也有个比较强大的GIS库，`geotools`，里面包含构建一个完整的地理信息系统所需要的全部工具类；数据库端常用是`postgis`扩展，需要在`postgres`库中引入使用。

然而在开发某一些业务系统的时候，有些需求只需要调用某一个GIS算法，简单的几行代码即可完成，没有必要去引用一个GIS类库。

而且有些算法在这些常用的GIS类库中没有对应接口，就比如在下文记录的这几种常用算法中，求垂足、判断线和面的关系，在`turf.js`就没有对应接口。

下面文章中是我总结的一些常用GIS算法，这里统一用`JavaScript`语言实现，因为`JS`代码相对比较简洁，方便理解其中算法逻辑，也方便在浏览器下预览效果。在具体应用时可以根据具体需求，翻译成`Java`、`C#`、`Python`等语言来使用。

文中代码大部分为之前遇到需求时在网上搜索得到，然后自己根据具体需要做了优化修改，通过这篇文章做个总结收集，也方便后续使用时查找。

## 1、常用算法

以下方法中传参的点、线、面都是对应`geojson`格式中`coordinates`，方便统一调用。`geojson`标准参考：https://www.oschina.net/translate/geojson-spec

![图片](https://mmbiz.qpic.cn/mmbiz_png/X2Hhgiauu3gVMWwrhsPicauw7QLvuxtd1cqPNKKFP3nOT48YafGBdIAXdbUp9R1E8NFxXamlyye2PJicnNe0ndt8g/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

### 1.1、计算两经纬度点之间的距离

适用场景：测量

```
/**
* 计算两经纬度点之间的距离(单位：米)
* @param p1 起点的坐标；[经度,纬度]；例：[116.35,40.08]
* @param p2 终点的坐标；[经度,纬度]；例：[116.72,40.18]
*
* @return d 返回距离
*/
function getDistance(p1, p2) {
  var rlat1 = p1[1] * Math.PI / 180.0;
  var rlat2 = p2[1] * Math.PI / 180.0;
  var a = rlat1 - rlat2;
  var b = p1[0] * Math.PI / 180.0 - p2[0] * Math.PI / 180.0;
  var d = 2 * Math.asin(Math.sqrt(Math.pow(Math.sin(a / 2), 2) + Math.cos(rlat1) * Math.cos(rlat2) * Math.pow(Math.sin(b / 2), 2)));
  d = d * 6378.137;
  d = Math.round(d * 10000) / 10;
  return d
}
```

### 1.2、根据已知线段以及到起点距离，求目标点坐标

适用场景：封闭管段定位问题点

```
/**
* 根据已知线段以及到起点距离（单位：米），求目标点坐标
* @param line 线段；[[经度,纬度],[经度,纬度]]；例：[[116.01,40.01],[116.52,40.01]]
* @param dis 到起点距离（米）；Number；例：500
*
* @return point 返回坐标
*/
function getLinePoint(line, dis) {
  var p1 = line[0]
  var p2 = line[1]
  var d = getDistance(p1, p2) // 计算两经纬度点之间的距离(单位：米)
  var dx = p2[0] - p1[0]
  var dy = p2[1] - p1[1]
  return [p1[0] + dx * (dis / d), p1[1] + dy * (dis / d)]
}
```

### 1.3、已知点、线段，求垂足

垂足可能在线段上，也可能在线段延长线上。

适用场景：求垂足

```
/**
* 已知点、线段，求垂足
* @param line 线段；[[经度,纬度],[经度,纬度]]；例：[[116.01,40.01],[116.52,40.01]]
* @param p 点；[经度,纬度]；例：[116.35,40.08]
*
* @return point 返回垂足坐标
*/
function getFootPoint(line, p) {
  var p1 = line[0]
  var p2 = line[1]
  var dx = p2[0] - p1[0];
  var dy = p2[1] - p1[1];
  var cross = dx * (p[0] - p1[0]) + dy * (p[1] - p1[1])
  var d2 = dx * dx + dy * dy
  var u = cross / d2
  return [(p1[0] + u * dx), (p1[1] + u * dy)]
}
```

### 1.4、线段上距离目标点最近的点

不同于上面求垂足方法，该方法求出的点肯定在线段上。

如果垂足在线段上，则最近的点就是垂足，如果垂足在线段延长线上，则最近的点就是线段某一个端点。

适用场景：根据求出最近的点计算点到线段的最短距离

```
/**
* 线段上距离目标点最近的点
* @param line 线段；[[经度,纬度],[经度,纬度]]；例：[[116.01,40.01],[116.52,40.01]]
* @param p 点；[经度,纬度]；例：[116.35,40.08]
*
* @return point 最近的点坐标
*/
function getShortestPointInLine(line, p) {
  var p1 = line[0]
  var p2 = line[1]
  var dx = p2[0] - p1[0];
  var dy = p2[1] - p1[1];
  var cross = dx * (p[0] - p1[0]) + dy * (p[1] - p1[1])
  if (cross <= 0) {
    return p1
  }
  var d2 = dx * dx + dy * dy
  if (cross >= d2) {
    return p2
  }
  // 垂足
  var u = cross / d2
  return [(p1[0] + u * dx), (p1[1] + u * dy)]
}
```

### 1.5、点缓冲

这里缓冲属于测地线方法，由于这里并没有严格的投影转换体系，所以与标准的测地线缓冲还有些许误差，不过经测试，半径`100KM`内，误差基本可以忽略。具体缓冲类型可看下之前的文章[你真的会用PostGIS中的buffer缓冲吗？](https://mp.weixin.qq.com/s?__biz=MzU3NDc1NDAzNQ==&mid=2247483963&idx=1&sn=dacec8cb1f4853a6a30f7aefedb23077&chksm=fd2cdfa7ca5b56b13d826b9d6d42a48d9af088de404dd8432138684cd8e0e38d9dd944fa897e&scene=21&token=1387027988&lang=zh_CN#wechat_redirect)

适用场景：根据点和半径画圆

```
/**
* 点缓冲
* @param center 中心点；[经度,纬度]；例：[116.35,40.08]
* @param radius 半径（米）；Number；例：5000
* @param vertices 返回圆面点的个数；默认64；Number；例：32
*
* @return coords 面的坐标
*/
function bufferPoint(center, radius, vertices) {
  if (!vertices) vertices = 64;
  var coords = []
  // 111319.55：在赤道上1经度差对应的距离，111133.33：在经线上1纬度差对应的距离
  var distanceX = radius / (111319.55 * Math.cos(center[1] * Math.PI / 180));
  var distanceY = radius / 111133.33;
  var theta, x, y;
  for (var i = 0; i < vertices; i++) {
    theta = (i / vertices) * (2 * Math.PI);
    x = distanceX * Math.cos(theta);
    y = distanceY * Math.sin(theta);
    coords.push([center[0] + x, center[1] + y]);
  }
  return [coords]
}
```

### 1.6、点和面关系

该方法采用射线法思路实现。（了解射线法可参考：https://blog.csdn.net/qq_27161673/article/details/52973866）

这里已经考虑到环状多边形的情况。

适用场景：判断点是否在面内

```
/**
* 点和面关系
* @param point 点；[经度,纬度]；例：[116.353455, 40.080173]
* @param polygon 面；geojson格式中的coordinates；例：[[[116.1,39.5],[116.1,40.5],[116.9,40.5],[116.9,39.5]],[[116.3,39.7],[116.3,40.3],[116.7,40.3],[116.7,39.7]]]
*
* @return inside 点和面关系；0:多边形外，1：多边形内，2：多边形边上
*/
function pointInPolygon(point, polygon) {
  var isInNum = 0;
  for (var i = 0; i < polygon.length; i++) {
    var inside = pointInRing(point, polygon[i])
    if (inside === 2) {
      return 2;
    } else if (inside === 1) {
      isInNum++;
    }
  }
  if (isInNum % 2 == 0) {
    return 0;
  } else if (isInNum % 2 == 1) {
    return 1;
  }
}


/**
* 点和面关系
* @param point 点
* @param ring 单个闭合面的坐标
*
* @return inside 点和面关系；0:多边形外，1：多边形内，2：多边形边上
*/
function pointInRing(point, ring) {
  var inside = false,
    x = point[0],
    y = point[1],
    intersects, i, j;

  for (i = 0, j = ring.length - 1; i < ring.length; j = i++) {
    var xi = ring[i][0],
      yi = ring[i][1],
      xj = ring[j][0],
      yj = ring[j][1];

    if (xi == xj && yi == yj) {
      continue
    }
    // 判断点与线段的相对位置，0为在线段上，>0 点在左侧，<0 点在右侧
    if (isLeft(point, [ring[i], ring[j]]) === 0) {
      return 2; // 点在多边形边上
    } else {
      if ((yi > y) !== (yj > y)) { // 垂直方向目标点在yi、yj之间
        // 求目标点在当前线段上的x坐标。 由于JS小数运算后会转换为精确15位的float，因此需要去一下精度
        var xx = Number(((xj - xi) * (y - yi) / (yj - yi) + xi).toFixed(10))
        if (x <= xx) { // 目标点水平射线与当前线段有交点
          inside = !inside;
        }
      }
    }
  }
  return Number(inside);
}


/**
* 判断点与线段的相对位置
* @param point 目标点
* @param line 线段
*
* @return isLeft，点与线段的相对位置，0为在线段上，>0 p在左侧，<0 p在右侧
*/
function isLeft(point, line) {
  var isLeft = ((line[0][0] - point[0]) * (line[1][1] - point[1]) - (line[1][0] - point[0]) * (line[0][1] - point[1]))
  // 由于JS小数运算后会转换为精确15位的float，因此需要去一下精度
  return Number(isLeft.toFixed(10))
}
```

### 1.7、线段与线段的关系

适用场景：判断线和线的关系

```
/**
* 线段与线段的关系
* @param line1 线段；[[经度,纬度],[经度,纬度]]；例：[[116.01,40.01],[116.52,40.01]]
* @param line2 线段；[[经度,纬度],[经度,纬度]]；例：[[116.33,40.21],[116.36,39.76]]
*
* @return intersect 线段与线段的关系；0:相离，1：相交，2：相切
*/
function intersectLineAndLine(line1, line2) {
  var x1 = line1[0][0],
    y1 = line1[0][1],
    x2 = line1[1][0],
    y2 = line1[1][1],
    x3 = line2[0][0],
    y3 = line2[0][1],
    x4 = line2[1][0],
    y4 = line2[1][1]

  //快速排斥：
  //两个线段为对角线组成的矩形，如果这两个矩形没有重叠的部分，那么两条线段是不可能出现重叠的

  //这里的确如此，这一步是判定两矩形是否相交
  //1.线段ab的低点低于cd的最高点（可能重合）
  //2.cd的最左端小于ab的最右端（可能重合）
  //3.cd的最低点低于ab的最高点（加上条件1，两线段在竖直方向上重合）
  //4.ab的最左端小于cd的最右端（加上条件2，两直线在水平方向上重合）
  //综上4个条件，两条线段组成的矩形是重合的
  //特别要注意一个矩形含于另一个矩形之内的情况
  if (!(Math.min(x1, x2) <= Math.max(x3, x4) && Math.min(y3, y4) <= Math.max(y1, y2) &&
      Math.min(x3, x4) <= Math.max(x1, x2) && Math.min(y1, y2) <= Math.max(y3, y4))) {
    return 0
  }

  // 判断点与线段的相对位置，0为在线段上，>0 点在左侧，<0 点在右侧
  if (isLeft(line1[0], line2) === 0 || isLeft(line1[1], line2) === 0) {
    return 2
  }

  //跨立实验：
  //如果两条线段相交，那么必须跨立，就是以一条线段为标准，另一条线段的两端点一定在这条线段的两段
  //也就是说a b两点在线段cd的两端，c d两点在线段ab的两端
  var kuaili1 = ((x3 - x1) * (y2 - y1) - (x2 - x1) * (y3 - y1)) * ((x4 - x1) * (y2 - y1) - (x2 - x1) * (y4 - y1))
  var kuaili2 = ((x1 - x3) * (y4 - y3) - (x4 - x3) * (y1 - y3)) * ((x2 - x3) * (y4 - y3) - (x4 - x3) * (y2 - y3))
  return Number(Number(kuaili1.toFixed(10)) <= 0 && Number(kuaili2.toFixed(10)) <= 0)
}
```

### 1.8、线和面关系

适用场景：判断线与面的关系

该方法考虑到环状多边形的情况，且把相切情况分为了内切和外切。

参考链接：https://www.cnblogs.com/xiaozhi_5638/p/4165353.html

```
/**
* 线和面关系
* @param line 线段；[[经度,纬度],[经度,纬度]]；例：[[116.01,40.01],[116.52,40.01]]
* @param polygon 面；geojson格式中的coordinates；例：[[[116.1,39.5],[116.1,40.5],[116.9,40.5],[116.9,39.5]],[[116.3,39.7],[116.3,40.3],[116.7,40.3],[116.7,39.7]]]
*
* @return intersect 线和面关系；0:相离，1：相交，2：包含，3：内切，4：外切
*/
function intersectLineAndPolygon(line, polygon) {
  var isTangent = false
  var isInNum = 0
  var intersect = 0
  for (var i = 0; i < polygon.length; i++) {
    // 线和面关系；0:相离，1：相交，2：包含，3：内切，4：外切
    intersect = intersectLineAndRing(line, polygon[i])
    if (intersect === 1) {
      return 1
    } else if (intersect === 2) {
      isInNum++
    } else if (intersect === 3) {
      isInNum++
      isTangent = true
    } else if (intersect === 4) {
      isTangent = true
    }
  }
  if (isInNum % 2 == 0) {
    if (isTangent) {
      return 4 // 外切
    } else {
      return 0 // 相离
    }
  } else if (isInNum % 2 == 1) {
    if (isTangent) {
      return 3 // 内切
    } else {
      return 2 // 包含
    }
  }
}


/**
* 线和面关系
* @param line 线段
* @param ring 单面
*
* @return intersect 线和面关系；0:相离，1：相交，2：包含，3：内切，4：外切
*/
function intersectLineAndRing(line, ring) {
  var inserset = 0
  var isTangent = false
  var inserset1 = pointInRing(line[0], ring) // 点和面关系；0:多边形外，1：多边形内，2：多边形边上
  var inserset2 = pointInRing(line[1], ring) // 点和面关系；0:多边形外，1：多边形内，2：多边形边上
  if (inserset1 === inserset2 === 0) {
    inserset = 0
  } else if ((inserset1 * inserset2) === 1) {
    inserset = 2
  } else if ((inserset1 * inserset2) === 2) {
    inserset = 3
  } else if ((inserset1 === 2 || inserset2 === 2) && (inserset1 === 0 || inserset2 === 0)) {
    inserset = 4
  } else if ((inserset1 === 1 || inserset2 === 1) && (inserset1 === 0 || inserset2 === 0)) {
    return 1 // 相交
  }
  for (var i = 0, j = ring.length - 1; i < ring.length; j = i++) {
    var line2 = [ring[j], ring[i]]
    // 目标线段与当前线段的关系；0:相离，1：相交，2：相切
    var intersectLine = intersectLineAndLine(line, line2)
    if (intersectLine == 1) {
      return 1 // 相交
    }
  }
  return inserset
}
```

### 1.9、geojson 面转线

适用场景：只有`geojson`面数据，获取线的边界

```
/**
* 面转线
* @param geojson 面geojson
*
* @return geojson 线geojson
*/
function convertPolygonToPolyline(polygonGeoJson) {
  var polylineGeoJson = JSON.parse(JSON.stringify(polygonGeoJson))

  for (var i = 0; i < polylineGeoJson.features.length; i++) {
    var MultiLineString = []
    if (polylineGeoJson.features[i].geometry.type === 'Polygon') {
      var Polygon = polylineGeoJson.features[i].geometry.coordinates
      Polygon.forEach(LinearRing => {
        var LineString = LinearRing
        MultiLineString.push(LineString)
      })
    } else if (polylineGeoJson.features[i].geometry.type === 'MultiPolygon') {
      var MultiPolygon = polylineGeoJson.features[i].geometry.coordinates
      MultiPolygon.forEach(Polygon => {
        Polygon.forEach(LinearRing => {
          var LineString = LinearRing
          MultiLineString.push(LineString)
        })
      })
    } else {
      console.error('请确认输入参数为geojson格式面数据！')
      return null
    }
    polylineGeoJson.features[i].geometry.type = 'MultiLineString' //面转线
    polylineGeoJson.features[i].geometry.coordinates = MultiLineString
  }

  return polylineGeoJson
}
```

## 2、在线示例

在线示例：http://gisarmory.xyz/blog/index.html?demo=GISAlgorithm

代码地址：http://gisarmory.xyz/blog/index.html?source=GISAlgorithm