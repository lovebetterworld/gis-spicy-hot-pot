- [WGS84 与 UTM 互转（Python代码版）_一颗小树x的博客-CSDN博客_wgs84转utm](https://blog.csdn.net/qq_41204464/article/details/118905641)
- [UTM坐标与GPS经纬度(WGS84)的相互转换_Alan Lan的博客-CSDN博客_utm转经纬度](https://blog.csdn.net/A_L_A_N/article/details/99300241)
- [简单的WGS84转UTM程序[C++\]_HRex39的博客-CSDN博客](https://blog.csdn.net/weixin_47047999/article/details/118463363)
- [UTM坐标和WGS84坐标（如何转换？）_一颗小树x的博客-CSDN博客_utm坐标系与wgs84 坐标系](https://blog.csdn.net/qq_41204464/article/details/104543636)
- [经纬度，墨卡托等坐标转换-Java架构师必看 (javajgs.com)](https://javajgs.com/archives/17722)
- [openlayer 4326与3857坐标互转之Java版 - 英哥boss - 博客园 (cnblogs.com)](https://www.cnblogs.com/code-chen/p/13620793.html)
- [UTM坐标与wgs84坐标转换关系_雪天枫的博客-CSDN博客_utm wgs84](https://blog.csdn.net/zhaodeming000/article/details/112004638)

## 一、安装pyproj

```bash
pip install pyproj
```

## 二、WGS84 转 UTM-示例代码

```python
'''
WGS84的经纬度 转 UTM的x,y
'''
from pyproj import Transformer
 
 
# 参数1：WGS84地理坐标系统 对应 4326 
# 参数2：坐标系WKID 广州市 WGS_1984_UTM_Zone_49N 对应 32649
transformer = Transformer.from_crs("epsg:4326", "epsg:32649") 
 
lat = 22.744435950
lon = 113.595417400
x, y = transformer.transform(lat, lon)
print("x:", x, "y:", y)
```

输出结果：

x: 766544.7801555358 y: 2517564.4969607797

对比结果精准性，Apollo6.0代码转换的结果：

![img](https://img-blog.csdnimg.cn/20210719174301108.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxMjA0NDY0,size_16,color_FFFFFF,t_70)

## 三、UTM 转 WGS84-示例代码

```python
'''
UTM的x,y 转 WGS84的经纬度
'''
from pyproj import Transformer
 
# 参数1：坐标系WKID 广州市 WGS_1984_UTM_Zone_49N 对应 32649
# 参数2：WGS84地理坐标系统 对应 4326
transformer = Transformer.from_crs("epsg:32649", "epsg:4326")
 
x = 766544.7801555358
y = 2517564.4969607797
lat, lon = transformer.transform(x, y)
print("x:", x, "y:", y)
print("lat:", lat, "lon:", lon)
```

输出：x: 766544.7801555358      y: 2517564.4969607797
     lat: 22.744435950000007    lon: 113.5954174

## 四、算法效率

这里计算1s内，能运行多少次转换，以UTM 转 WGS84为例子。

```python
'''
计算1s内，能运行多少次转换（UTM的x,y 转 WGS84的经纬度）
'''
from pyproj import Transformer
import time
# 参数1：坐标系WKID 广州市 WGS_1984_UTM_Zone_49N 对应 32649
# 参数2：WGS84地理坐标系统 对应 4326
transformer = Transformer.from_crs("epsg:32649", "epsg:4326")
 
sum_t=0.0            #花费的总时间
i = 0
 
# 计算1s内，能运行多少次转换。
while sum_t < 1:
    time_start = time.time()  # 开始计时
    print("i:", i)
    i = i + 1
    ###########
    x = 766544.7801555358
    y = 2517564.4969607797
    lat, lon = transformer.transform(x, y)
    print("x:", x, "y:", y)
    print("lat:", lat, "lon:", lon)
    ###########
    time_end = time.time()                # 结束计时
    sum_t=(time_end - time_start)+sum_t   #运行所花时间
    print('time cost', sum_t, 's')
    print("\n")
```

这是我电脑的结果，1s能转换2489次左右。![img](https://img-blog.csdnimg.cn/20210719204840673.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxMjA0NDY0,size_16,color_FFFFFF,t_70)

## 三、查询坐标系WKID

可以从以下两个网站进行查询：

地理坐标系WKID：https://developers.arcgis.com/javascript/3/jshelp/gcs.htm

投影坐标系WKID：https://developers.arcgis.com/javascript/3/jshelp/pcs.htm

比如，查询广州市的，先查广州市的UTM区号WGS_1984_UTM_Zone_49N；然后在官方网页，用Ctrl + F搜索一下，能找到WGS_1984_UTM_Zone_49N 对应 32649

![img](https://img-blog.csdnimg.cn/20210719174719280.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxMjA0NDY0,size_16,color_FFFFFF,t_70)

## 四、pyproj官网文档学习

https://www.osgeo.cn/pyproj/examples.html

![img](https://img-blog.csdnimg.cn/20210719180730715.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxMjA0NDY0,size_16,color_FFFFFF,t_70)

参考：https://blog.csdn.net/tap880507/article/details/111608529

[UTM坐标和WGS84坐标（如何转换？](https://blog.csdn.net/qq_41204464/article/details/104543636?ops_request_misc=%7B%22request%5Fid%22%3A%22162668837016780274133032%22%2C%22scm%22%3A%2220140713.130102334.pc%5Fblog.%22%7D&request_id=162668837016780274133032&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~blog~first_rank_v2~rank_v29-1-104543636.pc_v2_rank_blog_default&utm_term=UTM&spm=1018.2226.3001.4450)

https://blog.csdn.net/ywcpig/article/details/107516253