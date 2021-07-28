- [openlayers中巧用canvas滤镜，自由切换你的地图风格](https://blog.csdn.net/u012413551/article/details/99892553)



# 前言

高德地图、百度地图等等图商现在都提供一些自定义地图风格，用户可以自己设计地图样式，这样使得地图使用灵活了很多。

## 百度地图个性化编辑平台

![百度地图个性化](https://img-blog.csdnimg.cn/20190820224427496.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTI0MTM1NTE=,size_16,color_FFFFFF,t_70)

## 高德地图自定义地图

![高德地图自定义](https://img-blog.csdnimg.cn/20190820224553662.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTI0MTM1NTE=,size_16,color_FFFFFF,t_70)

从openlayers3开始，其底层渲染从SVG切换到了canvas，据说渲染效率提高了不少。在canvas上，我们可以实现很多比较炫酷的可视化操作，如之前的空气质量态势图、动态风场等等。今天，来分享一个好玩的，通常CSS3滤镜，改变地图风格。

# 1、原理

1、通过地图的渲染事件，获取到canvas上下文context；
2、设置context的filter属性。
3、重新渲染图层。

```js
  map.on('precompose', function(evt){
      var ctx = evt.context;
      ctx.filter = filter;//设置滤镜值
  })
  map.render();
```

filter值类型为字符串，默认值为"none"；
precompose事件会在地图渲染前发生，因此在渲染前，改变filter值，即可让地图按设置的滤镜进行渲染。

关于滤镜的属性，可以参考菜鸟教程中的《CSS3 filter(滤镜)》
也可以参考MDN web docs中的《CanvasRenderingContext2D.filter》

# 2、示例

我们看上一幅原图：

![原图](https://img-blog.csdnimg.cn/20190821213023529.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTI0MTM1NTE=,size_16,color_FFFFFF,t_70)

## 1）灰度滤镜： 设置filter值为 grayscale(100%)

![灰度滤镜](https://img-blog.csdnimg.cn/20190821215816606.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTI0MTM1NTE=,size_16,color_FFFFFF,t_70)

## 2）褐色： 设置filter值为 sepia（100%）

![褐色滤镜](https://img-blog.csdnimg.cn/20190821213909598.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTI0MTM1NTE=,size_16,color_FFFFFF,t_70)

## 3)  复合滤镜

可以使用多个滤镜，值之间用空格隔开，如：contrast(150%) saturate(200%)

![复合滤镜](https://img-blog.csdnimg.cn/2019082121524111.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTI0MTM1NTE=,size_16,color_FFFFFF,t_70)

利用复合滤镜，我们可以更灵活的变换地图风格，是不是挺好玩，大家可以下来试试。

# 3、完整代码

js代码

```js

var app = {
    baseLayer: undefined,
    map: undefined,
    filter: 'none',
    key: undefined,
    init: function(){
        this.baseLayer = new ol.layer.Tile({
            source: new ol.source.XYZ({
                url: 'https://map.geoq.cn/ArcGIS/rest/services/ChinaOnlineStreetPurplishBlue/MapServer/tile/{z}/{y}/{x}'
            })
        });

        this.map = new ol.Map({
            target: 'map',
            view: new ol.View({
                projection: 'EPSG:4326',
                center: [118, 36],
                zoom: 7
            }),
            layers: [this.baseLayer]
        });

        this.map.on('precompose', function(evt){
            let ctx = evt.context;
            ctx.filter = this.filter;
        }.bind(this))
    }
}

app.init();


function fs(type){
    switch (type) {
        //反色
        case 'invert':
            type = 'invert' + '(100%)'
            break;
        //褐色
        case 'sepia':
                type = 'sepia' + '(100%)'
                break;
        //灰度
        case 'grayscale':
            type = 'grayscale' + '(100%)'
            break;
        //复合
        case 'complex':
                type = 'contrast(150%) saturate(200%)'
                break;
        //默认
        default:
            type = 'none';
            break;
    }
    app.filter = type;
    app.map.render();
}
```

html代码

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://openlayers.org/en/v4.6.5/css/ol.css" type="text/css">
    <title>滤镜</title>
    <script src="https://openlayers.org/en/v4.6.5/build/ol.js"></script>
    <style>
        head,body, #map{
            height: 100%;
            width: 100%;
            margin: 0%;
            padding: 0%;
        }
        .ol-attribution{
            display: none;
        }
        .ol-zoom{
            display: none;
        }
        .input-group-btn{
            top: 2%;
            left: 1%;
            z-index: 1;
            position: absolute;
        }
    </style>
</head>
<body>
    <div id="app">
        <div id="map"></div>        
        <div class="input-group-btn">
            <button type="button" class="btn btn-default" onclick="fs('invert')">反色</button>
            <button type="button" class="btn btn-default" onclick="fs('sepia')">褐色</button>
            <button type="button" class="btn btn-default" onclick="fs('grayscale')">灰度</button>
            <button type="button" class="btn btn-default" onclick="fs('complex')">复合滤镜</button>
            <button type="button" class="btn btn-default" onclick="fs('none')">原色</button>
        </div>
    </div>
    <script src="./app.js"></script>
</body>
</html>
```

# 4、precompose事件

需要说明的是，precompose事件不仅仅只有map对象有，ol.layer.vector对象也具备这个事件，因此如果需要对图层进行滤镜操作，可以试试在layer的precompose事件中进行。
另外，也可以利用渲染事件中的上下文，实现图层的阴影效果。有兴趣尝试一下吧！