- [maptalks 开发GIS地图（7）maptalks.three.00  介绍  ](https://www.cnblogs.com/googlegis/p/14721692.html)
- [maptalks 开发GIS地图（8）maptalks.three.01 准备](https://www.cnblogs.com/googlegis/p/14721713.html)
- [maptalks 开发GIS地图（9）maptalks.three.02 animation](https://www.cnblogs.com/googlegis/p/14721778.html)

# 一、maptalks.three 介绍

maptalks 是针对2D地图添加了视角和旋转等功能，实现的2.5D的地图库，以针对threejs支持著称。

不过本篇只针对maptalk中的插件 threeLayer 的功能进行介绍，maptalks 的基础功能请查看: https://github.com/WhatGIS/maptalkMap#readme

ThreeJS 是一组支持WebGL功能的js库，支持三维对象和三维显示，并能呈现一些特殊效果，如果三维的地图加上三维对象，呈现三维的效果，那必然实时相当的惊艳，目前GIS的方向也在逐渐向这个方向发展，Web上的Cesium，手机AR，眼镜的VR，甚至与基于实时的激光雷达，现在的GIS页面，不显示个三维效果，都不好意思出去和人打招呼。

TheeJS 的官方地址：https://threejs.org/ 大家可以查看一下threejs的内容和效果。简单了解一下，会对下面的内容有帮助。

maptalks 中的插件 threelayer 支持大部分的 threejs 内容，也就是说，通过地理位置，把一个三维对象放在那里，然后使用 threejs 的 webgl 特性来处理对象。

maptalks.three 的地址为 https://github.com/maptalks/maptalks.three ， 里面有源码和demo，有兴趣的可以自己拉下来看。

# 二、maptalks.three准备

开始使用maptalks.three 开发之前，先熟悉几个库和概念。

1. dat.gui.min.js

https://github.com/dataarts/dat.gui

这是一个用来调试WebGL对象的js库，绑定对象的属性后，可以通过UI的方式，直接修改对象的属性。

2. stats.min.js

https://github.com/mrdoob/stats.js/

Javascript 性能监控库，可以用来监控当前webgl的渲染性能。

3. 三维对象

一般三维对象是3dsMax软件制作出来的文件，类型包括很多，比较常用的应该有obj、fbx、glb、gltb等类型。

可参考我的另外一篇文章，对这几个类型进行了对比。

- [在maptalks中加载三维模型obj,fbx,glb](https://www.cnblogs.com/googlegis/p/13963519.html)

4. 理解了上面的功能也就可以把 maptalks 的GIS逻辑理清楚了。

maptalks 主要用来加载和显示地图，支持倾斜角度和旋转。

threejs 主要用来支持webgl 也就是 3d 对象的控制。

maptalks.three 类似于一个中间件，将两者结合起来。

# 三、maptalks.three animation

1. 说明： 本demo主要是加载了一个具有动画效果的三维机器人，然后通过鼠标选择菜单控制机器人的动作和表情。

　　其实这个机器人，本身就已经具有动画和动作表情效果了，只不过是使用threejs的接口，把它加载到地图上，然后再调用API操控机器人。

2. 先来看一下 ../threelayer/demo/data/RobotExpressive.glb 这个文件。通过Windows10下面自带的 3D查看器软件打开。

  这是一个glb文件，通过3dmax软件导出后，已经具有了动画效果。而且还包括了多种动画效果。

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210430134400660-2055360605.gif)

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210430134419102-1272222625.png)

 

3. 新建一个 maptalks 地图

关于maptalks 地图的功能，这里就不多讲了，可以参考前面的文章。

```js
var map = new maptalks.Map("map", {
            center: [19.06325670775459, 42.16842479475318],
            zoom: 9,
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

4. 新建一个 ThreeLayer 图层，并设置三维三要素，光源、场景、镜头。

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
            camera.add(new THREE.PointLight('#fff', 4));

            addGltf();

        };
        threeLayer.addTo(map);
```

5. 添加三维模型对象

这里使用了 THREE.GLTFLoader 对象，此函数包含在 GLTFLoader.js 中，需要调用前添加引用。

其中 model 对象是获取了三维模型中的场景，然后将三维模型进行旋转45° model.rotation , 模型比例设为 1:1 ， scale.set , 模型的位置设在地图中心点。

使用 addMesh 添加三维模型到对应的threeLayer 图层，完成了三维模型对象在地图上的添加。

```js
function addGltf() {
            clock = new THREE.Clock();
            stats = new Stats();
            map.getContainer().appendChild(stats.dom);
            var loader = new THREE.GLTFLoader();
            loader.load('./data/RobotExpressive.glb', function (gltf) {

                model = gltf.scene;
                model.rotation.x = Math.PI / 2;
                model.scale.set(100, 100, 100);
                model.position.copy(threeLayer.coordinateToVector3(map.getCenter()));
                threeLayer.addMesh(model);

                createGUI(model, gltf.animations);
                animate();

            }, undefined, function (e) {

                console.error(e);

            });
        }
```

6. 创建GUI用以控制机器人

这就是前面那篇文章说的使用了 dat.gui.min.js 中相关的内容。

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210430135508840-1961421798.png)

```js
function createGUI(model, animations) {
            var states = ['Idle', 'Walking', 'Running', 'Dance', 'Death', 'Sitting', 'Standing'];
            var emotes = ['Jump', 'Yes', 'No', 'Wave', 'Punch', 'ThumbsUp'];
            gui = new dat.GUI();
            mixer = new THREE.AnimationMixer(model);
            actions = {};
            for (var i = 0; i < animations.length; i++) {
                var clip = animations[i];
                var action = mixer.clipAction(clip);
                actions[clip.name] = action;
                if (emotes.indexOf(clip.name) >= 0 || states.indexOf(clip.name) >= 4) {
                    action.clampWhenFinished = true;
                    action.loop = THREE.LoopOnce;
                }
            }
            // states
            var statesFolder = gui.addFolder('States');
            var clipCtrl = statesFolder.add(api, 'state').options(states);
            clipCtrl.onChange(function () {
                fadeToAction(api.state, 0.5);
            });
            statesFolder.open();
            // emotes
            var emoteFolder = gui.addFolder('Emotes');
            function createEmoteCallback(name) {
                api[name] = function () {
                    fadeToAction(name, 0.2);
                    mixer.addEventListener('finished', restoreState);
                };
                emoteFolder.add(api, name);
            }
            function restoreState() {
                mixer.removeEventListener('finished', restoreState);
                fadeToAction(api.state, 0.2);
            }
            for (var i = 0; i < emotes.length; i++) {
                createEmoteCallback(emotes[i]);
            }
            emoteFolder.open();
            // expressions
            face = model.getObjectByName('Head_2');
            var expressions = Object.keys(face.morphTargetDictionary);
            var expressionFolder = gui.addFolder('Expressions');
            for (var i = 0; i < expressions.length; i++) {
                expressionFolder.add(face.morphTargetInfluences, i, 0, 1, 0.01).name(expressions[i]);
            }
            activeAction = actions['Walking'];
            activeAction.play();
            expressionFolder.open();
        }
```

7. 重新绘制webgl的状态，满足动画更新需要。

```js
function animate() {
    var dt = clock.getDelta();
    if (mixer) mixer.update(dt);
    requestAnimationFrame(animate);
    stats.update();
    // threeLayer._needsUpdate = !threeLayer._needsUpdate;
    if (threeLayer._needsUpdate) {
        threeLayer.renderScene();
    }
}
```

8. 在 maptalks 地图中的效果。

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210430135810435-790604260.gif)

 9. 源码地址

[ https://github.com/WhatGIS/maptalkMap/tree/main/threelayer/demo](https://github.com/WhatGIS/maptalkMap/tree/main/threelayer/demo)

