- [GIS后端距离计算方法 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/531162872)

## 需求

计算出，给定起点、终点 两点之间的距离，单位为米。

## 方案

亲测如下两个方案，计算准确，精度高。

### 方案1:使用geotools

核心代码

```text
private double getDistance(double lat1,double lon1,double lat2, double lon2){
    // 84坐标系构造GeodeticCalculator
    GeodeticCalculator geodeticCalculator = new GeodeticCalculator(DefaultGeographicCRS.WGS84);
    // 起点经纬度
    geodeticCalculator.setStartingGeographicPoint(lon1,lat1);
    // 末点经纬度
    geodeticCalculator.setDestinationGeographicPoint(lon2,lat2);
    // 计算距离，单位：米
    double orthodromicDistance = geodeticCalculator.getOrthodromicDistance();
    return orthodromicDistance;
}
```

### 方案2：使用postgis的st_distance函数

核心代码：

```text
select st_distance(st_geometryfromtext('POINT(111 28)', 4326)::geography,st_geometryfromtext('POINT(111 29)', 4326)::geography)
```

**一定要注意，st_distance函数使用的时候，入参必须转成 geography 类型，否则计算出来的单位是度，而不是米**

## **总结**

上面两个方案，计算出的距离都非常准确，可以满足业务需求。

具体要使用哪一个方案，取决于实际的应用场景，如果对并发要求高或者是系统压根就没有使用postgis，可以使用方案1，因为方案1是在Java后端计算的，如果系统使用spring cloud 这类的微服务框架，可以很容易的实现集群部署，快速扩容。如果并发要求低，又有现成的postgis，就用方案2，方案2的优势就是简单，一句代码了事。