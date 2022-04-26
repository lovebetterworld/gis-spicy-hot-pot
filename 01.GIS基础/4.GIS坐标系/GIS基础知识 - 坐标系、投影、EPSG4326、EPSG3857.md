- [GIS基础知识 - 坐标系、投影、EPSG:4326、EPSG:3857](https://www.cnblogs.com/E7868A/p/11460865.html)
- [CGCS2000与WGS84、北斗坐标系的区别](https://www.qxwz.com/zixun/829503749)

## 1. 大地测量学 (Geodesy)

[大地测量学](https://en.wikipedia.org/wiki/Geodesy)是一门量测和描绘地球表面的学科，也包括确定地球重力场和海底地形。

### 1.1 大地水准面 (geoid)

[大地水准面](https://en.wikipedia.org/wiki/Geoid)是**海洋表面**在排除风力、潮汐等其它影响，只考虑重力和自转影响下的形状，这个形状延伸过陆地，生成一个密闭的曲面。虽然我们通常说地球是一个球体或者椭球体，但是由于地球引力分布不均（因为密度不同等原因），大地水准面是一个不规则的光滑曲面。虽然不规则，但是可以近似地表示为一个椭球体，这个椭球体被 称为[参考椭球体（Reference ellipsoid）](https://en.wikipedia.org/wiki/Reference_ellipsoid)。大地水准面相对于参考椭球体的高度被称为 **Undulation of the geoid** 。这个波动并不是非常大，最高在冰岛为85m，最低在印度南部为 −106 m，一共不到200m。下图来自[维基百科](https://en.wikipedia.org/wiki/Geoid)，表示 EGM96 geoid 下不同地区的 Undulation。

![img](https://img2018.cnblogs.com/blog/165220/201909/165220-20190904132051915-475643758.png)

###  1.2 参考椭球体（Reference ellipsoid）

[参考椭球体（Reference ellipsoid）](https://en.wikipedia.org/wiki/Reference_ellipsoid)是一个数学上定义的地球表面，它近似于大地水准面。因为是几何模型，可以用长半轴、短半轴和扁率来确定。我们通常所说的经度、纬度以及高度都以此为基础。

一方面，我们对地球形状的测量随着时间迁移而不断精确，另一方面，因为大地水准面并不规则，地球上不同地区往往需要**使用不同的参考椭球体**，来尽可能适合当地的大地水准面。历史上出现了很多不同的参考椭球体，很多还仍然在使用中。国内过去使用过“北京54”和“西安90”两个坐标系，其中北京54使用的是克拉索夫斯基（Krasovsky）1940的参考椭球，西安80使用的是1975年国际大地测量与地球物理联合会第16届大会推荐的参考椭球。当前世界范围内更普遍使用的是WGS所定义的参考椭球。

## 2. 坐标系（coordinate system）

有了参考椭球体这样的几何模型后，就可以定义坐标系来进行描述位置，测量距离等操作，使用相同的坐标系，可以保证同样坐标下的位置是相同的，同样的测量得到的结果也是相同的。通常有两种坐标系 地理坐标系（geographic coordinate systems） 和 投影坐标系（projected coordinate  systems）。

### 2.1 地理坐标系（Geographic coordinate system）

地理坐标系一般是指由经度、纬度和高度组成的坐标系，能够标示地球上的任何一个位置。前面提到了，不同地区可能会使用不同的参考椭球体，即使是使用相同的椭球体，也可能会为了让椭球体更好地吻合当地的大地水准面，而调整椭球体的方位，甚至大小。这就需要使用不同的大地测量系统（**Geodetic datum**）来标识。因此，对于地球上某一个位置来说，使用不同的测量系统，得到的坐标是不一样的。我们在处理地理数据时，必须先确认数据所用的测量系统。事实上，随着我们对地球形状测量的越来越精确，北美使用的 NAD83 基准和欧洲使用的 ETRS89 基准，与 WGS 84 基准是基本一致的，甚至我国的 CGCS2000  与WGS84之间的差异也是非常小的。但是差异非常小，不代表完全一致，以 NAD83 为例，因为它要保证北美地区的恒定，所以它与 WGS84  之间的差异在不断变化，对于美国大部分地区来说，每年有1-2cm的差异。

### 2.2 投影坐标系（Projected coordinate systems）

地理坐标系是三维的，我们要在地图或者屏幕上显示就需要转化为二维，这被称为[投影（Map projection）](https://en.wikipedia.org/wiki/Map_projection)。显而易见的是，从三维到二维的转化，必然会导致变形和失真，失真是不可避免的，但是不同投影下会有不同的失真，这让我们可以有得选择。常用的投影有[等矩矩形投影](https://en.wikipedia.org/wiki/Equirectangular_projection)（Platte Carre）和[墨卡托投影](https://en.wikipedia.org/wiki/Mercator_projection)（Mercator），下图来自[Mercator vs. well…not Mercator (Platte Carre)](https://idvux.wordpress.com/2007/06/06/mercator-vs-well-not-mercator-platte-carre/)，生动地说明了这两种投影下的失真：

![img](https://img2018.cnblogs.com/blog/165220/201909/165220-20190904172204757-1850337732.png)

左图表示地球球面上大小相同的圆形，右上为墨卡托投影，投影后仍然是圆形，但是在高纬度时物体被严重放大了。右下为等距投影，物体的大小变化不是那么明显，但是图像被拉长了。Platte Carre 投影因为在投影上有扭曲，并不适合于航海等活动，但是因为坐标与像素之间的对应关系十分简单，非常适合于栅格图的展示，Platte  Carre 投影是很多GIS 软件的默认投影。

需要注意的是，对于墨卡托投影来说，越到高纬度，大小扭曲越严重，到两极会被放到无限大，所以，墨卡托投影无法显示极地地区。下图来自[维基百科](https://en.wikipedia.org/wiki/Mercator_projection)，可以看到墨卡托投影下每个国家的大小和实际大小的差异。但是 conformality（正形性） 和 straight rhumb lines 这两个特点，让它非常适合于航海导航。

![墨卡托投影下各个国家的大小和实际大小](https://img2018.cnblogs.com/blog/165220/201909/165220-20190904184435623-813112659.gif)

 By Jakub Nowosad - Own work, [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0), [Link](https://commons.wikimedia.org/w/index.php?curid=73955926)

## 3. 对于 Web Map 开发人员的意义

对于 Web Map 开发人员来说，最熟悉的应该是EPSG:4326 (WGS84) and EPSG:3857(Pseudo-Mercator)，这又是啥呢？

### 3.1 EPSG:4326 (WGS84)

前面说了 WGS84 是目前最流行的地理坐标系统。在国际上，每个坐标系统都会被分配一个 [EPSG](https://epsg.io/) 代码，EPSG:4326 就是 WGS84 的代码。GPS是基于WGS84的，所以通常我们得到的坐标数据都是WGS84的。一般我们在存储数据时，仍然按WGS84存储。

### 3.2 EPSG:3857 (Pseudo-Mercator)

伪墨卡托投影，也被称为球体墨卡托，Web Mercator。它是基于墨卡托投影的，把 WGS84坐标系投影到正方形。我们前面已经知道  WGS84  是基于椭球体的，但是伪墨卡托投影把坐标投影到球体上，这导致两极的失真变大，但是却更容易计算。这也许是为什么被称为”伪“墨卡托吧。另外，伪墨卡托投影还切掉了南北85.051129°纬度以上的地区，以保证整个投影是正方形的。因为墨卡托投影等正形性的特点，在不同层级的图层上物体的形状保持不变，一个正方形可以不断被划分为更多更小的正方形以显示更清晰的细节。很明显，伪墨卡托坐标系是非常显示数据，但是不适合存储数据的，通常我们使用WGS84 存储数据，使用伪墨卡托显示数据。

Web Mercator 最早是由 Google 提出的，当前已经成为 Web Map 的事实标准。但是也许是由于上面”伪“的原因，最初  Web Mercator 被拒绝分配EPSG 代码。于是大家普遍使用 EPSG:900913（Google的数字变形）  的非官方代码来代表它。直到2008年，才被分配了EPSG:3785的代码，但在同一年没多久，又被弃用，重新分配了  EPSG:3857 的正式代码，使用至今。

## 4 CGCS2000与WGS84、北斗坐标系的区别

> 摘要：CGCS2000和1954或1980坐标系，在定义和实现上有根本区别。局部坐标和地心坐标之间的变换是不可避免的。坐标变换通过联合平差来实现。当采用模型变换时，变换模型的选择应依据精度要求而定。

CGCS2000是中国[2000国家大地坐标系](https://www.qxwz.com/baike/049813361)的缩写，该[坐标系](https://www.qxwz.com/baike/001250179)是通过中国GNSS 连续运行基准站、 空间大地控制网以及天文大地网联合平差建立的地心[大地坐标系统](https://www.qxwz.com/baike/893936337)。[2000国家大地坐标系](https://www.qxwz.com/baike/049813361)以ITRF 97 参考框架为基准， 参考框架历元为2000.0。

 CGCS2000[坐标系](https://www.qxwz.com/baike/001250179)原点和轴定义如下：原点为地球的质量中心；Z轴指向IERS参考极方向；X轴为IERS参考[子午面](https://www.qxwz.com/baike/645721224)与通过原点且同Z轴正交的[赤道](https://www.qxwz.com/baike/031226155)面的交线；Y轴完成右手地心地固[直角坐标系](https://www.qxwz.com/baike/058827721)。

 [2000国家大地坐标系](https://www.qxwz.com/baike/049813361)的[大地测量](https://www.qxwz.com/baike/088586814)基本常数分别为: 长半轴 a = 6 378 137 m; 地球引力常数 GM =3.986004418×1014m3s-2; 扁率f = 1/ 298. 257 222 101;地球自转角速度X =7.292115×10-5rad s-1

### 与WGS84区别

CGCS2000的定义与WGS84实质一样，原点、尺度、定向均相同，都属于地心[地固坐标](https://www.qxwz.com/baike/776563739)系。采用的参考椭球非常接近。扁率差异引起椭球面上的[纬度](https://www.qxwz.com/baike/254117521)和高度变化最大达0.1mm。当前[测量精度](https://www.qxwz.com/baike/565906337)范围内，两者相容至cm级水平。

 CGCS2000[坐标](https://www.qxwz.com/baike/377434614)是2000.0历元的瞬时[坐标](https://www.qxwz.com/baike/377434614)，而WGS84[坐标](https://www.qxwz.com/baike/377434614)是观测历元的动态[坐标](https://www.qxwz.com/baike/377434614)，两者都基于ITRF框架，可通过历元、框架转换进行换算。同样的点位及观测精度，GNSS接收机获取的WGS84[坐标](https://www.qxwz.com/baike/377434614)及CGCS2000[坐标](https://www.qxwz.com/baike/377434614)并不是只有厘米级的差异，而是因框架、历元差异产生的分米级的[坐标](https://www.qxwz.com/baike/377434614)差。历元归算到2000.0的WGS[坐标](https://www.qxwz.com/baike/377434614)，可以作为CGCS2000[坐标](https://www.qxwz.com/baike/377434614)使用。

 WGS84[坐标系](https://www.qxwz.com/baike/001250179)由26个全球分布的监测站[坐标](https://www.qxwz.com/baike/377434614)来实现，不同版本的WGS84对应相应的ITRF版本和参考历元。

### 与[北斗](https://www.qxwz.com/zixun/beidou)[坐标系](https://www.qxwz.com/baike/001250179)区别

[北斗](https://www.qxwz.com/zixun/beidou)[坐标系](https://www.qxwz.com/baike/001250179)和WGS84[坐标系](https://www.qxwz.com/baike/001250179)类似，属于[导航坐标](https://www.qxwz.com/baike/042962912)系，其坐标是观测历元的动态坐标，与CGCS2000[坐标系](https://www.qxwz.com/baike/001250179)有2500多个框架点不同，[北斗](https://www.qxwz.com/zixun/beidou)[坐标系](https://www.qxwz.com/baike/001250179)只有几个框架点，其更新周期短，[测量精度](https://www.qxwz.com/baike/565906337)低，而CGCS2000属于国家基础[坐标系](https://www.qxwz.com/baike/001250179)，更新周期往往长达几十年。但CGCS2000[坐标系](https://www.qxwz.com/baike/001250179)与[北斗](https://www.qxwz.com/zixun/beidou)坐标系的定义、椭球是一致的，

### 与54系、80系区别

CGCS2000和1954或1980坐标系，在定义和实现上有根本区别。局部坐标和地心坐标之间的变换是不可避免的。[坐标变换](https://www.qxwz.com/baike/768708665)通过联合平差来实现。当采用模型变换时，变换模型的选择应依据精度要求而定。

 ![img](https://cdn.wzw.cn/ccms-file/2021-12-31-16-13-02/e022b5b5-a59d-4337-aaeb-d035364dda91.png)

## 说明：

[测绘](https://www.qxwz.com/baike/132254634)工作中采用的[RTK](https://www.qxwz.com/baike/060191956)、[静态测量](https://www.qxwz.com/baike/478765421)等属于相对定位，以地面已知控制点做起算，所以相对定位成果的历元和框架由控制[点坐标](https://www.qxwz.com/baike/173532683)的历元和框架决定；精密单点定位等绝对定位是以[卫星星历](https://www.qxwz.com/baike/383283379)作为起算数据，而[卫星星历](https://www.qxwz.com/baike/383283379)是利用地面监测站的[卫星](https://www.qxwz.com/baike/912354035)跟踪数据计算得到。

 坐标框架体系建设历史及来源： 20世纪50年代，为满足[测绘](https://www.qxwz.com/baike/132254634)工作的迫切需要 ，中国采用 了1954年北京坐标系。1954年之后，随着天文大地网布设任务的完成，通过天文大地网整体平差，于20世纪80年代初中国又建立了[1980西安坐标系](https://www.qxwz.com/baike/886768871)。[1954北京坐标系](https://www.qxwz.com/baike/488601450)和[1980西安坐标系](https://www.qxwz.com/baike/886768871)在中国的经济建设和国防建设中发挥了巨大作用。

 随着情况的变化和时间的推移，上述两个以经典[测量](https://www.qxwz.com/baike/945310090)技术为基础的局部[大地坐标系](https://www.qxwz.com/baike/018219209)，已经不能适应科学技术特别是空间技术发展，不能适应中国经济建设和国防建设需要。中国[大地坐标系](https://www.qxwz.com/baike/018219209)的更新换代，是经济建设、国防建设、社会发展和科技发展的客观需要。

 以地球质量中心为原点的地心[大地坐标系](https://www.qxwz.com/baike/018219209)，是21世纪空间时代全球通用的基本[大地坐标系](https://www.qxwz.com/baike/018219209)。以空间技术为基础的地心[大地坐标系](https://www.qxwz.com/baike/018219209)，是中国新一代[大地坐标系](https://www.qxwz.com/baike/018219209)的适宜选择。历经多年，中国[测绘](https://www.qxwz.com/baike/132254634)、地震部门和科学院有关单位为建立中国新一代[大地坐标系](https://www.qxwz.com/baike/018219209)作了大量基础性工作，20世纪末先后建成全国 GPS一、二级网，国家GPS A、B级网，中国地壳运动观测网络和许多地壳形变网，为地心[大地坐标系](https://www.qxwz.com/baike/018219209)的实现奠定了较好的基础。中国[大地坐标系](https://www.qxwz.com/baike/018219209)更新换代的条件也已具备。中国新一代[大地坐标系](https://www.qxwz.com/baike/018219209)建立的基本原则是：

 1)坐标系应尽可能对准 ITRF(国际地球参考框架)；

2)坐标系应由空间大地网在某参考历元的坐标和速度体现；

3)参考椭球的定义参数选用长半轴、扁率、地球地心引力常数和地球角速度，其参数值采用 IUGG (国际[大地测量](https://www.qxwz.com/baike/088586814)与地球物理联合会)或 IERS(国际地球旋转与参考系服务局)的采用值或推荐值。

## 参考资料：

[EPSG 4326 vs EPSG 3857 (projections, datums, coordinate systems, and more!) ](https://lyzidiamond.com/posts/4326-vs-3857)

[Mercator vs. well…not Mercator (Platte Carre)](https://idvux.wordpress.com/2007/06/06/mercator-vs-well-not-mercator-platte-carre/)