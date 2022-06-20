- [OpenLayers实战（三）地图打点，自定义图标_A_Big_Banana的博客-CSDN博客_openlayer 打点](https://blog.csdn.net/qq_43766999/article/details/120344401)

## 往地图中添加删除层（[layer](https://so.csdn.net/so/search?q=layer&spm=1001.2101.3001.7020)）和元素（feature）

```typescript
// ===== 创建数据源和图层并加入map的图层 =====
let vectorSource = new ol.source.Vector({ // 矢量数据源
    features: [],
});
let vectorLayer = new ol.layer.Vector({ // 矢量图层
    style: null, // 设置style为null，后面可以通过改变样式控制marker的显示隐藏
    source: vectorSource,
});
map.addLayer(vectorLayer); 
// 在$data中保存图层
this.vectorLayer = vectorLayer;

// ===== 清空全部feature =====
function clearAllMarker(){
    vectorSource.clear();
}

// ===== 添加一个新的自定义图标 =====
function addOneMarker(marker={}) {
    if (marker.coordinate) { // 是否有经纬度
        let lonAndLat = item.coordinate.split(',');
        let newFeature = new ol.Feature({ // 创建一个类型为Point的feature
            geometry: new ol.geom.Point(lonAndLat), // 几何信息
            name: marker.name || '', 
        });
        newFeature.set('key','value'); // 可以给当前元素绑定一个自定义key-value
        newFeature.setStyle(customStyle(marker.type)); // 设置feature的自定义样式
        markerSource.addFeature(newFeature); // 将新要素添加到数据源中
    }
}

// ===== 批量添加自定义图标 =====
function addMarkers(markers=[]){
    // 遍历markers并转换为features
    let features = markers.map(item => {
        if(item.coordinate){
            let lonAndLat = item.coordinate.split(',');
            let feature = new ol.Feature({
                geometry: new ol.geom.Point(lonAndLat),
                name: item.featureName || '',
            });
            feature.setStyle(customStyle(item.type));
            feature.set('key','value');
            return feature;
        }        
    });
    markerSource.addFeatures(features);
}
```

## 创建ol自定义Style（简单封装一下）

```javascript
/**
 * 封装一个方法快速返回自定义样式
 * @param type 类型，目前只写了circle以及icon
 * @param params 具体要自定义的属性
 * @returns {ol.style.Style}
 */
function customStyle(type, params = {}) {
    return new ol.style.Style({
        image: getImageStyle(params),
        text: getTextStyle(params),
    });
    // 自定义图片
    function getImageStyle(params = {}) {
        switch (type.toLowerCase()) {
            case 'circle':
                let circle = params.circle || {};
                return new ol.style.Circle({
                    radius: circle.radius || 10,
                    stroke: new ol.style.Stroke({
                        color: circle.strokeColor || '#DC143C'
                    }),
                    fill: new ol.style.Fill({
                        color: circle.fillColor || '#3399CC'
                    })
                })
            case 'icon':
                let icon = params.icon || {};
                return new ol.style.Icon({
                    src: icon.url || '../pub/img/blueIcon.png', // 路径
                    offset: icon.offset || [0, 0], // 偏移，默认为 [0, 0]
                    scale: icon.scale || 1, // 图标缩放比例，默认为 1
                    opacity: icon.opacity || 1, // 透明度，默认为 1
                });
            default:
                return null;
        }

    }
    // 自定义文字
    function getTextStyle(params = {}) {
        let text = params.text || {};
        return new ol.style.Text({
            text: text.content || '', // 文本内容
            font: text.font || 'normal 14px 微软雅黑', //文字样式
            fill: new ol.style.Fill({
                color: text.fillColor || '#333'
            }), // 文字颜色
            stroke: new ol.style.Stroke({
                color: text.strokeColor || '#ffcc33',
                width: text.strokeWidth || 2,
            }), // 文字描边
            textAlign: text.textAlign || 'center', // 文字对齐
            textBaseline: text.textBaseline || 'middle', //基准线
            offsetX: text.offset ? markerText.offset[0] : 0, // X轴偏移
            offsetY: text.offset ? markerText.offset[1] : 0, // Y轴偏移
        })
    }
}
```