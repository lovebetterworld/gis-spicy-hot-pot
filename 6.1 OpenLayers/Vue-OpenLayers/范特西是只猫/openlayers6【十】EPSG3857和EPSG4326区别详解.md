- [openlayers6【十】EPSG:3857和EPSG:4326区别详解_范特西是只猫的博客-CSDN博客_epsg3857](https://xiehao.blog.csdn.net/article/details/106429109)

## 1. 写在前面

在我之前写的文章中，其实已经涉及到了这一点，就是为什么这里我们要把中心点的坐标用 `fromLonLat()`方法进行包裹。fromLonLat() 方法是继承自`ol.proj` 这个类。

下面是vue页面引入fromLonLat和transform类。

```javascript
import { fromLonLat,transform } from "ol/proj";
```

在 [openlayers](https://so.csdn.net/so/search?q=openlayers&spm=1001.2101.3001.7020) 中创建map时候会有个view 属性，该属性下面会存在一个`center`属性。这个属性就是设置中心位置的坐标。如果不设置就没有中心，也毫无意义。`projection` 属性指定坐标系的类型。一般是4326和3857两种，下面我们就详细讲解下这两个的区别。让你彻底了解及使用。

```javascript
new View({
	projection:'EPSG:3857',//坐标系类型
    center: fromLonLat([104.912777, 34.730746]), //地图中心坐标
});
```

> 更多访问：https://openlayers.org/en/latest/apidoc/module-ol_proj.html

## 2. 什么是EPSG:3857坐标系（投影坐标）

**在`openlayers 中默认的坐标就是google的摩卡托坐标`**，也就是我们经常看到的 `EPSG:3857` 坐标系。

EPSG:3857 的数据一般是这种的。**`[12914838.35,4814529.9]`**，看上去相对数值较大。不利于存储，比较占内存。

## 3. 什么是EPSG:4326 坐标系（地理坐标）

**4326 WGS-84：是国际标准，GPS坐标（Google Earth使用、或者GPS模块）**

EPSG:4326 的数据一般是这种的。**`[22.37，114.05]`**。利于存储，可读性高

所以我们常常看到和用到的`坐标系数据`往往不是墨卡托坐标，而是`EPSG:4326`坐标系下的坐标数据。

因为易读和存储小。比如下面的第三方的阿里[datav](http://datav.aliyun.com/tools/atlas/#&lat=31.80289258670676&lng=104.2822265625&zoom=4) 边界数据源。就是采用的EPSG:4326地理坐标返回。如下：

![在这里插入图片描述](https://img-blog.csdnimg.cn/2020060610594196.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)

## 4. EPSG:4326和EPSG:3857区别（重点）

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200706101338652.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)
我们可以先看下，左图表示地球球面上大小相同的圆形，右上为墨卡托投影，投影后仍然是圆形，但是在高纬度时物体被严重放大了。右下为等距投影，物体的大小变化不是那么明显，但是图像被拉长了。Platte Carre 投影因为在投影上有扭曲，并不适合于航海等活动，但是因为坐标与像素之间的对应关系十分简单，非常适合于栅格图的展示，Platte Carre 投影是很多GIS 软件的默认投影。

需要注意的是，对于墨卡托投影来说，越到高纬度，大小扭曲越严重，到两极会被放到无限大，所以，墨卡托投影无法显示极地地区。下图来自维基百科，可以看到墨卡托投影下每个国家的大小和实际大小的差异。但是 conformality（正形性） 和 straight rhumb lines 这两个特点，让它非常适合于航海导航。
![在这里插入图片描述](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9pbWcyMDE4LmNuYmxvZ3MuY29tL2Jsb2cvMTY1MjIwLzIwMTkwOS8xNjUyMjAtMjAxOTA5MDQxODQ0MzU2MjMtODEzMTEyNjU5LmdpZg)
所有结合上面的图，我们总结下最大区别：

**`EPSG:3857（投影）：数据的可读性差和数值大存储比较占用内存`。
`EPSG:4326（地理）：使用此坐标系会导致页面变形。`**

结合前面所说的内容，我们自己通过实践，继续分析，往下看。

### 4.1 首先看下用EPSG:4326坐标类型去渲染的数据

> 因为使用的 `projection` 是 `"EPSG:4326"` 类型，可以看到 `center` 中的数据格式 也是 `"EPSG:4326"` 的数值格式。所以没有用 fromLonLat() 方法 进行转换得到的图像信息。

```javascript
let view = new View({
    projection: "EPSG:4326", //使用这个坐标系
    center: [104.912777, 34.730746], //地图中心坐标
    zoom: 4.5 //缩放级别
});
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200606112300286.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)

我们发现确实是，好像被压缩了。就验证了我们上面所说的。

### 4.2 我们继续看下用EPSG:3857坐标类型去渲染的数据

> 前面说了默认 是 goole的 摩卡托 `EPSG:3857` 坐标系，所以我们可以不写。但是我们用到的 `center` 数据值格式 是 `EPSG:4326`格式（前面也说了是常见的数据源），所以我们需要使用 `fromLonLat()` 方法把 `EPSG:4326`格式数据转换为 `EPSG:3857` 数据格式

```javascript
let view = new View({
    // projection: "EPSG:3857", //使用这个坐标系，默认为 3857,可以不写
    center: fromLonLat([104.912777, 34.730746]), // 数据格式4326转为3857
    zoom: 4.5 //缩放级别
});
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200606112430820.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)

对比下上面的两种坐标系渲染出来的map，可以明显的看到 `EPSG:4326` 感觉map 地图被上下压缩过一样。而 `EPSG:3857` 坐标系就很正常。这是因为他们的`投影`不同造成的。

所以总结下：在实际开发中，因为map源数据大部分都是EPSG:4326的数据源格式的数据，但是使用EPSG:4326的坐标系地图会出现被压缩的感觉。

所以我们都是采用 EPSG:3857的坐标系类型，把数据源转换位 EPSG:3857的数据源即可。

但是这个EPSG:3857数据源不易读取和值占内存原因，所有结合两者的缺点，我们采用坐标转换，即 EPSG:4326转 EPSG:3857。 

**所有请理解这句话：通常：数据存储在EPSG:4326中，显示在EPSG:3857中**

如下所示：

```js
function anmiteCenter(map, attr, zoom) {
    let pos = [parseFloat(attr.lon), parseFloat(attr.lat)];
    pos = ol.proj.transform(pos, 'EPSG:4326', 'EPSG:3857');
    map.getView().animate({
        center: pos,
        zoom: zoom
    });
}
```

更多参考：[GIS基础知识 - 坐标系、投影、EPSG:4326、EPSG:3857](https://blog.csdn.net/lhjuejiang/article/details/105134063)