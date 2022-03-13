- [OpenDrive地图格式解析——案例分析_comeo_outh的博客-CSDN博客_opendrive 示例](https://blog.csdn.net/comeo_outh/article/details/121690868?ops_request_misc=%7B%22request%5Fid%22%3A%22164718010616781683937166%22%2C%22scm%22%3A%2220140713.130102334.pc%5Fblog.%22%7D&request_id=164718010616781683937166&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~blog~first_rank_ecpm_v1~rank_v31_ecpm-27-121690868.nonecase&utm_term=OpenDrive&spm=1018.2226.3001.4450)

# 基本介绍

opendrive是一种高[精度](https://so.csdn.net/so/search?q=精度&spm=1001.2101.3001.7020)地图的规范格式，也就是说在制作地图时按官网给的方式写入地图数据，就是一张opendrive格式的高精度地图了。

opendrive可以导入许多仿真软件中，比如说preScan、VTD、Sumo等等，前两者要求都是1.4版本的opendrive地图，Sumo有转换工具。

官方教程里给的示例在网站上搜不到，这里分析自己写的一个1.4版本下的.xodr文件小例子，便于大家理解。

示例中缺少数值，可以按自己的道路要求填写数值，建议对照1.4版本的教程来看，不同版本具有一定差异。

```xml
<?xml version="1.40" encoding="utf-8"?>
```

首先是版本声明和编码，这里声明了为1.4版本。

# [header](https://so.csdn.net/so/search?q=header&spm=1001.2101.3001.7020)

```xml
<OpenDRIVE>
	<header date="2021-11-30T09:31:32.641336" revMajor="1" revMinor="4" name="1" version="1.4"></header>
	...
</OpenDRIVE>
```

总体部分需要在OpenDRIVE节点下。首先是header头声明，介绍了一些基本属性，可以对照教程了解属性信息。

# 道路

```xml
<OpenDRIVE>
	<header date="2021-11-30T09:31:32.641336" revMajor="1" revMinor="4" name="1" version="1.4"></header>
    <road name="1" length="2860.018" id="1" junction="-1">
...
    </road>
</OpenDRIVE>
```

新增了道路节点，为必要节点，有几条道路就写几条这样的节点。道路中声明了道路名、道路总长、道路id、交叉口编号，如果这条道路为交叉口的其中一条，则junction等于交叉口id，若不连入交叉口则为-1.

# 道路类型

```xml
  <type>
       <speed max=" " unit="m/s"/>
  </type>
  <planView>
			<geometry s="0.0"  x=" "  y=" " hdg=" " length=" ">
				<line/>
			</geometry>
			<geometry s=""  x=" " y=" " hdg="" length="">
				<arc curvature=" "/>
			</geometry>
  </planView>
```

道路节点内包含了type节点，非必要，定义了道路的类型，内含限速等等子节点。

其次是planView参考线节点，必要节点，参考线由多个直线、螺旋线、曲线或其他复杂线形组成，geometry中s表示该线形起点的里程，x、y是坐标、hdg是航向角，表示和x坐标间的角度，逆时针为正、顺时针为负，以弧度表示。

曲线中包含了曲率curvature，为半径的倒数；螺旋线中以起点曲率和终点曲率表示。

# 道路高程

```xml
...
 <elevationProfile>
       <elevation s="0" a=" " b="-0.003" c="0.0000000000000000e+00" d="0.0000000000000000e+00"/>
       <elevation s="45" a=" " b="-0.003" c="0.0000000000000000e+00" d="0.0000000000000000e+00"/>
 </elevationProfile>
 <lateralProfile>
       <shape  s="0.0000000000000000e+00" t="-20.0000000000000000e+00"  a=" " b=""c="0.0000000000000000e+00"d="0.0000000000000000e+00"/>
       <shape  s="0.0000000000000000e+00" t="-15.0000000000000000e+00"  a="" b="" c="0.0000000000000000e+00" d="0.0000000000000000e+00"/>
       <shape  s="0.0000000000000000e+00" t="-1.5000000000000000e+00" a=""   b="" c="0.0000000000000000e+00"d="0.0000000000000000e+00"/>
       ...
       <shape  s="0.0000000000000000e+00" t="15.0000000000000000e+00"a=" " b="0.03" c="0.0000000000000000e+00"d="0.0000000000000000e+00"/>
</lateralProfile>
...
```

再是高程节点elevationProfile，高程的每一次变化都记录在一个elevation节点中。

道路中的路拱横坡常用lateralProfile下的shape表示。从道路右边按t往左推进。

# 车道

```xml
...
<lanes>
	<laneSection s="0">
		<left>
				   <lane id="3" type="driving" level="false" >
						  <width sOffset="0.0000000000000000e+00" a="3.75" b="0" c="0" d="0"/>
                          <roadMark sOffset="0.0000000000000000e+00" type="broken" weight="standard" color="standard" width="0.15"/>	
					</lane>
					<lane id="2" type="median" level="false" >        
					     <width sOffset="0.0000000000000000e+00" a="0.5" b="0"  c="0" d="0"/>
                         <roadMark sOffset="0.0000000000000000e+00" type="solid" weight="standard" color="standard" width="0.2"/>
					</lane>
					<lane id="1" type="median" level="false" >
                         <width sOffset="0.0000000000000000e+00" a="1" b="0"  c="0" d="0"/> 
                         <roadMark sOffset="0.0000000000000000e+00" type="grass" weight="standard" color="standard" width="0.2"/>
					</lane>
		</left>
		<center>
					<lane id="0" type="driving" level="false">
					</lane>
		</center>
		<right>
					<lane id="-1" type="median" level="false" >
						  <width sOffset="0.0000000000000000e+00" a="1" b="0"  c="0" d="0"/
						  <roadMark sOffset="0.0000000000000000e+00" type="grass" weight="standard" color="standard" width="0.2"/>                                                      
                     </lane>
					<lane id="-2" type="median" level="false" >
						  <width sOffset="0.0000000000000000e+00" a="0.5" b="0"  c="0" d="0"/>                                                                    <roadMark sOffset="0.0000000000000000e+00" type="solid" weight="standard" color="standard" width="0.2"/>
					</lane>
					<lane id="-3" type="driving" level="false">
					 	  <width sOffset="0.0000000000000000e+00" a="3.75" b="0"  c="0" d="0"/>	
					 	  <roadMark sOffset="0.0000000000000000e+00" type="broken" weight="standard" color="standard" width="0.15"/>
					</lane>
		</right>
	</laneSection>
</lanes>
		...
```

road中必要的lanes车道节点，车道中可以根据车道数量变化等分为多个车道段，以s里程为分段根据，每个车道段中有左、中、右节点，中间车道不能缺少，且id必须为0，左车道id均为正，且按从大到小编写，右车道id均为负，从大到小编写，车道中宽度节点 sOffset是宽度开始定义的节点，如果宽度有变化，可以有多个宽度节点， sOffset代表宽度开始变化的里程。

车道的roadMark节点表示车道标识，type代表类型，基本的有solid、broken、solid-solid等等，roadMark内部还可以定义线形。

由以上节点可以构成一个基本的opendrive地图，上述例子为一条道路的表示，多条道路间还有连接关系需要表示，例如link节点。

除此之外还有object节点，为道路上的物体，如停车位等，还有signal节点，为道路上的标志、信号等。

若在交叉口，则还有一个junction节点。