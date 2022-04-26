- [openlayers6【十二】vue 切片图层 TileLayer 切换地图底图，图层叠加效果_范特西是只猫的博客-CSDN博客](https://xiehao.blog.csdn.net/article/details/106540795)

##### 1. 效果图![在这里插入图片描述](https://img-blog.csdnimg.cn/20200604113441597.gif)

> 通过 `addLayer` 添加图层，通过`removeLayer` 删除图层

##### 2. html（创建 checkbox 用来切换图层）

```html
<template>
    <div id="content">
        <div id="map" ref="map"></div>
        <div id="mouse-position">
            <el-checkbox-group v-model="checkList">
                <el-checkbox label="天地图影像图" @change="changImage"></el-checkbox>
                <el-checkbox label="天地图影像标注" @change="changText"></el-checkbox>
            </el-checkbox-group>
        </div>
    </div>
</template>
```

##### 3. js (通过`map.addLayer` 实现)

```js
<script>
import "ol/ol.css";
import { Map, View } from "ol";
import TileLayer from "ol/layer/Tile";
import OSM from "ol/source/OSM";
import XYZ from "ol/source/XYZ";
import { fromLonLat } from "ol/proj";

export default {
    name: "tree",
    data() {
        return {
            map: null,
            checkList: []
        };
    },
    methods: {
        // 初始化一个 openlayers 地图
        initMap() {
            let target = "map";
            let tileLayer = [
                new TileLayer({
                    source: new XYZ({
                        url:
                            "http://map.geoq.cn/ArcGIS/rest/services/ChinaOnlineStreetPurplishBlue/MapServer/tile/{z}/{y}/{x}"
                    })
                })
            ];
            let view = new View({
                center: fromLonLat([104.912777, 34.730746]),
                zoom: 4.5
            });
            this.map = new Map({
                target: target, 
                layers: tileLayer,
                view: view 
            });
        },
        // 天地图影像图层
        changImage: function(checked, e) {
            if (checked) {
                this.TiandiMap_img = new TileLayer({
                    name: "天地图影像图层",
                    source: new XYZ({
                        url:
                            "http://t0.tianditu.com/DataServer?T=img_w&x={x}&y={y}&l={z}&tk=5d27dc75ca0c3bdf34f657ffe1e9881d", //parent.TiandituKey()为天地图密钥
                        wrapX: false
                    })
                });
                // 添加到地图上
                this.map.addLayer(this.TiandiMap_img);
            } else {
                this.map.removeLayer(this.TiandiMap_img);
            }
        },
        // 天地图影像注记图层
        changText: function(checked, e) {
            if (checked) {
                this.TiandiMap_cia = new TileLayer({
                    name: "天地图影像注记图层",
                    source: new XYZ({
                        url:
                            "http://t0.tianditu.com/DataServer?T=cia_w&x={x}&y={y}&l={z}&tk=5d27dc75ca0c3bdf34f657ffe1e9881d", //parent.TiandituKey()为天地图密钥
                        wrapX: false
                    })
                });
                // 添加到地图上
                this.map.addLayer(this.TiandiMap_cia);
            } else {
                this.map.removeLayer(this.TiandiMap_cia);
            }
        }
    },
    mounted() {
        this.initMap();
    }
};
```

##### 4. css 样式

```css
<style lang="scss" scoped>
html,
body {
    height: 100%;
    #content {
        width: 100%;
        position: relative;
        #mouse-position {
            float: left;
            position: absolute;
            top: 75px;
            right: 10px;
            width: 200px;
            height: 50px;
            padding: 10px;
            background-color: rgba(0, 0, 0, 0.6);
            /*在地图容器中的层，要设置z-index的值让其显示在地图上层*/
            z-index: 2000;
            color: white;
            .el-checkbox {
                color: white;
            }
            /* 鼠标位置信息自定义样式设置 */
            .custom-mouse-position {
                color: rgb(0, 0, 0);
                font-size: 16px;
                font-family: "微软雅黑";
            }
        }
    }
}
</style>
```