- [maptalks 开发GIS地图（42）maptalks.three.35- custom-rgbimage-terrain](https://www.cnblogs.com/googlegis/p/14738386.html)

1. 可以说，这是我一直想要的效果之一，另外一个cesium 和 UE 一起搞得那个。

2. 数据使用的是 ./data/west-lake-area.geojson 

![img](https://img2020.cnblogs.com/blog/59231/202105/59231-20210507111022512-952567368.png)

3. 扩展类

```js
class Terrain extends maptalks.BaseObject {
            constructor(extent, options, material, layer) {
                options = maptalks.Util.extend({}, OPTIONS, options, { layer, extent });
                const { texture, image, altitude, imageHeight, imageWidth, factor, filterIndex } = options;
                if (!image) {
                    console.error('not find image');
                }
                if (!(extent instanceof maptalks.Extent)) {
                    extent = new maptalks.Extent(extent);
                }
                const { xmin, ymin, xmax, ymax } = extent;
                const coords = [
                    [xmin, ymin],
                    [xmin, ymax],
                    [xmax, ymax],
                    [xmax, ymin]
                ];
                let vxmin = Infinity, vymin = Infinity, vxmax = -Infinity, vymax = -Infinity;
                coords.forEach(coord => {
                    const v = layer.coordinateToVector3(coord);
                    const { x, y } = v;
                    vxmin = Math.min(x, vxmin);
                    vymin = Math.min(y, vymin);
                    vxmax = Math.max(x, vxmax);
                    vymax = Math.max(y, vymax);
                });
                const w = Math.abs(vxmax - vxmin), h = Math.abs(vymax - vymin);
                const rgbImg = generateImage(image), img = generateImage(texture);
                const geometry = new THREE.PlaneBufferGeometry(w, h, imageWidth - 1, imageHeight - 1);
                super();
                this._initOptions(options);
                this._createMesh(geometry, material);
                const z = layer.distanceToVector3(altitude, altitude).x;
                const v = layer.coordinateToVector3(extent.getCenter(), z);
                this.getObject3d().position.copy(v);
                material.transparent = true;
                if (rgbImg) {
                    material.opacity = 0;
                    rgbImg.onload = () => {
                        const width = imageWidth, height = imageHeight;
                        const imgdata = getRGBData(rgbImg, width, height);
                        let idx = 0;
                        let maxZ = -Infinity;
                        //rgb to height  https://docs.mapbox.com/help/troubleshooting/access-elevation-data/
                        for (let i = 0, len = imgdata.length; i < len; i += 4) {
                            const R = imgdata[i], G = imgdata[i + 1], B = imgdata[i + 2];
                            const height = -10000 + ((R * 256 * 256 + G * 256 + B) * 0.1);
                            const z = layer.distanceToVector3(height, height).x * factor;
                            geometry.attributes.position.array[idx * 3 + 2] = z;
                            maxZ = Math.max(z, maxZ);
                            idx++;
                        }
                        this.getOptions().maxZ = maxZ;
                        geometry.attributes.position.needsUpdate = true;
                        if (filterIndex) {
                            const _filterIndex = [];
                            const index = geometry.getIndex().array;
                            const position = geometry.attributes.position.array;
                            const z = maxZ / 15;
                            for (let i = 0, len = index.length; i < len; i += 3) {
                                const a = index[i];
                                const b = index[i + 1];
                                const c = index[i + 2];
                                const z1 = position[a * 3 + 2];
                                const z2 = position[b * 3 + 2];
                                const z3 = position[c * 3 + 2];
                                if (z1 > z || z2 > z || z3 > z) {
                                    _filterIndex.push(a, b, c);
                                }
                            }
                            geometry.setIndex(new THREE.Uint32BufferAttribute(_filterIndex, 1));
                        }
                        if (img) {
                            textureLoader.load(img.src, (texture) => {
                                material.map = texture;
                                material.opacity = 1;
                                material.needsUpdate = true;
                                this.fire('load');
                            });
                        } else {
                            material.opacity = 1;
                        }
                    };
                    rgbImg.onerror = function () {
                        console.error(`not load ${rgbImg.src}`);
                    };
                }
            }
        }
```

4. 获取数据，并进行数据处理。 

```js
fetch('./data/west-lake-area.geojson').then(res => res.json()).then(geojson => {
    const polygons = maptalks.GeoJSON.toGeometry(geojson);
    const polygon = polygons[0];
    let extent = polygon.getExtent();

    const { xmin, ymin, xmax, ymax } = extent;
    let coords = [
        [xmin, ymin],
        [xmin, ymax],
        [xmax, ymax],
        [xmax, ymin]
    ];
    let rectangle = new maptalks.Polygon([coords]);
    const tiles = cover.tiles(rectangle.toGeoJSON().geometry, {
        min_zoom: 12,
        max_zoom: 12
    });
    console.log(tiles);
    //buffer
    let minx = Infinity, miny = Infinity, maxx = -Infinity, maxy = -Infinity;
    tiles.forEach(tile => {
        const [x, y, z] = tile;
        const { xmin, ymin, xmax, ymax } = baseLayer._getTileLngLatExtent(x, y, z);
        minx = Math.min(minx, xmin);
        maxx = Math.max(maxx, xmax);
        miny = Math.min(miny, ymin);
        maxy = Math.max(maxy, ymax);
    });
    extent = new maptalks.Extent(minx, miny, maxx, maxy);
    coords = [
        [minx, miny],
        [minx, maxy],
        [maxx, maxy],
        [maxx, miny]
    ];
    rectangle = new maptalks.Polygon([coords]);
    // layer.addGeometry(rectangle);
    generateCanvas(tiles, function ({ image, width, height, texture }) {
        const terrain = new Terrain(extent, {
            texture,
            imageWidth: Math.ceil(width / 1),
            imageHeight: Math.ceil(height / 1),
            image,
            factor: 1.5,
            filterIndex: true
        }, material, threeLayer);
        lines.push(terrain);
        threeLayer.addMesh(terrain);
        animation();
        initGui();
    });
})
```

5. 页面显示

![img](https://img2020.cnblogs.com/blog/59231/202105/59231-20210507111104983-510946456.png)