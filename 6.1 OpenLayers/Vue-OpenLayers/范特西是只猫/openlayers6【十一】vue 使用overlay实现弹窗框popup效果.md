- [openlayers6【十一】vue 使用overlay实现弹窗框popup效果_范特西是只猫的博客-CSDN博客_ol.overlay.popup](https://xiehao.blog.csdn.net/article/details/106476543)

弹窗效果在地图加载完成后，我们往往需要更多的交互效果，不仅仅局限于地图的缩放和平移，让地图业务更加复杂一点，比如图标打点上图后，我们可以通过点击图标弹窗这个点位的具体信息都是应用场景，下面具体说下怎么利用`overlay`类实现`popup`气泡弹窗的吧。

## 1. popup 弹窗框效果

![在这里插入图片描述](https://img-blog.csdnimg.cn/2020062411102349.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)

## 2. 实现步骤

**2.1 在此之前你需要先基于之前的文章如何加载一个地图。下面是初始化地图的代码。**

```css
<div id="map" ref="map"></div>

initMap() {
    let target = "map"; //跟页面元素的 id 绑定来进行渲染
    let tileLayer = new TileLayer({
        source: new XYZ({
            url:
                "http://map.geoq.cn/ArcGIS/rest/services/ChinaOnlineStreetPurplishBlue/MapServer/tile/{z}/{y}/{x}"
        })
    });
    let view = new View({
        center: fromLonLat([104.912777, 34.730746]), //地图中心坐标
        zoom: 4.5 //缩放级别
    });
    this.map = new Map({
        target: target, //绑定dom元素进行渲染
        layers: [tileLayer], //配置地图数据源
        view: view //配置地图显示的options配置（坐标系，中心点，缩放级别等）
    });
},
```

**2.2 地图有了，下面就可以直接在地图上创建overlay 实现弹窗了，在vue中需要先引入`ol/Overlay` 这个类**

```js
import Overlay from "ol/Overlay";
```

下面可以看下这个类都有哪些常用的参数

- `element`, 绑定 Overlay 对象和 DOM 对象的,可能是一个DIV标签
- `autoPan` 定义弹出窗口在边缘点击时候可能不完整 设置自动平移效果
- `autoPanAnimation` 自动平移效果的动画时间 9毫秒
- `map` 是要绑定的地图对象，
- `offset` 偏移量属性
- `position` 是点击时Popup放置的位置。

为了产生弹出框的效果，那么HTML文件中要有相应的元素，那么我们就定义一些元素：

```html
<div id="popup" class="ol-popup">
    <a href="#" id="popup-closer" class="ol-popup-closer"></a>
    <div id="popup-content" class="popup-content"></div>
</div>
```

下面就可以创建一个overlay，然后实现弹窗效果啦

```js
var container = document.getElementById("popup");
// 创建一个弹窗 Overlay 对象
this.overlay = new Overlay({
    element: container, //绑定 Overlay 对象和 DOM 对象的
    autoPan: true, // 定义弹出窗口在边缘点击时候可能不完整 设置自动平移效果
    autoPanAnimation: {
        duration: 250 //自动平移效果的动画时间 9毫秒
    }
});
// 将弹窗添加到 map 地图中
this.map.addOverlay(this.overlay);
```

**2.3.这样，弹出的框框我们就准备好了。下一步需要为Map绑定点击事件，这样，当我们点击地图上的相应位置时，才会触发弹出框框嘛！**

```js
var content = document.getElementById("popup-content");
this.map.on("click", function(evt) {
	let coordinate = transform(
	    evt.coordinate,
	    "EPSG:3857",
	    "EPSG:4326"
	);
	// 点击尺 （这里是尺(米)，并不是经纬度）;
	let hdms = toStringHDMS(toLonLat(evt.coordinate)); // 转换为经纬度显示
	content.innerHTML = `
	<p>你点击了这里：</p>
	<p>经纬度：<p><code> ${hdms}  </code> <p>
	<p>坐标：</p>X：${coordinate[0]} &nbsp;&nbsp; Y: ${coordinate[1]}`;
	_that.overlay.setPosition(evt.coordinate); //把 overlay 显示到指定的 x,y坐标
});
```

**2.4 然后我们可以设置点击 `X` 关闭弹窗**

```js
var closer = document.getElementById("popup-closer");
closer.onclick = function() {
   _that.overlay.setPosition(undefined);
   closer.blur();
   return false;
};
```

**2.5 最后当然我们可以控制弹窗的样式效果**

```css
<style lang="scss" scoped>
html,
body {
    height: 100%;
}
#app {
    min-height: calc(100vh - 50px);
    width: 100%;
    position: relative;
    overflow: none;
    #map {
        height: 888px;
        min-height: calc(100vh - 50px);
    }
}
.ol-popup {
    position: absolute;
    background-color: white;
    -webkit-filter: drop-shadow(0 1px 4px rgba(0, 0, 0, 0.2));
    filter: drop-shadow(0 1px 4px rgba(0, 0, 0, 0.2));
    padding: 15px;
    border-radius: 10px;
    border: 1px solid #cccccc;
    bottom: 12px;
    left: -50px;
}
.ol-popup:after,
.ol-popup:before {
    top: 100%;
    border: solid transparent;
    content: " ";
    height: 0;
    width: 0;
    position: absolute;
    pointer-events: none;
}
.ol-popup:after {
    border-top-color: white;
    border-width: 10px;
    left: 48px;
    margin-left: -10px;
}
.ol-popup:before {
    border-top-color: #cccccc;
    border-width: 11px;
    left: 48px;
    margin-left: -11px;
}
.ol-popup-closer {
    text-decoration: none;
    position: absolute;
    top: 2px;
    right: 8px;
}
.popup-content {
    width: 400px;
}
.ol-popup-closer:after {
    content: "✖";
}
</style>
```

## 3. 附上完整代码

```html
<template>
    <div id="app">
        <div id="map" ref="map"></div>
        <div id="popup" class="ol-popup">
            <a href="#" id="popup-closer" class="ol-popup-closer"></a>
            <div id="popup-content" class="popup-content"></div>
        </div>
    </div>
</template>

<script>
import "ol/ol.css";
import { Map, View, Coordinate } from "ol";
import { toStringHDMS } from "ol/coordinate";
import TileLayer from "ol/layer/Tile";
import XYZ from "ol/source/XYZ";
import Overlay from "ol/Overlay";
import { fromLonLat, transform, toLonLat } from "ol/proj";

// 弹出窗口实现
export default {
    name: "dashboard",
    data() {
        return {
            map: null,
            overlay: null
        };
    },
    methods: {
        /**
         * 初始化地图
         */
        initMap() {
            let target = "map"; //跟页面元素的 id 绑定来进行渲染
            let tileLayer = new TileLayer({
                source: new XYZ({
                    url:
                        "http://map.geoq.cn/ArcGIS/rest/services/ChinaOnlineStreetPurplishBlue/MapServer/tile/{z}/{y}/{x}"
                })
            });
            let view = new View({
                center: fromLonLat([104.912777, 34.730746]), //地图中心坐标
                zoom: 4.5 //缩放级别
            });
            this.map = new Map({
                target: target, //绑定dom元素进行渲染
                layers: [tileLayer], //配置地图数据源
                view: view //配置地图显示的options配置（坐标系，中心点，缩放级别等）
            });
        },
        /**
         * 创建一个 Overlay 叠加从对象用作显示弹窗
         * 思路：
         * 1. 点击地图上的位置
         * 2. 获取经纬度的坐标
         * 3. 调用 ol 内置的方法 ol.Overlay 实现弹出
         */
        addPopup() {
            // 使用变量存储弹窗所需的 DOM 对象
            var container = document.getElementById("popup");
            var closer = document.getElementById("popup-closer");
            var content = document.getElementById("popup-content");

            // 创建一个弹窗 Overlay 对象
            this.overlay = new Overlay({
                element: container, //绑定 Overlay 对象和 DOM 对象的
                autoPan: true, // 定义弹出窗口在边缘点击时候可能不完整 设置自动平移效果
                autoPanAnimation: {
                    duration: 250 //自动平移效果的动画时间 9毫秒
                }
            });
            // 将弹窗添加到 map 地图中
            this.map.addOverlay(this.overlay);
            let _that = this;
            /**
             * 添加单击响应函数来处理弹窗动作
             */
            this.map.on("click", function(evt) {
                // "EPSG:3857", "EPSG:4326" 转换
                let coordinate = transform(
                    evt.coordinate,
                    "EPSG:3857",
                    "EPSG:4326"
                );
                // 点击尺 （这里是尺(米)，并不是经纬度）;
                let hdms = toStringHDMS(toLonLat(evt.coordinate)); // 转换为经纬度显示
                content.innerHTML = `
                <p>你点击了这里：</p>
                <p>经纬度：<p><code> ${hdms}  </code> <p>
                <p>坐标：</p>X：${coordinate[0]} &nbsp;&nbsp; Y: ${coordinate[1]}`;
                _that.overlay.setPosition(evt.coordinate); //把 overlay 显示到指定的 x,y坐标
            });
            /**
             * 为弹窗添加一个响应关闭的函数
             */
            closer.onclick = function() {
                _that.overlay.setPosition(undefined);
                closer.blur();
                return false;
            };
        }
    },
    mounted() {
        this.initMap();
        this.addPopup();
    }
};
</script>

<style lang="scss" scoped>
html,
body {
    height: 100%;
}
#app {
    min-height: calc(100vh - 50px);
    width: 100%;
    position: relative;
    overflow: none;
    #map {
        height: 888px;
        min-height: calc(100vh - 50px);
    }
}
.ol-popup {
    position: absolute;
    background-color: white;
    -webkit-filter: drop-shadow(0 1px 4px rgba(0, 0, 0, 0.2));
    filter: drop-shadow(0 1px 4px rgba(0, 0, 0, 0.2));
    padding: 15px;
    border-radius: 10px;
    border: 1px solid #cccccc;
    bottom: 12px;
    left: -50px;
}
.ol-popup:after,
.ol-popup:before {
    top: 100%;
    border: solid transparent;
    content: " ";
    height: 0;
    width: 0;
    position: absolute;
    pointer-events: none;
}
.ol-popup:after {
    border-top-color: white;
    border-width: 10px;
    left: 48px;
    margin-left: -10px;
}
.ol-popup:before {
    border-top-color: #cccccc;
    border-width: 11px;
    left: 48px;
    margin-left: -11px;
}
.ol-popup-closer {
    text-decoration: none;
    position: absolute;
    top: 2px;
    right: 8px;
}
.popup-content {
    width: 400px;
}
.ol-popup-closer:after {
    content: "✖";
}
</style>
```