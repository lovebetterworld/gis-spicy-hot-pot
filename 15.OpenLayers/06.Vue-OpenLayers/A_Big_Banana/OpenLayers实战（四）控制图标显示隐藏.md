- [OpenLayers实战（四）控制图标显示隐藏_A_Big_Banana的博客-CSDN博客_openlayers 隐藏feature](https://blog.csdn.net/qq_43766999/article/details/120344779)

## 将同一图层的元素（feature）按条件显示或隐藏

```javascript
// 接前面（三）图层和vectorSource数据源，遍历source数据源，将符合条件的feature的style置空或者重新设置样式
let vectorLayer = this.vectorLayer;
let features = vectorSource.getFeatures();
features.forEach(feature=>{
    if(xxx){
        feature.setStyle(null); // 隐藏
    }
    if(xxx){
        feature.setStyle(customIcon(marker)) // 重现
    }
});
```