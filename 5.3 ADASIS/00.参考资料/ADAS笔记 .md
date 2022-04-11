- [ADAS笔记 - 多弗朗强哥 - 博客园 (cnblogs.com)](https://www.cnblogs.com/chendeqiang/p/12861695.html)

## ADAS

高级驾驶辅助系统（Advanced Driving Assistance System）是利用安装在车上的各式各样传感器（毫米波雷达、激光雷达、单\双目摄像头以及卫星导航），在汽车行驶过程中随时来感应周围的环境，收集数据，进行静态、动态物体的辨识、侦测与追踪，并结合导航仪地图数据，进行系统的运算与分析，从而预先让驾驶者察觉到可能发生的危险，有效增加汽车驾驶的舒适性和安全性。 

近年来ADAS市场增长迅速，原来这类系统局限于高端市场，而现在正在进入中端市场，与此同时，许多低技术应用在入门级乘用车领域更加常见，经过改进的新型传感器技术也在为系统布署创造新的机会与策略。

## ADASIS

ADASIS是什么？ADASIS的全称是AdvancedDriver Assistant Systems Interface Specifications， 即ADAS的接口说明。ADASIS定义了地图在ADAS中的数据模型及传输方式，以CAN作为传输通道。可以说它是一个标准，也可以说它是一个标准组织，国内做地图的朋友会比较了解。

ADAS的实现离不开车辆上的各种传感器，但无论是什么传感器，都只能监控车辆周边的区域，监控范围是有限的。如果能够让车辆获取到更远地方的数据，那么ADAS的功能必然可以得到增强。在当前基础设施不具备的情况下，依靠V2X和云端技术都是不现实的。所以以传统地图为基础，提供车辆对远方的感知能力是一个务实的选择。

**满足ADAS需要的地图就是ADAS地图，它介于普通的导航电子地图和高精度地图之间。ADAS地图的精度一般在 1-5 米左右**，它是在普通的导航电子地图的基础上进行了扩充，比如在道路上补充了一些坡度、曲率、航向的一些辅助信息。另外也涵盖了车道数量、车道宽度的信息，并且道路的精度和形状信息更加的准确，只是这些信息的精度都和高精度地图有一个数量级的差别。

[![坡度](https://pagepig.oss-cn-hangzhou.aliyuncs.com/20200117212902.png?x-oss-process=image/resize,m_lfit,h_450)](https://pagepig.oss-cn-hangzhou.aliyuncs.com/20200117212902.png?x-oss-process=image/resize,m_lfit,h_450)
在上图中，传感器无法判断坡度，因而会给错误的提示。如果结合ADAS地图的坡度信息，就可以更好的执行辅助驾驶。

ADAS系统包括感知系统、通信系统、决策系统和控制系统，要让地图信息在车辆的各个子系统中自由传输，统一的地图与ADAS系统之间的通信协议是必需的。为了消除各图商、ADAS零部件供应商之间协议的差异，并且更有利于ADAS地图的推广，在2001年5月，来自欧洲汽车行业的汽车制造商、车载系统开发商以及图商联合起来成立了ADASIS Forum，制定地图与ADAS系统之间的通信协议，也就是ADASIS。

ADASIS Forum的工作包括两个：

1. 制定一套开源标准的系统架构，用来提取并重构ADAS系统所需的数据；
2. 制定统一的地图数据（含车辆位置数据）的接口协议，让数据能够成功被提取并传输到ADAS系统之中。

后来ADASIS Forum被纳入到ERTICO（ITS Europe，欧洲智能交通组织）中。

ADASIS v1验证了技术上的可行性，但并不是一个成熟的协议，过于复杂，基本上没有企业采用。因此，ADASIS Forum在2012年7月发布了第二版标准说明，即ADASIS v2。v2着重降低系统占用的CAN总线资源，以及使用最小原则提取并重构数据。目前ADASIS v2已经被多家车厂采用。

ADASIS v2结构中包含以下几个部分：

- ADAS Horizion Provider：地图信息提供者，负责数据组织与发送
- ADAS Protocol：ADASIS协议
- ADAS Application（ADAS Horizion Reconstructor）：ADAS应用，负责数据接收与解析及数据的使用。
- CAN Bus作为信息传送的通道

[![img](https://pagepig.oss-cn-hangzhou.aliyuncs.com/20200117213118.png?x-oss-process=image/resize,m_lfit,h_450)](https://pagepig.oss-cn-hangzhou.aliyuncs.com/20200117213118.png?x-oss-process=image/resize,m_lfit,h_450)

ADASIS Forum自2015年6月开始研究ADASIS v3以及基于车身以太网的传输方式。ADASIS v3计划2017年下半年发布。

ADASIS v3支持高度自动驾驶HAD。

------

汽车导航很普遍了，地图数据不仅可以用于导航的路径规划，还可以用于汽车内的其他应用程序，如车灯控制、增强导航及巡航控制等安全程序。

ADASIS 的目标是：

1. 制定一个定义汽车周边的地图数据和模型的开放标准，这样，地图数据可以在导航及其他程序间传输。
2. 制定一个开放标准，各种ADAS程序能获取车辆位置相关信息，如CAN-bus上的数据。

汽车上的各种传感器只能获取周围比较小范围的的状况，而地图数据可以看做汽车上一个更大能力的传感器。地图数据包括几何形状、公路等级、车道数目、限速、交通标志等等。由此，汽车能估计出MLP（most likely path）最有可能的路径。

ADASIS v1  制定了利用车辆位置与地图数据，来估计道路几何形状的标准。但各个公司都采用了自己的的解决方案，原因是v1比较复杂，能估计多条道路，并增加了数据传输的开销。v2版本就显得比较简洁，基于单路径估计，CAN-bus作为数据的传输层。

v2中的两个概念：

1. 道路的表示和汽车的位置： 道路由一系列连接起来的点表示，两点之间形成了一个SEGMENT。而车的位置，由车距离SEGMENT起始点的偏移量offset表示。
2. 除了MLP最有可能的路径外，还有多条备选的路径，作为扩展可选功能。

ADASIS v2定义了三种数据类型：

1. 汽车位置
2. 汽车环境信息，包括MLP可能路径的属性。
3. 元数据，定义本协议的一些信息，包括接口版本、地图版本及国家代码等。

以下是v2制定的重要的数据结构，及其应该包含的内容：

位置信息（POSITION）的主要内容包括：路径编号、偏移量offset、速度、与道路的相对方向、当前所在车道、置信度及时间timestamp（相对于上一个GPS信息的时间）。

道路(SEGMENT)的主要内容包括：路径编号、公路等级、类型（如大路、转盘、停车场等）、道路组成（如高速、单双车道等）、限速、车道数目、方向、（隧道、桥梁、分岔路、紧急车道、计算路径、服务区及复杂交叉路口的标志）。

STUB信息（类似SEGMENT之间交点）：路径编号、子路径的编号、转角（与下一路段的夹角）、是交叉路口的概率、道路类型及组成、正反向的车道数目、转弯点（转弯到另外一条路上）、是否复杂的交叉路口。

道路形状（PROFILE）的主要内容：路径编号、轮廓类型、轮廓序列点（用于本路段内位置的插值计算）、曲率（高阶插值）。

元数据（META-DATA）的主要内容包括：国家代码、区域（州县）代码、驾驶位（左、右）、速度单位、协议大小版本、硬件版本、地图提供商、地图版本、Horizon Provider兼容和模式信息。

## 应用范例：

ASR（Adaptive Speed Recommendation）是ADAS中地图数据的典型应用。

ASR要考虑以下因素：曲率、法定限速、十字路口、转盘。

ASR在减速的区域，会提前50-300米提醒用户减速，提前提醒的距离会依据目前车速、汽车刹车速度及司机反映时间。 在有转弯（curve）的路段，要考虑路宽、车道数目、整个路况等，ASR会综合以上因素计算合理的汽车速度。不过，目前地图中道路的曲率的精度不是一直都很精确，所以，一般需要估计和矫正模型进行计算，即ASR要有一定的学习能力。

## 参考链接：

https://www.sohu.com/a/200471073_391994
https://baike.baidu.com/item/高级驾驶辅助系统/16837281?fromtitle=ADAS&fromid=11003651&fr=aladdin
https://blog.csdn.net/viewcode/article/details/7840061

## 其他参考链接：

https://blog.csdn.net/weixin_42229404/article/details/82623742?depth_1-utm_source=distribute.pc_relevant.none-task&utm_source=distribute.pc_relevant.none-task
https://blog.csdn.net/liaojiacai/article/details/55062873
https://blog.csdn.net/usstmiracle/article/details/95356324
https://blog.csdn.net/amap_tech/article/details/102849291