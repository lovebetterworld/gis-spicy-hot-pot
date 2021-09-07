- [maptalks 开发GIS地图（12）maptalks.three.05 bar-music](https://www.cnblogs.com/googlegis/p/14722194.html)

1. 说明

使用柱状图，并根据音乐节奏显示动画效果。

2. 初始化地图

```js
var map = new maptalks.Map("map", {
            center: [120.88083857368815, 31.494732837748273],
            zoom: 10,
            pitch: 35,
            bearing: -43.600000000000136,

            centerCross: true,
            doubleClickZoom: false,
            // baseLayer: new maptalks.TileLayer('tile', {
            //     urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
            //     subdomains: ['a', 'b', 'c', 'd'],
            //     attribution: '© <a href="http://osm.org">OpenStreetMap</a> contributors, © <a href="https://carto.com/">CARTO</a>'
            // })
        });
```

3. 添加threelayer 图层，并设置环境。

其中 oReq 对象读取 MP3文件的数据，并进行解析。

```js
// the ThreeLayer to draw
        var threeLayer = new maptalks.ThreeLayer('t', {
            forceRenderOnMoving: true,
            forceRenderOnRotating: true
            // animation: true
        });
        threeLayer.prepareToDraw = function (gl, scene, camera) {
            var light = new THREE.PointLight(0xffffff);
            // light.position.set(0, -10, 10).normalize();
            camera.add(light);

            var ambientlight = new THREE.AmbientLight(0x999999, 1.57);
            scene.add(ambientlight);

            var oReq = new XMLHttpRequest();
            oReq.open('GET', './data/roll-it-up.mp3', true);
            oReq.responseType = 'arraybuffer';

            oReq.onload = function (e) {
                audioContext.decodeAudioData(oReq.response, initVisualizer);
            };
            oReq.send();
            // threeLayer.config('animation', true);
            animation();
        };

        threeLayer.addTo(map);
```

4. MP3数据解析

```js
// code from https://www.echartsjs.com/examples/zh/editor.html?c=bar3d-music-visualization&gl=1
        function initVisualizer(audioBuffer) {
            inited = true;

            var source = audioContext.createBufferSource();
            source.buffer = audioBuffer;

            // Must invoked right after click event
            if (source.noteOn) {
                source.noteOn(0);
            } else {
                source.start(0);
            }

            var analyzer = audioContext.createAnalyser();
            var gainNode = audioContext.createGain();
            analyzer.fftSize = 4096;

            gainNode.gain.value = 1;
            source.connect(gainNode);
            gainNode.connect(analyzer);
            analyzer.connect(audioContext.destination);

            var frequencyBinCount = analyzer.frequencyBinCount;
            var dataArray = new Uint8Array(frequencyBinCount);


            function update() {
                analyzer.getByteFrequencyData(dataArray);

                var item = [];
                var size = 50;
                var dataProvider = [];

                for (var i = 0; i < size * size; i++) {
                    var x = i % size;
                    var y = Math.floor(i / size);
                    var dx = x - size / 2;
                    var dy = y - size / 2;

                    var angle = Math.atan2(dy, dx);
                    if (angle < 0) {
                        angle = Math.PI * 2 + angle;
                    }
                    var dist = Math.sqrt(dx * dx + dy * dy);
                    var idx = Math.min(
                        frequencyBinCount - 1, Math.round(angle / Math.PI / 2 * 60 + dist * 60) + 100
                    );

                    var val = Math.pow(dataArray[idx] / 100, 3);
                    dataProvider.push([x, y, Math.max(val, 0.1)]);
                }
                var musdata = [];
                for (var i = 0; i < dataProvider.length; i++) {
                    var d = dataProvider[i];
                    var x = d[0],
                        y = d[1],
                        z = d[2];
                    var lng = minLng + x * averageLng;
                    var lat = minLat + y * averageLat;
                    var height = z * scale;
                    if (height < 2000) continue;
                    musdata.push({
                        // name: Math.random() * 10000,
                        value: [lng, lat, height]
                    });
                }
                addBars(musdata);

                setTimeout(update, UPDATE_DURATION);
            }
            update();
        }
```

5. 更新数据柱状图

```js
function addBars(data) {
            if (bars) {
                threeLayer.removeMesh(bars, false);
            }
            bars = data.map(function (d) {
                var value = d.value;
                minValue = Math.min(minValue, value[2]);
                maxValue = Math.max(maxValue, value[2]);
                const material = getMaterial(value[2]);
                if (!barCache[value[2]]) {
                    barCache[value[2]] = threeLayer.toBox(value.slice(0, 2), {
                        height: value[2],
                        radius: 600,
                        topColor: '#fff',
                        interactive: false
                    }, material);
                }
                //复用geometry
                const geometry = barCache[value[2]].getObject3d().geometry;
                const options = barCache[value[2]].getOptions();
                const coordinate = value.slice(0, 2);
                const bar = new maptalks.BaseObject();
                bar._initOptions(Object.assign({}, options, { coordinate }));
                bar._createMesh(geometry, material);
                const position = threeLayer.coordinateToVector3(coordinate);
                bar.getObject3d().position.copy(position);
                return bar;
            });
            threeLayer.addMesh(bars, false);
        }
```

6. 显示效果

这个动画确实是根据音乐节奏来的， 音乐可参考 ../data/roll-it-up.mp3。

这让我想起了windowsXP自带的音乐播放器。

 

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210430153003949-1774770341.gif)

7. 源码参考

https://github.com/WhatGIS/maptalkMap

