- [QGIS设置点图层样式并导出SLD文件_制图小韩的博客-CSDN博客_qgis 导出sld](https://blog.csdn.net/han_jinlin/article/details/123295882?spm=1001.2101.3001.6650.14&utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromBaidu~default-14-123295882-blog-99827530.pc_relevant_sortByStrongTime&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromBaidu~default-14-123295882-blog-99827530.pc_relevant_sortByStrongTime&utm_relevant_index=17)

这篇文章中，主要记录在QGIS中进行点符号的简单设置，各种符号类型的说明，以及导出SLD文件供GeoServer使用。

# 1、[QGIS](https://so.csdn.net/so/search?q=QGIS&spm=1001.2101.3001.7020) 点符号设置

QGIS中图层符号的设置在“图层属性 - 符号化”，默认渲染方式为单一符号 - 简单标记

![在这里插入图片描述](https://img-blog.csdnimg.cn/08bf98627b854b72aba5484d2a2514f3.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5Yi25Zu-5bCP6Z-p,size_20,color_FFFFFF,t_70,g_se,x_16)

- 点击“单一符号”，可选择其他渲染方式，包括分类、渐进、基于规则、点的位移，点聚类、[热力图](https://so.csdn.net/so/search?q=热力图&spm=1001.2101.3001.7020)等
  \- 单一符号：图层所有数据使用同一种符号渲染
  \- 分类：按照某一字段属性可分类设置符号

![在这里插入图片描述](https://img-blog.csdnimg.cn/61eacc3daf394feaa91e3989818cba7b.png)

- 分类符号化的设置：

![在这里插入图片描述](https://img-blog.csdnimg.cn/1b4639e4cce04a8a87dbc51d036b53e2.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5Yi25Zu-5bCP6Z-p,size_20,color_FFFFFF,t_70,g_se,x_16)

- 选择图层的渲染方式之后，可选择标记的类型，也就是点符号的类型

![在这里插入图片描述](https://img-blog.csdnimg.cn/cfeae6e31d4c442a985495296989b75a.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5Yi25Zu-5bCP6Z-p,size_20,color_FFFFFF,t_70,g_se,x_16)

- 椭圆标记：看起来跟简单标记差不多，还没明白为啥要有这一项设置
- 实心标记：可以进行填充设置的几种几何样式
- 文字符号标记：字体符号库，如果有现成的，直接就可以用
- 几何图形生产器：使用表达式绘制几何
- 掩膜：还没明白…
- 栅格图像标记：jpg、png各种图像格式的符号，这里SVG也可以
- 简单标记：包括圆形，星形和正方形等几何样式
- SVG标记：有一些默认的SVG符号，默认的SVG可以修改颜色
- 矢量字段标记：可自定义的矢量场可视化工具，看着有点像向量绘制

# 2、导出SLD文件

图层符号设置完成之后，可以将符号化样式导出为SLD文件，之后就可以在GeoServer中使用。在QGIS中有两种方式都可以打开SLD文件导出页面：

- 第一种是在“图层属性 - 符号化 - 样式 - 保存样式”
- 第二种是直接在图层右键 - 导出 - 另存为QGIS图层样式文件

![在这里插入图片描述](https://img-blog.csdnimg.cn/406a33d1bccc46b9bb39f6da2029b7c0.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5Yi25Zu-5bCP6Z-p,size_20,color_FFFFFF,t_70,g_se,x_16)

打开之后，选择“保存为SLD格式样式文件”，下边的类别在默认的QGIS样式中可以修改，SLD不能修改，点击OK导出即可。生成的SLD文件就可以拿去供GeoServer使用。

![在这里插入图片描述](https://img-blog.csdnimg.cn/be69412fd7d14fc38d2bc6b8ab72b345.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5Yi25Zu-5bCP6Z-p,size_16,color_FFFFFF,t_70,g_se,x_16)