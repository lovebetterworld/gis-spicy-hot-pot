- [Vue+OpenLayers加载天地图](https://blog.csdn.net/funkstill/article/details/89446015)



项目需要，实现功能:加载天地图，标注用户位置，定位到用户位置

```js
<template>
    <div id="map" ref="rootmap">
        <div id="mouse-position"></div>
</div>
</template>
<script>
            import 'ol/ol.css'
import {get as getProjection} from 'ol/proj'
import {getWidth,getTopLeft} from 'ol/extent'
import View from 'ol/View'
import Map from 'ol/Map'
import TileLayer from 'ol/layer/Tile'
import WMTS from 'ol/source/WMTS'
import WMTSTileGrid from 'ol/tilegrid/WMTS'
import VectorSource from 'ol/source/Vector'
import VectorLayer from 'ol/layer/Vector'
import Feature from 'ol/Feature'
import Point from 'ol/geom/Point'
import olStyle from 'ol/style/Style'
import olstyleIcon from 'ol/style/Icon'
import olstyleText from 'ol/style/Text'
import olstyleFill from 'ol/style/Fill'
import olstyleStroke from 'ol/style/Stroke'
import {defaults as defaultControls} from 'ol/control'
import MousePosition from 'ol/control/MousePosition'
import {createStringXY} from 'ol/coordinate'
export default {
    name:'OlMap',
    props:['tableData','targetPoint'],
    data(){
        return {
            map1:null,
            view:null,
            vectorSource:null,
            mousePositionControl:null
        }
    },
    mounted(){
        //渲染地图
        var projection = getProjection('EPSG:4326');
        var projectionExtent = projection.getExtent();
        var size = getWidth(projectionExtent) / 256;
        var resolutions = new Array(18);
        var matrixIds = new Array(18);
        for(var z=1;z<19;++z){
            resolutions[z]=size/Math.pow(2,z);
            matrixIds[z]=z;
        }
        var webKey = '你的key';
        var wmtsUrl_1 = 'http://t{0-7}.tianditu.gov.cn/vec_c/wmts?tk='; //矢量底图
        var wmtsUrl_2 = 'http://t{0-7}.tianditu.gov.cn/cva_c/wmts?tk='; //矢量注记
        this.view = new View({
            center:[116.0,40.040],
            projection:projection,
            zoom:8
        });
        this.mousePositionControl = new MousePosition({
            coordinateFormat:createStringXY(4),
            projection:'EPSG:4326',
            className:'custom-mouse-position',
            target:document.getElementById('mouse-position'),
            undefinesHTML:'&nbsp;'
        })
        this.map1 = new Map({
            controls:defaultControls().extend([this.mousePositionControl]),
            layers:[
                new TileLayer({
                    opacity:0.7,
                    source:new WMTS({
                        url:wmtsUrl_1+webKey,
                        layer:'vec',
                        matrixSet:'c',
                        format:'tiles',
                        style:'default',
                        projection:projection,
                        tileGrid:new WMTSTileGrid({
                            origin:getTopLeft(projectionExtent),
                            resolutions:resolutions,
                            matrixIds:matrixIds
                        }),
                        wrapX:true
                    })
                }),
                new TileLayer({
                    opacity:0.7,
                    source:new WMTS({
                        url:wmtsUrl_2+webKey,
                        layer:'cva',
                        matrixSet:'c',
                        format:'tiles',
                        style:'default',
                        projection:projection,
                        tileGrid:new WMTSTileGrid({
                            origin:getTopLeft(projectionExtent),
                            resolutions:resolutions,
                            matrixIds:matrixIds
                        }),
                        wrapX:true
                    })
                })
            ],
            target:'map',
            view:this.view
        });
        this.vectorSource = new VectorSource({
            features:[]
        });
        //初始化矢量图层
        var vectorLayer = new VectorLayer({
            source:this.vectorSource
        });
        //将矢量图层添加到map
        this.map1.addLayer(vectorLayer);
    },
    watch:{
        tableData(n,o){
            this.vectorSource.clear();
            for(var i=0;i<n.length;i++){
                this.addMarker(n[i].username,n[i].lon,n[i].lat);
            }
        },
        targetPoint(n,o){
            this.vectorSource.clear();
            this.addMarker(n.username,n.lon,n.lat);
            this.view.animate({
                center:[n.lon,n.lat],
                duration:1000,
                zoom:12
            })
        }
    },
    methods:{
        /*
        *标注点
        */
        addMarker(username,lon,lat){
            var newFeature = new Feature({
                geometry:new Point([lon,lat]),
                name:username
            });
            //设置样式
            newFeature.setStyle(createLabelStyle(newFeature));
            //将当前要素加入矢量数据源
            this.vectorSource.addFeature(newFeature);
            //创建标注的样式
            function createLabelStyle(fe) {
                //返回一个样式
                return new olStyle({
                    image:new olstyleIcon({
                        anchor:[0.5,70],
                        anchorOrigin:'top-right',
                        anchorXUnits:'fraction',
                        anchorYUnits:'pixels',
                        offsetOrigin:'top-right',
                        opacity:0.75,
                        scale:0.5,
                        src:'../../static/images/locate.png'
                    }),
                    text:new olstyleText({
                        textAlign:'center',
                        textBaseline:'middle',
                        font:'normal 20px 微软雅黑',
                        text:fe.get('name'),
                        fill:new olstyleFill({color:'#000'}),
                        scale:0.7,
                        stroke:new olstyleStroke({color:'pink',width:2})
                    })
                });
            }
        }
    }
}
</script>
<style>
    #map{
height:100%;
}
#mouse-position {
float: right;
position: absolute;
right:3px;
width: 200px;
height: 20px;
/* 将z-index设置为显示在地图上层 */
z-index: 2000;
}
/* 显示鼠标信息的自定义样式设置 */
    .custom-mouse-position {
        color: black;
        font-size: 16px;
        font-family: "Arial";
    }
</style>
```

