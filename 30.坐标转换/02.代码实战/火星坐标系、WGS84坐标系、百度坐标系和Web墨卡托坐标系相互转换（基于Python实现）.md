- [火星坐标系、WGS84坐标系、百度坐标系和Web墨卡托坐标系相互转换（基于Python实现）_hhhSir'blog的博客-CSDN博客_wgs84转web墨卡托](https://blog.csdn.net/weixin_41399650/article/details/124182920)
- [WGS84、Web墨卡托、火星坐标、百度坐标互转 - March On - 博客园 (cnblogs.com)](https://www.cnblogs.com/z-sm/p/5074611.html)
- [大地经纬度坐标系与Web墨卡托坐标系的转换](https://www.cnblogs.com/charlee44/p/15449722.html)

# 一、背景

主流被使用的地理坐标系并不统一，导致我们从不同平台下载的数据由于坐标系的差异往往对不齐。这个现象在多源数据处理的时候往往很常见，因此需要进行坐标转换。

简单介绍一下几种常见的坐标系：

- **WGS84**坐标系：即地球坐标系（World Geodetic System），国际上通用的坐标系。设备包含的GPS芯片或者北斗芯片获取的经纬度一般都是为WGS84地理坐标系，目前谷歌地图采用的是WGS84坐标系（中国范围除外）。
- **GCJ02**坐标系：GCJ-02是由中国国家测绘局（G表示Guojia国家，C表示Cehui测绘，J表示Ju局）制订的地理信息系统的坐标系统。由WGS84坐标系经加密后的坐标系。谷歌中国采用的GCJ02地理坐标系。也称：**火星坐标**系。
- **BD09**坐标系：即百度坐标系，GCJ02坐标系经加密后的坐标系。
- **Web 墨卡托投影坐标系**：也称web墨卡托，是如今主流的Web地图使用的坐标系，如国外的 Google Maps，OpenStreetMap，Bing Map，ArcGIS 和 Heremaps 等，国内的百度地图、高德地图、腾讯地图和天地图等也是基于Web墨卡托，与地理坐标系不同，投影坐标系的单位是m（由于国内政策的原因，国内地图会有加密要求，一般有两种情况，一种是在 Web墨卡托的基础上经过国家标准加密的国标02坐标系，熟称“火星坐标系”；另一种是在国标的02坐标系下进一步进行加密，如百度地图的BD09坐标系）。
  墨卡托投影的“等角”特性，保证了对象的形状的不变行，正方形的物体投影后不会变为长方形。“等角”也保证了方向和相互位置的正确性，因此在航海和航空中常常应用，而Google们在计算人们查询地物的方向时不会出错。

# 二、代码

```python
# -*- coding: utf-8 -*-

import math
import pandas as pd
import os

# WGS84、GCJ02（火星坐标系）、BD09（百度坐标系）以及百度地图中保存矢量信息的web墨卡托
class LngLatTransfer():
    
    def __init__(self):
        self.x_pi = 3.14159265358979324 * 3000.0 / 180.0
        self.pi = math.pi  # π
        self.a = 6378245.0  # 长半轴
        self.es = 0.00669342162296594323  # 偏心率平方
        pass

    def GCJ02_to_BD09(self, gcj_lng, gcj_lat):
        """
        实现GCJ02向BD09坐标系的转换
        :param lng: GCJ02坐标系下的经度
        :param lat: GCJ02坐标系下的纬度
        :return: 转换后的BD09下经纬度
        """
        z = math.sqrt(gcj_lng * gcj_lng + gcj_lat * gcj_lat) + 0.00002 * math.sin(gcj_lat * self.x_pi)
        theta = math.atan2(gcj_lat, gcj_lng) + 0.000003 * math.cos(gcj_lng * self.x_pi)
        bd_lng = z * math.cos(theta) + 0.0065
        bd_lat = z * math.sin(theta) + 0.006
        return bd_lng, bd_lat


    def BD09_to_GCJ02(self, bd_lng, bd_lat):
        '''
        实现BD09坐标系向GCJ02坐标系的转换
        :param bd_lng: BD09坐标系下的经度
        :param bd_lat: BD09坐标系下的纬度
        :return: 转换后的GCJ02下经纬度
        '''
        x = bd_lng - 0.0065
        y = bd_lat - 0.006
        z = math.sqrt(x * x + y * y) - 0.00002 * math.sin(y * self.x_pi)
        theta = math.atan2(y, x) - 0.000003 * math.cos(x * self.x_pi)
        gcj_lng = z * math.cos(theta)
        gcj_lat = z * math.sin(theta)
        return gcj_lng, gcj_lat


    def WGS84_to_GCJ02(self, lng, lat):
        '''
        实现WGS84坐标系向GCJ02坐标系的转换
        :param lng: WGS84坐标系下的经度
        :param lat: WGS84坐标系下的纬度
        :return: 转换后的GCJ02下经纬度
        '''
        dlat = self._transformlat(lng - 105.0, lat - 35.0)
        dlng = self._transformlng(lng - 105.0, lat - 35.0)
        radlat = lat / 180.0 * self.pi
        magic = math.sin(radlat)
        magic = 1 - self.es * magic * magic
        sqrtmagic = math.sqrt(magic)
        dlat = (dlat * 180.0) / ((self.a * (1 - self.es)) / (magic * sqrtmagic) * self.pi)
        dlng = (dlng * 180.0) / (self.a / sqrtmagic * math.cos(radlat) * self.pi)
        gcj_lng = lat + dlat
        gcj_lat = lng + dlng
        return gcj_lng, gcj_lat


    def GCJ02_to_WGS84(self, gcj_lng, gcj_lat):
        '''
        实现GCJ02坐标系向WGS84坐标系的转换
        :param gcj_lng: GCJ02坐标系下的经度
        :param gcj_lat: GCJ02坐标系下的纬度
        :return: 转换后的WGS84下经纬度
        '''
        dlat = self._transformlat(gcj_lng - 105.0, gcj_lat - 35.0)
        dlng = self._transformlng(gcj_lng - 105.0, gcj_lat - 35.0)
        radlat = gcj_lat / 180.0 * self.pi
        magic = math.sin(radlat)
        magic = 1 - self.es * magic * magic
        sqrtmagic = math.sqrt(magic)
        dlat = (dlat * 180.0) / ((self.a * (1 - self.es)) / (magic * sqrtmagic) * self.pi)
        dlng = (dlng * 180.0) / (self.a / sqrtmagic * math.cos(radlat) * self.pi)
        mglat = gcj_lat + dlat
        mglng = gcj_lng + dlng
        lng = gcj_lng * 2 - mglng
        lat = gcj_lat * 2 - mglat
        return lng, lat


    def BD09_to_WGS84(self, bd_lng, bd_lat):
        '''
        实现BD09坐标系向WGS84坐标系的转换
        :param bd_lng: BD09坐标系下的经度
        :param bd_lat: BD09坐标系下的纬度
        :return: 转换后的WGS84下经纬度
        '''
        lng, lat = self.BD09_to_GCJ02(bd_lng, bd_lat)
        return self.GCJ02_to_WGS84(lng, lat)


    def WGS84_to_BD09(self, lng, lat):
        '''
        实现WGS84坐标系向BD09坐标系的转换
        :param lng: WGS84坐标系下的经度
        :param lat: WGS84坐标系下的纬度
        :return: 转换后的BD09下经纬度
        '''
        lng, lat = self.WGS84_to_GCJ02(lng, lat)
        return self.GCJ02_to_BD09(lng, lat)


    def _transformlat(self, lng, lat):
        ret = -100.0 + 2.0 * lng + 3.0 * lat + 0.2 * lat * lat + \
              0.1 * lng * lat + 0.2 * math.sqrt(math.fabs(lng))
        ret += (20.0 * math.sin(6.0 * lng * self.pi) + 20.0 *
                math.sin(2.0 * lng * self.pi)) * 2.0 / 3.0
        ret += (20.0 * math.sin(lat * self.pi) + 40.0 *
                math.sin(lat / 3.0 * self.pi)) * 2.0 / 3.0
        ret += (160.0 * math.sin(lat / 12.0 * self.pi) + 320 *
                math.sin(lat * self.pi / 30.0)) * 2.0 / 3.0
        return ret


    def _transformlng(self, lng, lat):
        ret = 300.0 + lng + 2.0 * lat + 0.1 * lng * lng + \
              0.1 * lng * lat + 0.1 * math.sqrt(math.fabs(lng))
        ret += (20.0 * math.sin(6.0 * lng * self.pi) + 20.0 *
                math.sin(2.0 * lng * self.pi)) * 2.0 / 3.0
        ret += (20.0 * math.sin(lng * self.pi) + 40.0 *
                math.sin(lng / 3.0 * self.pi)) * 2.0 / 3.0
        ret += (150.0 * math.sin(lng / 12.0 * self.pi) + 300.0 *
                math.sin(lng / 30.0 * self.pi)) * 2.0 / 3.0
        return ret

    def WGS84_to_WebMercator(self, lng, lat):
        '''
        实现WGS84向web墨卡托的转换
        :param lng: WGS84经度
        :param lat: WGS84纬度
        :return: 转换后的web墨卡托坐标
        '''
        x = lng * 20037508.342789 / 180
        y = math.log(math.tan((90 + lat) * self.pi / 360)) / (self.pi / 180)
        y = y * 20037508.34789 / 180
        return x, y

    def WebMercator_to_WGS84(self, x, y):
        '''
        实现web墨卡托向WGS84的转换
        :param x: web墨卡托x坐标
        :param y: web墨卡托y坐标
        :return: 转换后的WGS84经纬度
        '''
        lng = x / 20037508.34 * 180
        lat = y / 20037508.34 * 180
        lat = 180 / self.pi * (2 * math.atan(math.exp(lat * self.pi / 180)) - self.pi / 2)
        return lng, lat
    
if __name__=='__main__':
    fileName = r'F:\武汉轨迹数据\交通事故(2018年)\accidentFileLocations.csv'
    transData = pd.read_csv(fileName, engine='python')
    transData["WGS84lng"] = None
    transData["WGS84lat"] = None
    # 火星坐标系 转换为 wgs84坐标系：GCJ02_to_WGS84 (lng, lat)
    handler = LngLatTransfer()
    transData[["WGS84lng", "WGS84lat"]] = transData.apply(lambda x : handler.GCJ02_to_WGS84(x["LON"], x["LAT"]), axis = 1, result_type="expand")
    os.chdir(r'F:\武汉轨迹数据\交通事故(2018年)')
    transData.to_csv("LoacationTransTest.csv", index = False)
```

直接贴个代码，具体怎么实现和怎么使用的就很清楚了，不多言。[代码来源](https://www.cnblogs.com/feffery/p/11023673.html)，而且真心实推GIS专业的学生多看看这个老哥的blog，大神。

上面代码的逻辑可以用这张图来表示，是不是更加清楚了。

![在这里插入图片描述](https://img-blog.csdnimg.cn/703aaf36aa0e438cb2cff55c5822b77d.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAaGhoU2lyJ2Jsb2c=,size_15,color_FFFFFF,t_70,g_se,x_16)