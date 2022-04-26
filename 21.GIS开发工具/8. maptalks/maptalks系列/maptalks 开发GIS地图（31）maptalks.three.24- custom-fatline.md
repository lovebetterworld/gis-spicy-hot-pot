- [maptalks 开发GIS地图（31）maptalks.three.24- custom-fatline](https://www.cnblogs.com/googlegis/p/14735819.html)

1. fatline ，这个名字也很有讲究，可是我还是不知道它的含义。

2. 创建 fatline 扩展类

```js
var OPTIONS = {
    altitude: 0
};

class FatLine extends maptalks.BaseObject {
    constructor(lineString, options, material, layer) {
        super();
        //geoutil.js getLinePosition
        const { positions } = getLinePosition(lineString, layer);
        const positions1 = _getLinePosition(lineString, layer).positions;

        options = maptalks.Util.extend({}, OPTIONS, options, { layer, lineString, positions: positions1 });
        this._initOptions(options);

        const geometry = new THREE.LineGeometry();
        geometry.setPositions(positions);
        const map = layer.getMap();
        const size = map.getSize();
        const width = size.width,
              height = size.height;
        material.resolution.set(width, height);
        const line = new THREE.Line2(geometry, material);
        line.computeLineDistances();
        this._createGroup();
        this.getObject3d().add(line);
        const { altitude } = options;
        const z = layer.distanceToVector3(altitude, altitude).x;
        const center = lineString.getCenter();
        const v = layer.coordinateToVector3(center, z);
        this.getObject3d().position.copy(v);
    }


    setSymbol(material) {
        if (material && material instanceof THREE.Material) {
            material.needsUpdate = true;
            const size = this.getMap().getSize();
            const width = size.width,
                  height = size.height;
            material.resolution.set(width, height);
            this.getObject3d().children[0].material = material;
        }
        return this;
    }

    //test Baseobject customize its identity
    identify(coordinate) {
        const layer = this.getLayer(), size = this.getMap().getSize(),
              camera = this.getLayer().getCamera(), positions = this.getOptions().positions, altitude = this.getOptions().altitude;
        let canvas = layer._testCanvas;
        if (!canvas) {
            canvas = layer._testCanvas = document.createElement('canvas');
        }
        canvas.width = size.width;
        canvas.height = size.height;
        const context = canvas.getContext('2d');

        const pixels = simplepath.vectors2Pixel(positions, size, camera, altitude, layer);
        const lineWidth = this.getObject3d().children[0].material.linewidth + 3;
        simplepath.draw(context, pixels, 'LineString', { lineWidth: lineWidth });
        const pixel = this.getMap().coordToContainerPoint(coordinate);
        if (context.isPointInStroke(pixel.x, pixel.y)) {
            return true;
        }
    }
}
```

3. 将 ./data/berlin-roads.txt 数据进行解密并进行处理，获取路径经纬度。

```js
fetch('./data/berlin-roads.txt').then(function (res) {
    return res.text();
}).then(function (geojson) {
    geojson = LZString.decompressFromBase64(geojson);
    geojson = JSON.parse(geojson);

    var lineStrings = maptalks.GeoJSON.toGeometry(geojson);
    var timer = 'generate line time';
    console.time(timer);
    var list = [];
    lineStrings.forEach(function (lineString) {
        list.push({
            lineString,
            //geoutil.js lineLength
            len: lineLength(lineString)
        });
    });
    list = list.sort(function (a, b) {
        return b.len - a.len
    });
    lines = list.slice(0, 200).map(function (d) {
        var line = new FatLine(d.lineString, { altitude: 100 }, material, threeLayer);

        //tooltip test
        line.setToolTip(line.getId(), {
            showTimeout: 0,
            eventsPropagation: true,
            dx: 10
        });


        //infowindow test
        line.setInfoWindow({
            content: 'hello world,id:' + line.getId(),
            title: 'message',
            animationDuration: 0,
            autoOpenOn: false
        });


        //event test
        ['click', 'mouseout', 'mouseover', 'mousedown', 'mouseup', 'dblclick', 'contextmenu'].forEach(function (eventType) {
            line.on(eventType, function (e) {
                console.log(e.type, e);
                // console.log(this);
                if (e.type === 'mouseout') {
                    this.setSymbol(material);
                }
                if (e.type === 'mouseover') {
                    this.setSymbol(highlightmaterial);
                }
            });
        });
        return line;
    });
    console.log('lines.length:', lines.length);
    console.timeEnd(timer);
    threeLayer.addMesh(lines);
    threeLayer.config('animation', true);
})
```

4. 页面显示

![img](https://img2020.cnblogs.com/blog/59231/202105/59231-20210506163813383-1223423742.png)

