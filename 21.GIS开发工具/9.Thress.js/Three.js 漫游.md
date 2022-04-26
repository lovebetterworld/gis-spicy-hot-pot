- [Three.js 漫游](https://blog.csdn.net/qq_39503511/article/details/114783707)

# 概述

开发了一个Three.js 商场漫游demo，先看视频效果

<iframe id="9RwhvM3T-1615700077553" src="https://live.csdn.net/v/embed/156959" allowfullscreen="true" data-mediaembed="csdn"></iframe>

three.js 室内漫游项目demo



# 创建场景

创建渲染器，灯光，相机，控制器和以前的智慧城市项目一样，从那边照抄过来即可，调用方式如下

```javascript
	  app = new ZThree("screen");
      app.initThree();
      // app.initHelper();
      app.initOrbitControls();
      light = app.initLight();

      // stats = app.initStatus();
      selectObj = app.initRaycaster();
      window.app = app;
      camera = app.camera;
      // bloomComposer = app.bloomComposer();
      camera.position.set(...this.cameraPosition);
      scene = app.scene;
      renderer = app.renderer;
      renderer.logarithmicDepthBuffer = true;
      renderer.autoClear = false;

      controls = app.controls;
      controls.target.set(...this.target);
      controls.maxDistance = 2000;
      controls.maxPolarAngle = Math.PI / 2.2;
      clock = new THREE.Clock();
```

# 创建天空

```javascript
export function loaderSky(app, water) {
  return new Promise(resolve => {
    let sky = new Sky();
    sky.scale.setScalar(10000);
    app.scene.add(sky);
    let skyUniforms = sky.material.uniforms;

    skyUniforms['turbidity'].value = 1;
    skyUniforms['rayleigh'].value = 3;
    skyUniforms['mieCoefficient'].value = 0.005;
    skyUniforms['mieDirectionalG'].value = 0.8;

    let parameters = {
      inclination: 0.49,
      azimuth: 0.205
    };

    let pmremGenerator = new THREE.PMREMGenerator(app.renderer);

    let sun = new THREE.Vector3();

    let theta = Math.PI * (parameters.inclination - 0.5);
    let phi = 2 * Math.PI * (parameters.azimuth - 0.5);

    sun.x = Math.cos(phi);
    sun.y = Math.sin(phi) * Math.sin(theta);
    sun.z = Math.sin(phi) * Math.cos(theta);

    sky.material.uniforms['sunPosition'].value.copy(sun);
    water.material.uniforms['sunDirection'].value.copy(sun).normalize();

    app.scene.environment = pmremGenerator.fromScene(sky).texture;

    resolve(sky);
  })
}
```

# 创建水面

创建一个平面然后加上调用水面的材质就好，很简单

```javascript
export function loaderWater(app) {
  return new Promise(resolve => {
    let waterGeometry = new THREE.PlaneGeometry(10000, 10000);

    let water = new Water(
      waterGeometry, {
        textureWidth: 512,
        textureHeight: 512,
        waterNormals: new THREE.TextureLoader().load('texture/waternormals.jpg', function (texture) {
          texture.wrapS = texture.wrapT = THREE.RepeatWrapping;
        }),
        alpha: 1.0,
        sunDirection: new THREE.Vector3(),
        sunColor: 0xffffff,
        waterColor: 0x001e0f,
        distortionScale: 3.7,
        fog: app.scene.fog !== undefined
      }
    );

    water.rotation.x = -Math.PI / 2;

    app.scene.add(water);

    resolve(water);
  })
}
```

此时我们看到的效果是
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210314125927527.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70)

# 创建模型

```javascript
export async function loaderShop(app) {
  return new Promise(async resolve => {
    let model = await app.loaderGltfDracoModel('model/', 'Fantasy_Mall');
    let allModel = [];
    model.traverse(obj => {
      if (obj.isMesh) {
        let s = 0.05;
        obj.scale.set(s, s, s);
        obj.material.side = THREE.DoubleSide;
        obj.material.needsUpdate = true;
        allModel.push(obj);
      }
    })
    model.position.y = 12;
    app.scene.add(model);
    resolve({
      model,
      allModel
    });
  })
}
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210314130057723.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70)

# 室内漫游

思路，首先我们先创建一个CircleGeometry，作用是显示要移动到的地点，我们在鼠标移动的时候更新这个点的定位即可

```javascript
let circleMat = new THREE.MeshBasicMaterial({
  color: 'yellow'
})
let circleGeo = new THREE.CircleGeometry(1.5, 20)
let circle = new THREE.Mesh(circleGeo, circleMat)
circle.rotation.x = -Math.PI / 2
circle.position.set(10000, 10000, 10000)
circle.material.transparent = true
circle.material.opacity = 0.5
circle.name = 'circle'
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210314130426900.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70)
 第二步我们创建一个box来绑定我们的相机

```javascript
let targetGeo = new THREE.BoxGeometry(4, 17, 4)
let camTarget = new THREE.Mesh(targetGeo, targetMat)
camTarget.position.set(...orientation)
camTarget.name = 'camTarget'
camTarget.visible = false
```

第三步将控制器绑定到box上，我们移动box实际就是移动控制器

```javascript
controls.target
            .copy(camTarget.position)
            .add(new THREE.Vector3(0, 5, 0));
```

第四步我们在鼠标移动的时候获取到当前的坐标，np就是我们获取到的坐标，此时在将坐标给绑定到circle上既可以更新circle的位置，这样我们就完成了鼠标移动的时候circle也跟随移动的效果

```javascript
if (selectObj && names.indexOf(selectObj.object.name) > -1) {
    let op = selectObj.point
    let nx = op.x
    let ny = op.y + 0.1
    let nz = op.z
    let np = new THREE.Vector3(nx, ny, nz)
    circle.position.copy(np)
  }
```

第五步我们在点击的时候更新我们的box的位置即可，这样我们差不多就完成了室内漫游的这个功能
 ，更新位置使用tween来做动画即可

```javascript
movingTarget = app.modelMove({
        fromPosition: [camTarget.position.x, camTarget.position.y, camTarget.position.z],
        toPosition: [upPoint.x, upPoint.y, upPoint.z]
      }, camTarget)
```

ok，此时我们就完成了这个漫游的功能！