- [openlayers 6【三】 地图视图 View 详解_范特西是只猫的博客-CSDN博客](https://xiehao.blog.csdn.net/article/details/105289610)

> 官方文档：https://openlayers.org/en/latest/apidoc/module-ol_View-View.html
>
> 上篇文章讲到 ，初始化map地图，必备的三要素之一就是视图（view），这个对象主要是控制地图与人的交互，如进行缩放，调节分辨率、地图的旋转等控制。也就是说每个 map对象包含一个 view对象部分，用于控制与用户的交互。

### 1. view 属性

| `center`                     | [模组：ol / coordinate〜Coordinate](https://openlayers.org/en/latest/apidoc/module-ol_coordinate.html#~Coordinate) | 视图的初始中心。如果未设置用户投影，则使用`projection`选项指定中心的坐标系。如果未设置，则不会获取图层源，但是稍后可以使用设置中心`#setCenter`。 |
| ---------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| `constrainRotation`          | 布尔 \| 数字 （默认为true）                                  | 旋转约束。 `false`表示没有约束。`true`表示没有约束，但会在接近零的位置捕捉到零。数字将旋转限制为该数量的值。例如，`4`将旋转限制为0、90、180和270度。 |
| `enableRotation`             | 布尔值 （默认为true）                                        | 启用旋转。如果为`false`，则使用始终将旋转设置为零的旋转约束。`constrainRotation`如果`enableRotation`为，则 该选项无效`false`。 |
| `extent`                     | [模块：ol /范围〜范围](https://openlayers.org/en/latest/apidoc/module-ol_extent.html#~Extent) | 限制视图的范围，换句话说，超出此范围的任何内容都无法在地图上看到。 |
| `constrainOnlyCenter`        | 布尔值 （默认为false）                                       | 如果为true，则范围约束将仅适用于视图中心，而不适用于整个范围。 |
| `smoothExtentConstraint`     | 布尔值 （默认为true）                                        | 如果为true，则范围约束将被平滑应用，即允许视图稍微超出给定范围`extent`。 |
| `maxResolution`              | 数                                                           | 用于确定分辨率约束的最大分辨率。它与`minResolution`（或 `maxZoom`）和一起使用`zoomFactor`。如果未指定，则以投影的有效范围适合256x256 px瓦片的方式进行计算。如果投影是“球形墨卡托”（默认），则`maxResolution`默认为`40075016.68557849 / 256 = 156543.03392804097`。 |
| `minResolution`              | 数                                                           | 用于确定分辨率约束的最小分辨率。它与`maxResolution`（或 `minZoom`）和一起使用`zoomFactor`。如果未指定，则假定使用29个缩放级别（系数为2）进行计算。如果投影是“球形墨卡托”（默认），则`minResolution`默认为 `40075016.68557849 / 256 / Math.pow(2, 28) = 0.0005831682455839253`。 |
| `maxZoom`                    | 数字 （默认为28）                                            | 用于确定分辨率约束的最大缩放级别。它与`minZoom`（或 `maxResolution`）和一起使用`zoomFactor`。请注意，如果`minResolution`还提供，则优先于`maxZoom`。 |
| `minZoom`                    | 数字 （默认为0）                                             | 用于确定分辨率约束的最小缩放级别。它与`maxZoom`（或 `minResolution`）和一起使用`zoomFactor`。请注意，如果`maxResolution`还提供，则优先于`minZoom`。 |
| `multiWorld`                 | 布尔值 （默认为false）                                       | 如果`false`视图受到限制，则只能看到一个世界，并且无法平移边缘。如果`true`地图可能在低缩放级别显示多个世界。仅在`projection`全局时使用。请注意，如果`extent`还提供，则它具有优先权。 |
| `constrainResolution`        | 布尔值 （默认为false）                                       | 如果为true，则在交互后，视图将始终设置为最接近的缩放级别。false表示允许中间缩放级别。 |
| `smoothResolutionConstraint` | 布尔值 （默认为true）                                        | 如果为true，则分辨率最小值/最大值将被平滑应用，即允许视图稍微超过给定的分辨率或缩放范围。 |
| `showFullExtent`             | 布尔值 （默认为false）                                       | 允许缩小视图以显示完整的配置范围。默认情况下，在为视图配置了范围时，用户将无法缩小，因此视口在任一维度上都超出了范围。这意味着如果视口比配置范围的纵横比高或宽，则整个范围可能不可见。如果showFullExtent为true，则用户将能够进行缩小，以使视口超过配置的范围的高度或宽度，但不能同时超过两者，从而可以显示整个范围。 |
| `projection`                 | [模块：ol / proj〜ProjectionLike](https://openlayers.org/en/latest/apidoc/module-ol_proj.html#~ProjectionLike) （默认为'EPSG：3857'） | 投影。默认值为球形墨卡托。                                   |
| `resolution`                 | 数                                                           | 视图的初始分辨率。单位是`projection`每像素的单位（例如米/像素）。设置此方法的替代方法是set `zoom`。如果既未`zoom`定义也未定义图层源，则可以稍后使用`#setZoom`或进行设置`#setResolution`。 |
| `resolutions`                | 数组。<数字>                                                 | 确定分辨率约束的分辨率。如果设置了`maxResolution`，`minResolution`， `minZoom`，`maxZoom`，和`zoomFactor`选项都将被忽略。 |
| `rotation`                   | 数字 （默认为0）                                             | 视图的初始旋转（弧度）（顺时针正旋转，0表示北）。            |
| `zoom`                       | 数                                                           | 仅在`resolution`未定义的情况下使用。缩放级别，用于计算视图的初始分辨率。 |
| `zoomFactor`                 | 数字 （默认为2）                                             | 缩放系数，用于计算相应的分辨率。                             |

**1.1 view 常见的几个属性**

- center 是一个坐标[x， y]，表示地图视图的中心位置；
- projection 是地图的投影坐标系统，默认为'EPSG：3857'；
- zoom 表示地图初始的缩放级别；

### 2. view 方法

 **2.1 view 类的方法主要是针对 view 的属性的 get 和 set 方法，其基本的方法很多，我们将常用的方法进行归类：**

**红色为常用的方法**

**get类：**

- getCenter 获取视图中心，返回一个地图中心的坐标。
- getZoom 获取当前的缩放级别。如果视图不限制分辨率，或者正在进行交互或动画，则此方法可能返回非整数缩放级别。
- getMaxZoom 获取视图的最大缩放级别。
- getMinZoom 获取视图的最小缩放级别。
- getAnimating 确定视图是否处于动画状态。
- getInteracting 确定用户是否正在与视图进行交互，例如平移或缩放。
- getKeys 获取对象属性名称的列表。
- getMaxResolution 获取视图的最大分辨率。
- getMinResolution 获取视图的最低分辨率
- getProjection 获取地图使用的”投影坐标系统”，如EPSG:4326；
- getProperties 获取具有所有属性名称和值的对象。
- getResolution 获取视图分辨率。
- getResolutionForExtent 获取提供的范围（以地图单位为单位）和大小（以像素为单位）的分辨率。
- getResolutionForZoom 获取缩放级别的分辨率。
- getResolutions 获取视图的分辨率。这将返回传递给View的构造函数的分辨率数组，如果未给出则未定义。
- getRevision 获取此对象的版本号。每次修改对象时，其版本号都会增加。
- getRotation 获取视图旋转。
- getZoomForResolution 获取分辨率的缩放级别。

**set类：**

- setCenter 设置当前视图的中心。任何范围限制都将适用。
- setConstrainResolution 设置视图是否应允许中间缩放级别。
- setZoom 缩放到特定的缩放级别。任何分辨率限制都将适用。
- setMaxZoom 为视图设置新的最大缩放级别。
- setMinZoom 为视图设置新的最小缩放级别。
- setProperties 设置键值对的集合。请注意，这会更改所有现有属性并添加新属性（不会删除任何现有属性）。
- setResolution 设置此视图的分辨率。任何分辨率约束都将适用。
- setRotation 设置该视图的旋转角度。任何旋转约束都将适用。

**2.2 其他类：**

- rotate 接受两个参数，旋转角度数（rotation）和旋转中心（opt_anchor，可选），将地图围绕 opt_anchor 旋转 rotation 角度；
- ifDef 检查地图的中心和分辨率是否已经设置，都设置返回 true，否则返回 false；
- fitExtent(extent, size)，接受两个参数：extent 和 size，extent 类型是 ol.Extent – [left, bottom, right, top]，size由map.getSize()获取；该功能类似于 ArcGIS 的缩放到图层功能，将地图的view 缩放到 extent 区域可见的合适尺度；
- fitGeometry(geometry, size, opt_options)，参数是地理要素，地图尺寸和可选参数；根据给定的地理要素，将 view 缩放到适合地理要素显示的尺寸；

### **3. 写在后面**

view主要控制地图与用户的最基本的交互，**每个 map 对象必须包含一个 view 对象，也就是说每个 map 必须都支持缩放、平移等基本交互动作。**

后面会将图层Layers的详解！！！ 