- [使用uDig美化地图，并叠加显示多个图层](https://www.cnblogs.com/ssjxx98/p/12539456.html)

# 一、uDig加载数据

## 1. 启动uDig

首先启动uDig，如果使用的是安装版，直接双击快捷方式就好。如果是解压版，在文件目录下双击“udig_internal"即可。

![Snipaste_2020-03-20_19-33-40](https://s1.ax1x.com/2020/03/21/8WgXIf.png)

## 2.创建项目

新建一个Project，可以理解为Eclipse中的WorkSpace。

![Snipaste_2020-03-20_19-35-36](https://s1.ax1x.com/2020/03/21/8WgOdP.png)

## 3.新建地图

在项目名称上点右键，选择New Map，即可创建一个新的地图文档。

![Snipaste_2020-03-20_19-36-14](https://s1.ax1x.com/2020/03/21/8WgLZt.png)

## 4.添加图层

在地图名称上点击右键，选择Add...，可通过各种数据源导入数据。这里以shp为例，选择Files。

![Snipaste_2020-03-20_19-36-46](https://s1.ax1x.com/2020/03/21/8WgbqI.png)![Snipaste_2020-03-20_20-18-54](https://s1.ax1x.com/2020/03/21/8WgxJS.png)

可以看到我们的shp数据已经导入地图中了。uDig跟ArcMap操作类似，对图层单击右键，选择Zoom to layer即可缩放到图层。

![Snipaste_2020-03-20_20-19-57](https://s1.ax1x.com/2020/03/21/8WgzRg.png)

# 二、为图层定义样式，美化地图

对于每一个图层，都可以单独配置样式。图层的样式是通过SLD进行描述的。相信接触过QGIS，或者开发过GIS软件（。）的人都比较熟悉。

**SLD**是风格化图层描述器（Styled Layer Descriptor）的简称，是2005年OGC提出的一个标准，标准在一定条件下允许WMS服务器对地图可视化的表现形式进行扩展。

SLD采用XML来配置地图图层渲染的可视化风格，可以设置过滤器，自定义图例等。其中**rule**是SLD最重要的一个元素，在rule中允许根据某个给定的字段/参数（使用过滤器）对数据集进行分类，并对该分类设置样式。简单的说，一个rule就是一种分组渲染规则（例如分级设色地图中的某一中颜色）。关于SLD的具体内容，我会在另一篇博客详细说明。

## 1.配置图层样式

选择需要配置的图层，点击右键，Change Style（这里以面要素为例）

![8](https://s1.ax1x.com/2020/03/21/8W2SzQ.png)

在Style Editor界面可以对点线面的样式进行配置。这里打开的是面要素的Style  Editor，因此不能选择左边的Lines和Points，嗯这很合理，对点、线要素同理。Theme中可以根据属性字段进行分级/分类渲染（此时每一个级别/类别就对应了一个rule），相当于ArcMap中对图层的Symbology进行设置。

关于样式的具体配置方法，几乎都与ArcMap类似，在这里不做过多介绍。配置一个你觉得好看的地图就好啦！

![Snipaste_2020-03-21_10-29-30](https://s1.ax1x.com/2020/03/21/8W2Css.png)![Snipaste_2020-03-21_10-34-09](https://s1.ax1x.com/2020/03/21/8W2PLn.png)

值得一提的是：

如果想要在图中显示注记，有两种方式：

​	(1)第一种方式如下图，对每一个rule分别配置Labels，可以实现每一种rule有不同样式的注记。如果shp数据含有中文，一定要注意选择中文字体，并更改字符的编码方式为GB2312或GBK，否则会出现乱码。

![Snipaste_2020-03-21_11-32-31](https://s1.ax1x.com/2020/03/21/8W2FZq.png)

​	(2)第二种方式在Simple Featrue里面设置Label，设置方法同理，此时的注记应用于整个图层而非某一个rule。同样要注意中文的问题。

![Snipaste_2020-03-21_09-51-20](https://s1.ax1x.com/2020/03/21/8W2kd0.png)

## 2.导出SLD

在Style Editor中选择XML选项卡，可以看到图层样式的SLD。如果数据有中文，需要将

```
encoding="UTF-8"
```

改成

```
encoding="GBK"`或`encoding="GB2312"
```

左下角export可以导出SLD文件，但为了避免不必要的编码问题，这里建议直接复制文本框中的XML文档内容。

![13](https://s1.ax1x.com/2020/03/21/8W2AoV.png)

# 三、添加Style到GeoServer

打开GeoServer页面，选择数据的Styles，然后选择Add a new style

![14](https://s1.ax1x.com/2020/03/21/8W2ZJU.png)

在接下来出现的页面中设置Style的各项参数。将复制的SLD内容粘贴到下方的文本框，或者使用图中导入SLD文件并上传的方法（不推荐）。然后保存Style即可。

![15](https://s1.ax1x.com/2020/03/21/8W2eWF.png)

然后再数据的图层中，找到我们创建的Style所对应的图层，点击图层名称。

![Snipaste_2020-03-21_10-51-47](https://s1.ax1x.com/2020/03/21/8W2uQJ.png)

在”发布“选项中找到WMS Settings，修改默认Style为我们新建的Style即可。

![Snipaste_2020-03-21_10-52-21](https://s1.ax1x.com/2020/03/21/8W2Ky9.png)![18](https://s1.ax1x.com/2020/03/21/8W2MLR.png)

在Layer Preview预览图层，可以看到，该图层已经具有我们配置好的样式了。

![19](https://s1.ax1x.com/2020/03/21/8W2le1.png)

**注意：**如果在预览时无法显示地图，或者出现中文字符乱码，可能是由于数据源的编码方式和SLD的编码方式不一致导致，具体处理方法，参考另一篇博客：[GeoServer style中文乱码解决方法](https://editor.csdn.net/md/?articleId=105010076)

# 四、叠加显示多个图层

在GeoServer中发布的图层，通过Layer Preview查看，只能看到当个图层效果。但我们的地图往往是多个图层叠加的结果。想要查看叠加后的结果，有两种方法：

## 1.修改请求参数

在浏览器地址栏可以看到Layer Preview预览图层效果的URL是：

http://localhost:8080/geoserver/xjs/wms?service=WMS&version=1.1.0&request=GetMap&layers=xjs%3ABoundaryChn2_4p&bbox=73.44696044921875%2C6.318641185760498%2C135.08583068847656%2C53.557926177978516&width=768&height=588&srs=EPSG%3A4326&format=application/openlayers

其中，请求参数的layers=xjs%3ABoundaryChn2_4p定义了当前访问的图层名

（这里的%3A是指十六进制3A所对应的ASCII字符，即 " :  ",也就是说图层名为xjs：BoundaryChn2_4p）

因此，对于多个图层的叠加显示，只需要在layers参数中使用" , "将多个图层名分隔开即可。

例如：layers=xjs%3ABoundaryChn2_4p,xjs%3ABoundaryChn1_4l,xjs%3ABoundaryChn2_4l

![20](https://s1.ax1x.com/2020/03/21/8W21dx.png)

## 2.创建图层组

将已发布的m多个图层创建为一个图层组，在Layer Preview预览时即可作为一个目标进行预览，这样也能实现图层的叠加显示。

具体操作如下：

![21](https://img-blog.csdnimg.cn/20200321140559578.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2RmMTQ0NQ==,size_16,color_FFFFFF,t_70)![img](https://img-blog.csdnimg.cn/20200321140632784.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2RmMTQ0NQ==,size_16,color_FFFFFF,t_70)![img](https://img-blog.csdnimg.cn/202003211407107.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2RmMTQ0NQ==,size_16,color_FFFFFF,t_70)

创建完毕后即可在Layer Preview中对该图层组进行预览

![img](https://img-blog.csdnimg.cn/20200321140735952.png)![25](https://img-blog.csdnimg.cn/20200321140759410.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2RmMTQ0NQ==,size_16,color_FFFFFF,t_70)

------

**写在最后**：uDig是一个开源桌面GIS软件，使用它美化地图并发布到GeoServer的实质是利用SLD规范对WMS服务进行扩展。因此，配置图层样式Style的方式不一定拘泥于uDig一种。我们常用的ArcMap其实也能够配置Style，只是他配好的图层样式并不保存在shp中，而是保存在mxd或者msd文件中。因为ArcGIS是一个商业软件，不能直接输出sld文件。我们可以试用一些插件将mxd文件转成sld，这里可以给大家分享一个：

链接：https://pan.baidu.com/s/1hvnQBhEGBp2oPk-cOYttaQ

提取码：5l1f

当然，QGIS等开源软件也支持直接导出SLD文件。