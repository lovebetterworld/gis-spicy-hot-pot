- [OpenLayers实战（五）聚合，自定义聚合，特效聚合_A_Big_Banana的博客-CSDN博客_openlayers 聚合](https://blog.csdn.net/qq_43766999/article/details/120345065)

## 地图提供的聚合能力

1. 创建矢量数据源vectorSorce
2. 创建聚合数据源clusterSource
3. 创建矢量图层并添加到map中

```typescript
// 矢量数据源
[见（三）创建自定义图标](https://blog.csdn.net/qq_43766999/article/details/120344401)
let vectorSorce = new ol.source.Vector({ 
	features:createFeatures(res.data);,
});
// 聚合数据源
let clusterSource = new ol.source.Cluster({ 
    distance: 100, // 自动聚合距离（以像素为单位，默认20）
    source: vectorSorce,
});
// 矢量图层
let clusterLayer = new ol.layer.Vector({ 
    source: markerSource,
    style:(feature,resolution)=>{}, // 自定义样式
});
this.map.addLayer(clusterLayer); // 添加图层

// 查询结果转换为fetura数组
function createFeatures(arr) {
    return arr.map(item => {
        let arr = item.coordinate.split(',');
        let lonAndLat = [Number(arr[0]), Number(arr[1])];
        return new ol.Feature(new ol.geom.Point(lonAndLat));
    });
}
```

注意：聚合数据源里面的feature的几何属性经纬度信息必须为Number类型
原本Feature对象里面通过set()方法添加的属性，在Cluster里面都没有了

## 通过监听缩放级别实现自定义伪聚合效果

```typescript
// 1.监听地图moveend事件
map.on("moveend", () => {
    let zoom = map.getView().getZoom();
    if (_this.zoom !== zoom) {
        _this.zoom = zoom;
    }
});
// 2.$.watch中监听zoom变化
const App = {
    data(){ 
        return{
            zoom:0,
        }
    },
    watch:{
        watch: {
            zoom: function (newVal, oldVal) {
                this.handleZoomChange(newVal, oldVal);
            },
        },
    },
    methods:{
        handleZoomChange(newVal,oldVal){
            let oldLevel = ZOOM_LEVEL[oldZoom];
            let newLevel = ZOOM_LEVEL[newZoom];
            let scale = ZOOM_SCALE[this.zoom];
            let source = this.iconLayer.getSource();
            // 判断是否需要重新写渲染
            if (newLevel !== oldLevel) {
                source.clear(); // 先清空数据
                let newFeatures = [];
                // 重新构造数据源
                // .....
                source.addFeatures(newFeatures);
            }else{
                // 只是根据缩放等级改变图标大小
                let features = source.getFeatures();
                features.forEach(item => {
                    item.getStyle().getImage().setScale(scale);
                    item.changed(); // 改变图标大小后刷新
                });
            }
        },
    },
}
```

## 有动画的特效聚合

在确定聚合图标较少时候，可以通过overlayer做特效聚合，达到自定义效果

1. 准备一个循环输出的div，注意绑定id

```html
<div v-for="item in clustersData" :key="item.id" :id="item.id" class="clusters-box"></div>
```

1. 遍历输出overlayer

```typescript
let clustersData = res.data;
this.clustersData = clustersData;
let dom = document.getElementById(item.id);
let layer = new ol.Overlay({
	element: dom,
	position: [item.lon, item.lat],
	offset: [0, 0],
	autoPan: true,
	stopEvent: true,
});
this.map.addOverlay(layer);
```