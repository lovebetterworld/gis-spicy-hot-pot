- [OpenX系列标准介绍（4）：OpenSCENARIO实例分析 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/343065975)

*本系列尝试对ASAM OpenX系列标准进行介绍。这是第四篇：*通过分析ASAM组织提供的一个OpenSCENARIO实例，来进一步介绍OpenSCENARIO格式

## 01 概览

本文使用的实例名称为End of Traffic Jam，可在ASAM官网[https://www.asam.net/standards](https://link.zhihu.com/?target=https%3A//www.asam.net/standards)获取。或者关注公众号adsimtest，并回复“OpenSCENARIO实例”来获取。

本实例中描述的场景如下图所示。初始状态本车（Ego）以车速100km/h在最右侧车道行驶，在其前方200m的本车道和左侧相邻车道各有一辆交通车（c1、c2）以车速80km/h行驶。c1行驶100m、c2行驶200m后各以5m/s2的减速度减速至70km/h。

![img](https://pic1.zhimg.com/80/v2-b797c1e3b7174757d691bdaab99bf41c_720w.jpg)

使用文本编辑器打开EndOfTrafficJam.xosc文件，如下图所示：

![img](https://pic4.zhimg.com/80/v2-12a1c8f810b866160c8191039bf8b70f_720w.jpg)

<OpenSCENARIO>为顶层节点，其下有多个子节点，其中：<FileHeader>描述了文件遵循的标准的版本和简介等；<ParameterDeclarations>通过参数名称和参数值的方式列举出了后面会用到的参数，便于直接引用参数名称、而不是参数值，从而方便了参数的修改和扩展；<RoadNetwork>中引用了本实例所运行的静态道路的OpenDRIVE文件；<Entities>中描述了场景的参与者的信息；<Storyboard>中描述了参与者的初始状态和动态变化。

## 02 场景参与者Entities

本实例中有三个参与者，本车（Ego）和两个交通车（A1和A2，分别对应前文的c1和c2）。这三个参与者在Entities中分为三个ScenarioObject来描述，用name来区分。如下图：

![img](https://pic3.zhimg.com/80/v2-3d698f50399e88cb58bbad904313aed6_720w.jpg)

以Ego为例，分为Performance、BoundingBox和Axles等条目，分别描述车辆的性能（最大车速、加减速度）、外形（几何中心和长宽高）和车轴（最大转向角、轮胎半径、轮距和轮心位置）等信息。另外，还描述了车辆的类型vehicleCategory和默认的驾驶员ObjectController。

## 03初始状态Storyboard->Init

Init中描述的初始状态包括天气环境的初始状态（在GlobalAction中描述）和参与者的初始状态（在Private中描述），如下图所示：

![img](https://pic3.zhimg.com/80/v2-579276919dbb841cbb671c14474da776_720w.jpg)

其中，GlobalAction中包括：（1）时间TimeOfDay，如年月日、时分秒；（2）天气Weather，如云层状态、太阳方位、可见距离和路面附着系数等。

Private中包括：（1）运动状态，如在纵向运动LongitudeAction描述的初始速度SpeedAction；（2）位置，在TeleportAction中描述，如Ego车位于roadId=1的道路的laneId=-3的车道，且纵向位置s=1000横向位置t=0。

## 04 动态变化Storyboard->Story

在不同的Act中对不同的参与者的行为变化进行描述，在Act中又按照ManeuverGroup->Maneuver->Event的层次将行为变化逐级分解，最终最基本的行为变化在Event之下的Action中体现，该Action发生的条件用在Event之下的StartTrigger描述。

本实例中A1行驶100m后以5m/s2的减速度减速至70km/h，描述方式如下图：

![img](https://pic2.zhimg.com/80/v2-87e604ffb300b2a6601da72bea0accd9_720w.jpg)

其减速的动作在<LongitudinalAction>中描述，<SpeedActionDynamics dynamicsShape="linear" value="$A1_Rate" dynamicsDimension="rate"/>表示速度按照线性变化，斜率为$A1_Rate，其中$A1_Rate在前面的<ParameterDeclarations>中定义为5，目标车速在<SpeedActionTarget>中设置。

减速条件在<StartTrigger>中描述，<TraveledDistanceCondition value="$A1_TriggeringDistance"/>表示行驶距离达到$A1_TriggeringDistance时满足触发条件，$A1_TriggeringDistance前面的<ParameterDeclarations>中定义为100。<Condition name="StartCondition1" delay="0" conditionEdge="rising">中的rising表示为上升沿触发，即条件由不满足变为满足的时刻，减速的动作开始执行。