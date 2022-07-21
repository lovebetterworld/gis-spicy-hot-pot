- [使用QGIS制作专题地图——上海市游泳馆分布地图_孤独世界的黄桃的博客-CSDN博客_qgis专题地图绘制](https://blog.csdn.net/jasmin0426/article/details/120523735)

## **使用QGIS制作专题地图——上海市游泳馆分布地图**

**下载POI数据与行政区划分数据**

在制作游泳馆分布地图前，我们需要收集上海市内游泳馆的POI数据以及上海市行政区划分数据。这些都可以在规划云（http://www.guihuayun.com）网站中获取。


![将获取的数据复制到excel内后，按照csv格式存储](https://img-blog.csdnimg.cn/5814f5ff726446a5a28a595189227536.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5a2k54us5LiW55WM55qE6buE5qGD,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)

> 将获取的数据复制到excel内后，按照csv格式存储

![选用DataV获取上海市的行政区域规划，下载json文件](https://img-blog.csdnimg.cn/a7943228637c4af0810973cc7889f1b5.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5a2k54us5LiW55WM55qE6buE5qGD,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)

> 选用DataV获取上海市的行政区域规划，下载json文件

**加载矢量数据**

打开[QGIS](https://so.csdn.net/so/search?q=QGIS&spm=1001.2101.3001.7020)，点击左上角新建工程。首先选择ESRI Gary(light)的地图。


![在这里插入图片描述](https://img-blog.csdnimg.cn/3c90e18ddf5b43eeae5ca73c508679f9.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5a2k54us5LiW55WM55qE6buE5qGD,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)


这样会获得一张浅灰色的世界地图，接着把刚才下载的上海市行政规划地图拖入下方图层中。

![在这里插入图片描述](https://img-blog.csdnimg.cn/24f669b8f2554abda30302a0b937955b.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5a2k54us5LiW55WM55qE6buE5qGD,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)



![在这里插入图片描述](https://img-blog.csdnimg.cn/a125ba13d4f34a94a8d5a84275a3c2cc.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5a2k54us5LiW55WM55qE6buE5qGD,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)

接下来添加POI数据。点击添加图层中的添加分隔文本图层。


![在这里插入图片描述](https://img-blog.csdnimg.cn/6fbdfa9c38304a51a897fd040c4a5c09.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5a2k54us5LiW55WM55qE6buE5qGD,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)

设置中找到csv文件，选择点坐标，并设置x、y字段为lng和lat，点击添加。这样我们就得到了代表上海市游泳馆的坐标点。双击图层可以对点的样式进行设置。

![在这里插入图片描述](https://img-blog.csdnimg.cn/4a33dbae82414780bdf3a696b5a133ec.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5a2k54us5LiW55WM55qE6buE5qGD,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)

**转换WGS坐标**

我们下载的POI数据来自百度地图，但为了信息安全这些坐标有一定的偏移。所以我们要利用制图中的GeoHey工具中的BD09 to WGS来得到真实的坐标数据。


![在这里插入图片描述](https://img-blog.csdnimg.cn/79cbbb899f6b4ed999b8e1c21b01f2f9.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5a2k54us5LiW55WM55qE6buE5qGD,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)


分别对上海市地图和游泳馆POI数据图层进行转换。

![在这里插入图片描述](https://img-blog.csdnimg.cn/8836df3ce8ad425c881504b57f10c0ae.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5a2k54us5LiW55WM55qE6buE5qGD,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)

全部转换之后，将原始图层前面的对勾取消就可以显示准确的地图了。

**地图数据的矢量分析与可视化**

到现在为止，地图数据已经全部加载完成了。接下来要对这张地图进行分析，才能突出“专题地图”的特点。这里选择矢量分析中的统计点在多边形中的数量。

![在这里插入图片描述](https://img-blog.csdnimg.cn/c9f313b7ed8244bc95a4cf6989c94bd2.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5a2k54us5LiW55WM55qE6buE5qGD,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)


![在这里插入图片描述](https://img-blog.csdnimg.cn/76b24bce89cb405384802f9fb19968cb.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5a2k54us5LiW55WM55qE6buE5qGD,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)

点击运行之后会出现一个计数图层。在可视化中我们一般通过颜色的变化来呈现数据量的变化，这里软件提供了很多种颜色组合，但是我认为同一种颜色由浅到深的渐变比起多种颜色的组合可以更直观地体现出数量的不同。所以这里我选择了白色到深紫色的渐变。

![在这里插入图片描述](https://img-blog.csdnimg.cn/7b239f6447be45e5ae6c860d6a28a450.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5a2k54us5LiW55WM55qE6buE5qGD,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)


只统计总数总归有点单调，所以我们要转过头去对游泳馆的POI数据图层的坐标点进行一些美化。这里我选择了热力图，调整好颜色之后点击运行。

![在这里插入图片描述](https://img-blog.csdnimg.cn/d4c3894b8cc44041aa8a1bdbfe4b53b3.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5a2k54us5LiW55WM55qE6buE5qGD,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)

![在这里插入图片描述](https://img-blog.csdnimg.cn/7c35c41ce72f4610aebc887e94c0e513.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5a2k54us5LiW55WM55qE6buE5qGD,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)

**在画布上制作完整的专题地图**

刚才我们得到了一张可以传达出一些数据的地图。但是一张合格的专题地图除了地图本身，还要有标题、比例尺、指北针、图例等信息。
点击新建打印布局，可以新建一张画布。注意，这个地方要把地图放大到合适的位置，因为这时画面的显示比例就是一会儿添加地图中显示的画面比例。如果要整个上海市正好位于画面正中间，就要在创建布局之前调整好。

![在这里插入图片描述](https://img-blog.csdnimg.cn/447db8698c7e432cbb2330c195891825.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5a2k54us5LiW55WM55qE6buE5qGD,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)

点击添加地图，可以自定义一个地图边框。


![在这里插入图片描述](https://img-blog.csdnimg.cn/ff838242d1e5492c8b5d3705222384ca.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5a2k54us5LiW55WM55qE6buE5qGD,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)


因为还要添加其他信息，所以把地图放在左下角。


![这个地方我放太大了崇明没有显示进去，后面重新做了一遍](https://img-blog.csdnimg.cn/fa5c12eba89f4bf79378d52c637ba931.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5a2k54us5LiW55WM55qE6buE5qGD,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)

> 这个地方我放太大了崇明没有显示进去，后面重新做了一遍

点击左边一列的比例尺标志就可以添加比例尺，单位可以在右边修改。


![在这里插入图片描述](https://img-blog.csdnimg.cn/8f39ea8ef2d0429ba46c41f91ccefa98.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5a2k54us5LiW55WM55qE6buE5qGD,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)


点击左边一列的指北针标志，就可以添加指北针了。

![在这里插入图片描述](https://img-blog.csdnimg.cn/a4cc400e71c742edb2237a03dd74d922.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5a2k54us5LiW55WM55qE6buE5qGD,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)


之后就是添加图例，同样的操作，在左边一列选择图例。右侧的项属性中取消勾选自动更新，可以删除不需要的图层文字。

![在这里插入图片描述](https://img-blog.csdnimg.cn/1a03f0d149544d879a9b5fe4daf2cf6e.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5a2k54us5LiW55WM55qE6buE5qGD,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)


![删除多余图层之后就是这样](https://img-blog.csdnimg.cn/ba8fa7ad0b10463090fa25c25b177b2e.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5a2k54us5LiW55WM55qE6buE5qGD,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)

> 删除多余图层之后就是这样
> 最后，还是像刚才一样选择文字工具，在画布的正上方写上专题地图的标题。在右边的项属性中可以修改字体、颜色和大小。

![在这里插入图片描述](https://img-blog.csdnimg.cn/99fc4a27f4b44f48826f931654bdf3c3.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5a2k54us5LiW55WM55qE6buE5qGD,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)

一切调整完毕之后，导出为图像。

![在这里插入图片描述](https://img-blog.csdnimg.cn/e031f1d612874471a4dde58ee0327d37.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5a2k54us5LiW55WM55qE6buE5qGD,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)

一张完整的体育专题地图就制作好了。

![在这里插入图片描述](https://img-blog.csdnimg.cn/93aa46de2ee5446d977cafb1c7274ad0.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5a2k54us5LiW55WM55qE6buE5qGD,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)