- [OpenDrive格式地图数据解析_lyf's blog-CSDN博客_opendrive](https://blog.csdn.net/lewif/article/details/78575840)

**OpenDrive地图解析代码可以参考，https://github.com/liuyf5231/opendriveparser**

OpenDrive地图文件格式为[xml](https://so.csdn.net/so/search?q=xml&spm=1001.2101.3001.7020)，详细的介绍可以参考
http://www.opendrive.org/docs/OpenDRIVEFormatSpecRev1.4H.pdf

该xml文件中中包含了很多地图信息，例如Road、Junction等，下图是xml文件的主要结构，

![这里写图片描述](https://img-blog.csdn.net/20171122102541888?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGV3aWY=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

下图为绘制地图的一个简单思路，读取OpenDRIVE文件，即地图数据，构造路网，通过渲染展示给用户。

![这里写图片描述](https://img-blog.csdn.net/20171122102613527?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGV3aWY=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

下面结合OpenDRIVE文件中的数据，介绍如何构造路网。

## 坐标系

首先需要考虑的是坐标系，我们平时看到的地图都是二维的，而地球是个椭球体,因此需要通过某种方式将椭球上的表示转换为二维平面。

在GIS中一般使用两种常用的坐标系类型：

- 全局坐标系或球坐标系，例如经纬度。这些坐标系通常称为地理坐标系(GCS)。
- 基于横轴墨卡托、亚尔勃斯等积或罗宾森等地图投影的投影坐标系，这些地图投影（以及其他多种地图投影模型）提供了各种机制将地球球面的地图投影到二维笛卡尔坐标平面上。(PCS)

GCS使用三维球面来定义地球上的位置。

![image](http://images2015.cnblogs.com/blog/601252/201510/601252-20151020160615458-936783340.png)

PCS在二维平面中进行定义。与地理坐标系不同，在二维空间范围内，投影坐标系的长度、角度和面积恒定。投影坐标系始终基于地理坐标系，而后者则是基于球体或旋转椭球体的。

![image](http://images2015.cnblogs.com/blog/601252/201510/601252-20151020160617083-208598275.png)

上图为经过某种投影变换后的二维投影图(本文记作xy坐标系)，x表示经度(正，东经，负，西经)，y表示纬度(正，北纬，负，南纬)。

在OpenDRIVE数据中，具体体现在，

```xml
<header revMajor="1" revMinor="4" name="OpenDRIVE TestFile" version="1" date="Tue Aug 15 16:21:00 2017" north="5.4355531085039526e+06" south="5.4143611839699000e+06" east="3.2681018217470363e+07" west="3.2670519445542485e+07" vendor="AUTONAVI">
    <geoReference originLat="3.2675915701523371e+07" originLong="5.4273604273430230e+06" originAlt="0.0000000000000000e+00" originHdg="0.0000000000000000e+00">
        <![CDATA[PROJCS["WGS 84 / UTM zone 32N",GEOGCS["WGS 84",DATUM["WGS_1984",SPHEROID["WGS 84",6378137,298.257223563,AUTHORITY["EPSG","7030"]],AUTHORITY["EPSG","6326"]],PRIMEM["Greenwich",0,AUTHORITY["EPSG","8901"]],UNIT["degree",0.01745329251994328,AUTHORITY["EPSG","9122"]],AUTHORITY["EPSG","4326"]],UNIT["metre",1,AUTHORITY["EPSG","9001"]],PROJECTION["Transverse_Mercator"],PARAMETER["latitude_of_origin",0],PARAMETER["central_meridian",117],PARAMETER["scale_factor",0.9996],PARAMETER["false_easting",500000],PARAMETER["false_northing",0],AUTHORITY["EPSG","32650"],AXIS["Easting",EAST],AXIS["Northing",NORTH]]]]>
    </geoReference>
</header>
```

geoReference元素定义了该文件使用的投影坐标系，其中地理坐标系为WGS-84，而投影坐标系采用的是Transverse_Mercator，横轴墨卡托投影。

在OpenDRIVE数据中大量使用的位置信息都是投影后的xy坐标，而除了该投影坐标系，还定义了一种轨迹坐标系，如下所示，

![这里写图片描述](https://img-blog.csdn.net/20171122102658905?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGV3aWY=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

s坐标是沿着reference line的，关于reference line后面介绍，长度是在xy坐标下计算的，应该是通过积分计算的吧(例如下图中的123.45)。
t坐标，是相对于reference line的侧向位置，左正，右负。

![这里写图片描述](https://img-blog.csdn.net/20171122102750113?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGV3aWY=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

## reference line

reference line是路网结构中一个很重要的概念，绘制地图的时候先是画reference line，reference line包含xy位置坐标、路的形状属性，然后在reference line基础上再去画其他其他元素。

下图是OpenDRIVE中路网结构中的一个road，该road有三部分组成，蓝色的reference line，车道lane，车道lane的其他feature(限速等)。

![这里写图片描述](https://img-blog.csdn.net/20171122102820275?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGV3aWY=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

整个地图路网由很多的road构成，而每个road中都会包含reference line，就是一条线，它没有宽度

> All roads consist of a reference line which defines the basic geometry (arcs, straight lines etc.). Along
> the reference line, various properties of the road can be defined.

reference line，线条有好几种类型，直线，螺旋线等，

The geometry of the reference line is described as a sequence of primitives of various types. The
available primitives are:

- straight line (constant zero curvature)
- spiral (linear change of curvature)
- curve (constant non-zero curvature along run-length)
- cubic polynom
- parametric cubic curves

下图为几种常见的reference line，注意图中的两个坐标系,xy和st
![这里写图片描述](https://img-blog.csdn.net/20171122102846186?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGV3aWY=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

而在OpenDRIVE数据中，reference line体现在planView元素下的geometry,顾名思义，俯视图下的road几何形状，该road是条直线，螺旋线等等。

```xml
<planView>
    <geometry s="0.0000000000000000e+00" x="-3.0024844302609563e+03" y="2.7962779217697680e+03" hdg="2.8046409307224991e+00" length="1.3647961224498889e+02">
        <arc curvature="-3.3912133325369736e-05" />
    </geometry>
    <geometry s="1.3647961224498889e+02" x="-3.1311844847723842e+03" y="2.8416976011684164e+03" hdg="2.7974752903867355e+00" length="9.9592435217850038e+01">
        <arc curvature="-1.2467775981482813e-03" />
    </geometry>
</planView>
```

![这里写图片描述](https://img-blog.csdn.net/20171122102927692?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGV3aWY=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

一个road的并不是只有一根reference line，因为假如一个road长度为100米，有可能这100米有些地方是直路，有些地方是拐弯的曲线，每一条都是一个geometry标签，通过s(起始位置)和长度进行连接(后一个s是前一个的length)。
而属性中的x，y，hdg分别是投影坐标系xy下的起始点位置以及起始点的角度(定义了曲线方程以及起始点坐标和长度，曲线肯定就能画出来了)。

## 车道lane

一个road中包含了很多的车道lane(lanes)，而车道(lane)本身有宽度(width)，以及虚线、实线等属性参数(roadMark)。结合这些参数，我们就能在reference line的基础上将车道画出来。

下面是OpenDRIVE中对应的车道相关的元素，

```xml
<lanes>
    <laneSection s="0.0000000000000000e+00">
        <center>
            <lane id="0" type="driving" level="false">
                <link />
                <roadMark sOffset="0.0000000000000000e+00" type="solid" weight="standard" color="standard" material="standard" LDM="none" width="2.9999999999999999e-01" laneChange="both" />
            </lane>
        </center>
        <right>
            <lane id="-1" type="driving" level="false">
                <link>
                    <predecessor id="-1" />
                    <successor id="-1" />
                </link>
                <width sOffset="0.0000000000000000e+00" a="3.8890850467340541e+00" b="-1.4514389448175911e-03" c="1.0899364495936138e-04" d="-1.3397356888919692e-06" />
                <width sOffset="7.6500000000000000e+01" a="3.8161122099921028e+00" b="1.6531839124687595e-03" c="-3.0234314157904548e-06" d="-2.9791355887866248e-08" />
                <roadMark sOffset="0.0000000000000000e+00" type="broken" weight="standard" color="standard" material="standard" LDM="none" width="1.4999999999999999e-01" laneChange="both" />
            </lane>
        </right>
    </laneSection>
</lanes>
```

在lanes下还有个laneSection车道横截面的概念，一个road包含了数个laneSection，每个laneSection中又包含了车道lane，在一个laneSection中车道lane是顺着reference line分为left,center,right。

![这里写图片描述](https://img-blog.csdn.net/20171122102958698?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGV3aWY=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

reference line是center，没有宽度width，只是一条线。
left的lane的id为正，right为负。上图中坐边定义了5条车道，1,2,3,-1,-2，而右边多了一条-3。

此外，在lane元素中，width元素定义了车道的宽度，都是基于曲线进行拟合的。roadMark元素定义了车道线的属性，OpenDrive中规定的车道线的属性如下所示，有实线，虚线等。

![这里写图片描述](https://img-blog.csdn.net/20171122103025561?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGV3aWY=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

通过上面的介绍，已经画完了一个road，而前面提到OpenDrive地图是由多个road组成，下面介绍如何将这些road连接起来。

## road连接

road之间的连接定义了两种(每个road有唯一的ID)，一种是有明确的连接关系，例如前后只有一条road，那么通过
successor/predecessor进行连接(例如下图中的road 1和road 2)，

In order to navigate through a road network, the application must know about the linkage between different roads. Two types of linkage are possible:

- successor/predecessor linkage (standard linkage)
- junctions

Whenever the linkage between two roads is clear, a standard linkage information is sufficient. A junction is required when the successor or predecessor relationship of a road is ambiguous. Here, the application needs to select one of several possibilities.

![这里写图片描述](https://img-blog.csdn.net/20171122103053144?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGV3aWY=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

如果前后的连接关系不是很明确，就需要一个junctions，上图road 2的后置节点successor就无法确定，

![这里写图片描述](https://img-blog.csdn.net/20171122103115607?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGV3aWY=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

在OpenDrive中，将上图中的3,4,5称为junction，road 3,4,5,称为connecting road，而2称为incoming road，6,7,8称为outgoing road。

具体体现在OpenDrive中如下所示，junction 41的incomingRoad为road 42，而road 55属于junction中的connectingRoad，

```xml
<junction name="normal" id="41">
    <connection id="1" incomingRoad="42" connectingRoad="55" contactPoint="start">
        <laneLink from="-3" to="-3" />
        <laneLink from="-2" to="-2" />
        <laneLink from="-1" to="-1" />
    </connection>
</junction>
```

**由于road中又包含了很多lanes车道，所以需要将车道的连接关系也表示清楚，上面的laneLink元素就是用来连接lanes的，对road 42和55的-3,-2,-1进行连接(center右边的车道)。**

## 一个完整的例子

![这里写图片描述](https://img-blog.csdn.net/20171122103144364?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGV3aWY=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

上图体现了OpenDrive中的路网连接关系，分为：

- 左边road 10，reference line黑线所在位置，左边有lane 1 ,2,右边为lane -1,-2,-3
- 上边road 60，reference line黑线所在位置，左边有lane 1 ,2,右边为lane -1,-2
- 右边road 50，reference line黑线所在位置，左边有lane 1 ,2,右边为lane -1,-2，-3
- 下边road 70，reference line黑线所在位置，左边有lane 1 ,2,右边为lane -1,-2
- 中间是一个Junction，包含road 40, road 20,road 30，都是connectingRoad，对应的连接关系为road 10 -1 lane (incoming road)<—>road40(connectingRoad) -1 lane，road 10 -2 lane (incoming road)<—>road30(connectingRoad) -1 lane，road 10 -1 lane (incoming road)<—>road20(connectingRoad) -1 lane,road 10 -2 lane (incoming road)<—>road20(connectingRoad) -2 lane，而outgoingRoad与之类似。

**总之，对于一个road来说，先确定reference line，有了reference line的几何形状和位置，然后再确定reference line左右的车道lane,车道lane又有实线和虚线等属性；road 和road之间通过普通连接和Junction进行连接，同时还要将road中的相关车道进行连接。**
