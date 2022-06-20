- [GPS经纬度坐标WGS84到东北天坐标系ENU的转换 - 一抹烟霞 - 博客园 (cnblogs.com)](https://www.cnblogs.com/long5683/p/13831605.html#13-东北天坐标系enu)

## 一、简介

### 1.1 ECEF坐标系

  也叫地心地固直角坐标系。其原点为地球的质心，x轴延伸通过本初子午线（0度经度）和赤道（0deglatitude）的交点。 z轴延伸通过的北极（即，与地球旋转轴重合）。 y轴完成右手坐标系，穿过赤道和90度经度。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20201017154233163.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM0MjEzMjYw,size_16,color_FFFFFF,t_70#pic_center)

### 1.2 WGS-84坐标

  也就是也叫经纬高坐标系(经度(longitude)，纬度(latitude)和高度(altitude)LLA坐标系)。，全球地理坐标系、大地坐标系。可以说是最为广泛应用的一个地球坐标系，它给出一点的大地纬度、大地经度和大地高程而更加直观地告诉我们该点在地球中的位置，故又被称作纬经高坐标系。WGS-84坐标系的X轴指向BIH(国际时间服务机构)1984.0定义的零子午面(Greenwich)和协议地球极(CTP)赤道的交点。Z轴指向CTP方向。Y轴与X、Z轴构成右手坐标系。

  一句话解释就是：把前面提到的ECEF坐标系用在GPS中，就是WGS-84坐标系。
其中：
（1）：大地纬度是过用户点P的基准椭球面法线与赤道面的夹角。纬度值在-90°到+90°之间。北半球为正，南半球为负。

（2）：大地经度是过用户点P的子午面与本初子午线之间的夹角。经度值在-180°到+180°之间。

（3）：大地高度h是过用户点P到基准椭球面的法线距离，基准椭球面以内为负，以外为正。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201017154742140.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM0MjEzMjYw,size_16,color_FFFFFF,t_70#pic_center)

### 1.3 东北天坐标系（ENU）

  也叫站心坐标系以用户所在位置P为坐标原点。

  坐标系定义为： X轴：指向东边 Y轴：指向北边 Z轴：指向天顶

  ENU局部坐标系采用三维直角坐标系来描述地球表面，实际应用较为困难，因此一般使用简化后的二维投影坐标系来描述。在众多二维投影坐标系中，统一横轴墨卡托（The Universal Transverse Mercator ，UTM）坐标系是一种应用较为广泛的一种。UTM 坐标系统使用基于网格的方法表示坐标，它将地球分为 60 个经度区，每个区包含6度的经度范围，每个区内的坐标均基于横轴墨卡托投影，如下图所示：

## 二、坐标系间的转换

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201017155642640.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM0MjEzMjYw,size_16,color_FFFFFF,t_70#pic_center)

### 2.1 LLA坐标系转ECEF坐标系

（1）LLA坐标系下的(lon,lat,alt)转换为ECEF坐标系下点(X,Y,Z)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20201017155837288.png#pic_center)
（2）其中e为椭球偏心率，N为基准椭球体的曲率半径
![在这里插入图片描述](https://img-blog.csdnimg.cn/20201017155924340.png#pic_center)
（3）由于WGS-84下极扁率f=a−baf=a−ba偏心率e和极扁率f之间的关系：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20201017160341165.png#pic_center)
(4) 坐标转换公式也可以为
![在这里插入图片描述](https://img-blog.csdnimg.cn/20201017160358907.png#pic_center)

### 2.2 ECEF坐标系转LLA坐标系

ECEF坐标系下点(X,Y,Z)转换为LLA坐标系下的(lon,lat,alt)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20201017160702975.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM0MjEzMjYw,size_16,color_FFFFFF,t_70#pic_center)一开始lon是未知的，可以假设为0，经过几次迭代之后就能收敛

### 2.3 ECEF坐标系转ENU坐标系

用户所在坐标原点P0=(x0,y0,z0)P0=(x0,y0,z0),，计算点P=(x,y,z)P=(x,y,z)在以点P0P0为坐标原点的ENU坐标系位置(e,n,u)这里需要用到LLA坐标系的数据，P0P0的LLA坐标点为LLA0=(lon0,lat0,alt0)LLA0=(lon0,lat0,alt0)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20201017161058989.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM0MjEzMjYw,size_16,color_FFFFFF,t_70#pic_center)

### 2.4 ENU坐标系转ECEF坐标系

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201017161135182.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM0MjEzMjYw,size_16,color_FFFFFF,t_70#pic_center)

### 2.5 LLA坐标系直接转ENU坐标系

上述可以看到，从LLA坐标系转换到enu坐标系有较多计算量，在考虑地球偏心率ee很小的前提下，可以做一定的近似公式计算

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201017161230739.png#pic_center)

## 参考资料

1. https://www.cnblogs.com/langzou/p/11388520.html
2. https://blog.csdn.net/YYshuangshuang/article/details/85099025?utm_medium=distribute.pc_feed_404.none-task-blog-BlogCommendFromBaidu-2.nonecase&depth_1-utm_source=distribute.pc_feed_404.none-task-blog-BlogCommendFromBaidu-2.nonecas