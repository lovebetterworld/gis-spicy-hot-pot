- [Openlayers 使用 GeoJSON](https://blog.csdn.net/weixin_39340061/article/details/108193732)

前言

GeoJSON 是一种标准的地理信息通信格式。本文简单介绍什么是 GeoJSON， 以及如何使用 Openlayers 提供的 API 读取、解析和展示 GeoJSON 描述的信息。

# 一 、什么是 GeoJSON？

## 1.1 官网介绍

GeoJSON is a format for encoding a variety of geographic data structures.

```js
{
    "type": "Feature",
        "geometry": {
            "type": "Point",
                "coordinates": [125.6, 10.1]
        },
            "properties": {
                "name": "Dinagat Islands"
            }
}
}
```

## 1.2 GeoJSON 重要对象成员（名/值对）

![image-20210816110811452](https://gitee.com/er-huomeng/l-img/raw/master/img/image-20210816110811452.png)

# 二、OpenLayers 使用 GeoJSON

官方示例： https://openlayers.org/en/latest/examples/geojson.html

## 1. 定义样式和获取样式的方法

```js
var styles = {
    'Polygon': new Style({
        stroke: new Stroke({
            color: 'blue',
            lineDash: [4],
            width: 3,
        }),
        fill: new Fill({
            color: 'rgba(0, 0, 255, 0.1)',
        }),
    })
};

var styleFunction = function (feature) {
    return styles[feature.getGeometry().getType()];
};
```

## 2. 解析并展示 GeoJSON

- 重点代码：

```js
// GeoJson 对象示例
var geojsonObject = {
    type: "Feature",
    geometry: {
        type: "Polygon",
        coordinates: [
            [
                [1e6, -3e6],
                [2e6, -4e6],
                [3e6, -6e6]
            ]
        ]
    }
};

// 将 geoJSON 解析成 feature 并添加到 vectorLayer 数据源中	
var vectorSource = new VectorSource({
    features: new GeoJSON().readFeatures(geojsonObject)
});

//使用数据源和显示方法构建图层
var vectorLayer = new VectorLayer({
    source: vectorSource,
    style: styleFunction
});
```

也可以在创建完成后调用 API 动态添加 feature:

```js
this.vectorSource.addFeatures(features);
```

