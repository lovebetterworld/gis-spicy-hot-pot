# 打造服务B端客户的酷炫3D地图可视化产品

原文地址：https://juejin.cn/post/6860376270102855687

## 背景

B 端市场中大量客户项目有很强的地理信息可视化需求，奇安信集团服务的党政军企客户的安全业务场景也不例外，地图可视化已经成为客户业务的必选项。从 2015 年至今，客户对于地图可视化的要求也从朴素的静态 2D 地图升级为酷炫的动态 3D 地图。同时由于奇安信集团服务的客户群体特殊性，要求如：地图数据源必须符合国标且支持服务完整离线部署、提交源代码接受审查、建筑模型定制化等，让我们不得不选择进行自研，进而构建满足奇安信集团客户需求的地图可视化产品。经过 5 年多在客户业务场景中的迭代发展，我们也收获了很多宝贵的经验与成果，今天我们选择将其中可公开的部分整理成系列文章与各位同仁分享，希望能够帮助到有需要的人，同时也欢迎大牛们、砖家们随时指正。

## 分享计划

1. 《打造服务 B 端客户的酷炫 3D 地图可视化产品》即本文，将会介绍地图引擎架构相关的内容，包括引擎架构分层、相关实现技术以及部分效果等。
2. 《数据源与存储计算》将会科普瓦片金字塔、GeoJSON、使用 WebWorker 和 WebAssembly 加速数据计算、使用 IndexDB 做持久化缓存以及 LRU 做内存缓存等。
3. 《地图交互与姿态控制》将揭秘地图相机的的平移、旋转，视窗范围的瓦片渲染和天空对边界的优化。
4. 《文字渲染》将会讨论多种文字渲染方案以及文字的碰撞检测等实践。
5. 《建筑渲染》会分享我们在做动态建筑渲染遇到的问题，如 Geometry 的生成、合并、Shader 动画以及拾取等。
6. 《地图建筑建模制作与输出》是一篇有艺术色彩的分享。除了矢量数据中的朴素建筑形态，当需要精细建筑模型时就需要设计师出马了。该篇将会描述设计师的建模和使用过程。
7. 《地理数据可视化》将介绍数据可视化图表分类、业务中适用的场景及其难点。
8. 《酷炫效果与原理揭秘》是末篇，将会分享多种酷炫效果的着色器代码实现。

接下来，我们开始第一篇正文：《打造服务 B 端客户的酷炫 3D 地图可视化产品》。

## 打造服务 B 端客户的酷炫 3D 地图可视化产品

![img](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/ce7dd26f57ab4f309f6d321bce1f92d4~tplv-k3u1fbpfcp-zoom-1.image)

奇安信雷尔3D地图可视化效果图

奇安信雷尔地图可视化引擎从 2015 年至今，经过多次迭代，由最初简单的 GeoJSON 地图演化到现在基于 Unity 3D 和 WebGL 研发的动态瓦片 3D 地图。

![img](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/ce5a6aa7c2a74b489dd869ef22839232~tplv-k3u1fbpfcp-zoom-1.image)

### 雷尔地图引擎迭代时间轴

在迭代演化的过程中，逐步诞生了约束可视化设计和使用的规范，以及从竞品中归纳和创新的迭代模式，这些都成为现在地图引擎的基石。在使用过程中，又衍生出了新的帮助用户使用的工具和平台，如主题编辑器、数据样式编辑器以及数据服务，这些构成了整个地图产品家族。

![img](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/cb8749b68d26467c8a2617e1b236b48a~tplv-k3u1fbpfcp-zoom-1.image)

### 地图可视化产品家族

3D 地图可视化引擎是整个产品的核心。依据对开源 3D 地图可视化库源码的阅读理解，并伴随着实现过程中不断的优化和调整，最终落地的架构如下：

![img](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/23e6ab7309e3446c99b9f873a9a80879~tplv-k3u1fbpfcp-zoom-1.image)

### 3D 地图可视化引擎架构

接下来我们将逐层对3D地图的核心架构进行说明。

### 数据接入层

负责地图图层和可视化图层的原始数据资源管理。考虑到数据的保密性和传输速度，矢量数据采用二进制数据的形式，前后端约定好瓦片切割规则，以及数据格式和字节数，前端进行解码；对于可视化图层来说，这层的主要功能是将数据置入可视化图层，等待下一层的进一步处理。

```js
// 瓦片图层数据接入原理
frustum = getCameraFrustum(camera)
bounds = getBoundsOfIntersection (frustum, mapPlane)
tileIds = getTileIds(bounds)

for (i = 0; i < tileIds.length; i++) {
  tileData = indexDBInstance.get(tileIds[i])

  if (tileData) {
    processTileData(tileData)
  } else {
    fetch(tileIds[i])
    .then(res => res.arrayBuffer())
    .then(arrayBuffer => {
      tileData = parser(arrayBuffer)
      indexDBInstance.set(tileIds[i], tileData)
      processData(tileData)
    })
    .catch(e => {
      // do something
    })
  }
}
```

### 数据处理层

