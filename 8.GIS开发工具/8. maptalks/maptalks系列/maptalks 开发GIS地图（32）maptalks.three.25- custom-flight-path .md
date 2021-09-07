- [maptalks 开发GIS地图（32）maptalks.three.25- custom-flight-path ](https://www.cnblogs.com/googlegis/p/14735916.html)

1. 使用飞线，加上飞机的移动，第一眼看过去和前面的 arcline-animation 很类似。

但是内部的代码内容完全不一样。

 2. 使用了 Bloom 效果，看起来很不错。

3. 材质

```js
var lines = [], lineTrails = [];
var material = new THREE.LineBasicMaterial({
    linewidth: 1,
    color: 'rgb(5,203,87)',
    opacity: 0.12,
    // blending: THREE.AdditiveBlending,
    transparent: true
});
var highlightmaterial = new THREE.LineBasicMaterial({
    linewidth: 1,
    color: '#fff',
    opacity: 1,
    blending: THREE.AdditiveBlending,
    transparent: true,
});
```

4. LineTrails

```js
class LineTrail extends maptalks.BaseObject {
    constructor(lineString, options, material, layer) {
        options = maptalks.Util.extend({}, OPTIONS, options, { layer, lineString });
        super();
        //Initialize internal configuration
        // https://github.com/maptalks/maptalks.three/blob/1e45f5238f500225ada1deb09b8bab18c1b52cf2/src/BaseObject.js#L135
        this._initOptions(options);

        const { altitude, chunkLength, speed, trail } = options;
        const chunkLines = lineSlice(lineString, chunkLength);

        const positions = _getChunkLinesPosition([chunkLines[0]], layer).positions;
        const geometry = new THREE.BufferGeometry();
        const ps = new Float32Array(MAX_POINTS * 3); // 3 vertices per point
        geometry.addAttribute('position', new THREE.BufferAttribute(ps, 3).setDynamic(true));
        setLineGeometryAttribute(geometry, positions);
        this._createLine(geometry, material);

        //set object3d position
        const z = layer.distanceToVector3(altitude, altitude).x;
        this.getObject3d().position.z = z;

        this._params = {
            trail: Math.max(1, trail),
            index: 0,
            len: chunkLines.length,
            chunkLines,
            layer,
            speed: Math.min(1, speed),
            idx: 0,
            positions: []
        };
        // this._init();
    }


    _init() {
        const { len, chunkLines, layer, trail } = this._params;
        for (let i = 0; i < len; i++) {
            const result = chunkLines.slice(i, i + trail);
            const ps = _getChunkLinesPosition(result, layer).positions;
            this._params.positions[i] = ps;
        }
    }


    _animation() {
        const { index, positions, idx, speed, len, chunkLines, layer, trail } = this._params;
        const i = Math.round(index);
        if (i > idx) {
            this._params.idx++;
            let ps = positions[i];
            if (!ps) {
                const result = chunkLines.slice(i, i + trail);
                ps = _getChunkLinesPosition(result, layer).positions;
                this._params.positions[i] = ps;
            }
            setLineGeometryAttribute(this.getObject3d().geometry, ps);
            this.getObject3d().geometry.attributes.position.needsUpdate = true;
        }
        if (index >= len) {
            this._params.index = -1;
            this._params.idx = -1;
        }
        this._params.index += speed;
    }
}
```

5. TextSprite

```js
class TextSprite extends maptalks.BaseObject {
    constructor(coordinate, options, layer) {
        options = maptalks.Util.extend({}, OPTIONS2, options, { layer, coordinate });
        super();
        //Initialize internal configuration
        // https://github.com/maptalks/maptalks.three/blob/1e45f5238f500225ada1deb09b8bab18c1b52cf2/src/BaseObject.js#L135
        this._initOptions(options);
        const { altitude, fontSize, color, text } = options;

        //Initialize internal object3d
        // https://github.com/maptalks/maptalks.three/blob/1e45f5238f500225ada1deb09b8bab18c1b52cf2/src/BaseObject.js#L140
        this._createGroup();
        const textsprite = new THREE_Text2D.SpriteText2D(text, { align: THREE_Text2D.textAlign.center, font: `${fontSize * 2}px Arial`, fillStyle: color, antialias: false });
        this.getObject3d().add(textsprite);

        //set object3d position
        const z = layer.distanceToVector3(altitude, altitude).x;
        const position = layer.coordinateToVector3(coordinate, z);
        this.getObject3d().position.copy(position);
    }

    _animation() {
        const scale = this.getMap().getScale() / 2000 / 15 * this.getOptions().fontSize;
        this.getObject3d().children[0].scale.set(scale, scale, scale);
    }

}
```

6. 线路

```js
function addLines() {
    fetch('./data/flight-path.txt').then(function (res) {
        return res.text();
    }).then(function (geojson) {
        geojson = LZString.decompressFromBase64(geojson);
        geojson = JSON.parse(geojson);
        geojson.forEach(lnglats => {
            const ps = lnglats.map(l => {
                const [lng, lat, height] = l;
                const z = threeLayer.distanceToVector3(height, height).x;
                return threeLayer.coordinateToVector3([lng, lat], z);
            });
            const line = new Line(ps, {}, material, threeLayer);
            line.getObject3d().layers.enable(1);
            lines.push(line);
            // console.log(lineSlice(lnglats, 20000));
            const lineTrail = new LineTrail(lnglats, { chunkLength: 5000, altitude: 200, trail: 1 }, highlightmaterial, threeLayer);
            lineTrail.getObject3d().layers.enable(1);
            lineTrails.push(lineTrail);

            const lineTrail1 = new LineTrail(lnglats.reverse(), { chunkLength: 5000, altitude: 200, trail: 1 }, highlightmaterial, threeLayer);
            lineTrail1.getObject3d().layers.enable(1);
            lineTrails.push(lineTrail1);
        });
        threeLayer.addMesh(lines);
        threeLayer.addMesh(lineTrails);
        initGui();
        animation();
        addNames();
    })
}
```

7. 页面显示

![img](https://img2020.cnblogs.com/blog/59231/202105/59231-20210506165354681-706857808.gif)

