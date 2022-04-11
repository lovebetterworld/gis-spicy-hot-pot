- [Lanelet2高精地图1——Lanelet2简介_fxfreefly的博客-CSDN博客_lanelet2](https://blog.csdn.net/bhniunan/article/details/121733823)

 Lanelet2是一个C++库，用于处理在[自动驾驶](https://so.csdn.net/so/search?q=自动驾驶&spm=1001.2101.3001.7020)情况下的地图数据。 它兼容并扩展了之前的lanelets库, 能够利用高清地图数据，以有效应对复杂交通情况下车辆所面临的挑战。 灵活性和可扩展性是应对未来地图挑战的一些核心原则。

Lanelet2地图采用分层结构，主要包括三层，分别为：
    1、[物理层](https://so.csdn.net/so/search?q=物理层&spm=1001.2101.3001.7020)（physical layer，可观测到的真实元素）
    2、关联层（relational [layer](https://so.csdn.net/so/search?q=layer&spm=1001.2101.3001.7020)，与物理层相关联的车道，区域以及交通规则）
    3、拓扑层（topological layer）

设计Lanelet2地图基于以下原则：

​    1、通过与可观察对象相关联来验证地图上的所有信息。

​    2、地图需要覆盖到所有可能区域，包括道路外的部分。

​    3、地图上各个车道和区域之间的交互作用必须是可识别和可理解的。必须能找出在哪些车道之间可能发生变道，或者在哪里可能由于交叉车道而引起冲突。

​    4、必须包含有关road user使用的区域的信息以及适用于他们的交通规则。

​    5、必须区分交通规则的来源及其对road user的影响。

​    6、可扩展性/模块化。

​    7、容易修改和更新。

​    Lanelet2高精地图的基本元素如下图所示：

![img](https://img-blog.csdnimg.cn/f26e81761f6d44fa95a9d7042d14fd22.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAZnhmcmVlZmx5,size_20,color_FFFFFF,t_70,g_se,x_16)

 1、Point（点）

​    Point由ID，3d坐标和属性组成，是唯一存储实际位置信息的元素，ID必须是唯一的。其他基本元素都是直接或者间接由Point组成的。在Lanelet2中，Point本身并不是有意义的对象，Point仅与Lanelet2中的其他对象一起使用有意义。

2、LineString（线串）

​    LineString是两个或者多个点构成的序列，用来描述地图元素的形状。线串可以是虚线，它可以通过高度离散化实现，来描述任何一维形式，并应用于地图上的任何可物理观察到的部分。线串可以高效计算，并且可以用来描述尖角。线串可以是区分方向的也可以是不区分方向的，可以是闭合的也可以是非闭合的。

3、Lanelet（车道）

​    Lanelet定义了发生定向运动时，地图车道的原子部分。原子表示沿当前lanelet行驶时，有效的交通规则不会改变，而且与其他Lanelet的拓扑关系也不会更改。lanelet可以引用表示适用于该lanelet的交通规则的regulatory element。多个lanelet可以引用同一regulatory element。必须始终可以直接从车道上确定车道的当前速度限制。

4、Area（区域）

​    Area是地图上没有方向或者是无法移动的部分区域，比如路标，停车位，绿化带等。他们由一条或者多条linestring组成的闭合的区域。Area也有相关联的regulatory element。

5、Polygon（多边形）

​    多边形与线串非常相似，但形成一个Area。隐式假定多边形的第一个点和最后一个点被连接以闭合形状。多边形很少用于传输地图信息（交通标志除外）。相反，它们通常用作将有关区域的自定义信息添加到地图的一种手段。

6、Regulatory Element

​    Regulatory Element是表达交通规则的通用方式，在应用的时候，Regulatory Element会和一个或者多个Lanelet、Area相关联。Regulatory Element是动态变化的，意味着它只是在某些条件下是有效的。诸如限速，道路优先级规则、红绿灯等，交通规则有许多不同的类型，因此每个Regulatory Element的准确结构大都不一样。他们通常引用定义规则的元素（例如交通标志），并在必要时引用取消规则的元素。

​    Lanelet2高精地图采用.OSM文件来表示。OSM—OpenStreetMap是lanelet2软件输出地图的标准格式。

​    OpenStreetMap的元素（数据基元）主要包括三种：点（Nodes）、路（Ways）和关系（Relations），这三种原始构成了整个地图画面。其中，Nodes定义了空间中点的位置；Ways定义了线或区域；Relations（可选的）定义了元素间的关系。

​    这篇文章对Lanelet2高精地图进行了基本的介绍，在后续的文章中，我们将对Lanelet2高精地图的元素进行展开介绍。