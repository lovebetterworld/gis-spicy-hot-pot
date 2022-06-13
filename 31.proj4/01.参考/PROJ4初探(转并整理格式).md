- [PROJ4初探(转并整理格式) - 乌合之众 - 博客园 (cnblogs.com)](https://www.cnblogs.com/oloroso/p/5749057.html)

# PROJ4初探(转并整理格式)

Proj4是一个免费的GIS工具，软件还称不上。 它专注于地图投影的表达，以及转换。采用一种非常简单明了的投影表达－－PROJ4，比其它的投影定义简单，但很明显。很容易就能看到各种地理坐标系和地 图投影的参数，同时它强大的投影转换功能，也是非常吸引人的。许多的 GIS软件中也将其集成在内。Proj可以在 window的命令下有可运行的 EXE文件，其实它更主要的是一个库！可以用来编一些批处理。在 Linux下除了可以直接运行外，还可以作为库来进行更高功能的开发。

# 1 安装

Window下安装:
从`Proj4`的网站下载安装文件，解压缩，把路径加到环境变量里即可。具体操作步骤在解压后的README有详细说明。
Ubuntu Linux下安装: 可以在终端输入：

```shell
Copy Highlighter-hljssudo apt -get install proj
```

Fedora Linux 下安装: 可以在终端输入：

```shell
Copy Highlighter-hljssu -c 'yum install proj'
```

# 2 快速开始

在终端或 DOSshell下可以输入（带$的为向终端里输入的命令）：

```shell
Copy Highlighter-hljs$proj Rel. 4.6.0, 21 Dec 2007 usage: proj [-beEfiIlormsStTvVwW [args]] [+opts[=arg]] [files]
```

会显示出 proj的用法。包括参数设置，可选项，和输入文件。

## 2.1 显示参数[#](https://www.cnblogs.com/oloroso/p/5749057.html#2598054345)

对于作地图和 GIS工作者来说投影可谓是一切的基础，投影的正确与否将关第到最终结果正确与否。在 proj里边集成了，许多的制作地图用的投影参数。我们可以使用下边的命令来显示在 proj里的内置的有关地图投影的参数。显示投影类型：

```shell
Copy Highlighter-hljs$proj -l aea: Albers Equal Area aeqd: Azimuthal Equidistant ... ... ... wag5: Wagner V wag6: Wagner VI wag7: Wagner VII weren: Werenskiold I wink1: Winkel I wink2: Winkel II wintri: Winkel Tripel    
```

同样的，还有命令：
`$proj －le`显示支持的椭球体(ellipsoid)信息,显示结果省略。
`$proj －ld`显示Proj4支持的基准面(Datum)信息，显示结果省略。
这两个概念是有区别的。学过地图学的都知道，地图学上对地球上的抽象，第一次抽象为`水准面`（等重力面），第二次抽象为`椭球体`（ellipsoid），第三次 抽象现在我认为是将椭球体进行定位之后，所确定的具有明确的方向的椭球体，它的要求能够很好的为当地区的地图制作服务，这个似乎才可称为`基准面` （Datum）。当输入：

```shell
Copy Highlighter-hljs$ proj -ld __datum_id__ __ellipse___ __definition/comments______________________________ WGS84 WGS84 towgs84=0,0,0 GGRS87 GRS80 towgs84=-199.87,74.79,246.62 Greek_Geodetic_Reference_System_1987 NAD83 GRS80 towgs84=0,0,0 North_American_Datum_1983 NAD27 clrk66 nadgrids=@conus,@alaska,@ntv2_0.gsb,@ntv1_can.dat 
```

上边显示的就是基准面和椭球体的差异。

## 2.2 投影转换[#](https://www.cnblogs.com/oloroso/p/5749057.html#2572876053)

我 国常用的地图投影主要有:Albers，Lambert，Gauss－Kruger，UTM投影。 等积投影由于没有面积变形,所以在土地调查,植被盖度分类等涉及到要保持面积不能变形的情况.中国的全国性地图许多采用等积投影。国际上称为`Albers`投影,是一种圆锥等积投影。中国所使用的 Albers的参数是`双标准纬线`，`25N`，`47N`，中央经线为`105E`，椭球体为`Krassovsky`。用proj4表示为：

```shell
Copy Highlighter-hljs+proj=aea +ellps=krass +lon_0=105 +lat_1=25 +lat_2=47
```

下边将用中国的 Albers投影，简称为 Albers＿China来作个简单的投影转换。

```shell
Copy Highlighter-hljs$proj +proj=aea +ellps=krass +lon_0=105 +lat_1=25 +lat_2=47 105 36 0.00 3847866.97 104d36'54 36d25'9 -33897.90 3895309.74 104d25'36.9E 36d52'41N -50158.40 3947261.73 
```

也可以进行批量转：

```shell
Copy Highlighter-hljs$ proj +proj=aea +ellps=krass +lon_0=105 +lat_1=25 +lat_2=47 <<EOF > 105 36 > 104 36 > 106 24 > EOF 0.00 3847866.97 -88522.43 3848312.80 102064.08 2503934.26
```

同样也可以进行反转，即将 Albers转为经纬度，只要在命令中加入参数`-I`

```shell
Copy Highlighter-hljs$ proj +proj=aea +ellps=krass +lon_0=105 +lat_1=25 +lat_2=47 -I <<e > 0 3847866.97 > -88522.43 3848312.80 > 102064.08 2503934.26 > e 105dE 36dN 104dE 36dN 106dE 24dN
```

在这里转换的过程中始终是按经度－纬度，x－y的顺序放进的。你也许会想将它们的方向掉转。如果是输入时想转可在命令中加 －r，如果是输出想掉转，可以是加 －s

```shell
Copy Highlighter-hljs$ proj +proj=aea +ellps=krass +lon_0=105 +lat_1=25 +lat_2=47 -r -s <<e > 36 105 > 33 104 > e 3847866.97 0.00 3509623.92 -91933.97 
```

同样也可以通过文件来进行批量转换：

```shell
Copy Highlighter-hljslat＿lon.test 105dE 36dN 104dE 36dN 106dE 24dN $ proj +proj=aea +ellps=krass +lon_0=105 +lat_1=25 +lat_2=47 ~/lat_lon.test >alberst.test
```

生成的:`alberst.test`

```shell
Copy Highlighter-hljs0.00 3847866.97 -88522.43 3848312.80 102064.08 2503934.26 
```

你也可以在文件中加注释和对坐标点的说明，在转换后仍可以保留：

```shell
Copy Highlighter-hljslat_lon.test #it's just a test for convert file format 105dE 36dN not Lanzhou 104dE 36dN Lanzhou 106dE 24dN Unknow place
```

命令:

```shell
Copy Highlighter-hljs$ proj +proj=aea +ellps=krass +lon_0=105 +lat_1=25 +lat_2=47 ~/lat_lon.test >albers.test albers.test
#it's just a test for convert file format 0.00 3847866.97 not Lanzhou -88522.43 3848312.80 Lanzhou 102064.08 2503934.26 Unknow place 
```

在命令上边的`~/lat_lon.test`是输入的文件,`~`在 linux下指的是当前目录，windows下没试过，不过可以用绝对路径。`>`是重定向，输出文件。

## 2.3 地图单位[#](https://www.cnblogs.com/oloroso/p/5749057.html#1523607838)

proj4支持许多单位，可以通过`proj -lu`,看到支持的单位：

```shell
Copy Highlighter-hljs$ proj -lu km 1000. Kilometer m 1. Meter dm 1/10 Decimeter cm 1/100 Centimeter mm 1/1000 Millimeter kmi 1852.0 International Nautical Mile
```

其中 proj默认的单位为`米`（meter），我们设置参数`+units`来控制输入的坐标单位。我们可以将它的输入或输出的数据的单位改为其它：

```shell
Copy Highlighter-hljs$ proj +proj=aea +ellps=krass +lon_0=105 +lat_1=25 +lat_2=47 +units=km -I <<e > 0 3847.86697 > -88.52243 3848.31280 > 102.06408 2503.93426 > e 105dE 36dN 104dE 36dN 106dE 24dN
```

# 3 地图投影设置

其实在上边我们已经用到了一些参数。比如进行投影的反转，所使的是-I。还有就是给出的中国等积投影是：

```shell
Copy Highlighter-hljsproj +proj=aea +ellps=krass +lon_0=105 +lat_1=25
```

其 中有许多参数前边都加了前缀`+`，这后边的参数是对地图投影的真正的设置，proj命令也将按这个规定来进行转换。这种的参数的形式是`+param=value`为 param（参数）来给定一个value(值)，这个值可以是一个以度分秒格式或实数，整数，甚至可以是一个ASCII字符串。所要注意的是一种拼错了的 参数名会被不理会，如果一个参数输入了两次，则第一次输入的将被使用。所以在执行前要将参数检查好。另一个很有用的特点是，proj会自动决定中央经线并 且追加一个+lon_0参数到你的定义中，如果你没有定义中央经线的话。

## 3.1 选择投影[#](https://www.cnblogs.com/oloroso/p/5749057.html#1449844473)

选择投影使用的参数是`+proj=name`。proj中集成了不少的投影而且还在不断的增加。可惜的对我们中国的并没增加多少！它在这里提供我们增加我们自己投影的方法。我们可以用命令：

```shell
Copy Highlighter-hljs$proj -l #得到内置的投影类型
aea : Albers Equal Area #可以看到 Albers等积投影的在 proj中的值是 aea
$proj -lP #得到更详细的投影信息，投影包含的参数。
aea : Albers Equal Area ＃更详细的信息
Conic Sph&Ell lat_1= lat_2=
```

这样我们就可以来定你想要的投影了。

## 3.2 选择椭球体[#](https://www.cnblogs.com/oloroso/p/5749057.html#838813542)

虽然投影定了，可是还要确定椭球体。有两种办法：一种是利用内置的一些椭球体。

```shell
Copy Highlighter-hljs$proj -le #显示出内置的椭球体。
```

找几个我国经常用的椭球体：

```shell
Copy Highlighter-hljsclrk66 a=6378206.4 b=6356583.8 Clarke 1866 krass a=6378245.0 rf=298.3 Krassovsky, 1942 WGS84 a=6378137.0 rf=298.257223563 WGS 84
```

另一种就是你可以自定义一个你自己的地球，在上边的三个椭球体上就包含了定义一个椭球体的参数。以下面是这几个参数的含义：必须有的：
`+a=A`椭球的赤道半径（半长轴）
下边的这些只要一个就行的参数：
`+b=B`椭球的极半径（半短轴）
`+f=F`椭球的扁率`F=(A-B)/A +rf=RF`
椭球的反扁率`RF=1/F +e=E`
偏心率`+es＝ES`
偏心率的平方`E^2`
例如指定一个 Clark1866 椭球来作为中国等积投影的参数就可以这样来设置：

```shell
Copy Highlighter-hljs$proj +proj=aea +ellps=clrk66 +lon_0=105 +lat_1=25 105 36 #可以和上边的 krass椭球体比较 0.00 3850517.66 104 36 -88731.89 3850957.52 106 24 102046.72 2507997.23
```

同样也可以自定义：

```shell
Copy Highlighter-hljs$ proj +proj=aea +a=6378206.4 +es=.006768658 +lon_0=105 +lat_1=25
```

或：

```shell
Copy Highlighter-hljs$ proj +proj=aea +a=6378206.4 b=6356583.8 +lon_0=105 +lat_1=25
```

得到结果都是一样的。如果你仅仅只指定了一个＋a则会得到一个正规的球体。例如：

```shell
Copy Highlighter-hljsproj +a=1
```

你会定义一个半径`R=1`的单位球体。

## 3.3 通用的参数[#](https://www.cnblogs.com/oloroso/p/5749057.html#2547930136)

我们知道`UTM投影`，为确保每个带中的点全为正，在北半球将坐标从每带的中央径线西移`500`公里。而南半球为了保证Y轴为正，不得不向南移。这样两个参数在 proj中可以用两个参数`+x_0`和`+y_0`来确定。例如在UTM中，
+`x_0=5000000 +y_0=0`
还有一个是`+lat_0`：不太清楚，把原文贴过来。
*A fourth parameter, lat_0= 0, is used to designate a φcentral parallel and associated y axis origin for several projections.*
还有最后一个`＋lon_0`：指中央径线，在 UTM还有 Albers中要设置。上边的四个参数是可选的如果没有将会默认为 `0`，除`＋lon_0`，它会计算。这样我们就完成了一个投影的完整定义了，至少我认为这是一种很很简单很优美的定义投影的方式。通常把这种proj定义出的投影形式称为`PROJ4格式`。例如刚开始写的中国的等积投影：
`+proj=aea +ellps=krass +lon_0=105 +lat_1=25`
还有中国的`Lambert`投影，写法和上边差不多，在 proj4里的投影名称叫`＋proj＝lcc`

定义一个 UTM 投影的方法

```shell
Copy Highlighter-hljs$proj +proj=utm +zone=48 105 36 ＃在离兰州最近的一条中央经线 500000.00 3983948.45 ＃可以看出西移 500000米
```

定义一个高斯克吕格（它是横轴墨卡托的一种，也是横轴黑卡托的默认值）

```shell
Copy Highlighter-hljs$proj ＋proj＝tmerc +lon_0=105 ＃这上边没带，可以简单的算出每个带的中央经线的度数：（带数*6）－3就是中央经线
```

# 4 自定义你的 proj 及内置的其它程序介绍

## 4.1 自定义你的参数[#](https://www.cnblogs.com/oloroso/p/5749057.html#1793652295)

也许我们或许希望将我们常用的地图投影的定义放到文件中，我们只要在需要时将其导入即可。Proj4也提供了这个功能。我们以设置`+init`参数来进行。 首先先将地图投影保存到文件中。我们保存地图投影的文件格式如下： **proj.dat文件**
中国全国范围内的Albers投影

```shell
Copy Highlighter-hljs<albers_china> +proj=aea +ellps=krass +lon_0=105 +lat_1=25 +lat_2=47 <>
```

上 边我们将中国的等积投影保存在名为`proj.dat`的文件中。作为这个放置投影的文件的格式是：`#`表示注释，`proj`不执行 `<...>`夹在这里边的是关键字，因为在一个投影文件中可以放多个投影， proj在这个文件里靠关键字来选择投影。`<>`最的这个表示投影定义的结束。中间的部分就表示为定义的投影了。这样我们就可以很简单的使用`+init`来使用我们定义的这个投影了！

```shell
Copy Highlighter-hljs$ proj +init=~/proj.dat:albers_china 106 36 88522.43 3848312.80 105 36 0.00 3847866.97 106 24 102064.08 2503934.26
```

`+init`后边是个等号，之后是你保存投影文件的绝对路径。之后是个冒号，冒号之后则是投影的关键字。由于我是在 LINUX上的，`~`号代表的是当前目录。在 Windows下则要改为类似于：`+init=c:\proj.dat:albers_china`
其实在 proj初使时它已经有一些默认的值了，比如椭球体默认为`WGS84`。如果要更改这些。可以参考后边所列的参考书。

## 4.2 proj4 里的其它程序[#](https://www.cnblogs.com/oloroso/p/5749057.html#4142260310)

其实在你安装完 proj4之后，不光只安装了个 proj程序，还包括其它的几个，以及一个 lib。先介绍其内置的几个其它函数。
`invproj`反转，将`xy`转换为`lonla`t。相当于`proj -I`
`cs2cs`是从一个投影转到另一个投影，具体的使用方法是：

```shell
Copy Highlighter-hljs$ cs2cs +init=~/proj.dat:albers_china +to +proj=utm +zone=48 +ellps=krass 88522.43 3848312.80 590130.56 3984481.41 0.00 +to
```

前边你输入的坐标所属的投影，后边是要转出的投影。这就解决了，如果要用`proj`在两个坐标系间转，必须要先转为经纬度。其它的参数可以参照proj的设置。
`nad2nad`这是他们给他们自己国家的两个基准面进行基准面转换所作的。
转个原文吧，不知道我们什么时候用上自己的基准面转换，从54转80
*Program nad2nad is a filter to convert data between North America Datum 1927 (NAD27) and North American Datum 1983. nad2nad can option-ally process both State Plane Coordinate System (SPCS) and Universal Transverse Mercator (UTM) grid data as well as geographic data for both input and output. This can also be accomplished with the cs2cs program.*
`geod`这是个很有意思的，在定义了椭球体之后可以求出地表任意两点的大圆距离，以及两点的相对方位。当然也可以有它的反函数，`invgeod`。其使用方法，可以看帮助，一目了然。

# 5 Proj 的参数全解

下边将 Proj程序进行一个小的总结，对它所包含的所有参数进行说明。投影变换的命令为：

```shell
Copy Highlighter-hljsproj [-control] [+control] [files]
```

在 unix，Linux上还包括一个反变换：

```shell
Copy Highlighter-hljsinvproj [files]
```

代表输入的数据文件，执行顺序是从左向右，如里这里为空的话，则程序默认是从标准输入设备中输入，即键盘。 [-control] 参数被用来制约控制，数据的输入输出，和选择要计算的基本信息。下边将每个`-control`参数进行说明。

```diff
Copy Highlighter-hljs-I 进行投影的反转换。在上边说到的 unix下的有反转程序 invproj在windows下只要加上它，就可以进行反转。从投影坐标转为地理坐标。
-l[p|P|e|u|d] 显示出 proj内置的一些地球参数。
	-lp显示投影。-lP显示投影里的参数比较详细。
	-le显示内置的椭球体，看完之后，基本上够用的。
	-lu显示 proj支持的长度单位。
	-ld显示基准面，很少基本上都是美国的，也只有 WGS84我们现在用的比较多。
-b 用来把从标准输入输出中的数据当做二进制。输入数据被认为是双精度浮点。当 proj作为一个子程序时非常有用，可以忽略格式操作。
-i 仅选择输入为二进制，参考（-b)
-o 仅选择输出为二进制，参考（-b)
-ta 指定一个字符来作为注释来不被执行，仅只能使用 ASCII 字符。(默认为＃号,例如可以改为-t％，这就将％作为注释符)
-e string 来作为当输出错误时输出的信息。注意 -e 空一格，之后再输入你想要达到的输出时输出的信息。默认的错误输出是 ＊\t*。所要注意的是如果选了-b,-o,-i的话，错误的消息将被使用系统的 HUGE VAL 输出。
-r 这个用来反转输入坐标的顺序，如果使用的话会将输入默认的longtitude-latitude或者x-y改变为latitude-lontitude 或y-x。
-s 将输出的顺序进行反转。参考 -r
-m 是指将输出的值按比例进行缩小放，主要用来用来进行单位转换，因为proj 默认的输出单位是米，如果你想输出为千米时就可以用它来指定。例如：-m 1:1000 或使用 -m 1/1000 都是可以的。也可将其放大使用 -m 1:0.1 显示为分米为最小单位。
-f format 来对输出进行精度规范，输出的小数点精度。默认的格式为%.2f，即输出两位小数。对于经纬度则采用十进制来表示。例如：将输出的小点数位保留五位，-f%.5f。
-[w|W]n 用来控制当使用度分秒格式时，秒的位数。n 是个小于10的数。
	-wn 指保留的秒的精度是n位，如果在某一位后全为0时就不输出。
	-Wn 则强制将后边的0补上，要求小数位为一个定长。这个有时很有用，在规定格式方面。
-v 来显示你的选择的投影的信息
-V 来显示更详细的你选择投影的信息，增加了椭球体。主要用来检查你的输入是否是你想定义的投影，保证没有错误。
-E
-S 来把每一点在投影后的各种变形显示出来。将这些信息显示在<>里。分别包括 h,k,s,omega,a 和 b。
[+control] 有加号的地图参数都和地图的投影有关，并且不同的投影对其中的有些参数不包括。除了+init 外，其它的带＋号的参数都可以作为初始文件中，或默认的文件。这些选择是从按从左到右的顺序进行处理的。当出现重复时，以前边的参数为准。
+proj＝name 这是经常必选的一个地图投影转换函数。Name 是一个投影名称。
+init=file:key 名为 file 的文件使用 key 关键字，选择包含了控制参数的投影。
+R=R 当把地球当成球体计算时，所要设置的半径。
+ellps=acronym 选择一个 proj 里的椭球体。Acronym 为椭球体名。
+a=a 设置椭球体的半长轴为a，单位为米
+es=e^2 设置椭球体的偏心度的平方。同样的也可以用+b=b,+e=e,
+rf=1/f,+f=f。来设置，椭球体参数。可以参考上边的说明。
+x_0=x0 设置假东，例如在gauss－kruge 中，东偏 5000000 米。主要用来保持坐标的非负。
+y_0=y0 设置假北，主要用来保持坐标非负。
+lon_0=c 高置中央经线。通常和+lat_0,一起决定投影的地理起点。
+lat_0=d 参考上边的。
+units=name 设置地图坐标的单位。
+geoc 地理坐标将被认为是地心坐标，当使用这个参数的时候。
+over 使用该参数时，把经纬不限制在-180～+180 间。
```

举例：

```shell
Copy Highlighter-hljs$ proj +proj=goode 389 36 2611721.44 4007501.67 29 36 ＃当不使用时，会自动将经度换到范围 2611721.44 4007501.67
$ proj +proj=goode +over ＃使用关键字时，则不会转换。 389 36 35033090.98 4007501.67 29 36 2611721.44 4007501.67
```

在安装Proj4的位置，有一个默认的文件夹，来指示不满足要求的初始化文件名称，以及投影的默认文件`proj_def.dat`。环境变量`PROJ_LIB`可以用来给出另一个新的文件夹。

# 6 在Python里使用的Proj4

proj 不光是一些应用程序的集合，它更是一个库，其它语言可以来调用它，来进行更高级的开发和应用。在 proj安装上之后，它本身作为库，可以被 C/C++来调用。而 proj本身是一个开源的项目，同时 Python也是一个开源的编程语言。Proj理所应当的能够用在 Python里。在 Python里的 Proj库称为 Pyproj。在 windows和 Linux下都很好安装。

`Pyporj`是 Python下的 proj。可以很方便的对点来进行地图投影转换。同时在它的基础上开发出更高级的应用。Pyproj包里包括两个类，`Proj`类和`Geod`类。
`Proj`类相当于前面所说的`proj`的功能。可以进行地图投影的变换从经纬度转为 xy投影坐标，也可以反转。也可以在不同的地图投影之间转换。
`Geod`类相当于前边介绍的`proj`里的一个应用程序`Geod`。可以很方便的计算地球上任意两点的大圆距离，以及它们的相对方位。同时，也可根据方位和大圆距离来反算出另一点的经纬度。其处理的输入坐标可以是 python数组，list\元组，scalar 或者 numpy/Numeric/numarray arrays。在导入 Pyproj后可以用其内部的函数 test()会运行一些例子。下边介绍 Proj类和 Geod类，以及 transform函数。

## 6.1 Proj 类[#](https://www.cnblogs.com/oloroso/p/5749057.html#4201876614)

Proj类主要是进行经纬度与地图投影坐标转换，以及反转。可以参考前边对 proj的介绍。当初始化一个 Proj类的时例时，地图投影的参数设置可以用关键字\值的形式。关键字和值的形式也可以用字典，或关键字参数，或者一个 proj4 字符串（与 proj的命令兼容）。
当调用一个包含经纬度的 Proj类的实例时，将会把十进制的经纬度，转换成为地图的 xy坐标。如果可选的关键字`inverse`等于 True的时候（默认为假），则进行相反的转换。如果关键字'radians'为 `True`的话（默认为假），则经纬度的单位则是弧度，而不是度。如果可选的关键字`errcheck` 为真的话（默认为假），一个异常将会被给出，如果转换无效的话。如果为假的话，且转换无效时，没有异常抛出，但会返会一个无效值`1.e30`。
可以将经纬度分别存入一个`list或`array。可以进行更高效率的转换。输入的值应当是双精度（如果输入的不是，它们将会被转为双精度）。
虽然`Proj`可以和`numpy and regular python array objects,python sequences and scalars`,但是用`array`对象速度快一些。
初始化一个投影：`Proj4`投影控制参数或者是以字典形式给出，或者是以关键字参数给出，也可以用`proj4`的形式给出字符串。例：

```python
Copy Highlighter-hljs>>> from pyproj import Proj ＃从 pyproj导入 Proj类 
>>> p=Proj('+proj=aea +lon_0=105 +lat_1=25 +lat_2=47 +ellps=krass') ＃初使化一个投影－中国等积投影，使用 proj4格式 
>>> x,y=p(105,36) ＃进行转换 
>>> print '%.3f,%.3f' %(x,y) ＃按格式输出 -0.000,3847866.973 
>>> lon,lat=p(x,y,inverse=True) ＃进行投影反转 
>>> print '%.3,%.3' %(lon,lat) ＃xy为上边转的数值 
>>> print '%.3f,%.3f' %(lon,lat) 105.000,36.000 
>>> import math ＃验证关键字 radians 
>>> x,y=p(math.radians(105),math.radians(36),radians=True) 
>>> print '%.3f,%.3f' %(x,y) -0.000,3847866.973 
>>> lons=(105,106,104) >>> lats=(36,35,34) 
>>> x,y=p(lons,lats) ＃将经纬度放入元组中 
>>> print '%.3f,%.3f,%.3f' %x ＃普通打印 -0.000,89660.498,-90797.784 
>>> print '%.3f,%.3f,%.3f' %y 3847866.973,3735328.476,3622421.811 
>>> type(x) ＃输出的类型为元组 <type 'tuple'> 
>>> zip(x,y) 用 zip函数包装 [(-1.1262207710106308e-09, 3847866.9725167281), (89660.498484069467, 3735328.4764740192), (-90797.783903947289, 3622421.8109651795)] 
>>> utm=Proj(proj='utm',zone=48,ellps='WGS84') 
>>> x,y=utm(105,36) ＃用关键字定义一个投影。 
>>> x,y (500000.00000000116, 3983948.4533358263)
```

两个 Proj实例的函数：
`is_geocent(self)`返回`True`当投影为`geocentric(x/y) coordinates`。
`is_latlong(self)`返回`True`当为地理坐标系经纬度时。
举例：

```python
Copy Highlighter-hljs>>> utm.is_geocent() ＃很纳闷，看来有必要弄清什么是 geocentric False 
>>> utm.is_latlong() False 
>>> latlong=Proj('+proj=latlong') 
>>> latlong.is_latlong() True 
>>> latlong.is_geocent() False
```

## 6.2 transform()函数[#](https://www.cnblogs.com/oloroso/p/5749057.html#3703604909)

`transform()`函数是在`pyproj`库下，可以进行两个不同投影的转换。相当于`proj`程序里的`cs2cs`子程序。用法如下：

```python
Copy Highlighter-hljstransform(p1, p2, x, y, z=None, radians=False) x2, y2, z2 = transform(p1, p2, x1, y1, z1, radians=False)
```

在 p1，p2两个投影间进行投影转换。将把在 p1坐标系下的点`(x1,y1,z1)`转换到 p2所定义的投影中去。`z1`是可选的，如果没有设 z1的话将会假定为 0，并仅仅返回 `x2,y2`。使用这个函数的时候要注意**不要**进行基准面的变换(datum)。关键字`radians`只有在 p1,p2中有一个为地理坐标系时才起作用，并且把是地理坐标系的投影的值会当作弧度。判断是否为地理坐标可以用 `p1.is_latlong()`和`p2.is_latlong()`函数。 输入的`x,y,z`可以是分别是数组或序列的某一种形式。举例：

```python
Copy Highlighter-hljs>>> import pyproj 
>>> albers=Proj('+proj=aea +lon_0=105 +lat_1=25 +lat_2=47 +ellps=krass')
>>> utm=Proj(proj='utm',zone=48,ellps='krass')
>>> albers_x,albers_y=albers(105,36)
>>> albers_x,albers_y (-1.1262207710106308e-09, 3847866.9725167281)
>>> utm_x,utm_y=utm(105,36)
>>> utm_x,utm_y (500000.00000000116, 3984019.0588136762)
＃下边直接从 albers转为 utm坐标
>>>to_utm_x,to_utm_y=pyproj.transform(albers,utm,albers_x ,albers_y)
>>> to_utm_x,to_utm_y (500000.00000000116, 3984019.0588136753)
```

## 6.3 Geod类[#](https://www.cnblogs.com/oloroso/p/5749057.html#3149140916)

主要用来求算地球大圆两点间的距离，及其相对方位，以及相反的操作。同时也可以在两点间插入 N等分点。
该类主要包括三个函数：
`fwd(self,lons,lats,az,dist,radians=False)`参数为经度，纬度，相对方位，距离。
正转换，返回经纬度，以及 back azimuths。可以用 numpy and regular python array objects, python
sequences and scalars。如果 radians为真把输入的经纬度单位当作弧度，而不是度。距离单位为米。
`inv(self, lons1, lats1, lons2, lats2, radians=False)`
反变换，已知两点经纬度，返回其前方位解，后方位角，以及距离。
`npts(self, lon1, lat1, lon2, lat2, npts, radians=False)`
给出一个始点（lon1，lat1）和终点(lon2，lat2)以及等份点数目 npts。举例（懒得写了，照抄过来，已验证）：

```python
Copy Highlighter-hljs>>> from pyproj import Geod 
>>> g = Geod(ellps='clrk66') # Use Clarke 1966 ellipsoid. 
>>> # specify the lat/lons of Boston and Portland. 
>>> boston_lat = 42.+(15./60.); boston_lon = -71.-(7./60.) 
>>> portland_lat = 45.+(31./60.); portland_lon = -123.-(41./60.) 
>>> # find ten equally spaced points between Boston and Portland. 
>>> lonlats = g.npts(boston_lon,boston_lat,portland_lon,portland_lat,10) 
>>> for lon,lat in lonlats: print '%6.3f  %7.3f' % (lat, lon) 43.528 -75.414 44.637 -79.883 45.565 -84.512 46.299 -89.279 46.830 -94.156 47.149 -99.112 47.251 -104.106 47.136 -109.100 46.805 -114.051 46.262 -118.924
```

初始化一个 Geod类实例：使用关键字方法来传一个椭球体，椭球体为 proj中支持的任何一个。

```python
Copy Highlighter-hljs>>> g=Geod(ellps='krass')
```

同时也可以指定 a，b，f，rf，e，es来设定地球椭球体。

```python
Copy Highlighter-hljs>>> miniearth=Geod(a=2,b=1.97) ＃单位为米
```

这样对于一个确定的实例就可以使用上边的三个函数了。实例（继续照抄过来）：

```python
Copy Highlighter-hljs>>> from pyproj import Geod
>>> g = Geod(ellps='clrk66') # Use Clarke 1966 ellipsoid.
>>> # specify the lat/lons of some cities.
>>> boston_lat = 42.+(15./60.); boston_lon = -71.-(7./60.)
>>> portland_lat = 45.+(31./60.); portland_lon = -123.-(41./60.) 
>>> newyork_lat = 40.+(47./60.); newyork_lon = -73.-(58./60.) 
>>> london_lat = 51.+(32./60.); london_lon = -(5./60.) 
>>> # compute forward and back azimuths, plus distance 
>>> # between Boston and Portland. >>> az12,az21,dist = g.inv(boston_lon,boston_lat,portland_lon,portland_lat) 
>>> print "%7.3f %6.3f .3f" % (az12,az21,dist) -66.531 75.654 4164192.708 >>> # compute latitude, longitude and back azimuth of Portland, >>> # given Boston lat/lon, forward azimuth and distance to Portland. >>> endlon, endlat, backaz = g.fwd(boston_lon,boston_lat, az12, dist) >>> print "%6.3f  %6.3f .3f" % (endlat,endlon,backaz) 45.517 -123.683 75.654 >>> # compute the azimuths, distances from New York to several >>> # cities (pass a list) >>> lons1 = 3*[newyork_lon]; lats1 = 3*[newyork_lat] >>> lons2 = [boston_lon, portland_lon, london_lon] >>> lats2 = [boston_lat, portland_lat, london_lat] >>> az12,az21,dist = g.inv(lons1,lats1,lons2,lats2) >>> for faz,baz,d in zip(az12,az21,dist): print "%7.3f %7.3f %9.3f" % (faz,baz,d) 54.663 -123.448 288303.720 -65.463 79.342 4013037.318 51.254 -71.576 5579916.649
```

7 参考资料

- [proj](http://trac.osgeo.org/proj/)
- Cartographic Projection Procedures Release 4 Interim Report
- Cartographic Projection Procedures for the UNIX Environment—A User’s Manual
- [pyproj](http://pyproj.googlecode.com/svn/trunk/README.html)