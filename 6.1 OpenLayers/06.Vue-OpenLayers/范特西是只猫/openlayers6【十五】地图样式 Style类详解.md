- [openlayers6【十五】地图样式 Style类详解_范特西是只猫的博客-CSDN博客_openlayers style](https://xiehao.blog.csdn.net/article/details/107152946)

## 1. 写在前面

地图样式是由 style 类控制的，其包含了地图样式的方方面面，例如，填充色、图标样式、图片样式、规则图形样式、边界样式、文字样式等，样式一般针对矢量要素图层。

了解更多[矢量图](https://so.csdn.net/so/search?q=矢量图&spm=1001.2101.3001.7020)层可以参考：[openlayers6【十三】地图矢量图层 Vector 详解](https://blog.csdn.net/qq_36410795/article/details/107037647)

## 2. ol.style 属性及[子类](https://so.csdn.net/so/search?q=子类&spm=1001.2101.3001.7020)

### 2.1 可以配置的选项

```js
/*
 * @typedef {{
 * 	   geometry: (undefined|string|ol.geom.Geometry|ol.style.GeometryFunction),
 *     fill: (ol.style.Fill|undefined),
 *     image: (ol.style.Image|undefined),
 *     stroke: (ol.style.Stroke|undefined),
 *     text: (ol.style.Text|undefined),
 *     zIndex: (number|undefined)
 * }}
 * /
```

geometry：要素的属性，或者要素，或者一个返回一个地理要素的函数，用来渲染成相应的地理要素；

fill：填充要素的样式；

stroke：要素边界样式，类型为 ol.style.Stroke；

image：图片样式，类型为 ol.style.Image；

text：要素文字的样式，类型为 ol.style.Text；

zIndex：CSS中的zIndex，即叠置的层次，为数字类型。

### 2.2 子类（针对矢量要素）

ol.style.Circle，针对矢量要素设置圆形的样式，继承 ol.style.Image；

ol.style.Icon，针对矢量数据设置图标样式，继承 ol.style.Image；

ol.style.Fill，针对矢量要素设置填充样式；

ol.style.RegularShape，对矢量要素设置规则的图形样式，如果设置 radius，结果图形是一个规则的多边形，如果设置 radius1 和 radius2，结果图形将是一个星形；

ol.style.Stroke，矢量要素的边界样式；

ol.style.Text，矢量要素的文字样式。

```js
// 在vue中导入相关类，后面栗子会使用到
import {
    Style,
    Circle,
    Icon,
    Fill,
    RegularShape,
    Stroke,
    Text,
} from "ol/style";
```

## 3. ol.style 样式举栗详解

矢量图层样式可以事先写好，写成静态的，矢量图层直接按照定义好的样式渲染，也可以动态使用样式的 `setStyle()` 方法，但是要注意刷新矢量图层，重新渲染，否则动态样式不生效。

我们通过`ol.style`实现下面的一个常用功能。

**一：先下面先准备一个矢量图层**

```js
// 先设置图层
let routeLayer = new VectorLayer({
    source: new VectorSource({
        features: features //这里的features就是矢量图层
    })
});
// 添加图层到地图上
this.map.addLayer(routeLayer);
```

**二：矢量图层有了，我们通过`geoJson`数据创建`geometry`地理信息**

这个数据自己通过 [阿里云geoData](http://datav.aliyun.com/tools/atlas/#&lat=31.769817845138945&lng=104.29901249999999&zoom=4) 下载静态数据到自己本地在引入即可

```js
import areaGeo from "@/geoJson/china.json";
```

**三：好了，图层和数据都有了，外面可以使用Style的属性来渲染矢量图层啦**

### 3.1 geometry：要素的属性

- `MultiPolygon`和`Polygon`两种方式去解析
- transform 4326转3857 ，不懂可以我之前写的文章 [EPSG:3857和EPSG:4326坐标转换](https://blog.csdn.net/qq_36410795/article/details/107151438)

```js
// 获取边界的经纬度数据
let features = [];
let routeFeature = null;
areaGeo.forEach(g => {
    let lineData = g.features[0];
    if (lineData.geometry.type == "MultiPolygon") {
        routeFeature = new Feature({
            geometry: new MultiPolygon(
                lineData.geometry.coordinates
            ).transform("EPSG:4326", "EPSG:3857")
        });
    } else if (lineData.geometry.type == "Polygon") {
        routeFeature = new Feature({
            geometry: new Polygon(
                lineData.geometry.coordinates
            ).transform("EPSG:4326", "EPSG:3857")
        });
    }
});
features.push(routeFeature);
```

通过geoJson数据渲染后，添加到图层上就可以有地图的矢量图层了，但是因为什么样式都没有，所有看不出效果，下面我们设置一些样式把。

### 3.2. fill ：填充样式

- color 可以为6进制也可以为rgba格式的值

```js
routeFeature.setStyle(
    new Style({
        fill: new Fill({ color: "#4e98f444" }),
    })
);
```

可以看到我们根据`geometry`渲染的地图之前是看不出效果的，填充`fill`样式之后的地图已经填充了一层颜色样式

![在这里插入图片描述](https://img-blog.csdnimg.cn/202007061159233.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)

```js
new Style({
	// 或者使用rgba格式
   fill: new Fill({ color: [178, 99, 37, 0.5] })
})
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200717103054186.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)

### 3.3 stroke：边界线条

- width 边界的宽度
- color 边界的颜色

```js
new Style({
    fill: new Fill({ color: "#4e98f444" }),
    stroke: new Stroke({
        width: 3,
        color: [71, 137, 227, 1]
    })
})
```

效果如图

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200706120241783.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)

改变 width 线条加粗效果

```js
stroke: new Stroke({
        width: 10,
        color: [71, 137, 227, 1]
    })
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200717103256787.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)

### 3.4 image：图片样式

> vue 项目中使用 `require` 方式引入图片

- image
  - src
  - …其他属性（比如偏移度等…）

```js
getIcon() {
    var styleIcon = new Style({
        // 设置图片效果
        image: new Icon({
            src: require("../../assets/images/img-bule.png"),
        })
    });
    return styleIcon;
},
```

其实图片设置也是一个矢量图层。样式主要针对矢量图层（[vector](https://so.csdn.net/so/search?q=vector&spm=1001.2101.3001.7020) layer），矢量图层中包含一个或多个要素（feature），要素中包含一个地理属性（geometry）表示地理位置，还可能包含一个或多个其他属性，比如要素的名称、类型等等，要素可以使用单独的样式，这时候要使 feature.setStyle(ol.style.Style) 来设置单独使用的样式，否则直接继承矢量图层的样式。

```js
let feature = new Feature({
   geometry: new Point(
        fromLonLat([102.741896, 30.839974])
    )
});
feature.setStyle(this.getIcon());
```

得到结果是，在[102.741896, 30.839974]坐标处显示一个图标，如图：

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200706121833850.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)

### 3.5. text - 文字

设置矢量图层中的各个要素中要显示的文字的字体类型，线条填充颜色，线条边界颜色，因为文字的线条本身就具有宽度，所以有填充色和边界颜色说法。如下面的例子，设置了文字的大小、字体、填充色和边界颜色：（下面以聚合数据文字为例子）

- text 文字内容（我这里是聚合数量）
- fill 填充颜色
- font 文字的大小和文字字体
- stroke 文字描边样式

```js
text: new Text({
    text: total.toString(), 
    fill: new Fill({ 
        color: "#FFF"
    }),
    font: "18px Calibri,sans-serif", 
    stroke: new Stroke({
        color: "red",
        width: 5
    })
})
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200717094708911.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)

### 3.6. ol.style 设置动态样式

`动态样式也成为条件样式`，条件样式是将样式配置为一个回调函数方法，其参数包含要素本身和分辨率，可以根据要素本身的属性和地图的分辨率，显示动态的样式:
形式如 style: function(feature, resolution) {}。

业务场景一：以下代码段配置当分辨率小于 5000 时候，在要素上显示一个标签，标识要素名称：
在缩放地图的时候会根据像素去显示和隐藏名称标签。

```js
style: function(feature, resolution) {
    style.getText().setText(resolution < 5000 ? feature.get('name') : '');
    return styles;
}
```

这种业务场景在openlayer 里面是经常会涉及到的。会让你的地图更加丰富和充满交互感。

## 4. 写在最后

样式主要针对矢量图层数据，既可以配置一个全局的样式，也可以针对每个feature单独配置；既可以应用统一的样式，也可以根据要素和分辨率应用条件样式。样式应用是非常灵活的。

另外，样式是可以多个一起起作用的，就如同 HTML 的元素样式类 class 可以有多个一样。如下例子中，就应用了两个样式，一个是应用于多边形本身，另一个用于绘制每个多边形的顶点：

```js
var styles = [
  new Style({
    stroke: new Stroke({
      color: 'blue',
      width: 3
    }),
    fill: new Fill({
      color: 'rgba(0, 0, 255, 0.1)'
    })
  }),
  new Style({
    image: new Circle({
      radius: 5,
      fill: new Fill({
        color: 'orange'
      })
    }),
    geometry: function(feature) {
      // return the coordinates of the first ring of the polygon
      var coordinates = feature.getGeometry().getCoordinates()[0];
      return new MultiPoint(coordinates);
    }
  })
];
```