- [opendrive中的Lanes_whuzhang16的博客-CSDN博客](https://blog.csdn.net/whuzhang16/article/details/110747232)

在OpenDRIVE中，所有道路都包含了车道。每条道路必须拥有至少一条宽度大于0的车道，并且每条道路的车道数量不受限制。

需要使用中心车道对OpenDRIVE中的车道进行定义和描述。中心车道没有宽度，并被用作车道编号的参考，自身的车道编号为0。对其他车道的编号以中心车道为出发点：车道编号向右呈降序，也就是朝负t方向；向左呈升序，也就是朝正t方向。

图51展示了一条道路的中心车道，该车道拥有多条交通车道以及不同的行驶方向。在这个示例中，根据靠左行车以及靠右行车的交通模式，中心车道将道路[类型](https://so.csdn.net/so/search?q=类型&spm=1001.2101.3001.7020)中定义的行驶方向分隔开来。由于并未使用车道偏移，因此中心车道等同于道路参考线。

![img](https://img-blog.csdnimg.cn/20201206171119663.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

![img](https://img-blog.csdnimg.cn/2020120617113870.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

在OpenDRIVE中，车道用 <road> 元素里的 <lanes> 元素来表示。

以下规则适用于车道的使用：

- 每条道路必须拥有一条中心车道及一条宽度大于0的车道。
- 道路可根据需要而设定任意数量的车道。
- 中心车道不能拥有宽度，这就意味着不能将<width>元素用于中心车道。
- 中心车道编号必须为0。
- 车道编号必须在中心车道之后从1开始，朝负t方向为降序，朝正t方向为升序。
- 车道编号必须保持连续性且无任何间断。
- 每个车道段都必须有唯一的车道编号。
- 可通过使用<lane>元素的@type属性对双向车道进行详细说明。

XML示例

![img](https://img-blog.csdnimg.cn/20201206171344827.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

## 1 在车道段中进行车道分组

为了能够便利地在OpenDRIVE道路描述中进行查找，一个车道段内的车道可分为左、中和右车道，车道在该组中用 <lane> 元素来描述。由于车道编号朝负t方向呈降序且朝正t方向呈升序，应用可从ID属性中给出的车道编号中得知车道的方向（除非@type是双向的）。

![img](https://img-blog.csdnimg.cn/20201206171438582.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

在OpenDRIVE中，车道组用 <laneSection> 元素内的 <center> 、 <right> 和 <left> 元素来表示。ID属性用嵌套在<center> 、 <right 和 <left> 元素里的 <lane> 元素来定义。

以下规则适用于车道分组：

- 带有正ID的车道在中心车道的左侧，而带有负ID的车道则在中心车道的右侧。
- 每个车道段必须包含至少一个<right>或<left>元素。
- 必须给每个s坐标定义一个<center>元素。
- 每个车道段都可包含一个<center>元素。
- 为了能够更好地确认方向，车道应按照降序ID按从左到右的顺序排列。

## 2 车道段

车道可被分成多个段。每个车道段包含车道的一个固定编号。如图56所示，每次车道编号的变更都随之产生一个新车道段的需求。车道段的定义将沿道路参考线按升序来进行。

图56中，路段被分割成不同的车道段。若车道编号改变，则需要定义一个新的车道段。

![img](https://img-blog.csdnimg.cn/20201206171621572.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

为了能更轻易地在复杂道路上对车道段进行使用，可仅使用@singleSide属性对道路的一侧进行定义。图57展示了这一原理。

![img](https://img-blog.csdnimg.cn/20201206171648539.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

在OpenDRIVE中 ，车道段用 <lanes> 元素里的 <laneSection> 元素来表示。

属性
t_road_lanes_laneSection：
车道可（may）被分成多个段，每个车道段都包含一个车道的固定编号。每一次的车道编号变更都将需要定义一个新的车道段。

![img](https://img-blog.csdnimg.cn/20201206171748467.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

t_road_lanes_laneSection_center：
为了能够便利地在OpenDRIVE的道路描述中进行查找，一个车道段内的车道可分为左、中和右车道。每个车道段均必须包含一个<center>元素和至少一个<right>或<left>元素。

t_road_lanes_laneSection_center_lane：
车道元素被包括在左/中/右元素中。车道元素必须使用降序ID从左到右展示车道。

![img](https://img-blog.csdnimg.cn/20201206171844134.png)

t_road_lanes_laneSection_left：
为了能够便利地在OpenDRIVE的道路描述中进行查找，一个车道段内的车道可分为左、中和右车道。每个车道段均必须包含一个<center>元素和至少一个<right>或<left>元素。
t_road_lanes_laneSection_left_lane：
车道元素被包括在左/中/右元素中。车道元素必须使用降序ID从左到右展示车道。

![img](https://img-blog.csdnimg.cn/20201206171932960.png)

t_road_lanes_laneSection_right：
为了能够便利地在OpenDRIVE的道路描述中进行查找，一个车道段内的车道可分为左、中和右车道。每个车道段均必须包含一个<center>元素和至少一个<right>或<left>元素。

t_road_lanes_laneSection_right_lane：
车道元素被包括在左/中/右元素中。车道元素必须（should）使用降序ID从左到右展示车道。

![img](https://img-blog.csdnimg.cn/20201206172032137.png)

以下规则适用于车道段：

- 每条道路都必须拥有至少一个车道段。
- 车道段必须按升序来定义。
- 每个s位置上都必须只有一条中心车道。
- 应该避免在长距离上使用宽度为0的车道。
- 每次车道编号改变都必须有新的车道段被定义。
- 车道段将持续有效，直到一个新的车道段被定义。
- 可根据需要多次更改一个车道段内的车道属性。
- 可仅使用@singleSide属性为道路的一侧对车道段进行定义。

## 3. 车道偏移

车道偏移可用于将中心车道从道路参考线上位移，以便能够更轻松地在道路上对车道的局部横向位移进行建模（比如对左转车道进行建模）。
根据用于车道偏移的插值，车道偏移和形状定义两者的组合可导致不一致性。若线性插值被用于定义沿参考线的道路形状，那么它也应被用于偏移定义，以便两者的定义能被一致地组合使用。
图58展示了中心车道偏离道路参考线而产生的偏移。

![img](https://img-blog.csdnimg.cn/20201206172226433.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

在OpenDRIVE中，车道偏移用<lanes>元素内的<laneOffset>元素来表示。

属性
t_road_lanes_laneOffset：
车道偏移可用于将中心车道从道路参考线上位移。

![img](https://img-blog.csdnimg.cn/20201206172319200.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

计算方式
利用以下三阶多项式函数来计算给定点的偏移：
[offset](https://so.csdn.net/so/search?q=offset&spm=1001.2101.3001.7020) (ds) = a + b*ds + c*ds² + d*ds³
 其中，offset 是在给定点处的横向偏移；a, b, c,d是系数；ds是新的道路偏移元素起始处和给定位置之间沿道路参考线产生的距离。

每当新的元素出现， ds 则清零。偏移值的绝对位置计算方式如下：
s = ss + ds

其中，s是参考线坐标系统中的绝对位置，ss是参考线坐标系统中元素的起始位置。

每一次的多项式函数变更都需要一个新的车道偏移元素。

![img](https://img-blog.csdnimg.cn/20201206172549310.png)

以下规则适用于车道偏移：

- 车道偏移不能与道路形状一同使用。
- 当底层的多项式函数有变化时，必须启动一个新的车道偏移。
- 若边界定义已存在，则不允许出现偏移。

## 4 车道连接

车道的连接信息被存储在OpenDRIVE中以便进行车道查找，并将借助于每条车道的前驱以及后继信息来对连接进行描述。车道和交叉口均可作为车道的前驱和后继部分。车道可连接至相同或不同道路上的其他车道上。

![img](https://img-blog.csdnimg.cn/2020120617270775.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

在OpenDRIVE中，车道连接用<lane>元素里的<link>元素来表示。<predecessor>和<successor>元素在<link>元素内得到定义。

属性
t_road_lanes_laneSection_lcr_lane_link：
前面的和后置车道信息为有着相同参考线的车道之间的连接提供了车道在前面的以及后置车道段中的ID。只有在车道在一个路口结束或不具有物理连接时，这一元素才可被删除。
t_road_lanes_laneSection_lcr_lane_link_predecessorSuccessor：

![img](https://img-blog.csdnimg.cn/20201206172806326.png)

以下规则适用于车道连接：

- 一条车道可拥有另外一条车道作为其前驱或后继。
- 只有当两条车道的连接明确时，它们才能被连接。若与前驱或后继部分的关系比较模糊，则必须使用交叉口。
- 若车道结束于一个路口内或没有任何连接，则必须删除 <link> 元素。

## 5 车道属性

车道属性描述了车道的用途以及形状。每个车道段都定义了一条车道属性，该属性也可能在该车道段中有变化。如果没有特意为车道段定义一条属性，应用便可采用默认属性。

车道属性的示例是车道宽度、车道边界和限速。

以下规则适用于车道属性：

- 车道属性的定义必须相对于相应车道段的起点来展开。
- 直到另外一个同类型的车道属性得到定义或车道段结束，特定的车道属性都必须保持有效。
- 相同类型的车道属性必须按升序定义。

### 5.1 车道宽度

车道的宽度是沿t坐标而定义的。车道的宽度有可能在车道段内产生变化。

车道宽度与车道边界元素在相同的车道组内互相排斥。若宽度以及车道边界元素在OpenDRIVE文件中同时供车道段使用，那么应用必须使用 <width> 元素提供的信息。

在OpenDRIVE中，车道宽度由 <lane> 元素中的 <width> 元素来描述。

属性
t_road_lanes_laneSection_lr_lane_width：
车道的宽度必须在每个车道段里至少被定义一次。中心车道不能有宽度，也就意味着不能对中心车道使用 <width> 元素。车道的宽度都必须保持有效，直到一个新的宽度元素被定义或车道段结束。

![img](https://img-blog.csdnimg.cn/20201206173124233.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

计算方式
利用以下三阶多项式函数来计算给定点的宽度：
Width (ds) = a + b*ds + c*ds² + d*ds³
 其中，width是给定点处的宽度；a, b, c,d是系数；ds 是新的道路宽度元素起始处和给定位置之间沿道路参考线产生的距离

每当新的元素出现， ds 则清零。宽度值的绝对位置计算方式如下：

![img](https://img-blog.csdnimg.cn/20201206173309521.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

![img](https://img-blog.csdnimg.cn/20201206173327600.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

以下规则适用于车道宽度：

- 车道的宽度必须在每个车道段中至少被定义一次。
- 必须为整个车道段的长度定义车道宽度。这意味着s=0必须要有一个<width>元素。
- 中心车道不能拥有宽度，也就是说不能对中心车道使用<width>元素。
- 直到新的宽度元素被定义或者车道段结束，车道的宽度都保持有效。
- 当多项式函数的变量发生改变时，新的宽度元素必须得到定义。
- 每个车道段的多个宽度元素都必须按升序得到定义。
- 不能在相同车道组里同时使用宽度元素以及边界元素。

### 5.2 车道边界

车道边界是用来描述车道宽度的另一种方法，它并不会直接定义宽度，而是在独立于其内部边界参数的情况下，对车道的外部界限进行定义。根据上述情况，内车道也被定义为车道，该车道虽然与当前被定义的车道有着相同ID符号，但内车道的ID绝对值要更小。

相比较对宽度进行详细说明而言，此类定义要更加地便利。尤其是在道路数据是源自于自动测量结果的情况下，该方式可以避免多个车道段被创建。

车道宽度与车道边界元素在相同的车道组内互相排斥。若宽度以及车道边界元素在OpenDRIVE文件中同时供车道段使用，那么应用必须使用 <width> 元素提供的信息。

在OpenDRIVE中，车道边界用 <lane> 元素中的 <border> 元素来表示。

属性
t_road_lanes_laneSection_lr_lane_border：

![img](https://img-blog.csdnimg.cn/2020120617354581.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

![img](https://img-blog.csdnimg.cn/20201206173616860.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

![img](https://img-blog.csdnimg.cn/20201206173632220.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

![img](https://img-blog.csdnimg.cn/20201206173648913.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

以下规则适用于车道边界：

- 不能在相同车道组内一同使用宽度元素以及边界元素。
- 边界元素不能和车道偏移同时存在。
- 当多项式函数的变量发生改变时，必须要定义一个新的边界元素。

### 5.3 车道类型

每条车道都会被定义一个类型。车道类型定义了车道的主要用途及与其相对应的交通规则。

可用的车道类型有：
路肩shoulder：描述了道路边缘的软边界。
边界border：描述了道路边缘的硬边界。其与正常可供行驶的车道拥有同样高度。
驾驶driving：描述了一条“正常”可供行驶、不属于其他类型的道路。
停stop：高速公路的硬路肩，用于紧急停车。
无none：描述了道路最远边缘处的空间，并无实际内容。其唯一用途是在（人类）驾驶员离开道路的情况下，让应用记录
OpenDRIVE仍在运行。
限制restricted：描述了不应有车辆在上面行驶的车道。该车道与行车道拥有相同高度。通常会使用实线以及虚线来隔开这类
车道。
泊车parking：描述了带停车位的车道。
分隔带median：描述了位于不同方向车道间的车道。在城市中通常用来分隔大型道路上不同方向的交通。
自行车道biking：描述了专为骑自行车者保留的车道。
人行道sidewalk：描述了允许行人在上面行走的道路。
路缘curb：描述了路缘石。路缘石与相邻的行车道在高度有所不同。
出口exit：描述了用于平行于主路路段的车道。主要用于减速。
入口entry：描述了用于平行于主路路段的车道。主要用于加速。
加速车道onramp：由乡村或城市道路引向高速公路的匝道。
减速车道offRamp：驶出高速公路，驶向乡村或城市道路所需的匝道。
连接匝道connectingRamp：连接两条高速公路的匝道。例如高速公路路口。

![img](https://img-blog.csdnimg.cn/20201206173820374.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

![img](https://img-blog.csdnimg.cn/20201206173841618.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

![img](https://img-blog.csdnimg.cn/20201206173859111.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

![img](https://img-blog.csdnimg.cn/20201206173911827.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

在OpenDRIVE中，车道类型用<lane>元素内属性@type元素来表示。

属性
t_road_lanes_laneSection_lr_lane：
车道元素元素被包括在左/中/右元素元素中。车道元素元素应按降序ID从左到右展示车道。

![img](https://img-blog.csdnimg.cn/20201206173955119.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

以下规则适用于车道类型：
可（may）通过使用新的车道段根据需要多次地更改车道类型。

### 5.4 车道材质

除OpenCRG之外，OpenDRIVE提供了一个用于存储车道材质信息（即表面、摩擦属性及粗糙程度）的元素。若未对材质进行定义，那么应用可采用默认值。

在OpenDRIVE中，车道材质用<lane>元素内的<material>元素来表示。

属性
t_road_lanes_laneSection_lr_lane_material：
该属性存储了关于车道材质的信息。直到新的元素得到定义，每个元素都将保持有效。若有多个元素得到定义，它们必须按升序被排列。

![img](https://img-blog.csdnimg.cn/20201206174118986.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

以下规则适用于车道材质：

- 中心车道不能拥有材质元素。
- 直到另一材质元素得到启动或车道段结束，车道的材质元素都必须保持有效。
- 若每个车道段都各自拥有多个材质元素，那么这些元素必须相对于s位置按升序得到定义。

### 5.5 车道限速

![img](https://img-blog.csdnimg.cn/20201206174225138.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

在OpenDRIVE中，车道速度用<lane>元素内的<speed>元素来表示。

属性
t_road_lanes_laneSection_lr_lane_speed：
该属性定义了给定车道上允许的最大行驶速度。直到新的元素得到定义，每个元素都在s坐标的增长方向中继续有效。

![img](https://img-blog.csdnimg.cn/20201206174300316.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

![img](https://img-blog.csdnimg.cn/20201206174313240.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

以下规则适用于车道限速：

- 中心车道不能拥有任何限速。
- 除非有另一个限速得到定义或车道段结束，车道的限速都必须保持有效。
- 若每个车道段都拥有多个车道限速元素，那么这些元素必须按升序得到定义。
- 源自于标志的限速必须始终被优先考虑。

### 5.6 车道的使用

车道可局限于特定的道路使用者，例如卡车或公共汽车。这类限制可在道路标识描述的限制之上另外在OpenDRIVE中得到定义。

![img](https://img-blog.csdnimg.cn/20201206174545910.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

OpenDRIVE在 <lane> 元素内提供了 <access> 元素，以便描述车道使用规则。

t_road_lanes_laneSection_lr_lane_access：
该属性定义了针对特定道路使用者类型的车道使用限制。
每个元素在s坐标的增长方向中都是有效的，直到新的元素得到定义。若多个元素得到定义，那它们必须按升序得到排列。

![img](https://img-blog.csdnimg.cn/20201206174635315.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

![img](https://img-blog.csdnimg.cn/20201206174649427.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

![img](https://img-blog.csdnimg.cn/2020120617470863.png)

以下规则适用于车道使用规则：
中心车道不能（shall）拥有使用规则。
直到另一条使用规则得到定义或车道段结束，使用规则都必须（shall）保持有效。
若每个车道段都拥有多个使用规则元素，那么这些元素必须（shall）按升序得到定义。
车道使用元素可（may）在相同偏移位置开始。
若一个车道元素内无 <access> 元素存在，则也没有使用限制。
若 <rule> 元素里出现否定值，那么所有其他车辆仍被允许使用车道。
若 <rule> 元素里出现允许值，那么所有其他车辆则被禁止使用车道。
只能为给定s位置赋予否定值或允许值的其中一个，二者不能同时出现。
即便只有一个子集被改变，都必须（must）为所有限制重新定义一个新的s位置。
否定=无 deny=none 这个限制被用于恢复所有先前限制。

### 5.7 车道高度

车道高度必须沿h坐标得到定义。无关于道路高程，车道高度可用于标高车道。车道高度用于执行如图71所示的小规模高程，该图展示了人行通道如何通过车道高度被拔高。车道高度被认为是偏离道路并朝z方向的偏移（包括高程、超高程和形状）。

![img](https://img-blog.csdnimg.cn/20201206174809968.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

在OpenDRIVE中，车道高度用<lane>元素内的<height>元素来表示。

![img](https://img-blog.csdnimg.cn/20201206174833444.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

 