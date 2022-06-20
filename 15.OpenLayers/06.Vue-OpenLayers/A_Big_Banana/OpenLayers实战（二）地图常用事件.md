- [OpenLayers实战（二）地图常用事件_A_Big_Banana的博客-CSDN博客_openlayers 地图事件](https://blog.csdn.net/qq_43766999/article/details/120344158)

## [监听](https://so.csdn.net/so/search?q=监听&spm=1001.2101.3001.7020)map常用事件

```javascript
// ===== 事件类型 =====
'click',// 单击
'dblclick',// 双击
'singleclick',// 单击，延迟250毫秒

'moveend',// 鼠标滚动事件
'pointermove',// 鼠标移动事件
'pointerdrag',// 鼠标拖动事件
    
'precompose',//地图准备渲染，为渲染
'postcompose',//地图渲染中
'postrender',//地图渲染全部结束

'change:layerGroup',// 地图图层增删时触发
'change:size',// 地图窗口发生变化就会触发
'change:target',// 地图绑定的div发生更改时触发
'change:view',// 地图view对象发生变化触发
'propertychange',// Map对象中任意的property值改变时触发

```

## 最最最常用的事件

```javascript
// ===== 监听地图单击事件 =====
map.on('singleclick', e => {
    let feature = map.forEachFeatureAtPixel(e.pixel, feature => feature);
    if (feature) {
        // do something
    } else {
        console.log('click the map get coordinate', e.coordinate.join());
    }
});

// ===== 监听地图双击事件 =====
map.on("dblclick", e => {
    let feature = map.forEachFeatureAtPixel(e.pixel, feature => feature);
    if (feature) {
        // do something
        return false;
    }
})

// ===== 为map添加鼠标移动事件监听（当指向“要素”时改变鼠标光标状态） =====
map.on('pointermove', e => {
    let pixel = map.getEventPixel(e.originalEvent);
    let hit = map.hasFeatureAtPixel(pixel);
    map.getTargetElement().style.cursor = hit ? 'pointer' : '';
});

// 监听地图地图移动结束事件，（获取当前缩放等级）
map.on("moveend", e => {
    let zoom = map.getView().getZoom(); //获取当前地图的缩放级别
    // do something
});

// ===== 其它事件 =====
```