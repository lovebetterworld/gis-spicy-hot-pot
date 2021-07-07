- [【三维GIS可视化】基于Vue+Cesium+Supermap实现智慧城市（一）](https://juejin.cn/post/6953968499089735711)
- [【三维GIS可视化】基于Vue+Cesium+Supermap实现智慧城市（二）](https://juejin.cn/post/6955011037070360589)
- [【三维GIS可视化】基于Vue+Cesium+Supermap实现智慧城市（三）](https://juejin.cn/post/6958708504618237960)
- [【三维GIS可视化】基于Vue+Cesium+Supermap实现智慧城市（四）](https://juejin.cn/post/6965347246061649934)
- [【三维GIS可视化】基于Vue+Cesium+Supermap实现智慧城市（五）](https://juejin.cn/post/6969369288247361572)



### 前言

![分层展示.gif](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/cd9637ac16fa465d88ec4ece08f0ae58~tplv-k3u1fbpfcp-watermark.image)

这个效果也是我偶然间在一个视频中看到的，然后开始逐步理清思路动手开始实现，简单来讲就是利用Entity的显示隐藏以及坐标的转换实现。因为是野路子所以可能实现过程略显粗糙或冗余，接下来来我们开始。

### 基本思路

我们需要利用点击事件获取我们选中的这个实体，隐藏当前实体并获取到它的外围坐标集来生成新的多边形，并且要对这个多边形进行放大平移等操作。同时我们需要提供一个关闭按钮让其能够退出所谓的分层模式。

我们如何对一个坐标集进行操作让它所代表的多边形能够缩放或平移呢？这就要用到我们的地理分析库`Turf.js`了，关于Turf的介绍及基本使用方法我在[Turf.js—让你在浏览器上实现地理分析](https://juejin.cn/post/6968626897156603918)里做了相关介绍，需要的小伙伴可以进行浏览。

关闭按钮该如何实现呢？还记得前面的文章中我们进行的简单的文本标记类封装吗，道理是一样的，将我们指定的div元素渲染到Cesium的容器中，并在类中指定所需的逻辑、方法等即可。

### 实现

#### 分层效果

思路清晰后我们可以开始功能实现。同样的，我们可以先实现功能后对其封装，在本文中我们只贴出关键代码，小伙伴们可以读完文章后亲自动手实现。

首先我们肯定是加载一个`entity`实体，这里老生常谈，我就不多做说明了，然后我们需要注册一个点击事件，用来触发点击实体后的响应函数。

```js
let handler = new Cesium.ScreenSpaceEventHandler(viewer.scene.canvas);

handler.setInputAction((movement) => {
    let pick = viewer.scene.pick(movement.position);
    if (Cesium.defined(pick)) {
        if(!pick.id.isFloor) {
            this.showFloor(pick.id);
        } else {
            this.selectFloor(pick.id);
        }
    }
}, Cesium.ScreenSpaceEventType.LEFT_CLICK);
复制代码
```

在响应函数中我们首先隐藏点击的这个实体，为我们的分层实体集腾位置，接着获取到这个实体的外围坐标集，并用它作为我们的分层实体的坐标集。

```js
showFloor(entity) {
    viewer.entities.getById(entity.id).show = false;
    let height = 30;
    for (let i = 0; i < entity.floor; i++) {
        let floor = {
            name: "floor" + i,
            id: entity.id + "F" + i,
            isFloor: true,
            floor: i + 1,
          	positions: entity.positions,
            polygon: {
                // hierarchy: Cesium.Cartesian3.fromDegreesArray(floorPos),
                hierarchy: entity.polygon.hierarchy._value,
                material: Cesium.Color.YELLOW.withAlpha(0.4),
                height,
                outline: true,
                ouelineColor: Cesium.Color.BLACK,
            },
        };
        height += 60;
        viewer.entities.add(floor);
    }
},
复制代码
```

这样我们基本的分层效果就做出来了。

![分层展示1.gif](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/7dc64dfc11b4473e8822fa53baf471a2~tplv-k3u1fbpfcp-watermark.image)

#### 选中效果

接下来我们实现选中效果，选中效果我们可以使用高亮、平移、放大以及它们的组合展示，高亮这里不做阐述，效果在我们网格实现那篇文章已经实现，本文主要实现放大效果。

想实现放大效果我们需要利用`Turf.js`进行坐标的变换，所以我们首先在项目中安装Turf

```cmd
npm i @turf/turf
复制代码
```

我们需要利用`Turf.js`中的`polygon`和`transformScale`实现。为了方便，在最开始`Entity`生成的时候我将它的二维坐标组作为一个属性绑定到实体上，以便后续使用。在实际项目中根据具体的情况进行调整，比如利用三维坐标转换或根据实体`ID`调取接口获取等。

我们想使用Turf就要遵循它的格式。所以首先我们需要生成Turf承认的Polygon实体，然后将其进行放大或缩小并获取其放大后的坐标数组。

```js
let poly = turf.polygon([positions]);
let translatedPoly = turf.transformScale(poly, 1.4);
let transPoints = translatedPoly.geometry.coordinates[0];
复制代码
```

然后生成一个实体并添加到实体集中即可。

这里只是做了最基本的实现，完整的思考下来其实会发现还有很多需要完善的地方。比如：点击已选中楼层后取消选中、选中楼层的唯一性等等。

![分层展示2.gif](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/ac587743c20942a3aadc5fd6fe8285d3~tplv-k3u1fbpfcp-watermark.image)

完整方法：

```js
selectFloor(floor) {
    console.log(floor);
    let positions = floor.positions;
    let poly, translatedPoly, transPoints, floorPosSingle = [];
    poly = turf.polygon([positions]);
    translatedPoly = turf.transformScale(poly, 1.4);
    transPoints = translatedPoly.geometry.coordinates[0];
    transPoints.forEach((item) => {
        floorPosSingle.push(item[0], item[1]);
    });

    let selectFloor = {
        name: "select_floor",
        id: 'active_' + floor.id,
        isFloor: true,
        isActive: true,
        polygon: {
            hierarchy: Cesium.Cartesian3.fromDegreesArray(floorPosSingle),
            material: Cesium.Color.RED.withAlpha(0.4),
            height: floor.polygon.height._value,
            outline: true,
            outlineColor: Cesium.Color.BLACK,
        },
    };

    viewer.entities.getById(floor.id).show = false
    viewer.entities.add(selectFloor)
},
复制代码
```

#### 关闭按钮

关闭按钮这里也不做过多说明，和动态文本标记的思路大致相同，唯一的区别是现在的DOM中绑定一个点击事件，需要通过这个事件触发删除分层实体集和恢复显示楼层。这里我简单说明一下如何在封装的类中调用vue文件下的方法

```js
// class类中
this._vmInstance.closeEvent = e => {
    this.close();
};

close() {
    this._vmInstance.show = false; //删除dom
    // do something……
}
复制代码
// vue文件中
<div :id="id" class="close-container" v-if="show" @click="closeClick"></div>

closeClick() {
    if (this.closeEvent) {
    	this.closeEvent();
    }
},
复制代码
```

#### 特殊情况

![分层展示3.gif](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/20d92729e36846688dfe0fe31e94a514~tplv-k3u1fbpfcp-watermark.image)

有时候我们会发现，我们的实体并不是一个完整的多边形体，有可能是环状或带洞的多边形，这时候利用上述的方法会发现疯狂报错。原因是无论是Ceisum中还是Turf中，带洞多边形的坐标格式都和普通的多边形是不一样的，下面简单说明一下两个库中带洞多边形的生成方式。

##### Cesium

在Ceisum中，`entity.polygon.hierarchy`作为多边形的外围坐标集，提供了两种写法，上文中的写法为简写，默认不带洞，而带洞多边形则需要提供一个对象，其中包含两个字段`positions`和`holes`。顾名思义，一个是外围坐标集，一个是洞坐标集。其中`holes`可以提供多个坐标集，相当于挖多个洞。

```js
let entity = {
    polygon:{
        hierarchy:{
            positions: Cesium.Cartesian3.fromDegreesArray(outPos),
            holes: [
                { positions: Cesium.Cartesian3.fromDegreesArray(inPos) }
            ]
        }
    }
}
复制代码
```

##### Turf.js

而在Turf中，我们无法实现直接掏洞，只能曲线救国，将洞的坐标集和外围坐标集生成多边形并分别进行放大操作，获取坐标后进行我们想要的实现。


作者：moe_
链接：https://juejin.cn/post/6969369288247361572
来源：掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。