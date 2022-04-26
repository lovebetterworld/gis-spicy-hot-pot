- [maptalks 开发GIS地图（28）maptalks.three.21- custom-cloud](https://www.cnblogs.com/googlegis/p/14735262.html)

1. 白云效果，是真的白云效果。

2. 白云效果的材质

```js
function generateTextureCanvas() {
    // build a small canvas 32x64 and paint it in white
    var canvas = document.createElement("canvas");
    canvas.width = 32;
    canvas.height = 64;
    var context = canvas.getContext("2d");
    // plain it in white
    context.fillStyle = "#ffffff";
    context.fillRect(0, 0, 32, 64);
    // draw the window rows - with a small noise to simulate light variations in each room
    for (var y = 2; y < 64; y += 2) {
        for (var x = 0; x < 32; x += 2) {
            var value = Math.floor(Math.random() * 64);
            context.fillStyle = "rgb(" + [value, value, value].join(",") + ")";
            context.fillRect(x, y, 2, 1);
        }
    }

    // build a bigger canvas and copy the small one in it
    // This is a trick to upscale the texture without filtering
    var canvas2 = document.createElement("canvas");
    canvas2.width = 512;
    canvas2.height = 1024;
    var context = canvas2.getContext("2d");
    // disable smoothing
    context.imageSmoothingEnabled = false;
    context.webkitImageSmoothingEnabled = false;
    context.mozImageSmoothingEnabled = false;
    // then draw the image
    context.drawImage(canvas, 0, 0, canvas2.width, canvas2.height);
    // return the just built canvas2
    return canvas2;
}
```

3. 白云的类扩展对象

```js
class Cloud extends maptalks.BaseObject {
    constructor(coordinate, options, material, layer) {
        options = maptalks.Util.extend({}, OPTIONS, options, { layer, coordinate });
        super();
        //Initialize internal configuration
        // https://github.com/maptalks/maptalks.three/blob/1e45f5238f500225ada1deb09b8bab18c1b52cf2/src/BaseObject.js#L135
        this._initOptions(options);
        const { altitude, width, height } = options;
        //generate geometry
        const w = layer.distanceToVector3(width, width).x;
        const h = layer.distanceToVector3(width, width).x;
        const geometry = new THREE.PlaneBufferGeometry(w, h);

        //Initialize internal object3d
        // https://github.com/maptalks/maptalks.three/blob/1e45f5238f500225ada1deb09b8bab18c1b52cf2/src/BaseObject.js#L140
        // this._createMesh(geometry, material);
        this._createGroup();
        const mesh = new THREE.Mesh(geometry, material);
        this.getObject3d().add(mesh);

        //set object3d position
        const z = layer.distanceToVector3(altitude, altitude).x;
        const position = layer.coordinateToVector3(coordinate, z);
        this.getObject3d().position.copy(position);

        const random = Math.random();
        const flag = random <= 0.3 ? "x" : random < 0.6 ? "y" : "z";
        this.positionflag = flag;
        const offset = Math.min(w, h);
        this.offset = offset;
        this._offset = 0;
        this._offsetAdd = random > 0.5;
    }

    // test animation
    _animation() {
        const map = this.getMap();
        const bearing = map.getBearing(),
              pitch = map.getPitch();
        this.getObject3d().children[0].rotation.x = (pitch * Math.PI) / 180;
        this.getObject3d().rotation.z = (-bearing * Math.PI) / 180;

        const offset = 0.001 * 5;
        if (this._offsetAdd) {
            this._offset += offset;
            this.getObject3d().position[this.positionflag] += offset;
            if (this._offset >= this.offset) {
                this._offsetAdd = false;
            }
        } else {
            this._offset -= offset;
            this.getObject3d().position[this.positionflag] -= offset;
            if (this._offset <= -this.offset) {
                this._offsetAdd = true;
            }
        }
    }
}
```

4. 添加白云

```js
clouds = lnglats.map(function (lnglat) {
    const cloud = new Cloud(
        lnglat,
        {
            altitude: Math.random() * 1000 + 500
        },
        material,
        threeLayer
    );
    return cloud;
});
threeLayer.addMesh(clouds);
```

5. 页面显示

![img](https://img2020.cnblogs.com/blog/59231/202105/59231-20210506150645262-194689866.gif)

