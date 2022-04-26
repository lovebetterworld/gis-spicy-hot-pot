- [maptalks 开发GIS地图（18）maptalks.three.11 - buildings](https://www.cnblogs.com/googlegis/p/14734079.html)

1. 三维建筑应该是GIS中比较典型的应用了，不论是高德百度还是其他的开发库，支持三维地图显示是比较重要的一个环节。

2. 建筑数据使用的是 ./threelayer/demo/buildings.js 。 这样的数据使用的是json格式的，而不是geojson。

![img](https://img2020.cnblogs.com/blog/59231/202105/59231-20210506101656925-720470167.png)

3. 使用 toExtrudeMesh 函数对建筑数据进行实例。

　featrures.forEach 是对每条记录进行处理。在处理的过程中，使用getColor获取建筑颜色。

　代码调试可以查看到features的数据量为2105个记录。

```js
threeLayer.prepareToDraw = function (gl, scene, camera) {
    var me = this;
    var light = new THREE.DirectionalLight(0xffffff);
    light.position.set(0, -10, 10).normalize();
    scene.add(light);

    features.forEach(function (g) {
        var heightPerLevel = 10;
        var levels = g.properties.levels || 1;
        var color = getColor(levels);

        var m = new THREE.MeshPhongMaterial({color: color, opacity : 0.7});
        //change to back side with THREE <= v0.94
        // m.side = THREE.BackSide;

        var mesh = me.toExtrudeMesh(maptalks.GeoJSON.toGeometry(g), levels * heightPerLevel, m, levels * heightPerLevel);
        if (Array.isArray(mesh)) {
          scene.add.apply(scene, mesh);
        } else {
          scene.add(mesh);
        }
    });
};
threeLayer.addTo(map);
```

4. 页面显示

![img](https://img2020.cnblogs.com/blog/59231/202105/59231-20210506102328060-1772755304.png)

