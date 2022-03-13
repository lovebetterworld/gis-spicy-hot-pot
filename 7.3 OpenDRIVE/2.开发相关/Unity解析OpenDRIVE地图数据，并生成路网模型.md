- [Unity解析OpenDRIVE地图数据，并生成路网模型_方寸想法，编码宇宙-CSDN博客_opendrive unity](https://blog.csdn.net/qq_36622009/article/details/107006508?ops_request_misc=&request_id=&biz_id=102&utm_term=OpenDrive&utm_medium=distribute.pc_search_result.none-task-blog-2~blog~sobaiduweb~default-6-107006508.nonecase&spm=1018.2226.3001.4450)

### 一、引言

前置知识：

[Unity解析OSM数据，并生成简单模型](https://blog.csdn.net/qq_36622009/article/details/106862309)

这次参考了两个[开源项目](https://so.csdn.net/so/search?q=开源项目&spm=1001.2101.3001.7020)：

- [OpenDRIVE2Unity3D](https://github.com/AIMRL/OpenDRIVE2Unity3D)
- [OpenDrive-Unity-Renderer](https://github.com/Furqan539/OpenDrive-Unity-Renderer)

第二个项目比较好，是直接用的OpenDRIVE原本的格式。第一个项目用的数据经过处理，直接看不出来是怎么解析源数据的，生成模型的方法也许可以看看。

以下内容都是对`OpenDrive-Unity-Renderer`的解读。本次使用Unity解析OpenDRIVE生成路网的模型如下：

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200628200921284.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NjIyMDA5,size_16,color_FFFFFF,t_70#pic_center)
有路网和建筑模型，车跑上去效果还行，但是交叉口没有处理，还是模型重叠的状态。

### 二、OpenDrive概述

OpenDRIVE ®是一个开放的文件格式，用于道路网络的逻辑描述。它是由一组仿真专业人员开发并维护的，并得到了仿真行业的大力支持。它的首次公开露面是在2006年1月31日。

**1.为什么要使用OpenDRIVE ®？**

OpenDRIVE ®是独立于供应商，并且可以免费使用
OpenDRIVE ®包含了所有的主要功能路网
OpenDRIVE ®是一个具有广泛的国际用户群
OpenDRIVE ®是一个管理良好的格式，发展过程透明

OpenDRIVE被开发出来是为了创建一种标准的地图数据格式，方便在各种驾驶仿真模拟器中进行数据交换。

**2. OpenDRIVE的特征：**

- XML格式
- 层次结构
- 道路几何形状的解析定义：（平面元素，横向/垂直轮廓，车道宽度等）
- 各种类型的车道
- 连接点和连接点组
- 通道的逻辑互连
- 标志和信号，包括 依存关系
- 信号控制器（例如用于路口）
- 路面特性（另请参见OpenCRG）
- 道路和路边物体
- 用户可定义的data beads
- 等等

**3. OSM和OpenDRIVE的比较：**

可以看到，OpenDRIVE也是一种XML文件，是一种矢量地图。只不过，相比OSM地图，它包含的信息更多，结构也更复杂。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200628195007946.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NjIyMDA5,size_16,color_FFFFFF,t_70#pic_center)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200628195033771.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NjIyMDA5,size_16,color_FFFFFF,t_70#pic_center)
**4.文件下载**

[这里](http://www.opendrive.org/download.html)可以下载OpenDRIVE的文件规范，对每个节点、每个节点的每个属性都做了详细的解释。还可以下载示例的OpenDRIVE数据。

### 三、OpenDrive重要节点介绍

这是我做的一个XML节点和属性的导图。“【】”表示这个节点一般有多个。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200628195626147.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NjIyMDA5,size_16,color_FFFFFF,t_70#pic_center)
在OpenDRIVE中，所有的道路都由一条定义基本几何图形(弧线，直线等)的reference line组成。沿着reference line，可以定义道路的各种属性。例如:高程轮廓线、交通标志等。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200629185012318.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NjIyMDA5,size_16,color_FFFFFF,t_70)

可以在思维导图中看到，road节点是重点，其中geometry节点就定义了reference line，而lane节点重点定义了各车道的属性。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200628195911788.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NjIyMDA5,size_16,color_FFFFFF,t_70#pic_center)
通过指定与reference line的横向距离来创建单独的车道。reference line通过连接clothoids(又名欧拉螺旋)或多项式来构建。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200628195959247.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NjIyMDA5,size_16,color_FFFFFF,t_70#pic_center)

请注意圆弧段和直线是clothoids的特殊情况。使用clothoids的优点是，沿着reference line的曲率随路径长度线性变化，这就是为什么大多数道路都是由clothoids构造的。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200628200025832.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NjIyMDA5,size_16,color_FFFFFF,t_70#pic_center)
三种线的曲率变化：

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200628200055647.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NjIyMDA5,size_16,color_FFFFFF,t_70#pic_center)

#### 1.建模用到的主要节点及属性

在项目中直接把用到的属性划个重点，接下来我们主要就看看这些属性是什么意思。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200628200332715.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NjIyMDA5,size_16,color_FFFFFF,t_70#pic_center)

- geometry.x
- geometry.y
- geometry.length
- geometry.hdg
- geometry.arc.curvature
- laneSection.right.lane[i].width.a

#### 2.geometry节点

一连串道路 geometry的节点在x/y平面(plan view)上定义了道路reference line的layout。这些geometry节点必须按照升序排列(i.e. increasing s-position). 一个子节点包含了具体的geometric元素的数据。OpenDRIVE现在支持五种geometric元素：

- straight lines
- spirals
- arcs
- cubic polynomials
- parametric cubic polynomials

geometry节点的属性：![在这里插入图片描述](https://img-blog.csdnimg.cn/2020062820165754.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NjIyMDA5,size_16,color_FFFFFF,t_70)
这里的`s-coordinate`是指：

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200628210502304.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NjIyMDA5,size_16,color_FFFFFF,t_70#pic_center)

`inertial`是指：

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200628210158479.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NjIyMDA5,size_16,color_FFFFFF,t_70#pic_center)

我们看一个具体的例子：

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200628202935369.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NjIyMDA5,size_16,color_FFFFFF,t_70#pic_center)
这里的reference line的类型是line，并且起始点的坐标是(x,y)=(512.5,-2250)，它的heading朝向的弧度约是1.57，line的长度为583。我们知道了道路参考线的起点、朝向、长度就可以确定这个参考线的位置了。

#### 3.lane的width节点

lanes节点由多个laneSection节点组成。若不定义新的lane section节点，它定义的数值就始终有效，适用于接下来的road（Each lane section is valid until the next lane section is defined）。所以每条road至少有一个从s=0.0m起始的lane section。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200628195911788.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NjIyMDA5,size_16,color_FFFFFF,t_70#pic_center)
一个lane section至少包含left/center/right三种节点中的一个。lane节点被包含在left/center/right节点中。车道用数字ID来区分，这些ID有如下特点：

- 唯一
- 连续 (i.e. without gaps),
- starting from 0 on the reference line
- 向左侧递增 (positive t-direction)
- 向右侧递减 (negative t-direction)

每条road的lane的数量是不限的。 reference line被定义为 lane zero，且不允许有width节点，因为它的宽度总为0。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200629183850524.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NjIyMDA5,size_16,color_FFFFFF,t_70#pic_center)
除了center里面的lane，其他lane至少有一个width节点。和lane section一样，如果不定义下一个width节点的话，它定义的数值就一直适用于接下来的lane。如果一个lane有多个width节点，它们必须按照升序排列。

width节点的属性如下：

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200629190708839.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NjIyMDA5,size_16,color_FFFFFF,t_70#pic_center)

看看具体数据：

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200629190630408.png#pic_center)

上述的lane的width节点中，只有属性“a”的值不为0。观察了下整个xml文件，发现几乎所有的width节点的属性都一样，只有a有值。那么a的含义是什么呢？

查文档后发现，在给定点处的实际宽度是用三阶多项式函数计算的，这个函数看起来像这样：w i d t h = a + b ∗ d s + c ∗ d s 2 + d ∗ d s 3 width = a + b*ds + c*ds^2 + d*ds^3*w**i**d**t**h*=*a*+*b*∗*d**s*+*c*∗*d**s*2+*d*∗*d**s*3其中，width就是给定点（`位于reference line上的点？`）处的车道宽度。a,b,c,d是常数系数。ds是the distance along the reference line between the start of the entry and the actual position.总体来讲，如果车道宽度变化比较复杂，那么计算也比较复杂。但是在本xml文件中，对车道的宽度做了简化，所有宽度都为10，ds相乘的系数都为0。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200629191421959.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NjIyMDA5,size_16,color_FFFFFF,t_70#pic_center)

### 四、根据解析得到的数据创建道路模型

对于每条道路，已知它们的参考线起点坐标、参考线方向、长度。在这个xml文件中只有两种参考线类型，line和arc。我们可以把line和arc都用贝塞尔曲线来表示。根据参考线的信息，得到相应贝塞尔曲线上点的坐标，从而确定最终的模型顶点，渲染出模型。

（PS：其实我们也可以不用贝塞尔曲线，使用和OSM数据生成模型一样的方法。因为不管是line还是arc，实际上都是由线段拼接表示的，我们得到线段的顶点后，完全可以直接用这些顶点生成Mesh。）

按照这个思路，我们可以创建一个脚本BezierCurvePath，用来单独绘制每条road。在绘制road时，分为两个步骤：首先把这条road的参考线转为贝塞尔曲线上的点；再根据贝塞尔曲线上的点确定模型顶点，进行渲染。

#### 1.把reference line表示为Bezier曲线

##### （1）Bezier曲线介绍

在[这个网站](https://cubic-bezier.com/#.09,.63,.84,.48)可以调整控制点，并实时看到Bezier曲线的效果。

搬一个数学总结：

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200629202459356.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NjIyMDA5,size_16,color_FFFFFF,t_70#pic_center)

##### （2）获取一条road reference line的信息

```csharp
public List<BezierCurveData> curveDatas = new List<BezierCurveData>();

void Start()
	{
		float length_s = 0f,x = 0f, y = 0f;
		float angle = 0f,curvature = 0f,patchWidth = 0f; int lanes = 0;		
		string path = Application.dataPath+ "/XMLFiles/cloverleaf.xml";
		XmlSerializer serializer = new XmlSerializer(typeof(OpenDRIVE));
		string xml = File.ReadAllText(path);

		using (var stream = new MemoryStream(Encoding.UTF8.GetBytes(xml)))
		{
			openDrive = (OpenDRIVE)serializer.Deserialize(stream);
			
			//这个脚本只能处理一个road，所以设置了一个roadVariable来指定road的index
			
			//reference line起点的x坐标
			x = openDrive.roads[roadVariable].plainView.geometry.x;
			//reference line起点的y坐标
			y = openDrive.roads[roadVariable].plainView.geometry.y;
			//reference line的长度
			length_s = openDrive.roads[roadVariable].plainView.geometry.length;
			//reference line 的heading角度
			angle = openDrive.roads[roadVariable].plainView.geometry.hdg;
			//生成道路模型的宽度：车道数x10
			cubeThickness = openDrive.roads[roadVariable].lanes.laneSection.right.lane.Length * 10;			
			//如果reference是arc，存储曲率
			try	{curvature = openDrive.roads[roadVariable].plainView.geometry.arc.curvature;}
			catch (NullReferenceException e){}
		}
		
		CityGenerator(x, y, length_s, angle, curvature);
	}
```

##### （3）根据reference line信息生成Bezier曲线数据

###### A. Line

![在这里插入图片描述](https://img-blog.csdnimg.cn/2020062921052156.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NjIyMDA5,size_16,color_FFFFFF,t_70#pic_center)

```csharp
void CityGenerator(float x, float y, float len, float angle, float curvature)
{	
	float x_end = 0.0f, y_end = 0.0f;	
	
	if (curvature != 0.0f) {......}
	else{
			//根据length和theta角度算出endPos
			x_end = len * Mathf.Cos (angle);
			y_end = len * Mathf.Sin (angle);
			
			//按照长度，将line等分为3段，这样就可以得到4个点了
			float add_pointx = x_end / 3, add_pointy = y_end / 3;
			
			float point1x, point2x, point3x, point4x;
			float point1y, point2y, point3y, point4y;
			
			point1x = x;
			point2x = point1x + add_pointx;
			point3x = point2x + add_pointx;
			point4x = point3x + add_pointx;

			point1y = y;
			point2y = point1y + add_pointy;
			point3y = point2y + add_pointy;
			point4y = point3y + add_pointy;
			
			//定义Bezier曲线的4个控制点
			var curve = new BezierCurveData ();
			curve.points = new Vector3[4]
			{
				new Vector3 (point1x, 0.1f, point1y),
				new Vector3 (point2x, 0.1f, point2y),
				new Vector3 (point3x, 0.1f, point3y),
				new Vector3 (point4x, 0.1f, point4y)
			};			
			curveDatas.Add (curve);
	}
}
```

###### B. Arc

[关于曲率的介绍](https://www.zhihu.com/question/25952605)

**先搞懂这些角度、点的含义：**

在下面这张图中，我们可以看到坐标系原点在右下角，x轴和z轴垂直，构成了水平面，这和Unity场景中的俯视图看到的坐标系是一样的。在opendrive的数据中，reference line的起点所在坐标系也是平面坐标系，是用x和y来表示的，这里的y和unity中的z等同，都是水平面上与x轴垂直的轴。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200630141650100.PNG?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NjIyMDA5,size_16,color_FFFFFF,t_70#pic_center)
我自定义了一个reference line，它的xml节点属性值如下：起点的坐标为(x,y)=(0,0)，hdg=1.57，转换为角度为90度，这条arc的弧长为1374m。这里的hdg，指的就是这条弧在起点处的切线，与x轴的夹角。从图上也可以看出来是90度。

```xml
<road id="3" name="R3" length="1374.446786" junction="-1">
	<planView>
		<geometry s="0.0" x="0" y="0" hdg="1.570796" length="1374.446786">
			<!-- hdgDegrees="90.0"-->
			<arc curvature="-0.001143" />
			<!-- radius="875.0"-->
		</geometry>
	</planView>
	<lanes>
		<laneSection s="0.0">
			<right>
				<lane id="-1" type="driving" level="false">
					<width sOffset="0.0" a="10.0" b="0.0" c="0.0" d="0.0" />
				</lane>
			</right>
		</laneSection>
	</lanes>
</road>
```

在下面这段代码中，startAngle就是hdg的值，roadLength就是弧长，radius根据曲率的绝对值计算得到，值为875,（在xml的注释中已经写出）。如果曲率的值小于0，那么这条arc的方向就是顺时针的。centerX和centerY是arc所在圆的圆心的横纵坐标。

```csharp
if (curvature != 0.0f) {
	float startAngle = angle;
	float roadLength = len;
	float radius = 1.0f / Mathf.Abs (curvature);
	bool clockwise = curvature < 0.0f;
	float centerX = x - radius * Mathf.Cos (startAngle - HALF_PI) * (clockwise ? -1.0f : 1.0f);
	float centerY = y - radius * Mathf.Sin (startAngle - HALF_PI) * (clockwise ? -1.0f : 1.0f);
	......
}
```

计算圆心需要考虑startAngle、clockwise的值，我们就用最简单的图上的这个arc为例：startAngle=HALF_PI，clockwise为true，所以c e n t e r X = x − r a d i u s ∗ C o s ( 0 ) ∗ ( − 1 ) = x + r a d i u s centerX=x-radius*Cos(0)*(-1)=x+radius*c**e**n**t**e**r**X*=*x*−*r**a**d**i**u**s*∗*C**o**s*(0)∗(−1)=*x*+*r**a**d**i**u**s*c e n t e r Y = y − r a d i u s ∗ S i n ( 0 ) ∗ ( − 1 ) = y centerY=y-radius*Sin(0)*(-1)=y*c**e**n**t**e**r**Y*=*y*−*r**a**d**i**u**s*∗*S**i**n*(0)∗(−1)=*y*也就得到了图上所示的center点的坐标。

在得到如上信息后，我们可以考虑如何创建多个折线段来表示这么长的弧线，每个折线段可以用一条贝塞尔曲线来表示，该贝塞尔曲线的中间两个点分别和起点终点重合。可以用下面`getNewCurve`函数来构建具体的贝塞尔曲线：我们只需要输入该折线段的起点和终点的vector。

```csharp
BezierCurveData getNewCurve(Vector3 prev_vector, Vector3 end_vector)
{
	var curve_data = new BezierCurveData();
	curve_data.points = new Vector3[4]{
		prev_vector, prev_vector,
		end_vector, end_vector
	};
	return curve_data;
}
```

为了获得这些小折线段的起点（`start_vector` ）和终点（`second_vector`），我们可以使用一个while循环，当这些小折线段的总长度没有达到弧线长度时，就不断更新`start_vector` 和`second_vector`。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200630150533532.PNG?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NjIyMDA5,size_16,color_FFFFFF,t_70#pic_center)

```csharp
	......
	//将 r 减去一个车道宽度（10）
	float r = radius * (clockwise ? 1.0f : -1.0f);	
	
	Vector3 first_vector = new Vector3 ();//定义整个 arc 的第一个折线段起点
	
	if (roadLength < 750) {
		r = -r;
		first_vector = getCurvePart (startAngle, r - 10, centerX, centerY);
	} else
		first_vector = getCurvePart (startAngle, r - 10, centerX, centerY);	
	
	//these are two vectors starting and ending point of the curve
	var end_vector = new Vector3 (x, 0.01f, y);
	var start_vector = first_vector;
	float distance = 0f;//折线段总长度
	
	while (true) {
		//每次增加一点角度，使得second_vector不断向end_vector靠近。
		startAngle = startAngle + 0.05f;
		var second_vector = getCurvePart (startAngle, r - 10, centerX, centerY);
		var curve_new = new BezierCurveData ();
		
		//循环的结束条件：总长度超过弧长
		distance += Vector3.Distance (start_vector, second_vector);
				
		if (distance >= roadLength) {
			curve_new = getNewCurve (start_vector, end_vector);
			curveDatas.Add (curve_new);
			start_vector = second_vector;
			break;
		}
		curve_new = getNewCurve (start_vector, second_vector);
		curveDatas.Add (curve_new);
		start_vector = second_vector;
	}
}
```

在每次循环中，递增startAngle使得second_vector不断向end_vector靠近，这是通过`getCurvePart`函数实现的：(start_x,start_y)构成的向量和(center_x,center_y)构成的向量相加，得到我们的目标向量（所代表的的点在arc上）。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200630154424288.PNG?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NjIyMDA5,size_16,color_FFFFFF,t_70#pic_center)

```csharp
Vector3 getCurvePart(float start_angle, float r, float center_x, float center_y)
{
	float start_x = 0.0f,start_y = 0.0f;
	
	start_x = r * Mathf.Cos(start_angle);
	start_y = r * Mathf.Sin(start_angle);
	
	return new Vector3(start_x + center_x, 0.1f, start_y + center_y);
}
```

#### 2.把Bezier曲线渲染为Mesh

得到`curveData`数组后，我们遍历每一条曲线，生成一个curve游戏对象，再生成具体的Mesh，作为curve游戏对象的子物体。对于line来说，curveData数组只有一个元素，对于arc来说，有很多个元素。

```csharp
void CreateMesh()
{
	for (int i = 0; i < curveDatas.Count; i++)
	{
		if (curveMeshes.Count > i)
		{	//此函数会在Update中实时调用，已经生成对象后就直接调用对象的CreateMesh函数
			curveMeshes[i].CreateMesh();
		}
		else
		{	//首次遍历时，先创建curveMesh对象实例
			var curveMesh = BezierCurveMesh.Instantiate(i, this);
			curveMeshes.Insert(i, curveMesh);
			curveMesh.CreateMesh();
		}
	}
}
```

如果想知道具体是怎么生成的Mesh，可以参考这个开源项目：[unity-procedural-mesh-bezier-curve](https://github.com/brainfoolong/unity-procedural-mesh-bezier-curve)。本项目的这部分代码就是引用于它（也可以在本项目中直接查看相关代码，不过这部分和路网生成关系不大，就不放在这里解读了）。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200630171410666.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NjIyMDA5,size_16,color_FFFFFF,t_70#pic_center)

### 五、沿着道路随机生成建筑物

（1）准备好建筑物的prefab共15个

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200630171959655.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NjIyMDA5,size_16,color_FFFFFF,t_70#pic_center)
（2）沿着道路随机摆放建筑物

可以观察到：建筑与路面之间有一定的距离；建筑不会摆放到道路上去；建筑都朝向路面。

关于实现方法，简单来说就是要分成line和arc类型来处理。在处理每种路面的时候也要考虑线段的方向，从而确定房屋摆放的位置。这部分细节比较多，如果需要优化或者修改，可以详细看看。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200630172240562.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NjIyMDA5,size_16,color_FFFFFF,t_70#pic_center)

### 六、给道路添加程序纹理

道路模型没有按照车道区分，所以多车道其实也是一个模型。而单车道和多车道，外表是不同的。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200630174711326.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NjIyMDA5,size_16,color_FFFFFF,t_70#pic_center)
本项目对于单车道和多车道使用的是同一张图片，但是对于多车道，在其上绘制了白色的线，作为新的贴图。

```csharp
void Texture1(float x, float y, float len, float angle, float curvature, float patchWidth, int lanes,float []lane)
{
	Texture2D texture = new Texture2D((int)patchWidth, (int)len);
	
	Material m_Material;
	
	//Fetch the Renderer from the GameObject
	Renderer m_Renderer = GameObject.FindGameObjectWithTag("Road").GetComponent<Renderer>();
	m_Renderer.material = new Material(Shader.Find("Standard"));
	m_Material = m_Renderer.material;
	//Make sure to enable the Keywords
	m_Material.EnableKeyword ("_NORMALMAP");
	m_Material.EnableKeyword("_DETAIL_MULX2");
	
	m_Material.SetTexture("_MainTex", textures);
	m_Material.SetFloat ("_Metallic", 0.3f);
	m_Material.SetFloat ("_Metallic/_Smoothness", 0.0f);
	
	//【绘制白色车道线】
	int a1 = (int)lane[0];
	int j = 0,b1=0;
	for (int i= 1; i< lanes; i++) {
		int l=0;
		while(l<len){
			b1 = l+80;//每条短线长 80
			for ( j = l; j < b1; j++)		{
				Color32 color = new Color32(255,255,255,255);
				texture.SetPixel (a1, j, color);
				texture.filterMode = FilterMode.Point;				
			}			
			l=j+100; //短线间间隔 100
		}
		a1 = a1 + (int)lane[i];
	}
	
	m_Material.SetTexture("_DetailAlbedoMap", texture);
	m_Material.SetTextureScale("_MainTex", new Vector2(1, 2));
	materials = m_Material;
	texture.Apply();
}
```