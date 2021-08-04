MapGuide是美国Autodesk公司生产的WebGIS平台，Autodesk  MapGuide是Autodesk公司为满足GIS用户数据发布需要，开发的Internet网络图形数据发布产品。它是世界上第一个通过Internet和Intranet发布实时的、内容丰富而详实的地图和地理数据的交互式解决方案。其主要特点为：利用WWW浏览器交互式操作，真正的矢量地图传输数据库的动态相关。该软件可以帮助用户在Internet和Intranet上开发、管理以及分发GIS和设计应用程序，拓宽了对关键的地理空间和数字设计数据的访问。 	——百度百科

# MapGuide结构介绍

MapGuide软件由创作器(MapGuide Author)，浏览器(MapGuide Viewer)，服务器(MapGuide Server)，Web服务器（MapGuide Web Extension）四个核心软件部件组成。

这几个部分都不是指具体的软件，而是一种MapGuide体系的一部分。比如，浏览器（Viewer）、服务器（Server）部分、Web服务器（Web Extension）在2.1版本后被集成到一起安装，有商业版**MapGuide Enterprise**和开源免费的**MapGuide Open Source**。创作器Author部分有收费的商业软件**MapGuide Studio**和开源的软件**MapGuide Maestro**，其中也会集成浏览器（Viewer），方便用户在客户端预览。

> ● **MapGuide Server**
>
> 用于与空间数据直接交互，并处理MapGuide Web Extension发出的请求，MapGuide Server支持Windows和Linux平台。
>
> ● **MapGuide Web Extension**
>
> 也称为Web Server，是网络结构的中间层，用于转发IIS (Internet Information Service)  的请求，并向MapGuide服务器发出相应的请求。MapGuide Web Extension支持IIS和Apache (Windows平台)  或Apache (Windows 和Linux平台)，它提供一系列完整的API，可以用这些API进行定制开发。MapGuide Web  Extension支持三种语言的开发，分别是PHP、ASP和JSP。
>
> ● **MapGuide Studio/Maestro  （Author）**
>
> 是用于地图管理的工具，为了用户方便，内部集成了浏览器。用户可以用 MapGuide Studio进行所见即所得的便捷管理，MapGuide Studio只能安装在Windows平台。而Meastro是Autodesk MapGuide  Studio的替代产品，它完全由C#语言编写，包含了一个用户界面，而且还提供了一系列的API。
>  Author部分的软件完全基于Http协议，可以实现对本地或者远程服务器上运行的MapGuide服务器上的资源进行编辑。
>
> 需要注意的是，Studio/Maestro只是地图编辑工具，而不是地图数据的创建工具，我们不能用它来画河流、湖泊等地理要素。它的主要功能是帮助你组织数据源、设置图层样式等属性、构建地图和网页布局，以供MapGuide Web应用程序使用。
>
> ● **MapGuide Viewer**
>
> 用于在浏览器中对地图进行浏览，编辑等，它提供两种Viewer, DWF Viewer和AJAX Viewer，由于DWF  Viewer是Active控件，所以它只支持Microsoft IE（Internet Explorer），AJAX Viewer支持Fire  fox, Opera (Mac) 等浏览器。



# 二、系列文章

[MapGuide安装](https://www.cnblogs.com/giser-s/archive/2013/03/19/2969038.html)

[MapGuide应用开发系列（一）----MapGuide的开源地图编辑（Authoring Tool）工具Meastro介绍](https://www.cnblogs.com/junqilian/archive/2009/10/16/1584771.html)

[MapGuide应用开发系列（二）----MapGuide Open Source 2.1 的安装](https://www.cnblogs.com/junqilian/archive/2009/10/17/1585144.html)

[MapGuide应用开发系列（三）----MapGuide 数据包管理及Maestro亮点功能介绍](https://www.cnblogs.com/junqilian/archive/2009/10/18/1585483.html)

[MapGuide Open Source v2.2 快速安装学习指南](https://www.cnblogs.com/junqilian/archive/2011/04/14/2015771.html)

[Mapguide配置心得](https://blog.csdn.net/cloudkurten/article/details/4104821)

[MapGuide和Openlayers开发](http://www.doc88.com/p-0406419464286.html)

[MapGuide应用程序示例——你好，MapGuide！](https://blog.csdn.net/mapguide_inside/article/details/5103745)

[mapguide 使用MapGuide Open Source2.1 & Maestro快速搭建一个基本的WebGIS](http://www.manew.com/blog-166430-28870.html)

[MapGuide open source开发系列教程四: 体系结构（转贴）](https://blog.csdn.net/weixin_30242907/article/details/96268313)

[MapGuide open source开发心得一：简介](https://blog.csdn.net/weixin_34087503/article/details/86050029)

[MapGuide Open Source安装、配置以及MapGuide Maestro发布地图——超详细！目前最保姆级的MapGuide上手指南！](https://www.cnblogs.com/ssjxx98/p/12620481.html)