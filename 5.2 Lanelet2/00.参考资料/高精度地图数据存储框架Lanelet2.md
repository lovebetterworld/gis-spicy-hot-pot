- [无人驾驶算法学习（十五）：高精度地图数据存储框架Lanelet2_su扬帆启航的博客-CSDN博客_lanelet2](https://blog.csdn.net/orange_littlegirl/article/details/106542743)

# 1.引言

Autoware目前使用的高[精度](https://so.csdn.net/so/search?q=精度&spm=1001.2101.3001.7020)地图以前是Vector Map Format(VMF)，现在已经是lanelet格式。Lanelet2是一个C++库，用于处理在自动驾驶情况下的地图数据。 

它兼容并扩展了之前的lanelets库, 能够利用高清地图数据，以有效应对复杂交通情况下车辆所面临的挑战。 灵活性和可扩展性是应对未来地图挑战的一些核心原则。
[lanelet2代码链接](https://github.com/fzi-forschungszentrum-informatik/Lanelet2)

# 2.lanelet2特点

Lanelet2地图层次划分：

• 物理层（physical layer，可观测到的真实元素）

• 关联层（relational layer，与物理层相关联的车道，区域以及交通规则）

• 拓扑层（topological layer）

设计Lanelet2地图基于以下原则：

1. 通过与可观察对象相关联来验证地图上的所有信息。
2. 地图需要覆盖到所有可能区域，包括道路外的部分。
3. 地图上各个车道和区域之间的交互作用必须是可识别和可理解的。必须能找出在哪些车道之间可能发生变道，或者在哪里可能由于交叉车道而引起冲突。
4. 必须包含有关road user使用的区域的信息以及适用于他们的交通规则。
5. 必须区分交通规则的来源及其对road user的影响。
6. 可扩展性/模块化。
7. 容易修改和更新

Lanelet2格式基于Liblanelet已知的格式，并设计为可在基于XML的OSM数据格式上表示，该格式的编辑器和查看器可公开使用。但是，我们认为地图的实际数据格式无关紧要，并且可以互相转换，只要可以确保该格式可以无损地传输到内部表示即可， 因此能够轻松转换为其他格式。

地图存储的时候，最重的是准确性，一般用无损地理坐标系（经纬度）。而在加载地图时，为了能够进行有效计算，将其转换为平面投影系，比如UTM系，但是高度信息也十分重要。

# 3.数据结构

## 3.1 Points

points由ID，3d坐标和属性组成，是唯一存储实际位置信息的元素，ID必须是唯一的。其他基本元素都是直接或者间接由points组成的。在Lanelet2中，Points本身并不是有意义的对象，Points仅与Lanelet2中的其他对象一起使用有意义。

## 3.2 Linestrings

线串是两个或者多个点通过线性插值生成的有序数组，用来描述地图元素的形状。线串可以是虚线，它可以通过高度离散化实现，来描述任何一维形式，并应用于地图上的任何可物理观察到的部分。与样条曲线相比，线串可以高效计算，并且可以用来描述尖角，最终转化为非线性微分方程的求解问题。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200604120613879.png)

线串必须至少包含一个点才能有效，并且不能自相交。它们不能重复包含点（即，不允许p1-> p2-> p2-> p3)。线串必须始终具有type属性，以便可以确定其用途。

## 3.3 Polygon

多边形与线串非常相似，但形成一个Area。隐式假定多边形的第一个点和最后一个点被连接以闭合形状。

多边形很少用于传输地图信息（交通标志除外）。相反，它们通常用作将有关区域的自定义信息添加到地图（例如，感兴趣区域）的一种手段。

## 3.4 Lanelets

Lanelets定义了发生定向运动时，地图车道的原子部分。原子表示沿当前lanelet行驶时，有效的交通规则不会改变，而且与其他Lanelet的拓扑关系也不会更改。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200604120600938.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L29yYW5nZV9saXR0bGVnaXJs,size_16,color_FFFFFF,t_70)

lanelet可以引用表示适用于该lanelet的交通规则的regulatory elements。多个lanelet可以引用同一regElem。必须始终始终可以直接从车道上确定车道的当前速度限制。可以通过引用SpeedLimit监管元素或标记小车的位置来完成。在这种情况下，假定道路类型的最大速度（例如，如果位置是德国城市，则为最大50公里/小时)。

## 3.5 Areas

Areas是地图上没有方向或者是无法移动的部分区域，比如路标，停车位，绿化带等。他们由一条或者多条linestring组成的闭合的区域。Area也有相关联的regulatory elements。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200604120548560.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L29yYW5nZV9saXR0bGVnaXJs,size_16,color_FFFFFF,t_70)

## 3.6 regElem （Regulatory elements ）

