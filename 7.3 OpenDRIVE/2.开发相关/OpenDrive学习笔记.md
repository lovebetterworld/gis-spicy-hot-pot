- [OpenDrive\] OpenDrive学习笔记_Sprinkle_WPD的博客-CSDN博客_opendrive](https://blog.csdn.net/qq_26915769/article/details/100143871)

## OpenDRIVE

OpenDRIVE是对路网结构的描述性文件，于2006年1月31日发布第一版，目前已更新至1.5版本。

OpenDRIVE文件格式为XML，该XML文件种包含了Road、Junction、station等诸多道路路网信息。

从OpenDRIVE 1.4 开始, 可以使用格式化为 “proj4”-字符串的投影定义对路网进行地理参照转化. 它将地理空间坐标从一个坐标参考系统 (CRS) 转换为另一个坐标参考系统。这包括制图投影和大地测量转换。 geoReference元素定义了该文件使用的投影坐标系，其中地理坐标系为WGS-84[1]。

在OpenDRIVE数据中大量使用的位置信息都是投影后的xy坐标，而除了该投影坐标系，还定义了一种轨迹坐标系，如下所示，s坐标是沿着reference line的，关于reference line后面介绍，长度是在xy坐标下计算的。 t坐标，是相对于reference line的侧向位置，左正，右负。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190902165204462.?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzI2OTE1NzY5,size_16,color_FFFFFF,t_70)
OpenDRIVE中路网结构中的一个road，该road有三部分组成，蓝色的reference line，车道lane，车道lane的其他feature(限速等)。
![在这里插入图片描述](https://img-blog.csdnimg.cn/2019090216523723.?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzI2OTE1NzY5,size_16,color_FFFFFF,t_70)
所有道路都由一条reference line组成, 用于定义基本几何 (弧线、直线等)。

沿着reference line 可以定义道路的各种属性,例如海拔概况、车道、交通标志等。

道路之间可以直连，也可以通过junction进行连接。

### reference line

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190902165548480.?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzI2OTE1NzY5,size_16,color_FFFFFF,t_70)

### lanes

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190902165605270.?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzI2OTE1NzY5,size_16,color_FFFFFF,t_70)

### lane offset

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190902165616856.?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzI2OTE1NzY5,size_16,color_FFFFFF,t_70)

### lane sections

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190902165635632.?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzI2OTE1NzY5,size_16,color_FFFFFF,t_70)

### lane properties

### superelevation and crossfall

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190902165733314.)

### lateral profile

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190902165805429.)

### road linkage

![在这里插入图片描述](https://img-blog.csdnimg.cn/2019090216584085.?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzI2OTE1NzY5,size_16,color_FFFFFF,t_70)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190902165850213.?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzI2OTE1NzY5,size_16,color_FFFFFF,t_70)

### junctions

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190902165908185.?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzI2OTE1NzY5,size_16,color_FFFFFF,t_70)

### neighbors

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190902165944407.?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzI2OTE1NzY5,size_16,color_FFFFFF,t_70)

由于是XML文件写的，所以可以有类似C语言中include的用法，可以在xml中include对应另一个xml

```xml
Original File
<planView>
    <include file="planview.xml"/>
</planView>


Included File
<planView>
    <geometry x="-0.014" y="-0.055" hdg="2.8829" length="95.889" s="0.000">
        <arc curvature="-0.000490572"/>
    </geometry>
    <geometry x="-92.102" y="26.644" hdg="2.8359" length="46.651" s="95.889">
        <spiral curvStart="-0.000490572" curvEnd="-0.004661241"/>
    </geometry>
</planView>
```

## 总体结构

OpenDrive格式为xodr，默认浮点型为double类型，推荐家用16位科学计数法表示。
OpenDrive采取的路网结构

|- OpenDRIVE
|- header [1]
|- road [1+]
|- controller [0+]
|- junction [0+]
|- junctionGroup [0+]
|- station [0+]

|- road [name, length, id, junction]
|- link
|- type
|- planView
|- elevationProfile
|- lateralProfile
|- lanes
|- objects
|- signals
|- surface
|- railroad

新版的OpenDrive中推荐使用lateral profile而不是crossfall

## [Apollo](https://so.csdn.net/so/search?q=Apollo&spm=1001.2101.3001.7020) OpenDRIVE

OpenDRIVE本身设计面向的应用是仿真器，自动驾驶需要更多的信息OpenDRIVE并没有完全提供，所以Apollo对OpenDRIVE的标准做了部分改动和扩展。

主要改动和扩展了以下几个方面：

- **地图元素形状的表述方式** : 以车道边界为例，标准OpenDRIVE采用基于Reference Line的曲线方程和偏移的方式来表达边界形状，而Apollo OpenDrive采用绝对坐标序列的方式描述边界形状；
- **元素类型的扩展**, 例如新增了对于禁停区、人行横道、减速带等元素的独立描述；
- **扩展了对于元素之间相互关系的描述**, 比如新增了junction与junction内元素的关联关系等；

除此之外还有一些配合无人驾驶算法的扩展，比如增加了车道中心线到真实道路边界的距离、停止线与红绿灯的关联关系等。改动和扩展后的规格在实现上更加的简单，同时也兼顾了无人驾驶的应用需求。

### Apollo OpenDRIVE结构

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190902170913369.?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzI2OTE1NzY5,size_16,color_FFFFFF,t_70)
百度高精地图坐标采用WGS84经纬度坐标表示。

车道 ID 的命名规则:

- lane section 内唯一数值连续的
- reference line 所在 lane 的 ID 为 0
- reference line 左侧 lane 的 ID 向左侧依次递增 (正t轴方向)
- reference line 右侧 lane 的 ID 向右侧依次递减(负 t 轴方向)
- reference line 必须定义在**< center >**节点内
- reference line 自身必须为 Lane 0。

base_map, routing_map和sim_map之间的差异

- **base_map**是最完整的地图，包含所有道路和车道几何形状和标识。其他版本的地图均基于base_map生成。
- **routing_map**包含base_map中车道的拓扑结构
- **sim_map**是一个适用于Dreamview视觉可视化，基于base_map的轻量版本。减少了数据密度，以获得更好的运行时性能。

## 参考文章：

[1] https://ryanadex.github.io/2019/06/04/opendrive/

[2] https://www.csdn.net/article/a/2018-04-12/15945514

[3] https://blog.csdn.net/weixin_36662031/article/details/81081744