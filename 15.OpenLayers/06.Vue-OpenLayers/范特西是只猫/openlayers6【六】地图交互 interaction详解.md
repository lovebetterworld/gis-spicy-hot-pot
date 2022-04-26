- [openlayers6【六】地图交互 interaction详解_范特西是只猫的博客-CSDN博客_openlayers6](https://xiehao.blog.csdn.net/article/details/106373522)

## 1. 什么是地图交互 interaction ？？？

地图交互功能都是不可见的，如鼠标双击、滚轮滑动等，手机设备的手指缩放等。

地图的交互功能包含很多，如地图双击放大，鼠标滚轮缩放，矢量要素点选，地图上绘制图形等等。只要是涉及到与地图的交互，就会涉及到 intercation 类，它定义了用户与地图进行交互的基本要素和事件。下面我们就来看看用户与地图都有那些交互，怎么交互。

## 2. 简述地图交互 interaction

在之前的文章中有写到一个地图map，是必须存在的三个属性 target ，view，layers。那么地图是不是还可以存在其他属性呢？当然是有的，现在这篇就为大家讲解另外的一个属性 `interaction` 地图的交互功能。

可以看到[官网](https://openlayers.org/en/latest/apidoc/module-ol_Map-Map.html)的描述：最初添加到地图的互动。如果未指定， module:ol/interaction~defaults则使用。

也就是说这个属性`不是必须` 存在的，默认使用的是 `interaction~defaults` 内容，并且是已 `Array` 数组形式存在，也就是说可以像图层一样，已多个交互功能承载在地图上。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200605141839203.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)

## 3. interaction 介绍

在 [OpenLayers](https://so.csdn.net/so/search?q=OpenLayers&spm=1001.2101.3001.7020) 6 中，表达交互功能的基类是 interaction，它是一个虚基类，不负责实例化，交互功能都继承该基类， OpenLayers 6 中可实例化的子类及其功能如下：

- doubleclickzoom ，双击放大交互功能；
- draganddrop ，以“拖文件到地图中”的交互添加图层；
- dragbox，拉框，用于划定一个矩形范围，常用于放大地图；
- dragpan ，拖拽平移地图；
- dragrotateandzoom，拖拽方式进行缩放和旋转地图；
- dragrotate ，拖拽方式旋转地图；
- dragzoom ，拖拽方式缩放地图；
- draw，绘制地理要素功能；
- keyboardpan ，键盘方式平移地图；
- keyboardzoom ，键盘方式缩放地图；
- select，选择要素功能；
- modify ，更改要素；
- mousewheelzoom ，鼠标滚轮缩放功能；
- pinchrotate，手指旋转地图，针对触摸屏；
- pinchzoom ，手指进行缩放，针对触摸屏；
- pointer ，鼠标的用户自定义事件基类；
- snap，鼠标捕捉，当鼠标距离某个要素一定距离之内，自动吸附到要素。
- `interaction defaults ，规定了默认添加的交互功能；`

## 4. interaction defaults - 默认添加的交互功能

> https://openlayers.org/en/latest/apidoc/module-ol_interaction.html

该类规定了默认包含在地图中的功能，他们都是继承自 `ol.interaction` 类。 主要是最为常用的功能，如缩放、平移和旋转地图等，具体功能有如下这些：

- altShiftDragRotate 是否需要Alt-Shift-拖动旋转 （布尔值：默认为true）
- doubleClickZoom 是否鼠标或手指双击缩放地图（布尔值：默认为true）。
- keyboard 是否需要键盘交互（布尔值：默认为true）
- mouseWheelZoom 是否鼠标滚轮缩放地图。布尔值 （默认为true）
- shiftDragZoom 是否需要Shift拖动缩放（布尔值：默认为true） 。
- dragPan 是否鼠标或手指拖拽平移地图（布尔值：默认为true）
- pinchRotate 是否两个手指旋转地图，针对触摸屏（布尔值：默认为true）
- pinchZoom 是否两个手指旋转地图，针对触摸屏（布尔值：默认为true）
- zoomDelta 使用键盘或双击缩放时的缩放级别增量。（数）
- zoomDuration 缩放动画的持续时间（数：以毫秒为单位）
- onFocusOnly 仅在地图具有焦点时进行交互。这会影响MouseWheelZoom和的DragPan相互作用，并且在没有浏览器焦点的地图需要页面滚动时很有用（布尔值：默认为false）

可以看出，很多都兼容移动设备的触摸屏，键盘，鼠标事件，这就是OpenLayers 3以后的改进，跨平台改进。这些功能都是默认添加的，如果要更改默认的选项，需要在相应的选项设置为 false。

栗子：如果想去掉默认的 DoubleClickZoom 功能，配置如下：

```java
interactions: ol.interaction.defaults([
    doubleClickZoom: false
]),
```

这样就取消双击放大功能，去除其他的默认功能，是一样的。

## 5. 栗子：dragrotateandzoom (shift + 鼠标拖拽进行缩放和旋转地图)

```bash
import {
    defaults as defaultInteractions,
    DragRotateAndZoom
} from "ol/interaction";

this.map = new Map({
    target: target,
    layers: tileLayer,
    view: view,
    interactions: defaultInteractions().extend([
        new DragRotateAndZoom()
    ])
});
```

## 6. 写在最后

地图交互功能内容实在是太多了，包括 `键盘事件`，`鼠标事件`，`拖拽`，`平移`，`缩放` 等一些基本的交互动作，还有后面会写到的 `测距`，`测面`，通过draw 绘制，选择要素 `select`，`modify`，铺捉吸附的 `snap` 和鼠标自定义事件 `pointer` 都构成了openlayers 更加强大的交互功能系统，提升更优的用户体验。
通过一系列的交互改变（新增，删除，更新）数据实现动态交互。