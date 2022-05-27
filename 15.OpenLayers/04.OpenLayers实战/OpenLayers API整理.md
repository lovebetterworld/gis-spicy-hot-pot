- [OpenLayers API整理 - HelloWorld开发者社区](https://www.helloworld.net/p/9567957620)

## 一、创建地图

### 1、地图`Map`

创建地图底图：需要用`new ol.Map({})`

地图`map`是由图层`layers`、一个可视化视图`view`、用于修改地图内容的交互`interaction`以及使用UI组件的控件`control`组成的。

#### （1）、创建基本地图

```
let map = new ol.Map({
    target: 'map',//对象指向
    layers: [//图层
      new ol.layer.Tile({//这里定义的是平铺图层
        source: new ol.source.OSM()//图层源 定义图层映射协议
      })
    ],
    view: new ol.View({//视图
      center: ol.proj.fromLonLat([37.41, 8.82]),//地图中心
      zoom: 4//缩放层级
    })
  });
```

#### （2）、属性选项

```
new ol.Map({
    target: 'map',//对象映射：要将`map`对象附加到div，` map`对象将`target`作为参数，值是`div`的`id`
    layers: [//图层
      new ol.layer.Tile({//这里定义的是平铺图层
        source: new ol.source.OSM()//图层源 定义图层映射协议
      })
    ],
    view: new ol.View({//视图
      center: ol.proj.fromLonLat([37.41, 8.82]),//地图中心
      zoom: 4//缩放层级
    }),
    controls:[//最初添加到映射中的控件  如未设置 使用默认控件
        new ol.control.Control({
            element:,//元素是控件的容器元素(DOM)。只有在开发自定义控件时才需要指定这一点
            render: ,//控件重新呈现时调用的函数
            target: //如果想在映射的视图端口之外呈现控件，指定目标
        })
    ],
    interactions:[//最初添加到映射中的交互 如未设置 使用默认交互
        new ol.interaction.Interaction({
            handleEvent
        })
    ],
    overlays:[
        new ol.Overlay()
    ],
    maxTilesLoading:16,//同时加载的最大瓷砖数 默认16
    loadTilesWhileAnimating:false,//
    loadTilesWhileInteracting:false,//   
    moveTolerance:1,//光标必须移动的最小距离(以像素为单位)才能被检测为map move事件，而不是单击。增加这个值可以使单击地图变得更容易
    pixelRatio:window.devicePixelRatio,//
    keyboardEventTarget:,//要监听键盘事件的元素
})
```

#### （3）、地图事件

地图事件

含义

```
click
```

无拖动单击

```
dblclick
```

无拖动双击

```
moveend
```

移动地图结束时

```
movestart
```

移动地图开始时

```
pointerdrag
```

当拖动指针时触发

```
pointermove
```

当指针移动时触发。注意，在触摸设备上，这是在地图平移时触发的，因此与`mousemove`不同

```
postcompose
```



```
postrender
```

在映射帧呈现后触发

```
precompose
```



```
propertychange
```

当属性被更改时触发

```
rendercomplete
```

渲染完成时触发，即当前视图的所有源和tile都已加载完毕，所有tile都将淡出

```
singleclick
```

一个真正的无拖放和无双击的单击。注意，这个事件被延迟了250毫秒，以确保它不是双击

#### （4）、地图方法

地图方法

功能

```
addControl(control)
```

将给定的控件添加到地图中

```
removeControl(control)
```

从地图中移除已给定的控件

```
addInteraction(interaction)
```

将给定的交互添加到地图中

```
removeInteraction(interaction)
```

从地图中移除已给定的交互

```
addLayer(layer)
```

将给定的图层添加到地图的顶部

```
removeLayer(layer)
```

从地图中移除已给定的图层

```
addOverlay(overlay)
```

将给定的叠加层添加到地图中

```
removeOverlay(overlay)
```

从地图中移除已给定的叠加层

```
forEachFeatureAtPixel(pixel, callback, opt_options)
```

检测与视图端口上的像素相交的特性，并对每个相交的特性执行回调。检测中包含的层可以通过`opt_options`中的`layerFilter`选项配置

```
forEachLayerAtPixel(pixel, callback, opt_options)
```

检测在视图端口上的像素处具有颜色值的层，并对每个匹配的层执行回调。检测中包含的层可以通过`opt_layerFilter`配置

```
getControls()
```

获取地图控件

```
getCoordinateFromPixel(pixel)
```

获取给定像素的坐标。这将返回地图视图投影中的坐标。

```
getEventCoordinate(event)
```

返回浏览器事件的视图投影中的坐标

```
getEventPixel(event)
```

返回浏览器事件相对于视图端口的地图像素位置

```
getFeaturesAtPixel(pixel, opt_options)
```

获取视图端口上与像素相交的所有特性

```
getInteractions()
```

获取地图交互

```
getLayerGroup()
```

获取与此地图关联的图层组

```
setLayerGroup(layerGroup)
```

设置与此地图关联的图层组

```
getLayers()
```

获取与此地图关联的图层的集合

```
getOverlayById(id)
```

通过其标识符获取覆盖(`overlay. getId()`返回的值)。注意，索引将字符串和数字标识符视为相同的。`getoverlaybyid(2)`将返回id为2或2的叠加层。

```
getOverlays()
```

获得地图叠加

```
getPixelFromCoordinate(coordinate)
```

获取坐标的像素。它接受地图视图投影中的坐标并返回相应的像素

```
getSize()
```

获取地图尺寸

```
setSize(size)
```

s设置地图尺寸

```
getTarget()
```

获取呈现此映射的目标。注意，这将返回作为选项或`setTarget`中输入的内容。如果这是一个元素，它将返回一个元素;如果是字符串，它会返回这个字符串

```
setTarget(target)
```

设置要将地图呈现的目标元素

```
getTargetElement()
```

获取呈现此映射的`DOM`元素。与`getTarget`相反，这个方法总是返回一个元素，如果映射没有目标，则返回`null`

```
getView()
```

获取地图视图。视图管理中心和分辨率等属性。

```
setView(view)
```

设置地图视图

```
getViewport()
```

获取作为`map`视图端口的元素

```
hasFeatureAtPixel(pixel, opt_options)
```

检测在`viewport`上是否与一个像素相交。可以通过`opt_layerFilter`配置在检测中包含的层。

### 2、图层`Layers`

定义图层：地图图层`layers:[...]`组定义映射中可用的图层组，用来盛放地图上的各种元素，其在地图上的显示顺序是按照数组中元素序列从下到上呈现的，可以直接在创建地图时定义图层，多个图层的时候可以单独定义。

```
const layer = new ol.layer.Vector({//这里定义的是图层类型(Image/Title/Vector)
    source:new ol.source.Vector(),//矢量图层源  源是用于获取映射块的协议【必须】
    style:[],//图层样式 【必须】
    feature:[],//图层元素 【必须】
})
```

- 添加指定图层：`map.addLayer(layer)`；
- 移除指定图层：`map.removeLayer(layer)`；

图层是轻量级容器，从数据源`Source`获取数据。

`Source`d子类分别有，分别对应不同图层类：

- `ol.source.ImageSource()`
- `ol.source.TileSource()`
- `ol.source.VectorSource()`

`Source`主要有以下属性选项：

```
new ol.source.VectorSource({
    attributions:,//
    attributionsCollapsible:,//布尔值  默认为true 
    projection:,//投影系
    state:'ready',//默认为'ready'
    wrapX:false,//默认为false
})
```

`ol.layer.Tile()`和`ol.layer.Image()`图层类都具有相同的属性如下：

```
new ol.layer.Tile/Image({//以下为图层的属性选项， 都可设置，所以皆有getter/setter
    opacity:2,//透明度 区间范围为(0, 1) 默认为1
    visible:true,//显示属性 布尔值 默认为true
    extent:[],//图层渲染的边界范围。该层将不会在此范围之外呈现
    zIndex:2,//图层渲染的索引层级。在渲染时，图层将被排序，首先是z-idnex，然后是位置，当为undefined时，对于添加到映射的layers集合中的层，zIndex为0，或者当使用该层的setMap()方法时，zIndex为无穷大
    minResolution:3,//该层可见的最小分辨率(包括在内)
    maxResolution:6,//该层可见的最大分辨率（包括在内）
    repload:0,//预加载。将低分辨率瓦片加载到预加载级别。0表示没有预加载 默认为0
    source:new ol.source.TileSource()/ImageSource(),//图层源
    map:  ,//把图层覆盖在地图上，地图不会在它的图层集合中管理这个图层，这个图层将被呈现在顶部，这对于临时层非常有用。
})
```

#### (1)`ol.layer.Tile()`

平铺图层。

对于提供预呈现、平铺的网格图像的层源，这些网格按特定分辨率的缩放级别组织。

#### (2)`ol.layer.Image()`

图像图层。

服务器呈现的映像，可用于任意范围和分辨率。

#### (3)`ol.layer.Vector()`

矢量图层。

在客户端呈现矢量数据，其属性具备`getter`和`setter`

```
new ol.layer.Vector({//以下为图层的属性选项， 都可设置，所以皆有getter/setter
    opacity:2,//透明度 区间范围为(0, 1) 默认为1
    visible:true,//显示属性 布尔值 默认为true
    extent:[],//图层渲染的边界范围。该层将不会在此范围之外呈现
    zIndex:2,//图层渲染的索引层级。在渲染时，图层将被排序，首先是z-idnex，然后是位置，当为undefined时，对于添加到映射的layers集合中的层，zIndex为0，或者当使用该层的setMap()方法时，zIndex为无穷大
    minResolution:3,//该层可见的最小分辨率(包括在内)
    maxResolution:6,//该层可见的最大分辨率（包括在内）
    renderOrder:,//呈现顺序。函数用于在呈现前对特性进行排序。默认情况下，特性是按照创建它们的顺序绘制的。使用null来避免排序，但是得到一个未定义的绘制顺序
    renderBuffer:100,//默认为100 缓冲区
    renderMode:'vector',//默认为'vector' 矢量图层的渲染模式
    source:new ol.source.VectorSource(),//图层源
    map:  ,//把图层覆盖在地图上，地图不会在它的图层集合中管理这个图层，这个图层将被呈现在顶部，这对于临时层非常有用
    declutter:false,//默认为false 整理图片和文字。清理应用于所有图像和文本样式，优先级由样式的z-index定义。z-index指数越低，优先级越高
    style:new ol.style.Style(),//图层样式
    updateWhileAnimating:false,//默认为false 
    updateWhileInteracting:false,//默认为false
})
```

其中渲染模式有两种：

- `'image'`：矢量图层被渲染为图像。性能很好，但是点符号和文本总是随着视图旋转，像素在缩放动画中缩放
- `'vector'`：矢量图层被呈现为向量。即使在动画期间也有最准确的渲染，但性能较慢

##### 1)`Feature`

用于地理特征的矢量元素，具有几何`geometry()`和其他属性，类似于矢量文件格式(如`GeoJSON`)中的特性。

- 添加矢量元素：通过`vectorsource().addFeature(feature)`添加到矢量图层上。

- 移除图层所有的矢量元素：`vectorsource().clear()`

  let feature = new ol.Feature({
  geometry: new ol.geom.Polygon(polyCoords),
  labelPoint: new ol.geom.Point(labelCoords),
  style:new ol.style.Style({}),
  name: ‘My Polygon’
  });

- 定义矢量元素：`new ol.Feature()`，；

- 矢量元素样式：

  - 设置样式：`new ol.style.Style()`，也可以使用`feature.setStyle(style)`，未定义的话，可以使用它的盛放容器`layer`的样式；
  - 获取样式：`feature.getStyle()`

- 一个`feature`只有一个默认几何属性`geometry`，可以有任意数量的命名几何图形：

  - 获取默认几何属性：`feature.getGeometry()`；
  - 设置几何属性：`feature.setGeometry(geometry)`；
  - 设置几何属性名：`feature.setGeometryName(name)`；
  - 矢量元素要呈现的几何图形的特征属性、几何图形或函数由`geometry`属性选项设定，主要有以下几种子类模块：
    - `ol.geom.Circle()`：圆形
    - `ol.geom.Geometry()`：几何图形
    - `ol.geom.GeometryCollection()`：
    - `ol.geom.LinearRing()`：环线
    - `ol.geom.LineString()`：线段
    - `ol.geom.Point()`：点
    - `ol.geom.Polygon()`：多边形
    - `ol.geom.MultiLineString()`
    - `ol.geom.MultiPoint()`
    - `ol.geom.MultiPolygon()`
    - `ol.geom.SimpleGeometry()`

- `feature`的稳定标识符`ID`：

  - 设置`feature`的`id`：`feature.setId(id)`，当`id`可能相同时，可以这样加以区分

    feature.setId(id + “featureName”);

  - 获取`feature`的`id`：`vector.getSource().getFeatureById()`或者`vectorsource().getFeatureById()`

- `feature`的`set(key, value, opt_silent)`：

  - 设置`key`：`feature.set("keyName",name)`，`keyName`是字符串，自己根据情况设置
  - 获取`key`：之前设置的什么，就获取什么，`feature.get("keyName")`，会得到设置的值

##### 2)`Style`

矢量特征呈现样式的容器。在重新呈现使用样式的特性或图层之前，通过`set*()`方法对样式及其子元素所做的任何更改都不会生效。

```
new ol.style.Style({
    geometry:new ol.geom.LineString(),//有以上ol.geom模块的几何图形可以参考
    fill:new ol.style.Fill({//填充样式
        color:color//颜色、渐变或图案
    }),
    
    image:new ol.style.Image({//图像
        opacity:,//数值
        rotateWithView:,//布尔值
        rotation:,//数值
        scale://数值
    }),
    
    image:new ol.style.Icon({//可以使用图片资源
        anchor:[0.5，0.5]，//锚。默认值是图标中心 默认值是[0.5,0.5]
        anchorOrigin:'top-left',//锚的原点:左下角、右下角、左上方或右上方。默认是左上
        anchorXUnits:'fraction',//指定锚点x值的单位。'fraction'的值表示x值是图标的'fraction'。'pixels'的值表示像素中的x值,默认为'fraction'
        anchorYUnits:'fraction',//指定锚点y值的单位。'fraction'的值表示y值是图标的'fraction'。'pixels'的值表示像素中的y值,默认为'fraction'
        color:color,//颜色、渐变或图案
        crossOrigin:,
        img:,//图标的图像对象  如果没有提供src选项，则必须已经加载了提供的图像
        imgSize:,//
        offset:[0,0].//偏移值，默认为[0,0]
        offsetOrigin:'top-left',//偏移量的原点，bottom-left, bottom-right, top-left or top-right. 默认是`top-left`
        opacity:1,//默认是1  （0，1）
        scale:1,//默认是1
        rotation：0，//以弧度旋转(顺时针方向正旋转) 默认为0
        size：,//图标大小(以像素为单位)。可与偏移量一起用于定义要从原点(sprite)图标图像使用的子矩形
        src:'',//图像URL源
        rotateWithView：false,//是否旋转视图中的图标  默认为false            
    }),
    
    stroke:new ol.style.Stroke({//描绘
        width: ,//宽
        color:color,//颜色、渐变或图案
        lineCap:'round',//线帽风格  butt, round, 或者 square 默认 round
        lineJoin:'round',//线连接方式 bevel, round, 或者 miter 默认 round
        lineDash： []，//线间隔模式 这个变化与分辨率有关 默认为undefined Internet Explorer 10和更低版本不支持
        lineDashOffset:0,//线段间隔偏移 默认0
        miterLimit:10,// 默认10                   
    }),
        
    text:new ol.style.Text({//文字
        font:'',//默认是'10px sans-serif'
        text:'',//文本内容
        textAlign：'center',//文本对齐 'left', 'right', 'center', 'end' 'start'.针对于placement: 'point',默认为'center'；针对于placement: 'line'，默认是让渲染器选择不超过maxAngle的位置
        textBaseline:'middle',//文本基线  'bottom', 'top', 'middle', 'alphabetic', 'hanging', 'ideographic' 默认'middle'
        placement:'',//文本布置
        scale：，
        padding:[0,0,0,0],//文本周围的像素填充。数组中值的顺序是[top, right, bottom, left]
        fill:new ol.style.Fill(),//如果未设置，默认未#333
        stroke:new ol.style.Stroke(),
        offsetX:0,//水平文本偏移量(以像素为单位)。正值将把文本右移。默认0
        offsetY:0,//垂直文本偏移量(以像素为单位)。正值会将文本向下移动。默认0
        rotation：0，//默认0
        rotateWithView:false,
        backgroundFill:  ,//当placement:“point”时，填充文本背景的样式。默认为无填充 
        backgroundStroke: ,//当placement:“point”时，描绘文本背景的样式。默认为无描绘
    }),
    
    zIndex:,
})
```

`ol.geom.Geomtry()`是矢量几何对象的抽象基类，通常只用于创建子类，而不是在应用程序中实例化。它的方法如下：

方法

功能

```
set(key, value)
```

设置值。`key`：关键名字（字符串）；`value`：值

```
get(key)
```

获取值

```
setProperties(values, opt_silent)
```

设置键值对的集合。注意，这将更改任何现有属性并添加新属性(它不会删除任何现有属性)。

```
getProperties()
```

获取一个包含所有属性名和值的对象

```
getClosestPoint(point, opt_closestPoint)
```

将几何图形的最近点作为坐标返回到经过的点

```
getExtent(opt_extent)
```

获取几何的范围

```
getKeys()
```

获取对象属性名称列表

```
getRevision()
```

获取此对象的版本号。每次修改对象时，它的版本号都会增加。

```
intersectsCoordinate(coordinate)
```

如果该几何图形包含指定的坐标，则返回`true`。如果坐标位于几何图形的边界上，则返回`false`

```
rotate(angle, anchor)
```

围绕给定的坐标旋转几何图形。这将修改现有的几何坐标

```
scale(sx, opt_sy, opt_anchor)
```

缩放几何图形(可选原点)。这将修改现有的几何坐标。sx`：x方向上的缩放因子；`sy`：Y轴上的缩放因子；`opt_anchor`：缩放原点(默认为几何范围的中心)

```
simplify(tolerance)
```

创建这个几何图形的简化版本

```
transform(source, destination)
```

将圆的每个坐标从一个坐标系变换到另一个坐标系。在适当的位置修改几何图形。如果不想修改几何图形，请首先`clone()`它，然后在克隆上使用此函数。在内部，一个圆目前由两点表示:圆心`[cx, cy]`和圆心右边的点`[cx + r, cy]`。这个`transform`函数只变换这两点。所以得到的几何形状也是一个圆，而这个圆并不等同于通过变换原圆的每一点得到的形状

```
translate(deltaX, deltaY)
```

翻转几何图形。这将修改现有的几何坐标。如果您想要一个新的几何体，那么首先`clone()`这个几何体

以下是`ol.geom.Geomtry`抽象基类创建的常见[子类模块](https://www.oschina.net/action/GoToLink?url=https%3A%2F%2Fopenlayers.org%2Fen%2Flatest%2Fapidoc%2Fmodule-ol_geom_SimpleGeometry-SimpleGeometry.html)：

###### 1)圆`ol.geom.Circle()`

方法

功能

```
applyTransform(transformFn)
```

对几何图形的每个坐标应用一个变换函数。在适当的位置修改几何图形。如果不想修改几何图形，请首先`clone()`它，然后在克隆上使用此函数

```
clone()
```

把几何图形复制一份

```
getCenter()
```

返回中心坐标

```
getFirstCoordinate()
```

返回几何图形的第一个坐标

```
getLastCoordinate()
```

返回几何图形的最后一个坐标

```
getLayout()
```

返回几何图形的`layout`

```
getRadius()
```

返回圆的半径

```
getType()
```

获取这个几何图形的类型

```
intersectsExtent(extent)
```

测试几何形状和经过的区域是否相交，返回布尔值

```
rotate(angle, anchor)
```

围绕给定的坐标旋转几何图形。这将修改现有的几何坐标。`angle`：以弧度为单位的旋转角度；`anchor`：旋转中心

```
scale(sx, opt_sy, opt_anchor)
```

缩放几何图形(可选原点)。这将修改现有的几何坐标。`sx`：x方向上的缩放因子；`sy`：Y轴上的缩放因子；`opt_anchor`：缩放原点(默认为几何范围的中心)

```
setCenter(center)
```

将圆心设置为`coordinate`

```
setCenterAndRadius(center, radius, opt_layout)
```

设置圆的中心(`coordinate`)和半径(`number`)

```
setRadius(radius)
```

设置圆的半径。半径的单位是投影的单位。

```
transform(source, destination)
```

将圆的每个坐标从一个坐标系变换到另一个坐标系。在适当的位置修改几何图形。如果不想修改几何图形，请首先`clone()`它，然后在克隆上使用此函数。在内部，一个圆目前由两点表示:圆心`[cx, cy]`和圆心右边的点`[cx + r, cy]`。这个`transform`函数只变换这两点。所以得到的几何形状也是一个，而这个圆并不等同于通过变换原圆的每一点得到的形状

```
translate(deltaX, deltaY)
```

f翻转几何图形。这将修改现有的几何坐标。如果您想要一个新的几何体，那么首先`clone()`这个几何体

###### 2)`ol.geom.LineString(coordinates, opt_layout)`

```
new ol.geom.LineString({
    coordinate:[],//坐标。对于内部使用，平面坐标结合opt_layout也可以接受
    layout: //Layout
})
```

方法

功能

```
appendCoordinate(coordinate)
```

将经过的坐标追加到`linestring`的坐标里

```
applyTransform(transformFn)
```

对几何图形的每个坐标应用一个变换函数。在适当的位置修改几何图形。如果不想修改几何图形，请首先`clone()`它，然后在克隆上使用此函数

```
clone()
```

把几何图形复制一份

```
forEachSegment(callback)
```

遍历每条线段，调用提供的回调函数。如果回调函数返回一个真值，则函数立即返回该值。否则函数返回`false`

```
getCoordinateAt(fraction, opt_dest)
```

沿着线段返回给定部分的坐标。`fraction`是一个介于0和1之间的数字，其中0是线段的开始，1是线段的末尾

```
getCoordinates()
```

返回线段的坐标

```
setCoordinates(coordinates, opt_layout)
```

s设置线段的坐标

```
getFirstCoordinate()
```

返回几何图形的第一个坐标

```
getLastCoordinate()
```

返回几何图形的最后一个坐标

```
getLayout()
```

返回几何图形的`Layout`

```
getLength()
```

在投影平面上返回线段的长度

```
getType()
```

得到这个几何图形的类型

```
intersectsExtent(extent)
```

测试几何形状和通过的范围是否相交

```
rotate(angle, anchor)
```

围绕给定的坐标旋转几何图形。这将修改现有的几何坐标

```
scale(sx, opt_sy, opt_anchor)
```

缩放几何图形(可选原点)。这将修改现有的几何坐标。sx`：x方向上的缩放因子；`sy`：Y轴上的缩放因子；`opt_anchor`：缩放原点(默认为几何范围的中心)

```
translate(deltaX, deltaY)
```

翻转几何图形。这将修改现有的几何坐标。如果您想要一个新的几何体，那么首先`clone()`这个几何体

###### 3)`ol.geom.Point(coordinates, opt_layout)`

```
new ol.geom.Point()
```

方法

功能

```
applyTransform(transformFn)
```

对几何图形的每个坐标应用一个变换函数。在适当的位置修改几何图形。如果不想修改几何图形，请首先`clone()`它，然后在克隆上使用此函数

```
clone()
```

把几何图形复制一份

```
getCoordinates()
```

返回点的坐标

```
setCoordinates(coordinates, opt_layout)
```

设置点的坐标

```
getFirstCoordinate()
```

返回几何图形的第一个坐标

```
getLastCoordinate()
```

返回几何图形的最后一个坐标

```
getLayout()
```

返回几何图形的`Layout`

```
getType()
```

得到这个几何图形的类型

```
intersectsExtent(extent)
```

测试几何形状和通过的范围是否相交

```
rotate(angle, anchor)
```

围绕给定的坐标旋转几何图形。这将修改现有的几何坐标

```
scale(sx, opt_sy, opt_anchor)
```

缩放几何图形(可选原点)。这将修改现有的几何坐标。sx`：x方向上的缩放因子；`sy`：Y轴上的缩放因子；`opt_anchor`：缩放原点(默认为几何范围的中心)

```
translate(deltaX, deltaY)
```

翻转几何图形。这将修改现有的几何坐标。如果您想要一个新的几何体，那么首先`clone()`这个几何体

###### (4)`ol.geom.Polygon()`

多边形几何图形。

```
new ol.geom.Polygon({
    coordinates:[],//定义多边形的线性环的数组
    layout:,
    ends:[],//末端（平面坐标内部使用）
})
```

方法

功能

```
applyTransform(transformFn)
```

对几何图形的每个坐标应用一个变换函数。在适当的位置修改几何图形。如果不想修改几何图形，请首先`clone()`它，然后在克隆上使用此函数

```
appendLinearRing(linearRing)
```

在多边形上追加线性环

```
clone()
```

把几何图形复制一份

```
getCoordinates()
```

返回点的坐标

```
setCoordinates(coordinates, opt_layout)
```

设置点的坐标

```
getFirstCoordinate()
```

返回几何图形的第一个坐标

```
getLastCoordinate()
```

返回几何图形的最后一个坐标

```
getInteriorPoint()
```

返回多边形的内部点

```
getLinearRing(index)
```

返回多边形几何的第n个线性环。如果给定索引超出范围，则返回null。外部线性环在索引0处可用，而内部环在索引1及以上处可用

```
getLinearRings()
```

返回多边形的线性环

```
getLinearRingCount()
```

返回多边形的环数，这包括外部环和任何内部环

```
getLayout()
```

返回几何图形的`Layout`

```
getType()
```

得到这个几何图形的类型

```
getArea()
```

返回投影平面上多边形的面积

```
intersectsExtent(extent)
```

测试几何形状和通过的范围是否相交

```
rotate(angle, anchor)
```

围绕给定的坐标旋转几何图形。这将修改现有的几何坐标

```
scale(sx, opt_sy, opt_anchor)
```

缩放几何图形(可选原点)。这将修改现有的几何坐标。sx`：x方向上的缩放因子；`sy`：Y轴上的缩放因子；`opt_anchor`：缩放原点(默认为几何范围的中心)

```
translate(deltaX, deltaY)
```

翻转几何图形。这将修改现有的几何坐标。如果您想要一个新的几何体，那么首先`clone()`这个几何体

#### (4)`ol.layer.VectorTile()`

矢量平铺图层。

图层用于客户端呈现矢量平铺数据。

```
new ol.layer.Vector({//以下为图层的属性选项， 都可设置，所以皆有getter/setter    opacity:2,//透明度 区间范围为(0, 1) 默认为1    visible:true,//显示属性 布尔值 默认为true    extent:[],//图层渲染的边界范围。该层将不会在此范围之外呈现    zIndex:2,//图层渲染的索引层级。在渲染时，图层将被排序，首先是z-idnex，然后是位置，当为undefined时，对于添加到映射的layers集合中的层，zIndex为0，或者当使用该层的setMap()方法时，zIndex为无穷大    minResolution:3,//该层可见的最小分辨率(包括在内)    maxResolution:6,//该层可见的最大分辨率（包括在内）    renderOrder:,//呈现顺序。函数用于在呈现前对特性进行排序。默认情况下，特性是按照创建它们的顺序绘制的。使用null来避免排序，但是得到一个未定义的绘制顺序    renderBuffer:100,//默认为100 缓冲区    renderMode:'vector',//默认为'vector' 矢量图层的渲染模式    source:new ol.source.VectorSource(),//图层源    map: ,//把图层覆盖在地图上，地图不会在它的图层集合中管理这个图层，这个图层将被呈现在顶部，这对于临时层非常有用    declutter:false,//默认为false 整理图片和文字。清理应用于所有图像和文本样式，优先级由样式的z-index定义。z-index指数越低，优先级越高    style:new ol.style.Style(),//图层样式    updateWhileAnimating:false,//默认为false     updateWhileInteracting:false,//默认为false    preload:,//    renderOrder:,//    useInterimTilesOnError:true,//错误时使用临时贴片 默认true})
```

### 3、视图`view`

设置视图`view`由三种状态决定：`center`中心、`resolution`分辨率、`rotation`旋转，每个状态都有相应的`getter`和`setter`。

可以在视图里定义地图中心点、层级、分辨率、旋转以及地图投影等。

视图对象受到约束，主要有分辨率约束、旋转约束、中心约束。

**分辨率约束**切换到特定分辨率时，特定分辨率主要由以下选项决定：`resolutions`、`maxResolution`、`maxZoom`、`zoomFactor`。如果已经设置`resolutions`，其他选项就可忽略。

**旋转约束**会切换到特定的角度。它由以下选项决定:`enableRotation`和`constrainRotation`。在默认情况下，当接近水平线时，旋转值会突然变为零。

**中心约束**由范围选项决定。默认情况下，中心完全不受约束。

#### (1)视图选项

##### 1)中心点`center`

视图的初始中心，中心的坐标系由投影`projection`指定，如果未设置此参数，则不会获取层源，但是之后可以使用`#setCenter`设置中心。

```
let center = ol.proj.fromLonLat([longitude, latitude]);//未限制地图范围时
let center = ol.proj.transform([minX, minY, maxX, maxY]，'EPSG:4326', 'EPSG:3857');//限制地图显示范围时设置中心点  X代表经度， Y代表纬度
```

`ol.proj.transform([], "EPSG:", "EPSG:")`是经纬度投影转换

- 获取中心：`map.getView().getCenter()`
- 设置中心：`map.getView().setCenter(center)`

##### 2)投影`projection`

视图拥有`projection`投影，投影决定了中心的坐标系，其单位决定了分辨率的单位(每个像素的投影单位)。默认投影为球面墨卡托(`EPSG:3857`)。

- 获取投影：`map.getView().getProjection()`
- 设置投影：`map.getView().setProjection()`

##### 3)分辨率`resolution`

视图的初始分辨率，单位是每像素的投影单位(例如米每像素)。

另一种方法是设置缩放`zoom`。缩放可以设置：最大层级`maxZoom`、最小层级`minZoom`以及当前层级`zoom`

```
let view = new ol.View({
    // center: center,
    zoom: curZoom,
    minZoom: minZoom,
    maxZoom: maxZoom,
});
```

- 获取分辨率：`map.getView().getResolution()`
- 获取给定范围(以映射单元为单位)和大小(以像素为单位)的分辨率：`map.getView().getResolutionForExtent(extent, opt_size)`；
- 获取缩放级别的分辨率：`map.getView().getResolutionForZoom(zoom)`；
- 获取视图最大值分辨率：`map.getView().getMaxResolution()`；
- 获取视图最小值分辨率：`map.getView().getMinResolution()`；
- 设置分辨率：`map.getView().setResolution(resolution)`

##### 4)旋转`rotation`

初始旋转角度为弧度(正顺时针旋转，0表示向北)。

- 获取旋转调用方法`map.getView().getRotation()`；
- 设置旋转调用方法`map.getView().setRotation(rotation);`

##### 5)缩放`zoom`

仅在未定义分辨率时使用。

缩放级别用于计算视图的初始分辨率。初始分辨率是使用`#constrainResolution`方法确定的。

- 获取缩放层级：`map.getView().getZoom()`；
- 获取最大缩放层级：`map.getView().getMaxZoom()`；
- 获取最小缩放层级：`map.getView().getMinZoom()`；
- 获取缩放层级的分辨率：`map.getView().getZoomForResolution(resolution)`；
- 设置缩放层级：`map.getView().setZoom(zoom)`；
- 设置最大缩放层级：`map.getView().setMaxZoom(zoom)`；
- 设置最小缩放层级：`map.getView().setMinZoom(zoom)`；

##### 6)旋转约束`constrainRotation`

旋转约束。`false`为未约束，`true`为未约束但是接近于0。数字限制了旋转到该值的数量。

##### 7)启用旋转`enableRotation`

如果为`false`，则始终使用将旋转设置为零的旋转约束。如果启用为`false`，则没有效果。

##### 8)约束范围`extent`

中心点不能超出这个范围。

#### (2)视图方法

##### 1)动画`animate(var_args)`

**单个动画**

动画视图。视图的中心、缩放(或分辨率)和旋转可以通过动画来实现视图状态之间的平滑转换。

默认情况下，动画持续时间为1秒，并且类型为`in-and-out easing`。

通过设置持续时间`duration`(以毫秒为单位)和缓动选项`easing`(参见模块:[ol/easing](https://www.oschina.net/action/GoToLink?url=https%3A%2F%2Fopenlayers.org%2Fen%2Flatest%2Fapidoc%2Fmodule-ol_easing.html))来定制此行为。

`easing`:

- `easeIn`：平缓加速
- `easeOut`：平缓减速
- `inAndOut`：平缓开始，先加速，再减速
- `linear`：匀速
- `upAndDown`：平缓开始，加速，最后再减速。这与模块的一般行为相同:`ol/easing~inAndOut`，但是最终的减速被延迟了

**多个动画**

要将多个动画连接在一起，请使用多个动画对象调用该方法。

如果提供一个函数作为`animate`方法的最后一个参数，它将在动画系列的末尾被调用。

如果动画系列独立完成，回调函数将被调用`true`;如果动画系列被取消，回调函数将被调用`false`。

**取消动画**

动画通过用户交互(例如拖动地图)或调用`view.setCenter()`、`view.setResolution()`或`view.setRotation()`(或调用其中一个方法的另一个方法)来取消。

##### 2)取消动画`cancelAnimations()`

取消任何正在进行的动画。

##### (3)`getAnimating()`

确定视图是否处于动画状态。返回布尔值。

##### 4)计算范围`calculateExtent(opt_size)`

计算当前视图状态的范围和传递的大小。`opt_size`指盒子像素尺寸，如未提供，将使用此视图的第一个映射的大小。

尺寸是盒子的像素尺寸，计算的范围应该与之匹配。

想要获取整个底图映射的范围，使用`map.getSize()`

##### 5)`centerOn(coordinate, size, position)`

以坐标和视图位置为中心。

- `coordinate`：坐标点
- `size`：盒子像素尺寸
- `position`：视图的居中位置

### 4、交互动作`interaction`

通常只用于创建子类，而不在应用程序中实例化。

用于更改映射状态的用户操作。有些类似于控件，但不与`DOM`元素关联。

虽然交互没有`DOM`元素，但是它们中的一些会呈现向量，因此在屏幕上是可见的。

添加交互动作使用：`map.addInteraction(interaction);`

[参考于此](https://www.oschina.net/action/GoToLink?url=https%3A%2F%2Fblog.csdn.net%2Fqingyafan%2Farticle%2Fdetails%2F45887109)

`OpenLayers` 中可实例化的子类及其功能如下：

可实例化子类

功能

```
doubleclickzoom interaction
```

双击放大交互功能

```
draganddrop
```

以“拖文件到地图中”的交互添加图层

```
dragbox
```

拉框，用于划定一个矩形范围，常用于放大地图

```
dragpan
```

拖拽平移地图

```
dragrotateandzoom
```

拖拽方式进行缩放和旋转地图

```
dragrotate
```

拖拽方式旋转地图

```
dragzoom
```

拖拽方式缩放地图

```
draw
```

绘制地理要素功能

```
interaction defaults
```

默认添加的交互功能

```
keyboardpan
```

键盘方式平移地图

```
keyboardzoom
```

键盘方式缩放地图

```
select
```

选择要素功能

```
modify
```

更改要素

```
mousewheelzoom
```

鼠标滚轮缩放功能

```
pinchrotate
```

手指旋转地图，针对触摸屏

```
pinchzoom
```

手指进行缩放，针对触摸屏

```
pointer
```

鼠标的用户自定义事件基类

```
snap
```

鼠标捕捉，当鼠标距离某个要素一定距离之内，自动吸附到要素

#### (1)默认交互功能`ol.interaction.defaylts()`

主要是最为常用的功能，如缩放、平移和旋转地图等，具体功能有如下这些：

默认交互

功能

```
ol.interaction.DragRotate
```

鼠标拖拽旋转，一般配合一个键盘按键辅助

```
ol.interaction.DragZoom
```

鼠标拖拽缩放，一般配合一个键盘按键辅助

```
ol.interaction.DoubleClickZoom
```

鼠标或手指双击缩放地图

```
ol.interaction.PinchRotate
```

两个手指旋转地图，针对触摸屏

```
ol.interaction.PinchZoom
```

两个手指缩放地图，针对触摸屏

```
ol.interaction.DragPan
```

鼠标或手指拖拽平移地图

```
ol.interaction.KeyboardZoom
```

使用键盘 `+` 和 `-` 按键进行缩放

```
ol.interaction.KeyboardPan
```

使用键盘方向键平移地图

```
ol.interaction.MouseWheelZoom
```

鼠标滚轮缩放地图

#### (2)针对矢量图层元素的交互功能

##### 1）选择`ol.interaction.Select()`

选择矢量元素的交互功能。

默认情况下，所选矢量元素的样式不相同，因此这种交互可以用于可视化高亮显示，以及为其他操作(如修改或输出)选择特性。

选定的矢量元素将被添加到内部非托管图层。

有三种方式控制矢量元素的选择：

- 使用由`condition`定义的浏览器事件和`toggle`切换的`add`/`remove`以及`multi`选项
- 一个`layer`过滤器
- 一个使用`filter`选项的进一步矢量元素过滤器

##### 2)绘制`ol.interaction.Draw()`

用于绘制特征几何图形的交互功能。

绘制交互允许绘制几何地理要素，可选一个参数为对象，可包含参数如下：

- `features`：绘制的要素的目标集合；
- `source`：绘制的要素的目标图层源；
- `snapTolerance`：自动吸附完成点的像素距离，也就是说当鼠标位置距离闭合点小于该值设置的时候，会自动吸附到闭合点，默认值是 `12`；
- `type`：绘制的地理要素类型，`ol.geom.GeometryType`类型，包含 `Point`、 `LineString`、 `Polygon`、`MultiPoint`、`MultiLineString` 或者 `MultiPolygon`；
- `minPointsPerRing`：绘制一个多边形需要的点数最小值，数值类型，默认是 `3`；
- `style`：要素素描的样式；
- `geometryName`：绘制的地理要素的名称，`string`类型

##### 3)修改`ol.interaction.Modify()`

用于修改矢量元素几何图形的交互功能。

若想修改已添加到存在的矢量源中的矢量元素，需要使用`modify`选项构建修改交互动作。

如若想修改集合中的矢量元素（比如用选择交互的集合），需要使用`features`选项构建交互。该交互必须使用`source`或者`features`构建。

默认情况下，当按下`alt`键时，交互允许删除顶点。想要使用不同的删除条件配置交互，请使用`deleteCondition`选项。

### 5、控件`Control`

控件是一个可见的小部件，其DOM元素位于屏幕上的固定位置。它们可以包含用户输入(按钮)，或者只是提供信息;位置是使用CSS确定的。这是一个虚基类，不负责实例化特定的控件。

默认情况下，这些元素被放置在具有CSS类名称`ol-overlaycontainer-stopevent`的容器中，但是可以使用任何外部DOM元素。

```
let myControl = new ol.control.Control({//定义一个控件
    element:myElement
})
//然后添加到地图上
map.addControl(myControl);
```

主要的属性选项有：

- `element`：DOM元素，元素是控件的容器元素。只有在开发自定义控件时才需要指定这一点
- `render`：重新呈现控件时调用的函数。这在`requestAnimationFrame`回调中调用
- `target`：DOM元素，想要控件在映射的视图端口之外呈现，需要指定目标对象

其中包含的控件有：

控件

功能

```
controldefaults
```

地图默认包含的控件，包含缩放控件和旋转控件

```
fullscreencontrol
```

全屏控件，用于全屏幕查看地图

```
mousepositioncontrol
```

鼠标位置控件，显示鼠标所在地图位置的坐标，可以自定义投影

```
overviewmapcontrol
```

地图全局视图控件

```
rotatecontrol
```

地图旋转控件

```
scalelinecontrol
```

比例尺控件

```
zoomcontrol
```

缩放控件

```
zoomslidercontrol
```

缩放刻度控件

```
zoomtoextentcontrol
```

缩放到全局控件

### 6、叠加层`Overlay`

要显示在地图上方并附加到单个地图位置的元素。与控件不同的是，它们不在屏幕上的固定位置，而是绑定到地理坐标上，因此平移地图将移动 `overlay` ，而不是控件。

```
<div id="map">
    <div id="popup">
        
    </div>
</div>

let popup = new ol.Overlay({
    element:document.getElementById('popup'),
    ...
});
popup.setPosition(coordinate);
map.addOverlay(popup);
```

**Overlay选项**

#### (1)`id`

设置 `overlay`的 `id`，字符串类型。

- 获取`id`：`map.getOverlayById(id)`或者`overlay.getId()`

#### (2)`element`

`overlay` 元素，`DOM`元素

- 获取：`overlay.getElement()`
- 设置：`overlay.setElement(element)`

#### (3)`offset`

偏移量(以像素为单位)，用于定位 `overlay` ，数组类型，默认为[0, 0]：

- 数组第一个元素为水平偏移，正右负左；
- 数组第二个元素为垂直，正下负上；
- 获取偏移值：`overlay.getOffset()`
- 设置偏移值：`overlay.setOffset(offset)`

#### (4)`position`

地图投影中的位置。

- 获取：`overlay.getPosition()`
- 设置：`overlay.setPosition(position)`，如果位置未定义`undefined`，则覆盖被隐藏。

#### (5)`positioning`

定义 `overlay` 相对于其位置属性的实际位置，默认为`top-left`，还有`'bottom-left'`, `'bottom-center'`, `'bottom-right'`, `'center-left'`, `'center-center'`, `'center-right'`, `'top-left'`,`'top-center'`, and `'top-right'`.

- 获取：`overlay.getPositioning()`
- 设置：`overlay.setPositioning(positioning)`

#### (6)`autoPan`

默认为`false`，如果设置为true，则在调用`setPosition`将平移映射，以便在当前视图中 `overlay` 完全可见。

#### (7)`autoPanAnimation`

动画选项用于平移 `overlay` 到视图中。此动画仅在启用`autoPan`时使用。可以提供一个持续时间和缓动来定制动画。

#### (8)`stopEvent`

默认为`true`，是否应该停止到map视图端口的事件传播。

- 如果为`true`，则将 `overlay` 放置在与控件相同的容器中（CSS class name`ol-overlaycontainer-stopevent`）
- 如果为`false`，它用`className`属性指定的`CSS`类名放置在容器中。

#### (9)`className`

`CSS class name`.

#### (10)`autoPanMargin`

地图自动平移时，地图边缘与 `overlay` 的留白（空隙），单位是像素，默认是 20像素

### 7、投影`Projections`

需要给所有坐标和范围提供视图投影系（默认是`EPAG:3857`）。

转换投影系，使用`ol.proj.transform()`和`ol.proj.transformExtendt`进行转换

#### (1）、`ol.proj`

##### 1）`ol.proj.addCoordinateTransforms(source, destination, forward, inverse)`

注册坐标转换函数来转换源投影和目标投影之间的坐标。正、反函数转换坐标对;此函数将这些转换为内部使用的处理区段和坐标数组的函数

- `source`：源投影
- `destination`：目标投影
- `forward`：接受`ol`的正向变换函数(即从源投影到目标投影)。作为参数，并返回转换后的`ol.Coordinate`
- `inverse`：接受`ol`的逆变换函数(即从目标投影到源投影)。作为参数，并返回转换后的`ol.Coordinate`

##### 2)`ol.proj.addEquivalentProjections(projections)`

注册不改变坐标的转换函数。它们允许在具有相同含义的投影之间进行转换。

##### 3）`ol.proj.addProjection(projection)`

将投影对象添加到受支持的投影列表中，这些投影可以通过它们的`SRS`码进行查找。

##### 4)`ol.proj.equivalent(projection1, projection2)`

检查两个投影是否相同，即一个投影中的每个坐标确实表示另一个投影中的相同地理点。

##### 5)`ol.proj.fromLonLat(coordinate, opt_projection)`

将经纬度坐标转换为不同的投影

- `coordinate`：经纬度数组，经度在前，纬度在后
- `projection`：目标投影。默认是`Web Mercator`，即`“EPSG: 3857”`

##### 6)`ol.proj.get(projectionLike)`

获取指定代码的投影对象。

##### 7)`ol.proj.getTransform(source, destination)`

给定类似于投影的对象，搜索转换函数将坐标数组从源投影转换为目标投影。

##### 8)`ol.proj.setProj4(proj4)`

proj4注册。如果没有显式注册，则假定proj4js将加载在全局名称空间中

```
ol.proj.setProj4(proj4);
```

##### 9)`ol.proj.toLonLat(coordinate, opt_projection)`

将坐标转换为经度/纬度

- `coordinate`：投影坐标
- `projection`：坐标的投影，默认是`Web Mercator`，即`“EPSG: 3857”`

##### 10)`ol.proj.transform(coordinate, source, destination)`

将坐标从源投影转换为目标投影，这将返回一个新的坐标(并且不修改原始坐标)。

- `coordinate`：坐标
- `source`：源投影
- `destination`：目标投影

##### 11)`ol.proj.transformExtent`

将范围从源投影转换为目标投影，这将返回一个新范围(并且不修改原始范围)。

##### 12)`ol.proj.Units{string}`

投影单位：`'degrees'`, `'ft'`, `'m'`, `'pixels'`, `'tile-pixels'` or `'us-ft'`