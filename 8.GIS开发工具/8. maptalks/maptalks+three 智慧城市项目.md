- [maptalks+three 智慧城市项目](https://blog.csdn.net/qq_39503511/article/details/114436877)

# 概述

经过上一次使用three.js做了个demo，这次使用maptalks+three+vue来继续开发一个demo玩玩
 先看视频效果：

<iframe id="bvzzjqdd-1615007935063" src="https://live.csdn.net/v/embed/156451" allowfullscreen="true" data-mediaembed="csdn"></iframe>

maptalks+three 智慧城市

# 搭建开发环境

使用的开发框架是vue-cli3.0, webgl使用three.js，地图使用maptalks，开发工具为vscode
 搭建完成后的目录为
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210116144436528.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70)

# 搭建maptalks+three场景

和上一个项目初始化场景一样，先创建一个ZThree的类，然后写入一个初始化方法initMapTalks

```javascript
initMapTalks(option) {
    let config = {
      center: [113.31915199756622, 23.109087176037534],
      zoom: 17,
      pitch: 70,
      bearing: 180,

      centerCross: true,
      doubleClickZoom: false,
      baseLayer: new maptalks.TileLayer('tile', {
        urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
        subdomains: ['a', 'b', 'c', 'd']
      })
    };
    option = Object.assign(config, option);
    let map = new maptalks.Map(this.id, option);

    let threeLayer = new ThreeLayer('t', {
      forceRenderOnMoving: true,
      forceRenderOnRotating: true
    });

    threeLayer.addTo(map);

    ThreeLayer.prototype.coordinateToXYZ = function (coordinate, height = 0) {
      let z = this.distanceToVector3(height, height).x;
      let v = this.coordinateToVector3(coordinate, z)
      return [v.x, v.y, v.z];
    }

    return threeLayer;
  }
```

- 实例化类

```javascript
app = new ZThree("screen");
```

# 创建灯光

灯光代码和上次项目的代码一样，在博客中的智慧城市第一篇文章中查找

```javascript
app.initLight();
```

此时我们看到的是已经成功创建好了地图
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210306123730163.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70)

# 加载建筑模型

1. 创建加载模型方法 loadBuilding

```javascript
export function loadBuilding(threeLayer) {
  let features = buildingGeoJosn.features;

  let polygons = features.map(f => {
    let height = Number(f.properties.height);
    let polygon = maptalks.GeoJSON.toGeometry(f);
    polygon.setProperties({
      height,
    });
    return polygon;
  });

  let material = new THREE.ShaderMaterial({
    uniforms: bulidingShader.uniforms,
    vertexShader: bulidingShader.vs,
    fragmentShader: bulidingShader.fs,
    side: THREE.DoubleSide,
    transparent: true,
  })

  let mesh = threeLayer.toExtrudePolygons(polygons, {
    interactive: false
  }, material);

  let meshs = [];

  let bufferGeometry = mesh.getObject3d().geometry;
  let geometry = new THREE.Geometry().fromBufferGeometry(bufferGeometry);

  let {
    vertices,
    faces,
    faceVertexUvs
  } = geometry;
  for (let i = 0, len = faces.length; i < len; i++) {
    let {
      a,
      b,
      c
    } = faces[i];
    let p1 = vertices[a],
      p2 = vertices[b],
      p3 = vertices[c];
    //top face
    if (p1.z > 0 && p2.z > 0 && p3.z > 0) {
      let uvs = faceVertexUvs[0][i];
      for (let j = 0, len1 = uvs.length; j < len1; j++) {
        uvs[j].x = 0;
        uvs[j].y = 0;
      }
    }
  }
  mesh.getObject3d().geometry = new THREE.BufferGeometry().fromGeometry(geometry);
  bufferGeometry.dispose();
  geometry.dispose();
  meshs.push(mesh);

  threeLayer.addMesh(meshs);
}
```

1. 在场景中调用此方法数据

```javascript
loadBuilding(threeLayer);
```

