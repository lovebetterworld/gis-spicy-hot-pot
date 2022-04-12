- [openlayers6【七】地图控件controls详解_范特西是只猫的博客-CSDN博客](https://xiehao.blog.csdn.net/article/details/106375350)

## 1. controls 简述

上篇文章我们将了在地图上的交互(interaction)，那些都是一些隐性的需要去使用才能知道存在有这样一个东西，就像彩蛋一样。这篇我们主要讲地图上的控件(controls)，这些可以说都是显性的东西，如果设置了，打开地图页面就能够看到的东西。场景

跟 interaction交互一样，可以看到官网的描述：最初添加到地图的控件。如果未指定， module:ol/control~defaults则使用。也就是说这个属性 `不是必须存在` 的，默认使用的是`control~defaults` 内容，并且是已 `Array`数组形式存在，也就是说可以像图层和交互一样，可以多个控件功能承载在地图上。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200605154754262.png)

## 2. 常见的 controls 控件

- `controldefaults，地图默认包含的控件，包含缩放控件和旋转控件；`
- fullscreen，全屏控件，用于全屏幕查看地图；
- mouseposition，鼠标位置控件，显示鼠标所在地图位置的坐标，可以自定义投影；
- overviewmap，地图全局视图控件（鹰眼图）；
- scaleline，比例尺控件；
- zoom，缩放控件；
- zoomslider，缩放滑块刻度控件；

## 3. 控件的使用

### 3.1 fullscreen 全屏控件

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200604111038768.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)

```js
import { defaults as defaultControls, FullScreen } from "ol/control";
this.map.addControl(new FullScreen());
```

### 3.2 mouseposition 鼠标位置控件

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200604111940815.gif)

```js
import MousePosition from "ol/control/MousePosition";
// 向地图添加 MousePosition
var mousePositionControl = new MousePosition({
     //坐标格式
     coordinateFormat: createStringXY(5),
     //地图投影坐标系（若未设置则输出为默认投影坐标系下的坐标）
     projection: "EPSG:4326",
     //坐标信息显示样式类名，默认是'ol-mouse-position'
     className: "custom-mouse-position",
     //显示鼠标位置信息的目标容器
     target: document.getElementById("mouse-position"),
     //未定义坐标的标记
     undefinedHTML: "&nbsp;"
 });
 this.map.addControl(mousePositionControl);
```

### 3.3 overviewmap 地图全局视图（鹰眼图）控件

参数：以下参数都为可选，添加如下代码：

collapsed，收缩选项，默认为true，收缩；

collapseLabel，收缩后的图标按钮；

collapsible，是否可以收缩为图标按钮，默认为 true；

label，当 overviewmapcontrol 收缩为图标按钮时，显示在图标按钮上的文字或者符号，默认为 »；

layers，overviewmapcontrol针对的图层，默认情况下为所有图层，一般这里设置的图层和map图层数据一致；

render，当 overviewmapcontrol 重新绘制时，调用的函数；

target，放置的 HTML 元素；

tipLabel，鼠标放置在图标按钮上的提示文字。

```js
var overviewMapControl = new OverviewMap({
    layers: [
        new TileLayer({
            source: new XYZ({
                url:
                    "http://map.geoq.cn/ArcGIS/rest/services/ChinaOnlineStreetPurplishBlue/MapServer/tile/{z}/{y}/{x}"
            })
        })
    ]
});
this.map = new Map({
    target: target,
    layers: tileLayer,
    view: view,
    // 添加鹰眼图的控件
    controls: defaultControls({ zoom: true }).extend([
        overviewMapControl
    ])
});
```

### 3.4 scaleline 比例尺控件

![在这里插入图片描述](https://img-blog.csdnimg.cn/2020060411024490.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)

```js
import { defaults as defaultControls,ScaleLine} from "ol/control";
this.map.addControl(new ScaleLine());
```

### 3.5 zoom 缩放控件

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200601165857832.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)

```js
controls: defaultControls({ zoom: true }).extend([])
```

### 3.6 zoomslider 缩放滑块刻度控件

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200604104218186.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)

```js
import { defaults as defaultControls, ZoomSlider } from "ol/control";
this.map.addControl(new ZoomSlider());
```

## 4. 总结

这里只是简单介绍了几个常用的控件全屏，鼠标位置，鹰眼图，比例尺，缩放，缩放滑块等，更多的控件可以去官网查看。