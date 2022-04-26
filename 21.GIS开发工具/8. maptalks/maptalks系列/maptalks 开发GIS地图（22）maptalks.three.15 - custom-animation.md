- [maptalks 开发GIS地图（22）maptalks.three.15 - custom-animation](https://www.cnblogs.com/googlegis/p/14734801.html)

1. 此demo演示了自定义动画的生成，动画的样式为一层层荡开的圆圈，类似与水纹。

2. 此demo中第一次使用了类的扩展对象，将圆圈定义为一个对象，样式和动画在其内部进行定义，外部直接调用添加到对应的经纬度上即可。

3. 参考代码

扩展对象类中有 _animation 函数，该函数为对象自动执行，可在该该函数中加入动画过程代码。而不需要自己写个定时器之类的去执行动画。

 添加 Circle 对象

```js
var text = Math.round(Math.random() * 10000);
var material = getMaterial(70, text, color);
circles = lnglats.map(function (lnglat) {
    var circle = new Circle(lnglat, {
        radius: 200
    }, material, threeLayer);

    //tooltip test
    circle.setToolTip('id:' + circle.getId(), {
        showTimeout: 0,
        eventsPropagation: true,
        dx: 10
    });

    //infowindow test
    circle.setInfoWindow({
        content: 'id:' + circle.getId(),
        title: 'message',
        animationDuration: 0,
        autoOpenOn: false
    });

    //event test
    ['click', 'mousemove', 'mouseout', 'mouseover', 'mousedown', 'mouseup', 'dblclick', 'contextmenu'].forEach(function (eventType) {
        circle.on(eventType, function (e) {
            console.log(e.type, e);
        });
    });
    return circle;
});
threeLayer.addMesh(circles);
```

Circle对象扩展类

```js
class Circle extends maptalks.BaseObject {
    constructor(coordinate, options, material, layer) {
        options = maptalks.Util.extend({}, OPTIONS, options, { layer, coordinate });
        super();
        //Initialize internal configuration
        // https://github.com/maptalks/maptalks.three/blob/1e45f5238f500225ada1deb09b8bab18c1b52cf2/src/BaseObject.js#L135
        this._initOptions(options);
        const { altitude, radius } = options;
        //generate geometry
        const r = layer.distanceToVector3(radius, radius).x
        const geometry = new THREE.CircleBufferGeometry(r, 50);

        //Initialize internal object3d
        // https://github.com/maptalks/maptalks.three/blob/1e45f5238f500225ada1deb09b8bab18c1b52cf2/src/BaseObject.js#L140
        this._createMesh(geometry, material);

        //set object3d position
        const z = layer.distanceToVector3(altitude, altitude).x;
        const position = layer.coordinateToVector3(coordinate, z);
        this.getObject3d().position.copy(position);
        this._scale = 1;
        // this.getObject3d().rotation.x = -Math.PI;
    }

    // test animation
    _animation() {
        this._scale = (this._scale > 1 ? 0 : this._scale);
        this._scale += 0.002;
        this.getObject3d().scale.set(this._scale, this._scale, this._scale);
    }
}
```

4. 页面显示

![img](https://img2020.cnblogs.com/blog/59231/202105/59231-20210506134524572-989286119.gif)