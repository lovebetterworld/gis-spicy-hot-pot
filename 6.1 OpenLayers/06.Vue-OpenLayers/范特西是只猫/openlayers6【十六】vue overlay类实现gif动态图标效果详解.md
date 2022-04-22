- [openlayers6【十六】vue overlay类实现gif动态图标效果详解_范特西是只猫的博客-CSDN博客_openlayers 动态图](https://xiehao.blog.csdn.net/article/details/107408029)

## 1. 写在前面

1. openlayer 里面支持 `gif` 图标上图的只有 `overlay类` 可以实现，矢量图层 Vector 不能设置动态的gif图标，只能设置静态的 `png，jpg文件，或者base64等数据`
2. overlay类 的常见使用场景更多可以看看这篇文章 [地图覆盖物overlay三种常用用法 popup弹窗，marker标注，text文本](https://blog.csdn.net/qq_36410795/article/details/106476543)
3. openlayers 不支持 svga 动画图（亲测）

## 2. 效果图

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200430162622738.gif)

## 3. 使用overlay类，地图添加动态图标

原理：其实就是 overlay 类创建可以通过绑定 `element` 属性在地图上，通过属性的css设置gif图标的样式即可。

方法详解：

1. 先在页面获取到map元素，通过遍历coordinates的数据，创建span元素，追加在页面中
2. 创建 overlay 类，通过 `element` 属性与上面创建的 `span` 进行绑定
3. 最后把 overlayer 类添加到 map 中

```js
// 使用Overlay添加GIF动态图标点位信息方法
addGif() {
    let _that = this;
    let mapDom = this.$refs.map; // 获取map地图dom元素
    for (let i = 0; i < this.coordinates.length; i++) {
        var oDiv = document.createElement("span"); // 遍历coordinates创建span元素
        oDiv.id = "gif-" + i; //设置元素的id值
        mapDom.appendChild(oDiv); //span追加到map中
        this.$nextTick(() => {
            this.markerPoint = new Overlay({ // 创建一个Overlay类
                position: fromLonLat([
                    _that.coordinates[i][0],
                    _that.coordinates[i][1]
                ]),//设置Overlay的经纬度位置
                positioning: "center-center",
                element: document.getElementById("gif-" + i),// 把上面的创建的元素绑定在Overlay中
                stopEvent: false
            });
            this.map.addOverlay(this.markerPoint);
        });
    }
}
```

我们看下dom元素的内容

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200717152513372.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)

## 4. css设置gif图标

页面有了dom元素，剩下的就是设置样式了，就是基础的css操作了。

```css
.ol-overlay-container {
    span {
        display: block;
        width: 20px;
        height: 42px;
        border-radius: 50%;
        background: url("../../assets/images/people.gif") no-repeat;
        background-size: 20px 42px;
    }
}
```

## 5. 完整代码

```html
<template>
    <div id="content">
        <div id="map" ref="map"></div>
    </div>
</template>

<script>
import "ol/ol.css";
import { Map, View } from "ol";
import TileLayer from "ol/layer/Tile";
import OSM from "ol/source/OSM";
import Overlay from "ol/Overlay";
import { fromLonLat } from "ol/proj";

// 弹出窗口实现
export default {
    name: "gif",
    data() {
        return {
            map: null,
            overlay: null,
            markerPoint: null,
            // 点信息
            coordinates: [
                [87.532236, 44.284182],
                [104.043505, 30.58165],
                [116.397289, 39.928632]
            ]
        };
    },
    methods: {
    	// 初始化地图
        initMap() {
            let target = "map";
            let tileLayer = new TileLayer({
                source: new OSM()
            });
            let view = new View({
                center: fromLonLat([104.912777, 34.730746]),
                zoom: 4.5
            });
            this.map = new Map({
                target: target,
                layers: [tileLayer],
                view: view
            });
        },
		// 使用Overlay添加GIF动态图标点位信息
		addGif() {
		    let _that = this;
		    let mapDom = this.$refs.map;
		    for (let i = 0; i < this.coordinates.length; i++) {
		        var oDiv = document.createElement("span");
		        oDiv.id = "gif-" + i;
		        mapDom.appendChild(oDiv);
		        this.$nextTick(() => {
		            this.markerPoint = new Overlay({
		                position: fromLonLat([
		                    _that.coordinates[i][0],
		                    _that.coordinates[i][1]
		                ]),
		                positioning: "center-center",
		                element: document.getElementById("gif-" + i),
		                stopEvent: false
		            });
		            this.map.addOverlay(this.markerPoint);
		        });
		    }
		}
    },
    mounted() {
        this.initMap();
        this.addGif();
    }
};
</script>
<style lang='scss' scope="scoped">
.ol-overlay-container {
    span {
        display: block;
        width: 20px;
        height: 42px;
        border-radius: 50%;
        background: url("../../assets/images/people.gif") no-repeat;
        background-size: 20px 42px;
    }
}
</style>
```