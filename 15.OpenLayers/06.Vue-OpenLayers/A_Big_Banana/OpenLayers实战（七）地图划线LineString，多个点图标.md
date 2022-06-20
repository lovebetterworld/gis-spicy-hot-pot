- [OpenLayers实战（七）地图划线LineString，多个点图标_A_Big_Banana的博客-CSDN博客_linestring openlayers](https://blog.csdn.net/qq_43766999/article/details/120527511)

## 连接地图上的feature

1. 准备多个用于连线的测试数据点

```typescript
// 可以通过监听地图click事件，获取地图点击时候的坐标，用作测试数据
map.on('singleclick', e => {
    console.log('click the map get coordinate', e.coordinate);
});

data(){
	return{
		arr : [
			[113.54381132, 22.26603718],
			[113.54210586, 22.25908172],
			[113.54272867, 22.24522491],
			[113.52521249, 22.26081840],
			[113.53888402, 22.28296649],
		 	[113.56272589, 22.28156777],
			[113.56545975, 22.27349332],
		],
	}
}
```

1. 构造LineString元素，创建并往map中添加矢量层

```typescript
methods:{
   createLineString(){
       let arr = this.testData;

       // 创建一个 线元素
       let lineFeature = new ol.Feature({
           geometry: new ol.geom.LineString(arr),
           type: 'lineString', // 指定type属性，用于匹配style，以及在feature点击事件中做出不同的操作
       });
       // 还可以添加起点和终点
       let startFeature = new ol.Feature({
           geometry: new ol.geom.Point(arr[0]),
           type:'startPoint',
       });
       let endFeature = new ol.Feature({
           geometry: new ol.geom.Point(arr[arr.length-1]),
           type:'endPoint',
       });

       // 创建一个矢量层
       let lineLayer = new ol.layer.Vector({
           source: new ol.source.Vector({
               features: [startFeature,lineFeature,endFeature],
           }),
           style: (feature)=>{
               return getStyle(feature.get('type'));
           },
           zIndex: 1,
       });
       // 往地图实例中加入改层
       this.map.addLayer(lineLayer);

       // 封装一下feature样式
       function getStyle(type){
           let style = null;
           switch(type){
               case 'lineString'  :
                   return new ol.style.Style({
                       stroke: new ol.style.Stroke({
                           width: 5, 		  // 线宽
                           color: '#27BB53', // 线的颜色
                       })
                   });
               case 'startPoint'  :
                   return new ol.style.Style({
                       stroke: new ol.style.Icon({
                           src: 'start.png',  // 起点图标src
                           scale:1 ,		  // 缩放比例,默认为 1
                           opacity:1, 		  // 透明度,默认为 1
                           offset:[0,0], 	  // 偏移,默认为 [0, 0]
                       })
                   });
               case 'endPoint'  :
                   return new ol.style.Style({
                       stroke: new ol.style.Icon({
                           src: 'end.png', // 终点图标src
                           scale:1 ,
                           opacity:1, 
                           offset:[0,0], 
                       })
                   });
               default:
                   return null;
           }
       }
   }
}

```

附上一个简单的算法：排序地图上多个坐标点数据，已知起点和多个其它坐标点，按照距离远近依次排序，每次都找出距离自己最近的那个点

```typescript
// 多个坐标点排序
function getPath(arr){
    // ol能力，通过经纬度计算距离
    const wgs84Sphere = new ol.Sphere(6378137);

    let path = []; //最终排序结果

    // 1.指定其中某个点为起点，就以第一个点为起点
    graphSort(arr,arr[0]);

    return path; 

    /**
     * 根据特定算法返回距离某点最近的一个点
     * @param ps 要排序的点集合
     * @param s 起点
     */
    function graphSort(ps,s){
        // 先过滤一下属性
        let arr = ps.map(item => {
            let lonLat =  [item.lon, item.lat];
            // 计算每个点距离中心的距离
            let distance;
            if(s===lonLat){
                distance = 0;
            }else{
                distance = getDistance(s,lonLat );
            }
            return {
                sn:item.sn,
                name: item.name,
                lon: item.lon,
                lat: item.lat,
                distance,
            }
        });

        // 根据distance排序
        arr.sort(function (a, b) {
            return a.distance - b.distance;
        });

        arr.splice(0, 1);// 删除第一个元素
        path.push(arr[0]); // 加入路径

        // 判断是否需要递归继续排序添加
        if (arr.length > 1) {
            graphSort(arr, [arr[0].lon, arr[0].lat])
        } else {
            path.push(arr[0]);
        }
    }
   
    function getDistance(lonAntLat1, lonAndLat2) {
        return parseInt(wgs84Sphere.haversineDistance(lonAntLat1, lonAndLat2));
    }
}
```