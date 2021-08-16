- [Vue + OpenLayers 实时定位（二） 后端服务](https://blog.csdn.net/weixin_39340061/article/details/108200509)



前言

本系列文章介绍一个简单的实时定位示例，示例的组成主要包括：

- 服务后端，使用 Java 语言编写，模拟生成 GeoJSON 数据。
- 前端展示，使用 Vue + OpenLayers ，负责定时向后端服务请求 GeoJSON 数据，并在以标签的形式展现定位数据。
- 前端实现移步：Vue + OpenLayers 实时定位（一） 前端展示



本文主要介绍定位服务后端示例，数据并非实时采集，而是 Mock 数据给前端。

# 一、定义 GeoJSON 相关 VO

因为本文只是示例， 将定位数据展示为地图上的红点，所以对 GeoJSON 进行简化。只包含了 Point 这种类型。

## 1. GeoJSON 对象示例：

```js
var geojsonObject = {
    type: "FeatureCollection",
    features: [
        {
            type: "Feature",
            geometry: {
                type: "Point",
                coordinates: [0, 0]
            }
        }
        //此处可以添加更多 feature
    ]
};
```

## 2. Java VO 对象

- GeoInfoVo

```js
@Data
public class GeoInfoVo {
    private final String type = "FeatureCollection";
	private List<GeoFeatureVo> features = new ArrayList<>();
}
```

- GeoFeatureVo

```js
@Data
public class GeoInfoVo {
    private final String type = "FeatureCollection";
	private List<GeoFeatureVo> features = new ArrayList<>();
}
```

- GeometryVo

```java
@Data
   public class GeometryVo {
       private final String type = "Point";
       private double[] coordinates = new double[2];
   }
```

# 二、定义 Controller

```java
@RestController
@RequestMapping("/locations")
@CrossOrigin(origins = "*", maxAge = 3600)
public class LocationController {

    Random random = new Random();

    @RequestMapping(method = RequestMethod.GET)
    public ResultBean getLocations() {
        return new ResultBean(getMock());
    }

    private GeoInfoVo getMock() {

        GeoInfoVo geoInfoVo = new GeoInfoVo();

        for (int i = 0; i < 100; i++) {

            GeoFeatureVo geoFeatureVo = new GeoFeatureVo();
            geoFeatureVo.setId("" + i);

            GeometryVo geometry = new GeometryVo();
            geometry.setCoordinates(new double[]{random.nextDouble() * 1e7, random.nextDouble() * 1e7});
            geoFeatureVo.setGeometry(geometry);

            geoInfoVo.getFeatures().add(geoFeatureVo);
        }

        return geoInfoVo;
    }
}
```

# 总结

本文比较简单，根据 GeoJSON 定义了三个 VO 类。并 mock 定位数据给前端。在连接到定位设备后， 可以使用实际的位置数据替换模拟数据。下一篇文章中对前端进行修改，完成本系列。