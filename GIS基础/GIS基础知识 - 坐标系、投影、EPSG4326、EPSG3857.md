- [GIS基础知识 - 坐标系、投影、EPSG:4326、EPSG:3857](https://www.cnblogs.com/E7868A/p/11460865.html)

# 1. 大地测量学 (Geodesy)

[大地测量学](https://en.wikipedia.org/wiki/Geodesy)是一门量测和描绘地球表面的学科，也包括确定地球重力场和海底地形。

## 1.1 大地水准面 (geoid)

[大地水准面](https://en.wikipedia.org/wiki/Geoid)是**海洋表面**在排除风力、潮汐等其它影响，只考虑重力和自转影响下的形状，这个形状延伸过陆地，生成一个密闭的曲面。虽然我们通常说地球是一个球体或者椭球体，但是由于地球引力分布不均（因为密度不同等原因），大地水准面是一个不规则的光滑曲面。虽然不规则，但是可以近似地表示为一个椭球体，这个椭球体被 称为[参考椭球体（Reference ellipsoid）](https://en.wikipedia.org/wiki/Reference_ellipsoid)。大地水准面相对于参考椭球体的高度被称为 **Undulation of the geoid** 。这个波动并不是非常大，最高在冰岛为85m，最低在印度南部为 −106 m，一共不到200m。下图来自[维基百科](https://en.wikipedia.org/wiki/Geoid)，表示 EGM96 geoid 下不同地区的 Undulation。

![img](https://img2018.cnblogs.com/blog/165220/201909/165220-20190904132051915-475643758.png)

##  1.2 参考椭球体（Reference ellipsoid）

[参考椭球体（Reference ellipsoid）](https://en.wikipedia.org/wiki/Reference_ellipsoid)是一个数学上定义的地球表面，它近似于大地水准面。因为是几何模型，可以用长半轴、短半轴和扁率来确定。我们通常所说的经度、纬度以及高度都以此为基础。

一方面，我们对地球形状的测量随着时间迁移而不断精确，另一方面，因为大地水准面并不规则，地球上不同地区往往需要**使用不同的参考椭球体**，来尽可能适合当地的大地水准面。历史上出现了很多不同的参考椭球体，很多还仍然在使用中。国内过去使用过“北京54”和“西安90”两个坐标系，其中北京54使用的是克拉索夫斯基（Krasovsky）1940的参考椭球，西安80使用的是1975年国际大地测量与地球物理联合会第16届大会推荐的参考椭球。当前世界范围内更普遍使用的是WGS所定义的参考椭球。

# 2. 坐标系（coordinate system）

有了参考椭球体这样的几何模型后，就可以定义坐标系来进行描述位置，测量距离等操作，使用相同的坐标系，可以保证同样坐标下的位置是相同的，同样的测量得到的结果也是相同的。通常有两种坐标系 地理坐标系（geographic coordinate systems） 和 投影坐标系（projected coordinate  systems）。

## 2.1 地理坐标系（Geographic coordinate system）

地理坐标系一般是指由经度、纬度和高度组成的坐标系，能够标示地球上的任何一个位置。前面提到了，不同地区可能会使用不同的参考椭球体，即使是使用相同的椭球体，也可能会为了让椭球体更好地吻合当地的大地水准面，而调整椭球体的方位，甚至大小。这就需要使用不同的大地测量系统（**Geodetic datum**）来标识。因此，对于地球上某一个位置来说，使用不同的测量系统，得到的坐标是不一样的。我们在处理地理数据时，必须先确认数据所用的测量系统。事实上，随着我们对地球形状测量的越来越精确，北美使用的 NAD83 基准和欧洲使用的 ETRS89 基准，与 WGS 84 基准是基本一致的，甚至我国的 CGCS2000  与WGS84之间的差异也是非常小的。但是差异非常小，不代表完全一致，以 NAD83 为例，因为它要保证北美地区的恒定，所以它与 WGS84  之间的差异在不断变化，对于美国大部分地区来说，每年有1-2cm的差异。

## 2.2 投影坐标系（Projected coordinate systems）

地理坐标系是三维的，我们要在地图或者屏幕上显示就需要转化为二维，这被称为[投影（Map projection）](https://en.wikipedia.org/wiki/Map_projection)。显而易见的是，从三维到二维的转化，必然会导致变形和失真，失真是不可避免的，但是不同投影下会有不同的失真，这让我们可以有得选择。常用的投影有[等矩矩形投影](https://en.wikipedia.org/wiki/Equirectangular_projection)（Platte Carre）和[墨卡托投影](https://en.wikipedia.org/wiki/Mercator_projection)（Mercator），下图来自[Mercator vs. well…not Mercator (Platte Carre)](https://idvux.wordpress.com/2007/06/06/mercator-vs-well-not-mercator-platte-carre/)，生动地说明了这两种投影下的失真：

![img](https://img2018.cnblogs.com/blog/165220/201909/165220-20190904172204757-1850337732.png)

左图表示地球球面上大小相同的圆形，右上为墨卡托投影，投影后仍然是圆形，但是在高纬度时物体被严重放大了。右下为等距投影，物体的大小变化不是那么明显，但是图像被拉长了。Platte Carre 投影因为在投影上有扭曲，并不适合于航海等活动，但是因为坐标与像素之间的对应关系十分简单，非常适合于栅格图的展示，Platte  Carre 投影是很多GIS 软件的默认投影。

需要注意的是，对于墨卡托投影来说，越到高纬度，大小扭曲越严重，到两极会被放到无限大，所以，墨卡托投影无法显示极地地区。下图来自[维基百科](https://en.wikipedia.org/wiki/Mercator_projection)，可以看到墨卡托投影下每个国家的大小和实际大小的差异。但是 conformality（正形性） 和 straight rhumb lines 这两个特点，让它非常适合于航海导航。

![墨卡托投影下各个国家的大小和实际大小](https://img2018.cnblogs.com/blog/165220/201909/165220-20190904184435623-813112659.gif)

 By Jakub Nowosad - Own work, [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0), [Link](https://commons.wikimedia.org/w/index.php?curid=73955926)

# 3. 对于 Web Map 开发人员的意义

对于 Web Map 开发人员来说，最熟悉的应该是EPSG:4326 (WGS84) and EPSG:3857(Pseudo-Mercator)，这又是啥呢？

## 3.1 EPSG:4326 (WGS84)

前面说了 WGS84 是目前最流行的地理坐标系统。在国际上，每个坐标系统都会被分配一个 [EPSG](https://epsg.io/) 代码，EPSG:4326 就是 WGS84 的代码。GPS是基于WGS84的，所以通常我们得到的坐标数据都是WGS84的。一般我们在存储数据时，仍然按WGS84存储。

## 3.2 EPSG:3857 (Pseudo-Mercator)

伪墨卡托投影，也被称为球体墨卡托，Web Mercator。它是基于墨卡托投影的，把 WGS84坐标系投影到正方形。我们前面已经知道  WGS84  是基于椭球体的，但是伪墨卡托投影把坐标投影到球体上，这导致两极的失真变大，但是却更容易计算。这也许是为什么被称为”伪“墨卡托吧。另外，伪墨卡托投影还切掉了南北85.051129°纬度以上的地区，以保证整个投影是正方形的。因为墨卡托投影等正形性的特点，在不同层级的图层上物体的形状保持不变，一个正方形可以不断被划分为更多更小的正方形以显示更清晰的细节。很明显，伪墨卡托坐标系是非常显示数据，但是不适合存储数据的，通常我们使用WGS84 存储数据，使用伪墨卡托显示数据。

Web Mercator 最早是由 Google 提出的，当前已经成为 Web Map 的事实标准。但是也许是由于上面”伪“的原因，最初  Web Mercator 被拒绝分配EPSG 代码。于是大家普遍使用 EPSG:900913（Google的数字变形）  的非官方代码来代表它。直到2008年，才被分配了EPSG:3785的代码，但在同一年没多久，又被弃用，重新分配了  EPSG:3857 的正式代码，使用至今。

 

参考资料：

[EPSG 4326 vs EPSG 3857 (projections, datums, coordinate systems, and more!) ](https://lyzidiamond.com/posts/4326-vs-3857)

[Mercator vs. well…not Mercator (Platte Carre)](https://idvux.wordpress.com/2007/06/06/mercator-vs-well-not-mercator-platte-carre/)