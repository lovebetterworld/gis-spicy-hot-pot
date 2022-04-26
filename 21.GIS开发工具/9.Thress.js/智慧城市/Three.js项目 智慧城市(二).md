- [Three.js项目 智慧城市(二)](https://blog.csdn.net/qq_39503511/article/details/112708224)

# 加载模型

1. 在ZThree类中加入loaderObjModel方法用来加载模型

```javascript
// 加载obj模型
  loaderObjModel(path, objName, mtlName) {
    return new Promise(resolve => {
      new MTLLoader()
        .setPath(path)
        .load(mtlName + '.mtl', function (materials) {
          console.log(materials)
          materials.preload();

          // 加载obj
          new OBJLoader()
            .setPath(path)
            .setMaterials(materials)
            .load(objName + '.obj', function (object) {
              resolve(object)
            });
        });
    })
  }
```

1. 在vue文件中调用此方法
    模型是我随便在网上找的，各位可以随意在网上找一个obj模型来测试即可

```javascript
	cityModel = await app.loaderObjModel(
        "model/city/",
        "CityIslands",
        "City_Islands"
      );

      scene.add(cityModel);
```

此时我们可以在页面上看到的效果是
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210116150230531.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70)
  此时有些小伙伴可能会比较奇怪的是为什么初始化进来时看不到模型或是只能看到模型的一小部分，那是你的相机设置的位置不对，教给大家一个小技巧，我们把app对象给挂载到window对象上，然后我们在调整控制器到视角最好的位置，此时打开控制台，输入app.camera.position和app.controls.target
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210116150939717.png)
 此时我们就可以看到对应的参数，然后我们在设置一下就ok了

```javascript
camera.position.set(18, 364, 397);
controls.target = new THREE.Vector3(2, 44, -32);
```

模型下载链接：https://download.csdn.net/download/qq_39503511/20044899
 此时看到的应该就和上面的效果图是一样的了

# 创建天空盒

1. 在ZThree类中加入loaderSky方法用来加载模型

```javascript
// 加载天空盒
  loaderSky(path) {
    let skyTexture = new THREE.CubeTextureLoader()
      .setPath(path)
      .load([
        "px.jpg", //右
        "nx.jpg", //左
        "py.jpg", //上
        "ny.jpg", //下
        "pz.jpg", //前
        "nz.jpg" //后
      ]);

    this.scene.background = skyTexture;
    this.renderer.setClearAlpha(1);
  }
```

1. 在vue文件中调用此方法

```javascript
app.loaderSky('texture/sky/');
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210116151904508.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70)
 此时我们就已经成功的创建了天空盒，天空盒图片素材命名规则
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210116152314967.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70)