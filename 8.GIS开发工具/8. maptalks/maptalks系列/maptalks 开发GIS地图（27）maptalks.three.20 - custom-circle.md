- [maptalks 开发GIS地图（27）maptalks.three.20 - custom-circle](https://www.cnblogs.com/googlegis/p/14735232.html)

1. 自定义圆圈，从效果上来看，并没有太惊艳，普通的canvas应用，不过圆圈的颜色是渐变色，这个还是头一次看到实际的应用，平时不太敢想这么去做。

2. 渐变色是使用 canvas 制作的。使用了 ctx.createLinearGradient。

```js
function getMaterial(fontSize, text, fillColor) {
    var SIZE = 256;
    var canvas = document.createElement('canvas');
    canvas.width = canvas.height = SIZE;
    var ctx = canvas.getContext('2d');
    var gradient = ctx.createLinearGradient(0, 0, SIZE, 0);
    // gradient.addColorStop("0", "#ffffff");
    gradient.addColorStop("0.0", "#1a9bfc");
    gradient.addColorStop("1.0", "#7049f0");
    // gradient.addColorStop("0.66", "white");
    // gradient.addColorStop("1.0", "red");

    ctx.strokeStyle = gradient;
    ctx.lineWidth = 40;
    ctx.arc(SIZE / 2, SIZE / 2, SIZE / 2, 0, Math.PI * 2);
    ctx.stroke();
    ctx.fillStyle = fillColor;
    ctx.font = `${fontSize}px Aria`;
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillText(text, SIZE / 2, SIZE / 2);
    ctx.rect(0, 0, SIZE, SIZE);
    var texture = new THREE.Texture(canvas);
    texture.needsUpdate = true; //使用贴图时进行更新

    var material = new THREE.MeshPhongMaterial({
        map: texture,
        // side: THREE.DoubleSide,
        transparent: true
    });
    return material;
}
```

3. 添加圆圈

```js
function addCircles() {
    var lnglats = [
        [13.429362937522342, 52.518205849377495]
        , [13.41688993786238, 52.52216099633924]
        , [13.417991247928398, 52.53296954185342]
        , [13.438154245439819, 52.533321196953096]
        , [13.450418871799684, 52.52653968753597]
        , [13.390340036780685, 52.51953598324846]
        , [13.399921081391199, 52.50920191922407]
        , [13.366122901455583, 52.50949703597493]
        , [13.365784792637783, 52.51964629275582]
        , [13.371429857108524, 52.528732386936014]
        , [13.383686384074508, 52.53781463596616]
        , [13.40395563186371, 52.540223413847315]
        , [13.361485408920998, 52.53916869831616]
        , [13.35373758485457, 52.52883597474849]
        , [13.355233792792774, 52.519259850666316]
        , [13.369548077301943, 52.506940362998336]
        , [13.338732610093984, 52.50860998116909]
        , [13.341879792058194, 52.52318729489704]
        , [13.348448231846305, 52.537668773653735]
    ];
    var text = Math.round(Math.random() * 10000);
    var material = getMaterial(70, text, '#fff');
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

    initGui();
}
```

4. 页面显示

![img](https://img2020.cnblogs.com/blog/59231/202105/59231-20210506150035844-896023025.png)

 