- [maptalks 开发GIS地图（29）maptalks.three.22- custom-coolwater](https://www.cnblogs.com/googlegis/p/14735454.html)

1. coolwater， 确实是很酷的water，其效果也相当不错。对于水域来说，比单独画一个蓝色的多边形好很多。

2. 首先定义一个CoolWater的扩展对象，然后使用THREE.TextureLoader 进行加载data/CoolWater-iChannel0.png 和 data/CoolWater-iChannel1.jpg。

```js
let textureLoader = new THREE.TextureLoader();
let iChannel0 = textureLoader.load('data/CoolWater-iChannel0.png');
iChannel0.wrapS = iChannel0.wrapT = THREE.RepeatWrapping;
let iChannel1 = textureLoader.load('data/CoolWater-iChannel1.jpg');
iChannel1.wrapS = iChannel1.wrapT = THREE.RepeatWrapping;
```

3. 使用 THREE.ShaderMaterial 将textureloader 加载为材质 Material

```js
let material = this.material = new THREE.ShaderMaterial({
    fragmentShader,
    uniforms: {
        iTime: {
            type: 'f',
            value: 0
        },
        iResolution: {
            type: 'v3',
            value: new THREE.Vector3(1, 1, 1)
        },
        iChannel0: {
            type: 't',
            value: iChannel0
        },
        iChannel1: {
            type: 't',
            value: iChannel1
        }
    }
});
```

4. 然后根据形状加载对应的材质

```js
let size = layer.getMap().getSize();
material.uniforms.iResolution.value.set(size.width, size.height, 1);
const geometry = getWaterGeometry(polygon, layer);
this._createMesh(geometry, material);
```

5. 水域的多边形数据使用的是 ./data/westlake.geojson

![img](https://img2020.cnblogs.com/blog/59231/202105/59231-20210506154203600-34013196.png)

6. 添加水域

```js
var waters;
function addWater() {
    fetch('./data/westlake.geojson').then(function (res) {
        return res.text();
    }).then(function (geojson) {
        var polygons = maptalks.GeoJSON.toGeometry(geojson);
        waters = polygons.map(p => new CoolWater(p, {}, threeLayer));

        threeLayer.addMesh(waters);

        initGui();
        threeLayer.config('animation', true);
        animation();
    })
}
```

7. 页面显示

![img](https://img2020.cnblogs.com/blog/59231/202105/59231-20210506154328159-1943970167.gif)