负责对数据接入层输入的原始数据进行进一步的处理。对于地图图层矢量瓦片数据，数据处理层是按照给定的矢量二进制瓦片数据格式标准解析出其中包含的点、线、面以及文本等信息，并使用一系列的技术，比如 LRU、IndexedDB 等进行缓存，使用 WebWorker、WebAssembly 加速数据解析，以提升性能；对于可视化图层，数据处理层对输入的数据进行正确性校验、渲染样式的合并等。

![img](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/e899506b06de46f3b14cc15e39dd4f5b~tplv-k3u1fbpfcp-zoom-1.image)

数据解析前与解析后对比

![img](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/010affd4f92041dfb483e97dd7902780~tplv-k3u1fbpfcp-zoom-1.image)

WebAssembly与JS解析速率对比

### 数据模型层

负责对数据输入层输入的数据进行建模，输出点、线、面、文本等给渲染层。数据模型层将经纬度坐标映射为 WebGL 世界中的墨卡托投影坐标，并对面数据进行网格划分；为了提升性能，对某些面进行合并，进一步抽象为建筑，路面，水面等；在可视化图层中，为了对数据进行分析，数据模型层还负责对数据进行建模，比如对数据进行聚合、分箱等。

```js
// 使用VectorLayer渲染kmeans点聚合数据
for (i =0; i < inputData.length; i++) {
  inputData[i].coord = lnglat2WebMercator(inputData[i].lnglat)
}

kmeansData = kmeans(inputData)
vectorLayer.setData(kmeansData)

// 使用VectorLayer渲染dbscan点聚合数据
dbscanData = dbscan(inputData)
vectorLayer.setData(dbscanData)
```

### 渲染层

负责对数据模型层输入的点、线、面、文本等数据进行绘制，最终输出的结果就是顶点、线、网格。地图图层将数据模型层输入的建筑、路面、水面等数据，根据给定的地图样式描述文件渲染为地图底图；可视化图层将点、线、面、文字等抽象之后，在GeoJSON的Feature中描述该 Feature的样式，输入到可视化图层，就能够渲染出大部分的可视化图层；对于 Heatmap 等图层，还需要在渲染层进行进一步的处理。

```js
// Feature 生成过程：
pointFeatures = []

for (i = 0; i < geojson.features.length; i++) {
  feature = geojson.features[i]

  switch feature.type: {
     case 'LineString':
        featureMesh = new LineString(feature, layerStyle) 
        break
     case 'MultiLineString':
        featureMesh = new MultiLineString(feature, layerStyle)
        break
     case 'Polygon':
        featureMesh = new Polygon(feature, layerStyle)
        break
     case 'MultiPolygon':
        featureMesh = new MultiPolygon(feature, layerStyle)
        break
     case 'Point':
        pointFeatures.push(feature)
  }

  if (featureMesh) {
      scene.add(featureMesh)
  }
}

// 点特殊处理，由点云生成
if (pointFeatures.length) { 
  featureMesh = new Point(pointFeatures, layerStyle)
  scene.add(featureMesh)
}
```

### 交互层

负责对用户的设备输入进行处理，对地图进行操作。在 3D 地图及可视化图层中，用户要进行的操作主要有对地图的平移、旋转、缩放和对图形的拾取，这些操作都是建立在用户设备的基础上，比如鼠标的 click、wheel、mousemove 等，还需要对这些基础操作进行区分、合并，进一步抽象为地图的 drag、zoom 等事件，然后对地图的参数进行设置、合并，达到控制地图姿态的目的；对图形元素的拾取区分为 CPU 拾取和 GPU 拾取两种类型，这两种拾取方式有各自不同的适用场景。

```js
// 鼠标事件分发
dom.on(eventName, function(…args) {
   map.emit(eventName, …args)
})

map.on(eventName,function(…args) {
  layers.forEach(function(layer) {
    layer.emit(eventName, …args)
  })
})

layer.on(eventName, function() {
  // do something
})
```

![img](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/c1cc80e93d15461fa5b8a6ae0cebd6b0~tplv-k3u1fbpfcp-zoom-1.image)

GPU拾取原理

```js
// GPU 拾取原理
id = genPickingId() //生成拾取的 id
obj3d = new Mesh(geometry, material({color: id}))
scene.add(obj3d)
renderer.render(scene, camera, renderTarget)
renderer.readRenderTargetPixels(renderTarget, x, y, 1, 1, pixelBuffer) 

// 将鼠标 x, y 位置的像素色值读取到 pixelBuffer
if (pixelBuffer[3] === 255) {
   pickingId = unpackId(pixelBuffer) // 将色值转换为拾取的 id
}
```

### 业务逻辑层

负责对用户业务目标进行处理。业务逻辑层主要是回调函数，在用户通过交互层设置了动画或者进行了拾取等操作之后，会对用户的业务数据产生怎样的效果，需要用户通过回调函数进行设定。

```js
layer = new VectorLayer()
layer.setData(pointsData)

layer.on('click', feature => {
  if (feature) { // 拾取到了图形元素
    feature.setStyle({
      stroke: {
        color: '#FF0000',
        opacity: 0.8
      }
    })
    // do something
  }
})
```

### 时间线

时间线是一个贯穿各个层的时钟，为了统一实例中所有元素的时间，方便在各个层做处理的时候使用时间属性做动画。


