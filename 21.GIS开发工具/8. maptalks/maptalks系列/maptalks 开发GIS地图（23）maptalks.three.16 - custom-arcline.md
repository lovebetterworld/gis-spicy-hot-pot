- [maptalks 开发GIS地图（23）maptalks.three.16 - custom-arcline](https://www.cnblogs.com/googlegis/p/14734882.html)

1. arcline 应该就是飞线，和百度以及其他的地图类似，从一个点飞出一条线到另外一个点。

2. 数据使用的是 ./data/lines.json , 可以看到里面包含了很多经纬度点。

![img](https://img2020.cnblogs.com/blog/59231/202105/59231-20210506135502555-419190593.png)

3. 将里面的对象转为 lineStrings。

```js
var lineStrings = geojson.map(function (feature) {
    var coordinates = feature.coordinates;
    var [from, to] = coordinates;
    var lnglats = [[parseFloat(from[0]), parseFloat(from[1])], [parseFloat(to[0]), parseFloat(to[1])]]
    return new maptalks.LineString(lnglats);
});
```

4. 然后对lineStrings进行处理，使用了 ArcLine 对象，并渲染材质。

```js
var list = [];
lineStrings.forEach(lineString => {
    list.push({
        lineString,
        len: lineLength(lineString)
    });
});
list = list.sort(function (a, b) {
    return b.len - a.len
});

var offset = Infinity;
lines = list.slice(0, offset).map(d => {
    var line = new ArcLine(d.lineString, {
        altitude: 0,
        height: d.len / 3
    }, material, threeLayer)
    return line;
});

console.log('lines.length:', lines.length);
threeLayer.addMesh(lines);
```

5. 页面显示

![img](https://img2020.cnblogs.com/blog/59231/202105/59231-20210506135945477-300350777.png)

