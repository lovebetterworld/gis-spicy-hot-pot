- [OpenLayers实战（八）行政区域遮罩和反遮罩_A_Big_Banana的博客-CSDN博客_openlayers 遮罩](https://blog.csdn.net/qq_43766999/article/details/120708054)

### 在使用瓦片地图的时候，可以通过加入特殊的层实现行政区域遮罩和反遮罩

获取行政区域轮廓数据：http://datav.aliyun.com/tools/atlas/index.html#&lat=30.37018632615852&lng=106.68898666525287&zoom=3.5

1. 准备好瓦片地图（此处简写）

```javascript
loadMap(){
    let mapLayer = new ol.layer.Tile();
    let mapView = new ol.View();
    this.map = new ol.Map({ 
        target: 'map',
        layers: [mapLayer],
        view: mapView, 
    });
}
```

### 区域遮罩效果，某个区域上方半透明遮罩：

```javascript
data(){
    return{
        map:null,
        converLayer:null,
        reverseLayer:null,
    }
};
methods:{
    // 准备反转遮罩层
    addConverLayer(){
        let source =new ol.source.Vector();
        // 遮罩的样式
        let style = new ol.style.Style({
            fill: new ol.style.Fill({
                color: "rgba(8,31,63,0.6)",
            }),
            stroke: new ol.style.Stroke({
                color: "rgb(8,91,163)",
                width: 1
            })
        });
        let converLayer = new ol.layer.Vector({ source,  style });
        this.converLayer = converLayer;
        this.map.addLayer(converLayer);
    },
    /**
	 * 开始操作
	 * @param data 某个行政区域的轮廓数据
	 */
    draw(data){
        let features = new ol.format.GeoJSON().readFeatures(data); 
        // 直接遍历添加feature即可
        features.forEach(item => {
            if(element.get("name") === '成都市'){
                this.converLayer.getSource.addFeature(element);
            }
        });
    }
}
```

### 反转遮罩：全图半透明遮罩，指定区域擦干净

```javascript
data(){
    return{
        map:null,
        converLayer:null,
        reverseLayer:null,
    }
},
methods:{
    // 准备反转遮罩层
    addReverseLayer(){
        let source =new ol.source.Vector();
        // 遮罩的样式
        let style = new ol.style.Style({
            fill: new ol.style.Fill({
                color: "rgba(8,31,63,0.6)",
            }),
            stroke: new ol.style.Stroke({
                color: "rgb(8,91,163)",
                width: 1
            })
        });
        let reverseLayer = new ol.layer.Vector({ source,  style });
        this.reverseLayer = reverseLayer;
        this.map.addLayer(reverseLayer);
    },
    /**
	 * 开始操作
	 * @param data 某个行政区域的轮廓数据
	 */
    draw(data) {
        // 将data转换为feature
        const dataForMart = new ol.format.GeoJSON().readFeatures(data);
        // 得到反转擦除后遮盖层数据
        const converGeom = erase(dataForMart);
        const convertFt = new ol.Feature({ geometry: converGeom });
        this.converLayer.getSource().addFeature(convertFt);

        function erase(geom) {
            const polygonRing = ol.geom.Polygon.fromExtent([-180, -90, 180, 90]);
            // 擦除操作
            for (let i = 0, len = geom.length; i < len; i++) {
                let g = geom[i].getGeometry();
                const coords = g.getCoordinates();
                coords.forEach(coord => {
                    const linearRing = new ol.geom.LineString(coord[0]);
                    polygonRing.appendLinearRing(linearRing);
                });
            }
            return polygonRing;
        }
    },
}
```

## CV大法：

1. 将以下代码复制到对应位置中
2. 调用addReverseLayer()创建层
3. 获取行政区域轮廓数据data
4. 调用draw()方法并传入data数据即可
5. 大功告成