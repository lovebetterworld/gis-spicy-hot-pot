- [maptalks 开发GIS地图（15）maptalks.three.08 - box](https://www.cnblogs.com/googlegis/p/14733737.html)

1. box 从代码上来说，和 bar 的代码类似，只不过是[ threelayer.toBar ](https://www.cnblogs.com/googlegis/p/14721889.html)改为了

 threelayer.toBox 。在样式的区别来看，也是 Bar 的六边形变成了 Box 的

　四边形。

2. 代码参考

Box：

```js
var bar = threeLayer.toBox(d.coordinate, {
    height: d.height * 200,
    radius: 15000,
    topColor: '#fff',
    // radialSegments: 4
}, material);
```

Bar:

```js
var bar = threeLayer.toBar(d.coordinate, {
    height: d.height * 400,
    radius: 15000,
    topColor: '#fff',
    // radialSegments: 4
}, material);
```

3. 页面效果

Bar:

![img](https://img2020.cnblogs.com/blog/59231/202105/59231-20210506084643507-1200635021.png)

  Box:

![img](https://img2020.cnblogs.com/blog/59231/202105/59231-20210506084726295-1929978614.png)

4. 源码参考

https://github.com/WhatGIS/maptalkMap/tree/main/threelayer/demo

