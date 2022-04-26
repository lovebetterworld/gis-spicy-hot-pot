- [OpenLayers - Source简介 （四） - 掘金 (juejin.cn)](https://juejin.cn/post/6996200345944719368)

## Source是什么

- 数据来源和格式。简单理解就是在使用`layers`(图层)时，不同的图层需要传入不同的数据类型，才能渲染地图。它们需要的数据格式都是通过`Source`定义好的，我们只需要把现有的数据，按照规定传入数据源中，就不需要关心其他操作。

## Source的一些数据类型

- `ol.source.BingMaps` Bing 地图图块数据的图层源。
- `ol.source.CartoDB` CartoDB Maps API 的图层源。
- `ol.source.Cluster` 聚簇矢量数据。
- `ol.source.Vector` 提供矢量图层数据。
- `ol.source.Image` 提供单一图片数据的类型。
- `ol.source.ImageCanvas` 数据来源是一个 canvas 元素，其中的数据是图片。
- `ol.source.ImageMapGuide` Mapguide 服务器提供的图片地图数据。
- `ol.source.ImageStatic` 提供单一的静态图片地图。
- `ol.source.ImageVector`数据来源是一个 canvas 元素，但是其中的数据是矢量来源。
- `ol.source.ImageWMS` WMS 服务提供的单一的图片数据。
- `ol.source.MapQuest` MapQuest 提供的切片数据。
- `ol.source.Stamen` Stamen 提供的地图切片数据。
- `ol.source.Tile` 提供被切分为网格切片的图片数据。
- `ol.source.TileVector` 被切分为网格的矢量数据。
- `ol.source.TileDebug` 并不从服务器获取数据。
- `ol.source.TileImage` 提供切分成切片的图片数据。
- `ol.source.TileUTFGrid` TileJSON 格式 的 UTFGrid 交互数据。
- `ol.source.TileJSON` TileJSON 格式的切片数据。
- `ol.source.TileArcGISRest` ArcGIS Rest 服务提供的切片数据。
- `ol.source.WMTS` WMTS 服务提供的切片数据。
- `ol.source.Zoomify` Zoomify 格式的切片数据。
- `ol.source.OSM` OpenStreetMap 提供的切片数据。
- `ol.source.XYZ` 具有在 URL 模板中定义的一组 XYZ 格式的 URL 的切片数据的图层源。

## 通过Layer使用Source

### ol.source.XYZ 切片数据源

- 在`ol.layer.Tile`图层中使用。

```js
var layerTile = new ol.layer.Tile({
      source: new ol.source.XYZ({
        url: 'https://webrd01.is.autonavi.com/appmaptile?lang=zh_cn&size=1&scale=1&style=8&x={x}&y={y}&z={z}'
      })
    })
```

- 通过url来获取高德地图的切片数据。

### ol.source.Vector 矢量图层的数据来源

- 常用属性

1. `attribution` 地图右下角的提示信息，传入字符串。
2. `features` 地理要素。传入`ol.Feature`对象。
3. `url` 要素数据的地址。
4. `format` `url`属性设置后，设置`url`返回的要素格式。传入`ol.format`下的格式。

- 使用`features`加载数据。

```js
var polygon = new ol.geom.Polygon([
      [
        [37, 19],
        [43, 19],
        [43, 3],
        [37, 3],
        [37, 19]
      ]
    ])
    polygon.applyTransform(ol.proj.getTransform('EPSG:4326', 'EPSG:3857'))
    // 多边形要素
    var polygonFeature = new ol.Feature(polygon)
    // 矢量图层
    var source = new ol.source.Vector({ features: [polygonFeature] })

    var vectorLayer = new ol.layer.Vector({
      source: source,
      style: new ol.style.Style({
        stroke: new ol.style.Stroke({
          //线样式
          color: '#ffcc33',
          width: 2
        })
      })
    })
    map.addLayer(vectorLayer)
```

![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/57d3b1c747084ed1a8f7773b1f9ad0bb~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

- 除了使用函数创建要素数据，也可是使用[**GeoJSON**](https://link.juejin.cn?target=https%3A%2F%2Fgeojson.org%2F)格式数据。

```js
    // GeoJSON 格式数据
    const geojsonObject = {
      type: 'FeatureCollection',
      crs: {
        type: 'name',
        properties: {
          name: 'EPSG:3857'
        }
      },
      features: [
        {
          type: 'Feature',
          geometry: {
            type: 'Polygon',
            coordinates: [
              [
                [-5e6, 6e6],
                [-5e6, 8e6],
                [-3e6, 8e6],
                [-3e6, 6e6],
                [-5e6, 6e6]
              ]
            ]
          }
        },
        {
          type: 'Feature',
          geometry: {
            type: 'Polygon',
            coordinates: [
              [
                [-2e6, 6e6],
                [-2e6, 8e6],
                [0, 8e6],
                [0, 6e6],
                [-2e6, 6e6]
              ]
            ]
          }
        },
        {
          type: 'Feature',
          geometry: {
            type: 'Polygon',
            coordinates: [
              [
                [1e6, 6e6],
                [1e6, 8e6],
                [3e6, 8e6],
                [3e6, 6e6],
                [1e6, 6e6]
              ]
            ]
          }
        },
        {
          type: 'Feature',
          geometry: {
            type: 'Polygon',
            coordinates: [
              [
                [-2e6, -1e6],
                [-1e6, 1e6],
                [0, -1e6],
                [-2e6, -1e6]
              ]
            ]
          }
        }
      ]
    }
    // 矢量图层
    var source = new ol.source.Vector({ features: new ol.format.GeoJSON().readFeatures(geojsonObject) })
    var vectorLayer = new ol.layer.Vector({
      source: source,
      style: new ol.style.Style({
        stroke: new ol.style.Stroke({
          //线样式
          color: '#ffcc33',
          width: 2
        })
      })
    })
    map.addLayer(vectorLayer)
```

![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/2a2e9d2382f74a879c119c5e0a0e4764~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

1. `GeoJSON` 是一种用于编码各种地理数据结构的格式。也是我们最常用的数据格式。
2. 一般使用`url`获取的也是这种格式。

- 因为`Source`的数据类型很多，每种都有自己的参数，事件等。就不一一介绍了，后面使用不同图层时会做讲解。
- 需要记住 `source` 是 `layer` 中必须的选项，定义着地图数据的来源。而且`source`是支持多种数格式。