- [maptalks 开发GIS地图（37）maptalks.three.30- custom-linetrail](https://www.cnblogs.com/googlegis/p/14737785.html)

1. 尾线效果，很适合做轨迹追踪或者路线动画。

2. 数据使用 ./data/lines.json 

![img](https://img2020.cnblogs.com/blog/59231/202105/59231-20210507092732465-641558682.png)

3. 处理数据

```js
var lineStrings = geojson.map(function (feature) {
    var coordinates = feature.coordinates;
    var [from, to] = coordinates;
    var lnglats = [[parseFloat(from[0]), parseFloat(from[1])], [parseFloat(to[0]), parseFloat(to[1])]]
    return new maptalks.LineString(lnglats);
});
```

4. 将数据处理为 linetrail 并添加到 图层。

```js
var offset = 2000;
lineTrails = list.slice(0, offset).map(d => {
    var line = new LineTrail(d.lineString, {
        chunkLength: d.len / 100,
        trail: 5,
        speed: 1,
        altitude: 100,
    }, material, threeLayer)
    return line;
});
var lines = list.slice(0, offset).map(d => {
    return threeLayer.toLine(d.lineString, {}, lineMaterial);
});
```

5. lineTrail 的自定义扩展类

```js
//default values
var OPTIONS = {
    trail: 5,
    chunkLength: 50,
    speed: 1,
    altitude: 0,
    interactive: false
};
const MAX_POINTS = 1000;

/**
         * custom component
         * */
class LineTrail extends maptalks.BaseObject {
    constructor(lineString, options, material, layer) {
        options = maptalks.Util.extend({}, OPTIONS, options, { layer, lineString });
        super();
        //Initialize internal configuration
        // https://github.com/maptalks/maptalks.three/blob/1e45f5238f500225ada1deb09b8bab18c1b52cf2/src/BaseObject.js#L135
        this._initOptions(options);

        const { altitude, chunkLength, speed, trail } = options;
        const chunkLines = lineSlice(lineString, chunkLength);

        const centerPt = layer.coordinateToVector3(lineString.getCenter());
        //cache position for  faster computing,reduce double counting
        const positionMap = {};
        for (let i = 0, len = chunkLines.length; i < len; i++) {
            const chunkLine = chunkLines[i];
            for (let j = 0, len1 = chunkLine.length; j < len1; j++) {
                const lnglat = chunkLine[j];
                const key = lnglat.join(',').toString();
                if (!positionMap[key]) {
                    positionMap[key] = layer.coordinateToVector3(lnglat).sub(centerPt);
                }
            }
        }

        const positions = getChunkLinesPosition([chunkLines[0]], layer, positionMap, centerPt).positions;
        const geometry = new THREE.BufferGeometry();
        const ps = new Float32Array(MAX_POINTS * 3); // 3 vertices per point
        geometry.addAttribute('position', new THREE.BufferAttribute(ps, 3).setDynamic(true));
        setLineGeometryAttribute(geometry, positions);
        this._createLine(geometry, material);

        //set object3d position
        const z = layer.distanceToVector3(altitude, altitude).x;

        const center = lineString.getCenter();
        const v = layer.coordinateToVector3(center, z);
        this.getObject3d().position.copy(v);

        this._params = {
            trail: Math.max(1, trail),
            index: 0,
            len: chunkLines.length,
            chunkLines,
            layer,
            speed: Math.min(1, speed),
            idx: 0,
            positions: [],
            positionMap,
            centerPt
        };
        // this._init();
    }

    _init() {
        const { len, chunkLines, layer, trail, positionMap, centerPt } = this._params;
        for (let i = 0; i < len; i++) {
            const result = chunkLines.slice(i, i + trail);
            const ps = getChunkLinesPosition(result, layer, positionMap, centerPt).positions;
            this._params.positions[i] = ps;
        }
    }

    _animation() {
        const { index, positions, idx, speed, len, chunkLines, layer, trail, positionMap, centerPt } = this._params;
        const i = Math.round(index);
        if (i > idx) {
            this._params.idx++;
            let ps = positions[i];
            if (!ps) {
                const result = chunkLines.slice(i, i + trail);
                ps = getChunkLinesPosition(result, layer, positionMap, centerPt).positions;
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

6. 页面效果

![img](https://img2020.cnblogs.com/blog/59231/202105/59231-20210507093329188-1053052183.gif)

