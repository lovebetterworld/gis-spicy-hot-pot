- [OpenLayers 3 View 简单应用_大树下躲雨的博客-CSDN博客](https://blog.csdn.net/weixin_43521890/article/details/121904251)

# View简单应用

视图View除了设置地图中心，还可设置地图显示范围和地图缩放级别

## 一、设置地图显示范围

#### 1、地图项目结构

![在这里插入图片描述](https://img-blog.csdnimg.cn/1b8cf2ccfb54499fbd79cad12b244c55.png)

#### 2、核心代码

```javascript
// 设置显示地图的视图
view: new ol.View({

    //设置成都为地图中心
    center: [104.06, 30.67],

    /**
             *  根据中心设置地图显示范围
             *  注：此时设置的显示层级会失效
             *
             *  extent参数类型为包含四个元素的数组：[minX, minY, maxX, maxY]
             *      第一个元素，最小x轴坐标
             *      第二个元素，最小y轴坐标
             *      第三个元素，最大x轴坐标
             *      第四个元素，最大y轴坐标
             */
    extent: [102, 29, 104, 31],

    //指定投影
    projection: 'EPSG:4326',

    //此时设置的显示层级会失效
    zoom: 2
}),
```

#### 3、map.html

```html
<!Doctype html>
<html xmlns=http://www.w3.org/1999/xhtml>
<head>
    <meta http-equiv=Content-Type content="text/html;charset=utf-8">
    <meta http-equiv=X-UA-Compatible content="IE=edge,chrome=1">
    <meta content=always name=referrer>
    <title>OpenLayers 3:设置地图显示范围</title>
    <link href="ol.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript" src="ol.js" charset="utf-8"></script>
</head>

<body>
<div id="map" style="width: 800px;height: 1000px;margin: auto"></div>
<script>

    // 创建地图
    new ol.Map({

        // 设置地图图层
        layers: [
            // 创建一个使用Open Street Map地图源的瓦片图层
            new ol.layer.Tile({
                source: new ol.source.OSM()
            })
        ],

        // 设置显示地图的视图
        view: new ol.View({

            //设置成都为地图中心
            center: [104.06, 30.67],

            /**
             *  根据中心设置地图显示范围
             *  注：此时设置的显示层级会失效
             *
             *  extent参数类型为包含四个元素的数组：[minX, minY, maxX, maxY]
             *      第一个元素，最小x轴坐标
             *      第二个元素，最小y轴坐标
             *      第三个元素，最大x轴坐标
             *      第四个元素，最大y轴坐标
             */
            extent: [102, 29, 104, 31],

            //指定投影
            projection: 'EPSG:4326',

            //此时设置的显示层级会失效
            zoom: 2
        }),

        // 让id为map的div作为地图的容器
        target: 'map'

    });

</script>
</body>

</html>
```

## 二、设置地图缩放级别

#### 1、核心代码

```javascript
// 设置显示地图的视图
view: new ol.View({
    //设置成都为地图中心
    center: [104.06, 30.67],
    //指定投影
    projection: 'EPSG:4326',
    //设置地图初始缩放级别
    zoom: 10
    // 设置地图缩放最小级别为10
    minZoom: 10,
    //设置地图缩放最大级别为14
    maxZoom: 14
}),
```

#### 1、map2.html

```html
<!Doctype html>
<html xmlns=http://www.w3.org/1999/xhtml>
<head>
    <meta http-equiv=Content-Type content="text/html;charset=utf-8">
    <meta http-equiv=X-UA-Compatible content="IE=edge,chrome=1">
    <meta content=always name=referrer>
    <title>OpenLayers 3:地图缩放级别设置</title>
    <link href="ol.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript" src="ol.js" charset="utf-8"></script>
</head>

<body>
<div id="map" style="width: 800px;height: 1000px;margin: auto"></div>
<script>

    // 创建地图
    new ol.Map({
        // 设置地图图层
        layers: [
            // 创建一个使用Open Street Map地图源的瓦片图层
            new ol.layer.Tile({
                source: new ol.source.OSM()
            })
        ],

        // 设置显示地图的视图
        view: new ol.View({

            //设置成都为地图中心
            center: [104.06, 30.67],
            //指定投影
            projection: 'EPSG:4326',
            //设置地图初始缩放级别
            zoom: 10
            // 设置地图缩放最小级别为10
            minZoom: 10,
			//设置地图缩放最大级别为14
            maxZoom: 14
        }),
        // 让id为map的div作为地图的容器
        target: 'map'
    });
</script>
</body>
</html>
```