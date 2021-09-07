- [maptalks 开发GIS地图（17）maptalks.three.10 - boxes](https://www.cnblogs.com/googlegis/p/14733884.html)

1. Boxes  我特意查了一下，Box 的复数是 Boxes，不是Box，threelayer的官方demo里写的是boxs，对象名称

写的也是 threeLayer.toBoxs , 所以，我只在这篇文章里修改了这个复数形式，代码里面没有修改。

2. Boxs 从形式上看是 Box 的复数，指的是有很多Box，从数据上看，也是比 Box 好了很多。Boxs 使用的

数据量为 30508个，Box 示例的数据量是 2413 个。 使用了 threeLayer.toBoxs 对象进行数据加载。

3. 参考代码：

```js
fetch('https://gw.alipayobjects.com/os/basement_prod/513add53-dcb2-4295-8860-9e7aa5236699.json').then((function (res) {
    return res.json();
})).then(function (json) {
    const data = json.features.slice(0, Infinity).map(function (dataItem) {
        dataItem = gcoord.transform(dataItem, gcoord.AMap, gcoord.WGS84);
        return {
            coordinate: dataItem.geometry.coordinates,
            height: Math.random() * 200,
            value: Math.random() * 10000,
            topColor: '#fff'
        }
    });
    const time = 'time';
    console.time(time);
    const box = threeLayer.toBoxs(data, {}, material);
    bars.push(box);
    console.timeEnd(time);

    // tooltip test
    box.setToolTip('hello', {
        showTimeout: 0,
        eventsPropagation: true,
        dx: 10
    });
    threeLayer.addMesh(bars);
}
```

4. 页面显示

![img](https://img2020.cnblogs.com/blog/59231/202105/59231-20210506093408436-1935776484.png)

5. 源码地址：

https://github.com/WhatGIS/maptalkMap/tree/main/threelayer/demo

