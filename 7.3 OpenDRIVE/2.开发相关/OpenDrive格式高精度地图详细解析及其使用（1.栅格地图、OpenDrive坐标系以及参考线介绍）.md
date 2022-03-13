- [OpenDrive格式高精度地图详细解析及其使用（1.栅格地图、OpenDrive坐标系以及参考线介绍）_LeeLee是一个小学生的博客-CSDN博客_opendrive](https://blog.csdn.net/qq_39767850/article/details/121266171?ops_request_misc=%7B%22request%5Fid%22%3A%22164718010616781683937166%22%2C%22scm%22%3A%2220140713.130102334.pc%5Fblog.%22%7D&request_id=164718010616781683937166&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~blog~first_rank_ecpm_v1~rank_v31_ecpm-24-121266171.nonecase&utm_term=OpenDrive&spm=1018.2226.3001.4450)

## 一.栅格地图

栅格地图是我接触的第一个所谓的高精度地图，因为当时刚刚入门，啥也不懂，到网上搜索大多数的地图出来的就是栅格地图，但是栅格地图其实本质上并不属于高精度地图，我们目前所理解的高精度地图能达到的许多功能栅格地图完全做不到，最简单的一点，栅格地图只能实现静态障碍物的避障，对于机器人可能是够了，但是对于自动驾驶车辆来说是完全不够的，车辆需要按照道路结构去走，从而做出相应的规划。话虽如此，如果你想做的功能很简单，那么栅格地图也不是不可以。
接下来我会简单叙述一下如何生成栅格地图，注意，我们这里的前提是离线建图，动态SLAM建图需要你另寻出路。我们采用激光SLAM的方法生成栅格地图，生成栅格地图我们首先需要生成点云地图，啥是点云地图，可以看下面的图片，你可以简单理解为通过激光SLAM算法拼接一帧一帧的激光点云帧生成的一个点云图（详细名词定义请搜索引擎）
![在这里插入图片描述](https://img-blog.csdnimg.cn/05f7011118c34150b747d7e7b0c30990.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBATGVlTGVl5piv5LiA5Liq5bCP5a2m55Sf,size_20,color_FFFFFF,t_70,g_se,x_16)激光SLAM生成的点云地图格式大多是PCD格式的，显示PCD格式的点云文件可以使用CloudCompare，软件除了偶尔卡死意外真的很好用。
得到点云地图的方法就是通过激光SLAM自己去建图，可以去看我之前写的那篇文章（这里注意一下，lego_loam在没有imu的情况下Z轴偏移情况很严重，如果你只有一个激光雷达，那么我建议你使用hdl_graph_slam或是其他SLAM算法）。
得到这个点云地图以后，我们就可以写代码来获得栅格地图了，那么如何通过点云生成的栅格地图就是一个问题，我们知道点云地图是由一个个密密麻麻的点构成的，每个点都有其三维坐标，栅格地图就是用一个个栅格组成的网格来代表地图，栅格里可以存储不同的数值，代表这个栅格的不同含义。比如我们表示这个格子被占用（有静态障碍物），就可以把表示这个格子的像素点标注为黑色，没有障碍物则为白色。我们首先给定一个栅格地图的分辨率，比如说我们规定栅格上的一个格子代表0.5 * 0.5米的面积，那么在点云地图上，将点云中的每个点按照0.5 * 0.5的格子去做二维投射（各位可以在脑子中想象一下这个过程，就不详细展开来讲了）随后我们根据投射到每个格子中的点的个数和其高度Z值来判定这个格子是否显示为占用，大致过程就是这样，如果想深入学习关于栅格地图的相关知识可以去找更具体的文章，这里只是简单介绍一下。
我做这部分的工作的代码刚开始是自己写的，后来在找SLAM算法的时候发现koide3大神（hdl_graph_slam的作者）开源了一个相同功能的代码，功能和效果都非常好，我把网址分享给大家，大家可以自己去下载。完成此步骤我们就可以获得一个栅格地图啦：
![在这里插入图片描述](https://img-blog.csdnimg.cn/df689120c1f24c5eb1fbc6b9d12cb2e7.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBATGVlTGVl5piv5LiA5Liq5bCP5a2m55Sf,size_12,color_FFFFFF,t_70,g_se,x_16)
接下来我们就可以在这个栅格地图上执行路径规划算法了，比如A*，这方面的文章很多，我们目前项目所使用的代码也是在CSDN的基础上改出来的，大家可以根据A*框架结合自己的需求去写。
到此为止栅格地图差不多就告一段落了，总之，如果做的是自动驾驶寻路方面的项目，强烈建议不要使用栅格地图，因为其自身的限制，导致你很难通过它给予下游模块（如轨迹规划和决策控制）很好的支持，这里大致了解一下就可以了。

## 二.OpenDrive格式的高精度地图

其实今年年初的时候我们并没有意识到栅格地图的劣根性，因为我们实验室之前没有做过类似的项目，而且委托的甲方更不懂，直到今年4月份的时候我们自己意识到问题才决定另寻出路。
我们的OpenDrive地图时甲方委托专业的制图公司来提供的，因此我们并没有去手动标注一张地图，但是大致路线是有的：还是生成一张点云地图（需要结合RTK，因为你需要设置投影关系），用RoadRunner软件去进行投影关系的设置和道路元素的标注，可以知乎关注@王方浩，他写过一篇文章就是关于用RoadRunner来制作Opendrive格式的高精度地图，过一阵子我也会自己践行一下技术路线，然后把怎么做更新上来。
OpenDrive是一种比较成熟的开源的描述道路结构的格式，其自身格式为xml文件（.xodr），用文字和公式的形式来表达一系列道路的形状和连接情况。接下来，我会首先介绍OpenDrive的结构（我并不会把OpenDrive中的所有元素都介绍给你，因为确实很多元素用的很少，如果一股脑的都写上不如叫你去看OpenDrive的官方文档。对了，官方文档的地址在这：https://www.asam.net/index.php?eID=dumpFile&t=f&f=3768&token=66f6524fbfcdb16cfb89aae7b6ad6c82cfc2c7f2）。随后告诉你如何解析OpenDrive的结构到内存中形成相应的数据结构，最后研究如何在OpenDrive的数据结构中实现routing的功能。
在介绍总体结构之前，我先要向你讲述**Opendrive的坐标系**，OpenDrive地图中主要包含三个坐标系，分别为xy惯性坐标系，st参考线坐标系和uv局部坐标系，其中我将着重于前两个坐标系，因为第三个确实用处没有那么大。三者关系如图所示：
![在这里插入图片描述](https://img-blog.csdnimg.cn/07bcf76b3e8541c1863328ccab0bc755.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBATGVlTGVl5piv5LiA5Liq5bCP5a2m55Sf,size_20,color_FFFFFF,t_70,g_se,x_16)

惯性坐标系的X轴通常指向东，Y轴指向北，作为最稳定的坐标系，在执行routing等功能时我们使用的都是惯性xy坐标，弧度关系为X轴为0逆时针为正（-pi, pi），Y轴为pi/2。接下来我们有很多地方会使用到惯性坐标系。
st坐标系是我个人认为最重要的坐标系，又名参考线坐标系，参考线我会在下面重点讲解，目前你可以将其理解为道路走势的一种抽象，看上面的蓝线就是一条参考线，将其想象为一条道路，那么st坐标系的走势就是从参考线开始到参考线结束一直沿着参考线的切线方向进行的，st坐标系是针对于参考线来说的，只有同一条参考线为基准下才能比较两个点的st坐标。大致如下图所示：

![请添加图片描述](https://img-blog.csdnimg.cn/3dcc85d5db8d472884d015ed54db2379.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBATGVlTGVl5piv5LiA5Liq5bCP5a2m55Sf,size_20,color_FFFFFF,t_70,g_se,x_16)

可以看到，st坐标系一直随着参考线的变化在变化，且一直沿着切线方向，由此我们可以推断出：在st坐标系中S的取值范围为[0, 参考线长度length]，而t即为基于参考线的偏移，所有处于参考线上的点t值均为0，这里请自己思考一下，下面我们讲参考线的时候还会再叙述。
uv坐标系目前看来只有在参数多项式那里使用了，你目前只需要知道它是由参考线坐标系通过确定原点并提供偏向角来确定的，此外无他。
接下来正式是OpenDrive的总体结构，下面我用一张图来表述：
![在这里插入图片描述](https://img-blog.csdnimg.cn/8af88ca314a84a17b5e889afa7eefd0d.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBATGVlTGVl5piv5LiA5Liq5bCP5a2m55Sf,size_10,color_FFFFFF,t_70,g_se,x_16)
这是我在csdn的一篇文章中找来的图，我们可以看到可以将OpenDrive格式的文件结构分为**三大类：Header类，Roads类，Junction类。**
**首先第一类是Header**，这个大类元素中最重要的一个元素就是geoReference，这个元素规定了整个Opendrive地图的投影方式，因为我们的地球是椭球体，所以需要将其进行相应的投影成为笛卡尔坐标系的坐标，我不是GIS专业的，所以原理我并没有深入了解。当你在用OpenDrive地图时，你可以使用georeference中给出的proj字符串，通过pyproj（一个python的库，可以处理很多GIS方面的问题）设定对应关系，来完成诸如WGS84向opendrive惯性坐标的转换。（具体的对应关系以及proj的投影问题可以去proj的官网或者CSDN学习下，pyproj里面的CRS支持直接输入proj字符串进行解析，不需要你弄懂他的构造）。下图中是我标出的proj字符串位置：
![请添加图片描述](https://img-blog.csdnimg.cn/264626cf7128412b8e11ef0c7ebe69ff.png)

**第二类是Roads类**，这是我们要最着重讲的环节，Roads类中包含着所有地图中描述了的道路，每一条道路被一对road标签表示。让我们根据实例先看一眼road在OpenDrive是如何表述的
![在这里插入图片描述](https://img-blog.csdnimg.cn/6666517e653a474b92e3a61854557fee.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBATGVlTGVl5piv5LiA5Liq5bCP5a2m55Sf,size_20,color_FFFFFF,t_70,g_se,x_16)
这是我在OpenDrive中挑选的一个road元素，可以看到拿这个图片结合上面的结构图片对比一下，我框选出来的road中比较重要的元素包括link、planView、lanes等，接下来我们会一一进行讲解。
首先要介绍的是road自身的属性
![在这里插入图片描述](https://img-blog.csdnimg.cn/9efb05bc1d234a068be19b04ebd9ed5c.png)
可以看到上面的属性包括name即道路的名字，这个属性并非必须，length是道路的总长度，还记得我们上面说过的st坐标系取值么，其中的[0,length]就是这个length。id是一种专属于道路的唯一属性，OpenDrive文件中不允许出现两个ID相同的道路。junction是标明该道路是否属于一个junction（交叉口，这个元素我们后面会讲，你目前可以将他理解为一个道路关系的集合，专门用来处理复杂道路连接情况的）如果该道路属于一个junction，那么junction属性的值就是所属junction的id。
接下来就是road中包含的诸多属性，在最开始我们要介绍的就是参考线，是我认为整个road中最重要的元素，首先我想希望读者您在脑海中构想出一条道路，不考虑该道路上的车道和宽度，将其抽象为一条线，这大致就是参考线的雏形了，在这里，我先给出一张图，
![在这里插入图片描述](https://img-blog.csdnimg.cn/4c4caf044c224eb6844f8e198b61e91a.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBATGVlTGVl5piv5LiA5Liq5bCP5a2m55Sf,size_20,color_FFFFFF,t_70,g_se,x_16)
这张图表示了一个道路的组成，我希望读者重点观察参考线和道路、车道之间的关系，你要知道的一点是，绝大部分情况下，参考线代表了道路的大体走势。
接下来的问题是，我们该如何用公式和数字表示参考线呢？请记住下面的话：**一条道路只能有一条参考线，而一条参考线可以有多条几何线构成。**是的，我们使用一种叫做几何线（geometry）的元素来表示参考线。为什么要用多条几何线来表示参考线呢，因为我们无法保证一条道路的走势是完全一致的，设想一条前半段为直线后半段为曲线的道路，如果想方便的用方程对其进行表示，分段表示是最好的选择，而这种分段，就是几何线表示参考线的远离所在。

我们来看一下参考线和几何线在opendrive中是被如何表示的：
![在这里插入图片描述](https://img-blog.csdnimg.cn/4e5e5618e9d8486aa5efc8db4e644471.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBATGVlTGVl5piv5LiA5Liq5bCP5a2m55Sf,size_20,color_FFFFFF,t_70,g_se,x_16)
你可以仔细看一下上图中的元素，猜想一下其中元素的含义，我可以先告诉你，这一条道路由两条直线几何线和一条弧线几何线构成，我用matplotlib把这条道路用点画出来就是下面的效果
![请添加图片描述](https://img-blog.csdnimg.cn/8e439e0da2d447a0bebc31584f59200f.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBATGVlTGVl5piv5LiA5Liq5bCP5a2m55Sf,size_20,color_FFFFFF,t_70,g_se,x_16)
这是一整条道路，最右面红色的点代表的就是参考线（为什么你后面就知道了），现在你应该可以大致看出端倪了，在下面我们会对这条道路做详细分析。
为了更好理解我们要做的事情，接下来我们了解几种比较常用的几何线;
首先是直线，直线是最常用的元素，在OpenDrive中用line来表示。直线有四个属性，首先是S值，S值表示该段几何线在参考线中的起始位置，观察上面我给出的那条参考线并结合OpenDrive代码，你可以发现表示参考线的第一条几何线就是直线，所以第一条直线的S值就是0。其次是x, y值，xy值给出参考线起始位置在惯性坐标系下的位置。然后是heading，该值给出起始朝向，用弧度表示，上面给出的第一条line的弧度转化成为角度大致是-71度，最后是length属性，给出几何线的长度。结合上述属性，我们可以确定这样一条参考线。我画出了大致的示意，希望能对你有帮助![请添加图片描述](https://img-blog.csdnimg.cn/ce0f2963cd7b4a5096d492abb227157f.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBATGVlTGVl5piv5LiA5Liq5bCP5a2m55Sf,size_20,color_FFFFFF,t_70,g_se,x_16)
下面要介绍的参考线是弧线，也可以理解为弧度一致的曲线，在OpenDrive中使用arc来表示，弧线的属性除了直线所有的一切以外还包括一个curvature弧度，因为弧线本身就是弧度恒定的曲线，这样通过上述属性我们就可以确定一个弧线了，还是给出大致的示意图，希望能够对你有帮助，注意观察，此时弧线的起始S值与上一条直线的length一致（一定要完全掌握S值的概念和st坐标系，要不然后面会出问题）弧度是一致的，我画工有点菜，凑活看。
![请添加图片描述](https://img-blog.csdnimg.cn/8ca6dea5579f483a851ffec5180bbb4d.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBATGVlTGVl5piv5LiA5Liq5bCP5a2m55Sf,size_20,color_FFFFFF,t_70,g_se,x_16)
再介绍一个螺旋线，用spiral表示，螺旋线特点是他是弧度线性变化的曲线，所以在包含所有直线的属性以外，还包含一curvStart和curvEnd属性，为线性变化的起始点和终止点。我手中的OpenDrive实例是没有spiral元素的，所以只能给你官方的图实例，看出弧度线性变化的效果了么？
![在这里插入图片描述](https://img-blog.csdnimg.cn/3e75d26e502f457c9f13212b42940138.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBATGVlTGVl5piv5LiA5Liq5bCP5a2m55Sf,size_8,color_FFFFFF,t_70,g_se,x_16)
下面还有一个参数三次多项式，放在过两天再更吧，今天已经写了很多了。

（2021.11.20更新）
接下来我们讲解最后一个几何线，即参数三次多项式，本来应该还有一个三次多项式的，但是已经被OpenDrive官方取消了，以参数三次多项式代替，但是我们还是要首先介绍一下三次多项式，以便更好的理解参数三次多项式。我们先给出参数三次多项式的方程：
![在这里插入图片描述](https://img-blog.csdnimg.cn/ada7e0a18ac9464c969e3738b7084230.png)

三次多项式我们会用到一个前文提到的很少用到的坐标系，那就是uv坐标系，前面说过，uv坐标系是根据st坐标系给出偏移生成的一个坐标系，那么是如何给定参数确定的这种偏移呢，答案是通过上面给出的a、b参数，参数b负责给出相对于st坐标系的航向角/偏向角，角度为arctan(b)，参数a负责给出当u = 0时，沿v坐标轴的偏移量。那么聪明的你此刻一定意识到了，当uv坐标系与st坐标系重合时，a = b = 0。当我们想将uv坐标转换为xy坐标时，使用下述公式：
![在这里插入图片描述](https://img-blog.csdnimg.cn/4930fee7bfac4642b941f6256c8df0ad.png)
参数三次多项式就暂时讲这么多，接下来就是参数三次多项式，参数多项式稍稍有些复杂，我并不知道我是否能够讲好，如果你没看懂可以去看看官方文档或者其他人写的。参数三次多项式有很多属性:aU、bU、cU、dU、aV、bV、cV、dV、pRange，下面结合公式：
![在这里插入图片描述](https://img-blog.csdnimg.cn/1a1e6b4353114ff99ca1bf77f9a845a3.png)
可以看出参数三次多项式与三次多项式不同，将uv坐标系的两个值uv**分开**，并引入公共参数p,注意这里的p并不是给的属性pRange，p是需要你自己去算的插值，而这个p的取值范围就是（0，pRange），那么我们计算p呢，下面给出我的算法：
**dis / length \* pRange**
其中dis就是你希望在这条线上每隔多少取一个点，length就是这条参考线的实际长度，这个算法实际上很简单，你一定能看懂，这样迭代dis就可以获得一系列的p,通过这些p就可以获得一系列的u、v，再通过上面给出的式子就可以获得x、y，语言很抽象，下面看图：
![在这里插入图片描述](https://img-blog.csdnimg.cn/e5ae44dcad0a49cc9d25b03fb0d1393c.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBATGVlTGVl5piv5LiA5Liq5bCP5a2m55Sf,size_10,color_FFFFFF,t_70,g_se,x_16)
![在这里插入图片描述](https://img-blog.csdnimg.cn/43ff2d7878334f83ac9005321ee10267.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBATGVlTGVl5piv5LiA5Liq5bCP5a2m55Sf,size_10,color_FFFFFF,t_70,g_se,x_16)
![在这里插入图片描述](https://img-blog.csdnimg.cn/8f9213832983466dad2e400f039c03eb.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBATGVlTGVl5piv5LiA5Liq5bCP5a2m55Sf,size_10,color_FFFFFF,t_70,g_se,x_16)
重点看第三幅图,上面有各个参数的几何意义，希望看到这你能够大致理解参数三次多项式的结构和格式。