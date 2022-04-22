- [openlayers 6【二】Map地图详解，初始化一个map地图_范特西是只猫的博客-CSDN博客_new openlayers.map](https://xiehao.blog.csdn.net/article/details/105272407)

### 1. map 参数详情参考

> 官方文档：https://openlayers.org/en/latest/apidoc/module-ol_Map-Map.html

- `layers 了解更多`
- `view 了解更多`

| `controls`            | [module：ol / Collection〜Collection](https://openlayers.org/en/latest/apidoc/module-ol_Collection-Collection.html)。< [模块：ol / control / Control〜Control](https://openlayers.org/en/latest/apidoc/module-ol_control_Control-Control.html) > \| Array。< [模块：ol / control / Control〜Control](https://openlayers.org/en/latest/apidoc/module-ol_control_Control-Control.html) > | 最初添加到地图的控件。如果未指定， `module:ol/control~defaults`则使用。 |
| --------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| `pixelRatio`          | 数字 （默认为window.devicePixelRatio）                       | 设备上物理像素与设备无关像素（dip）之间的比率。              |
| `interactions`        | [module：ol / Collection〜Collection](https://openlayers.org/en/latest/apidoc/module-ol_Collection-Collection.html)。< [module：ol / interaction / Interaction〜Interaction](https://openlayers.org/en/latest/apidoc/module-ol_interaction_Interaction-Interaction.html) > \| Array。< [模块：ol / interaction / Interaction〜Interaction](https://openlayers.org/en/latest/apidoc/module-ol_interaction_Interaction-Interaction.html) > | 最初添加到地图的互动。如果未指定， `module:ol/interaction~defaults`则使用。 |
| `keyboardEventTarget` | HTMLElement \| 文件 \| 串                                    | 监听键盘事件的元素。这决定了`KeyboardPan`和 `KeyboardZoom`互动的触发时间。例如，如果将此选项设置为 `document`键盘，则交互将始终触发。如果未指定此选项，则库在其上侦听键盘事件的元素是地图目标（即用户为地图提供的div）。如果不是 `document`，则需要集中目标元素以发射关键事件，这要求目标元素具有`tabindex`属性。 |
| `layers`              | Array。< [模块：ol / layer / Base〜BaseLayer](https://openlayers.org/en/latest/apidoc/module-ol_layer_Base-BaseLayer.html) > \| [module：ol / Collection〜Collection](https://openlayers.org/en/latest/apidoc/module-ol_Collection-Collection.html)。< [module：ol / layer / Base〜BaseLayer](https://openlayers.org/en/latest/apidoc/module-ol_layer_Base-BaseLayer.html) > \| [模块：ol / layer / Group〜LayerGroup](https://openlayers.org/en/latest/apidoc/module-ol_layer_Group-LayerGroup.html) | 图层。如果未定义，则将渲染没有图层的地图。请注意，层是按提供的顺序渲染的，因此，**例如，如果要使矢量层出现在图块层的顶部，则它必须位于图块层之后。** |
| `maxTilesLoading`     | 数字 （默认为16）                                            | 同时加载的最大瓦片数。                                       |
| `moveTolerance`       | 数字 （默认为1）                                             | 光标必须移动的最小距离（以像素为单位）才能被检测为地图移动事件，而不是单击。增大此值可以使单击地图更容易。 |
| `overlays`            | [module：ol / Collection〜Collection](https://openlayers.org/en/latest/apidoc/module-ol_Collection-Collection.html)。< [module：ol / Overlay〜Overlay](https://openlayers.org/en/latest/apidoc/module-ol_Overlay-Overlay.html) > \| Array。< [module：ol / Overlay〜Overlay](https://openlayers.org/en/latest/apidoc/module-ol_Overlay-Overlay.html) > | 叠加层最初添加到地图中。默认情况下，不添加任何覆盖。         |
| `target`              | HTMLElement \| 串                                            | 地图的容器，元素本身或`id`元素的。如果在构造时未指定，则[`module:ol/Map~Map#setTarget`](https://openlayers.org/en/latest/apidoc/module-ol_Map-Map.html#setTarget)必须调用渲染地图。 |
| `view`                | [模块：ol / View〜View](https://openlayers.org/en/latest/apidoc/module-ol_View-View.html) | 地图的视图。除非在构造时或通过指定，否则不会获取任何层源 [`module:ol/Map~Map#setView`](https://openlayers.org/en/latest/apidoc/module-ol_Map-Map.html#setView)。 |

 

场景：为了方便我们在浏览器中实现可交互的操作，基于一些政府单位工作场景，常常会涉及到对地理地图需求的项目。

我们已此为依托，使用[OpenLayers](https://so.csdn.net/so/search?q=OpenLayers&spm=1001.2101.3001.7020)便是一个减轻你的工作量的框架，利用它可以轻松地加载一幅动态可交互的地图到浏览器中！达到可交换的功能。

下面便是一个利用OpenLayers加载地图的小例子，我们先看看运行结果，并分析一下原理！

### 2. 话不多说，先看渲染出来的效果

![img](https://img-blog.csdnimg.cn/20200605115307772.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)

### 2. 在vue环境下，创建一个Map地图

**2.1 npm 安装 openlayers**

```javascript
cnpm i -S ol
```

**2.2 完整代码**

```html
<template>
    <div id="content">
        <div id="map" ref="map"></div>
    </div>
</template>
 
<script>
import "ol/ol.css";
import { Map, View } from "ol";
import { defaults as defaultControls } from "ol/control";
import Tile from "ol/layer/Tile";
import { fromLonLat } from "ol/proj";
import OSM from "ol/source/OSM";
 
export default {
    name: "tree",
    data() {
        return {
            map: null
        };
    },
    methods: {
        /**
         * 初始化一个 openlayers 地图
         */
        initMap() {
            let target = "map"; //跟页面元素的 id 绑定来进行渲染
            let tileLayer = [
                new Tile({
                    source: new OSM()
                })
            ];
            let view = new View({
                center: fromLonLat([104.912777, 34.730746]), //地图中心坐标
                zoom: 4.5 //缩放级别
            });
            this.map = new Map({
                target: target, //绑定dom元素进行渲染
                layers: tileLayer, //配置地图数据源
                view: view //配置地图显示的options配置（坐标系，中心点，缩放级别等）
            });
        }
    },
    mounted() {
        this.initMap();
    }
};
</script>
<style lang="scss" scoped>
// 非核心已删除
</style>
```

### **3**. 代码分析

**3.1 首先页面需要先创建一个 div，用来绑定 map 地图上**

```html
<div id="map" ref="map"></div>
```

**3.2 下面是一个初始化地图的方法**

```javascript
/**
 * 初始化一个 openlayers 地图
 */
initMap() {
    let target = "map"; //跟页面元素的 id 绑定来进行渲染
    let tileLayer = [
        new Tile({
            source: new OSM()
        })
    ];
    let view = new View({
        center: fromLonLat([104.912777, 34.730746]), //地图中心坐标
        zoom: 4.5 //缩放级别
    });
    this.map = new Map({
        target: target, //绑定dom元素进行渲染
        layers: tileLayer, //配置地图数据源
        view: view //配置地图显示的options配置（坐标系，中心点，缩放级别等）
    });
}
```

 我们可以看到，前面的声明了三个变量分别是 容器（target），图层（tileLayer），view（视图）。通过实例化了一个OpenLayers的Map对象，于是就显示了地图！Map是何许人也？它是OpenLayers中最主要的对象！**要初始化一幅地图，需要一个target，view，layers。**

- **target 主要是用来跟页面的元素进行绑定显示**
- tileLayer 我们看到，他其实是一个数组形式，那就说明它可以存在多个图层，这也是openlayers强大之处，非常实用。通过new Tile() 创建了一个图层，但是单单创建图层也是不行，图层里面必须要有数据，于是就有了 source: new OSM() 创建了一个OpenStreetMap提供的切片数据
- view 同理，通过new View()创建了一
- 个视图对象，设置一些视区的参数，
  - center 设置默认地图中心点位置 ，fromLonLat 函数是将给定的坐标从4326转到3857坐标系下，4326即是WGS84坐标系！（后面单独讲解 4326 和3857 坐标系的区别）
  - zoom 设置缩放等级

### 4. 说在后面

最后，地图已经成功加载到网页中，并且可以进行缩放，平移及拖动操作（map默认此功能），想实现更多功能后面再写哈。