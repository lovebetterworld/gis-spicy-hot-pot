> 记录一个开发中遇到的Bug，关于OpenLayer的投影坐标系的问题。



```js
this.map = new Map({
    target: "container",
    layers: [
        new TileLayer({
            source: new XYZ({
                url: "https://wprd0{1-4}.is.autonavi.com/appmaptile?lang=zh_cn&size=1&style=7&x={x}&y={y}&z={z}",
            }),
        }),
    ],
    view: new View({
        projection: "EPSG:4326",    //使用这个坐标系
        // center: fromLonLat([118.903532, 32.053145]),  //南京
        center: [118.903532, 32.053145],  //南京
        zoom: 12
    }),
    )}
```

在初始化地图的时候，将projection投影坐标系设置为4326。

但是下一步，设置center坐标点的时候，却是通过`fromLonLat([118.903532, 32.053145])`进行设置的。

得，凉凉，底图都不出来。

原因：

- fromLonLat是将`EPSG:4326`转换为`EPSG:3857`；而toLonLat是将`EPSG:3857`转换为`EPSG:4326`

设置投影得时候，已经将底图坐标系设置为4326得了，下面却将中心坐标设置为3857格式，肯定显示不出来了。

卒，忙活了一下午。