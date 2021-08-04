# 一、uDig –用户友好的桌面Internet GIS

uDig（用户友好型桌面Internet GIS）**是由Refractions Research开发的。Refractions不仅是uDig的开发者和维护者，而且还是标准的开源空间数据库PostGIS的开发者和维护者。



基于 Eclipse RCP 的 uDig 开源项目既是一个 GeoSpatial 应用程序也是一个平台开发者可通过这个平台来创建新的在 uDig 基础上衍生的应用程序，uDig 是 Web 地理信息系统的一个核心组件。

UDIG是一个开源的、基于Java的桌面GIS应用程序，它也是一个开源的GIS开发平台。



uDiG首字母缩略词的含义如下：

- **u** 代表 **user-friendly** 界面
- **D** 代表 **桌面** （Windows、Mac或Linux）。你可以在Mac上运行udig
- **I** 代表 **互联网** 定向消费标准（WMS、WFS或WPS）
- **G** 代表 **GIS** -具备复杂的分析能力

除此之外，该应用程序还可以在Windows、Linux、Mac OS上运行。

[ ![UDig GIS Software](https://www.osgeo.cn/static/blog_html/gisgeography_html/_images/UDig-User-Interface-425x226.png) ](https://www.osgeo.cn/wp-content/uploads/2016/06/UDig-User-Interface.png)



# 二、下载uDig

可以从[uDig官网下载](http://udig.refractions.net/download/)，可以看到，对于Windows平台，1.5.0.RC1版本可以选择安装版和解压版，2.0.0只有解压版提供下载。这里选择2.0.0版本的解压版就好。

![1](https://s1.ax1x.com/2020/03/21/8Wgvi8.png)

uDig界面是英语，可以用插件进行汉化，但我觉得没必要。如果的确有需要，参考：

https://jingyan.baidu.com/article/fc07f989bc2ec412ffe51904.html

从uDig的介绍可以看出，这是一个基于Java和Eclipse的开源桌面GIS软件。因此，想要使用uDig必须先安装Java，在前几篇文章里也提到过，具体方法在这里就不多说了。

而Eclipse相信Java开发者都不陌生，它是一个开源的、基于Java的可扩展开发平台。就其本身而言，它只是一个框架和一组服务，用于通过插件组件构建开发环境。尽管我们大多都将它当作一个集成开发环境（IDE）来使用，但Eclipse 的目标却不仅限于此。Eclipse 还包括插件开发环境（Plug-in Development  Environment，PDE）。其核心功能（Eclipse RCP）提供了标准化的组件模型，包括菜单，工具栏等，也使得基于 Java  开发桌面应用也变得容易了很多。

尽管uDig是基于Eclipse RCP开发的，但当我们仅仅使用它进行**地图美化**时，并**不需要安装并搭建eclipse的开发环境**。

当然，如果你需要通过uDig绘制地图符号，进行复制编辑等操作时（就像我们在ArcGIS的ArcMap上做的那样），则似乎需要搭建开发环境。至于开发环境如何搭建，可以参考如下两篇博客：

[Udig开发环境搭建/入门教程](https://blog.csdn.net/MOLLMY/article/details/51779618)

[udig-1.4.0 开发环境搭建](https://blog.csdn.net/philosophyatmath/article/details/37909299)