- [maptalks 开发GIS地图（11）maptalks.three.04 bar-animation](https://www.cnblogs.com/googlegis/p/14722040.html)

1. 说明

使用柱状图，并加上了动画效果。

2. 初始化地图

```js
var map = new maptalks.Map("map", {
            center: [120.74088044043242, 30.48913000018203],
            zoom: 9.478337137999542,
            pitch: 58.800000000000026,
            bearing: -36.29999999999973,
            // bearing: 180,

            centerCross: true,
            doubleClickZoom: false
            // baseLayer: new maptalks.TileLayer('tile', {
            //     urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
            //     subdomains: ['a', 'b', 'c', 'd'],
            //     attribution: '© <a href="http://osm.org">OpenStreetMap</a> contributors, © <a href="https://carto.com/">CARTO</a>'
            // })
        });
```

3. 添加threelayer 图层，并设置环境。

```js
threeLayer.prepareToDraw = function (gl, scene, camera) {
            stats = new Stats();
            stats.domElement.style.zIndex = 100;
            document.getElementById("map").appendChild(stats.domElement);

            var light = new THREE.DirectionalLight(0xffffff);
            light.position.set(0, -10, 10).normalize();
            scene.add(light);

            scene.add(new THREE.AmbientLight(0xffffff, 0.2));

            // camera.add(new THREE.PointLight(0xffffff, 1));

            addBars(scene);
        };
        threeLayer.addTo(map);
```

4. 添加柱状图

```js
function addBars(scene) {
            const minLng = 120,
                maxLng = 121,
                minLat = 30,
                maxLat = 30.9;
            const lnglats = [];
            const NUM = 25;
            const rows = 24,
                cols = 24;
            const app = (window.app = new App(NUM, NUM));
            for (let i = 0; i <= cols; i++) {
                const lng = ((maxLng - minLng) / cols) * i + minLng;
                for (let j = 0; j <= rows; j++) {
                    const lat = ((maxLat - minLat) / rows) * j + minLat;
                    const bar = threeLayer.toBar([lng, lat], { height: 40000, radius: 2000, radialSegments: 4, interactive: false }, material);
                    bar.getObject3d().rotation.z = Math.PI / 4;
                    bars.push(bar);
                    app.staggerArray.push({
                        altitude: 0
                    });
                }
            }
            threeLayer.addMesh(bars);
            app.init();
            animation();
        }
```

5. 设置方柱动画。

```js
class App {
            constructor(rows, cols) {
                this.rows = rows;
                this.cols = cols;

                this.randFrom = ["first", "last", "center"];

                this.easing = [
                    "linear",
                    "easeInOutQuad",
                    "easeInOutCubic",
                    "easeInOutQuart",
                    "easeInOutQuint",
                    "easeInOutSine",
                    "easeInOutExpo",
                    "easeInOutCirc",
                    "easeInOutBack",
                    "cubicBezier(.5, .05, .1, .3)",
                    "spring(1, 80, 10, 0)",
                    "steps(10)"
                ];
                this.staggerArray = [];
            }

            init() {
                this.beginAnimationLoop();
            }
            beginAnimationLoop() {
                // random from array
                let randFrom = this.randFrom[
                    Math.floor(Math.random() * this.randFrom.length)
                ];
                let easingString = this.easing[
                    Math.floor(Math.random() * this.easing.length)
                ];

                anime({
                    targets: this.staggerArray,
                    altitude: [
                        { value: 100000 * 0.25, duration: 500 },
                        { value: -(0 * 0.25), duration: 2000 }
                    ],
                    delay: anime.stagger(200, {
                        grid: [this.rows, this.cols],
                        from: randFrom
                    }),
                    easing: easingString,
                    complete: (anim) => {
                        this.beginAnimationLoop();
                    },
                    update: () => {
                        for (let i = 0, len = bars.length; i < len; i++) {
                            bars[i].setAltitude(this.staggerArray[i].altitude);
                        }
                    }
                });
            }
        }
```

6. 显示效果

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210430150053055-678089238.gif)

7. 源码参考

https://github.com/WhatGIS/maptalkMap

