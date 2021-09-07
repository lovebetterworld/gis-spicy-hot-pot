- [Three.js 自定义创建点，线，面，Geometry，法线，UV坐标，顶点颜色](https://blog.csdn.net/qq_39503511/article/details/111108316)

# 概述

此章将介绍如何自定义创建点，线，面，Geometry，法线，UV坐标，顶点颜色。
 任何一个模型都是由一个一个顶点来组成的，然后由顶点来组成线和面来生成的，在Three.js中，我们使用new THREE.Vector3()来创建一个顶点。

# 顶点

现在我们来创建4个顶点，顶点坐标分别为(0, 0, 0)，(10, 0, 0)， (0, 0, 10)， (10, 0, 10)
 ![顶点坐标](https://img-blog.csdnimg.cn/20201213135933404.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70)

```javascript
    let p1 = new THREE.Vector3(0, 0, 0);
    let p2 = new THREE.Vector3(10, 0, 0);
    let p3 = new THREE.Vector3(0, 0, 10);
    let p4 = new THREE.Vector3(10, 0, 10);
```

创建Geometry, 并将顶点添加到Geometry的顶点数组vertices中

```javascript
	let geometry = new THREE.Geometry();
	// 顶点添加到Geometry的顶点数组vertices中
	geometry.vertices.push(p1, p2, p3, p4);
```

创建点模型对象

```javascript
	// 必须使用对应点的材质，size为点的大小
	let  material = new THREE.PointsMaterial( {color: 'red', size:2} );
	
    let  mesh = new THREE.Points( geometry, material );
    scene.add( mesh );
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201213140955558.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70)
 geometry中打印结果为，可以在此处看见添加的几个顶点数据
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20201213141042588.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70)

# 使用顶点来创建面

在webgl中，面都是由3个顶点来创建的每一个三角形，上面我们创建了4个顶点，这里我们将这4个顶点来创建一个两个面，并对每个面使用不同的材质

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201213141528807.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70)
 new THREE.Face3(0, 2, 1, new THREE.Vector3(), new THREE.Color(), 0)中的0， 2， 1三个值分别对应顶点数组中的索引，对应的分别是P1, P3,  P2三个点，此处创建顶点的时候需要使用逆时针的顺序，不然是看不见当前面的，具资料解释说是创建的面顺序会决定法线的方向，使用一下右手法则我们可以知道此处法线的方向是向上的，如果法线向下，那么我们的相机就需要在负Y轴才可以看到我们创建的face1, new THREE.Vector3()对应的是法线， new THREE.Color()对应的是面的颜色，0对应的是使用材质数组中的索引

```javascript
	let face1 = new THREE.Face3(0, 2, 1, new THREE.Vector3(), new THREE.Color(), 0);
    let face2 = new THREE.Face3(1, 2, 3, new THREE.Vector3(), new THREE.Color(), 1);
    // 将面添加到geometry的facess数组中
    geometry.faces.push(face1, face2);
	// 创建两个材质
	let material1 = new THREE.MeshBasicMaterial( {color: 'green'} );
    let material2 = new THREE.MeshBasicMaterial( {color: 'red'} );
	// face1使用第一个材质，face2使用第二个材质
    let mesh = new THREE.Mesh( geometry, [material1, material2] );
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201213141643502.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70)
 最终效果：
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20201213142429447.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70)
 打印结果为：
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20201213142603495.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70)

# 面使用顶点颜色渲染

此处我们将创建4中顶点颜色并在面的顶点颜色数组中添加对应的颜色

```javascript
	let color1 = new THREE.Color(0xFF0000);
    let color2 = new THREE.Color(0x00ff00);
    let color3 = new THREE.Color(0x0000ff);
    let color4 = new THREE.Color(0x00ffff);
    // 面添加顶点颜色，此面的材质颜色使用顶点渲染
    face1.vertexColors.push(color1, color2, color4);
```

修改材质1来使用顶点着色，只有选择使用顶点着色后vertexColors数组才会起作用

```javascript
	// vertexColors: THREE.VertexColors 使用顶点颜色进行插值渲染
    let material1 = new THREE.MeshBasicMaterial( {vertexColors: THREE.VertexColors} );
```

最终效果，可以看到face1为三个顶点的颜色插值来渲染的，face2保持原来的不变
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20201213143143315.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70)
 打印结果为
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20201213143321482.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70)

# 面使用面颜色渲染

在这之前，我们分别使用了材质的颜色来渲染面，顶点颜色来渲染面，此处还有一种，就是使用在定义面的时候new THREE.Color()来渲染

```javascript
    // new THREE.Color(0x00ff00) 将当前面的颜色给定义为红色
	let face1 = new THREE.Face3(0, 2, 1, new THREE.Vector3(), new THREE.Color(0x00ff00), 0);
	// 顶点颜色数组需要删除掉，不然还是会使用顶点颜色数组
	// face1.vertexColors.push(color1, color2, color4);
	// 将材质1的来使用面着色
	let material1 = new THREE.MeshBasicMaterial( {vertexColors: THREE.FaceColors} );
```

最终效果：
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20201213171619536.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70)

# 面添加法线

在创建的face3面中添加法线，没有法线的面是无法接收到光照的
 创建唯一的光源

```javascript
	const directionalLight = new THREE.DirectionalLight( '#fff' )
    directionalLight.position.set( 30, 30, 30 ).normalize()
    scene.add( directionalLight )
```

将face1添加new THREE.Vector3(0, 1, 0)方向的法线，face2添加new THREE.Vector3(0, -1, 0)方向的法线

```javascript
	// 点的顺序决定法线的方向
    let face1 = new THREE.Face3(0, 2, 1, new THREE.Vector3(0, 1, 0), new THREE.Color(), 0);
    let face2 = new THREE.Face3(1, 2, 3, new THREE.Vector3(0, -1, 0), new THREE.Color(), 1);
```

定义两个材质，MeshLambertMaterial材质可以接受光照

```javascript
	let material1 = new THREE.MeshLambertMaterial( {color: 'yellow'} );
    let material2 = new THREE.MeshLambertMaterial( {color: 'red'} );
```

最终效果：
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20201213172245447.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70)
 可以看到最后法线向上的显示了出颜色，法线向下的是黑色，不是显示红色

# 自定义UV贴图

先定义四个UV坐标，xy分别为0~1， 分别为p1和p4的4个顶点的坐标
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20201213172757219.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70)

```javascript
	let uv1 = new THREE.Vector2(0, 1);
    let uv2 = new THREE.Vector2(1, 1);
    let uv3 = new THREE.Vector2(0, 0);
    let uv4 = new THREE.Vector2(1, 0);
```

在geometry的faceVertexUvs数组中添加UV坐标

```javascript
	geometry.faceVertexUvs[0].push([uv1, uv3, uv2])
    geometry.faceVertexUvs[0].push([uv2, uv3, uv4])
```

定义贴图和材质

```javascript
	let loader = new THREE.TextureLoader();
    let texture = loader.load('ground.jpg');
    texture.wrapS = texture.wrapT = THREE.RepeatWrapping;
	let material1 = new THREE.MeshBasicMaterial( {map: texture} );
    let material2 = new THREE.MeshBasicMaterial( {map: texture} );
```

最终效果：
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20201213173104120.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70)
 打印结果为
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20201213173126402.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70)

[![img](https://profile.csdnimg.cn/F/D/5/3_qq_39503511)](https://blog.csdn.net/qq_39503511)