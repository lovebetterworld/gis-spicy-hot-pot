- [maptalks 开发GIS地图（19）maptalks.three.12 - buildings-outline](https://www.cnblogs.com/googlegis/p/14734218.html)

1. 建筑物轮廓为建筑的边缘线，内部不进行填充颜色，只有边缘线进行勾勒，效果也不错。

2. 将建筑物填充为黑色方块，获取建筑物的边线

```js
//default values
var OPTIONS = {
    altitude: 0
};

//https://zhuanlan.zhihu.com/p/199353080
class OutLine extends maptalks.BaseObject {
    constructor(mesh, options, material, layer) {
        options = maptalks.Util.extend({}, OPTIONS, options, { layer });
        super();
        //Initialize internal configuration
        // https://github.com/maptalks/maptalks.three/blob/1e45f5238f500225ada1deb09b8bab18c1b52cf2/src/BaseObject.js#L135
        this._initOptions(options);

        const edges = new THREE.EdgesGeometry(mesh.getObject3d().geometry, 1);
        const lineS = new THREE.LineSegments(edges, material);
        this._createGroup();
        this.getObject3d().add(lineS);
        //Initialize internal object3d
        // https://github.com/maptalks/maptalks.three/blob/1e45f5238f500225ada1deb09b8bab18c1b52cf2/src/BaseObject.js#L140

        //set object3d position
        this.getObject3d().position.copy(mesh.getObject3d().position);
    }
}
```

3. 页面显示

![img](https://img2020.cnblogs.com/blog/59231/202105/59231-20210506105112853-353938415.png)