数据可从此地址获得 https://www.openstreetmap.org/
 此时我们可以看到的效果是，用的数据量小的做开发，后期数据自己替换即可
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210306124532540.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70)
 建筑贴图：
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210306125608477.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70#pic_center)

# 加载流光道路

流光道路使用MeshLineMaterial来实现，因为three.js的线条材质是没有宽度的，所以此处我们需要导入一个新的库THREE.MeshLine，当然可以使用管道tube来实现也是可以的，使用管道来实现请查看博客中的流光特效文章

```javascript
export function loaderRoad(threeLayer, SpriteLine) {
  let texture = new THREE.TextureLoader().load('texture/road.png');
  texture.anisotropy = 16;
  texture.wrapS = THREE.RepeatWrapping;
  texture.wrapT = THREE.RepeatWrapping;
  let camera = threeLayer.getCamera();

  let material = new MeshLineMaterial({
    map: texture,
    useMap: true,
    lineWidth: 13,
    sizeAttenuation: false,
    transparent: true,
    near: camera.near,
    far: camera.far
  });

  let features = roadGeoJosn.features;

  let meshs = []

  features.forEach(item => {
    if (item.geometry.type === 'LineString' && item.properties?.highway === 'primary') {
      let line = maptalks.GeoJSON.toGeometry(item);
      let mesh = new SpriteLine(line, {
        altitude: 0
      }, material, threeLayer);
      meshs.push(mesh);
    }
  })

  threeLayer.addMesh(meshs);
}
```

数据来源和建筑的是一个地址，添加好后在场景中引入即可，流光动画只要偏移贴图的uv就好了
 此时的效果
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210306125152549.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70)
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210306125155481.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70)
 道路流光的贴图
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210306125503432.png#pic_center)

# 加载水系

水系使用Ocean来制作，具体的可以在github上搜索Ocean来看案例

```javascript
export function loaderWater(threeLayer) {
  let polygons = maptalks.GeoJSON.toGeometry(waterGeoJosn);
  let oceans = polygons.map(p => {
    let ocean = new Ocean(p, {
      waterNormals: 'texture/waternormals.jpg'
    }, threeLayer)
    return ocean;
  });
  threeLayer.addMesh(oceans);
}
```

水系的贴图
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210306125437926.jpg?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70#pic_center)
 此时我们看到的效果是
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210306125716393.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70)

# 加载大厦模型

模型在网上随便找了一个，勉强能用
 加载模型代码

```javascript
export async function loaderModel(app, threeLayer, position) {
  let model = await app.loaderModel(
    "model/",
    'building'
  );
  let material = new THREE.ShaderMaterial({
    uniforms: modelShader.uniforms,
    vertexShader: modelShader.vs,
    fragmentShader: modelShader.fs,
    side: THREE.DoubleSide,
    transparent: true,
  })
  model.traverse(obj => {
    obj.material = material;
    obj.scale.set(1.5, 1.5, 1.5);
  })
  model.position.set(...position);
  model.rotateX(Math.PI / 2)
  threeLayer.addMesh(model);
  return model;
}
```

模型下载地址：https://download.csdn.net/download/qq_39503511/15611779
 加载成功后看到的效果：
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210306130235471.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70)

# 加载飞行线条

飞行线条也和上期代码中的开发方式一样的，通过三个点生成贝塞尔曲线，在添加贴图偏移就好了

```javascript
export function loaderCurve(app, threeLayer, geojson = curve) {
  let points = geojson.features.map(item => {
    let coordinates = item.geometry.coordinates;
    return [new THREE.Vector3(...threeLayer.coordinateToXYZ(coordinates)), new THREE.Vector3(...threeLayer.coordinateToXYZ([-73.98565649986267, 40.74843959459197], 258))]
  })
  let meshs = []

  points.forEach((point, index) => {
    let c = point[0].clone().add(point[1].clone()).divideScalar(2);
    c.z += 4
    let curve = new THREE.QuadraticBezierCurve3(point[0], c, point[1])
    let points = curve.getPoints(80)
    let line = new THREE.CatmullRomCurve3(points)
    let tube = app.loaderTube(
      line,
      index % 2 === 0 ? tubeRedMaterial : tubeGreenMaterial
    );
    meshs.push(tube);
  })
  threeLayer.addMesh(meshs);
}
```

