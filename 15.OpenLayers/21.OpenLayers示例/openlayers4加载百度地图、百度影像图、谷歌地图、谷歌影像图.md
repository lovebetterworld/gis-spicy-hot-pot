- [openlayers4加载百度地图、百度影像图、谷歌地图、谷歌影像图](https://www.giserdqy.com/secdev/openlayers/114/?spm=a2c4e.10696291.0.0.29c019a4GuKFEP)

```js
// 自定义分辨率和瓦片坐标系
var resolutions = [];
var maxZoom = 18;
// 计算百度使用的分辨率
for (var i = 0; i <= maxZoom + 1; i++) {
    resolutions[i] = Math.pow(2, maxZoom - i);
}
var tilegrid = new ol.tilegrid.TileGrid({
    origin: [0, 0], // 设置原点坐标
    resolutions: resolutions // 设置分辨率
});
// 创建百度行政区划
var baiduSource = new ol.source.TileImage({
    tileGrid: tilegrid,
    tileUrlFunction: function(tileCoord, pixelRatio, proj) {
        var z = tileCoord[0];
        var x = tileCoord[1];
        var y = tileCoord[2];

        // 百度瓦片服务url将负数使用M前缀来标识
        if (x < 0) {
            x = 'M' + (-x);
        }
        if (y < 0) {
            y = 'M' + (-y);
        }

        // return "http://online0.map.bdimg.com/onlinelabel/?qt=tile&x=" + x + "&y=" + y + "&z=" + z + "&styles=pl&udt=20170115&scaler=1&p=1";
        //street
        return 'http://online' + parseInt(Math.random() * 10) + '.map.bdimg.com/onlinelabel/?qt=tile&x=' +
            x + '&y=' + y + '&z=' + z + '&styles=pl&udt=20170620&scaler=1&p=1';
    }
});
// 百度影像
var baiduSourceRaster= new ol.source.TileImage({
    tileGrid: tilegrid,
    tileUrlFunction: function(tileCoord, pixelRatio, proj) {
        var z = tileCoord[0];
        var x = tileCoord[1];
        var y = tileCoord[2];

        // 百度瓦片服务url将负数使用M前缀来标识
        if (x < 0) {
            x = 'M' + (-x);
        }
        if (y < 0) {
            y = 'M' + (-y);
        }
        return 'http://shangetu' + parseInt(Math.random() * 10) + '.map.bdimg.com/it/u=x=' + x +
            ';y=' + y + ';z=' + z + ';v=009;type=sate&fm=46&udt=20170606';
    }
});
// 百度标注
var baiduSourceLabel = new ol.source.TileImage({
    tileGrid: tilegrid,
    tileUrlFunction: function(tileCoord, pixelRatio, proj) {
        var z = tileCoord[0];
        var x = tileCoord[1];
        var y = tileCoord[2];

        // 百度瓦片服务url将负数使用M前缀来标识
        if (x < 0) {
            x = 'M' + (-x);
        }
        if (y < 0) {
            y = 'M' + (-y);
        }
        return 'http://online' + parseInt(Math.random() * 10) + '.map.bdimg.com/onlinelabel/?qt=tile&x=' +
            x + '&y=' + y + '&z=' + z + '&styles=sl&udt=20170620&scaler=1&p=1';
    }
});
// 百度行政区划
var baiduMapLayer = new ol.layer.Tile({
    source: baiduSource
});

// 百度地图标注
var baiduMapLayerLabel = new ol.layer.Tile({
    source: baiduSourceLabel
});
//百度地图影像
var baiduRasterLayer = new ol.layer.Tile({
    source: baiduSourceRaster
});
//谷歌行政区划
var googleMapLayer = new ol.layer.Tile({
    source: new ol.source.XYZ({
        url: 'http://www.google.cn/maps/vt/pb=!1m4!1m3!1i{z}!2i{x}!3i{y}!2m3!1e0!2sm!3i345013117!3m8!2szh-CN!3scn!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0'
    })
});
//谷歌影像
var googleRasterLayer = new ol.layer.Tile({
    source: new ol.source.TileImage({ url: 'http://mt2.google.cn/vt/lyrs=y&hl=zh-CN&gl=CN&src=app&x={x}&y={y}&z={z}&s=G' }),
    visible: false
});
```

