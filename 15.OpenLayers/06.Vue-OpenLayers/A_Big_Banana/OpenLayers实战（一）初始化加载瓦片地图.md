- [OpenLayers实战（一）初始化加载瓦片地图_A_Big_Banana的博客-CSDN博客_openlayers加载瓦片地图](https://blog.csdn.net/qq_43766999/article/details/120343625)

## 地图初始化，加载瓦片地图

```javascript
// ===== 抽出基本地图配置项，用于快速切换地图源 =====
const mapConfig = {
    urlOSM:'url',
    // 镜头
    center:[lon,lat],
    zoom:15,
    minZoom:0,
    maxZoom:19,
}

// ===== methods中写一个方法用来初始化渲染地图层 =====
methods:{
	loadMap(){
		// 地图层,使用OSM
		let mapLayer = new ol.layer.Tile({ 
		    source: new ol.source.OSM();
		});
		// 初始镜头
		let mapView = new ol.View({ 
		    center: mapConfig.center,
		    zoom: mapConfig.zoom,
		    maxZoom: mapConfig.maxZoom,
		    minZoom: mapConfig.minZoom,
		    // other options
		});
		// 地图对象
		const map = new ol.Map({ 
		    target: 'map', // 目标容器
		    layers: [mapLayer],
		    view: mapView, 
		});
		
		// 在$data中存储一下
		this.map = map;
	},
}

// ===== mounted中调用初始化方法 =====
mounted(){
	this.loadMap();
}
```