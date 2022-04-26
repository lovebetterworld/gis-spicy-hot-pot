- [maptalks 开发GIS地图（35）maptalks.three.28- custom-grid-height](https://www.cnblogs.com/googlegis/p/14737706.html)

1. 带高度的栅格，在栅格的基础上加上高度。

2. 其中是用d3.min.js 和 turf.js 

D3 是一个数据可视化的JS库，能够实现各种图表。

turf.js 是主要用来进行空间分析，空间几何对象关系的计算，点、线、面之间包含、相交等计算的JS库。

3. 数据使用的是网络数据

```
https://gw.alipayobjects.com/os/basement_prod/513add53-dcb2-4295-8860-9e7aa5236699.json
```

从格式可以看出是类似于geoJson 的数据。

4. 使用 grid.count / 5 作为grid.height.

```js
const filterGrids = [];
for (let i = 0, len = grids.length; i < len; i++) {
    if (grids[i].count > 0) {
        const grid = grids[i];
        max = Math.max(max, grid.count);
        grid.height = grid.count / 5;
        const color = getColor(grid.count);
        grid.color = color;
        filterGrids.push(grids[i]);
    }
}
```

5. 最后将 filterGrids 数组作为一个整体进行渲染并添加到图层中。

```js
const boxs = new Boxs(filterGrids, { center: center }, material, threeLayer);
threeLayer.addMesh(boxs);
```

6. 页面显示

![img](https://img2020.cnblogs.com/blog/59231/202105/59231-20210507090655841-1518645970.png)

