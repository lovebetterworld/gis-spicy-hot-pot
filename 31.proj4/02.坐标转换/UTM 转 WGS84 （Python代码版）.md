- [UTM 转 WGS84 （Python代码版）-云社区-华为云 (huaweicloud.com)](https://bbs.huaweicloud.com/blogs/detail/285556)

## 前言

本文不讲原理，只分享实践思路和代码。基于Python语言，使用pyproj库进行WGS 和UTM的转换。

## 一、安装pyproj

```bash
pip install pyproj
```

## 二、示例代码

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

输出：

x: 766544.7801555358    y: 2517564.4969607797
lat: 22.744435950000007 lon: 113.5954174

## 三、算法效率

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

这是我电脑的结果，1s能转换2489次左右。

## 四、查询坐标系WKID

可以从以下两个网站进行查询：

地理坐标系WKID：https://developers.arcgis.com/javascript/3/jshelp/gcs.htm

投影坐标系WKID：https://developers.arcgis.com/javascript/3/jshelp/pcs.htm

比如，查询广州市的，先查广州市的UTM区号WGS_1984_UTM_Zone_49N；然后在官方网页，用Ctrl + F搜索一下，能找到WGS_1984_UTM_Zone_49N 对应 32649

## 五、pyproj官网文档学习

https://www.osgeo.cn/pyproj/examples.html

参考：https://bbs.huaweicloud.com/blogs/article?id=5e43167ee0724d4e961ecfab6a554cdc