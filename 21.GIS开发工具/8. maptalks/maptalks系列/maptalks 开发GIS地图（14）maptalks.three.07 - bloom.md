- [maptalks 开发GIS地图（14）maptalks.three.07 - bloom](https://www.cnblogs.com/googlegis/p/14722488.html)

1. 这个demo有着比较惊艳的效果，很多实际在用的项目上都采用了这种效果。

2. 添加地图并初始化建筑。

```js
var baseLayer = new maptalks.TileLayer('tile', {
            urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c', 'd'],
            attribution: '© <a href="http://osm.org">OpenStreetMap</a> contributors, © <a href="https://carto.com/">CARTO</a>'
        });

        var map = new maptalks.Map("map", {
            center: [13.412830873144912, 52.53720286413957],
            zoom: 16,
            pitch: 70,
            bearing: 180,
            centerCross: true,
            doubleClickZoom: false
        });
        // features to draw
        var features = [];
        buildings.forEach(function (b) {
            features = features.concat(b.features);
        });
        // the ThreeLayer to draw buildings
        var threeLayer = new maptalks.ThreeLayer('t', {
            forceRenderOnMoving: true,
            forceRenderOnRotating: true,
            // animation: true
        });
        var stats;
        var buildingMaterial = new THREE.MeshBasicMaterial({ color: 'rgb(19,19,38)' });
        var buildingMeshes = [];

        threeLayer.prepareToDraw = function (gl, scene, camera) {
            stats = new Stats();
            stats.domElement.style.zIndex = 100;
            document.getElementById('map').appendChild(stats.domElement);

            var light = new THREE.DirectionalLight(0xffffff);
            light.position.set(0, -10, 10).normalize();
            scene.add(light);

            this.initBloom();
            this.setRendererRenderScene();

            features.forEach(function (g) {
                var heightPerLevel = 10;
                var levels = g.properties.levels || 1;
                var mesh = threeLayer.toExtrudePolygon(maptalks.GeoJSON.toGeometry(g), {
                    height: heightPerLevel * levels,
                    topColor: '#fff',
                    // interactive: false
                }, buildingMaterial);
                buildingMeshes.push(mesh);
            });
            threeLayer.addMesh(buildingMeshes);
            addLines();

        };
        threeLayer.addTo(map);
```

3. 初始化 bloom 效果。

```js
/**
         * initBloom
         * */
maptalks.ThreeLayer.prototype.initBloom = function () {
    const params = {
        exposure: 1,
        bloomStrength: 4.5,
        bloomThreshold: 0,
        bloomRadius: 0,
        debug: false
    };
    const renderer = this.getThreeRenderer();
    const size = this.getMap().getSize();
    this.composer = new THREE.EffectComposer(renderer);
    this.composer.setSize(size.width, size.height);

    const scene = this.getScene(), camera = this.getCamera();
    this.renderPass = new THREE.RenderPass(scene, camera);

    this.composer.addPass(this.renderPass);

    const bloomPass = this.bloomPass = new THREE.UnrealBloomPass(new THREE.Vector2(size.width, size.height));
    bloomPass.renderToScreen = true;
    bloomPass.threshold = params.bloomThreshold;
    bloomPass.strength = params.bloomStrength;
    bloomPass.radius = params.bloomRadius;

    // composer.setSize(size.width, size.height);
    // composer.addPass(renderPass);
    this.composer.addPass(bloomPass);
    this.bloomEnable = true;
}
```

4. 添加道路线。

道路线分两种，一种是角色不发光，没有白色移动物在上面跑，另外一种是橘色发光，有白色物体在沿线移动。

```js
function addLines() {
            fetch('./data/berlin-roads.txt').then(function (res) {
                return res.text();
            }).then(function (geojson) {
                geojson = LZString.decompressFromBase64(geojson);
                geojson = JSON.parse(geojson);
                var lineStrings = maptalks.GeoJSON.toGeometry(geojson);
                var data = [], data1 = [];
                var classMap = {};
                lineStrings.forEach(lineString => {
                    const fclass = lineString.getProperties().fclass;
                    classMap[fclass] = fclass;
                    //main road
                    if (fclass && (fclass.includes('primary') || fclass.includes('secondary') || fclass.includes('tertiary'))) {
                        data1.push(lineString);
                    } else {
                        data.push(lineString);
                    }
                });
                const list = [];
                data.forEach(lineString => {
                    list.push({
                        lineString,
                        len: lineLength(lineString)
                    });
                });
                data = list.sort(function (a, b) {
                    return b.len - a.len
                });

                baseLines = data.slice(0, 200).map(function (d) {
                    var line = threeLayer.toLine(d.lineString, {}, baseLineMaterial);
                    line.getObject3d().layers.enable(1);
                    return line;
                });
                threeLayer.addMesh(baseLines);

                addExtrudeLine(data1);

            });
        }

        var material = new THREE.MeshBasicMaterial({
            color: 'rgb(255,45,0)', transparent: true, blending: THREE.AdditiveBlending
        });
        var highlightmaterial = new THREE.MeshBasicMaterial({ color: '#ffffff', transparent: true });
        var lines, lineTrails;

        function addExtrudeLine(lineStrings) {
            var timer = 'generate line time';
            console.time(timer);
            const list = [];
            lineStrings.forEach(lineString => {
                list.push({
                    lineString,
                    len: lineLength(lineString)
                });
            });
            lineStrings = list.sort(function (a, b) {
                return b.len - a.len
            });

            lines = lineStrings.slice(0, 1000).map(d => {
                var line = threeLayer.toExtrudeLine(d.lineString, { altitude: 0, width: 4, height: 1 }, material);
                line.getObject3d().layers.enable(1);
                return line;
            });
            lineTrails = lineStrings.slice(0, 300).map(function (d) {
                var line = threeLayer.toExtrudeLineTrail(d.lineString, { altitude: 0, width: 5, height: 2, chunkLength: d.len / 40, speed: 1, trail: 6 }, highlightmaterial);
                line.getObject3d().layers.enable(1);
                return line;
            });

            console.log('lines.length:', lines.length);
            console.timeEnd(timer);
            threeLayer.addMesh(lines);
            threeLayer.addMesh(lineTrails);
            initGui();
            // threeLayer.config('animation', true);
            animation();
        }
```

5. 建筑的数据使用的是 building.js

类似geojson 的json数据。没有geojson前面的头，直接就是对象数据。

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210430161633424-921155909.png)

 6.道路的数据使用的是 ./data/berlin-roads.txt

可以看出，这是一份加密数据，使用 LZString.decompressFromBase64 进行解密。解析后的数据就比较正常了。应该是geojson格式的数据了。

然后对数据截取一部分作为白光bloom效果的路线。

并且为了保证移动物的平滑性，把每个数据平均分为了1000份，这样移动物移动的时候，就比较光滑了。

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210430161757787-1427819081.png)

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210430162140677-1368809170.png)

7. 页面显示

 ![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210430162315061-1413979636.gif)

8. 源码地址

https://github.com/WhatGIS/maptalkMap

