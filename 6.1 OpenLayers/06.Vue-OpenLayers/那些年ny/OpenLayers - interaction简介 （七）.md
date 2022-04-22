- [OpenLayers - interaction简介 （七） - 掘金 (juejin.cn)](https://juejin.cn/post/6997206730455121933)

## Interaction是什么

1. `Interaction`是用来控制地图的。没看错它和控件一样的作用。不过它们的区别是**控件**触发都是一些可见的 HTML元素触发，如按钮、链接等；**交互功能**都是一些设备行为触发，都是不可见的，如鼠标双击、滚轮滑动，手机设备的手指缩放等。
2. `Interaction`，是一个虚基类，不负责实例化，交互功能都继承该基类。

## 常用交互功能

- `doubleclickzoom` ，双击地图进行缩放；
- `draganddrop` ，以“拖文件到地图中”的交互添加图层；
- `dragbox`，拉框，用于划定一个矩形范围，常用于放大地图；
- `dragpan` ，拖拽平移地图；
- `dragrotateandzoom`，拖拽方式进行缩放和旋转地图；
- `dragrotate` ，拖拽方式旋转地图；
- `dragzoom` ，拖拽方式缩放地图；
- `draw`，绘制地理要素功能；
- `keyboardpan` ，键盘方式平移地图；
- `keyboardzoom` ，键盘方式缩放地图；
- `select`，选择要素功能；
- `modify` ，更改要素；
- `mousewheelzoom` ，鼠标滚轮缩放功能；
- `pinchrotate`，手指旋转地图，针对触摸屏；
- `pinchzoom` ，手指进行缩放，针对触摸屏；
- `pointer` ，鼠标的用户自定义事件基类；
- `snap`，鼠标捕捉，当鼠标距离某个要素一定距离之内，自动吸附到要素。

### defaults

默认的交互功能，包含多个交互。规定了默认包含在地图中的功能，他们都是继承自 `ol.interaction` 类。 主要是最为常用的功能，如缩放、平移和旋转地图等。

- `DragRotate`，鼠标拖拽旋转，一般配合一个键盘按键辅助。
- `DragZoom`，鼠标拖拽缩放，一般配合一个键盘按键辅助。
- `DoubleClickZoom`，鼠标或手指双击缩放地图。
- `PinchRotate`，两个手指旋转地图，针对触摸屏。
- `PinchZoom`，两个手指缩放地图，针对触摸屏。
- `DragPan`，鼠标或手指拖拽平移地图。
- `KeyboardZoom`，使用键盘 `+` 和 `-` 按键进行缩放。
- `KeyboardPan`，使用键盘方向键平移地图。
- `MouseWheelZoom`，鼠标滚轮缩放地图。

## 使用交互功能

1. 通过`map`构造参数`interactions`传入，不传值默认`defaults`中的交互。
2. 需要在默认交互基础上继续添加交互，可以使用`ol.interaction.defaults().extend([new ol.control.Draw()])` 方法传入。
3. 也可以利用`map`对象的`addInteraction()`方法在地图上添加`Interaction`对象。

### 初始化地图

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
            center: ol.proj.fromLonLat([130.41, 28.82]),
            zoom: 4
        })

        map.setView(view)
        map.addLayer(layerTile)
    </script>
</html>
```

### Draw 使用

- 负责勾绘交互，支持绘制的图形类型包含 Point（点）、LineString（线）、Polygon（面）和Circle（圆）。

```js
var source = new ol.source.Vector()
var draw = new ol.interaction.Draw({
    source: source,
    type: 'Polygon',
    style: new ol.style.Style({
        fill: new ol.style.Fill({
            color: 'rgba(255, 255, 255, 1)'
        }),
        stroke: new ol.style.Stroke({
            color: '#ffcc33',
            width: 2
        }),
        image: new ol.style.Circle({
            radius: 7,
            fill: new ol.style.Fill({
                color: '#ffcc33'
            })
        })
    })
})
map.addInteraction(draw)
```

![1.gif](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/057ba4ff66ad4c0cb9fd896135d470be~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

### DragRotateAndZoom 使用

- shift + 鼠标拖拽进行缩放和旋转地图

```js
map.addInteraction(new ol.interaction.DragRotateAndZoom())
```

![1.gif](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/22413d67431f4a4194aea090a6ea0900~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

### pointer

- 监听鼠标的行为按下（Down）、移动（Move）和抬起（Up）事件。

```js
var pointer = new ol.interaction.Pointer({
    handleDownEvent: (e) => {
        console.log('按下', e.type)
        return true
    },
    handleDragEvent: (e) => {
        console.log('拖拽移动', e.type)
    },
    handleUpEvent: (e) => {
        console.log('拖拽抬起', e.type)
    }
})
map.addInteraction(pointer)
```

![1.gif](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/c7ad2cb583954113ab3bef83f12274ba~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

## 总结

`OpenLayers`提供了很多的交互控件，主要有：缩放、平移拖拽、旋转，为了提高兼容性，除了针对鼠标和键盘的交互，还有针对触摸屏的缩放、旋转和平移拖拽等。在开发中灵活的使用这些交互，可以减少开发时间也可以提升客户满意度。这里只是简单的介绍了交互的作用，要详细了解最好每一个交互都实际使用一下。