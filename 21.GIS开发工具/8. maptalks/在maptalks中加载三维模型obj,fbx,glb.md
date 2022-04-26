- [在maptalks中加载三维模型obj,fbx,glb](https://www.cnblogs.com/googlegis/p/13963519.html)



maptalks 是一个基于WebGL的三维地图js库，基于maptalks可以快速建立web三维地图，加载各种地图数据，生成对应的图层，加载三维模型等。

![img](https://img2020.cnblogs.com/blog/59231/202011/59231-20201112133059347-1572814023.png)

-  地图加载。maptalks支持标准的地图数据类型，如GeoJson，TileServer等。

　　　　**GeoJson**格式是一种地理信息对象描述文件，可以是本地的，也可以存储在远程服务器上，其基本格式如下：

```json
{
    "type": "FeatureCollection",
    "name": "line0706",
    "crs": { "type": "name", "properties": { "name": "urn:ogc:def:crs:OGC:1.3:CRS84" } },
    "features": [
        { "type": "Feature", "properties": { "id": 26, "OID": 26, "PID": "1JS2036-1JS2037", "Shape_Length": 215.78135367381537, "linegj": 400.0, "linecz": "球墨铸铁" }, "geometry": { "type": "LineString", "coordinates": [ [ 117.139587450494673, 31.980963606892612 ], [ 117.141572764515146, 31.980002698897021 ] ] } },
        { "type": "Feature", "properties": { "id": 27, "OID": 27, "PID": "1JS2037-1JS2038", "Shape_Length": 174.33523286131555, "linegj": 400.0, "linecz": "球墨铸铁" }, "geometry": { "type": "LineString", "coordinates": [ [ 117.141572764515146, 31.980002698897021 ], [ 117.143128167657636, 31.979157606398935 ] ] } },
        { "type": "Feature", "properties": { "id": 28, "OID": 28, "PID": "1JS2038-AJS2720", "Shape_Length": 74.157593232456321, "linegj": 400.0, "linecz": "球墨铸铁" }, "geometry": { "type": "LineString", "coordinates": [ [ 117.143128167657636, 31.979157606398935 ], [ 117.143830270406454, 31.978859076104776 ] ] } },
        { "type": "Feature", "properties": { "id": 29, "OID": 29, "PID": "1JS2039-DJS504", "Shape_Length": 116.76683212772929, "linegj": 400.0, "linecz": "球墨铸铁" }, "geometry": { "type": "LineString", "coordinates": [ [ 117.146490176708213, 31.977233403153686 ], [ 117.147518501281553, 31.9766498062083 ] ] } },
        { "type": "Feature", "properties": { "id": 30, "OID": 30, "PID": "1JS2040-1JS2041", "Shape_Length": 346.5596390599348, "linegj": 400.0, "linecz": "球墨铸铁" }, "geometry": { "type": "LineString", "coordinates": [ [ 117.148207019802612, 31.976299944711535 ], [ 117.151189187226777, 31.974481644858205 ] ] } }
    ]
}
```

　　　　可以看出，geoJson格式是在Json数据格式的基础上增加了关于GIS的一些属性描述信息，

　　　　如type:Feature表示是一个地理对象，properties表示对象的属性值，geometry表示要描述的地理对象，

　　　　里面type:LineString表示类型是一个线段， coordinates 表示坐标，后面接着的数组表示一组坐标值，来表示起始点坐标位置。

# ArcGISTileLayer

```js
let ArcGIS_Layer = new maptalks.ArcGISTileLayer('line', {
    visible: true,
    urlTemplate: 'http://127.0.0.1:6080/server/rest/services/line/MapServer',

});
```

　　　　urlTemplate对应的值就是已经部署在ArcGIS服务器上的地图服务地址。

- 三维模型。基于maptalks 有一个使用threejs开发 maptalks.threeLayer 库，可以在maptalks中直接引用，在maptalks中加载三维模型，其实就是使用threejs加载三维模型。

　　　常用的三维模型有以下几种，obj，fbx，glb。使用同一个模型导出的三种文件格式大小如下图：

　　![img](https://img2020.cnblogs.com/blog/59231/202011/59231-20201112133454448-1501872954.png)

　　**从文件大小看，fbx和glb更有优势。**

　　使用Windows自带的3D模型打开Wie

 　***obj模型**一般情况下包含2-3个文件，obj,mtl,jpg(png), obj 为模型文件，mtl 和 jpg文件为材质文件，obj文件可以通过文本编辑器打开，可以看到里面指定了该obj文件对应的材质文件的名称。其余的是在三维空间中绘制的点位置。*

　　　　*![img](https://img2020.cnblogs.com/blog/59231/202011/59231-20201112133527778-1421316585.png)*

 　需要使用材质的位置则指定使用mtl文件中的材质名称。

　　 　![img](https://img2020.cnblogs.com/blog/59231/202011/59231-20201112133605415-413172219.png)

 　在mtl文件中，则可以看到该材质的名称对应的参数

　　　　![img](https://img2020.cnblogs.com/blog/59231/202011/59231-20201112133647554-1331556282.png)

　　fbx文件和glb为二进制编码后的文件，使用文本编辑器打开为乱码。

　　**从可读性看，obj文件更占优势。**

- 使用maptalks.threelayer 加载三维模型

　　　　threejs针对obj、fbx、glb三种格式的三维模型有专门的示例，针对threejs加载，可以在其官网 https://threejs.org/examples 查看，这里专门讲解maptalks 地图中的加载。

　　　　首先，threejs 提供了用于专门解析模型的 js 文件，　　

　　　　![img](https://img2020.cnblogs.com/blog/59231/202011/59231-20201112133806822-1399278711.png)

　　　　需要注意的是:在使用的过程中，需要确认 maptalks.js, maptalks.threelayer.js, 与  OBJLoader.js，MTLLoader.js，FBXLoader.js，GLTFLoader.js所引用three.js  版本一致，否则会出现函数不兼容的情况，无法调用成功。

　　　　加载obj的方法为： 　　　

```js
new THREE.MTLLoader(manager)
    .setPath('/js/symap/lib/maptalks/models/obj/ws/')
    .load('gs.mtl', function (materials) {
    materials.preload();
    new THREE.OBJLoader(manager)
        .setMaterials(materials)
        .setPath('/js/symap/lib/maptalks/models/obj/ws/')
        .load('gs.obj', function (object) {
        object.traverse(function (child) {
            if (child instanceof THREE.Mesh) {
                child.scale.set(0.01, 0.01, 0.01);
                child.rotation.set(Math.PI * 1 / 2, Math.PI * 1 / 8, 0);
            }
        });
        _this.getObject3d().add(object);
        const z = layer.distanceToVector3(50, 50).x;
        const position = layer.coordinateToVector3(
            coordinate,
            z
        );
        _this.getObject3d().position.copy(position);

    });
});
```

　　　　加载 fbx 的方法为：

```js
var loader = new THREE.FBXLoader();
loader.load('/js/symap/lib/maptalks/models/fbx/beng.fbx', function (object) {
    object.scale.set(0.002, 0.002, 0.002);
    object.rotation.set(-Math.PI * 1 / 2, -Math.PI * 1 / 2, 0);
    _this._mixer = new THREE.AnimationMixer(object);
    const action = _this._mixer.clipAction(object.animations[0]);
    if (title.indexOf("测试") > -1) { //速度不为0，显示运转
        action.stop();
    } else {
        action.play();
    }
    object.traverse(function (child) {
        if (child.isMesh) {
            if (child.name == "bengke") {
                child.material.visible = false;
            }
            child.castShadow = true;
            child.receiveShadow = true;
        }
    });
    _this.getObject3d().add(object);
    const z = layer.distanceToVector3(150, 150).x;
    const position = layer.coordinateToVector3(
        coordinate,
        z
    );
    _this.getObject3d().position.copy(position);
});
```

　　　　加载 glb 文件的方法为：

```js
var gltfLoader = new THREE.GLTFLoader(manager);
const dracoLoader = new THREE.DRACOLoader(manager);
gltfLoader.setDRACOLoader(dracoLoader);
gltfLoader.setPath('/js/symap/lib/maptalks/models/gltf/');
gltfLoader.load('gssb.glb', function (gltf) {
    var object = gltf.scene;
    object.scale.set(0.3, 0.3, 0.3);
    _this.getObject3d().add(object);

    object.traverse(function (child) {
        if (child instanceof THREE.Mesh) {
            //if (child.name == "bengke") {
            //    child.material.visible = false;
            //}
            child.rotation.set(Math.PI * 1 / 2, 0, 0);
            child.scale.set(0.1, 0.1, 0.1);
        }
    });

    const z = layer.distanceToVector3(150, 150).x;
    const position = layer.coordinateToVector3(
        coordinate,
        z
    );

    _this.getObject3d().position.copy(position);
    _this._mixer = new THREE.AnimationMixer(object);
    var clip = gltf.animations[0];
    _this._mixer.clipAction(clip.optimize()).play();

});
```

　　　　在glb的加载中，另外引用了一个 DRACOLoader.js 这是一个js库可以在模型加载的过程中对模型进行压缩。

　　　　踩坑记录：

　　　　在3D软件设计模型时，将模型放在(0,0,0)的位置，否则模型加载后不能出现在Scene中，或者不在代码设定的位置上。

　　　　另外对比同一开发环境下单个模型的加载方式对比: ![img](https://img2020.cnblogs.com/blog/59231/202011/59231-20201112134157930-1946703961.png)支持 ![img](https://img2020.cnblogs.com/blog/59231/202011/59231-20201112134211504-178330342.png) 不支持  ![img](https://img2020.cnblogs.com/blog/59231/202011/59231-20201112134224133-420343332.png)待测

| **格式** | **大小** | **多文件**                                                   | **可读性**                                                   | **加载速度** | **支持动画**                                                 | **运行压缩**                                                 | **预压缩**                                                   | **备注** |
| -------- | -------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | -------- |
| **Obj**  | 17.36M   | ![img](https://img2020.cnblogs.com/blog/59231/202011/59231-20201112134235582-1748126455.png) | ![img](https://img2020.cnblogs.com/blog/59231/202011/59231-20201112134241147-101739670.png) | 30ms         | ![img](https://img2020.cnblogs.com/blog/59231/202011/59231-20201112134325205-842015285.png) | ![img](https://img2020.cnblogs.com/blog/59231/202011/59231-20201112134332326-296117417.png) | ![img](https://img2020.cnblogs.com/blog/59231/202011/59231-20201112134256540-1305538606.png) |          |
| **fbx**  | 6.3M     | ![img](https://img2020.cnblogs.com/blog/59231/202011/59231-20201112134312487-781167945.png) | ![img](https://img2020.cnblogs.com/blog/59231/202011/59231-20201112134313583-720816684.png) | 21ms         | ![img](https://img2020.cnblogs.com/blog/59231/202011/59231-20201112134245776-977302077.png) | ![img](https://img2020.cnblogs.com/blog/59231/202011/59231-20201112134333437-2033792809.png) | ![img](https://img2020.cnblogs.com/blog/59231/202011/59231-20201112134300141-1998716379.png) |          |
| **glb**  | 8.3      | ![img](https://img2020.cnblogs.com/blog/59231/202011/59231-20201112134314447-84794968.png) | ![img](https://img2020.cnblogs.com/blog/59231/202011/59231-20201112134315207-2130248641.png) | 25ms         | ![img](https://img2020.cnblogs.com/blog/59231/202011/59231-20201112134246898-641823997.png) | ![img](https://img2020.cnblogs.com/blog/59231/202011/59231-20201112134252951-76297909.png) | ![img](https://img2020.cnblogs.com/blog/59231/202011/59231-20201112134303565-1242538973.png) |          |

　　　　在此次测试中，从加载时间来看，fbx>glb>obj ,综合网络搜索结果，glb模型对其它三维GIS软件（Cesium，CityEngine）的兼容性更好，所以在本项目中使用glb格式的三维模型文件。

　　　　下图为在maptalks中加载的三维模型：

　　 　![img](https://img2020.cnblogs.com/blog/59231/202011/59231-20201112135106307-128792631.png)

　　　　针对模型较大的问题，网上还有其它解决方法，比如DRACOLoader将模型压缩为drc文件进行加载；大模型拆分小模型然后分别压缩drc文件加载；精细模型减少内部结构，保留表面减少模型实际大小等，在开发中再进行测试。

