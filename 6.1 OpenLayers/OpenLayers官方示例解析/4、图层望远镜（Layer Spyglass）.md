- [图层望远镜（Layer Spyglass）](https://blog.csdn.net/qq_35732147/article/details/84836998)

# 一、示例简介

图层渲染可以在precompose和postcompose事件处理程序中被控制，这两个事件处理程序的事件对象中包含一个Canvas渲染上下文属性（canvas rendering context）。

在本示例中，在precompose事件处理程序中生成一个以鼠标光标为中心的剪切掩模，给用户提供一个望远镜效果，使得在一个图层中可以查看另一个图层。

鼠标在地图上移动可以看到效果，使用 “↑”键和“↓”键可以调整望远镜的大小。

 图层望远镜效果：

![img](https://img-blog.csdnimg.cn/20181205155959249.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

# 二、代码详解

```js
<body>
    <!-- 图层容器 --> 
    <div id="map"></div>
</body>
```

## 2.1、首先加载Bing地图的路网地图和影像地图

```js
// Bing地图的key
var key = 'Bing地图的key，可以去Bing地图官网申请';
 
var roads = new TileLayer({         // Bing路网地图
    source: new BingMaps({
        key: key,
        imagerySet: 'Road'
    })
});
 
var imagery = new TileLayer({       // Bing影像地图
    source: new BingMaps({
        key: key,
        imagerySet: 'Aerial'
    })
});
 
var container = document.getElementById('map');
 
var map = new Map({
    target: container,
    layers: [
        roads,
        imagery
    ],
    view: new View({
        center: fromLonLat([-109, 46.5]),
        zoom: 6
    })
});
```

可以去Bing地图的官网申请Key码。

## 2.2、控制望远镜的半径和位置

创建两个变量radius和mousePosition以用于保存望远镜的半径和望远镜圆心的位置（也就是鼠标光标所在像素的位置）

```js
var radius = 75;                        // 用于控制图层望远镜的半径
document.addEventListener('keydown', function(evt){
    console.log(100);
    if(evt.keyCode === 38){            
        console.log(1);       
        // 如果用户按下'↑'键，望远镜的半径增加5像素
        radius = Math.min(radius + 5, 150);
        map.render();
        evt.preventDefault();
    }else if(evt.keyCode === 40){
        // 如果用户按下'↓'键，望远镜的半径减少5像素
        radius = Math.max(radius - 5, 25);
        map.render();
        evt.preventDefault();
    }
});
var mousePosition = null;                       // 用于实时保存鼠标光标所在的像素的位置
container.addEventListener('mousemove', function(event){
    // 每次鼠标移动就获取鼠标光标所在像素相对于地图视口的位置， 并重新渲染一次地图
    mousePosition = map.getEventPixel(event);
    map.render();
});

container.addEventListener('mouseout', function(){
    // 鼠标移出地图容器，鼠标位置设置为空，并重新渲染一次地图
    mousePosition = null;
    map.render();
});
```

主要通过"keydown"、"mousemove"、"mouseout"来控制望远镜的半径和位置。

注意：每次改变了望远镜的半径或位置都需要重新渲染地图，即调用map对象的render()方法。

## 2.3、绘制图层望远镜

因为precompose事件的事件处理程序的事件对象包含canvas渲染上下文，所以可以使用它绘制图层望远镜。

```js
imagery.on('precompose', function(event){       // 在每次绘制影像图层之前触发
    var ctx = event.context;      // 获取canvase渲染上下文
    var pixelRatio = event.frameState.pixelRatio;  // 获取地图当前帧的像素比率
    ctx.save();                 // 保存当前canvas设置
    ctx.beginPath();            // 开始绘制路径
    if(mousePosition){
        // 绘制一个围绕鼠标光标的圆
        ctx.arc(mousePosition[0] * pixelRatio, mousePosition[1] * pixelRatio, 
            radius * pixelRatio, 0, 2 * Math.PI);
            ctx.lineWidth = 5 * pixelRatio;
            ctx.strokeStyle = 'rgba(0, 0, 0, 0.5)';
            ctx.stroke();
    }
    ctx.clip();   // 使用刚绘制的圆裁剪影像图层，使得影像图层只保留该圆的范围
});
 
// 在每次绘制影像图层之后触发
imagery.on('postcompose', function(event){
    var ctx = event.context;
    ctx.restore();                  // canvas恢复到之前的设置
})
```

注意：mousePosition中保存的鼠标光标位置信息是基于当前地图的像素比的，所以要把它转换成和canvas绘图一致的像素比。 

# 三、总结

    图层望远镜功能使得用户可以在一个图层上查看另外一个图层。
    
    官方示例地址：http://openlayers.org/en/latest/examples/layer-spy.html?q=Layer+Spyt
