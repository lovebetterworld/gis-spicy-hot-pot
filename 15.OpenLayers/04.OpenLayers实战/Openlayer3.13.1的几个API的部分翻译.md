- [Openlayer3.13.1的几个API的部分翻译 - 作业部落 Cmd Markdown 编辑阅读器 (zybuluo.com)](https://www.zybuluo.com/mgsky1/note/1132768)

# 说明

1、需求：显示地图，同时，在地图上显示标记，并且在点击标记后显示可定制弹窗
2、本API基于版本：3.13.1
3、本API说明针对以上需求提炼出相关API，全部引文请参考[OpenLayers3 API](https://doc.acmsmu.cn/openlayer3/)

## ol.Map类

Map是OpenLayers的核心部件。一个地图若要被渲染的话，一个view，一个或多个的layer还有一个目标容器是必须的。

#### 1、new ol.Map(options)

构造方法，关于option的说明，这里只说用到的，具体参见[这里](https://doc.acmsmu.cn/openlayer3/ol.Map.html)。

| 名称     | 类型                                                         | 描述                                                         |
| :------- | :----------------------------------------------------------- | :----------------------------------------------------------- |
| `target` | Element\|string\|undefined                                   | map的容器，可以是element自身或element的`id`。如果在构造的时候没有指定，必须调用[`ol.Map#setTarget`](https://doc.acmsmu.cn/openlayer3/ol.Map.html#setTarget)来渲染地图。 |
| `layers` | Array.<[ol.layer.Base](https://doc.acmsmu.cn/openlayer3/ol.layer.Base.html)>\|[ol.Collection](https://doc.acmsmu.cn/openlayer3/ol.Collection.html).<[ol.layer.Base>](https://doc.acmsmu.cn/openlayer3/ol.layer.Base.html)\| undefined | layers。如果没有定义，一个没有layer的地图会被渲染。注意layer是按照提供的顺序渲染的，所以，如果你愿意的话，举个例子，一个矢量层要在瓦片层上方出现，它必须在瓦片层之后被定义。 |
| `view`   | [ol.View](https://doc.acmsmu.cn/openlayer3/ol.View.html)\| undefined | 地图的视图，没有图层源被获取，除非它在构造时指定或者通过[`ol.Map#setView`](https://doc.acmsmu.cn/openlayer3/ol.Map.html#setView)来进行指定。 |

#### 2、getEventPixel(event)

返回浏览器事件发生时，相对于viewport的地图的像素位置。

| 名称    | 类型  | 描述 |
| :------ | :---- | :--- |
| `event` | Event | 事件 |

**返回值:**
像素。

#### 3、forEachFeatureAtPixel(pixel, callback, opt_this, opt_layerFilter, opt_this2)

探测在viewport上被像素截断的feature,并且对每一个被截断的feature执行回掉函数。在探测中被包含的Layer能够通过`opt_layerFilter`进行设置。

| 名称          | 类型                                                       | 描述                                                         |
| :------------ | :--------------------------------------------------------- | :----------------------------------------------------------- |
| `pixel`       | [ol.Pixe](https://doc.acmsmu.cn/openlayer3/ol.html#.Pixel) | 像素                                                         |
| `callback`    | function                                                   | Feature的回掉函数。这个回掉函数将调用两个参数。第一个参数是在像素上的一个`feature`或者`render feature`，第二个是feature所在的`layer`，如果是没有整合的layer，值将为空。回掉函数能够返回一个真值来停止探测。 |
| `this`        | S                                                          | 当执行`callback`时被当作`this`使用的值                       |
| `layerFilter` | function                                                   | Layer过滤函数，这个过滤器将会接收一个参数，是[`layer-candidate`](https://doc.acmsmu.cn/openlayer3/ol.layer.Layer.html)，并且这个函数应该返回一个布尔值。只有可见的以及函数返回`true`值的layer将会被测试是否含有feature。默认情况下，所有可见的layer都会被测试。 |
| `this2`       | U                                                          | 当执行`layerFilter`时被当作`this`使用的值。                  |

**注：在后续版本中(如4.6.5)，函数定义变为[forEachFeatureAtPixel(pixel, callback, opt_options)](http://openlayers.org/en/latest/apidoc/ol.Map.html#forEachFeatureAtPixel)，实测这个版本的定义在3.13.1版本中也可使用。**
**返回值:**
回掉函数的返回值，比如，最后一次回掉的返回值，或者第一次返回的真值。

#### 4、addOverlay(overlay)

将给予的overlay添加到map上

| 名称    | 类型                                                         | 描述    |
| :------ | :----------------------------------------------------------- | :------ |
| overlay | [ol.overlay](https://doc.acmsmu.cn/openlayer3/ol.Overlay.html) | Overlay |

#### 5、on(type, listener, opt_this)

监听某一个确切事件。

| 名称       | 类型     | 描述                           |
| :--------- | :------- | :----------------------------- |
| `type`     | string   | Array.< string>                |
| `listener` | function | 监听器函数                     |
| `this`     | Object   | 在`listener`中作为`this`的对象 |

**返回值:**
监听器的唯一ID

#### 6、addLayer(layer)

将给予的layer添加到map的顶层。如果你想添加在栈中其他地方的layer，使用`getLayers()`和在`ol.Collection`中的可用方法。

| 名称    | 类型                                                         | 描述 |
| :------ | :----------------------------------------------------------- | :--- |
| `layer` | [ol.layer.Base](https://doc.acmsmu.cn/openlayer3/ol.layer.Base.html) | 图层 |

#### 7、getView()

获取与map相关联的view。一个view管理着像center、resolution的属性。
**返回值:**
控制这个map的view

## ol.View类

一个ol.View对象代表地图上的一个简单2D视图
这是一个随着地图的中心、分辨率、旋转而做出对应行动的对象。

#### 1、new ol.View(opt_options)

构造方法，关于opt_options的说明，这里只说用到的，具体参见[这里](https://doc.acmsmu.cn/openlayer3/ol.View.html)。

| 名称         | 类型                                                         | 描述                                                         |
| :----------- | :----------------------------------------------------------- | :----------------------------------------------------------- |
| `projection` | [ol.proj.ProjectionLike](https://doc.acmsmu.cn/openlayer3/ol.proj.html#.ProjectionLike) | 投影坐标系，默认为`EPSG:3857`(墨卡托)                        |
| `center`     | [ol.Coordinate](https://doc.acmsmu.cn/openlayer3/ol.html#.Coordinate)\|undefined | 视图的初始中心。坐标系系统的中心由`projection`选项指定。默认是`undefined`，并且如果它不设置的话，图层源不会被获取。 |
| `zoom`       | number\|undefined                                            | 只有在`resolution`没有定义的时候使用。Zoom等级用于初始化计算视图的分辨率。初始分辨率取决于`ol.View#constrainResolution`。 |

#### 2、fit(geometry, size, opt_options)

根据给定的地图大小和边界来拟合给定的几何图形或范围。 大小是盒子的像素尺寸以适合程度。 在大多数情况下，你会希望使用地图大小，即map.getSize（），站在地图的角度来考虑。

| 名称       | 类型                                | 描述         |
| :--------- | :---------------------------------- | :----------- |
| `geometry` | ol.geom.SimpleGeometry \| ol.Extent | Geometry     |
| `size`     | ol.Size                             | 像素盒子大小 |
| `option`   | Options                             | 选项         |

## ol.Overlay类

Overlay是一个能在地图上显示并且依附在地图上单一位置的元素。像[`ol.control.Control`](https://doc.acmsmu.cn/openlayer3/ol.control.Control.html),Overlay是可见的小组件。不像Controls，它们不固定在屏幕上的某一个位置，但是它们与地理的坐标系进行绑定，所以平移地图时将移动Overlay而不是一个Control。

例子：

```
var popup = new ol.Overlay({  element: document.getElementById('popup')});popup.setPosition(coordinate);map.addOverlay(popup);
```

#### 1、new ol.Overlay(options)

构造方法，关于options的说明（只列举用到的，其他更具体的设置，参看[这里](https://doc.acmsmu.cn/openlayer3/ol.Overlay.html)）

| 名称      | 类型                      | 描述                                                         |
| :-------- | :------------------------ | :----------------------------------------------------------- |
| `id`      | number\|String\|undefined | 设置overlay的id。这个overlay的id可以与[`ol.Map#getOverlayById`](https://doc.acmsmu.cn/openlayer3/ol.Map.html#getOverlayById)一起使用。 |
| `element` | Element\|undefined        | overlay元素。*可以是一个div标签的id*                         |
| `autoPan` | boolean\|undefined        | 如果设置为`true`，地图在平移的时候调用`setposition`,以至于overlay能够在当前的viewport中完全可见。默认值是`false`。 |

#### 2、setPosition(position)

这是overlay的位置。如果位置是`undefined`，overlay被隐藏。

| 名称       | 类型                                                         | 描述                        |
| :--------- | :----------------------------------------------------------- | :-------------------------- |
| `position` | [ol.Coordinate](https://doc.acmsmu.cn/openlayer3/ol.html#.Coordinate)\|undefined | 固定这个overlay的具体位置。 |

## ol.source.Vector类

为矢量层的feature提供一个源(容器)。通过这个源(容器)提供的矢量feature是适合编辑的。参阅[ol.source.VectorTile](https://doc.acmsmu.cn/openlayer3/ol.source.VectorTile.html)中为渲染优化的矢量数据。

#### 1、new ol.source.Vector(opt_options)

构造方法，关于`opt_option`的说明，请参阅[这里](https://doc.acmsmu.cn/openlayer3/ol.source.Vector.html)

#### 2、addFeature(feature)

为源(容器)中添加单一的feature。如果你想一次性添加多个feature，调用[source.addFeatures()](https://doc.acmsmu.cn/openlayer3/ol.source.Vector.html#addFeatures)代替。

| 名称      | 类型                                                         | 描述            |
| :-------- | :----------------------------------------------------------- | :-------------- |
| `feature` | [ol.feature](https://doc.acmsmu.cn/openlayer3/ol.Feature.html) | 要添加的feature |

## ol.Feature类

它是一个矢量对象，是一个地理的feature，拥有几何形状和其他属性特征，类似矢量feature中的GeoJSON。
Feature能够使用`setStyle`独立地设置样式；否则它们使用它们矢量层的样式。
注意在feature对象中的属性会被设置成[`ol.Object`](https://doc.acmsmu.cn/openlayer3/ol.Object.html)属性，所以它们是可见的，并且有get/set访问方法。

通常，一个feature有一个单一的geometry属性。你能使用`setGeometry`属性设置geometry并且使用`getGeometry`来获得它。使用属性在一个feature中存储超过一个的grometry是可能的。但是在默认情况下，geometry使用属性名为`geometry`的值进行渲染。如果你想使用其他geometry属性进行渲染，使用`setGeometryName`方法来改变与这个feature对象所绑定的geometry。比如：

```
var feature = new ol.Feature({  geometry: new ol.geom.Polygon(polyCoords),  labelPoint: new ol.geom.Point(labelCoords),  name: 'My Polygon'});// 获得多边形geometryvar poly = feature.getGeometry();// 使用labelPoint的坐标系将这个feature以点进行渲染feature.setGeometryName('labelPoint');// 获得点的geometryvar point = feature.getGeometry();
```

#### 1、new ol.Feature(opt_geometryOrProperties)

构造方法

| 名称                 | 类型                                                         | 描述                                                         |
| :------------------- | :----------------------------------------------------------- | :----------------------------------------------------------- |
| geometryOrProperties | [ol.geom.Geometry](https://doc.acmsmu.cn/openlayer3/ol.geom.Geometry.html)\|Object.< string, *>= | 你可以直接通过Geometry对象设置或者一个包含属性的[对象字面量](https://blog.csdn.net/yukycookie/article/details/53369640)。如果你通过对象字面量设置，你可能需要包含一个与`geometry`键绑定的值。 |

## ol.geom.Point类

Point geometry

继承关系：
![img](http://xxx.fishc.com/album/201805/03/101920icvn5l0055ia5ici.png)

#### 1、new ol.geom.Point(coordinates, opt_layout)

构造方法

| 名称          | 类型                                                         | 描述   |
| :------------ | :----------------------------------------------------------- | :----- |
| `coordinates` | [ol.Coordinate](https://doc.acmsmu.cn/openlayer3/ol.html#.Coordinate) | 坐标系 |
| `layout`      | [ol.geom.GeometryLayout](https://doc.acmsmu.cn/openlayer3/ol.geom.html#.GeometryLayout) | 布局   |

## ol.style.Style类

渲染矢量feature的样式容器。任何通过`set*()`方法对样式或其子样式进行的改变，直到这个feature或layer重新渲染时才会起效。

#### 1、new ol.style.Style(opt_options)

构造方法，关于opt_option的说明，这里只说用到的，具体参见[这里](https://doc.acmsmu.cn/openlayer3/ol.style.Style.html)。这个opt_option就是样式设置的选项。

| 名称    | 类型                                                         | 描述     |
| :------ | :----------------------------------------------------------- | :------- |
| `image` | [ol.style.Image](https://doc.acmsmu.cn/openlayer3/ol.style.Image.html)\| undefined | 图片样式 |

## ol.style.Icon类

为矢量feature设置图标样式

继承关系：
![img](http://xxx.fishc.com/album/201805/03/104133tuzy198zt9wtq6yw.png)

#### 1、new ol.style.Icon(opt_options)

构造方法，关于opt_option的说明，这里只说用到的，具体参见[这里](https://doc.acmsmu.cn/openlayer3/ol.style.Icon.html)。这个opt_options就是样式设置的选项。

| 名称      | 类型              | 说明                    |
| :-------- | :---------------- | :---------------------- |
| `opacity` | number\|undefined | 图标的透明度，默认是`1` |
| `src`     | string            | 图片的URI。必须。       |

## ol.layer.Vector类

矢量数据在客户端渲染。注意任何在option中设置都会被设置为layer对象上的`ol.object`属性；举个例子，在option中设置`title: 'My Title'`，意味着`title`是可见的，并且拥有get/set方法。

#### 1、new ol.layer.Vector(opt_options)

构造方法，关于opt_option的说明，这里只说用到的，具体参见[这里](https://doc.acmsmu.cn/openlayer3/ol.layer.Vector.html)。这个opt_options就是样式设置的选项。

| 名称     | 类型                                                         | 描述                                                         |
| :------- | :----------------------------------------------------------- | :----------------------------------------------------------- |
| `source` | [ol.source.Vector](https://doc.acmsmu.cn/openlayer3/ol.layer.Vector.html) | 源。必须。                                                   |
| `style`  | [ol.style.Style](https://doc.acmsmu.cn/openlayer3/ol.style.Style.html)\|Array.<[ol.style.Style](https://doc.acmsmu.cn/openlayer3/ol.style.Style.html)>\| [ol.style.StyleFunction](https://doc.acmsmu.cn/openlayer3/ol.style.html#.StyleFunction)\|undefined | layer的样式。参看[`ol.style`](https://doc.acmsmu.cn/openlayer3/ol.style.html)，如果这个属性没有被定义的默认样式。 |

## ol.layer.Tile类

对以特定分辨率的缩放级别，组织网格中预渲染的图层源。注意任何设置在option中的属性将会在layer对象中被设置成`ol.Object`属性。举个例子，在option中设置`title: 'My Title'`，意味着`title`是可见的，并且拥有get/set方法。

#### 1、new ol.layer.Tile(opt_options)

构造方法，关于opt_option的说明，这里只说用到的，具体参见[这里](https://doc.acmsmu.cn/openlayer3/ol.layer.Tile.html)。这个opt_options就是样式设置的选项。

| 名称     | 类别                                                         | 描述             |
| :------- | :----------------------------------------------------------- | :--------------- |
| `source` | [ol.source.Tile](https://doc.acmsmu.cn/openlayer3/ol.source.Tile.html) | 层的数据源。必须 |

## ol.source.TileWMS类

从WMS服务获取瓦片数据图层源。

继承关系：
![img](http://xxx.fishc.com/album/201805/03/143302fztgl9lbt6berseb.png)

#### 1、new ol.source.TileWMS(opt_options)

构造方法，关于opt_option的说明，这里只说用到的，具体参见[这里](https://doc.acmsmu.cn/openlayer3/ol.source.TileWMS.html)。这个opt_options就是样式设置的选项。

| 名称       | 类别                                                         | 描述                                                         |
| :--------- | :----------------------------------------------------------- | :----------------------------------------------------------- |
| `url`      | string \| undefined                                          | WMS服务的URL                                                 |
| `params`   | Object.< string, *>                                          | WMS服务请求参数。至少`LAYERS`参数是必须的。`STYLES`默认为`''`。`VERSION`默认为`1.3.0`。`WIDTH`、`HEIGHT`、`BBOX`和`CRS`(WMS的`SRS`版本<1.3.0)将会被动态设置。该参数必须。 |
| `tileGrid` | [ol.tilegrid.TileGrid](https://doc.acmsmu.cn/openlayer3/ol.tilegrid.TileGrid.html) \| undefined | 网格。基于分辨率，瓦片大小和服务支持的程度。如果它未定义，一个默认的网格将被使用；如果有投影范围，网格将基于它；如果没有，一个基于全局的，原点在0,0的网格将会被使用。 |

## ol.tilegrid.TileGrid类

它是对访问瓦片图片服务的数据源设置网格模式的基类。

#### 1、new ol.tilegrid.TileGrid(options)

构造方法，关于option的说明，这里只说用到的，具体参见[这里](https://doc.acmsmu.cn/openlayer3/ol.tilegrid.TileGrid.html)。

| 名称          | 类别                                                         | 描述                                                         |
| :------------ | :----------------------------------------------------------- | :----------------------------------------------------------- |
| `resolutions` | Array.                                                       | 分辨率。数组的每一个索引需要匹配缩放等级。这意味着即使如果一个`minZoom`被定义了，分辨率数组要有`maxZoom+1`的长度。该参数必须。 |
| `origin`      | [ol.Coordinate](https://doc.acmsmu.cn/openlayer3/ol.tilegrid.TileGrid.html)\|undefined | 瓦片网格的原点。比如，`x`轴与`y`轴相交(`[z,0,0]`)。瓦片坐标从左到右增加。如果不具体指明，`extent`或`origins`必须提供。 |

## ol.proj.Projection类

投影坐标系定义类。其中一个是为应用程序支持的每个投影创建的，并在`ol.proj`名字空间中。你可以在应用程序中使用这些，但是不是必须的，因为API参数和选项使用的是`ol.proj.ProjectionLike`。这意味着简单的字符串代码就足够了。
你可以使用`ol.project`来获得一个具体的投影坐标系对象。
这个库包含了`ESPG:4326`和`ESPG:3587`的定义，同时，包含以下别名：
`EPSG:4326`: CRS:84, urn:ogc:def:crs:EPSG:6.6:4326, urn:ogc:def:crs:OGC:1.3:CRS84, urn:ogc:def:crs:OGC:2:84, http://www.opengis.net/gml/srs/epsg.xml#4326, urn:x-ogc:def:crs:EPSG:4326
`EPSG:3857`: EPSG:102100, EPSG:102113, EPSG:900913, urn:ogc:def:crs:EPSG:6.18:3:3857, http://www.opengis.net/gml/srs/epsg.xml#3857
如果你使用的是proj4j，别名可以使用`proj.defs()`进行添加，查看[文档](https://github.com/proj4js/proj4js)。为proj4设置一个可选的名字空间，使用`ol.proj.setProj4`。

#### 1、new ol.proj.Projection(options)

构造方法，关于option的说明，这里只说用到的，具体参见[这里](https://doc.acmsmu.cn/openlayer3/ol.proj.Projection.html)。

| 名称              | 类别                   | 描述                                        |
| :---------------- | :--------------------- | :------------------------------------------ |
| `code`            | String                 | SRS的定义代码，例如`ESPG:4326`。必须        |
| `units`           | ol.proj.Units\| string | 单元。必须，除非为`code`定义一个proj4投影。 |
| `axisOrientation` | string \| undefined    | Proj4中指定的轴方向。默认是`enu`            |

## ol.source.WMTS类

从WMTS服务器获取瓦片数据的层

#### 1、new ol.source.WMTS(options)

构造方法，关于option的说明，这里只说用到的，具体参见[这里](https://doc.acmsmu.cn/openlayer3/ol.source.WMTS.html)。

| 名称         | 类别                     | 描述                              |
| :----------- | :----------------------- | :-------------------------------- |
| `url`        | string \| undefined      | 服务的URL                         |
| `layer`      | string                   | WMTS功能中公布的图层名称。必须。  |
| `matrixSet`  | string                   | 矩阵集，必须                      |
| `format`     | string \| undefined      | 图像格式，默认为`image/jpeg`      |
| `projection` | `ol.proj.ProjectionLike` | 投影坐标集                        |
| `tileGrid`   | `ol.tilegrid.WMTS`       | 网格，必须                        |
| `style`      | `string`                 | 在WMTS功能中的样式名称。必须      |
| `wrapX`      | boolean \| undefined     | 是否将世界水平包裹。默认是`false` |

## ol.tilegrid.WMTS类

为访问WMTS 瓦片图像服务设置网格模式

#### new ol.tilegrid.WMTS(options)

构造方法，关于option的说明，这里只说用到的，具体参见[这里](https://doc.acmsmu.cn/openlayer3/ol.tilegrid.WMTS.html)。

| 名称          | 类别                       | 描述                                                         |
| :------------ | :------------------------- | :----------------------------------------------------------- |
| `tileSize`    | number\|ol.Size\|undefined | 瓦片大小                                                     |
| `extent`      | ol.Extent \|undefined      | 平铺网格的范围，`ol.source.Tile`不会请求在这个范围外的任何瓦片。如果未配置`origin`或`origins`，`origin`将会被设置在范围的左上角 |
| `origin`      | ol.Coordinate \| undefined | 网格的原点，比如，如果`x`和`y`匹配(`[z,0,0]`)。瓦片坐标从左到右增加。如果没有指定，`extent`或`origin`则必须提供。 |
| `resolutions` | Array.< number>            | 分辨率。数组下标所对应的分辨率必须与缩放级别相对应。这意味着即使设置了`minZoom`，分辨率数组将需要`maxZoom+1`的长度 |
| `matrixIds`   | Array.< string>            | 矩阵的ID组。这个数组的长度需要与`resolutions`数组相匹配。必须。 |