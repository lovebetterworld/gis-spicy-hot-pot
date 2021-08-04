# 版本依赖

1. [ThreeJS](https://threejs.org/) 0.87.0 
2. [Cesium](https://cesiumjs.org/) 1.61.0 

# 集成原理

无论是Cesium还是ThreeJS都是基于WebGL渲染意味这两者的空间坐标是相对一致的，加之GIS系统核心在于GPS坐标数据与笛卡尔坐标系的对应关系，在三维空间上这个关系是无论对Cesium还是ThreeJS都是一致的只需要对其进行一层解析就可以了。同时两者的渲染管线一致所以很多WebGL的原生封装两者是可以直接共用的。

集成上面最核心的部分就是将两个渲染引擎的渲染帧给同步，方式是将ThreeJS的帧生成函数与Cesium在同一帧调用完成，方式如下所示：

## 1、分别创建Cesium视图与ThreeJS视图

```javascript
var cesiumContainer = document.getElementById("cesiumContainer");
var ThreeContainer = document.getElementById("ThreeContainer");
//创建Cesium视图
var cesium = {}
cesium.viewer = new Cesium.Viewer(cesiumContainer, {}）；
//创建Three视图
var three = {}；
three.scene = new THREE.Scene();
three.camera = new THREE.PerspectiveCamera(fov, aspect, near, far);
three.renderer = new THREE.WebGLRenderer({
  alpha: true,
  logarithmicDepthBuffer:true
});
ThreeContainer.appendChild(three.renderer.domElement)；
```

## 2、将Cesium的渲染帧给禁用调用

```javascript
viewer.useDefaultRenderLoop = false
```

## 3、同步两者的相机，由于用户直接的操作的是Cesium所以最终要求将ThreeJS的相机同步到Cesium上,每一帧更新。

```javascript
//将Cesium的摄像头视场同步至THREE
three.camera.fov = Cesium.Math.toDegrees(cesium.viewer.camera.frustum.fovy);
//更新摄像头投影矩阵
three.camera.updateProjectionMatrix();
//关闭摄像头自动更新
three.camera.matrixAutoUpdate = false;
//获取Cesium相机矩阵
var cvm = cesium.viewer.camera.viewMatrix;
//获取Cesium相机逆矩阵
var civm = cesium.viewer.camera.inverseViewMatrix;
//设置three的世界坐标矩阵
three.camera.matrixWorld.set(
   civm[0], civm[4], civm[8], civm[12],
   civm[1], civm[5], civm[9], civm[13],
   civm[2], civm[6], civm[10], civm[14],
   civm[3], civm[7], civm[11], civm[15]
);
three.camera.matrixWorldInverse.set(
   cvm[0], cvm[4], cvm[8], cvm[12],
   cvm[1], cvm[5], cvm[9], cvm[13],
   cvm[2], cvm[6], cvm[10], cvm[14],
   cvm[3], cvm[7], cvm[11], cvm[15]
);
//重置视角
three.camera.lookAt(new THREE.Vector3(0, 0, 0));
```

## 4、同步ThreeJS的三维物体，每一帧都需要更新

```javascript
//_3DOBS是一个数组，数组之中的每一个元素都包含一个three的Object3D、经度、维度三项数据。
for (var id in _3DOBS) {
    //获取经纬度
    var LnL = [_3DOBS[id].longitude, _3DOBS[id].dimension];
    //获取经纬度原点坐标
    var center = Cesium.Cartesian3.fromDegrees(LnL[0], LnL[1]);
    //获取经纬度原点坐标向上一个单位的坐标
    var centerHigh = Cesium.Cartesian3.fromDegrees(LnL[0], LnL[1], 1);
    //重置模型位置
    _3DOBS[id].Group.position.copy(center);
    //重置模型方向
    _3DOBS[id].Group.lookAt(centerHigh);
}
//还有一步操作，因为Cesium是y轴向上所以需要将three的Object3D对象在X轴方向翻转90度。
```

## 5、同步两个渲染器的渲染

```javascript
three.Render = () => {
    //这里的this是three对象
    requestAnimationFrame(this.Render);
    //渲染cesium
    渲染cesium.viewer.render();
    //渲染three
    var width = ThreeContainer.clientWidth;
    var height = ThreeContainer.clientHeight;
    var aspect = width / height;
    this.camera.aspect = aspect;
    this.camera.updateProjectionMatrix();
    this.renderer.setSize(width, height);
    this.renderer.render(this.scene, this.camera);
}
```

最后将两者对应的dom对象重叠在一起，Three在上层，Cesium在下层，将Three的事件捕捉禁用，启用背景透明。这些步骤之后两个渲染器基本上就可以协同工作了，后续可以自行对两个渲染器进行封装，然后分别实现各自的功能。

# 特性

## 1、完整的ThreeJS功能

![img](https://www.tangyuecan.com/wp-content/uploads/2019/09/three.jpg)

**ThreeJS场景下导入的基于PBR渲染的GLTF模型**

在渲染器的基础之上没有对THREE做任何修改，所以ThreeJS上拥有的特性全部可以无缝应用在这个项目之中，无论是粒子、动画、物理学模拟等等。由于这个特性存在，无论什么大场景的三维可视化、GIS系统或者是一些大型工程的BIM都可以轻松实现，至少在地图上已经赢了。即便是对ThreeJS的操作事件其实可以通过下层Cesium透传回来。

## 2、各种地图瓦片数据对接

![img](https://www.tangyuecan.com/wp-content/uploads/2019/09/baidu.jpg)

**高德瓦片集成效果**

目前我所知道的，无论是谷歌、高德、百度、腾讯还是其他乱七八糟的地图都是采用瓦片数据对整个地球进行分割虽然各家的瓦片完全不一样，但是格式是完全一样的，这就意味着他们是通用的，而且Cesium可以对接这些数据。

瓦片数据上我大概知道的有：

高德卫星：http://webst02.is.autonavi.com/appmaptile?style=6&x={x}&y={y}&z={z}

百度卫星：http://shangetu1.map.bdimg.com/it/u=x={x};y={y};z={z};v=009;type=sate&fm=46

谷歌卫星：http://www.google.cn/maps/vt?lyrs=m&gl=CN&x={x}&y={y}&z={z}

OMS地图：https://c.tile.openstreetmap.org/{z}/{x}/{y}.png

大概试了一下谷歌地图不但没有被墙而且访问速度还非常的快，整体无论是精度还是数据量都远远超过国产地图，妈的，主场优势的BAT简直丢脸。

## 3、地形DEM数据可视化

![img](https://www.tangyuecan.com/wp-content/uploads/2019/09/hight.jpg)

**这个效果无敌了**

这个虽然看起来比较科幻，但是人家谷歌在多年前就已经有了，那就是将DEM数据在浏览器地图之中展示。不得不说这个还是效果还是NB的，但是人家谷歌使用的高度贴图，Cesium其实有点悲剧没有办法直接使用谷歌的高度贴图（至少我没有找到，谁知道可以给我说一下），所以就退而求其次使用第三方的DEM数据，比较痛苦的是Cesium官方其实是有一套全球14级的DEM数据的基本上开箱即用，但是国内访问速度太慢了，所以要不然就自己按照其规则去下载DEM数据然后自己搭建，我看了一下CSDN上有一个老哥搞了一个教程可以学习一波地址是：[点击跳转](https://blog.csdn.net/u013821237/article/details/82999006)，但是比较伤的是数据转换之后太大了服务器带宽不够所以我还是去找了一下国内速度比较快的最终还真就找到了一个全中国14级DEM，速度飞快：

https://lab.earthsdk.com/terrain/577fd5b0ac1f11e99dbd8fd044883638

最终的效果就是上图的样子了

## 4、CZML数据文件封装

![img](https://www.tangyuecan.com/wp-content/uploads/2019/09/data-1024x722.jpg)

**官网的卫星数据可视化Demo效果**

这个东西我还没有完全搞懂，但是意思是非常清楚的，基本意味着GIS上能够用得上的所有数据呈现都有一个特定格式进行封装，包含了动画、路径、图标等等，我大概在官方Demo上看了一会，目前只能看看没有办法直接开始写但是东西就是这个东西，后续必须要学习一下，非常的震撼。

# 已知问题

1、目前的三维坐标转换函数只能在球面地图上良好的转换，平面上不行，主要是经纬度解析会GG。

![img](https://www.tangyuecan.com/wp-content/uploads/2019/09/plan-1024x409.jpg)

**不是二维，是平面！**

2、ThreeJS在0.87之后所有版本不知道为什么无法正常转换坐标，目前只能用0.87也将就一下了。