- [geoserver使用postgis数据进行矢量切片，并用openlayer加载_~疆的博客-CSDN博客_geoserver 实时矢量切片](https://blog.csdn.net/qq_40323256/article/details/120534706)

# 将shp数据导入postgis中

![img](https://img-blog.csdnimg.cn/20210928180944950.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAfueWhg==,size_17,color_FFFFFF,t_70,g_se,x_16)

![img](https://img-blog.csdnimg.cn/20210928180803679.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAfueWhg==,size_20,color_FFFFFF,t_70,g_se,x_16)

#  geoserver导入postgis数据

![img](https://img-blog.csdnimg.cn/20210928181025312.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAfueWhg==,size_20,color_FFFFFF,t_70,g_se,x_16)

![img](https://img-blog.csdnimg.cn/2021092818113078.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAfueWhg==,size_20,color_FFFFFF,t_70,g_se,x_16)

#  openlayer加载

有个问题，就是实时更新数据库中的数据后，之前已经切片过要[素数](https://so.csdn.net/so/search?q=素数&spm=1001.2101.3001.7020)据不会更新，而缩放另一个视图层级，数据又是更新的

![img](https://img-blog.csdnimg.cn/20210928181225170.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAfueWhg==,size_20,color_FFFFFF,t_70,g_se,x_16)

```html
<template>
    <div>
        <div id="map" style="width: 100vw; height: 100vh"></div>
    </div>
</template>

<script>
    import "ol/ol.css";
    import { Map, View } from "ol";
    import { VectorTile as VectorLayerTile, Tile } from "ol/layer";
    import { Style, Fill, Stroke } from "ol/style";
    import { VectorTile as VectorSourceTile, OSM, WMTS } from "ol/source";
    import { createXYZ } from "ol/tilegrid";
    import WMTSTileGrid from "ol/tilegrid/WMTS";
    import MVT from "ol/format/MVT";
    import { Projection } from "ol/proj";
    import { GeoJSON } from "ol/format";

    export default {
        name: "OlVectorTiles",
        data() {
            return {
                map: {},
            };
        },
        mounted() {
            this.initMap();
            this.clickFeature();
            this.pointerMove();
        },
        methods: {
            initMap() {
                this.map = new Map({
                    target: "map",
                    view: new View({
                        center: [10836963.115396298, 3004762.6299129482],
                        zoom: 6,
                        projection: "EPSG:3857",
                    }),
                    layers: [
                        new Tile({
                            source: new OSM(),
                        }),
                        new VectorLayerTile({
                            source: new VectorSourceTile({
                                url:
                                "http://120.76.197.111:8090/geoserver/gwc/service/tms/1.0.0/" +
                                "cite:sichuan_test_vectortile@EPSG%3A3857@pbf/{z}/{x}/{-y}.pbf",
                                format: new MVT(), //切片格式
                            }),
                            // 对矢量切片数据应用的样式
                            style: new Style({
                                fill: new Fill({
                                    color: "rgba(255,128,0,0.5)",
                                }),
                                stroke: new Stroke({
                                    color: "#40FF00",
                                    width: 1,
                                }),
                            }),
                        }),
                    ],
                });
            },
            clickFeature() {
                this.map.on("click", (e) => {
                    let feature = this.map.forEachFeatureAtPixel(e.pixel, (feature) => {
                        return feature;
                    });
                    this.$message.success(feature.get("name"));
                });
            },
            // 设置鼠标划过矢量要素的样式
            pointerMove() {
                this.map.on("pointermove", (e) => {
                    const isHover = this.map.hasFeatureAtPixel(e.pixel);
                    this.map.getTargetElement().style.cursor = isHover ? "pointer" : "";
                });
            },
        },
    };
</script>
```