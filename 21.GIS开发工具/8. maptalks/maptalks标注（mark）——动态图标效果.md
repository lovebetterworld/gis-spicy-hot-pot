- [maptalks标注（mark）——动态图标效果](https://blog.csdn.net/liona_koukou/article/details/100743049)

最终效果图如下：

1、下图这种效果是用了官方提供的插件maptalks.animatemarker，地址https://github.com/maptalks/maptalks.animatemarker

![img](https://img-blog.csdnimg.cn/20190911172907165.gif)

2、这种是用了maptalks的Mark的变形动画，官方例子地址https://maptalks.org/examples/cn/animation/marker-anim/#animation_marker-anim

![img](https://img-blog.csdnimg.cn/2019091117290265.gif)
  

首先我们先说为什么maptalks地图的mark不支持动图，我们初始化地图之后选取页面元素可以发现整个地图是个canvas，而canvas是不支持gif之类的动图的。这意味着如果我们要做成好看一点的动态mark图标就要想别的办法= =。完整代码我会放在最下面，第一二种实现我放在一个页面里了有加注释应该比较容易看懂

1、作为一个GIS小白翻了官网之后其实先找到了maptalks.animatemarker这个插件——也就是第一种的实现效果，根据官方提供的例子也可以很轻易的实现mark的动态图标，只要再加上点击弹框效果就ok了——下图这里的代码就是给每个mark加了一个点击事件

![img](https://img-blog.csdnimg.cn/20190911175053223.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpb25hX2tvdWtvdQ==,size_16,color_FFFFFF,t_70)

2、实际项目中点位多的时候我们需要做聚合效果，所以第一种方法实现之后我又开始研究怎么能把这种图标加上聚合效果，我粗浅的理解如下：

maptalks提供了聚合插件maptalks.markercluster，我们看GitHub上的官方说明

![img](https://img-blog.csdnimg.cn/20190911175645989.png)

![img](https://img-blog.csdnimg.cn/20190911175720749.png)

也就是说maptalks.animatemarker插件和聚合插件maptalks.markercluster都是maptalks.VectorLayer的子类，这两个都是图层我不知道怎么能同时加上聚合和动态效果的图标，各位看客有想法或者专业GIS知道的可以告诉我（萌新求教），所以我把目光转向了第二种实现方法つ﹏⊂——marker的变形动画，看官方的例子之后我想如果setInterval执行变形动画图标就可以有动态效果了根据这个思路做出第二种效果

具体代码如下：

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <style>
        html, body {
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
            background: #191945;
        }

        .container {
            width: 100%;
            height: 100%;
        }

        .maptalks-msgBox {
            background: transparent !important;
            border: none !important;
        }

        .map-popover {
            width: 100%;
            height: 100px;
            background: transparent;
        }

        .map-popover .mark-info {
            position: relative;
            display: inline-block;
            width: 100%;
            height: 100px;
            background: rgba(0, 0, 255, 0.4);
            border-radius: 4px;
            border: 1px solid #00fff0;
        }

        .waver-span {
            display: inline-block;
            width: 3px;
            height: 10px;
            background-color: #00fff0;

        }

        .waver-box {
            position: absolute;
            right: 0;
            top: 0;
            width: 30px;
            height: 12px;
        }

        .waver-spanr {
            transform: skew(25deg);
        }

        .waver-span1 {
            animation: shake1 1s infinite;
        }

        .waver-span2 {
            animation: shake2 1s infinite;
        }

        .waver-span3 {
            animation: shake3 1s infinite;
        }

        .waver-span4 {
            animation: shake4 1s infinite;
        }

        @keyframes shake1 {
            0% {
                opacity: 1;
            }
            25% {
                opacity: 0;
            }
            100% {
                opacity: 1;
            }
        }

        @keyframes shake2 {
            0% {
                opacity: 1;
            }
            50% {
                opacity: 0;
            }
            100% {
                opacity: 1;
            }
        }

        @keyframes shake3 {
            0% {
                opacity: 1;
            }
            75% {
                opacity: 0;
            }
            100% {
                opacity: 1;
            }
        }

        @keyframes shake4 {
            0% {
                opacity: 1;
            }
            100% {
                opacity: 0;
            }
        }
    </style>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/maptalks/dist/maptalks.css">
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/maptalks/dist/maptalks.min.js"></script>
    <script type="text/javascript"
            src="https://unpkg.com/maptalks.markercluster/dist/maptalks.markercluster.min.js"></script>
    <script type="text/javascript"
            src="https://unpkg.com/maptalks.animatemarker/dist/maptalks.animatemarker.min.js"></script>
    <script src="js/all_month.js"></script>
    <script src="js/addressPoints.js"></script>
</head>
<body>
<div id="map" class="container"></div>
<script>
    let map = new maptalks.Map('map', {
        center: [-0.113049, 51.498568],
        zoom: 14,
        fpsOnInteracting: 0, // 解决marker不连续问题,关闭交互帧数限制,（默认25帧）限制
        baseLayer: new maptalks.TileLayer('base', {
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
            attribution: '&copy; <a href="http://www.osm.org" target="_blank">OpenStreetMap</a> contributors',
            cssFilter: 'sepia(100%) invert(90%)'
        })
    })

    // mark点击弹框
    function onClick(e) {
        e.target.setInfoWindow({
            'content': '<div class="map-popover">' +
                '<div class="mark-info">' +
                '<div class="waver-box">' +
                '        <span class="waver-span waver-spanr waver-span1"></span>' +
                '        <span class="waver-span waver-spanr waver-span2"></span>' +
                '        <span class="waver-span waver-spanr waver-span3"></span>' +
                '        <span class="waver-span waver-spanr waver-span4"></span>' +
                '    </div>' +
                '</div>' +
                '</div>',
            'width': 300,
            'minHeight': 100,
            'dy': 5,
            'autoPan': true,
            'custom': false,
            'autoOpenOn': 'click',  //set to null if not to open when clicking on marker
            'autoCloseOn': 'click'
        })
    }

    /*maptalks的Mark的变形动画-----------------开始*/
    //图片标注+点击弹框
    let markers = []
    for (let i = 0; i < addressPoints.length; i++) {
        let a = addressPoints[i]
        markers.push(new maptalks.Marker([a[0], a[1]], {
            'symbol': [
                {
                    'markerType': 'ellipse',
                    'markerWidth': 20,
                    'markerHeight': 20,
                    'markerFill': 'rgb(64, 158, 255)',
                    'markerFillOpacity': 0.7,
                    'markerLineColor': '#73b8ff',
                    'markerLineWidth': 3
                },
                {
                    'markerType': 'ellipse',
                    'markerWidth': 10,
                    'markerHeight': 10,
                    'markerFill': '#006ddd',
                    'markerFillOpacity': 0.7,
                    'markerLineWidth': 0
                }
            ]
        }).on('mousedown', onClick));

    }
    // 聚合效果
    let clusterLayer = new maptalks.ClusterLayer('cluster', markers, {
        'noClusterWithOneMarker': false,
        'maxClusterZoom': 16,
        //"count" is an internal variable: marker count in the cluster.
        'symbol': {
            'markerType': 'ellipse',
            'markerFill': {
                property: 'count',
                type: 'interval',
                stops: [[0, 'rgb(135, 196, 240)'], [9, '#1bbc9b'], [99, 'rgb(216, 115, 149)']]
            },
            'markerFillOpacity': 0.7,
            'markerLineOpacity': 1,
            'markerLineWidth': 3,
            'markerLineColor': '#fff',
            'markerWidth': {property: 'count', type: 'interval', stops: [[0, 40], [9, 60], [99, 80]]},
            'markerHeight': {property: 'count', type: 'interval', stops: [[0, 40], [9, 60], [99, 80]]}
        },
        'drawClusterText': true,
        'geometryEvents': true,
        'single': true
    })
    map.addLayer(clusterLayer)

    // 执行mark的变形动画
    setInterval(() => {
        replay();
    }, 1500)

    function replay() {
        animate();
        setTimeout(() => {
            reset();
        }, 600)

    }

    // mark的变形动画
    function animate() {
        markers.map((item) => {
            item.animate({
                'symbol': [
                    {
                        'markerWidth': 40,
                        'markerHeight': 40,
                        'markerFillOpacity': 0.2,
                        'markerLineWidth': 1
                    },
                    {
                        'markerWidth': 20,
                        'markerHeight': 20,
                        'markerFillOpacity': 0.4
                    }
                ]
            }, {
                'duration': 600
            });
        })
    }

    // mark的变形动画
    function reset() {
        markers.map((item) => {
            item.animate({
                'symbol': [
                    {
                        'markerWidth': 20,
                        'markerHeight': 20,
                        'markerFillOpacity': 0.7,
                        'markerLineWidth': 3
                    },
                    {
                        'markerWidth': 10,
                        'markerHeight': 10,
                        'markerFillOpacity': 0.7
                    }
                ]
            }, {
                'duration': 600
            });
        })
    }

    /*maptalks的Mark的变形动画-----------------结束*/


    /*maptalks.animatemarker插件------------------开始*/
    function getGradient(colors) {
        return {
            type: 'radial',
            colorStops: [
                [0.70, 'rgba(' + colors.join() + ', 0.5)'],
                [0.30, 'rgba(' + colors.join() + ', 1)'],
                [0.20, 'rgba(' + colors.join() + ', 1)'],
                [0.00, 'rgba(' + colors.join() + ', 0)']
            ]
        };
    }

    //JSON序列化 - GeoJSON转化为Geometry
    let geometries = maptalks.GeoJSON.toGeometry(earthquakes);
    // 添加mark点击弹框操作
    geometries.map((item) => {
        item.on('mousedown', onClick)
    })
    let layer = new maptalks.AnimateMarkerLayer(
        'animatemarker',
        geometries,
        {
            'animation': 'scale,fade',
            'randomAnimation': true,
            'geometryEvents': true
        }
    )
        .setStyle([
            {
                filter: ['<=', 'mag', 2],
                symbol: {
                    'markerType': 'ellipse',
                    'markerLineWidth': 0,
                    'markerFill': getGradient([135, 196, 240]),
                    'markerFillOpacity': 0.8,
                    'markerWidth': 50,
                    'markerHeight': 50
                }
            },
            {
                filter: ['<=', 'mag', 5],
                symbol: {
                    'markerType': 'ellipse',
                    'markerLineWidth': 0,
                    'markerFill': getGradient([255, 255, 0]),
                    'markerFillOpacity': 0.8,
                    'markerWidth': 50,
                    'markerHeight': 50
                }
            },
            {
                filter: ['>', 'mag', 5],
                symbol: {
                    'markerType': 'ellipse',
                    'markerLineWidth': 0,
                    'markerFill': getGradient([216, 115, 149]),
                    'markerFillOpacity': 0.8,
                    'markerWidth': 50,
                    'markerHeight': 50
                }
            }
        ]).addTo(map)
    /*maptalks.animatemarker插件------------------结束*/

    // 地图飞行到指定位置的效果
    changeView()

    function changeView() {
        map.animateTo({
            center: [-0.113049, 51.498568],
            zoom: 13,
            pitch: 45,
            bearing: 360
        }, {
            duration: 3000
        })
    }

</script>
</body>
</html>
```

页面里有两个文件是标注点的信息文件都是来自官方给的，不过根据我的地图修改了点的经纬度，下面给出这两个文件内容

![img](https://img-blog.csdnimg.cn/20190912095234779.png)

all_month.js

```js
var earthquakes = {"type":"FeatureCollection","metadata":{"generated":1493627919000,"url":"https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson","title":"USGS All Earthquakes, Past Month","status":200,"api":"1.5.7","count":9468},"features":[{"type":"Feature","properties":{"mag":2.5,"place":"39km ESE of Sutton-Alpine, Alaska","time":1493625197031,"updated":1493626024970,"tz":-540,"url":"https://earthquake.usgs.gov/earthquakes/eventpage/ak15851488","detail":"https://earthquake.usgs.gov/earthquakes/feed/v1.0/detail/ak15851488.geojson","felt":null,"cdi":null,"mmi":null,"alert":null,"status":"automatic","tsunami":0,"sig":96,"net":"ak","code":"15851488","ids":",ak15851488,","sources":",ak,","types":",geoserve,origin,","nst":null,"dmin":null,"rms":0.96,"gap":null,"magType":"ml","type":"earthquake","title":"M 2.5 - 39km ESE of Sutton-Alpine, Alaska"},"geometry":{"type":"Point","coordinates":[-0.12204900000004636,51.498568000000006]},"id":"ak15851488"},
{"type":"Feature","properties":{"mag":0.31,"place":"10km NNE of Cabazon, California","time":1493624583650,"updated":1493624807584,"tz":-480,"url":"https://earthquake.usgs.gov/earthquakes/eventpage/ci37637279","detail":"https://earthquake.usgs.gov/earthquakes/feed/v1.0/detail/ci37637279.geojson","felt":null,"cdi":null,"mmi":null,"alert":null,"status":"automatic","tsunami":0,"sig":1,"net":"ci","code":"37637279","ids":",ci37637279,","sources":",ci,","types":",geoserve,nearby-cities,origin,phase-data,scitech-link,","nst":12,"dmin":0.09068,"rms":0.3,"gap":175,"magType":"ml","type":"earthquake","title":"M 0.3 - 10km NNE of Cabazon, California"},"geometry":{"type":"Point","coordinates":[-0.123049,51.528568]},"id":"ci37637279"},
{"type":"Feature","properties":{"mag":1.14,"place":"17km N of Yucca Valley, California","time":1493624526120,"updated":1493624745760,"tz":-480,"url":"https://earthquake.usgs.gov/earthquakes/eventpage/ci37637271","detail":"https://earthquake.usgs.gov/earthquakes/feed/v1.0/detail/ci37637271.geojson","felt":null,"cdi":null,"mmi":null,"alert":null,"status":"automatic","tsunami":0,"sig":20,"net":"ci","code":"37637271","ids":",ci37637271,","sources":",ci,","types":",geoserve,nearby-cities,origin,phase-data,scitech-link,","nst":31,"dmin":0.05453,"rms":0.26,"gap":86,"magType":"ml","type":"earthquake","title":"M 1.1 - 17km N of Yucca Valley, California"},"geometry":{"type":"Point","coordinates":[-0.113049,51.498568]},"id":"ci37637271"},
],"bbox":[-179.9434,-65.0051,-3.43,179.9803,84.9861,638.62]}
```

addressPoints.js

```js
var addressPoints = [
    [-0.123149,51.528568, "3"],
    [-0.123249,51.528568, "10"],
    [-0.123049,51.528568, "11"],
    [-0.123349,51.528568, "12"],
    [-0.123449,51.528568, "13"],
    [-0.123549,51.528568, "14"],
    [-0.123649,51.528568, "15"],
    [-0.123749,51.528568, "16"],
    [-0.123849,51.528568, "17"],
    [-0.123949,51.528568, "18"],
    [-0.124049,51.528568, "20"],
    [-0.125049,51.528568, "22"],
    [-0.126049,51.528568, "24"],
    [-0.127049,51.528568, "26"],
    [-0.128049,51.528568, "28"],
    [-0.129049,51.528568, "4A"],
    [-0.133049,51.528568, "4B"],
    [-0.143049,51.528568, "5"],
    [-0.153049,51.528568, "6"],
    [-0.163049,51.528568, "7"],
    [-0.173049,51.528568, "8"]
    ]
```

代码可以直接运行

