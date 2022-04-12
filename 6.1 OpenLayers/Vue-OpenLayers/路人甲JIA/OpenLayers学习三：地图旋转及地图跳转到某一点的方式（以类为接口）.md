- [OpenLayers学习三：地图旋转及地图跳转到某一点的方式（以类为接口）_路人甲JIA的博客-CSDN博客_openlayers 旋转](https://blog.csdn.net/u013719339/article/details/77920770)

上面例子中，除了飞行到某点不好理解，其他都非常好理解，以下直接贴所有的方法，解释都在代码中。

```javascript
var london = ol.proj.fromLonLat([-0.12755, 51.507222]);
var moscow = ol.proj.fromLonLat([37.6178, 55.7517]);
var istanbul = ol.proj.fromLonLat([28.9744, 41.0128]);
var rome = ol.proj.fromLonLat([12.5, 41.9]);
var bern = ol.proj.fromLonLat([7.4458, 46.95]);
 
var viewAnimate = map.getView();
 
function onClick(id, callback) {
    map.loadTilesWhileAnimating = true;
    document.getElementById(id).addEventListener('click', callback);
}
 
onClick('rotate-left', function () {
    viewAnimate.animate({
        rotation: viewAnimate.getRotation() + Math.PI / 2
    });
});
 
onClick('rotate-right', function () {
    viewAnimate.animate({
        rotation: viewAnimate.getRotation() - Math.PI / 2
    });
});
 
onClick('rotate-around-rome', function () {
    viewAnimate.animate({
        rotation: viewAnimate.getRotation() + 2 * Math.PI, //地图旋转角度
        center: rome
    });
});
 
onClick('pan-to-london', function () {
    viewAnimate.animate({
        center: london,
        duration: 2000
    });
});
 
onClick('elastic-to-moscow', function () {
    viewAnimate.animate({
        center: moscow,
        duration: 2000,
        easing: function (t) {
            return Math.pow(2, -10 * t) * Math.sin((t - 0.075) * (2 * Math.PI) / 0.3) + 1;
        }
    });
});
 
onClick('bounce-to-istanbul', function () {
    viewAnimate.animate({
        center: istanbul,
        duration: 2000,
        easing: function (t) {
            var s = 7.5625, p = 2.75, l;
            if (t < (1 / p)) {
                l = s * t * t;
            } else {
                if (t < (2 / p)) {
                    t -= (1.5 / p);
                    l = s * t * t + 0.75;
                } else {
                    if (t < (2.5 / p)) {
                        t -= (2.25 / p);
                        l = s * t * t + 0.9375;
                    } else {
                        t -= (2.625 / p);
                        l = s * t * t + 0.984375;
                    }
                }
            }
            return l;
        }
    });
});
 
onClick('spin-to-rome', function () {
    viewAnimate.animate({
        center: rome,
        rotation: 2 * Math.PI,
        duration: 2000
    });
});
 
function flyTo(location, done) {
    var duration = 2000;
    var zoom = viewAnimate.getZoom();
    var parts = 1; // 判断下列两个动画效果是否都执行完毕
    var called = false; // ? 未懂
 
    function callback(complete) {
        --parts;
        if (called) {  //此处的parts和called是什么意思没看懂
            console.log(1);  //调试用的，非正是代码
            return;
        }
        if (parts === 0 || !complete) { //动画效果完成 或 动画效果中断 complete是内部传入参数，判断动画执行还是中断
            called = true;
            done(complete); //动画效果完后执行的函数
        }
    }
    //第一个动画效果 到达目的点
    //第二个动画效果 执行放大缩小
    //两个动画换位，则两个先放大缩小，在转到目的点
    viewAnimate.animate({
        center: location,
        duration: duration
    }, callback);
    viewAnimate.animate({
        zoom: zoom + 5,
        duration: duration / 2
    }, {
        zoom: zoom - 1,
        duration: duration / 2
    },{
        zoom: zoom,
        duration: duration / 2
    }, callback);
}
 
onClick('fly-to-bern', function () {
    //自动产生一个boolean值传入函数中作为参数 完成则为true 中断为false
    //tour里向flyTo传入了回调函数，因此此处调用时不能空参，functions(){}此处无意义
    flyTo(bern, function () {});
});
 
onClick('tour', function () {
    var locations = [london, bern, rome, moscow, istanbul];
    var index = -1;
 
    function next(more) {
        if (more) {
            ++index;
            if (index < locations.length) {
                var delay = index === 0 ? 0 : 750;
                setTimeout(function () {
                    flyTo(locations[index], next);
                }, delay);
            } else {
                alert('Tour complete');
            }
        } else {
            alert('Tour cancelled');
        }
    }
    next(true);
});
```

HTML

```html
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>OpenLayers Map</title>
        <link rel="stylesheet" href="ol.css" type="text/css">
        <script src="ol.js"></script>
        <script src="http://code.jquery.com/jquery-3.2.1.js"></script>
    </head>
    <body>

        <div id="map" class="map" tabindex="0"></div>
        <button id="zoom-out">Zoom out</button>
        <button id="zoom-in">Zoom in</button>

        <button id="rotate-left" title="Rotate clockwise">↻</button>
        <button id="rotate-right" title="Rotate counterclockwise">↺</button>
        <button id="pan-to-london">Pan to London</button>
        <button id="elastic-to-moscow">Elastic to Moscow</button>
        <button id="bounce-to-istanbul">Bounce to Istanbul</button>
        <button id="spin-to-rome">Spin to Rome</button>
        <button id="fly-to-bern">Fly to Bern</button>
        <button id="rotate-around-rome">Rotate around Rome</button>
        <button id="tour">Take a tour</button>

        <script type="text/javascript" src="Accessible Map.js"></script>
        <script type="text/javascript" src="View Animation.js"></script>

    </body>
</html>
```

进入地图  Accessible Map.js

```javascript
var view = new ol.View({
    center: [0, 0],
    zoom: 6
})

var map = new ol.Map({
    layers: [
        new ol.layer.Tile({
            source: new ol.source.OSM()
        })
    ],
    target: 'map',
    controls: ol.control.defaults({
        attribution: false//来源
    }),
    view: view,
});

//每次都要获取当前地图所在级别
document.getElementById('zoom-out').onclick = function() {
    var view = map.getView();
    var zoom = view.getZoom();
    view.setZoom(zoom - 1);
};

document.getElementById('zoom-in').onclick = function() {
    var view = map.getView();
    var zoom = view.getZoom();
    view.setZoom(zoom + 1);
};
```