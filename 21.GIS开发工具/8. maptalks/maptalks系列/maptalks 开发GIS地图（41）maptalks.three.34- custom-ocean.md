- [maptalks 开发GIS地图（41）maptalks.three.34- custom-ocean](https://www.cnblogs.com/googlegis/p/14738296.html)

1. 自定义海洋效果 ， 与前面的[ coolwater ](https://www.cnblogs.com/googlegis/p/14735454.html)效果差不多，coolwater 的效果好像是使用两个图片作为 ShaderMaterial，

2. 数据使用 ./data/westlake.geojson , 背景图片使用 ./data/waternormals.jpg

![img](https://img2020.cnblogs.com/blog/59231/202105/59231-20210507105527010-1376147696.png)

  

![img](https://img2020.cnblogs.com/blog/59231/202105/59231-20210507105543743-1926701059.png)

 

3. 定义Ocean扩展类

```js
class Ocean extends maptalks.BaseObject {
    constructor(polygon, options, layer) {
        options = maptalks.Util.extend({}, OPTIONS, options, { layer, polygon });
        if (!options.waterNormals) {
            throw new Error('waterNormals is null');
        }
        super();
        //Initialize internal configuration
        // https://github.com/maptalks/maptalks.three/blob/1e45f5238f500225ada1deb09b8bab18c1b52cf2/src/BaseObject.js#L135
        this._initOptions(options);

        const waterNormalsTexture = new THREE.TextureLoader().load(options.waterNormals);
        waterNormalsTexture.wrapS = waterNormalsTexture.wrapT = THREE.RepeatWrapping;
        options.waterNormals = waterNormalsTexture;

        const water = new THREE.Water(
            layer.getThreeRenderer(),
            layer.getCamera(),
            layer.getScene(),
            options
        );
        const geometry = getOceanGeometry(polygon, layer);
        this._createMesh(geometry, water.material);

        this.getObject3d().add(water);
        this.water = water;
        //set object3d position
        const { altitude } = options;
        const z = layer.distanceToVector3(altitude, altitude).x;
        const center = polygon.getCenter();
        const v = layer.coordinateToVector3(center, z);
        this.getObject3d().position.copy(v);
    }

    getSymbol() {
        return this.water.material;
    }

    setSymbol(material) {
        this.water.material = material;
        return this;
    }

    _animation() {
        const water = this.water;
        water.material.uniforms.time.value += 1.0 / 60.0;
        water.render();
    }
}
```

4. 添加数据

```js
var oceans;
function addOcean() {
    fetch('./data/westlake.geojson').then(function (res) {
        return res.text();
    }).then(function (geojson) {
        var polygons = maptalks.GeoJSON.toGeometry(geojson);
        oceans = polygons.map(p => {
            var ocean = new Ocean(p, {
                // altitude: 2,
                waterNormals: './data/waternormals.jpg'
            }, threeLayer)
            return ocean;
        });

        threeLayer.addMesh(oceans);

        initGui();
        threeLayer.config('animation', true);
        animation();
    })
}
```

5. 页面显示

![img](https://img2020.cnblogs.com/blog/59231/202105/59231-20210507105725966-549118014.gif)

 