- [手把手教你使用QGIS制作地图_卡尔曼和玻尔兹曼谁曼的博客-CSDN博客_qgis](https://blog.csdn.net/theonegis/article/details/105377095?ops_request_misc=%7B%22request%5Fid%22%3A%22165830726916780357270481%22%2C%22scm%22%3A%2220140713.130102334..%22%7D&request_id=165830726916780357270481&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~blog~top_positive~default-1-105377095-null-null.185^v2^control&utm_term=qgis&spm=1018.2226.3001.4450)

# 手把手教你使用[QGIS](https://so.csdn.net/so/search?q=QGIS&spm=1001.2101.3001.7020)制作地图

QGIS是一款开源免费的[地理信息系统](https://so.csdn.net/so/search?q=地理信息系统&spm=1001.2101.3001.7020)软件，虽然比不上商业的ArcGIS软件，但是QGIS免费而且跨平台，值得学习！

今天我们聊聊如何使用QGIS进行地图制作并输出。对任意一幅地图的制作下面介绍的步骤并不是都要用得到，我会分知识点进行介绍，学习一些常用地图制作技巧。

下面我们一步一步进行吧！（我是在macOS平台下进行操作的，Windows平台界面可能稍有差异）

## 加载矢量数据

打开QGIS，从文件管理面板Browser加载所要的数据，如下图所示（以陕西省为例）。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200407233758503.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1RfMjcwODA5MDE=,size_16,color_FFFFFF,t_70#pic_center)

## 加载背景底图

底图的加载我们可以有很多选择，比如使用OpenStreetMap或者谷歌地图。当然，我们也可以选择不使用底图。

下面给出加载底图的步骤：

在文件管理面板Browser的XYZ Tiles节点上右键，选择New Connection…，然后在弹出的对话框中输出Name和URL。下图给出了OpenStreetMap的添加界面。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200407233834921.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1RfMjcwODA5MDE=,size_16,color_FFFFFF,t_70#pic_center)

添加完Connection以后，直接点击添加的地图服务节点将底图添加到我们的工程。

鼠标在图层Layers面板中拖动数据层的顺序，将刚添加的底图移动到最下方的位置。如下图所示。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200407233849794.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1RfMjcwODA5MDE=,size_16,color_FFFFFF,t_70#pic_center)

此外，这里附上谷歌地图服务的地址，方便有需要的朋友使用：

**Google Maps**: https://mt1.google.com/vt/lyrs=r&x={x}&y={y}&z={z}

**Google Satellite:** http://www.google.cn/maps/vt?lyrs=s@189&gl=cn&x={x}&y={y}&z={z}

**Google Satellite Hybrid:** https://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}

**Google Terrain:** https://mt1.google.com/vt/lyrs=p&x={x}&y={y}&z={z}

**Google Roads:** https://mt1.google.com/vt/lyrs=h&x={x}&y={y}&z={z}

拿走不谢！

## 美化矢量数据

在Layers面板中选中数据层，右键选择Properties…，在弹出的对话框中选择左侧列表中的Symbology，然后设置矢量数据的填充（Fill），边线（Stroke）等。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200407233906680.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1RfMjcwODA5MDE=,size_16,color_FFFFFF,t_70#pic_center)

## 添加晕线

地图制作中有时候需要给行政边界添加晕线，制作方法很简单。思路是这样的：首先，给原始行政区做缓冲区，然后添加缓冲区到原始行政区图层下面，设置缓冲区的边线的颜色粗细。

注意：我在使用QGIS的过程中，通过菜单栏Vector->Geoprocessing Tools->Buffer…工具进行缓冲区制作的时候，发现制作的缓冲区地理坐标不对（和原始的行政区地理间隔很大），我也不找到出错的原因。

我通过菜单栏Processing->Toolbox打开QGIS工具箱，使用GDAL提供的Buffer工具，则不会出现错误，如下图（QGIS中集成了GDAL，GRASS等开源GIS工具，所以经常在处理一个任务的时候，我们有多个工具可以选择）。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200407233923878.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1RfMjcwODA5MDE=,size_16,color_FFFFFF,t_70#pic_center)

做完缓冲区之后，我们需要对缓冲区进行美化（你自己认为漂亮即可），效果如下图！

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200407233938110.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1RfMjcwODA5MDE=,size_16,color_FFFFFF,t_70#pic_center)

## 切换到排版视图

在[ArcGIS](https://so.csdn.net/so/search?q=ArcGIS&spm=1001.2101.3001.7020)中我们一般在进行地图输出的时候一般会切换到布局视图（好像是叫Layotu View，如果我没记错的话）进行地图整饰和出图。

在QGIS中也是类似的，我们需要点击工具栏的New Print Layout（我的在保存Save Project按钮旁边，我的节目自己调整过，所以可能和标准界面不一样）。这时候会出现一个新的Tab面板（对应ArcGIS的布局视图），我们在该选项卡面板中进行操作，如下图所示。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200407233955688.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1RfMjcwODA5MDE=,size_16,color_FFFFFF,t_70#pic_center)

在布局视图面板的左侧有一系列工具，我们首先点击Add Map按钮，在空白画布上拖动一个地图范围，这样我们刚才制作的地图就会显示在该画布上面。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200407234010419.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1RfMjcwODA5MDE=,size_16,color_FFFFFF,t_70#pic_center)

## 添加经纬度格网

下面我们添加经纬度格网，在该视图的右边Items选项卡中选择我们的地图对象，然后在Item Properties选项卡中，选择Grids节点进行展开，点击➕按钮添加一个Grid对象，然后点击Modify Grid按钮编辑格网的属性。

我们可以设置格网显示的坐标系，格网显示的间隔，格网显示的样式等等。根据自己的需求自由发挥吧！

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200407234023728.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1RfMjcwODA5MDE=,size_16,color_FFFFFF,t_70#pic_center)

## 添加其他修饰元素

此外，我们还可以点击面板右边的按钮添加比例尺、图例、图名、指北针等等修饰元素。这里不做详细介绍，自己慢慢探索吧！添加完以后，如下图。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200407234038811.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1RfMjcwODA5MDE=,size_16,color_FFFFFF,t_70#pic_center)

## 地图输出

最后我们要将地图输出为PDF或者图片格式进行保存，在工具栏提供了相应的按钮进行操作。

我这里想说的是在QGIS地图制作过程中如果添加了地图服务（Web-Service-Based Map），则有可能在输出保存的时候，底图的显示不太对（会有缩放），我们的矢量地图不存在问题。