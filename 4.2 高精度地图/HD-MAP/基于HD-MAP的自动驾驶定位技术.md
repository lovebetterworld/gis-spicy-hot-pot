- [基于HD-MAP的自动驾驶定位技术 - 古月居 (guyuehome.com)](https://www.guyuehome.com/35445)

# 0. 前言

最近公司需要实现基于HD-MAP的自动驾驶定位技术，而这方面之前涉及的较少，自动驾驶这部分的定位技术与SLAM类似，但是缺少了建图的工程，使用HD-MAP的形式来实现车辆的定位（个人感觉类似机器人SLAM当中的初始化+回环定位的问题）。下面是我个人的思考与归纳

[![在这里插入图片描述](https://img-blog.csdnimg.cn/501e09be1ed549599c0ab798cb8af1a2.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBASGVybWl0X1JhYmJpdA==,size_20,color_FFFFFF,t_70,g_se,x_16)](https://img-blog.csdnimg.cn/501e09be1ed549599c0ab798cb8af1a2.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBASGVybWl0X1JhYmJpdA==,size_20,color_FFFFFF,t_70,g_se,x_16)

# 1. AVP-SLAM

从[AVP-SLAM](https://arxiv.org/pdf/2007.01813.pdf)自动泊车SLAM中我们发现基础（封闭）的视觉定位模式避不开下面几个步骤

A 首先是IPM( Inverse Perspective Mapping )逆透视变换
[![在这里插入图片描述](https://img-blog.csdnimg.cn/17bb52c116c64684afb8f6ff42c09fff.png)](https://img-blog.csdnimg.cn/17bb52c116c64684afb8f6ff42c09fff.png)
[![在这里插入图片描述](https://img-blog.csdnimg.cn/145379114e9240f692e332e306d55e68.png)](https://img-blog.csdnimg.cn/145379114e9240f692e332e306d55e68.png)

B 语义特征提取：使用了CNN网络进行了语义特征的检测[1]， U-Net [2]进行分割

C 局部地图的构建:根据之前图像IPM的变换关系，可以将这些语义信息映射到三维空间中，并且根据里程计信息，将这些语义特征不断的变换到全局坐标下。
[![在这里插入图片描述](https://img-blog.csdnimg.cn/ceec5e257f814f3fa921b70ac57cc9df.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBASGVybWl0X1JhYmJpdA==,size_14,color_FFFFFF,t_70,g_se,x_16)](https://img-blog.csdnimg.cn/ceec5e257f814f3fa921b70ac57cc9df.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBASGVybWl0X1JhYmJpdA==,size_14,color_FFFFFF,t_70,g_se,x_16)

D 回环检测为了解决里程计的漂移的问题，这里使用了语义特征的局部地图不断的ICP全局地图，不断的局部优化。

E：全局优化，优化的残差为
[![在这里插入图片描述](https://img-blog.csdnimg.cn/883ba8791c9d495689f5e0bb5e193c47.png)](https://img-blog.csdnimg.cn/883ba8791c9d495689f5e0bb5e193c47.png)
F 定位:语义地图中的定位。如下图白色、红色和蓝色的圆点是地图上的停车线、减速带、指路标志。绿点是当前的特征。橙色线是估计的轨迹。通过将当前特征与地图匹配来定位车辆。停车位由停车位的角点和停车线拟合自动生成。

G 停车位的检测:由于停车线和停车位角点是从IPM图像中检测出来的，因此很容易自动检测停车位。角点用于预测停车点的位置。如果停车线与预测的停车位匹配良好，则该预测被认为是正确的。
[![在这里插入图片描述](https://img-blog.csdnimg.cn/b21234ea05c74cb7a71669757e88e40a.png)](https://img-blog.csdnimg.cn/b21234ea05c74cb7a71669757e88e40a.png)

# 2. Road-SLAM

Road-SLAM作为基于道路标线车的道级精度SLAM，B站上也有博主对该文章的[详细介绍](https://www.bilibili.com/video/av52887955/)。
[![在这里插入图片描述](https://img-blog.csdnimg.cn/a0945602e5414f81a36bab02b5a66c1d.png)](https://img-blog.csdnimg.cn/a0945602e5414f81a36bab02b5a66c1d.png)
下面是该文章的步骤：
A stero camera获得道路图像

B 通过更新相机与地面的角度，获得IPM 的bird view（俯视图）

C 对该俯视图进行二值化，并分割流通域（此时流通域即为road Marks）

D 对流通域进行ESF feature （Ensemble of Shape Function）提取

E 对提取后特征进行分类，即可获得分类后的sub-map（如果特征比较多即构造sub-map）

F 在回环中，进行sub-map的匹配

G 若形成回环，则可通过sub-map中点云的三维坐标，使用ICP求位姿

F 对得到的位姿进行优化
[![在这里插入图片描述](https://img-blog.csdnimg.cn/123480f092c84b05a5eb04286afcec86.png)](https://img-blog.csdnimg.cn/123480f092c84b05a5eb04286afcec86.png)
下面我们用图来表示
[![在这里插入图片描述](https://img-blog.csdnimg.cn/28eaa3a260874856bedfc2ac7b249bdb.png)](https://img-blog.csdnimg.cn/28eaa3a260874856bedfc2ac7b249bdb.png)
[![在这里插入图片描述](https://img-blog.csdnimg.cn/25299719314e4340911c12b74a79c820.png)](https://img-blog.csdnimg.cn/25299719314e4340911c12b74a79c820.png)
[![在这里插入图片描述](https://img-blog.csdnimg.cn/31aec2832c814663ae2f524d57ea53cd.png)](https://img-blog.csdnimg.cn/31aec2832c814663ae2f524d57ea53cd.png)
我们可以看到对于车道线的感知slam仍然绕不开逆透视变换=>语义分割=>ICP匹配这样的思路。

# 3. HD-Map语义定位

最近纽劢科技公开了他们的[技术方案](https://www.bilibili.com/video/BV11A411c7Dq/)，具体表现为通过HD-Map代替实时建图。利用相机在高精地图（HD map）种进行定位则提供了一种低成本的定位传感器，该系统使用相机作为主要传感器，在具有高精地图环境中用于自动驾驶。这里借鉴[点云PCL文章](https://mp.weixin.qq.com/s/frQTLx4PHki2YItQ_Hw00Q)。这类语义定位相较于SLAM而言缺少了鸟瞰图的投影
[![在这里插入图片描述](https://img-blog.csdnimg.cn/11f4c7002761415c9cb2bbb8642c81f1.png)](https://img-blog.csdnimg.cn/11f4c7002761415c9cb2bbb8642c81f1.png)
在这张图中我们可以看到分成了好几个部分：
**A.高精地图**

高精度地图在自主驾驶中，通常是一种简单且灵活的环境结构表达方式代表着驾驶场景，在车辆定位中，使用**地图元素路标（ lanemarkings LA）**、**杆状物体（ pole-like objects PO）**、**标志牌（ signboards SB）**，这些元素由HD地图中连续有序的三维点集合来描述，上图的跟踪部分中的图形显示了上述语义元素，在定位系统中，可以根据当**前车辆位置和给定的搜索半径查询地图元素**，对于查询到的地标，我们以固定长度间隔采样点作为地标代表。

**B.语义分割和后处理**

为了找到高精地图元素与图像的对应关系，采用语义分割的方法提取图像的语义特征，文中提出了Resnet-18作为主干，并在Cityscape数据集上进行预训练，该网络是一个**多头部结构**，**每个头部是高精地图中一个元素（LA、PO或SB）的二进制分割，用于定位。通过使用语义分割图进行非线性优化来实现车辆姿态估计**，这里使用不同的后处理方法对高精地图中的不同元素进行语义分割，给定**车道和极点的分割结果，使用腐蚀和膨胀操作生成梯度图像**，对于**标志地标，采用拉普拉斯变换提取边缘信息，然后利用形态学运算得到平滑的梯度图像。**
[![在这里插入图片描述](https://img-blog.csdnimg.cn/99b50956dded4f609838711e2967ed23.png)](https://img-blog.csdnimg.cn/99b50956dded4f609838711e2967ed23.png)
**C.初始化**

初始化模块的目的是在地图坐标系中获得相对精确的姿态估计，以便进行后续的姿态跟踪步骤,我们以从粗到精的方式介绍了一种鲁邦而精确的初始化方法，具体而言，是由**两个有效的GPS信息计算粗略的初始姿态Twb**。

**D.跟踪**

在给定初始姿态后，进行跟踪阶段，基于**语义特征和先验地图的估计车辆姿态**，跟踪模块可分为三个步骤。首先，基于**k时刻的姿态估计和其它传感器输入**，如车轮里程测量值，预测k+1帧的车辆姿态。如果驾驶场景**满足纵向约束设置，则执行全局地图步骤中的裁剪局部地图**，否则，首先应用纵向位置校正过程。

从**全局地图元素（LA、PO和SB）裁剪局部地图将使用当前粗略的车辆姿势在预定义的阈值距离内从全局地图查询**，然后利用查询到的局部地图进行无漂移视觉定位，将地图元素E投影回图像点P。为了获得精确的姿势优化，P中的点在图像空间中均匀采样。

纵向位置校正如果驾驶场景不满足纵向约束条件，经过长时间后，**纵向定位可能会出现显著漂移**，这种纵向位置校正模块能够避免在恶劣环境条件下，特别是在长时间内，纵向定位的漂移问题。

其次，通过与高精地图元素的图像对齐来细化6自由度车辆姿态，基于图像语义分割和形态学操作，已经建立了代价图，通过**非线性优化（Levenberg-Marquardt（LM））解决对准问题**。

最后，为了使规划模块获得更平滑的姿态，提高定位系统的鲁棒性，采用了**带有滑动窗口的姿态图**，优化窗口中包含跟踪良好的帧数据，如果滑动窗口的大小超过阈值，历史记录中的一帧将根据车辆状态从滑动窗口中剔除。例如，如果车辆里程测量值接近零，则使用第二个最新帧，否则使用最旧帧。在姿态优化中，因子图由两部分组成，第一部分是每帧的先验姿态因子，约束其视觉对齐的先验分布，另一个是车轮里程计系数，它建立相邻帧之间的连接，以确保平滑的姿势输出，位姿图优化的总残差如等式所示（这部分VINS有涉及，即类似其他的submap）
[![在这里插入图片描述](https://img-blog.csdnimg.cn/900193189deb49cbaa7f0cb6de828d50.png)](https://img-blog.csdnimg.cn/900193189deb49cbaa7f0cb6de828d50.png)

**E.优化**

关于损失函数梯度的优化细节在以下方程式中推导，相对于优化状态的误差雅可比矩阵通常用于加速非线性优化方法（如高斯-牛顿法或LM法）的过程：

[![在这里插入图片描述](https://img-blog.csdnimg.cn/ce287cec43344489b0e0d4accf05ead2.png)](https://img-blog.csdnimg.cn/ce287cec43344489b0e0d4accf05ead2.png)
[![在这里插入图片描述](https://img-blog.csdnimg.cn/ce34d7985b9e47f48dfd9a1fefa653cf.png)](https://img-blog.csdnimg.cn/ce34d7985b9e47f48dfd9a1fefa653cf.png)
**F.跟踪丢失恢复系统**

跟踪系统可能在以下三种情况下丢失：

（1）车辆不在HD地图的范围内；

（2） 姿势优化失败的总数超过阈值；

（3） 严重遮挡的连续帧数超过阈值（例如，在语义地图元素完全不可见的**交通堵塞情况下**会发生这种情况）。

跟踪置信度计算模块将根据上述统计指标确定系统状态，当定位系统处于丢失状态时，跟踪丢失恢复模式被激活，**丢失帧的姿势替换为从车轮里程计推断的备用姿势，即优化前的姿势，给定下一帧，为了激活跟踪阶段，系统再次进入初始化状态**。

# 4. Semantic Map

在此之前也有[一些工作](https://blog.csdn.net/weixin_43900210/article/details/109764977)值得研究，就是通过稀疏的点云来进行匹配。[Localization Based on Semantic Map and Visual Inertial Odometry](https://ieeexplore.ieee.org/abstract/document/8545148)文中，通过感知结果建立先验地图（ICP+GPS），基于VINS-MONO框架，融入GPS，用每帧2D的感知结果去3D的地图里面作匹配，通过语义约束重投影误差的设计，优化位姿。
[![在这里插入图片描述](https://img-blog.csdnimg.cn/8d87284dabca478b804b0f6eada31a58.png)](https://img-blog.csdnimg.cn/8d87284dabca478b804b0f6eada31a58.png)
这里就涉及到点采样的问题了

**2D车道线：拟合为曲线**

[![在这里插入图片描述](https://img-blog.csdnimg.cn/53f93e8902a4417aa12cffc8c7d21471.png)](https://img-blog.csdnimg.cn/53f93e8902a4417aa12cffc8c7d21471.png)
**3D车道线：**
[![在这里插入图片描述](https://img-blog.csdnimg.cn/5d074e5bbd8a4f5488a2c7a4161245d2.png)](https://img-blog.csdnimg.cn/5d074e5bbd8a4f5488a2c7a4161245d2.png)
**交通标志：**
三角形标志保存三个点的坐标
矩形标志保存为四个点坐标
圆形标志保存为圆心坐标和半径

**灯杆：**

一条直线的起始坐标

以GPS的**global pose为初值，确定搜索半径，在范围内获得候选3D坐标，将3D landmark重投影到当前相机坐标，根据语义标签类别的不同定义重投影误差，确定匹配关系后，继续跟踪这对2D-3D匹配，出现了不止一次，就认为是可用的约束**
由于车道线和灯杆容易误匹配，特征不足，主要以标志2D-3D匹配进行初始化，初始化的匹配方式是按照面积选最合适的一堆标志，再在候选中找error最小的
由于匹配比较稀疏，会在多帧之后才初始化完成，采用这个约束来优化

**重投影误差定义：**
车道线：3D点到2D曲线的距离，以x方向差为距离
[![在这里插入图片描述](https://img-blog.csdnimg.cn/4813ccaf3c674b82b1e6ac8c7c8a92d7.png)](https://img-blog.csdnimg.cn/4813ccaf3c674b82b1e6ac8c7c8a92d7.png)
标志
[![在这里插入图片描述](https://img-blog.csdnimg.cn/81b0a7e3c88040eb99b9f4d2de6f542b.png)](https://img-blog.csdnimg.cn/81b0a7e3c88040eb99b9f4d2de6f542b.png)
圆形标志以圆心距离为误差

灯牌：
[![在这里插入图片描述](https://img-blog.csdnimg.cn/c95524aed5fb4790a4d1750708f4e834.png)](https://img-blog.csdnimg.cn/c95524aed5fb4790a4d1750708f4e834.png)
最终如下图：
[![在这里插入图片描述](https://img-blog.csdnimg.cn/938883c37949425f80bf69125ac26258.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBASGVybWl0X1JhYmJpdA==,size_14,color_FFFFFF,t_70,g_se,x_16)](https://img-blog.csdnimg.cn/938883c37949425f80bf69125ac26258.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBASGVybWl0X1JhYmJpdA==,size_14,color_FFFFFF,t_70,g_se,x_16)

# 5. 总结

从这选取的三篇文章来看，从V-SLAM、车道线 SLAM再到HD-Map定位，是逐渐具体化的，以HD-Map为代表的定位已经更加偏向单纯的自动驾驶定位。但是与SLAM相比，仍然可以看到很多SLAM的影子。个人认为HD-Map的定位方案包含了类似SLAM当中的大回环（初始化）+局部地图迭代（跟踪）的思路。