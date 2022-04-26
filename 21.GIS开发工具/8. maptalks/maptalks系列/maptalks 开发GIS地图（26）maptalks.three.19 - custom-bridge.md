- [maptalks 开发GIS地图（26）maptalks.three.19 - custom-bridge](https://www.cnblogs.com/googlegis/p/14735209.html)

1. 自定义高架，每个高架路线为经纬度数组，

其中包括经度、纬度、高度。

![img](https://img2020.cnblogs.com/blog/59231/202105/59231-20210506144319419-1942715766.png)

2. 调用addLine函数添加对象。

```js
function addLine(lnglats, name, width = 8) {
    const lineString = new maptalks.LineString(lnglats);
    const altitudes = lnglats.map(lnglat => {
        return lnglat[2] / 10;
    });
    lineString.setProperties({ altitudes });
    const line = new Bridge(lineString, { width }, material, threeLayer);
    line.setToolTip(name, {
        showTimeout: 0,
        eventsPropagation: true,
        dx: 10
    });

    const { coordinates, height } = line.getOptions();
    const alts = coordinates.map(c => {
        return c[2];
    })
    const pLine = new maptalks.LineString(coordinates);
    pLine.setProperties({
        altitudes: alts
    });
    const edgeLine = new Line(pLine, { altitude: -0.05, offset: -0.05 }, edgeLineMaterial, threeLayer);
    const edgeLine1 = new Line(pLine, { altitude: height + 0.05, offset: height + 0.05 }, edgeLineMaterial, threeLayer);

    const centerLine = new Line(lineString, { altitude: 1.1, offset: 1.1 }, linematerial, threeLayer);

    threeLayer.addMesh([line, centerLine, edgeLine, edgeLine1]);
    meshes.push(line);

    helperMeshes.push(centerLine, edgeLine, edgeLine1);
}
```

3. 其中的红黑效果，最后发现是通过不同的材质组合构成的。

```js
var material = new THREE.MeshBasicMaterial({ color: 'rgb(12,12,17)', transparent: true, wireframe: false });
var highlightmaterial = new THREE.MeshBasicMaterial({ color: 'yellow', transparent: true });

const material1 = new THREE.MeshLambertMaterial({
    color: '#000'
});
const highlightmaterial1 = new THREE.MeshLambertMaterial({
    color: 'red'
});

var edgeLineMaterial = new THREE.LineBasicMaterial({
    color: '#fff',
    transparent: true,
    opacity: 0.6
});

var linematerial = new THREE.LineDashedMaterial({
    color: '#fff',
    dashSize: 0.05,
    gapSize: 0.05
});
```

4. 页面显示

![img](https://img2020.cnblogs.com/blog/59231/202105/59231-20210506145117183-1697818987.png)

