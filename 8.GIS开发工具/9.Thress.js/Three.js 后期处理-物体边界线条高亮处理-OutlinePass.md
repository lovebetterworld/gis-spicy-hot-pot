- [Three.js 后期处理-物体边界线条高亮处理-OutlinePass](https://blog.csdn.net/qq_39503511/article/details/111031800)

# 概述

本文介绍如何使用three.js的后期处理来制作物体边界线条高亮处理，先来看效果图
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20201211111939157.gif#pic_center)

# 步骤

1. 添加相应的后期处理js，对应的js在three的github中全部可以获取到

```javascript
<!-- 后期处理js -->
<!-- EffectComposer（效果组合器）对象 -->
<script src="js/postprocessing/EffectComposer.js"></script>
<!-- RenderPass/该通道在指定的场景和相机的基础上渲染出一个新场景 -->
<script src="js/postprocessing/RenderPass.js"></script>
<!-- ShaderPass/使用该通道你可以传入一个自定义的着色器，用来生成高级的、自定义的后期处理通道 -->
<script src="js/postprocessing/ShaderPass.js"></script>
<!-- 传入了CopyShader着色器，用于拷贝渲染结果 -->
<script src="js/shaders/CopyShader.js"></script>
<script src="js/postprocessing/OutlinePass.js"></script>
```

1. 创建两个box， 用来对比效果

```javascript
  var geometry1 = new THREE.BoxGeometry(4, 4, 4);
  var material1 = new THREE.MeshBasicMaterial({
    map: texture
  });
  var cube1 = new THREE.Mesh(geometry1, material1);
  cube1.position.set(10, 0, 0)
  scene.add(cube1);

  var geometry2 = new THREE.BoxGeometry(4, 4, 4);
  var material2 = new THREE.MeshBasicMaterial({
    map: texture
  });
  var cube2 = new THREE.Mesh(geometry2, material2);
  scene.add(cube2);
```

1. 加入通道

```javascript
  // RenderPass这个通道会渲染场景，但不会将渲染结果输出到屏幕上
  const renderScene = new THREE.RenderPass(scene, camera)
  // THREE.OutlinePass(resolution, scene, camera, selectedObjects)
  // resolution 分辨率
  // scene 场景
  // camera 相机
  // selectedObjects 需要选中的物体对象, 传入需要边界线进行高亮处理的对象
  const outlinePass = new THREE.OutlinePass(new THREE.Vector2(el.offsetWidth, el.offsetHeight), scene, camera, [cube2]);
  console.log(outlinePass);
  outlinePass.renderToScreen = true;
  outlinePass.edgeStrength = 3 //粗
  outlinePass.edgeGlow = 2 //发光
  outlinePass.edgeThickness = 2 //光晕粗
  outlinePass.pulsePeriod = 1 //闪烁
  outlinePass.usePatternTexture = false //是否使用贴图
  outlinePass.visibleEdgeColor.set('yellow'); // 设置显示的颜色
  outlinePass.hiddenEdgeColor.set('white'); // 设置隐藏的颜色

  //创建效果组合器对象，可以在该对象上添加后期处理通道，通过配置该对象，使它可以渲染我们的场景，并应用额外的后期处理步骤，在render循环中，使用EffectComposer渲染场景、应用通道，并输出结果。
  const bloomComposer = new THREE.EffectComposer(renderer)
  bloomComposer.setSize(el.offsetWidth, el.offsetHeight);
  bloomComposer.addPass(renderScene);
  // 眩光通道bloomPass插入到composer
  bloomComposer.addPass(outlinePass)
  bloomComposer.render()
```

1. 在调用requestAnimationFrame的函数中调用

```javascript
    bloomComposer.render()
```