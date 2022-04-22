- [OpenLayers - control简介 （六） - 掘金 (juejin.cn)](https://juejin.cn/post/6996832393575268359)

## control是什么

1. `Controls`是用来控制地图的。如通过按钮控制地图大小，在地图map上添加修饰等。
2. 在`Openlayers`中多数`Controls`直接可以在地图上添加，比如`Navigation（导航栏）`。第二类是需要放在`Div元素`中才能用。第三类需要放置在`panel（面板）`中的操作类似于网页`HTML`中`button`按钮，需要点击或绑定才能起作用。最后一类就是自定义类型的。

## 常用的控件

- `controldefaults`，地图默认包含的控件。
- `fullscreen`，全屏控件，用于全屏幕查看地图。
- `mouseposition`，鼠标位置控件，显示鼠标所在地图位置的坐标，可以自定义投影。
- `overviewmap`，地图全局视图控件（鹰眼图）。
- `scaleline`，比例尺控件。
- `zoom`，地图放控件。
- `zoomslider`，地图缩放滑块刻度控件。

## 使用控件

- 实例化地图`map`，通过参数`control`传入，不传值默认`controldefaults`中的控件。
- 也可以利用`map`对象的`addControl()`或`addControls()`方法在地图上添加`Controls`对象。
- 需要在默认控件基础上继续添加控件，可以使用`ol.control.defaults().extend([new ol.control.FullScreen()])` 方法传入。

### 实例化地图

```html
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Document</title>
    </head>
    <style type="text/css">
        .map {
            height: 500px;
            width: 100%;
        }
    </style>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/openlayers/openlayers.github.io@master/en/v6.6.1/css/ol.css" />
    <script src="https://cdn.jsdelivr.net/gh/openlayers/openlayers.github.io@master/en/v6.6.1/build/ol.js"></script>
    <body>
        <div id="map" class="map"></div>
    </body>
    <script>
        var map = new ol.Map({
            target: 'map'
        })

        // 图层
        var layerTile = new ol.layer.Tile({
            source: new ol.source.XYZ({
                url: 'https://webrd01.is.autonavi.com/appmaptile?lang=zh_cn&size=1&scale=1&style=8&x={x}&y={y}&z={z}'
            })
        })
        // 视图
        var view = new ol.View({
            center: ol.proj.fromLonLat([37.41, 8.82]),
            zoom: 4
        })

        map.setView(view)
        map.addLayer(layerTile)
    </script>
</html>
```

### fullscreen 全屏控件

```js
map.addControl(new ol.control.FullScreen())
```

![1.gif](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/200006e178d8417c84ca450e73d7171c~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

### mouseposition 显示鼠标所在坐标

```js
var mousePositionControl = new ol.control.MousePosition({
    //地图投影坐标系（若未设置则输出为默认投影坐标系下的坐标）
    projection: 'EPSG:4326',
    //显示鼠标位置信息的目标容器
    target: document.getElementById('mouse-position'),
    //未定义坐标的标记
    undefinedHTML: ''
})
this.map.addControl(mousePositionControl)
```

![1.gif](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/a07b392d993d4400855f674fbfa6bf8d~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

### scaleline 控件、zoom 控件、zoomslider 控件

```js
map.addControl(new ol.control.ScaleLine())
map.addControl(new ol.control.Zoom())
map.addControl(new ol.control.ZoomSlider())
```

![1.gif](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/ffcff077566b4414b8ee1d98d4c8097c~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

### overviewmap 地图全局视图（鹰眼图）

- 使用地图作为另一个定义地图的概览图创建一个新控件。
- 常用参数

1. `collapsed`，收缩选项，默认为true，收缩。
2. `collapsible`，是否可以收缩为图标按钮，默认为 true。
3. `label`，当 overviewmapcontrol 收缩为图标按钮时，显示在图标按钮上的文字或者符号，默认为 »。
4. `layers`，overviewmapcontrol针对的图层，默认情况下为所有图层，一般这里设置的图层和map图层数据一致。

```js
var overview = new ol.control.OverviewMap({
    collapsed: false,
    layers: [
        new ol.layer.Tile({
            source: new ol.source.XYZ({
                url: 'http://map.geoq.cn/ArcGIS/rest/services/ChinaOnlineStreetPurplishBlue/MapServer/tile/{z}/{y}/{x}'
            })
        })
    ]
})
map.addControl(overview)
```

- 当然除了这些控件，官网上还有其他的控件。
- 我们也可以自定义控件来操作地图。可以通过使用侦听器创建元素，创建一个实例，将其用于简单的自定义控件：

```
var myControl = new Control({element: myElement});
```

- 然后将其添加到地图中。