在QGIS中编辑矢量图层的过程如下：

​    

# 1.添加矢量图层

添加矢量图层「练习.shp」![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image81.jpg)，启动图层编辑![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image82.jpg)。 启动后，图元上的节点呈现交叉（此交叉，之后更可以对节点进行移动、删除、增加等动作。）

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image83.jpg)

# 2.编辑相关的功能介绍

| 工具                                                         | 作用                        | 操作说明                                               |
| ------------------------------------------------------------ | --------------------------- | ------------------------------------------------------ |
| ![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image84.jpg) | 新增点图元                  | 按鼠标左键，点击图面，右键单击结束                     |
| ![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image85.jpg) | 新增线图元                  | 按鼠标左键，点击图面，右键单击结束                     |
| ![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image86.jpg) | 新增面图元                  | 按鼠标左键，点击图面，右键单击结束                     |
| ![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image87.jpg) | 新增环形（Ring）            | 先选取图元，在图元内画一个多边形，右键单击结束         |
| ![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image88.jpg) | 新增岛形（Island）          | 先选取图元，在图元外，画一个多边形，右键单击结束       |
| ![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image89.jpg) | 分割图元 （将图元一分为二） | 用线段直接切割图元，点击图面切割某一图元，右键单击结束 |
| ![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image90.jpg) | 移动图元                    | 光标在图元上，按鼠标左键拖拉，便可移动图元             |
| ![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image91.jpg) | 移动转折点                  | 光标在图元的转折点上，按鼠标左键拖拉，便可移动图元     |
| ![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image92.jpg) | 删除图元                    | 先选取图元，按鼠标左键删除                             |
| ![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image93.jpg) | 剪下图元                    | 先选取图元，按鼠标左键剪下                             |
| ![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image94.jpg) | 复制图元                    | 先选取图元，按鼠标左键复制                             |
| ![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image95.jpg) | 贴上图元                    | 先选取图元，按鼠标左键贴上                             |
| ![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image96.jpg) | 选取图元                    | 鼠标左键点击所要选取的图元                             |

  

# 3.绘制一个新图元

绘制一个新图元![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image86.jpg)，按鼠标左键，点击图面，右键单击结束后，出现[输入属性值]，若没有要输入属性值，可以按[确定]略过。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image97.jpg)

# 4.移动折点

如图：

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image91.jpg)

  

# 5.新增折点

点选节点工具，光标在图元的某一线段上，按鼠标左键连续点击两下，就可以新增转折点。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image99.jpg)

# 6.删除折点

删除转折点 光标直接在某一节点上点击一下， 节点将转为蓝色，即可按下「Delete」删除转折点。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image100.jpg)

# 7.绘制环形

先选取图元，再按「加入环形」键，在图元的范围内，鼠标左键点击绘图，右键单击形成封闭曲线。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image101.jpg)

完成后如图，原本完整的面变成中空环形。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image102.jpg)

若无加入环形按钮，在工具栏按下右键点选进阶数字化状态呈现「X」，工具栏就会出现新增环形等功能。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image103.jpg)

图：选择工具栏使新增环形功能出现

# 8.绘制岛

先选取图元后，再按「加入部件」，在原本图元附近绘制一个新图元，点选鼠标左键两下，右键单击结束。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image104.jpg)

此两个图元虽然看起来虽然分属不同的两个图元，但却算是一个对象，共有一个属性。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image105.jpg)

图：虽两个不同图元但属于同一对象

# 9.分割图元

先选取图元后，再点击图面切割，用线段直接切割图元，点击图面切割某一图元，右键单击结束。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image106.jpg)

# 10.移动图元

如需要移动、删除、剪下、复制、贴上功能如图，黄色图元为被选取后，移动图元。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image107.jpg)

