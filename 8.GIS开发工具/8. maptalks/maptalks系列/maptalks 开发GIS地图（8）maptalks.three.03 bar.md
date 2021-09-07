- [maptalks 开发GIS地图（10）maptalks.three.03 bar](https://www.cnblogs.com/googlegis/p/14721889.html)

1. 说明

这个 demo 主要显示3D的柱状图，而且是具有地理位置信息的柱状图，比echart那些二维的柱状图效果当然要好很多。

2. 初始化地图

```
var map = new maptalks.Map("map", {
            center: [19.06325670775459, 42.16842479475318],
            zoom: 3,
            pitch: 60,
            // bearing: 180,

            centerCross: true,
            doubleClickZoom: false,
            baseLayer: new maptalks.TileLayer('tile', {
                urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c', 'd'],
                attribution: '© <a href="http://osm.org">OpenStreetMap</a> contributors, © <a href="https://carto.com/">CARTO</a>'
            })
        });
```

3. 添加 threelayer 图层，并设置webgl 三要素。

```js
// the ThreeLayer to draw buildings
        var threeLayer = new maptalks.ThreeLayer('t', {
            forceRenderOnMoving: true,
            forceRenderOnRotating: true
            // animation: true
        });
        threeLayer.prepareToDraw = function (gl, scene, camera) {
            var light = new THREE.DirectionalLight(0xffffff);
            light.position.set(0, -10, 10).normalize();
            scene.add(light);
            scene.add(new THREE.AmbientLight(0xffffff, 0.5));
            setTimeout(() => {
                addBars(scene);
            }, 1000);

        };
        threeLayer.addTo(map);
```

4. 添加柱状图，数据使用的是 ../data/population.json , 从格式可以看出，每个数据包含三项内容，经度、纬度、数值。

代码里添加了两个变量，material 和 highlightmaterial ， 当鼠标移动到物体上时，则变换颜色。

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210430142049198-2021434087.png)

```js
var bars;
        var material = new THREE.MeshLambertMaterial({ color: '#fff', transparent: true });
        var highlightmaterial = new THREE.MeshBasicMaterial({ color: 'yellow', transparent: true });
        function addBars(scene) {
            fetch('./data/population.json').then((function (res) {
                return res.json();
            })).then(function (json) {
                const time = 'time';
                console.time(time);
                bars = json.filter(function (dataItem) {
                    return dataItem[2] > 500;
                }).slice(0, Infinity).map(function (dataItem) {
                    return {
                        coordinate: dataItem.slice(0, 2),
                        height: dataItem[2]
                    }
                }).map(function (d) {
                    var bar = threeLayer.toBar(d.coordinate, {
                        height: d.height * 400,
                        radius: 15000,
                        topColor: '#fff',
                        // radialSegments: 4
                    }, material);

                    // tooltip test
                    bar.setToolTip(d.height * 400, {
                        showTimeout: 0,
                        eventsPropagation: true,
                        dx: 10
                    });


                    //infowindow test
                    bar.setInfoWindow({
                        content: 'hello world,height:' + d.height * 400,
                        title: 'message',
                        animationDuration: 0,
                        autoOpenOn: false
                    });


                    //event test
                    ['click', 'mouseout', 'mouseover', 'mousedown', 'mouseup', 'dblclick', 'contextmenu'].forEach(function (eventType) {
                        bar.on(eventType, function (e) {
                            // console.log(e.type, e);
                            // console.log(this);
                            if (e.type === 'mouseout') {
                                this.setSymbol(material);
                            }
                            if (e.type === 'mouseover') {
                                this.setSymbol(highlightmaterial);
                            }
                        });
                    });

                    return bar;
                });

                console.log(bars);
                console.timeEnd(time);
                // bars.forEach(function (bar) {
                //     scene.add(bar.getObject3d());
                // });
                // threeLayer.renderScene();
                threeLayer.addMesh(bars);
                initGui();
                threeLayer.config('animation', true);
            })
        }
```

5. 事件， 代码中定义了事件的处理方式，可以同时处理多个事件类型，通过 type 再进行分别处理。

```js
['click', 'mouseout', 'mouseover', 'mousedown', 'mouseup', 'dblclick', 'contextmenu'].forEach(function (eventType) {
                        bar.on(eventType, function (e) {
                            // console.log(e.type, e);
                            // console.log(this);
                            if (e.type === 'mouseout') {
                                this.setSymbol(material);
                            }
                            if (e.type === 'mouseover') {
                                this.setSymbol(highlightmaterial);
                            }
                        });
                    });
```

6. 另外被注释的代码里包括 tooltip 和 InfoWindow。

tooltip 是鼠标移动到物体上时，提示的文字内容，Info 是点击物体时弹出的提示内容。

两者还是有区别的。

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210430142649095-438645416.png)

```js
// tooltip test
bar.setToolTip(d.height * 400, {
    showTimeout: 0,
    eventsPropagation: true,
    dx: 10
});

//infowindow test
bar.setInfoWindow({
    content: 'hello world,height:' + d.height * 400,
    title: 'message',
    animationDuration: 0,
    autoOpenOn: false
});
```

7. 显示效果

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210430142805646-1170838352.png)

8. 源码地址

https://github.com/WhatGIS/maptalkMap/tree/main/threelayer/demo

