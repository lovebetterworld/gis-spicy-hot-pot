- [maptalks 开发GIS地图（21）maptalks.three.14 - buildings-vertexcolor](https://www.cnblogs.com/googlegis/p/14734400.html)

1. Vertex 查了一下意思是 顶点的意思，但是我一直没有理解到底是啥原因，代码使用的是 threeLayer.toExtrudePolygon，而不是 toExtrudeMesh ， 也许

是因为是多边形，所以才会有顶点之说。

2. 代码参考

```js
features.forEach(function (g) {
    var heightPerLevel = 10;
    var levels = g.properties.levels || 1;
    var mesh = threeLayer.toExtrudePolygon(maptalks.GeoJSON.toGeometry(g), {
        height: levels * heightPerLevel,
        topColor: '#fff'
    }, material);

    //tooltip test
    mesh.setToolTip(levels * heightPerLevel, {
        showTimeout: 0,
        eventsPropagation: true,
        dx: 10
    });

    //infowindow test
    mesh.setInfoWindow({
        content: 'hello world,height:' + levels * heightPerLevel,
        title: 'message',
        animationDuration: 0,
        autoOpenOn: false
    });
}
```

3. 页面显示

![img](https://img2020.cnblogs.com/blog/59231/202105/59231-20210506112119298-387946940.png)

