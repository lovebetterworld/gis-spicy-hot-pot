- [maptalks 开发GIS地图（24）maptalks.three.17 - custom-arcline-animation](https://www.cnblogs.com/googlegis/p/14734960.html)

1. 在飞线的基础上加入移动轨迹，很像飞机飞过的轨迹。这个效果在百度地图里也有。

2. 在 ArcLine 对象中，加入了 speed 参数，在 ArcLine 的类中加入 _animation 动画代码。

3. 添加 Line。

```js
function loadRoad(geojsonURL, textureURL) {
            fetch(geojsonURL).then(function (res) {
                return res.text();
            }).then(function (text) {
                return JSON.parse(text);
            }).then(function (geojson) {
                const texture = new THREE.TextureLoader().load(textureURL);
                texture.anisotropy = 16;
                texture.wrapS = THREE.RepeatWrapping;
                texture.wrapT = THREE.RepeatWrapping;
                const camera = threeLayer.getCamera();
                const material = new MeshLineMaterial({
                    map: texture,
                    useMap: true,
                    lineWidth: 13,
                    sizeAttenuation: false,
                    transparent: true,
                    near: camera.near,
                    far: camera.far
                });
                const multiLineStrings = maptalks.GeoJSON.toGeometry(geojson);
                for (const multiLineString of multiLineStrings) {
                    const lines = multiLineString._geometries.filter(lineString => {
                        const len = lineLength(lineString);
                        return len > 800;
                    }).map(lineString => {
                        const len = lineLength(lineString)
                        const line = new ArcLine(lineString, { altitude: 0, height: len / 3, speed: len / 100000 }, material, threeLayer);
                        line.setToolTip(len);
                        return line;
                    });
                    threeLayer.addMesh(lines);
                    meshes = meshes.concat(lines);
                }
            });
        }
```

4. ArcLine 扩展类

```js
var OPTIONS = {
    altitude: 0,
    speed: 0.01,
    height: 100
};

class ArcLine extends maptalks.BaseObject {
    constructor(lineString, options, material, layer) {
        super();
        options.offset = material.uniforms.offset.value;
        options.clock = new THREE.Clock();
        //geoutil.js getLinePosition
        options = maptalks.Util.extend({}, OPTIONS, options, { layer, lineString });
        this._initOptions(options);

        const { altitude, height } = options;
        const points = getArcPoints(lineString, layer.distanceToVector3(height, height).x, layer);
        const geometry = new THREE.Geometry();
        geometry.vertices = points;
        const meshLine = new MeshLine();
        meshLine.setGeometry(geometry);

        const map = layer.getMap();
        const size = map.getSize();

        material.uniforms.resolution.value.set(size.width, size.height);

        this._createMesh(meshLine.geometry, material);

        const z = layer.distanceToVector3(altitude, altitude).x;
        const center = lineString.getCenter();
        const v = layer.coordinateToVector3(center, z);
        this.getObject3d().position.copy(v);
        this._setPickObject3d();
        this._init();
    }

    _animation() {
        this.options.offset.x -= this.options.speed * this.options.clock.getDelta();
    }

    _init() {
        const pick = this.getLayer().getPick();
        this.on('add', () => {
            pick.add(this.pickObject3d);
        });
        this.on('remove', () => {
            pick.remove(this.pickObject3d);
        });
    }


    _setPickObject3d(ps, linewidth) {
        const geometry = this.getObject3d().geometry.clone();
        const pick = this.getLayer().getPick();
        const color = pick.getColor();
        const {
            lineWidth,
            sizeAttenuation,
            transparent,
            near,
            far
        } = this.getObject3d().material;
        const material = new MeshLineMaterial({
            lineWidth,
            sizeAttenuation,
            transparent,
            near,
            far,
            color
        });
        const map = this.getMap();
        const size = map.getSize();

        material.uniforms.resolution.value.set(size.width, size.height);
        const mesh = new THREE.Mesh(geometry, material);
        mesh.position.copy(this.getObject3d().position);

        const colorIndex = color.getHex();
        mesh._colorIndex = colorIndex;
        this.setPickObject3d(mesh);
    }

    identify(coordinate) {
        return this.picked;
    }
}

function getArcPoints(lineString, height, layer) {
    const lnglats = [];
    if (Array.isArray(lineString)) {
        lnglats.push(lineString[0], lineString[lineString.length - 1]);
    } else if (lineString instanceof maptalks.LineString) {
        const coordinates = lineString.getCoordinates();
        lnglats.push(coordinates[0], coordinates[coordinates.length - 1]);
    }
    const [first, last] = lnglats;
    let center;
    if (Array.isArray(first)) {
        center = [first[0] / 2 + last[0] / 2, first[1] / 2 + last[1] / 2];
    } else if (first instanceof maptalks.Coordinate) {
        center = [first.x / 2 + last.x / 2, first.y / 2 + last.y / 2];
    }
    const centerPt = layer.coordinateToVector3(lineString.getCenter());
    const v = layer.coordinateToVector3(first).sub(centerPt);
    const v1 = layer.coordinateToVector3(last).sub(centerPt);
    const vh = layer.coordinateToVector3(center, height).sub(centerPt);
    const ellipse = new THREE.CatmullRomCurve3([v, vh, v1], false, 'catmullrom');
    const points = ellipse.getPoints(40);
    return points;
}
```

5. 页面显示

![img](https://img2020.cnblogs.com/blog/59231/202105/59231-20210506141431175-1048752249.gif)

