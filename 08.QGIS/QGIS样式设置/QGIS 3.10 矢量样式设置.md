- [QGIS 3.10 矢量样式设置_QGIS课堂的博客-CSDN博客](https://blog.csdn.net/QGISClass/article/details/106475726)

地图由图层构成，为图层设定合适的样式，地图才能达成直观生动的[可视化](https://so.csdn.net/so/search?q=可视化&spm=1001.2101.3001.7020)效果。QGIS提供了大量选项，用于为图层设置形形色色的符号（symbology）。本教程使用一个文本文件，采用各种可视化技术揭示文本数据中隐含的空间模式（spatial pattern）。

# 任务概述

通过包含全世界发电厂位置信息的CSV文件，展示使用可再生燃料的发电厂与使用不可再生燃料的发电厂的空间分布情况。

# 将会学到的其他技巧

使用表达式（expressions）将多个属性值分组为同一类别。

# 获取示范数据

世界资源研究所（World Resources Institute，简称WRI）建立了涵盖全球近3万家发电厂的详实数据库，并且该数据库是开源的（根据《知识共享署名4.0国际许可协议（Creative Commons Attribution 4.0 International License）》获得许可），下载地址为：
[datasets.wri.org/dataset/540dcf46-f287-47ac-985d-269b04bea4c6/resource/c240ed2e-1190-4d7e-b1da-c66b72e08858/download/globalpowerplantdatabasev120](http://datasets.wri.org/dataset/540dcf46-f287-47ac-985d-269b04bea4c6/resource/c240ed2e-1190-4d7e-b1da-c66b72e08858/download/globalpowerplantdatabasev120)
自然地球数据集包含多个覆盖全球的矢量图层。下载1:1千万陆地矢量数据，下载地址为：
[www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/physical/ne_10m_land.zip](http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/physical/ne_10m_land.zip)

# 将[QGIS](https://so.csdn.net/so/search?q=QGIS&spm=1001.2101.3001.7020)界面设置为中文

制作地图之前，请将您的QGIS软件界面设置为简体中文（如果您已经设置过了，可以忽略本节后续内容）。操作方式为：通过菜单【Settings】->【Options…】打开对话框，选择其中的【General】标签，找到“Override system locale”前面的复选框并打勾，在“User Interface Transaction”下拉框中找到并选择“简体中文”，单击【OK】，退出QGIS。重新启动QGIS后即可看到简体中文界面。
![设置中文界面](https://img-blog.csdnimg.cn/20200601164547899.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1FHSVNDbGFzcw==,size_16,color_FFFFFF,t_70#pic_center)

# 详细操作步骤

1. 解压缩下载的两个压缩文件。在QGIS【浏览】面板中，找到解压缩后的文件夹。展开ne_10m_land文件夹，选中其中的ne_10m_land.shp图层，把它拖地图画布窗口中。

![打开数据](https://img-blog.csdnimg.cn/20200601164645304.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1FHSVNDbGFzcw==,size_16,color_FFFFFF,t_70#pic_center)

1. ne_10m_land图层已经添加到【图层】面板中。全球发电厂数据存储于CSV文件中，首先需要将它导入QGIS。点击【数据源】工具栏中的【打开数据源管理器】按钮，也可以使用Ctrl+ L快捷键。

![导入数据](https://img-blog.csdnimg.cn/20200601164754378.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1FHSVNDbGFzcw==,size_16,color_FFFFFF,t_70#pic_center)

1. 在【数据源管理器】窗口中，切换到【分割文本文件】选项卡。点击【文件名称】右侧的【…】按钮，导航至globalpowerplantdatabasev120.zip文件解压缩后生成的文件夹，选择global_power_plant_database.csv文件。QGIS将自动检测分隔符和几何字段。几何坐标参照系保留缺省值EPSG:4326 - WGS84。点击【添加】按钮，然后点击【Close】按钮。

![数据源管理](https://img-blog.csdnimg.cn/2020060116503541.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1FHSVNDbGFzcw==,size_16,color_FFFFFF,t_70#pic_center)

1. 通过CSV文件生成的新图层global_power_plant_database已经添加到【图层】面板中，地图画布中的点代表发电厂。点击【图层】面板上方最左侧的【打开图层样式面板】按钮，对图层样式进行设置。

![图层样式](https://img-blog.csdnimg.cn/20200601165138291.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1FHSVNDbGFzcw==,size_16,color_FFFFFF,t_70#pic_center)

1. 【图层样式】面板将出现在地图画布右侧。首先选择ne_10m_land图层。该图层作为地图的底图，尽可能使其样式简单化，不对其他图层造成干扰。点击【简单填充】，然后在【填充颜色】下拉列表中任意选择一种颜色。在【描边颜色】下拉列表中选择“透明描边”，多边形对象的边界线将变为透明。图层样式设置的效果会立刻反映在地图中。

![图层填充色](https://img-blog.csdnimg.cn/20200601165218580.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1FHSVNDbGFzcw==,size_16,color_FFFFFF,t_70#pic_center)

1. 选择global_power_plant_database图层，点击【简单标记】，然后在下方的标记列表中选择三角形标记。
   ![选择标记](https://img-blog.csdnimg.cn/20200601165308629.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1FHSVNDbGFzcw==,size_16,color_FFFFFF,t_70#pic_center)
2. 在【填充颜色】下拉列表中任意选择一种颜色。一个有用的制图技巧是，把描边颜色设置的比填充颜色略深一些。QGIS可以通过[表达式](https://so.csdn.net/so/search?q=表达式&spm=1001.2101.3001.7020)精确设置颜色，替代手工设置。点击【描边颜色】下拉框右侧的【由数据定义覆盖】按钮，在弹出菜单中点击【编辑】。
   ![填充色和描边](https://img-blog.csdnimg.cn/20200601165403330.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1FHSVNDbGFzcw==,size_16,color_FFFFFF,t_70#pic_center)
3. 输入以下表达式，设置描边颜色比填充颜色深30%，点击【OK】按钮。
   ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200601165440887.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1FHSVNDbGFzcw==,size_16,color_FFFFFF,t_70#pic_center)
   *备注：该表达式与设置的具体颜色无关。通过后续的步骤，将会发现这一点非常有用，因为无论选择怎样的填充颜色，描边颜色都会被自动设置为比填充颜色深30%。*
4. 【由数据定义覆盖】按钮此时将变为黄色，意味着描边颜色属性的设定值被通过表达式定义的数据覆盖了。使用简单标记展现发电厂图层有其局限性，除了反映发电厂的位置信息以外，并没有传达出其他有用信息。下面将增加新的标记方式，点击【符号化】下拉列表，选择【分类】。
   ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200601165531170.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1FHSVNDbGFzcw==,size_16,color_FFFFFF,t_70#pic_center)
5. global_power_plant_database图层包含标识发电厂所用主要燃料的属性字段primary_fuel。可以为该字段的每个取值设置一种不同的颜色。在【值】下拉列表中选择primary_fuel，然后点击【分类】按钮，该字段所有的取值都将作为一个类别出现，地图也相应发生了变化。
   ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200601165603965.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1FHSVNDbGFzcw==,size_16,color_FFFFFF,t_70#pic_center)
6. primary_fuel字段包含的分类取值非常多，造成地图上发电厂对象的颜色繁多，难以传达有效信息。可以将一定分类的取值合并为同一分类，减少分类数量。这里将发电厂分为三类：可再生燃料、不可再生燃料、其他。点击【符号化】下拉列表，选择【基于规则】。点击选中下方规则列表中的第二行，按住键盘上的Shift键，然后点击规则列表中的最后一行，从第二行到最后一行都将被选中，呈现为蓝色。点击【删除选中规则】按钮，删除选中的所有行。
   ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200601165632145.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1FHSVNDbGFzcw==,size_16,color_FFFFFF,t_70#pic_center)
7. 选中剩下的那条规则，点击规则列表下方的【编辑当前规则】按钮。
   ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200601170029763.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1FHSVNDbGFzcw==,size_16,color_FFFFFF,t_70#pic_center)
8. 在【标签】文本框中输入“可再生燃料”作为当前规则的标签，然后点击【过滤】右侧的【表达式】按钮。
   ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200601165907317.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1FHSVNDbGFzcw==,size_16,color_FFFFFF,t_70#pic_center)
9. 在【表达式字符串构建器】对话框中输入以下表达式，然后点击【OK】按钮。这里将多个可再生燃料分类合并为同一分类。

```c
"primary_fuel" IN ('Biomass', 'Geothermal', 'Hydro', 'Solar', 'Wind', 'Storage', 'Wave and Tidal')
1
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200601172847875.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1FHSVNDbGFzcw==,size_16,color_FFFFFF,t_70#pic_center)
*备注：本文对可再生与不可再生燃料的分类参考了维基百科，您也可以使用其他的分类方式。*

1. 在下方的【符号】面板中，选择【简单标记】，然后选择一种填充颜色，设置完成后点击面板上方的【后退】按钮。
   ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200601172926488.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1FHSVNDbGFzcw==,size_16,color_FFFFFF,t_70#pic_center)
2. 可以看出，各类可再生燃料发电厂都显示为相同的符号。用鼠标右键点击规则列表中的唯一行，在弹出菜单中点击【复制】，然后在规则列表空白处再次点击鼠标右键，在弹出菜单中点击【粘贴】。
   ![在这里插入图片描述](https://img-blog.csdnimg.cn/2020060117295773.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1FHSVNDbGFzcw==,size_16,color_FFFFFF,t_70#pic_center)
3. 选中规则列表中通过复制粘贴生成的第二行，点击规则列表下方的【编辑当前选中规则】按钮。
   ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200601173023318.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1FHSVNDbGFzcw==,size_16,color_FFFFFF,t_70#pic_center)
4. 在【标签】文本框中输入“不可再生燃料”作为规则标签，然后点击【过滤】右侧的【表达式】按钮。
   ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200601173408323.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1FHSVNDbGFzcw==,size_16,color_FFFFFF,t_70#pic_center)
5. 在【表达式字符串构建器】对话框中输入以下表达式，然后点击【OK】按钮。

```c
"primary_fuel" IN ('Coal', 'Gas', 'Nuclear', 'Oil', 'Petcoke')
1
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200601173356716.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1FHSVNDbGFzcw==,size_16,color_FFFFFF,t_70#pic_center)

1. 在下方的【符号】面板中，选择【简单标记】，然后选择一种填充颜色，设置完成后点击面板上方的【后退】按钮。
   ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200601173433639.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1FHSVNDbGFzcw==,size_16,color_FFFFFF,t_70#pic_center)
2. 重复上述复制/粘贴步骤，添加第三个规则，选中该规则并点击规则列表下方的【编辑当前规则】按钮。
   ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200601173501946.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1FHSVNDbGFzcw==,size_16,color_FFFFFF,t_70#pic_center)
3. 在【标签】文本框中输入“其他”作为规则标签，然后选中【否则 Catch-all for other features】单选按钮。这将确保所有未出现在前两条规则中的分类都将被列入第三条规则。在下方的【符号】面板中，选择【简单标记】，然后选择一种填充颜色，设置完成后点击面板上方的【后退】按钮。
   ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200601173525451.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1FHSVNDbGFzcw==,size_16,color_FFFFFF,t_70#pic_center)
4. 至此，合并分类的任务已经完成，发电厂图层清晰地展示出可再生燃料发电厂、不可再生燃料发电厂、其他发电厂的空间分布状况。让我们更进一步，为发电厂图层的样式增加另一个变量（capacity_mw字段）：将发电厂的符号大小设置成与发电量成正比。这在制图学中称作“多元制图（Multivariate mapping）”。用鼠标右键点击“可再生燃料”规则，在弹出菜单中点击【更改大小】。
   ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200601173555544.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1FHSVNDbGFzcw==,size_16,color_FFFFFF,t_70#pic_center)
5. 点击弹出对话框最右侧的【由数据定义覆盖】按钮，在弹出菜单中点击【编辑】。
   ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200601173618586.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1FHSVNDbGFzcw==,size_16,color_FFFFFF,t_70#pic_center)

25.由于各发电厂的发电量数值差别巨大，可以通过log10函数减少符号大小之间的差异。在【表达式字符串构建器】对话框中输入以下表达式，然后点击【OK】按钮。

```c
log10("capacity_mw") + 1
1
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200601173654169.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1FHSVNDbGFzcw==,size_16,color_FFFFFF,t_70#pic_center)

1. 对不可再生燃料、其他两类规则进行同样的设置步骤。
   ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200601173723444.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1FHSVNDbGFzcw==,size_16,color_FFFFFF,t_70#pic_center)
2. 设置完成后，关闭【图层样式】面板。
   ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200601173747900.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1FHSVNDbGFzcw==,size_16,color_FFFFFF,t_70#pic_center)
3. 观察最终的可视化效果，一眼就可以看出发电厂的空间分布规律。例如，欧洲有很多使用可再生燃料的发电厂，但发电量普遍较不可再生燃料发电厂低。
   ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200601173806298.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1FHSVNDbGFzcw==,size_16,color_FFFFFF,t_70#pic_center)