- [opendrive坐标系_whuzhang16的博客-CSDN博客_opendrive坐标系](https://blog.csdn.net/whuzhang16/article/details/110388309)

## 1 opendrive坐标系概况

OpenDRIVE使用三种[类型](https://so.csdn.net/so/search?q=类型&spm=1001.2101.3001.7020)的坐标系，如下图所示：

- 惯性x/y/z轴坐标系
- 参考线s/t/h轴坐标系
- 局部u/v/z轴坐标系

![img](https://img-blog.csdnimg.cn/20201130145247986.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

若无另外说明，对局部坐标系的查找与定位将相对于参考线坐标系来进行。对参考线坐标系位置与方向的设定则相对于惯性坐标系来开展，具体方法为对原点、原点的航向角/偏航角、横摆角/翻滚角和俯仰角的旋转角度及它们之间的关系进行详细说明。

![img](https://img-blog.csdnimg.cn/20201130145409470.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

## 2 惯性坐标系（Inertial coordinate systems）

根据[ISO](https://so.csdn.net/so/search?q=ISO&spm=1001.2101.3001.7020) 8855惯性坐标系是右手坐标系，其轴的指向方向如下（见图7）：

- x轴 ⇒ 右方
- y轴 ⇒ 上方
- z轴 ⇒ 指向绘图平面外

以下惯例适用于地理参考：

- x轴 ⇒ 东边
- y轴 ⇒ 北边
- z轴 ⇒ 上方

通过依次设置航向角/偏航角（heading）、俯仰角（pitch）和横摆角/翻滚角（roll），元素（如物体、标志等）可被置于惯性坐标系中：

![img](https://img-blog.csdnimg.cn/20201130145627958.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

图7展示了对应角的正轴与正方向。

![img](https://img-blog.csdnimg.cn/20201130145754428.png)

![img](https://img-blog.csdnimg.cn/20201130145808123.png)

![img](https://img-blog.csdnimg.cn/20201130145827492.png)

![img](https://img-blog.csdnimg.cn/20201130145846727.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

x’/y’/(z’=z) 指的是以航向角/偏航角围绕z轴旋转x/y/z轴之后的坐标系。坐标系x’’/(y’’=y’)/z’’指的是以俯仰角围绕y’轴旋转x’/y’/z’轴之后的坐标系。最后，坐标系(x’’’=x’’)/y’’’/z’’’在用横摆角/翻滚角旋转x’’/y’’/z’’后获得。

## 3 参考线坐标系

参考线坐标系同样也是右手坐标系，应用于道路参考线。s方向跟随着参考线的切线方向。这里需要说明的是：参考线总是被放置在由惯性坐标系定义的x/y平面里。t方向与s方向成正交。在定义完垂直于x轴和y轴、朝上的h方向后，整个右手坐标系才算完成。被定义的自由度如下：

![img](https://img-blog.csdnimg.cn/20201130150009910.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

s ：坐标沿参考线，以[m]为单位，由道路参考线的起点开始测量，在xy平面中计算（也就是说，这里不考虑道路的高程剖面）；
t ：侧面，在惯性x/y平面里正向向左；
h ：在右手坐标系中垂直于st平面；

![img](https://img-blog.csdnimg.cn/2020113015022923.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

![img](https://img-blog.csdnimg.cn/20201130150248394.png)

![img](https://img-blog.csdnimg.cn/20201130150304255.png)

与惯性系相似，s’/t’/h’ 与s’’’/t’’’/h’’’指的是围绕航向角/偏航角和横摆角/翻滚角旋转后得到的坐标系。如图11所示，通过提供原点坐标以及相对于惯性坐标系原点的方向（航向角/偏航角），参考线坐标系可（can）被置于惯性空间中。

![img](https://img-blog.csdnimg.cn/20201130150334906.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

超高程导致参考线内产生横摆角/翻滚角。

![img](https://img-blog.csdnimg.cn/20201130150403920.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

俯仰角在s/t/h轴坐标系中不可能出现，参考线的高程如下图所示。高程对s的长度不产生影响。

![img](https://img-blog.csdnimg.cn/20201130150439716.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

## 4 局部坐标系

根据ISO 8855局部坐标系是右手坐标系，其轴的指向方向如下。以下内容适用于非旋转坐标系：

u ：向前匹配 s
v ：向左匹配 t
z ：向上匹配 h

可通过依次设置航向角/偏航角、俯仰角和横摆角/翻滚角，将元素（例如物体）置于局部坐标系中：

![img](https://img-blog.csdnimg.cn/20201130150612386.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

在局部坐标系中，以下角度得到定义：

![img](https://img-blog.csdnimg.cn/20201130150648329.png)

![img](https://img-blog.csdnimg.cn/202011301507054.png)

![img](https://img-blog.csdnimg.cn/20201130150720860.png)

![img](https://img-blog.csdnimg.cn/20201130150735347.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

图14展示了对应角的正轴与正方向。局部坐标系只能（can）通过以下方法被置于参考线空间中：如图16所示，在参考线坐标系中提供局部坐标系的原点和相对于参考线坐标系、局部系原点的方向（航向角/偏航角）。

![img](https://img-blog.csdnimg.cn/20201130150811261.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

## 5 所有可用坐标系的总结

惯性坐标系、参考线坐标系和局部坐标系将在OpenDRIVE中同时被使用。图17中的示例描述了三个坐标系相对于彼此的位置与方向设定。

![img](https://img-blog.csdnimg.cn/20201130150903228.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

## 6 OpenDRIVE中的地理坐标参考

空间参考系的标准化由欧洲石油调查组织(EPSG)执行，该参考系由用于描述大地基准的参数来定义。大地基准是相对于地球的椭圆模型的位置合集所作的坐标参考系。

通过使用基于PROJ（一种用于两个坐标系之间数据交换的格式）的投影字符串来完成对大地基准的描述。该数据应标为CDATA，因为其可能包含会干预元素属性XML语义的字符。

在OpenDRIVE中，关于数据集的地理参考信息在<header>元素的<geoReference>元素中得以呈现。Proj字符串（如以下XML示例中所示）包含了所有定义已使用的空间参考系的参数：

关于proj字符串的细节信息，参见 https://proj.org/usage/projections.html

投影的定义不能（shall）多于一个。若定义缺失，那么则假定为局部笛卡尔坐标系。

这里强烈建议使用proj字符串的官方参数组（使用该链接查询字符串： https://epsg.io/ ）。参数不应（should）被改变。一些空间参考系如UTM具有隐东及北伪偏移，这里使用+x_0与+y_0参数对它们进行定义。

若想应用偏移，请使用<offset>元素，而不是改变所有参数值。

XML示例:

```XML
<geoReference>
    <![CDATA[+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs]]>
</geoReference>
```

![img](https://img-blog.csdnimg.cn/2020113015124997.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

规则：

- <offset> 应使OpenDRIVE 的x和y坐标大致集中在(0;0)周围。在x和y坐标过大的情况下，由于IEEE 754双精度浮点数的精确度有限，在内部使用浮点坐标的应用可能无法对它们进行精确处理。