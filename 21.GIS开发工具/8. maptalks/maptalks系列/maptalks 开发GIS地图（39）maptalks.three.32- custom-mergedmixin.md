- [maptalks 开发GIS地图（39）maptalks.three.32- custom-mergedmixin](https://www.cnblogs.com/googlegis/p/14737889.html)

1. 这个不觉明历。在我看来，这和 [boxs ](https://www.cnblogs.com/googlegis/p/14733884.html)那个例子差不多。

2. 只不过扩展类 TestBoxs 继承了 maptalks.MergedMixin ，这个估计要看源码才能明白是啥了。

```js
class TestBoxs extends maptalks.MergedMixin(maptalks.BaseObject) {
    constructor(points, options, material, layer) {
        if (!Array.isArray(points)) {
            points = [points];
        }
        const len = points.length;
        const center = getCenterOfPoints(points);
        const centerPt = layer.coordinateToVector3(center);
        const geometries = [], bars = [], geometriesAttributes = [], faceMap = [];
        let faceIndex = 0, psIndex = 0, normalIndex = 0, uvIndex = 0;
        for (let i = 0; i < len; i++) {
            const opts = maptalks.Util.extend({ index: i }, OPTIONS1, points[i]);
            const { radius, altitude, topColor, bottomColor, height, coordinate } = opts;
            const r = layer.distanceToVector3(radius, radius).x;
            const h = layer.distanceToVector3(height, height).x;
            const alt = layer.distanceToVector3(altitude, altitude).x;
            const buffGeom = defaultGeometry.clone();
            buffGeom.scale(r * 2, r * 2, h);
            const v = layer.coordinateToVector3(coordinate).sub(centerPt);
            const parray = buffGeom.attributes.position.array;
            for (let j = 0, len1 = parray.length; j < len1; j += 3) {
                parray[j + 2] += alt;
                parray[j] += v.x;
                parray[j + 1] += v.y;
                parray[j + 2] += v.z;
            }
            const position = buffGeom.attributes.position;
            const normal = buffGeom.attributes.normal;
            const uv = buffGeom.attributes.uv;
            const index = buffGeom.index;
            geometries.push({
                position: position.array,
                normal: normal.array,
                uv: uv.array,
                indices: index.array
            });
            const bar = new TestBox(coordinate, opts, material, layer);
            bars.push(bar);

            const faceLen = buffGeom.index.count / 3;
            faceMap[i] = [faceIndex + 1, faceIndex + faceLen];
            faceIndex += faceLen;

            const psCount = buffGeom.attributes.position.count,
                  //  colorCount = buffGeom.attributes.color.count,
                  normalCount = buffGeom.attributes.normal.count, uvCount = buffGeom.attributes.uv.count;
            geometriesAttributes[i] = {
                position: {
                    count: psCount,
                    start: psIndex,
                    end: psIndex + psCount * 3,
                },
                normal: {
                    count: normalCount,
                    start: normalIndex,
                    end: normalIndex + normalCount * 3,
                },
                // color: {
                //     count: colorCount,
                //     start: colorIndex,
                //     end: colorIndex + colorCount * 3,
                // },
                uv: {
                    count: uvCount,
                    start: uvIndex,
                    end: uvIndex + uvCount * 2,
                },
                hide: false
            };
            psIndex += psCount * 3;
            normalIndex += normalCount * 3;
            // colorIndex += colorCount * 3;
            uvIndex += uvCount * 2;
        }
        super();
        options = maptalks.Util.extend({}, { altitude: 0, layer, points }, options);
        this._initOptions(options);
        const geometry = maptalks.MergeGeometryUtil.mergeBufferGeometries(geometries);
        this._createMesh(geometry, material);
        const altitude = options.altitude;
        const z = layer.distanceToVector3(altitude, altitude).x;
        const v = centerPt.clone();
        v.z = z;
        this.getObject3d().position.copy(v);

        this._faceMap = faceMap;
        this._baseObjects = bars;
        this._datas = points;
        this._geometriesAttributes = geometriesAttributes;
        this.faceIndex = null;
        this._geometryCache = geometry.clone();
        this.isHide = false;
        this._colorMap = {};
        this._initBaseObjectsEvent(bars);
        this._setPickObject3d();
        this._init();
    }

    // eslint-disable-next-line no-unused-vars
    identify(coordinate) {
        return this.picked;
    }
}
```

3. 页面显示

![img](https://img2020.cnblogs.com/blog/59231/202105/59231-20210507095523435-925409140.png)