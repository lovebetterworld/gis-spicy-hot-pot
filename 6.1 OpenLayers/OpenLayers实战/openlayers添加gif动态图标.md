# openlayers添加gif动态图标

原文地址：https://www.giserdqy.com/secdev/openlayers/34888/

## 功能说明

地图开发过程中会遇到动态标注，如火灾，地震，事故发生点动态标注，openlayers icon不支持gif图片的渲染，总结了解决方案，实现功能如下

- 地图上添加动画图标
- 改变动态图标位置

## 功能实现

1. 准备动态gif图标
2. 添加html元素
3. 添加overlay
4. 动态设置图标显示与位置

## 添加html元素

```js
//id 大小可根据图标来设置
<div id="marker" title="Marker" style="height: 40px; width: 27px;"></div>
```

## 添加overlay

```js
var marker = new ol.Overlay({
    position: [0,0],
    positioning: 'center-bottom',
    element: document.getElementById('marker'),
    //stopEvent: false,
    offset: [-13.5, -40]//根据图标大小设置偏移位置
});
map.addOverlay(marker);
```

## 动态设置图标，改变坐标

```js
var src = '../Content/HomeMap/images/' + type + '.gif';
var css = {
    background: 'url(' + src + ')'
};
$('#marker').css(css);
marker.setPosition(coordinate);//位置
```