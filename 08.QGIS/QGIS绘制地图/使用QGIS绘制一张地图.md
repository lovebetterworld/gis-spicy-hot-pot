- [如何使用QGIS绘制一张地图 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/66504876)

## 在线地图加载

QGIS可以借助在线地图插件很方便的实现在线地图的加载。

Plugins-Manage and Install Plugins

![img](https://pic1.zhimg.com/80/v2-2c742f6ec87dfa639536bf91e4fc14a4_720w.jpg)

安装HCMGIS插件

![img](https://pic3.zhimg.com/80/v2-a1d3b1ee2c3ce2a2c3fbbb7cb70cd6ee_720w.jpg)

插件安装完成后，菜单栏中就会出现新的HCMGIS菜单，从HCMGIS菜单中添加底图（BaseMap），选择Esri Imagery和Esri Boundaries and Places，这样即可引用ESRI的影像在线地图和地名标注。

![img](https://pic4.zhimg.com/80/v2-ae3f0594487238040699399f6ecf15f7_720w.jpg)

## 新建地图模版

在ArcGIS中，可以直接切换输出视图（Layout View）实现地图的排版输出，QGIS中稍微复杂一些，不能直接切换排版视图。

首先新建一个打印输出模版，New Print Layout

在这里我给它命名为“A3影像地图”

![img](https://pic1.zhimg.com/80/v2-b05d51800cf971373c1cd26fe3bade40_720w.jpg)

调整页面设置，在空白处右击，页面属性（Page Properties）即可打开页面属性模版，大小（Size）设置为A3，朝向设置为竖向（Portrait）

![img](https://pic1.zhimg.com/80/v2-005822f81fcad79a986cedb318dc6864_720w.jpg)

## 添加数据和要素

地图页面设置完成后，即可添加数据和要素。首先插入地图

Add Item-Add Map

![img](https://pic1.zhimg.com/80/v2-a011c838854facb4b3735fc543cf21cc_720w.jpg)

点击添加地图菜单后，需要在页面中绘制一个框子，在框中显示地图。

![img](https://pic3.zhimg.com/80/v2-699c54b3a9556f3b0e09e7186f3f909e_720w.jpg)

使用左侧Move Item Content工具调整显示内容位置，如图，把团结湖公园放在正中，使用右侧Scale比例尺设置为2000，合适的大小。

![img](https://pic3.zhimg.com/80/v2-0227504b5a3ac68dfbb0f24d871e80de_720w.jpg)

添加地图格网

点击下图绿色加号，添加格网，点击Modify Grid，对格网进行修改

在这里我设置了十字形（Cross）格网，格网间距（Interval）XY均为100米。

![img](https://pic2.zhimg.com/80/v2-6799573c5d212d7195921a34f4551fc5_720w.jpg)

在格网设置页面添加坐标信息，将地图坐标标注于地图外框。

![img](https://pic1.zhimg.com/80/v2-e92bbe7a51df2a23b5120f0d11b80ea8_720w.jpg)



添加比例尺：

![img](https://pic4.zhimg.com/80/v2-a96e4903beee785e5398bf5555e799fb_720w.jpg)

添加指北针

QGIS没有直接的添加指北针命令，需要手动制作指北针。

首先在图片处理软件如Photoshop中绘制一个指北针，存储为PNG格式，这样能够保证非图形部分为透明。

然后如下图所示：

1在QGIS中添加图片

2绘制图片范围，也就是指北针的放置区域

3选择指北针PNG图片文件

4设置图片旋转，Sync with map，和地图方向一致

这样即可完成指北针的制作。

![img](https://pic1.zhimg.com/80/v2-f25167911fc3ed4b167cdbc1156a461c_720w.jpg)

## 地图输出

由于采用的是在线底图，分辨率设置过高的情况下会出现数据无法显示的情况

在这里，调成200DPI即可，能够正确显示，存储为PDF或者TIFF格式

![img](https://pic4.zhimg.com/80/v2-0f7ac7e68b4fa46c41192577445c86ab_720w.jpg)