- [Three.js 定义材质](https://blog.csdn.net/qq_39503511/article/details/111105046)

# 概述

Three.js中Mesh()的第二个参数material可以是一个数组，所以我们就能给网格模型定义多个材质，效果：
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20201213131817923.gif#pic_center)
 我们可以在效果图中看到，这个box网格模型总共使用了三种材质，分别为颜色贴图的基础网格材质，黄色的基础网格材质，红色的基础网格材质

# 步骤

1. 创建多个材质

```javascript
let loader = new THREE.TextureLoader();
let texture = loader.load('ground.jpg')
let material1 = new THREE.MeshBasicMaterial( {map: texture} );
let material2 = new THREE.MeshBasicMaterial( {color: 'red'} );
let material3 = new THREE.MeshBasicMaterial( {color: 'yellow'} );
```

1. 创建网格模型

```javascript
let geometry = new THREE.BoxGeometry( 20, 20, 20 );
let materials = []
for (let i = 0; i < geometry.faces.length / 2; i+=3) {
    materials.push(material1, material2, material3)
}
let cube = new THREE.Mesh( geometry, materials );
```

在控制台打印出网格模型cube可以看到每一个都应用到了不同的材质索引
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20201213133414187.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70)

[![img](https://profile.csdnimg.cn/F/D/5/3_qq_39503511)](https://blog.csdn.net/qq_39503511)