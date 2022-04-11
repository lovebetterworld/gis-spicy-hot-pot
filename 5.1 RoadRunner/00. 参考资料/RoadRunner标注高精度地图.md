- [RoadRunner标注高精度地图 | 攻城狮の家 (xchu.net)](http://xchu.net/2021/04/22/55-roadrunner/)

RoadRunner标注高精度地图记录。

– 2021年4月26日更新

![image-20210422110041059](http://xchu.net/2021/04/22/55-roadrunner/image-20210422110041059.png)



### 导入点云地图

1. 在libary Browser中新建pointsmap文件夹，作为存放点云地图的路径，然后把pcd文件copy到目录下。

![image-20210422105505152](http://xchu.net/2021/04/22/55-roadrunner/image-20210422105505152.png)

1. 点击工具栏中点云的图标，鼠标左键将pointsmap文件夹中的点云拖动到主窗口中，画布的右上角会一直转圈，表明正在导入点云地图，这里比较慢。

   ![image-20210426193753618](http://xchu.net/2021/04/22/55-roadrunner/image-20210426193753618.png)
   ![image-20210422105627903](http://xchu.net/2021/04/22/55-roadrunner/image-20210422105627903.png)

2. 点击主窗口中的点云地图，可以在右侧属性窗口中编辑点云显示的属性，可以把点调大调小，或者是缩放点云反射强度，注意反射强度缩放很重要，能否看得清车道线等道路标志全靠这个功能。

   > 一般来说，道路地面标识等材料的反射强度范围在0-100，其中车道线等白色油漆涂料的反射强度更小，大概10-20，这里通过反射强度的rescale，可以很好的把地面标识区分出来，方便标注。

   ![image-20210422110041059](http://xchu.net/2021/04/22/55-roadrunner/image-20210422110041059.png)

### 调整视角

1. 一般采用正交图标注，即俯视图，调整以下按钮，选择Orthographic，或者直接快捷键选择O，direction选择Top-down

   ![image-20210422110313174](http://xchu.net/2021/04/22/55-roadrunner/image-20210422110313174.png)

2. 鼠标放在主窗口下，Alt+鼠标左键即可查看3d视角。

   ![image-20210422110444075](http://xchu.net/2021/04/22/55-roadrunner/image-20210422110444075.png)

### 标注Road和车道

road的操作基本上是选中以下这些图标，然后在下方的RoadStyles中选择合适的道路类型，鼠标右键在画布中选定起点，点击即延长道路，鼠标连续点击形成的线段即为opendrive中的reference line线段。两条road相交时，如果高度一致，会默认形成junction。

![image-20210426194023556](http://xchu.net/2021/04/22/55-roadrunner/image-20210426194023556.png)

![image-20210426194048244](http://xchu.net/2021/04/22/55-roadrunner/image-20210426194048244.png)

![image-20210426194410033](http://xchu.net/2021/04/22/55-roadrunner/image-20210426194410033.png)

```
选中一条road，在左下脚的2d编辑器窗口可以看到道路点云的高度情况，可以进行道路高度的曲线拟合，对曲线拟合有三种拟合方式，曲线通过控制点、不通过控制点、折线拟合。
```

![image-20210426194601209](http://xchu.net/2021/04/22/55-roadrunner/image-20210426194601209.png)