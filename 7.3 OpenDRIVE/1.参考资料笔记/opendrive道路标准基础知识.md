- [opendrive道路标准基础知识_布拉德先生的博客-CSDN博客_opendrive标准](https://blog.csdn.net/weixin_44108388/article/details/111303760)

# opendrive基础知识

[ASAM所有的标准](https://www.asam.net/standards/)
[opendrive标准](https://www.asam.net/standards/detail/opendrive/)
[opendrive中文版描述](https://www.asam.net/index.php?eID=dumpFile&t=f&f=3768&token=66f6524fbfcdb16cfb89aae7b6ad6c82cfc2c7f2)
opendrive概念：
定义：一个描述道路的国际标准。表示高精地图的方式。
Opendrive是由ASAM定义的。

关于ASAM：
ASAM(Association for Standardisation of Automation and Measuring Systems, 自动化及测量系统标准协会)是汽车工业中的标准协会，致力于数据模型，接口及语言规范等领域。该协会创建于1991年，是德国汽车工业中的领军人。如今，ASAM已经成为一个拥有100多个成员公司的世界性协会。

关于opendrive：
ASAM is a standardization organization where experts from OEMs, Tier-1s, tool vendors, engineering service providers, and research institutes meet to commonly standardize development and test systems for the automotive industry.
ASAM OpenDRIVE描述了驾驶仿真应用所需的静态道路交通网络（以下简称路网）并提供了标准交换格式说明文档。该标准的主要任务是对道路及道路上的物体进行描述。OpenDRIVE说明文档涵盖对如道路、车道、交叉路口等内容进行建模的描述，但该说明文档中并不包含动态内容。

OpenDRIVE可交付以下内容：
文件格式说明文档
XML模式
UML模型
示例文件（应用案例和示例）
示例实现
引用实现的螺旋线
用于OpenDRIVE的标志库目录

## 概要

OpenDRIVE格式使用文件拓展名为**xodr**的可扩展标记语言（**XML**）作为描述路网的基础。存储在OpenDRIVE文件中的数据描述了道路的几何形状以及可影响路网逻辑的相关特征(features)，例如车道和标志。OpenDRIVE中描述的路网可以是人工生成或来自于真实世界的。OpenDRIVE的主要目的是提供可用于仿真的路网描述，并使这些路网描述之间可以进行交换。

该格式将通过节点(nodes)而被构建，用户可通过自定义的数据扩展节点。这使得各类应用（通常为仿真）具有高度的针对性，同时还保证不同应用之间在交换数据时所需的互通性。

### 1) 单位

如无另外说明，本说明文档中的所有数值均采用SI（[国际单位制](https://baike.baidu.com/item/国际单位制/1189599?fr=aladdin)，来自法语的缩写）单位，例如：

位置/距离单位为[m]
角度单位为[rad]
时间单位为[s]
速度单位为[m/s]

OpenDRIVE结构图的建模根据统一建模语言（UML,Unified Modeling Language [UML](https://baike.baidu.com/item/统一建模语言/3160571?fr=aladdin)）来进行。
这是一种为面向对象系统的产品进行说明、可视化和编制文档的一种标准语言，是非专利的第三代建模和规约语言。UML是面向对象设计的建模工具，独立于任何具体程序设计语言。

曲率：
正曲率：左曲线（逆时针运动）
负曲率：右曲线（顺时针运动）

### 2) simulation标准之间的关系

ASAM OpenDRIVE为路网的静态描述定义了一种存储格式。通过与ASAM OpenCRG(curved regular grid record)结合使用，可以将非常详细的路面描述添加至路网当中。OpenDRIVE和ASAM OpenCRG仅包含静态内容，若要添加动态内容，则需要使用ASAM OpenSCENARIO。三个标准的结合则提供包含静态和动态内容、由场景驱动的对交通模拟的描述。

opendrive主要注重道路的属性，包括多少个车道，单行道双行道，车速限速，交通信号灯；
opencrg主要注重道路的形状，相当于贴图；
openscenario主要注重动态属性。

## opendrive通用架构

### 1) File Structure 文件结构

OpenDRIVE数据存储于XML文件中，文件拓展名为.xodr。

OpenDRIVE压缩文件的拓展名为".xodrz"（压缩格式gzip）。

靠右行车环境。

在OpenDRIVE中，辅助数据用 `<userData>` 元素来表示。它们可（may）被存储在OpenDRIVE任意元素中。

**核心类：class core:**
![在这里插入图片描述](https://img-blog.csdnimg.cn/20201216214358836.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80NDEwODM4OA==,size_16,color_FFFFFF,t_70#pic_center)

### 2) <OpenDRIVE

### 3) <header

属性

### 4) <include

包含数据用`<include>`元素来表示，可（may）被存储在OpenDRIVE里任意位置。

## opendrive坐标系

OpenDRIVE使用三种类型的坐标系，如下图所示：

若无另外说明，对局部坐标系的查找与定位将相对于参考线坐标系来进行。对参考线坐标系位置与方向的设定则相对于惯性坐标系来开展，具体方法为对原点、原点的航向角/偏航角、横摆角/翻滚角和俯仰角的旋转角度及它们之间的关系进行详细说明。

惯性x/y/z轴坐标系
参考线s/t/h轴坐标系
局部u/v/z轴坐标系
![在这里插入图片描述](https://img-blog.csdnimg.cn/20201216214418630.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80NDEwODM4OA==,size_16,color_FFFFFF,t_70#pic_center)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20201216214428678.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80NDEwODM4OA==,size_16,color_FFFFFF,t_70#pic_center)
空间参考系的标准化由欧洲石油调查组织(EPSG)执行，该参考系由用于描述大地基准的参数来定义。大地基准是相对于地球的椭圆模型的位置合集所作的坐标参考系。

通过使用基于PROJ（一种用于两个坐标系之间数据交换的格式）的投影字符串来完成对大地基准的描述。该数据应（shall）标为CDATA，因为其可能（may）包含会干预元素属性XML语义的字符。

投影的定义不能（shall）多于一个。若定义缺失，那么则假定为局部笛卡尔坐标系。

## Geometry 几何形状

五种定义道路参考线几何形状的可行方式：

直线
螺旋线或回旋曲线（曲率以线性方式改变）
有恒定曲率的弧线
三次多项式曲线
参数三次多项式曲线
![在这里插入图片描述](https://img-blog.csdnimg.cn/20201216214451215.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80NDEwODM4OA==,size_16,color_FFFFFF,t_70#pic_center)

## Road reference line 道路参考线

道路参考线是OpenDRIVE中每条道路的基本元素。所有描述道路形状以及其他属性的几何元素都依照参考线来定义，这些属性包括车道及标志。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20201216214510964.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80NDEwODM4OA==,size_16,color_FFFFFF,t_70#pic_center)
按照定义，参考线向s方向伸展，而物体出自参考线的侧向偏移，向t方向伸展。

在OpenDRIVE中，参考线的几何形状用`<planView>`元素里的 `<geometry>` 元素来表示。

`<planView>` 元素是每个 `<road>` 元素里必须要用到的元素。通用属性：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20201216214533860.PNG?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80NDEwODM4OA==,size_16,color_FFFFFF,t_70#pic_center)
但是对不同曲线模型会多出不同的属性：
1.直线

2.螺旋线

螺旋线是以起始位置的曲率(@curvStart)和结束位置的曲率(@curvEnd)为特征。沿着螺旋线的弧形长度（见 `<geometry>` 元素@length），曲率从头至尾呈线性。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201216214554205.PNG?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80NDEwODM4OA==,size_16,color_FFFFFF,t_70#pic_center)

以下规则适用于道路参考线：

每条道路必须（shall）有一条参考线。
每条道路只能（shall）有一条参考线。
参考线通常在道路中心，但也可能（may）有侧向偏移。
几何元素应（shall）沿参考线以升序（即递增的s位置）排列。
一个 `<geometry>` 元素应（shall）只包含一个另外说明道路几何形状的元素。
若两条道路不使用交叉口来连接，那么新的道路的参考线应（shall）总是起始于其前驱或后继道路的 `<contactPoint>`。
参考线有可能（may）被指向相反方向。
参考线不能（shall）有断口（leaps）。
参考线不应（should）有扭结（kinks）

（shall）总是起始于其前驱或后继道路的 `<contactPoint>`。
参考线有可能（may）被指向相反方向。
参考线不能（shall）有断口（leaps）。
参考线不应（should）有扭结（kinks）