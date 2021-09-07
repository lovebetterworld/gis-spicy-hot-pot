- [maptalks 开发GIS地图（36）maptalks.three.29- custom-image-plane  ](https://www.cnblogs.com/googlegis/p/14737732.html)

1. image plane 与前面的 [geotiff plane ](https://www.cnblogs.com/googlegis/p/14736002.html)在效果上是类似的。

2. 加载的图片地址 https://gw.alipayobjects.com/mdn/antv_site/afts/img/A*8SUaRr7bxNsAAAAAAAAAAABkARQnAQ

3. 自定义ImagePlane扩展类

```js
class ImagePlane extends maptalks.BaseObject {
    constructor(extent, options, material, layer) {
        options = maptalks.Util.extend({}, OPTIONS, options, { layer, extent });
        const { texture, altitude, imageHeight, imageWidth, factor, filterIndex } = options;
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
        const img = generateImage(texture);
        const geometry = new THREE.PlaneBufferGeometry(w, h, imageWidth - 1, imageHeight - 1);
        super();
        this._initOptions(options);
        this._createMesh(geometry, material);
        const z = layer.distanceToVector3(altitude, altitude).x;
        const v = layer.coordinateToVector3(extent.getCenter(), z);
        this.getObject3d().position.copy(v);
        material.transparent = true;
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
    }
}
```

4. 添加图片

```js
const image = new ImagePlane([113.1277263548, 32.3464238863, 118.1365790452, 36.4786759137], {
    texture: 'https://gw.alipayobjects.com/mdn/antv_site/afts/img/A*8SUaRr7bxNsAAAAAAAAAAABkARQnAQ'
}, material, threeLayer);
threeLayer.addMesh(image);
```

5. 页面显示

![img](https://img2020.cnblogs.com/blog/59231/202105/59231-20210507092039639-572334314.png)

