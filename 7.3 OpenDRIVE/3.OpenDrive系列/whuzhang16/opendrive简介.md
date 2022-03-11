- [opendrive简介_whuzhang16的博客-CSDN博客_opendrive](https://blog.csdn.net/whuzhang16/article/details/110198356)

## 1、概要

ASAM OpenDRIVE描述了[自动驾驶](https://so.csdn.net/so/search?q=自动驾驶&spm=1001.2101.3001.7020)仿真应用所需的静态道路交通网络，并提供了标准交换格式说明文档。该标准的主要任务是对道路及道路上的物体进行描述。OpenDRIVE说明文档涵盖对如道路、车道、交叉路口等内容进行建模的描述，但其中并不包含动态内容。

OpenDRIVE格式使用文件拓展名为xodr的[可扩展标记语言](https://so.csdn.net/so/search?q=可扩展标记语言&spm=1001.2101.3001.7020)（XML）作为描述路网的基础。存储在OpenDRIVE文件中的数据描述了道路的几何形状以及可影响路网逻辑的相关特征(features)，例如车道和标志。OpenDRIVE中描述的路网可以是人工生成或来自于真实世界的。OpenDRIVE的主要目的是提供可用于仿真的路网描述，并使这些路网描述之间可以进行交换。

该格式将通过节点(nodes)而被构建，用户可通过自定义的数据扩展节点。这使得各类应用（通常为仿真）具有高度的针对性，同时还保证不同应用之间在交换数据时所需的互通性。

## 2、惯例

用户可以直接定义某些数据的数量单位。如果数量单位没有被明确定义或无法被解析，则将默认采用SI单位。以下单位可（may）用于直接定义数据：

![img](https://img-blog.csdnimg.cn/20201126174910739.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

![img](https://img-blog.csdnimg.cn/2020112617493366.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

地理位置用空间坐标系定义的单位来说明，可遵循例如WGS 84 – EPSG 4326 坐标系。

这些可选的单位只能作为指示牌以及速度标明使用。而不能作为通用单位使用，比如不能用来定义道路几何形状或其他内容。

## 3、ID使用

在OpenDRIVE中使用ID时，请遵循以下规则：

1. ID在一个类中必须是唯一的。
2. 车道ID在车道段中必须是唯一的。
3. 仅可引用已定义的ID。

## 4、曲率

以下惯例适用于标明曲率：

1. 正曲率：左曲线（逆时针运动）
2. 负曲率：右曲线（顺时针运动）

Curvature == 1/radius

## 5、与其他标准的关联

### 5.1 ASAM OpenDRIVE在ASAM标准系列中的角色

ASAM OpenDRIVE是ASAM仿真标准的一部分，该标准专注于车辆环境的仿真数据。除了ASAM OpenDRIVE，ASAM还提供其他仿真领域的标准，例如ASAM OpenSCENARIO和ASAM OpenCRG。

### 5.2 OpenDRIVE与OpenCRG以及OpenSCENARIO之间的关联

ASAM OpenDRIVE为路网的静态描述定义了一种存储格式。通过与ASAM OpenCRG结合使用，可以将非常详细的路面描述添加至路网当中。OpenDRIVE和ASAM OpenCRG仅包含静态内容，若要添加动态内容，则需要使用ASAM OpenSCENARIO。三个标准的结合则提供包含静态和动态内容、由场景驱动的对交通模拟的描述。

![img](https://img-blog.csdnimg.cn/20201126175442116.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

图 OpenDRIVE, OpenCRG 以及 OpenSCENARIO之间的关联

### 5.3 向后兼容早期版本

OpenDRIVE 1.6版包含了在1.5版中出现过的元素，但这些元素与1.4版不兼容。为了确保能与1.4版和1.5版兼容，这些元素在1.6版的[XML](https://so.csdn.net/so/search?q=XML&spm=1001.2101.3001.7020)模式中从技术上被定义为可选。在UML模型的注释中，它们被标记为“向后兼容的可选”。