- [QGIS添加自定义点状符号库_最帅的GISer的博客-CSDN博客_qgis自定义符号](https://blog.csdn.net/qq_43391694/article/details/113634025)

**主要思路：**利用AI制图软件制作符号并导出为.[SVG](https://so.csdn.net/so/search?q=SVG&spm=1001.2101.3001.7020)格式，之后将SVG格式导入QGIS中使用

**1.在AI中制作符号**

以绘制点状符号“井”为例，绘制宽0.1mm，长0.5mm的井符号，绘制过程此处不做叙述，具体绘制结果及绘制属性如图所示。

![img](https://img-blog.csdnimg.cn/20210204115122127.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQzMzkxNjk0,size_16,color_FFFFFF,t_70)

**2.调整画板**

此处往往是大多数人符号制作失败的原因，改正方法为将画板大小调整为与符号等大的画板，如前图所示。具体设置方法为：【文件】|【文档设置】|【编辑画板】，之后手工修改画板大小即可，修改界面如图所示。

![img](https://img-blog.csdnimg.cn/20210204115640817.PNG?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQzMzkxNjk0,size_16,color_FFFFFF,t_70)

**3.导出为.SVG格式**

选择【文件】|【存储为】，在下拉框中选择对应格式，新建文件夹，将其保存至对应文件夹，个人喜欢设置其为“[QGIS](https://so.csdn.net/so/search?q=QGIS&spm=1001.2101.3001.7020)自定义符号库”，点击确认即可。

![img](https://img-blog.csdnimg.cn/20210204115900812.PNG?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQzMzkxNjk0,size_16,color_FFFFFF,t_70)

**4.QGIS导入并应用符号**

打开QGIS，依次在菜单栏打开【设置】|【选项】【系统】，在SVG路径中添加符号所在的文件夹，如图所示。

![img](https://img-blog.csdnimg.cn/20210204120423829.PNG?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQzMzkxNjk0,size_16,color_FFFFFF,t_70)

之后便可随意打开一组点状矢量数据，如图所示。

![img](https://img-blog.csdnimg.cn/20210204120635964.PNG?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQzMzkxNjk0,size_16,color_FFFFFF,t_70)

双击该要素（交通点要素（精）），在弹出界面打开其【符号化】设置，点击【简单标记】选项，如图所示

![img](https://img-blog.csdnimg.cn/20210204120902511.PNG?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQzMzkxNjk0,size_16,color_FFFFFF,t_70)

在【符号图层类型】中选择“SVG标记”

![img](https://img-blog.csdnimg.cn/20210204121111267.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQzMzkxNjk0,size_16,color_FFFFFF,t_70)

之后下拉至该页最下方，显示SVG浏览器，选择自定义符号所在文件夹，之后点击该符号，点击确定，即可应用该符号。

![img](https://img-blog.csdnimg.cn/20210204121435181.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQzMzkxNjk0,size_16,color_FFFFFF,t_70)

最终结果如图所示。

![img](https://img-blog.csdnimg.cn/20210204121544703.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQzMzkxNjk0,size_16,color_FFFFFF,t_70)

**5.检验符号尺寸**

将比例尺调节至1：1，然后锁定（如图在底部状态栏显示处），之后再次放大，然后使用测量工具进行测量尺寸。

![img](https://img-blog.csdnimg.cn/20210204121824786.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQzMzkxNjk0,size_16,color_FFFFFF,t_70)

放大后图像如图所示

![img](https://img-blog.csdnimg.cn/20210204121933525.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQzMzkxNjk0,size_16,color_FFFFFF,t_70)

对其进行测量，测量结果为长度2.5mm（2.585mm与2.500mm相差0.085mm在绘制误差精度之内），与之前绘制差0.2倍，因此还需修改。

![img](https://img-blog.csdnimg.cn/2021020412213017.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQzMzkxNjk0,size_16,color_FFFFFF,t_70)

再次双击该要素，在弹出框中设置大小一栏数字乘以0.2倍，再次测量结果显示正确。

![img](https://img-blog.csdnimg.cn/20210204123053667.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQzMzkxNjk0,size_16,color_FFFFFF,t_70)