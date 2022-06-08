- [OpenLayers helloworld 以及加载天地图图层示例_Southejor的博客-CSDN博客_openlayer 天地图](https://blog.csdn.net/linzi19900517/article/details/123111280)

## 初识 OpenLayers

来自 [官方](https://openlayers.org/) 的翻译：一个高性能的、功能丰富、可以满足你对地图所有需求的框架。

OpenLayers 很容易在任何网页加载动态地图。它可以展示任何资源的地图瓦片、矢量数据和marker点。

OpenLayers 的开发是为了进一步加载各种类型的地理信息数据。它是完全免费的开源 JavaScript，基于 2-clause BSD 许可（也就是 FreeBSD）发布的。

这里奉上：[尚在更新中的 Openlayers 翻译](http://openlayers.vip/examples/)

## OpenLayers 的 helloworld

OpenLayers 官方的教程简单明了，一般都可以直接运行，我这里就直接粘过来，加点注释。

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <!--注意：openlayers 原版的比较慢，这里引起自己服务器版-->
    <link rel="stylesheet" href="http://openlayers.vip/examples/css/ol.css" type="text/css">
    <style>
       /* 注意：这里必须给高度，否则地图初始化之后不显示；一般是计算得到高度，然后才初始化地图 */
      .map {
        height: 400px;
        width: 100%;
      }
    </style>
    <!--注意：openlayers 原版的比较慢，这里引起自己服务器版-->
    <script src="http://openlayers.vip/examples/resources/ol.js"></script>
    <title>OpenLayers example</title>
  </head>
  <body>
    <h2>My Map</h2>
    <!--地图容器，需要指定 id -->
    <div id="map" class="map"></div>
    <script type="text/javascript">
      var map = new ol.Map({
        // 地图容器
        target: 'map',
        // 地图图层，比如底图、矢量图等
        layers: [
          new ol.layer.Tile({
            // 谷歌底图
            source: new ol.source.OSM()
          })
        ],
        // 地图视野
        view: new ol.View({
          // 定位
          center: ol.proj.fromLonLat([37.41, 8.82]),
          // 缩放
          zoom: 4
        })
      });
    </script>
  </body>
</html>
```

## openlayers 加载天地图底图

地图初始化方法跟上边一样，只是使用天地图底图，这里提供一个工具类：

先麻烦可以直接下载：[Openlayers加载天地图](https://download.csdn.net/download/linzi19900517/82194643)

使用天地图资源需要先 [申请天地图tk](https://console.tianditu.gov.cn/api/key)

```javascript
// 请使用自己的tk，笔者这里设置白名单，只有白名单域名才可以访问，否则报403
let TK = '2b7cbf61123cbe4e9ec6267a87e7442f';

// 获取天地图地址
let getUrl = function (type) {
    let url = 'http://t{randomNumber}.tianditu.gov.cn/DataServer?T={type}&x={x}&y={y}&l={z}';
	// 这里用随机数获取地址
    url = url.replace('{randomNumber}', Math.round(Math.random() * 7).toString());
    url = url.replace('{type}', type);
    url = url + "&tk=" + TK;
    return url;
}

// 获取分辨率数组
let getResolutionsExpert = function (size) {

    let resolutions = new Array(18);
    let matrixIds = new Array(18);
    for (let z = 0; z < 19; ++z) {
        //分辨率
        resolutions[z] = size / Math.pow(2, z);
        //等级
        matrixIds[z] = z;
    }
    return resolutions;
}

let getOptional = function (url) {

	// 投影坐标系
    let projection = ol.proj.get('EPSG:4326');
    let projectionExtent = projection.getExtent();
    let size = ol.extent.getWidth(projectionExtent) / 256;

    return new ol.source.XYZ({
        crossOrigin: 'anonymous',
        wrapX: true,
        //切片xyz获取方法
        tileUrlFunction: function (tileCoord) {
            const z = tileCoord[0];
            const x = tileCoord[1];
            let y = tileCoord[2];
            let completeUrl = url.replace('{z}', z.toString())
                .replace('{y}', y.toString())
                .replace('{x}', x.toString());
            return completeUrl;
        },
        //坐标系
        projection: projection,
        tileGrid: new ol.tilegrid.TileGrid({
            origin: ol.extent.getTopLeft(projectionExtent),
            tileSize: [256, 256],
            //分辨率数组
            resolutions: getResolutionsExpert(size)
        }),
    })
}

// const type = 'w'; // 墨卡托
let TYPE = 'c';  // WGS84
//影像图参数
let IMG_C = 'img_c' + TYPE;
let CIA_C = 'cia_c' + TYPE;
let IBO_C = 'ibo_c' + TYPE;

//矢量图
let VEC_C = 'vec_' + TYPE;
let CVA_C = 'cva_' + TYPE;
//地形图
let TER_C = 'ter_' + TYPE;

// 影像图
function getIMG_CLayer() {
    let layer = new ol.layer.Tile({
        name: "天地图影像图层",
        source: getOptional(getUrl(IMG_C))
    });
    return layer;
}
// 注记
function getCIA_CLayer() {
    let layer = new ol.layer.Tile({
        name: "天地图影像注记图层",
        source: getOptional(getUrl(CIA_C)),
        zIndex: 1,
    });
    return layer;
}
// 境界
function getIBO_CLayer() {
    let layer = new ol.layer.Tile({
        name: "天地图影像境界图层",
        source: getOptional(getUrl(IBO_C)),
        zIndex: 1,
    });
    return layer;
}
```

天地图图层在线地址：[墨卡托](https://blog.csdn.net/linzi19900517/article/details/82255525)

## 在线示例

**地图初始化：**[Openlayers helloworld](http://openlayers.vip/examples/csdn/Openlayers-helloworld.html) （有的网不能访问谷歌地图资源）

**加载天地图底图：**[Openlayers tianditu](http://openlayers.vip/examples/csdn/Openlayers-tianditu.html)