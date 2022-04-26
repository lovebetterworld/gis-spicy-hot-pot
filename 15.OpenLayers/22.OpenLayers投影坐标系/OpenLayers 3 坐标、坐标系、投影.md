- [OpenLayers 3 坐标、坐标系、投影_大树下躲雨的博客-CSDN博客_openlayers默认坐标系](https://blog.csdn.net/weixin_43521890/article/details/121854460)

## 一、坐标

代码中我们常见到的[数组](https://so.csdn.net/so/search?q=数组&spm=1001.2101.3001.7020) [0,0] 就是我们常说的坐标

![在这里插入图片描述](https://img-blog.csdnimg.cn/586d9cdb01914ed993e913d0cec5b354.png)

坐标是一个包含两个元素的数组，第一个元素代表地图上的x坐标，第二个元素代表地图上的y坐标。通过x坐标和y坐标我们就可以定位到地图上的任何一个位置

## 二、坐标系

学过地理知识都知道，地球并不是一个完全规则的球体。在不同的地区，为了在数学上表示它，就出现了多种不同的参考椭球体，比如克拉索夫斯基(Krasovsky)椭球体，WGS1984椭球体，更多的椭球体参见[参考椭球体](https://zh.wikipedia.org/wiki/参考椭球体)。在参考椭球体的基础上，就发展出了不同的地理坐标系，比如我国常用的WGS84，北京54，西安80坐标系，欧洲，北美也有不同的坐标系。北京54使用的是克拉索夫斯基(Krasovsky)椭球体，WGS84使用的是WGS1984椭球体。由此可见，多个坐标系是源于地理的复杂性。

由于存在着多种坐标系，即使同样的坐标，在不同的坐标系中，也表示的是不同的位置，这就是大家经常遇到的偏移问题的根源，要解决这类问题，就需要纠偏，把一个坐标系的坐标转换成另一个坐标系的坐标。

## 三、投影

投影是为了把不可展的椭球面描绘到平面上，它使用几何透视方法或数学分析的方法，将地球上的点和线投影到可展的曲面(平面、园柱面或圆锥面)上，再将此可展曲面展成平面，建立该平面上的点、线和地球椭球面上的点、线的对应关系。正是因为有投影，大家才能在网页上看到二维平面的地球地图

投影方式也多种多样，其中有一种投影叫墨卡托投影(Mercator Projection)，广泛使用于网页地图，对于OpenLayers 3的开发者而言，尤其重要，详情参见[墨卡托投影](http://baike.baidu.com/view/301981.htm)。

## 四、使用不同坐标系和投影的定位的地图

#### 1、指定投影使用坐标系EPSG:4326

```javascript
view: new ol.View({
    center: [104.06, 30.67],   // 设置地图显示中心
    projection: 'EPSG:4326',  // 指定投影使用坐标系EPSG:4326
    zoom: 10
}),
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/6ab8ad56f2954670a2826976c7aebcb2.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5aSn5qCR5LiL6Lqy6Zuo,size_20,color_FFFFFF,t_70,g_se,x_16)

#### 2、指定投影使用坐标系EPSG:3857

```javascript
view: new ol.View({
    center: [104.06, 30.67],   // 设置地图显示中心
    projection: 'EPSG:3857',  // 指定投影使用坐标系EPSG:3857
    zoom: 10
}),
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/1a84817d73e340c2a2895ec4e5611189.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5aSn5qCR5LiL6Lqy6Zuo,size_20,color_FFFFFF,t_70,g_se,x_16)

## 五、OpenLayers 3使用的坐标系

#### 1、默认坐标系

OpenLayers 3默认使用的是`EPSG:3857`。

#### 2、支持的坐标系

OpenLayers 3支持两种投影，一个是`EPSG:4326`(全球通用)，等同于WGS84坐标系，参见[详情](http://spatialreference.org/ref/epsg/wgs-84/)。另一个是`EPSG:3857`(web地图专用)，等同于900913，由Mercator投影而来，经常用于web地图，参见[详情](http://spatialreference.org/ref/sr-org/7483/)。

#### 3、坐标系的转换和使用

由于OpenLayers 3默认使用的是`EPSG:3857`，OpenLayers 3 若想使用`EPSG:4326`，有两种方式：

（1）直接指定

```javascript
view: new ol.View({
    center: [104.06, 30.67],   // 设置地图显示中心
    projection: 'EPSG:4326',  // 指定投影使用坐标系EPSG:4326
    zoom: 10
}),
```

（2）`EPSG:4326`转`EPSG:3857`

```javascript
view: new ol.View({
    // 设置成都为地图中心，此处进行坐标转换， 把 EPSG:4326 的坐标，转换为 EPSG:3857 坐标，因为>OpenLayers 3默认使用的是 EPSG:3857 坐标
    center: ol.proj.transform([104.06, 30.67], 'EPSG:4326', 'EPSG:3857'),
    zoom: 10            //设置地图显示层级为10
}),
```

## 六、代码

#### 1、地图项目结构

![[外链图片转存失败,源站可能有防盗链机制,建议将图片保存下来直接上传(img-W1E5Sz31-1639115740907)(C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20211209132249105.png)]](https://img-blog.csdnimg.cn/b389912927db43c58a333d00db5b1810.png)

#### 2、map.html

```html
<!Doctype html>
<html xmlns='http://www.w3.org/1999/xhtml'>
<head>
    <meta http-equiv='Content-Type' content='text/html;charset=utf-8'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'>
    <meta content='always' name='referrer'>
    <title>OpenLayers 3 :创建一个地图</title>
    <link href='ol.css ' rel='stylesheet' type='text/css'/>
    <script type='text/javascript' src='ol.js' charset='utf-8'></script>
</head>

<body>

<div id='map' style='width: 1000px;height: 800px;margin: auto'></div>

<script>

    /**
     *  创建地图
     */
    new ol.Map({

        // 设置地图图层
        layers: [

            //创建一个使用Open Street Map地图源的图层
            new ol.layer.Tile({
                source: new ol.source.OSM()
            })

        ],

        // 设置显示地图的视图
        view: new ol.View({
            center: [0,0],       // 设置地图显示中心于经度0度，纬度0度处
            zoom: 10            // 设置地图显示层级为0
        }),

        // 设置显示地图的视图
        // view: new ol.View({
        //     // 设置成都为地图中心，此处进行坐标转换， 把 EPSG:4326 的坐标，转换为 EPSG:3857 坐标，因为>OpenLayers 3默认使用的是 EPSG:3857 坐标
        //     center: ol.proj.transform([104.06, 30.67], 'EPSG:4326', 'EPSG:3857'),
        //     zoom: 10            //设置地图显示层级为10
        // }),


        //设置显示地图的视图
        // view: new ol.View({
        //     center: [104.06, 30.67],   // 设置地图显示中心
        //     projection: 'EPSG:4326',  // 指定投影使用坐标系EPSG:4326
        //     zoom: 10
        // }),

        //设置显示地图的视图
        // view: new ol.View({
        //     center: [104.06, 30.67],   // 设置地图显示中心
        //     projection: 'EPSG:3857',  // 指定投影使用坐标系EPSG:3857
        //     zoom: 10
        // }),



        // 让id为map的div作为地图的容器
        target: 'map'

    })

</script>
</body>
</html>
```