此时我们看到的效果是
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210306130511801.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70)

# 创建圆锥体

```javascript
export function loaderCone(threeLayer, geojson = cone) {
  let points = geojson.features.map(item => {
    let coordinates = item.geometry.coordinates;
    return threeLayer.coordinateToXYZ(coordinates, 100)
  })
  let geometry = new THREE.ConeGeometry(0.2, 0.4, 4);

  let meshs = []
  points.forEach(item => {
    let material = new THREE.MeshBasicMaterial({
      color: `rgb${rgb()}`,
      transparent: true,
      opacity: 8,
      side: THREE.DoubleSide,
      depthWrite: false
    });
    let cone = new THREE.Mesh(geometry, material);
    cone.rotateX(-Math.PI / 2);
    cone.position.set(...item);
    meshs.push(cone);
  });
  threeLayer.addMesh(meshs);
  return meshs;
}
```

rgb函数是一个获取随机rbg颜色函数

```javascript
export function rgb() { //rgb颜色随机
  let r = Math.floor(Math.random() * 256);
  let g = Math.floor(Math.random() * 256);
  let b = Math.floor(Math.random() * 256);
  let rgb = '(' + r + ',' + g + ',' + b + ')';
  return rgb;
}
```

此时我们看到场景中的效果是
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210306130742412.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70)

# 创建文本

最后再来创建一些基础的文本，使用精灵来创建

```javascript
export function loaderText(app, threeLayer, geojson = text) {
  geojson.features.forEach(item => {
    let coordinates = item.geometry.coordinates;
    let position = threeLayer.coordinateToXYZ(coordinates, 200);
    let name = item.properties.name;
    let element = `
                    <div class="sprite-canvas">
                        <span class="sprite-layer">${name}</span>
                    </div>`;
    app.addHtmlCanvas({
      parent: app.scene,
      position,
      element
    })
  })

}
```

addHtmlCanvas方法在上期已经贴出代码，通过html来生成canvas，然后在map使用就好
 此时的效果：
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210306131002154.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70)
 最后我们给整个场景添加一个高光的后期处理就ok了

```javascript
export function loaderBloom(threeLayer) {
  const params = {
    exposure: 1,
    bloomStrength: 1.5,
    bloomThreshold: 0,
    bloomRadius: 0,
    debug: false
  };
  const renderer = threeLayer.getThreeRenderer();
  const size = threeLayer.getMap().getSize();
  threeLayer.composer = new EffectComposer(renderer);
  threeLayer.composer.setSize(size.width, size.height);

  const scene = threeLayer.getScene(),
    camera = threeLayer.getCamera();
  threeLayer.renderPass = new RenderPass(scene, camera);

  threeLayer.composer.addPass(threeLayer.renderPass);

  const bloomPass = threeLayer.bloomPass = new UnrealBloomPass(new THREE.Vector2(size.width, size.height));
  bloomPass.renderToScreen = true;
  bloomPass.threshold = params.bloomThreshold;
  bloomPass.strength = params.bloomStrength;
  bloomPass.radius = params.bloomRadius;
  threeLayer.composer.addPass(bloomPass);
  threeLayer.bloomEnable = true;

  threeLayer.getRenderer().renderScene = function () {
    const layer = this.layer;
    layer._callbackBaseObjectAnimation();
    this._syncCamera();
    const renderer = this.context,
      camera = this.camera,
      scene = this.scene;
    if (
      layer.bloomEnable &&
      layer.composer &&
      layer.composer.passes.length > 1
    ) {
      layer.composer.render(0);
      renderer.clearDepth();
      camera.layers.set(0);
      renderer.render(scene, camera);
    }
    this.completeRender();
  };
}
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210306131147495.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70)
 ok, 此时我们的整个场景就比之前亮了，我们在替换一下数据就成视频中的效果了
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210306131341913.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70)