- [maptalks+three.js+vue webpack项目实现二维地图上贴三维模型](https://blog.csdn.net/liona_koukou/article/details/85231410)

最终效果如图：（地图上添加一个“三维地图”的toolbar按钮，点击后在二维地图上贴上建好的三维模型点击显示弹框）

![img](https://img-blog.csdnimg.cn/20181224115623874.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpb25hX2tvdWtvdQ==,size_16,color_FFFFFF,t_70)



以下都在已经引入并且初始化maptalks地图的基础上，如何引入使用maptalks可以查看博客https://blog.csdn.net/liona_koukou/article/details/84316065

1、安装maptalks.three包

npm install maptalks.three

2、安装three包

npm install three

3、安装obj-loader和mtl-loader包

npm i --save three-obj-mtl-loader

4、引入model模型文件到public下（放在这里是因为打包后读取路径问题，目前发现放在这里才能在打包后正确读取）

![img](https://img-blog.csdnimg.cn/20181224115751119.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpb25hX2tvdWtvdQ==,size_16,color_FFFFFF,t_70)

5、Vue页面代码

引入包

```js
import * as THREE from 'three'
import * as maptalks from 'maptalks'
import { ThreeLayer } from 'maptalks.three'
import { MTLLoader, OBJLoader } from 'three-obj-mtl-loader'
```

初始化的地图对象是

```
this.map
```

下面是渲染三维模型的方法

```js
// 渲染三维
draw3D() {
  const that = this
  // 三维地图
  var three_flag = false
  // ///单体化交互开始
  var INTERSECTED
  this.map.on('click', function(e) {
    //    console.log(e)
    var raycaster = new THREE.Raycaster()
    var mouse = new THREE.Vector2()
    const camera = threeLayer.getCamera()
    const scene = threeLayer.getScene()
    if (!scene) return

    const size = that.map.getSize()
    const width = size.width; const height = size.height
    mouse.x = (e.containerPoint.x / width) * 2 - 1
    mouse.y = -((e.containerPoint.y) / height) * 2 + 1

    raycaster.setFromCamera(mouse, camera)
    raycaster.linePrecision = 3

    var intersects = raycaster.intersectObjects(scene.children, true)
    // var intersects = raycaster.intersectObject(points);
    if (!intersects) return
    if (Array.isArray(intersects) && intersects.length === 0) return
    console.log(intersects)
    // 这里我们操作第一个相交的物体
    if (intersects.length > 0) {
      if (INTERSECTED != intersects[0].object) {
        if (INTERSECTED) {
          // INTERSECTED.material.color.setHex(INTERSECTED.currentHex);
          // INTERSECTED.scale.set(1,1,1);
          if (INTERSECTED.material.length === undefined) {
            INTERSECTED.material.color.setHex(INTERSECTED.currentHex)
          } else {
            for (var i = 0; i < INTERSECTED.material.length; i++) {
              INTERSECTED.material[i].color.setHex(INTERSECTED.currentHex)
            }
          }
        }
        INTERSECTED = intersects[0].object

        // 设置相交的第一个物体的颜色
        // INTERSECTED.currentHex = INTERSECTED.material[0].color.getHex();
        INTERSECTED.currentHex = 16777215
        // 将该物体设为随机的其他颜色
        // INTERSECTED.material.opacity = 0.2;

        // INTERSECTED.material.transparent = true;
        // INTERSECTED.material.opacity = 0.2;
        // INTERSECTED.material.needsUpdate = true;
        // INTERSECTED.material.transparent = false;

        // INTERSECTED.material.color.setHex(0xff0000);
        if (INTERSECTED.material.length === undefined) {
          INTERSECTED.material.color.setHex(0x1E90FF)
        } else {
          for (var i = 0; i < INTERSECTED.material.length; i++) {
            INTERSECTED.material[i].color.setHex(0x1E90FF)
          }
        }
      }
      // //
      var lonlat = e.coordinate
      if (true) {
        var options = {
          'autoOpenOn': 'null', // set to null if not to open window when clicking on map
          'single': true,
          'width': 410,
          'height': 190,
          'custom': true,
          'autoCloseOn': 'click',
          'dy': -316,
          'content': '<div class="content build-content">' +
            '<div class="pop-img"><img src="http://pde56fqkk.bkt.clouddn.com/1544760152593.jpg"/><p class="pop-name build-pop-name" id="viewDetial"><span class="text-ellipsis" title="浦软大厦">浦软大厦</span><a>详情<i class="el-icon-arrow-right"></i></a></p></div>' +
            '<div class="pop-txt"><ul><li>入驻企业：<span>12 家</span> </li><li>登记人员：<span>1000 人</span> </li><li>今日访客：<span>100 人</span> </li><li>登记车辆：<span>500 辆</span> </li><li>实时人数：<span>0 人</span> </li><li>监控点位：<span>0 个</span> </li><li>人脸门禁：<span>0 个</span> </li><li>消防设施：<span>0 个</span></li></ul></div>' +
            '</div>'
        }
        var infoWindow = new maptalks.ui.InfoWindow(options)
        infoWindow.addTo(that.map).show(lonlat)
      }
    } else {
      // 当射线离开的时候变为原来的颜色
      if (INTERSECTED) {
        // INTERSECTED.material.color.set(INTERSECTED.currentHex);
        if (INTERSECTED.material.length === undefined) {
          INTERSECTED.material.color.setHex(INTERSECTED.currentHex)
        } else {
          for (var i = 0; i < INTERSECTED.material.length; i++) {
            INTERSECTED.material[i].color.setHex(INTERSECTED.currentHex)
          }
          // INTERSECTED.scale.set(1,1,1);
        }
      }
      INTERSECTED = null
    }
    threeLayer.renderScene()
  })

  function closeBox() {
    var theClose = document.getElementById('close_id')
    var cont = document.getElementById('infow')
    cont.style.display = 'none'
  }

  // ///单体化交互结束
  // the ThreeLayer to draw buildings
  // //ThreeLayer初始化
  var threeLayer = new ThreeLayer('t_forbcmp', {
    forceRenderOnMoving: true,
    forceRenderOnRotating: true,
    animation: true
  })

  threeLayer.prepareToDraw = function(gl, scene, camera) {
    var me = this
    // var light = new THREE.PointLight(0xffffff);
    // camera.add(light);
    // let axes=new THREE.AxesHelper(200000000);
    // scene.add(axes);
    var light0 = new THREE.DirectionalLight('#ffffff', 0.5)
    light0.position.set(800, 800, 800).normalize()
    light0.castShadow = true
    camera.add(light0)
    // 环境光
    var light01 = new THREE.AmbientLight('#f7fdf9')
    light01.castShadow = true
    scene.add(light01)
    // var light1 = new THREE.DirectionalLight("#ffffff");
    // light1.position.set(-800,-800,800).normalize();
    // light1.castShadow = true;
    // camera.add(light1);

    // 测试加载obj和mtl贴图
    // addmtlLoaderTest(13.438186479666001,52.530305072175594);
    // addmtlLoaderTestforMTL(13.436186479666001,52.530305072175594);
    // 相对路径参数,
    var mtlPath = process.env.BASE_URL + 'model/obj/'
    var mtlName = '3d_puruan_new.mtl'
    var objPath = process.env.BASE_URL + 'model/obj/'
    var objName = '3d_puruan3.obj'
    var objlon = 121.60499979860407
    var objlat = 31.20150084741559
    addLoaderForObj(objlon, objlat, mtlPath, mtlName, objPath, objName)
  }

  threeLayer.addTo(that.map).hide()

  // 加载模型相关
  // 加载obj+mtl
  function addLoaderForObj(lon, lat, mtlPath, mtlName, objPath, objName) {
    const me = threeLayer
    const scene = me.getScene()
    const scale = -0.0007
    var mtlLoader = new MTLLoader()
    // 加载贴图mtl
    mtlLoader.setPath(mtlPath)
    mtlLoader.load(mtlName, function(materials) {
      materials.preload()
      var objLoader = new OBJLoader()
      objLoader.setMaterials(materials)
      // 加载模型obj  Math.PI*3/2
      objLoader.setPath(objPath)
      objLoader.load(objName, function(object) {
        object.traverse(function(child) {
          if (child instanceof THREE.Mesh) {
            child.scale.set(scale, scale, scale)
            child.rotation.set(-Math.PI / 2, Math.PI, 0)
            // 赋予基础材质的颜色,无色（0xFFFFFF）调试色0x0000FF
            for (var i = 0; i < child.material.length; i++) {
              child.material[i].color.setHex(0x0000FF)
            }
          }
        })

        var v = threeLayer.coordinateToVector3(new maptalks.Coordinate(lon, lat))
        object.position.set(v.x, v.y, 0)
        scene.add(object)
        mtlLoaded = true
        threeLayer.renderScene()
      })
      // var mm = new THREE.MeshPhongMaterial({color:0xFF0000});
      // objLoader.setMaterials( mm );
      // objLoader.setMaterials(materials);
    })
  }
  var toolbar = new maptalks.control.Toolbar({
    position: { 'right': 40, 'bottom': 40 },
    items: [
      {
        item: '二三维图层切换',
        click: function() {
          if (three_flag === false) {
            that.map.animateTo({
              center: [121.6050804009, 31.2015354151],
              zoom: 18,
              pitch: 45
            }, {
              duration: 2000
            })
            threeLayer.show()
            three_flag = true
          } else {
            that.map.animateTo({
              center: [121.6050804009, 31.2015354151],
              zoom: 18,
              pitch: 0
            }, {
              duration: 2000
            })
            threeLayer.hide()
            three_flag = false
          }
          console.log('obj模型')
        }
      }
    ]
  }).addTo(this.map)
}
```

上面这段代码需要注意的是模型数据文件的读取路径

```js
// 相对路径参数,
var mtlPath = process.env.BASE_URL + 'model/obj/'
var mtlName = '3d_puruan_new.mtl'
var objPath = process.env.BASE_URL + 'model/obj/'
var objName = '3d_puruan3.obj'
```

关于process.env.BASE_URL的值可以在vue.config.js里自定义设置（cli3.0）

```js
baseUrl: process.env.NODE_ENV === 'production' ? '/bcmp-web/' : '/',
```

