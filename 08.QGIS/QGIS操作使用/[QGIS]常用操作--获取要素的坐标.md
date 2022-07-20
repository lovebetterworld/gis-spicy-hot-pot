- [[QGIS\]常用操作--获取要素的坐标_young_always的博客-CSDN博客_qgis怎么坐标定位](https://blog.csdn.net/u012655611/article/details/118461145)

## 手动获取

节点工具拾取坐标

1. 选中图层并打开编辑
2. 启用顶点工具,在需要获取坐标的要素上用右键点击
3. 在顶点编辑器查看要素坐标信息,如下图

![vertex tool](https://img-blog.csdnimg.cn/20210704203850518.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTI2NTU2MTE=,size_16,color_FFFFFF,t_70#pic_center)

wkt格式复制粘贴获取

1. 选中需要查看坐标的要素(可以不打开编辑状态)
2. 按下CTRL+C,复制要素
3. 打开文本编辑器,CTRL+V将要素信息粘贴到文件中,此时除了要素的坐标这样的几何信息,还有要素的一些属性值也会粘贴到文件,如下录屏

![复制粘贴大法](https://img-blog.csdnimg.cn/20210704231917315.gif#pic_center)

## 使用python代码批量获取

- QGIS支持使用python代码获取要素信息,进行python插件开发,此处简单介绍下通过代码获取要素几何信息

1. 首先是制作python脚本文件,代码如下:
   *2021年7月5日更新,新增对点/线/面几何处理,本文章是以线几何为样例进行处理的*

```python
import os
import sys
from qgis.gui import *
from qgis.core import *
import qgis.utils
from qgis.core import QgsProject

mapCanvas = iface.mapCanvas()
curlayer = mapCanvas.currentLayer()

if curlayer is None:
    print("%s:%s" % ("Error","图层不可用"))
else:
    fetList = curlayer.selectedFeatures()
    print("%s:图层[%s]要素坐标解析开始" % ("Info", curlayer.name()))
    for feature in fetList:
        lineFid = feature.id()
        print("lineFid:%s" % (str(lineFid)))
        geom = feature.geometry()
        # line
        ori_pts = []
        if geom.isMultipart():
            print("MultiPart")
            for part in geom.parts():
                pts = part.points()
                for point in pts:
                    ori_pts.append(point)
        else:
            print("Simple")
            ori_pts = geom.get().points()
        # area
        # for areaPt in geom.vertices():
        #	ori_pts.append(areaPt)
        # point
        # point = geom.get()
        # ori_pts.append(point)
        endPoint = [ori_pts[0],ori_pts[-1]]
        idx = 0
        idxDict = {0:"起点", 1:"终点"}
        for lanePt in endPoint:
            print("端点[%s](%.12f,%.12f,%.12f)" % (idxDict[idx], lanePt.x(), lanePt.y(), lanePt.z()))
            idx = idx + 1
    print("%s:图层[%s]要素端点解析坐标完成" % ("Info", curlayer.name()))
```

1. 打开python控制台,点击"显示编辑器"打开python代码编辑器,将上步代码粘贴到编辑器
2. 选中图层和要素(本例中选用线类型几何的要素),执行脚本,效果如下图:

![python代码](https://img-blog.csdnimg.cn/20210704212502283.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTI2NTU2MTE=,size_16,color_FFFFFF,t_70#pic_center)