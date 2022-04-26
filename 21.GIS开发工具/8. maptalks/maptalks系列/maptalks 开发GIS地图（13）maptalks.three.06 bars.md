- [maptalks 开发GIS地图（13）maptalks.three.06 bars](https://www.cnblogs.com/googlegis/p/14722308.html)

1. 说明

使用柱状图，并根据音乐节奏显示动画效果。

2. 初始化地图并添加threelayer

```js
var map = new maptalks.Map("map", {
            center: [19.06325670775459, 42.16842479475318],
            zoom: 3,
            pitch: 60,
            // bearing: 180,

            centerCross: true,
            doubleClickZoom: false,
            // baseLayer: new maptalks.TileLayer('tile', {
            //     urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
            //     subdomains: ['a', 'b', 'c', 'd'],
            //     attribution: '© <a href="http://osm.org">OpenStreetMap</a> contributors, © <a href="https://carto.com/">CARTO</a>'
            // })
        });

        // the ThreeLayer to draw buildings
        var threeLayer = new maptalks.ThreeLayer('t', {
            forceRenderOnMoving: true,
            forceRenderOnRotating: true
            // animation: true
        });
        threeLayer.prepareToDraw = function (gl, scene, camera) {
            stats = new Stats();
            stats.domElement.style.zIndex = 100;
            document.getElementById('map').appendChild(stats.domElement);

            var light = new THREE.DirectionalLight(0xffffff);
            light.position.set(0, -10, 10).normalize();
            scene.add(light);

            scene.add(new THREE.AmbientLight(0xffffff, 0.2));

            // camera.add(new THREE.PointLight(0xffffff, 1));

            addBars(scene);

        };
        threeLayer.addTo(map);
```

3. 添加数据

```js
function addBars(scene) {
            fetch('./data/population.json').then((function (res) {
                return res.json();
            })).then(function (json) {
                const data = json.filter(function (dataItem) {
                    return dataItem[2] > 0;
                }).map(function (dataItem) {
                    dataItem[2] *= 400;
                    min = Math.min(min, dataItem[2]);
                    max = Math.max(max, dataItem[2]);
                    return {
                        coordinate: dataItem.slice(0, 2),
                        height: dataItem[2],
                        radius: 15000,
                        // topColor: '#fff'
                    }
                }).slice(0, Infinity);
                const colorMap = {};
                data.forEach(d => {
                    const { height } = d;
                    const color = getColor(height);
                    if (!colorMap[color]) {
                        const m = material.clone();
                        m.color.set(color);
                        colorMap[color] = {
                            data: [],
                            material: m
                        }
                    }
                    colorMap[color].data.push(d);
                });
                console.log(colorMap);
                const time = 'time';
                console.time(time);
                for (let color in colorMap) {
                    const { data, material } = colorMap[color];
                    const mesh = threeLayer.toBars(data, { interactive: false }, material);
                    bars.push(mesh);
                }
                console.timeEnd(time);
                bars.forEach(mesh => {
                    mesh.setToolTip('hello', {
                        showTimeout: 0,
                        eventsPropagation: true,
                        dx: 10
                    });

                    //infowindow test
                    mesh.setInfoWindow({
                        content: 'hello world',
                        title: 'message',
                        animationDuration: 0,
                        autoOpenOn: false
                    });

                    //event test
                    ['click', 'mousemove', 'empty', 'mouseout', 'mouseover', 'mousedown', 'mouseup', 'dblclick', 'contextmenu'].forEach(function (eventType) {
                        mesh.on(eventType, function (e) {
                            // console.log(e.type);
                            const select = e.selectMesh;
                            if (e.type === 'empty' && selectMesh.length) {
                                threeLayer.removeMesh(selectMesh);
                                selectMesh = [];
                            }

                            let data, baseObject;
                            if (select) {
                                data = select.data;
                                baseObject = select.baseObject;
                                if (baseObject && !baseObject.isAdd) {
                                    baseObject.setSymbol(highlightmaterial);
                                    threeLayer.addMesh(baseObject);
                                    selectMesh.push(baseObject);
                                }
                            }


                            if (selectMesh.length > 20) {
                                threeLayer.removeMesh(selectMesh);
                                selectMesh = [];
                            }


                            // override tooltip
                            if (e.type === 'mousemove' && data) {
                                const height = data.height;
                                const tooltip = this.getToolTip();
                                tooltip._content = `height:${height}`;
                            }
                            //override infowindow
                            if (e.type === 'click' && data) {
                                const height = data.height;
                                const infoWindow = this.getInfoWindow();
                                infoWindow.setContent(`height:${height}`);
                                if (infoWindow && (!infoWindow._owner)) {
                                    infoWindow.addTo(this);
                                }
                                this.openInfoWindow(e.coordinate);

                            }
                        });
                    });
                });
                console.log(bars);
                threeLayer.addMesh(bars);
                initGui();
                animation();
            });
        }
```

4. 数据使用的是 ./data/population.json

这里的是数据原始格式：

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210430153923953-1827758443.png)

下面的这段代码，将这个数据重新生成了一次，把前两个数据作为 coordinate，将最后一个数据乘以 400 作为高度。

然后将 15000 作为了圆柱的半径。

```js
dataItem[2] *= 400;
 min = Math.min(min, dataItem[2]);
 max = Math.max(max, dataItem[2]);
 return {
       coordinate: dataItem.slice(0, 2),
       height: dataItem[2],
       radius: 15000,
       // topColor: '#fff'
}
```

最终的数据变为了下面的样式。

别问我那个数据为啥是 440.00000000000006 😭

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210430154635282-2040159630.png)

5. 显示效果

效果还是不错的。

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210430153503721-1723419699.png)

6. 源码参考

https://github.com/WhatGIS/maptalkMap

