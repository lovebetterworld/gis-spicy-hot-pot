- [Vue + OpenLayers 实时定位（三） 前后端联调](https://blog.csdn.net/weixin_39340061/article/details/108201024)



本文主要打通前后端，使前端通过后台服务获取数据（模拟）。并在前台展示。

# 一、最终效果

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200824155551214.gif#pic_center)

# 二、重新定义 Vue Data

```js
data() {
    return {
        map: {},  // 地图
        geoData: {},  // 定位数据
        vectorSource: new VectorSource()  // 便签展示层的数据源，改变它实现标签展现的变化
    };
},
```

# 三、定义个 watch 监视定位数据的变化

```js
watch: {
    geoData(val) {
        if (val) {
            var features = new GeoJSON().readFeatures(this.data);
            //调用展示方法
            this.translate(features);
        }
    }
}
```

# 四、修改展示方法

```js
translate(features) {
    // 先将定位点清空，这是最简单的实现，实际项目中需要优化
    this.vectorSource.forEachFeature(f => {
        this.vectorSource.removeFeature(f);
    });
    // 展示本次获取的定位
    this.vectorSource.addFeatures(features);
}
```

# 五、向后端请求数据

```js
getLocation() {
    this.axios
        .get("/locations")
        .then(result => {
        if (result.status == 200 && result.data.code == 0) {
            //请求成功时，修改 vue data
            this.geoData = result.data.data;
        } else {
            this.$message.error("定位服务故障，请求定位失败");
        }
    })
        .catch(e => {
        console.log(e);
        this.$message.error("网络故障，请联系管理员");
    });
},
```

```js
//在 mounted 设置定时任务，调用请求方法
setInterval(this.getLocation, 1000);
```

# 总结

以上就是一个实时定位示例的全部实现，通过本文了解了以下内容：

- vue 的使用，data、mounted、watch、methods 配合。实现定时任务、数据监视和其他方法处理。

- 熟悉 OpenLayers 的使用，创建地图、创建 Vector 图层、动态添加/移除 feature、样式设置等。

- GeoJSON 的作用、格式。

  

  前端完整代码：

```js
<template>
    <div>
    <span>hi, map</span>
<div id="map" class="map"></div>
</div>
</template>

<script lang="ts">
    import "ol/ol.css";
import GeoJSON from "ol/format/GeoJSON";
import Map from "ol/Map";
import View from "ol/View";
import { Circle as CircleStyle, Fill, Stroke, Style } from "ol/style";
import { OSM, Vector as VectorSource } from "ol/source";
import { Tile as TileLayer, Vector as VectorLayer } from "ol/layer";

import Vue from "vue";

var image = new CircleStyle({
    radius: 5,
    fill: new Fill({
        color: "rgba(255, 0, 0, 1)"
    }),
    stroke: new Stroke({ color: "red", width: 1 })
});

var styles = {
    Point: new Style({
        image: image
    })
};

var styleFunction = function(feature) {
    return styles[feature.getGeometry().getType()];
};

export default Vue.extend({
    data() {
        return {
            map: {},
            geoData: {},
            vectorSource: new VectorSource()
        };
    },
    mounted() {
        var vectorLayer = new VectorLayer({
            source: this.vectorSource,
            style: styleFunction
        });

        this.map = new Map({
            layers: [
                new TileLayer({
                    source: new OSM()
                }),
                vectorLayer
            ],
            target: "map",
            view: new View({
                center: [0, 0],
                zoom: 2
            })
        });

        setInterval(this.getLocation, 1000);
    },

    watch: {
        geoData(val) {
            if (val) {
                var features = new GeoJSON().readFeatures(this.data);
                this.translate(features);
            }
        }
    },

    methods: {
        getLocation() {
            this.axios
                .get("/locations")
                .then(result => {
                if (result.status == 200 && result.data.code == 0) {
                    this.geoData = result.data.data;
                } else {
                    this.$message.error("定位服务故障，请求定位失败");
                }
            })
                .catch(e => {
                console.log(e);
                this.$message.error("网络故障，请联系管理员");
            });
        },

        translate(features) {
            this.vectorSource.forEachFeature(f => {
                this.vectorSource.removeFeature(f);
            });

            this.vectorSource.addFeatures(features);
        }
    }
});
</script>
<style>
    .map {
        width: 100%;
        height: 600px;
    }
</style>
```

