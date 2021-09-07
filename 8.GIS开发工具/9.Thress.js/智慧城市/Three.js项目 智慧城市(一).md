- [Three.js项目 智慧城市(一)](https://blog.csdn.net/qq_39503511/article/details/112707047)

# 概述

在网上苦苦找寻很久都很难找到一篇详细讲解使用Three.js开发智慧城市的文章，为此专门做一个智慧城市得项目，先来看看效果

<iframe id="fnu7rGCl-1611038633488" src="https://live.csdn.net/v/embed/146201" allowfullscreen="true" data-mediaembed="csdn"></iframe>

智慧城市项目录制视频



科技风版本：

<iframe id="y0NrlQj0-1611557606893" src="https://live.csdn.net/v/embed/147068" allowfullscreen="true" data-mediaembed="csdn"></iframe>

智慧城市二期视频



# 搭建开发环境

使用的开发框架是vue-cli3.0，报表使用echarts, webgl使用three.js，开发工具为vscode
 搭建完成后的目录为
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210116144436528.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70)

# 搭建three场景

1. 创建一个class，用来初始化场景，渲染器，相机，灯光，控制器

```javascript
import * as THREE from 'three'
import {
  OrbitControls
} from 'three/examples/jsm/controls/OrbitControls.js';
import {
  OBJLoader
} from 'three/examples/jsm/loaders/OBJLoader';
import {
  MTLLoader
} from 'three/examples/jsm/loaders/MTLLoader';

export default class ZThree {
  constructor(id) {
    this.id = id;
    this.el = document.getElementById(id);
  }

  // 初始化场景
  initThree() {
    let _this = this;
    let width = this.el.offsetWidth;
    let height = this.el.offsetHeight;
    this.scene = new THREE.Scene();
    this.camera = new THREE.PerspectiveCamera(45, width / height, 1, 3000)
    this.renderer = new THREE.WebGLRenderer({
      antialias: true,
      alpha: true
    })
    this.renderer.setPixelRatio(window.devicePixelRatio)
    this.renderer.setSize(width, height)
    this.el.append(this.renderer.domElement)
    this.renderer.setClearColor('#000')

    window.addEventListener('resize', function () {
      _this.camera.aspect = _this.el.offsetWidth / _this.el.offsetWidth;
      _this.camera.updateProjectionMatrix();
      _this.renderer.setSize(_this.el.offsetWidth, _this.el.offsetWidth);
    }, false)
  }

  // 初始化helper
  initHelper() {
    this.scene.add(new THREE.AxesHelper(100))
  }

  // 初始化控制器
  initOrbitControls() {
    let controls = new OrbitControls(this.camera, this.renderer.domElement)
    controls.enableDamping = true
    controls.enableZoom = true
    controls.autoRotate = false
    controls.autoRotateSpeed = 0.3
    controls.enablePan = true
    this.controls = controls
  }

  initLight() {
    let directionalLight = new THREE.DirectionalLight('#fff')
    directionalLight.position.set(30, 30, 30).normalize()
    this.scene.add(directionalLight)
    let ambientLight = new THREE.AmbientLight('#fff', 0.3)
    this.scene.add(ambientLight)
    return {
      directionalLight,
      ambientLight
    }
  }
}
```

1. 在vue文件中调用此类初始化three

```javascript
<template>
  <div id="box" class="container"></div>
</template>

<script>
import ZThree from "@/three/ZThree";
import * as THREE from "three";

let app, camera, scene, renderer, controls, clock, cityModel;

export default {
  name: "Home",
  components: {},
  methods: {
    async initZThree() {
      app = new ZThree("box");
      app.initThree();
      app.initHelper();
      app.initOrbitControls();
      app.initLight();
      window.app = app;
      camera = app.camera;
      scene = app.scene;
      renderer = app.renderer;
      controls = app.controls;
      clock = new THREE.Clock();
      camera.position.set(30, 30, 30);
    },
  },
  mounted() {
    this.initZThree();
  },
};
</script>

<style lang='less' scoped>
.container {
  width: 100%;
  height: 100%;
  overflow: hidden;
  background-color: #000;
}
</style>
```

此时我们可以看到的场景是，如果能够看到坐标轴辅助线，代表我们的场景已经加载成功
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210116145417357.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70)