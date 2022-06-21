- [OpenLayers学习二：点标记的添加删除和修改（以类为接口）_路人甲JIA的博客-CSDN博客_openlayers 添加点](https://blog.csdn.net/u013719339/article/details/77898613)

我每一个功能都用了一个单独的JS文件，并且是以类为接口的方式。

 OpenLayer添加点标记的顺序是：Map —— [Layer](https://so.csdn.net/so/search?q=Layer&spm=1001.2101.3001.7020) —— Source —— Feature (Style) —— Geometry

 上面从大到小，Geometry就是设置经纬度了。

1.设置Layer和Source

```javascript
/** 设置点图层 */
var markVectorSource = new ol.source.Vector();
var markVectorLayer = new ol.layer.Vector({
    source: markVectorSource
});
```

2.设置Geometry和Feature

 我们常用的坐标系是WGS84，对应过来空间坐标系是EPSG:4326，但OpenLayers默认示例是EPSG:900913。所以经纬度必须经过转换。

```javascript
var iconFeature = new ol.Feature({
    //geometry: new ol.geom.Point(markSettings.markCoordinate)
    geometry: new ol.geom.Point(ol.proj.fromLonLat(markSettings.markCoordinate))//纬度 经度
});
```

3.设置Style

 其中，src与img只需要设置一个值。src是一个字符串，为引用图片的路径，而img是指真正的图片，也就是html中的<img>，但不能直接把<img>放进去，而是要先添加到地图中的Canvas上，然后再在此处调用。imgSize用来定义img属性的大小，如果img未定义，那它也必须未定义。

```javascript
var iconStyle = new ol.style.Style({
    image: new ol.style.Icon(/** @type {olx.style.IconOptions} **/({
        anchor: markSettings.markAnchor, //点图片偏移量
        src: markSettings.markImage, //图片路径
        img: undefined, //图片
        imgSize: undefined
    }))
});
```

4.添加到Map

```javascript
iconFeature.setStyle(iconStyle);
markVectorSource.addFeature(iconFeature);
map.removeLayer(markVectorLayer);
map.addLayer(markVectorLayer);
```

5.删除点，需要先从Feature里移除icon，然后再移除图层，如果不从Feature里移除icon而直接移除图层，则同一个实例化方法中icon一直存在，只是由于图层不存在而未在地图上显示出来。

```javascript
markVectorSource.removeFeature(iconFeature);
map.removeLayer(markVectorLayer);
```

6.改变样式

```javascript
iconFeature.setStyle(new ol.style.Style({
    image: new ol.style.Icon(/** @type {olx.style.IconOptions} */({
        anchor: markSettings.markAnchor,
        src: markImage,
        img: undefined,
        imgSize: undefined
    }))
}));
```

综合以上，完整的点标记的类的代码为 SetMark.js：

```javascript
var SetMark = (function() {
    /** 设置点图层 */
    var markVectorSource = new ol.source.Vector();
    var markVectorLayer = new ol.layer.Vector({
        source: markVectorSource
    });
    var SetIcon = function(markOptions){
        var markSettings = $.extend({
            markCoordinate: [0, 0],
            markAnchor: [0.5, 0.96],
            markImage: 'https://openlayers.org/en/v4.0.1/examples/data/icon.png',
        }, markOptions);  //传参变量
        var iconFeature = new ol.Feature({
            //geometry: new ol.geom.Point(markSettings.markCoordinate)
            geometry: new ol.geom.Point(ol.proj.fromLonLat(markSettings.markCoordinate))//纬度 经度
        });
        /** 创建点图标 */
        this.createMark = function () {
            var iconStyle = new ol.style.Style({
                image: new ol.style.Icon(/** @type {olx.style.IconOptions} **/({
                    anchor: markSettings.markAnchor,
                    src: markSettings.markImage,
                    img: undefined,
                    imgSize: undefined
                }))
            });
            iconFeature.setStyle(iconStyle);
            markVectorSource.addFeature(iconFeature);
            map.removeLayer(markVectorLayer);
            map.addLayer(markVectorLayer);
            /** 选择点 */
            if (true) {
                var selectStyle = {};
                var select = new ol.interaction.Select({
                    style: function(feature) {
                        var image = feature.get('style').getImage().getImage();
                        if (!selectStyle[image.src]) {
                            var canvas = document.createElement('canvas');
                            var context = canvas.getContext('2d');
                            canvas.width = image.width;
                            canvas.height = image.height;
                            context.drawImage(image, 0, 0, image.width, image.height);
                            var imageData = context.getImageData(0, 0, canvas.width, canvas.height);
                            var data = imageData.data;
                            for (var i = 0, ii = data.length; i < ii; i = i + (i % 4 == 2 ? 2 : 1)) {
                                data[i] = 255 - data[i];
                            }
                            context.putImageData(imageData, 0, 0);
                            selectStyle[image.src] = createStyle(undefined, canvas);
                        }
                        return selectStyle[image.src];
                    }
                });
                map.addInteraction(select);
                map.on('pointermove', function(evt) {
                    map.getTargetElement().style.cursor =
                        map.hasFeatureAtPixel(evt.pixel) ? 'pointer' : '';
                });
            }
        }
        /** 删除点 */
        this.deleteMark = function () {
            markVectorSource.removeFeature(iconFeature);
            map.removeLayer(markVectorLayer);
        }
        /** 修改点图片 */
        this.changeMark = function (markImage) {
            iconFeature.setStyle(new ol.style.Style({
                image: new ol.style.Icon(/** @type {olx.style.IconOptions} */({
                    anchor: markSettings.markAnchor,
                    src: markImage,
                    img: undefined,
                    imgSize: undefined
                }))
            }));

            /** 使用img和imgSize来改变图片 */
            // var markIcon = new Image();
            // markIcon.src = markImage;
            // markIcon.width = 70;
            // markIcon.height = 70;
            // //markIcon.hidden = true;
            // var markPicture = document.getElementsByClassName("ol-unselectable")[0].appendChild(markIcon);
            // iconFeature.setStyle(new ol.style.Style({
            //     image: new ol.style.Icon(/** @type {olx.style.IconOptions} */({
            //         anchor: markSettings.markAnchor,
            //         src: undefined,
            //         img: markIcon,
            //         imgSize: [markIcon.width, markIcon.height]
            //     }))
            // }));

            /** 等比例缩小图片 */
            // if( markIcon.width> 70) {
            //     var scaling = 1-(markIcon.width-70)/markIcon.width;
            //     //计算缩小比例
            //     markIcon.width = markIcon.width * scaling;
            //     markIcon.height = markIcon.height * scaling;
            // }
        }
    }
    return SetIcon;
})()
```

实例化上面的类，就可以使用了 Function.js

```javascript
/** add mark
 * para
 * var mark = new SetMark({
        markCoordinate: [0, 0],
        markAnchor: [0.5, 0.96],
        markImage: 'https://openlayers.org/en/v4.0.1/examples/data/icon.png',
    });
 **/
/** add one point **/
function MarkTesting() {
    var mark = new SetMark({
        markCoordinate: [80, -50]
    });
    $("#addOneMark").click(function () {
        mark.createMark();
        //mark.addClick();
    });
    $("#delOneMark").click(function () {
        mark.deleteMark();
    });
    $("#chaOneMark").click(function () {
        mark.changeMark('timg.png');
    });
}
MarkTesting();
/** add two points **/
function MarksTesting() {
    var mark = new Array();
    var markID = new Array();  // [[坐标对], 存放序号] 删除或修改某一个点时
    var markCoordinates = [[0,0], [50, 60], [10, 80]];
    var len = markCoordinates.length;
    for (var i = 0; i < len; i++) {
        mark[i] = new SetMark({
            markCoordinate: markCoordinates[i]
        });
        markID[i] = [markCoordinates[i], i];
        var k  = 0;
    }
    $("#addMoreMark").click(function () {
        for (var i = 0; i < len; i++) {
            mark[i].createMark();
            //mark[1].addClick();
        }
    });
    $("#delMoreMark").click(function () {
        for (var i = 0; i < len; i++) {
            mark[i].deleteMark();
        }
    });
    $("#chaMoreMark").click(function () {
        for (var i = 0; i < len; i++) {
            mark[i].changeMark('123.png');
        }
    });
}
MarksTesting();
```

HTML部分为：CommonVariable.js 和 SetMap.js见[OpenLayers3学习一：地图加载（以类为接口）](http://blog.csdn.net/u013719339/article/details/77898952)

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>OpenLayers3Exercise1</title>
    <link rel="stylesheet" href="ol.css" type="text/css">
    <script src="ol.js"></script>
    <script src="http://code.jquery.com/jquery-3.2.1.min.js"></script>
</head>
<body>
    <div id="map" class="map"></div>
    <button id="addOneMark">添加一个点</button>
    <button id="addMoreMark">添加多个点</button>
    <button id="delOneMark">删除一个点</button>
    <button id="delMoreMark">删除多个点</button>
    <button id="chaOneMark">改变一个图标</button>
    <button id="chaMoreMark">改变多个图标</button>
 
    <script type="text/javascript" src="CommonVariable.js"></script>
    <script type="text/javascript" src="SetMap.js"></script>
    <script type="text/javascript" src="SetMark.js"></script>
 
    <script type="text/javascript" src="Function.js"></script>
</body>
</html>
```