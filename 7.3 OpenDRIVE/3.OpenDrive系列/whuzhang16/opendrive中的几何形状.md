- [opendrive中的几何形状_whuzhang16的博客-CSDN博客_opendrive 参数三次曲线](https://blog.csdn.net/whuzhang16/article/details/110671806)

道路的走向可以是多种多样的，可以是空旷地面上的直线、高速公路上细长的弯道、亦或山区狭窄的转弯。为从数学角度对所有这些道路线进行正确建模，OpenDRIVE提供了多种几何形状元素。 图19展示了五种定义道路参考线几何形状的可行方式：

- 直线
- 螺旋线或回旋曲线（曲率以线性方式改变）
- 有恒定曲率的弧线
- 三次多项式曲线
- 参数三次多项式曲线

![img](https://img-blog.csdnimg.cn/20201204195626425.png)

## 1 道路参考线

道路参考线是OpenDRIVE中每条道路的基本元素。所有描述道路形状以及其他属性的几何元素都依照参考线来定义，这些属性包括车道及标志。

按照定义，参考线向s方向伸展，而物体出自参考线的侧向偏移，向t方向伸展。

图20展示了OpenDRIVE中一条道路的不同部分。

- 道路参考线
- 一条道路上的单独车道
- 沿道路放置的道路特征（如标志）

![img](https://img-blog.csdnimg.cn/20201204195945539.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

在OpenDRIVE中，参考线的几何形状用<planView>元素里的 <geometry> 元素来表示。

<planView> 元素是每个 <road> 元素里必须要用到的元素。

![img](https://img-blog.csdnimg.cn/20201204200036970.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

以下规则适用于道路参考线：

- 每条道路必须有一条参考线。
- 每条道路只能有一条参考线。
- 参考线通常在道路中心，但也可能有侧向偏移。
- 几何元素应沿参考线以升序（即递增的s位置）排列。
- 一个 <geometry> 元素应只包含一个另外说明道路几何形状的元素。
- 若两条道路不使用交叉口来连接，那么新的道路的参考线应总是起始于其前驱或后继道路的 <contactPoint> 。参考线有可能（may）被指向相反方向。
- 参考线不能有断口（leaps）。
- 参考线不应有扭结（kinks）。

## 2 直线

在OpenDRIVE中，直线用<geometry> 元素里的 <line> 元素来表示。

 XML示例

```XML
<planView>
    <geometry
              s="0.0000000000000000e+00"
              x="-4.7170752711170401e+01"
              y="7.2847983820912710e-01"
              hdg="6.5477882613167993e-01"
              length="5.7280000000000000e+01">
        <line/>
    </geometry>
</planView>
```

## 3 螺旋线

如图23所示，螺旋线是一条描述参考线变化曲率的回旋曲线。螺旋线可被用来描述曲率在<line>到<arc>连贯的转换。

螺旋线是以起始位置的曲率(@curvStart)和结束位置的曲率(@curvEnd)为特征。沿着螺旋线的弧形长度（见 <geometry> 元素@length），曲率从头至尾呈[线性](https://so.csdn.net/so/search?q=线性&spm=1001.2101.3001.7020)。

也可以按顺序排列 <line> 、 <spiral> 和 <arc> 几个元素，从而对复杂曲率进行描述。

![img](https://img-blog.csdnimg.cn/20201204200426191.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

在OpenDRIVE中，螺旋线用<geometry> 元素里的<spiral>元素来表示。

![img](https://img-blog.csdnimg.cn/20201204200458932.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

XML示例

```XML
<geometry s="100.0" x="38.00" y="-1.81" hdg="0.33" length="30.00">
    <spiral curvStart="0.0" curvEnd="0.013"/>
</geometry>
```

以下规则适用于螺旋线：

- @curvStart和@curvEnd不应该相同。

## 4 弧线

如图24所示，弧线描述了有着恒定曲率的道路参考线。

![img](https://img-blog.csdnimg.cn/20201204200648238.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

在OpenDRIVE中，弧线用<geometry> 元素里的<arc>元素来表示。

![img](https://img-blog.csdnimg.cn/20201204200715749.png)

 XML示例

```XML
<planView>
    <geometry
              s="3.6612031746270386e+00"
              x="-4.6416930098385274e+00"
              y="4.3409250448366459e+00"
              hdg="5.2962250374496271e+00"
              length="9.1954178989066371e+00">
        <arc curvature="-1.2698412698412698e-01"/>
    </geometry>
</planView>
```

以下规则适用于弧线：

- 曲率不应（should）为零。

## 5 从几何形状元素中生成任意车道线

如图25所示，通过对OpenDRIVE中所有可用的几何形状元素进行组合，便可以创建诸多种类的道路线。

为避免曲率中出现断口，建议使用螺旋线将直线与弧线以及其他有不同曲率的元素进行结合。

![img](https://img-blog.csdnimg.cn/20201204200938717.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

## 6 三次[多项式](https://so.csdn.net/so/search?q=多项式&spm=1001.2101.3001.7020)（弃用）

三次多项式可用来生成衍生于测量数据的复杂道路走向。测量对为x/y坐标系中沿参考线的被测量坐标的指定次序定义了线段的多项式极限。

局部三次多项式描述了道路的参考线。通过对线段极限处的连续性条件例如线段连续性、切线和/或曲率连续性等进行详细说明，可以对多个三次多项式线段进行融合并且整个道路走向生成一条全局三次样条线插值曲线。另一个优点则是，沿着多项式的路径方式比沿回旋曲线更有效。

### 6.1 三次多项式的背景信息

以下方程描述了x/y坐标系里三次多项式的插值：
y(x) = a + b*x + c*x2 + d*x³

公式中的多项式参数a、b、c、d用于定义道路的走向。借助参数a-d，坐标系里每个点的y坐标都可以从x坐标中计算出来。

图26使用以下的值对在x/y坐标系中的三次多项式进行了展示：

![img](https://img-blog.csdnimg.cn/20201204202051421.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

### 6.2 利用三次多项式创建道路

如图27所示，在x/y坐标系中描述的三次多项式并不适合用来描述带有任意方向的曲线段。为了对在给定x坐标上带有两个或更多y坐标的曲线段进行处理，可（may）根据与局部u/v坐标系的关系来对三次多项式段进行定义。局部u/v坐标系的使用提高了曲线定义的灵活性。以下方程式得以使用：
v(u) = a + b*u + c*u2 + d*u³

应遵循以下方式对局部u/v坐标系方向进行选择：使用在递增的u坐标上的函数v(u)来表达曲线。

![img](https://img-blog.csdnimg.cn/20201204202157942.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

通常来说，u/v坐标系与s/t坐标系在线段的起始位置(@x,@y)和起始方向@hdg（关于这两点在<geometry>元素中有详细说明）上是一致的。这一选择的结果就是多项式参数a=b=0（见图28）。作为一个附加选项，局部u/v坐标系可相对于起始点(@x,@y)被旋转，做法为规定一个不等于0的多项式参数@b。在这里，反正切arctan(@b)定义了相对于局部u/v坐标系的多项式的航向角/偏航角。可通过设置一个不等于0的多项式参数@a（见图29）来获得当(@x,@y)应被定位于u=0时，沿v坐标轴对u/v 坐标系
原点的额外位移。参数u有可能随着0到曲线终点在u坐标轴上的投影而发生变化。对于给定的参数u，局部坐标v(u)定义了局部u/v坐标系内曲线上的点。
v(u) = a + b*u + c*u2 + d*u³

考虑到<geometry>元素中说明的位移和旋转参数@a、@b、(@x,@y) 和@hdg，在给定的u坐标上最终的x/y曲线位置如图29所示。

![img](https://img-blog.csdnimg.cn/20201204202255161.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

![img](https://img-blog.csdnimg.cn/20201204202312522.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

在OpenDRIVE中，三次多项式用 <geometry> 元素里的 <poly3> 元素来表示。

![img](https://img-blog.csdnimg.cn/20201204202341969.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

XML示例

```XML
<geometry
          s="0.0000000000000000e+00"
          x="-6.8858131487889267e+01"
          y="4.1522491349480972e-01"
          hdg="6.5004409066736524e-01"
          length="2.5615689718113455e+01">
    <poly3
           a="0.0000000000000000e+00"
           b="0.0000000000000000e+00"
           c="1.4658732624442020e-02"
           d="-5.7746497381565959e-04"/>
</geometry>
<geometry
          s="2.5615689718113455e+01"
          x="-4.8650519031141869e+01"
          y="1.5778546712802767e+01"
          hdg="2.9381264033570398e-01"
          length="3.1394863696852912e+01">
    <poly3
           a="0.0000000000000000e+00"
           b="0.0000000000000000e+00"
           c="-1.9578575382799307e-02"
           d="2.3347864348004167e-04"/>
</geometry>
```

以下规则适用于三次多项式：

- 三次多项式可（may）被用于描述在测量数据可用的情况下道路的走向。
- 若局部u/v坐标系与s/t坐标系起始点一致，那么多项式参数系数为a=b=0。
- <geometry>元素的起始点(@x,@y)定位在局部u/v坐标系的v轴上。
- 多项式参数a和b应（should）为0，以确保参考线的平滑。 

## 7 参数三次曲线

参数三次曲线被用于描述从测量数据中生成的复杂曲线。参数三次曲线相较于三次多项式更为灵活，它能描述更多种类的道路线。与在x/y坐标系中被定义或被当成局部u/v坐标系的三次多项式比起来，x坐标与y坐标的插值是通过它们自身的样条相对于共同的插值参数p而进行的。

### 7.1 使用参数三次曲线生成道路

只需使用x轴和y轴便可以用参数三次曲线生成道路线。为保持三次多项式的连贯性，可利用u轴和v轴同时将它们计算到三次多项式里。

![img](https://img-blog.csdnimg.cn/20201204201150424.png)

若无另外说明，插值参数p则在[0;1]范围内。另外，也可在 [0; @length of <geometry> ]的范围内对其赋值。与三次多项式相似，有着变量u和v的局部坐标系可被任意放置和旋转。

为简化描绘，局部坐标系可与s/t坐标系在起始点(@x,@y)和起始方向@hdg上保持一致：

- u点在局部s方向，即沿参考线在起始点上。
- v点在局部t方向，即从参考线在起始点上作横向偏移。
- 参数@aU、@aV和@bV应为零。

如图26、27和28所示，给参数@aU、@aV、 和@bV赋予非零值会导致s/t坐标系的转移和旋转。

在为已知参数p定义曲线上的点后，在考虑相对于参数@aU、@aV、@bU、@bV、起始坐标(@x,@y)和起始方向@hdg所规定的位移和方向的前提下，u值和v值会被转换成x/y坐标系里的值。

这里需注意的是：插值参数p和 <geometry> 元素中起始点(@x,@y)和与参数p相关的点(x(p),y(p))之间弧线实际长度是非线性关系。通常来说，只有起点和终点参数p=0和p=@length（选项@pRange=arcLength）与弧线的实际长度一致。

考虑到 <geometry> 元素中说明的位移和旋转参数@a、@b、(@x,@y) 和@hdg，在给定的u坐标上最终的x/y曲线位置如图29所示。

![img](https://img-blog.csdnimg.cn/20201204201726676.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

![img](https://img-blog.csdnimg.cn/20201204201803744.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

![img](https://img-blog.csdnimg.cn/20201204201823685.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

在OpenDRIVE中，参数三次曲线用 <geometry> 元素里的 <paramPoly3> 元素来表示。

![img](https://img-blog.csdnimg.cn/20201204201536579.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

![img](https://img-blog.csdnimg.cn/2020120420155441.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dodXpoYW5nMTY=,size_16,color_FFFFFF,t_70)

XML示例

```XML
<planView>
    <geometry
              s="0.000000000000e+00"
              x="6.804539427645e+05"
              y="5.422483642942e+06"
              hdg="5.287405485081e+00"
              length="6.565893957370e+01">
        <paramPoly3
                    aU="0.000000000000e+00"
                    bU="1.000000000000e+00"
                    cU="-4.666602734948e-09"
                    dU="-2.629787927644e-08"
                    aV="0.000000000000e+00"
                    bV="1.665334536938e-16"
                    cV="-1.987729787588e-04"
                    dV="-1.317158625579e-09"
                    pRange="arcLength">
        </paramPoly3>
    </geometry>
</planView>
```

以下规则适用于参数三次曲线：

若局部u/v坐标系与s/t坐标系的起始点一致，那么多项式参数系数为@aU=@aV=@bV=0。

若@pRange="arcLength"，那么p可（may）在[0, @length from <geometry> ]范围内对其赋值。

若@pRange="normalized"，那么p可（may）在[0, 1]范围内对其赋值。

多项式参数aU、bU和 aV应为0，以确保参考线的平滑。