regElem是表达交通规则的通用方式，它们由适用的lanelet或Area引用。在应用的时候，regElem 会和一个或者多个Lanelets、Areas相关联。regElem是动态变化的，意味着它只是在某些条件下是有效的。

诸如限速，道路优先级规则、红绿灯等，交通规则有许多不同的类型，因此每个regElem的准确结构大都不一样。他们通常引用定义规则的元素（例如交通标志），并在必要时引用取消规则的元素（例如速度区末尾的标志）。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200604120528347.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L29yYW5nZV9saXR0bGVnaXJs,size_16,color_FFFFFF,t_70)
通常，regElem元素由通常表示规则类型的标签（即交通信号灯regElem）和有关对此规则具有特定作用的可观察事物的特定信息（例如交通信号灯本身和停车线)组成。 其他类型的regElem是通行权和交通标志regElem。

# 4.软件模块

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200604121714195.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L29yYW5nZV9saXR0bGVnaXJs,size_16,color_FFFFFF,t_70)

## 4.1 Core

此模块包含所有的图元和以上描述的图层，并且还包括几何计算，比如计算中心线，距离和重叠区域等

## 4.2 Traffic Rules

根据不同的road user类型和国家，来解释相应的交通规则。

## 4.3 Physical

可以直接访问物理层元素。

## 4.4 Routing

根据交通规则，创建路由图，来确定精准的行驶路线。也可能通过组合相邻的Areas和lanelets来构建易通行区域。

## 4.5 Matching

用来给road user分配lanelets或者基于传感器的观测来确定可能的行驶方向。

## 4.6. Projection

提供全球地理坐标系到局部平面坐标系的准换

## 4.7. IO

用于从各种地图格式（特别是OSM格式）读取和写入地图。

# 5.OSM高精度地图

OSM—OpenStreetMap是lanelet2软件输出地图的标准格式。

首先，看一下OpenStreetMap的数据结构：

OpenStreetMap的元素（数据基元）主要包括三种：点（Nodes）、路（Ways）和关系（Relations），这三种原始构成了整个地图画面。其中，Nodes定义了空间中点的位置；Ways定义了线或区域；Relations（可选的）定义了元素间的关系。

## 5.1. Node

node通过经纬度定义了一个地理坐标点。同时，还可以height=*标示物体所海拔；通过layer=* 和 level=*，可以标示物体所在的地图层面与所在建筑物内的层数；通过place=* and name=*来表示对象的名称。同时，way也是通过多个点（node）连接成线（面）来构成的。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200604122432181.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L29yYW5nZV9saXR0bGVnaXJs,size_16,color_FFFFFF,t_70)

## 5.2. Way

通过2-2000个点（nodes）构成了way。way可表示如下3种图形事物（非闭合线、闭合线、区域）。对于超过2000 nodes的way，可以通过分割来处理。
Open polyline way(非闭合线)：收尾不闭合的线段。通常可用于表示现实中的道路、河流、铁路等。
Closed polyline closed way(闭合线)：收尾相连的线。例如可以表示现实中的环线地铁。
Area area(区域)：闭合区域。通常使用landuse=* 来标示区域等。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200604122504438.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L29yYW5nZV9saXR0bGVnaXJs,size_16,color_FFFFFF,t_70)

## 5.3. Relation

一个Relation可由一系列nodes, ways 或者其他的relations来组成，相互的关系通过role来定义。一个元素可以在relation中被多次使用，而一个relation可以包含其他的relation。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200604122541404.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L29yYW5nZV9saXR0bGVnaXJs,size_16,color_FFFFFF,t_70)

## 5.4. Tag

标签不是地图基本元素，但是各元素都通过tag来记录数据信息。通过’key’ and a 'value’来对数据进行记录。例如，可以通过highway=residential来定义居住区道路；同时，可以使用附加的命名空间来添加附加信息，例如：maxspeed: winter=*就表示冬天的最高限速。

![在这里插入图片描述](https://img-blog.csdnimg.cn/2020060412261394.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L29yYW5nZV9saXR0bGVnaXJs,size_16,color_FFFFFF,t_70)

## 5.5 OSM编辑软件JOSM

下面介绍一下osm的离线编辑器——JOSM。
JOSM 特色：最原汁原味的编辑器。最适合使用GPS轨迹绘图和在已有地图添加细节。有大量插件可以自动化常用操作
[JOSM软件下载链接](https://download.csdn.net/download/orange_littlegirl/12457361)

地图显示：

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200604123226766.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L29yYW5nZV9saXR0bGVnaXJs,size_16,color_FFFFFF,t_70)
地图编辑：

左边的工具栏：

这几个节点（nodes）常用的操作，第一个为：选择已有节点；第二个是：添加新节点；第三个是：地图的操作。下面几个比较简单，试一下就会了。在这也看出了nodes在osm中的重要性。
![在这里插入图片描述](https://img-blog.csdnimg.cn/2020060412361215.png)