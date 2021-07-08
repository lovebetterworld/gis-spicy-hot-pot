- [（十）WebGIS中地理坐标与屏幕坐标间的转换原理](https://www.cnblogs.com/naaoveGIS/p/3930603.html)

## 1.前言

```
地图本身是拥有坐标的，一般可以大致分为平面坐标和经纬度坐标，在这里我们统称为地理坐标，比如北京，(115.9°E ，39.6°N)和(506340，304400)均是其地理坐标，只是表示形式不同而已。
我们在上一章讲解了矢量图层中数据的来源，最后提出了一个还未解决的问题，即当我们获得了矢量数据后，如何在屏幕中将这些数据里的地理（Geometry）坐标转换为屏幕坐标，从而在屏幕端Canvas里的各个UIComponent（要素）中绘制出来？
这一章我们将对此转换做出讲解。
```

## 2.转换前提

```
实现屏幕坐标能与地理坐标进行转换的前提是：
1).知道屏幕的最左上角所对应的真实的地理坐标（screenGeoBounds.left, screenGeoBounds.top）。
2).知道此时的地图所在级别上每个瓦片所对应的实际地理长度(sliceLevelLength)。
3).知道瓦片的大小，即一个瓦片所拥有的屏幕像素(tileSize)。
```

## 3.如何获得这些前提参数

### 3.1 tileSize参数的获取

```
由于此参数为固定参数，所以获取十分简单，与实际中的瓦片大小一致即可。
```

### 3.2 sliceLevelLength参数的获取

```
此参数需要经过一定的算法才能获得，具体算法和原理可以在第三章《通过地理范围获取瓦片行列号》中得到详细的讲解。我这里直接给出公式：
resolution=scale*inch2centimeter/dpi；
sliceLevelLength=tileSize*resolution；
英文代表如下意思：
inch2centimeter：英寸转里面的参数。
Dpi：一英寸所包含的像素。
Resolution：单位像素所代表的实际单位长度。
```

### 3.3 screenGeoBounds的获取

```
此参数的实际意思是屏幕坐标上（0，0）所对应的地理坐标（screenGeoBounds.left, screenGeoBounds.top）。而screenGeoBounds却同时是不确定，动态变化的一个参数值。因为随着地图的平移、放大、缩小操作，此screenGeoBounds均会发生变化。
参考第三章内容（我们整个系统中，第三章的内容均是重点），我们可以知道，每一次我们触发瓦片请求时，都会重新计算出此时的屏幕四角坐标所对应的实际地理坐标。
并且，在以后章节中跟大家探讨WebGIS功能，当讲解地图平移功能时，我们还能了解到，事实上每次地图平移事件发生时，我们的屏幕四角坐标也会加减相同的地理平移量。
```

## 4.转换公式

```
下面我将给出基于tileSize、sliceLevelLength、screenGeoBounds三个参数的地理坐标与屏幕坐标互相转换的公式。
```

### 4.1 屏幕坐标转换为地理坐标

```
geoXY.x = screenGeoBounds.left + screenX * sliceLevelLength / tileSize;
geoXY.y = screenGeoBounds.top - screenY * sliceLevelLength / tileSize;
```

### 4.2 地理坐标转换为屏幕坐标

```
screenXY.x = (geoX - screenGeoBounds.left)/(sliceLevelLength/ tileSize);
screenXY.y = (screenGeoBounds.top - geoY)/(sliceLevelLength/ tileSize);
```

### 4.3 公式的简单解说

```
两个转换公式均是首先算出在屏幕上的一个像素所对应的单位地理长度后，再根据转换需求进行需要的转换。所需要注意的是，在真实的地图上，Y代表的是纬度，其越往上纬度越大，而在屏幕上，Y越往上走反而越小。所以仔细观察两种转换公式中关于纬度和屏幕Y坐标的转换就能发现这一点。
```

## 5.WebGIS中基于坐标转换公式的用法

```
这两个转换公式很多时候是配合使用的。比如有这样一个需求：鼠标点击在地图上后需要查询出鼠标点击处的要素属性信息，并且将该查询到的要素在地图上画出来（其实此需求是一个I查询的需求）。
我们的实现方法是先将鼠标点击处的屏幕坐标转换为地理坐标，然后加上tolerance后拼成一个Geometry范围，从前端发出I查询的请求URL，通过地理服务器得到返回的矢量数据，再在前端将矢量数据中的地理坐标转换为屏幕坐标，根据此屏幕坐标在UIComponent里绘出要素，并将矢量数据中携带的Atrributes进行解析作为查询所得的属性数据。
以下为此过程的流程图：
```

 ![img](https://images0.cnblogs.com/blog/656746/201408/230733055189143.png)

## 6.总结

在此章中，我们知道了如何将得到的矢量数据里的地理坐标转换为屏幕坐标，接下来我们要做的事情是在UIComponent中基于得到的屏幕坐标，绘制出要素的shape。