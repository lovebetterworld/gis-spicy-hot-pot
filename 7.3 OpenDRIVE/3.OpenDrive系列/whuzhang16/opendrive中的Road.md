- [opendrive中的Road_whuzhang16的博客-CSDN博客](https://blog.csdn.net/whuzhang16/article/details/110672722)

路网在OpenDRIVE中用 <road> 元素来表示。每条道路都沿一条道路参考线延伸。一条道路必须拥有至少一条宽度大于0的车道。

OpenDrive中的道路可以与真实路网中或为应用而设的路网中的道路相提并论。每条道路由一个或多个 <road> 元素描述。一个 <road> 元素可以覆盖一条长路、交叉口之间较短的路，或甚至多条道路。只有在道路的属性不能在先前<road> 元素中得到描述或需要一个交叉口的情况下，才应开始一个新的 <road> 元素。

![img](https://img-blog.csdnimg.cn/20201204202615573.png)

![img](https://img-blog.csdnimg.cn/20201204202629303.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

## 1 道路段以及横截面的属性

某些道路属性是基于道路横截面得到描述的，道路横截面是道路参考线上给定点处的道路正交视图。超高程是一种与道路横截面相关的属性。如果元素对道路横截面有效，那么它对道路参考线上给定点处的整个宽度都有效。

其他道路属性是基于道路平面图得到描述的，其中包括车道和道路高程。这些属性称为道路段，其描述了道路的各个部分以及它们沿道路参考线s坐标的特定属性。对路段有效的属性仅对特定车道有效，可能对整个道路宽度无效。

这意味着可为不同属性（例如道路类型或车道段）创建不同的道路段，方式是使用新的起始s坐标以及 <road> 元素中的附加元素。两个给定s-起始位置之间的差别隐式地指定了组的长度。段的存储必须按s坐标升序来进行。

## 2 道路连接

为了能够在路网中行进，道路必须相互连接。道路可以连接到其他道路或交叉口上（孤立的道路除外）。

图35的场景展示了禁止、允许以及建议的道路连接方式。非常重要的是，相互连接的道路的车道及其参考线需与其前驱以及后继道路的车道及其参考线直接连接。如果参考线连接正确，则应该避免重叠或断口，但不完全禁止。

![img](https://img-blog.csdnimg.cn/20201204202847951.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

图36的场景展示了在交叉口外可行的道路连接方式，其中包括两条同向、反向或汇聚的道路。如果这两条参考线相互不连接，则也无法实现道路连接。

![img](https://img-blog.csdnimg.cn/20201204202916719.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

![img](https://img-blog.csdnimg.cn/20201204202935530.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

在OpenDRIVE中，道路连接用 <road> 元素里的 <link> 元素来表示。 <predecessor> 以及 <successor> 元素在<link> 元素中被定义。对于虚拟和常规的交叉口来说， <predecessor> 以及 <successor> 元素必须使用不同的属性组。

属性：
t_road_link
如果道路与一条后继、前驱或相邻道路连接，该属性则遵循道路头文件。孤立的道路可（may）忽略该元素。
t_road_link_predecessorSuccessor
必须将不同属性用于虚拟以及常规的交叉口。@contactPoint须（shall）用于常规交叉口；@elementS 和@elementDir则须（shall）用于虚拟交叉口。

![img](https://img-blog.csdnimg.cn/20201204204158327.png)

![img](https://img-blog.csdnimg.cn/20201204204217349.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

以下规则适用于道路连接:

- 只有在连接（linkage）清晰的情况下，才能直接连接两条道路。如果与前驱或后继的关系模糊，则必须使用交叉口。
- 道路可将其他道路或交叉口作为其后继或前驱，它也可以没有后继或前驱。
- 道路亦可作为自身的后继或前驱。

## 3 Road type 道路类型

道路类型（例如高速公路以及乡村公路）定义了道路的主要用途以及相关的交通规则。道路类型对于整个道路横截面均有效。

通过在沿参考线的给定点上定义不同道路类型，可在 <road> 元素中根据需要改变道路类型。道路类型将持续有效，直到另一个道路类型被定义。

在OpenDRIVE中，道路类型用<road>元素中的 <type> 元素来表示。道路类型本身在@type属性中被给定。

属性：
t_road_type
道路类型元素对于整个道路横截面持续有效，直到新的道路类型元素出现或者道路结束。

![img](https://img-blog.csdnimg.cn/20201204204501774.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

以下规则适用于道路类型:

- 当道路类型有变更时，必须在父级<road>元素中创建一个新的 <type> 元素。
- 可添加国家/地区代号以及州标识符至 <type> 元素中，以便对适用于该道路类型的国家交通规则进行详细说明。相关数据并不存储在OpenDRIVE中，它将存储于应用中。
- 只能使用ALPHA-2 国家/地区代号，ALPHA-3 国家/地区代号不能得以使用，原因是只有ALPHA-2 国家/地区代号才支持州标识符。
- 单独车道可能与其所属道路的类型不同。道路类型和车道类型代表不同的属性，若有具体说明，那么两种属性都为有效。

### 3.1 道路类型的限速


可为道路类型设置速度限制（限速）。若道路类型已更改且在路段中已有速度限制存在，由于道路类型并不拥有全局有效的速度限制，因此需要一个新的速度元素。必须为每个道路类型元素单独定义限速。
在OpenDRIVE中，速度限制用 <type> 元素里的 <speed> 元素来表示。

属性：
t_road_type_speed
该属性结合了特定的道路类型对默认的最大允许速度进行定义。

![img](https://img-blog.csdnimg.cn/20201204205927147.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

以下规则适用于速度限制:

- 最大速度可以（may）被定义为每个道路类型元素的默认值。
- 单独车道可以（may）有不同于其所属道路的速度限制，其将被定义为<laneSpeed>。
- 源自标志的限速必须（shall）始终被优先考虑。

## 4 高程的方法

以下几种方法用于标高道路或道路的部分:

- 道路高程详细说明了沿道路参考线（s方向）的高程。
- 通过使用超高程以及形状定义，横断面图将对与t方向参考线正交的高程进行详细说明。

![img](https://img-blog.csdnimg.cn/20201204210049533.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

s长度不随着高程变化。

### 4.1. Road elevation 道路高程


一条道路可沿其参考线被标高，需根据每个在参考线上给定点的道路横截面来对道路高程进行定义。高程以米为单位，道路的默认高程为零。若使用了地理坐标参考，则根据地理坐标参考对零进行定义。
在OpenDRIVE中，高程用 <elevationProfile> 元素中的 <elevation> 元素来表示。

属性：
t_road_elevationProfile_elevation
该属性定义了参考线上给定点处的高程元素。此外，必须（shall）沿参考线按升序对元素进行定义。s的长度不随高程而改变。

![img](https://img-blog.csdnimg.cn/20201204210220498.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

计算方式：
使用以下三次多项式函数来计算道路高程：
elev(ds) = a + b*ds + c*ds² + d*ds³
其中，elev 是给定位置上的高程（惯性 z）；a, b, c,d是系数；ds 是沿着参考线上新高程元素的起点与给定位置之间的距离

每当新的元素出现，`ds`则清零。使用以下公式对高程值的绝对位置进行计算：
s = s-start + ds
 其中,s 是参考线坐标系中的绝对位置;s-start 是元素在参考线坐标中的起始位置；

以下规则适用于道路高程:

- 道路必须沿其参考线被标高。
- 道路高程可单独或者结合超高程以及道路形状被定义。
- 对高程元素的定义必须按升序进行。由于高程可以上下移动，元素必须被连接到参考线上的相应位置。
- 道路高程的定义持续有效，直到该类型的下一个元素得到定义。

### 4.2 超高程

超高程是横断面图的一部分，它描述了道路的横坡。它可（may）用于将道路往内侧倾斜，从而使车辆更容易驶过。如图40所示，对于被超高程的道路而言，道路的t轴不与下层地形平行。因此，横断面图的定义适用于整个道路横截面。超高程不改变车道的实际宽度，但它会影响被投影的宽度。超高程的默认值为零。

超高程从数学角度被定义为围绕参考线的道路横截面的倾斜角。这意味着超高程对于向右边倾斜的道路具有正值，对于向左边倾斜的道路具有负值。

为简化上述示例，图40示例中的参考线平行于y轴。

![img](https://img-blog.csdnimg.cn/20201204210705320.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

在OpenDRIVE中，超高程用<lateralProfile>元素中的 <superelevation> 元素来表示。

属性：
t_road_lateralProfile_superelevation
该属性被定义为围绕着s轴的路段倾斜角。必须沿参考线按升序定义元素。元素的参数将持续有效，直到下一个元素开始或道路参考线结束。道路的超高程程默认为零。

![img](https://img-blog.csdnimg.cn/20201204210754420.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

计算方式
通过使用以下三次多项式函数，对超高程进行计算：
s (ds) = a + b*ds + c*ds2 + d*ds3

其中，s 是给定位置的超高程；a, b, c,d是系数；ds 是沿参考线上超高程元素的起点与给定位置之间的距离。

每当新的元素出现， ds 则清零。超高程值的绝对位置的计算方式如下：
s = ss + ds
其中，s是在参考线坐标系中的绝对位置；ss 是元素在参考线坐标系中的起始位置；

以下规则适用于超高程:

- 超高程的定义必须适用于整个道路横截面。
- 通过使用@level属性，道路的单条车道

### 4.3 形状定义

由于某些横向道路形状过于复杂，仅使用超高程来描述是不够的。通过形状则能够更详细地描述在参考线上给定点处的道路横截面的高程。这意味着，一个有多个t值的s坐标上可以拥有多个形状定义，从而对道路的弯曲形状进行描述。

如果不结合超高程而使用了形状，车道的实际宽度可能会由于其曲线的形状而被改变。相对于平面图的投影宽度不受影响。

如果结合超高程而使用了形状（如图41所示），相对于超高程状态的道路投影宽度不会变化，但相对于平面图的投影宽度会有变化。

如图42所示，被定义的t范围必须最少要覆盖到整个 <road> 元素的最大t展开式。

图41展示了如何对两个横断面图之间的高度信息进行计算。该图中的横断面图处于s 并拥有五个多项式定义，而处于s 的横断面图则拥有三个多项式定义。可使用图41中的公式对两个横断面图之间的一个点以及线性插值进行计算。

![img](https://img-blog.csdnimg.cn/20201204211428848.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

典型的应用案例是高速测试跑道以及路拱上的弯曲路面。形状的默认值为零。

![img](https://img-blog.csdnimg.cn/20201204211451478.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

属性
t_road_lateralProfile_shape
该属性被定义为相对于参考水平面路段的路面。一个拥有不同t值的s位置上可存在多个形状，从而对道路的弯曲形状进行描述。

![img](https://img-blog.csdnimg.cn/20201204211529658.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

计算方式
通过以下多项式函数可对横断面图的形状进行计算：
h (ds)= a + b*dt + c*dt2 + d*dt3
 其中，h 是给定位置参考平面上方的高度；a, b, c,d是系数，dt 是形状元素起点和给定位置之间垂直于参考线的距离

每当新的元素出现， dt 则清零。形状值的绝对位置用如下方式计算：
t = tstart + dt
 其中，t 是参考线坐标系中的绝对位置，tstart  是元素在参考线坐标系中的起始位置。

以下规则适用于形状：

- 可结合超高程以及道路高程对形状进行定义。
- 在使用形状时，不应该存在任何车道偏移。

## 5.  道路表面

OpenDRIVE并不包含对道路表面的描述，该类描述则包含在OpenCRG中，但OpenDRIVE可以引用在OpenCRG中生成的数据。两者均不包含有关道路表面视觉展示的数据。借助OpenCRG可以对更细节化的道路表面属性进行建模，例如图43中的卵石或坑洼。

![img](https://img-blog.csdnimg.cn/20201206165956936.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

如CRG的名称所示，CRG数据被置于常规网格中，该网格是沿参考线被布置的（类似OpenDRIVE的道路参考线）。在每个网格位置上，它都包含了在真实道路上测量到的绝对高程和某些附加数据，这些数据可以对相对于参考线的delta高程进行计算。将OpenDRIVE和CRG数据进行结合的关键在于对两条参考线之间的相关性以及一条使用两者高程数据的规则进行定义。CRG数据可能会与OpenDRIVE道路参考线有偏差（参见@tOffset），其方向可能与道路布局方向相同或者相反（参见方向）。

![img](https://img-blog.csdnimg.cn/20201206170036764.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

可在不同模式下将CRG数据应用于给定的OpenDRIVE道路：
@mode = attached附加:
出于对@tOffset以及@sOffset参数的考虑，CRG数据集的参考线将被替换为OpenDRIVE道路的参考线。通过对CRG网格的评估以及@zOffset和@zScale的应用后得出CRG局部高程值，该值会被添加到OpenDRIVE道路的表面高程数据中（该数据衍生于高程、超高程以及路拱的组合）。无需考虑道路的全方位几何是否匹配，这个模式可用于将相对于原始CRG数据的参考线的道路表面信息从任意CRG道路转移到OpenDRIVE道路中。CRG道路的原始位置、航向角/偏航角、曲率、高程以及超高程均不在考虑范围内。CRG网格的评估是沿OpenDRIVE参考线，而不是沿CRG参考线而进行的。

![img](https://img-blog.csdnimg.cn/20201206170122670.png)

![img](https://img-blog.csdnimg.cn/20201206170141145.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

![img](https://img-blog.csdnimg.cn/20201206170157648.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

该模式与附加模式基本无异，唯一与附加模式不同的是只有CRG数据的高程值会被作为关注对象（即OpenDRIVE高程被设置为零）。为了避免出现问题，需准确地将@sStart及@sEnd设置为CRG数据的边界，否则可能会出现如下图中的高度为零的缺口。

![img](https://img-blog.csdnimg.cn/2020120617022513.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

CRG数据集参考线的起点相对于OpenDRIVE道路参考线上的点位于由@sStart、@sOffset和@tOffset定义的位置上。通过为横向以及纵向移位、航向角/偏航角(@hOffset)以及高程(@zOffset)提供偏移值，可以明确OpenCRG与OpenDRIVE各自的参考线之间的相关性。在真实（genuine）模式中，CRG数据会完全取代OpenDRIVE高程数据，也就是说，会直接从CRG数据中计算出道路表面给定点的绝对高程（可把这看成将OpenDRIVE高程、超高程和路拱均设为零时，对CRG和OpenDRIVE数据进行合并）。若使用该方法， 必须确保CRG数据的几何形状在一定的范围内与下层的OpenDRIVE道路几何是匹配的。

![img](https://img-blog.csdnimg.cn/20201206170307749.png)

![img](https://img-blog.csdnimg.cn/20201206170318771.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

@mode = global全局:
数据集仅从给定轨道或交叉口记录中引用，但并无平移或旋转转换可被应用。CRG文件中的所有数据保留在其原生的坐标系中。高程数据被认作为是惯性数据，也就是AS IS。

@orientation 定向
由于CRG数据可能只覆盖了道路表面部分，所以必须确保衍生于OpenDRIVE数据的高程信息在有效的CRG范围外依然可以得以使用。在OpenDRIVE中，道路表面用 <road> 元素里的 <surface> 元素来表示，OpenCRG中描述的数据则用<surface> 元素里的<CRG>元素来表示。

![img](https://img-blog.csdnimg.cn/2020120617042761.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

![img](https://img-blog.csdnimg.cn/20201206170442624.png)

方向属性在OpenCRG的u/v坐标系的原点处沿着CRG文件进行旋转。"same"值的旋转角度为0，"opposite"值则为180°。T-偏移不被方向属性所影响。

属性
t_road_surface_CRG

![img](https://img-blog.csdnimg.cn/20201206170522134.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

![img](https://img-blog.csdnimg.cn/20201206170547671.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

![img](https://img-blog.csdnimg.cn/20201206170614511.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

XML示例

```XML
<surface>
    <CRG file="fancyData.crg" sStart="0.0" sEnd="100.0" orientation="same" mode="attached"
         tOffset="0.0">
    </CRG>
</surface>
```

## 6 道路的应用案例

以下小节包含部分在OpenDrive中对道路进行建模的示范应用案例。

### 6.1 用线性路拱对道路形状进行建模

许多道路都有一个路拱，例如用于提供一个排水坡度从而让水能从路面上流入水沟中。
图50展示了一个拥有路拱的两车道路的样本定义。

![img](https://img-blog.csdnimg.cn/20201206170802171.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

线性路拱拥有以下属性:

- 道路的宽度从t=-4开始。由于值为0，因此在高度到t=-3的范围内不会有任何改变。
- 从t = -3到t = 0，每米线性上升0.15米。这意味着，在t = 0（道路的中间）处，道路已达到0.45m的高度。
- 从t = 0.45m开始，道路每米线性下降0.1米。这意味着，当达到t = 4时，道路的高度为0.05m（0.45m-0.40m为0.05m；在4m距离后，道路每米损失0.1m；当从0.45m开始时，终点则为0.05 m）。

XML结构用于描述路拱，< lateralProfile >中的<shape>元素可被使用；对道路形状进行建模，形状元素必须在处于正t方向的道路的右侧开始。这意味着元素将会以负t值的形式开始。