- [opendrive文件结构_whuzhang16的博客-CSDN博客](https://blog.csdn.net/whuzhang16/article/details/110199448)

## 1、 文件结构

OpenDRIVE数据存储于[XML](https://so.csdn.net/so/search?q=XML&spm=1001.2101.3001.7020)文件中，文件拓展名为.xodr。OpenDRIVE压缩文件的拓展名为".xodrz"（压缩格式gzip）。

OpenDRIVE文件的结构符合XML规则；关联的模式文件在XML中得到引用。用于OpenDRIVE格式的模式文件可从以下链接中读取：

https://www.asam.net/standards/detail/opendrive/

元素被置于层级中。层级大于零(0)的元素是上一层级的子级，层级等于一（1）的元素则为主元素。

可通过用户定义的数据对每个元素进行拓展。此类数据被存储于“用户数据”元素中。

所有在OpenDRIVE中使用的浮点数均为IEEE 754双精度浮点数。为了确保XML表示法中对浮点数的表示精准，应使用已知的、保留最小的浮点数打印算法（比如[Burger96], [Adams18])的正确精度来进行执行，或者执行应该确保始终有17个有效十进制数字得到生成（例如使用the "%.17g" ISO C printf 修饰符）。在导入执行时，建议使用一个已知的正确精度来保留浮点数并读取算法（例如 [Clinger90])。可通过用户定义的数据对每个元素进行拓展。此类数据被存储于“用户数据”元素中。

## 2、 合并文件

可使用<include>标签在适当的位置对多个文件进行合并。解析该标签后，OpenDRIVE读取器须立刻开始读取作为标签属性的文件。用户有责任确保从包含文件中读取而来的内容与包含开始时的上下文一致。

<include>标签发生在父标签下，该父标签必须存在于父文件以及包含文件内。

```XML
示例:



 原始文件



 



<planView>



<include file="planview.xml"/>



</planView>



 



包含文件



 



<planView>



<geometry x="-0.014" y="-0.055" hdg="2.88" length="95.89" s="0.0">



<arc curvature="-0.000490572"/>



</geometry>



<geometry x="-92.10" y="26.64" hdg="2.84" length="46.65" s="95.89">



<spiral curvStart="-0.000490572" curvEnd="-0.004661241"/>



</geometry>



</planView>
```

## 3、文件中使用的属性

### 3.1 封闭元素

 文件的起始及结束元素是：

![img](https://img-blog.csdnimg.cn/20201126182359525.png)

### 3.2 头文件

<header> 元素是<OpenDRIVE>中的第一个元素。

头文件元素的属性：

![img](https://img-blog.csdnimg.cn/20201126182508113.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

![img](https://img-blog.csdnimg.cn/20201126182530416.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

### 3.3 通用规则与假定

如无另外说明，都假定为靠右行车环境。

## 4、附加数据

### 4.1 用户数据

应在辅助数据所引用的元素附近对其进行描述。辅助数据包含OpenDRIVE中还未描述或出于特殊原因为某一应用所用的数据，如不同的道路纹理。

在OpenDRIVE中，辅助数据用 <userData> 元素来表示。它们可被存储在OpenDRIVE任意元素中。

### 4.2 包含数据

OpenDRIVE允许将外部文件包含在OpenDRIVE文件中，而如何处理该类文件则视应用而定。包含数据用<include>元素来表示，可被存储在OpenDRIVE里任意位置。

### 4.3 使用不同布局类型

可在OpenDRIVE中对用户生成的元素布局（如路标或标志）进行集成。这些附加的布局设计并不存储在OpenDRIVE中，而是存储在用户应用中。

在OpenDRIVE中，不同布局类型用 <set> 元素来表示，可存储在OpenDRIVE里任意位置。每个 <set> 元素之后都可以关联一个或多个对布局进行说明的<instance>元素。

### 4.4 数据质量描述

集成到OpenDRIVE的原始数据或来自外部资源的数据质量可能参差不齐。外部数据的质量和准确性可以在OpenDRIVE中得到描述。

对数据质量的描述用 <dataQuality> 元素来表示。它们可存储在OpenDRIVE中的任意位置。

集成到OpenDRIVE、源自于GPS等外部资源的测量数据可能存在误差。以[m]为单位的误差范围可在应用中被列出。

道路数据的绝对或相对误差在<dataQuality>元素中用 <error> 元素来描述。

某些基本元数据涵盖了被包括在OpenDRIVE中的原始数据信息，这些原始数据在 <dataQuality> 元素中用 <rawData> 元素来描述。