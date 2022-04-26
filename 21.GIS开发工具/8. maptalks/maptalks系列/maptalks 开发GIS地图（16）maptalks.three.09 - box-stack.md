- [maptalks 开发GIS地图（16）maptalks.three.09 - box-stack](https://www.cnblogs.com/googlegis/p/14733833.html)

1. Box-stack 则是使用了不同颜色的材质在同一个地点进行叠加，显示出了颜色渐变的效果。

这个效果的用途可以用在多种类型的数据对比。

2. 参考代码

从代码中可以看出，在每一个经纬度上，对14个颜色循环添加，相当于在同一个经纬度上叠加了14个颜色块。这里每个颜色块的高度都是100，如果使用高度来表示某个

指标数据的话，这个效果所表达的内容就比较丰富了。

```js
function addBars() {
    const lnglats = randomLnglats();
    lnglats.forEach(lnglat => {
        for (let i = 0; i < colors.length; i++) {
            const bar = threeLayer.toBox(lnglat, { height: 100, altitude: i * 100, radius: 50, interactive: false }, getMaterial(colors[i]));
            bars.push(bar);
        }
    });
    threeLayer.addMesh(bars);
    animation();
}
```

3. 页面效果：

![img](https://img2020.cnblogs.com/blog/59231/202105/59231-20210506091238064-1598001162.png)

4. 源码地址：

https://github.com/WhatGIS/maptalkMap/tree/main/threelayer/demo

