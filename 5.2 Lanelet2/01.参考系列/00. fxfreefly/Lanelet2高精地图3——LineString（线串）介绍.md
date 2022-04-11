- [Lanelet2高精地图3——LineString（线串）介绍_fxfreefly的博客-CSDN博客_lanelet2](https://blog.csdn.net/bhniunan/article/details/121869071)

   LineString线串是两个或者多个点生成的[有序数组](https://so.csdn.net/so/search?q=有序数组&spm=1001.2101.3001.7020)，用来描述地图元素的形状。线串可以通过高度离散化实现，来描述任何一维形式，并应用于地图上的任何可物理观察到的部分。与样条曲线相比，线串可以高效计算，并且可以描述任何不规则形状。线串必须至少包含两个点才能有效，并且不能自相交。它们不能重复包含点（即，不允许p1-> p2-> p2-> p3）。线串可选type属性，以便可以确定其用途。

​    LineString元素的组成如下表所示：

| 物理量        | 内容     | 类型                           |
| ------------- | -------- | ------------------------------ |
| id            | 线串的ID | int                            |
| points[]      | 点的数组 | point                          |
| 属性（可选）* | Tags     | key=stringvalue=string, double |

​    \* key和value的取值范围如下：

| Tags    |                                        |
| ------- | -------------------------------------- |
| key     | value                                  |
| type    | line_thin, traffic_sign, virtual, etc. |
| subtype | dashed, solid, etc.                    |

​    线串的Tags用来决定线串是否用来描述下面的元素：

- 车道边界
- 地面标志
- 交通标志
- 交通灯

下面我们对常用的线串及.osm示例进行介绍

### 1、车道线

​    线串最主要的作用是用来描述车道线，对于车道线，Tags的取值如下：

| Key                 | 内容         | 类型   | 示例值    |
| ------------------- | ------------ | ------ | --------- |
| type                | 边界线类型   | string | line_thin |
| subtype             | 更详细的类型 | string | solid     |
| lane_change（可选） | 是否允许变道 | string | yes/no    |

下图为车道线的示例。

![img](https://img-blog.csdnimg.cn/37d68dbfe73f432e9a16f644c70058bb.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAZnhmcmVlZmx5,size_20,color_FFFFFF,t_70,g_se,x_16)

 在图中，标示出了车道线的type和subtype。车道线的类型代表了车道是否允许进行变道操作。有关车道线类型的说明如下表所示。

| **type**    | **subtype**    | **描述**                     | **是否允许变道** |
| :---------- | :------------- | :--------------------------- | :--------------- |
| line_thin   | solid          | 实线标记                     | no               |
| line_thin   | solid_solid    | 双实线标记                   | no               |
| line_thin   | dashed         | 虚线标记                     | yes              |
| line_thin   | dashed_solid   | 左侧虚线右侧实线标记         | 左->右: yes      |
| line_thin   | solid_dashed   | 左侧实线右侧虚线标记         | 右->左: yes      |
| line_thick  | 与上述类型相同 |                              |                  |
| curbstone   | high           | 高的路沿石，车辆无法通过     | no               |
| curbstone   | low            | 低的路沿石，车辆可以通过     | no               |
| virtual     | -              | 非物理边界线，主要用作路口的 | no               |
| road_border | -              | 道路边界                     | no               |

*.osm**文件表达实例*

在.osm文件中，线串以<way/>来表达。

```xml
<way id='21' visible='true' version='1'>
    <nd ref='9' />
    <nd ref='10' />
    <nd ref='11' />
    <nd ref='12' />
    <tag k='subtype' v='dashed' />
    <tag k='type' v='line_thin' />
</way>
```

### 2、交通标志

​    线串可以用来表达交通标志，对于交通标志，Tags的取值如下：

| Key            | 内容                                 | 类型   | 示例值       |
| -------------- | ------------------------------------ | ------ | ------------ |
| type           | 类型必须是traffic_sign               | string | traffic_sign |
| subtype        | 区域代码（参见ISO3166）+交通标志编号 | string | jp206        |
| height（可选） | 标志的垂直尺寸                       | double | 0.4          |

如下图所示，为一个交通标志牌，采用线串来表示交通标志牌时，至少要包含两个点，线串起点为标志牌左下角的位置，线串的终点为标志牌右下角的位置。

![img](https://img-blog.csdnimg.cn/8f5e6f00f1d0446c8be6e7184a2a1c81.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAZnhmcmVlZmx5,size_20,color_FFFFFF,t_70,g_se,x_16)

 *.osm**文件表达实例*

```xml
<way id='3' visible='true' version='1'>
    <nd ref='1' />
    <nd ref='2' />
    <tag k='subtype' v='jp206' />
    <tag k='type' v='traffic_sign' />
    <tag k='height' v='0.4m' />
</way>
```

### 3、交通灯

​    traffic_light是表示交通灯的线串，该线串区分方向，为非闭合线串。对于交通灯，Tags的取值如下：

| Key            | 内容                    | 类型   | 示例值           |
| -------------- | ----------------------- | ------ | ---------------- |
| type           | 类型必须是traffic_light | string | traffic_light    |
| subtype        | 类型的详细信息          | string | red_yellow_green |
| height（可选） | 交通灯的垂直尺寸        | double | 0.4              |

​    如下图所示，为一个红绿灯，可以看出交通灯通过左下角和右下角两个点来表示红绿灯的位置和宽度。

![img](https://img-blog.csdnimg.cn/635e64e362e0447eb761e560656b0068.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAZnhmcmVlZmx5,size_20,color_FFFFFF,t_70,g_se,x_16)

 *.osm**文件表达实例*

```xml
<way id='3' visible='true' version='1'>
    <nd ref='1' />
    <nd ref='2' />
    <tag k='subtype' v='red_yellow_green' />
    <tag k='type' v='traffic_light' />
    <tag k='height' v='0.4' />
</way>
```

### 4、地面标志

​    地面标志性的种类比较多，主要是用来约束交通规则的。如人行横道、停止线、箭头等。对于地面标志，Tags的取值如下：

| Key             | 内容     | 类型   | 示例值                          |
| --------------- | -------- | ------ | ------------------------------- |
| type            | 标志类型 | string | e.g. arrow, stop_line,lift_gate |
| subtype（可选） |          | string | e.g. right, left                |

​    如下图所示，为一个路口停止线的示例。

![img](https://img-blog.csdnimg.cn/0b6af7c91b414dfb8938e9c42ea0e37c.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAZnhmcmVlZmx5,size_16,color_FFFFFF,t_70,g_se,x_16)

*.osm**文件表达实例* 

```xml
<way id='17' visible='true' version='1'>
    <nd ref='1' />
    <nd ref='2' />
    <tag k='type' v='stop_line' />
</way>
```