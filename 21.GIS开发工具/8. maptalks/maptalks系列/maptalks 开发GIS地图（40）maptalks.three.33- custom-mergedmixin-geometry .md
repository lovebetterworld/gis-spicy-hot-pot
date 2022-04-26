- [maptalks 开发GIS地图（40）maptalks.three.33- custom-mergedmixin-geometry  ](https://www.cnblogs.com/googlegis/p/14738153.html)

1. 多重复用对象， multiplexing geometry。

2. 定义 Bar 对象。

```js
function getBar(options) {
    const { radius, height } = barCache.getOptions();
    const geometry = barCache.getObject3d().geometry;
    const scaleR = options.radius / radius, scaleH = options.height / height;
    const bar = new maptalks.BaseObject();
    bar._initOptions(Object.assign({}, barCache.getOptions(), options));
    bar._createMesh(geometry, material);
    bar.getObject3d().scale.set(scaleR, scaleR, scaleH);
    const { altitude, coordinate } = options;
    const layer = barCache.getLayer();
    const z = layer.distanceToVector3(altitude, altitude).x;
    const position = layer.coordinateToVector3(coordinate, z);
    bar.getObject3d().position.copy(position);
    return bar;

}
```

3. 处理数据

```js
const data = json.features.slice(0, 10000).map(function (dataItem) {
    dataItem = gcoord.transform(dataItem, gcoord.AMap, gcoord.WGS84);
    return {
        coordinate: dataItem.geometry.coordinates,
        height: Math.random() * 200,
        value: Math.random() * 10000,
        radius: 5 + 5 * Math.random(),
        topColor: '#fff',
        interactive: false
    }
});

barCache = threeLayer.toBox(data[0].coordinate, data[0], material);
bars.push(barCache);
data.forEach(d => {
    const bar = getBar(d);
    //event test
    ['click', 'mousemove', 'mouseout', 'mouseover', 'mousedown', 'mouseup', 'dblclick', 'contextmenu'].forEach(function (eventType) {
        bar.on(eventType, function (e) {
            console.log(e.type, e);
            // console.log(this);
            if (e.type === 'mouseout') {
                this.setSymbol(material);
            }
            if (e.type === 'mouseover') {
                this.setSymbol(highlightmaterial);
            }
        });
    });
    // tooltip test
    // box.setToolTip(d.value, {
    //     showTimeout: 0,
    //     eventsPropagation: true,
    //     dx: 10
    // });
    // //infowindow test
    // box.setInfoWindow({
    //     content: d.value,
    //     title: 'message',
    //     animationDuration: 0,
    //     autoOpenOn: false
    // });
    bars.push(bar);
});

threeLayer.addMesh(bars);
```

4. 页面显示

![img](https://img2020.cnblogs.com/blog/59231/202105/59231-20210507103403381-187730824.png)

 