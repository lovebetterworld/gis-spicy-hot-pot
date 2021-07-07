# MapboxGL 开发 — 总结

原文地址：https://juejin.cn/post/6908651828854915085



MapboxGL官方文档中API、案例和样式标准，写的很全。Demo中涵盖了基本开发中的大部分功能。我在使用过程遇到的一些个人觉得可以总结的地方，比较杂，希望能对你有帮助。后续，不断完善。

**注意：以下关键代码函数是在继承 了mapboxgl.Map的类中编写，即：this 是指 mapboxgl.Map 实例。**

### 底图切换

我之前的文章中有简要说明过实现原理,[看这里](https://zhuanlan.zhihu.com/p/163248525)。

在mapbox-gl中初始化创建地图的时候，我们传入的 style.json 或 style.json 地址，自然就是作为底图，之后绘制的所有图层就是专题图了。我们切换底图不能影响上层专题图，最好也不要有刷新专题图的现象。

我之前一版本的实现是，在地图load完成后，会默认在最上层加一个空图层。空图层下面的是底图，上面的是专题图。这样并不好，我个人觉得每个图层都应该有一个字段来标识，他是底图还是专题图，制图并不会帮我们去标识。我重写的 map 的 addLayer 方法，除非我们特意指定，不然layer中metadata对象的isBaseMap默认为false。这样，除了创建地图传入的地图没有metada信息，其他所有图层只要我们调用addLayer都会包含一个isBaseMap标识。所以判断是否为底图可以这样：

- layer对象中，没有metadata字段，是底图；
- layer对象中，有metadata字段，但metadata.isBaseMap为ture，是底图。

```javascript
    addLayer(layer, beforeId) {
            if (!layer.metadata) {
                layer.metadata = {
                    isBaseMap: false,
                };
            }
            super.addLayer(layer, beforeId);
        }
复制代码
        /**
         * 切换地图
         * @param {*} data
         * @param {*} options
         */
    changeBaseMap(data, options) {
            let opt = Object.assign(options, {
                isBaseMap: true,
            });
            this._removeBaseStyle();
            this.addMapStyle(data, opt);
        }
       /**
         * 移除底图
         */
    _removeBaseStyle() {
            let { layers } = this.getStyle();
            for (let layer of layers) {
                if (!layer.metadata || (layer.metadata && layer.metadata.isBaseMap == true)) {
                    this.removeLayer(layer.id);
                }
            }
        }
     /**
         * 加载标准mapbox样式文件
         * @param {*} styleUrl
         * @param {*} options
         */
    addMapStyle(styleJson, options) {
            let { styleid, isBaseMap } = options;
            if (typeof styleJson != 'object') {
                throw new TypeError('addMapStyle需要传入对象类型参数');
            }
            let { zoom, center, pitch } = styleJson;
            Object.keys(styleJson.sources).forEach((key) => {
                if (!this.getSource(key)) {
                    this.addSource(key, styleJson.sources[key]);
                }
            });
            if (styleJson.sprite) {
                this._addImages(styleJson.sprite);
            }
            const layerMetaData = {
                isBaseMap: isBaseMap || false,
                aid: `${styleid}`,
            };
            for (const layer of styleJson.layers) {
                let layerid = layer.id;
                layer.metadata = layerMetaData;
                if (!this.getLayer(layerid)) {
                    let firstSpeLayer = this._findFirstSpeLayer();
                    if (isBaseMap && firstSpeLayer) {
                        this.addLayer(layer, firstSpeLayer.id);
                    } else {
                        this.addLayer(layer);
                    }
                }
            }
            if (zoom) {
                this.setZoom(zoom);
            }
            if (pitch) {
                this.setPitch(pitch);
            }
            if (center) {
                this.setCenter(center);
            }
        }
        /**
         * 解析雪碧图，穿件canvas绘制图标
         * @param {*} spritePath
         */
    _addImages(spritePath) {
            let self = this;
            fetch(`${spritePath}.json`)
                .then((result) => result.json())
                .then((spriteJson) => {
                    const img = new Image();
                    img.onload = function() {
                        Object.keys(spriteJson).forEach((key) => {
                            const spriteItem = spriteJson[key];
                            const { x, y, width, height } = spriteItem;
                            const canvas = createCavans(width, height);
                            const context = canvas.getContext('2d');
                            context.drawImage(img, x, y, width, height, 0, 0, width, height);
                            const base64Url = canvas.toDataURL('image/png');
                            self.loadImage(base64Url, (error, simg) => {
                                if (self.hasImage(key)) {
                                    self.removeImage(key);
                                }
                                // console.log(1);
                                self.addImage(key, simg);
                            });
                        });
                    };
                    img.crossOrigin = 'anonymous';
                    img.src = `${spritePath}.png`;
                });
        }
        /**
         * 查询第一个非底图图层
         */
    _findFirstSpeLayer() {
            let { layers } = this.getStyle();
            for (let layer of layers) {
                if (layer.metadata && layer.metadata.isBaseMap == false) {
                    return layer;
                }
            }
            return null;
        }
```

### 地图服务加载

我之前在文章中有简要说明过,[看这里](https://zhuanlan.zhihu.com/p/141725135)。

这里我们考虑 wgs84、cgcs2000、web 墨卡托(EPSG:4326、EPSG:4490、EPSG:3857）。

- wgs84
- cgcs2000
- web 墨卡托

原生 mapboxgl 支持的是 3857；对于 wgs84 和 cgcs2000 球面坐标，我们使用 mapboxgl 扩展库加载[@cgcs2000/mapbox-gl](https://www.npmjs.com/package/@cgcs2000/mapbox-gl)；我们加载地图服务，不考虑 wgs84 和 cgcs2000 的区别，实际上他们的参考椭球非常相近，椭球常数中仅扁率有细微差别，虽然有微小差异，但是，在当前测量精度水平下这种微小差值是可以忽略。

*如果是 4326 或 4490 可以使用[@cgcs2000/mapbox-gl](https://www.npmjs.com/package/@cgcs2000/mapbox-gl)，服务加载只要将下面对应 3857 改成 4490 或 4326 就可以了。*

#### ArcGIS 切片服务

```javascript
       /**
         *加载arcgis 切片服务
         * @param {*} url
         * @param {*} options
         */
    addArcGISTileLayer(url, options) {
            let { layerid } = options;
            this.addSource(layerid, {
                type: 'raster',
                tiles: [`${url}/tile/{z}/{y}/{x}`],
                tileSize: 256,
            });
            this.addLayer({
                id: layerid,
                type: 'raster',
                source: layerid,
                layout: {},
                paint: {},
            });
        }
```

#### ArcGIS 动态服务

```javascript
              /**
         *加载arcgis动态服务
         * @param {*} url
         * @param {*} options
         */
    addArcGISDynamicLayer(url, options) {
        let { layerid,layers } = options;
        this.addSource(layerid, {
            type: 'raster',
            tiles: [`${url}/export?dpi=96&transparent=true&format=png8&bbox=&SRS=EPSG:3857&STYLES=${layers}&WIDTH=256&HEIGHT=256&f=imageBBOX={bbox-epsg-3857}`],
            tileSize: 256,
        });
        this.addLayer({
            id: layerid,
            type: 'raster',
            source: layerid,
            layout: {},
            paint: {},
        });
    }
```

#### WMTS

```javascript
       /**
         *加载WMS服务
         * @param {*} url
         * @param {*} options
         */
    addWMSLayer(url, options) {
            let { layerid, layers } = options;
            this.addSource(layerid, {
                type: 'raster',
                tiles: [
                    `${url}?SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&FORMAT=image/png&TRANSPARENT=true&tiled=true&LAYERS=${layers}&exceptions=application/vnd.ogc.se_inimage&tiles&WIDTH=256&HEIGHT=256&SRS=EPSG:3857&STYLES=&BBOX={bbox-epsg-3857}`,
                ],
                tileSize: 256,
            });
            this.addLayer({
                id: layerid,
                type: 'raster',
                source: layerid,
                paint: {},
            });
        }
```

#### WMTS

```javascript
      /**
         *加载WMTS
         * @param {*} url
         * @param {layerid,layer} options
         */
    addWMTSLayer(url, options) {
            let { layerid, layer } = options;
            this.addSource(layerid, {
                type: 'raster',
                tiles: [
                    `
                 ${url}?SERVICE=WMTS&REQUEST=GetTile&layer=${layer}&Version=1.0.0&TILEMATRIX=EPSG:900913:{z}&TILEMATRIXSET=EPSG:900913&format=image%2Fpng&TileCol={x}&TileRow={y}
                 `,
                ],
                tileSize: 256,
            });
            this.addLayer({
                id: layerid,
                type: 'raster',
                source: layerid,
                paint: {},
            });
        }
```

### **模型加载**

官网有加载gltf模型[案例](https://docs.mapbox.com/mapbox-gl-js/example/add-3d-model/)，官方使用three.js结合mapbox-gl中custom layer，不过，这还是太原始了。推荐[threebox](https://github.com/peterqliu/threebox),我之前也写过一篇文章 [mapboxgl + three.js 开发实践](https://zhuanlan.zhihu.com/p/206543641)。不过写的太过于简陋。这里再推荐一个fork了threebox的库，可以尝试使用[这个](https://github.com/jscastro76/threebox)。

### **MapboxGL相机和cesium相机同步**

之前项目中想在mapboxgl中加载倾斜摄像3d-tiles格式数据，技术方向测的是[deck.gl](https://deck.gl/)和[loaders.gl](https://loaders.gl/examples)。最后也出来了，但是在数据优化性能方面还是不行。最后选择mapboxgl+cesium融合的技术路线。如果是mapbox+cesium相结合，自然就是要解决在切换场景相机同步的问题。具体实现细节看**[这里](https://github.com/limzgiser/cesium-mapboxgl-syncamera)**.

mapbox-gl相机

- center 定图定位中心
- pitch 地图倾角
- bearing 地图旋转角
- zoom 地图级别

cesium 相机

相机位置、角度（欧拉角）

- position 相机位置
- pitch 相机抬头、低头角度
- heading 相机左右、摇头角度
- roll 相机沿着看的方向轴旋转角

**关键公式**

- 根据cesium相机高度计算mapbox地图zoom级

```javascript
function getElevationByZoom(map, zoom) {
	// 长半轴 6378137
 return (2 * Math.PI * 6378137.0) / Math.pow(2, zoom) / 2 / Math.tan(map.transform._fov / 2);
}
```

- 根据mapbox中zoom级别计算cesium中相机高度

```javascript
function getZoomByElevation(map, elevation) {
	return Math.log2((2 * Math.PI * 6378137.0) / (2 * elevation * Math.tan(map.transform._fov / 2)));
}
```

### 控制图层顺序

最初，在使用mapbox开发的时候，发现控制图层顺序很让人觉得不方便，相比openlayers而言。即使mapboxgl 的addLayer方法的第二个参数允许我们传入beforeId，就是当前图层插到哪个图层前面，如果你不传，那就是添加到最上面。这挺好，不过你要确保beforeId图层在地图中。在有些场景中，我们希望我addLayer的所有图层都按照点、线、面、体分组，无论我什么时候添加图层，我都希望，点永远在最上层，下面是线，然后是面、体。我添加一个面，就把当前面插到面图层组的最上面，这样不至于，加载一个很大的面，啪，一下把所有图层都盖住了，这样不好。

实现方式也比较简单，我们在地图load完成后，偷偷的在地图中加载多个空图层，这里就是我们说的分组边界。将beforeId指向这些边界，这些边界一定存在，因为它们是你在地图load完成后自己添加进去的。

```javascript
    /**
      * 添加默认图层组
    */
    addGroupLayer() {
            this.addLayer({
                id: 'cityfun.null.fill',
                type: 'fill',
                source: {
                    type: 'geojson',
                    data: null,
                },
            });
            this.addLayer({
                id: 'cityfun.null.line',
                type: 'line',
                source: {
                    type: 'geojson',
                    data: null,
                },
            });
            this.addLayer({
                id: 'cityfun.null.symbol',
                type: 'symbol',
                source: {
                    type: 'geojson',
                    data: null,
                },
            });
        }
/// 这样使用 -- 这样就可以方便控制图层顺序了
this.addLayer(layer,'cityfun.null.line') 
```

### 取消地图订阅事件

mapboxgl event.off 方法可以取消地图事件订阅，注意取消订阅地图事件需要传入回调函数引用。我们可以在注册事件的时候off也可以在组件销毁的时候off。

```javascript
bindMapEvent() {
  const self = this;
  if (this.callback) {
    this.map.off('click', this.callback);
  }
  this.callback = function (e) {
    // this
    // self
  };
  this.map.on('click', this.callback);
}
```

### 解决图层事件冲突

如果需要给地图上两个相互叠加并且相互重贴的图层绑定点击事件，当我们点击上面一个图层的时候，会同时触发下面图层的回调函数。这当然是理所当然的，因为我们确实需要订阅两个图层的点击事件。某些应用场景中，我们就希望只触发上层图层的点击事件，改怎么处理。

`e.preventDefault()`会阻止mapbox一写默认行为，它并不会阻止我们自己代码里的一些冲突。幸运的是，在调用`e.preventDefault()`之后，`e.defaultPrevented`会被修改为true。因此我们可以这么处理：

注意：

- 使用这种方式并不能阻止回调函数的调用，其实它还是调用了，只是，我们在判断`e.defaultPrevented`为true后阻止后面代码的执行。
- 叠加在上面的图层需要先被订阅，如：layer-01在layer-02上面，`*`行代码就应该在`**`前面执行。

```javascript
let callback_01 = function (e) {
        if (e.defaultPrevented) {
          return;
        }
        e.preventDefault();
       // do something
      };
let callback_02 = function (e) {
        if (e.defaultPrevented) {
          return;
        }
        e.preventDefault();
       // do something
      };
 mapboxmap.on('click',  'layer-01',callback_01);  // * 行
 mapboxmap.on('click',  'layer-02',callback_02); // ** 行
```

### 业务模块图层相互串的问题

我们前端框架用的是Angular。我们开发很多系统，大多都是共用底图。也就是切换业务模块底图是不会随着业务模块的切换而刷新的。异步编程，你并不知道各个业务模块发起的网络请求什么时候才能拿到数据，在数据上图前，我都离开了当前模块，数据还绘制到图层，那就不对了。所以，你需要管理好各个模块的异步任务。

ng中httpClient网络请求会返回是一个可订阅的流，当发起多个接口请求时，结果未响应之前，业务模块组件销毁，我们就手动取消订阅，就可以避免我们离开当前模块还继续订阅绘制接口返回的数据。

```javascript
 for (const item of this.buslines) {
    const xhr = this.http.get(`./assets/mock.data/busEcode/20161212_${item}.txt`,
      { responseType: 'text' as 'json' }).subscribe(encodeGPS => {
          // map draw gps line
        });
      this.xhrs.push(xhr);
    }
 
// 组建销毁时候你应该取消订阅
this.xhrs.forEach(item => {
      item.unsubscribe();
});
```

### 无法hover高亮图层要素

官方案例有一个hover高亮图层要素的案例[Demo](https://docs.mapbox.com/mapbox-gl-js/example/hover-styles/)，请注意，打开它的geojson地址看一下，每个feature都有一个id字段，这是必要的，不是properties中的ID，是Feature。如果你是geojson数据源，你可以在数据源中设置generateId为true，[点这里](https://docs.mapbox.com/mapbox-gl-js/style-spec/sources/#geojson-generateId)。一般你设置这个就可以了。但是。。。有bug，真有，我不知道你们有没有遇到，不太好描述，反正就是某些要素，在hover离开的时候，并不会取消高亮状态。最后我手动给每个feature设置一个id，就可以了。如果你遇到过类似问题，可以尝试，手动添加feature的id属性。

```javascript
generatedFeatureId(geojson) {
    if (geojson && geojson.features) {
      geojson.features.forEach((element, index) => {
        element['id'] = index + 1;
      });
      return geojson;
    }
    return geojson;
}
```

### 地图定位

[turf](http://turfjs.org/)是一个很不错的空间处理分析库。就拿mabpx fitBounds功能来说，我们要fit到一个要素，也有可能是个图层。不用自己去计算外包矩形，直接使用turf空间处理函数。

```javascript
import { bbox } from '@turf/turf';
var bound = bbox({
          type: 'FeatureCollection',
          features: [],
        });
 this.mapboxglmap.fitBounds(bound, { padding: 50 });
```