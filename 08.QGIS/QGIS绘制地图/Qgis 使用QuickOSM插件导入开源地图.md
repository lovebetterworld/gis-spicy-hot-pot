- [Qgis 使用QuickOSM插件导入开源地图_上层建筑与底层逻辑的博客-CSDN博客_qgis地图插件](https://blog.csdn.net/icoolno1/article/details/107409492)

# 一、安装插件

如果没有安装插件的话，需要先安装插件。

安装步骤：

1、顶部菜单里找到Plugins->Manage and Install Plugins...

![img](https://img-blog.csdnimg.cn/20200717153159922.png)

2、在搜索框中输入QuickOSM，在列表中选择QuickOSM，然后点击右下角的InstallPlugins。

![QuickOSM](https://img-blog.csdnimg.cn/20200717152624699.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2ljb29sbm8x,size_16,color_FFFFFF,t_70)

# 二、下载地图

1、打开[https://www.openstreetmap.org](https://www.openstreetmap.org/)

2、点击上方的导出

3、将右边的地图中心点拖到合适的地方。

![img](https://img-blog.csdnimg.cn/20200717152818188.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2ljb29sbm8x,size_16,color_FFFFFF,t_70)

4、点击左边蓝色背景的导出按钮，保存对话框中选择合适位置下载保存。

![img](https://img-blog.csdnimg.cn/20200717152839889.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2ljb29sbm8x,size_16,color_FFFFFF,t_70)

# 三、在[Qgis](https://so.csdn.net/so/search?q=Qgis&spm=1001.2101.3001.7020)中加入OpenStreetMap的地图数据

插件安装好，Vector的子菜单下就会多一个QuickOSM菜单，点击对话框。

![img](https://img-blog.csdnimg.cn/20200717153620229.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2ljb29sbm8x,size_16,color_FFFFFF,t_70)

OSM File选择刚才下载的地图文件，选择合适的图形，点击Open。

![img](https://img-blog.csdnimg.cn/20200717152926409.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2ljb29sbm8x,size_16,color_FFFFFF,t_70)

完成后，Qgis的图层窗口里就会多出刚刚添加的内容。此时图层数据是放在内存中的，需要点击右边的小图标保存为文件或存放到数据库中。

![img](https://img-blog.csdnimg.cn/20200717152959562.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2ljb29sbm8x,size_16,color_FFFFFF,t_70)

在弹出的对话框中选择合适的格式，选择要保存的文件名。

![QuickOSM](https://img-blog.csdnimg.cn/20200717152545445.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2ljb29sbm8x,size_16,color_FFFFFF,t_70)

至此OSM文件导入就完成了。