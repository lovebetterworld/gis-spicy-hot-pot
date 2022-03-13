- [OpenX系列标准介绍（3）：OpenSCENARIO介绍 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/176374167)

## 01 概览

作为一个完整的仿真测试场景描述方案，OpenX系列标准包括：OpenDRIVE、OpenCRG和OpenSCENARIO。仿真测试场景的静态部分（如道路拓扑结构、交通标志标线等）由OpenDRIVE文件描述，道路的表面细节（如坑洼、卵石路等）由OpenCRG文件描述；仿真测试场景的动态部分（如交通车的行为）由OpenSCENARIO文件描述。如下图所示：

![img](https://pic1.zhimg.com/80/v2-16b71dc9ec9eaa45ac81e156b8316500_720w.jpg)


OpenSCENARIO是一种用于描述动态场景的数据格式，由德国VIRES Simulationstechnologie GmbH和 Automotive Simulation Center Stuttgart公司于2014年启动，逐渐迭代，并在2017年7月发布了0.9.1版本。2018年9月，OpenSCENARIO的开发团队将维护工作转交给德国ASAM标准化组织，1.0及之后的版本由ASAM负责。1.0版本已由ASAM组织在2020年3月发布，本文使用该版本进行介绍。OpenSCENARIO的1.0版本与0.9版本有较大的区别，ASAM提供了0.9到1.0版本文件的转换方法。

OpenSCENARIO文件按XML格式编写，文件扩展名为.xosc。

## 02 OpenSCENARIO的文件结构

OpenSCENARIO文件主要分为三个部分：RoadNetwork、Entity和Storyboard，如下图所示：

![img](https://pic3.zhimg.com/80/v2-59984d892b0f6cf78408b727d04b497e_720w.jpg)

其中：
**（1）RoadNetwork：**

用于对场景运行的道路进行说明，引用了OpenDRIVE文件。

**（2）Entity：**

用于描述场景参与者的参数。参与者的类型包括车辆、行人和树木、路灯等物体。不同类型的参与者具有不同的参数，比如车辆参数有长宽高、轴距和最高车速等，行人的参数有质量、名称等；

**（3）Storyboard：**

用于描述参与者的行为，包括参与者的初始状态和运行过程中的行为变化。

初始状态Init包括位置、朝向和速度等；行为变化Story中采用类似剧本的思路，对哪个参与者在什么时间发生了什么行为进行了描述。

**03 Storyboard的场景描述结构**

![img](https://pic3.zhimg.com/80/v2-8670415d38ae81b203162c172c30284e_720w.jpg)

如上图所示Init中定义了参与者的初始状态，行为变化Story中采用类似剧本的思路，对哪个参与者在什么时间发生了什么行为进行了描述。Story之下为Act，每个Act对一个参与者的行为进行描述。

其中：

（1）Start/Stop Trigger描述了行为变化什么时候/在什么情况下开始/结束（when）。首先设定一个条件，比如两车距离为50米；然后设定条件触发的方式（上升沿、下降沿等），比如两车距离逐渐缩短为50米或逐渐增加为50米时条件触发。

（2）Actors描述了哪个参与者的行为发生变化（who）。

（3）Maneuver描述了参与者的行为发生的怎样的变化（what）。Maneuver由一系列Event构成，每个Event描述了一个相对完整的行为，如向左换道、加速等。

Event由具体的Action和该Action发生的条件StartTrigger构成。Action的类型包括PrivateAction、GlobalAction和UserDefinedAction。

其中PrivateAction为参与者可能的动作，包括纵向动作（如速度变化、距离变化）、横向动作（如换道、横向偏移）和沿路径行驶等多种类型；GlobalAction包括环境变化（如天气、时间和道路附着率）、增减交通参与者、交通流等类型。