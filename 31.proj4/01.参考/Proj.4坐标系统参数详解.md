- android 使用proj4j库，转换部分解释（Java 版纠正高程没有计算）
- [Proj.4坐标系统参数详解 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/159105544)
- [PROJ.4学习——初识PROJ - eshinex - 博客园 (cnblogs.com)](https://www.cnblogs.com/eshinex/p/10299234.html)

这个文档目的是描述所有`PROJ.4`的参数，可以应用于所有或大多数坐标系统定义。本文档并不试图描述特定于投影类型的特定参数。其中一些可以在GeoTIFF **[投影变换列表](https://link.zhihu.com/?target=http%3A//www.remotesensing.org/geotiff/proj_list/)**找到。大多数参数的详细文档是可从 [PROJ.4 主页](https://link.zhihu.com/?target=https%3A//proj.org/usage/quickstart.html)访问

## 使用实例

```js
const anchor = { x: 119, y: 30, z: 0 }
const latlonProjWkt = '+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs'
const tmercProjWkt = `+proj=tmerc +lat_0=${anchor.y} +lon_0=${anchor.x} +axis=enu +k=1 +x_0=0 +y_0=0 +datum=WGS84 +no_defs +geoidgrids=egm96_15.gtx`
    // 相对距离
const carRelativeToLight = () => {
      let result = proj4(latlonProjWkt, tmercProjWkt, [location.longitude, location.latitude])
      let relative = {
        x: result[0],
        y: result[1],
        z: 0,
      }
      return relative
    }
```



**通用参数**

```text
+a         椭球体长半轴长度
+alpha     ? 用于斜墨卡托和其它几个可能的投影
+axis      轴方向 (new in 4.8.0)
+b         椭球体短半轴长度
+datum     基准面名(见`proj -ld`)
+ellps     椭球体名(见`proj -le`)
+k         比例因子(old name)
+k_0       比例因子(new name)
+lat_0     维度起点
+lat_1     标准平行纬线第一条
+lat_2     标准平行纬线第二条
+lat_ts    有效纬度范围Latitude of true scale
+lon_0     中央经线
+lonc      ? 经度用于斜墨卡托和其它几个可能的投影
+lon_wrap  Center longitude to use for wrapping (见下文)
+nadgrids  NTv2网格文件的文件名，用于基准面转换(见下文)
+no_defs   不要使用/usr/share/proj/proj_def.dat缺省文件
+over      允许经度超出-180到180范围,禁止wrapping (见下文)
+pm        备用本初子午线(通常是一个城市的名字，见下文)
+proj      投影名(见`proj -l`)
+south     表示南半球UTM区域
+to_meter  乘数，转换地图单位为1.0m
+towgs84   3或7参数基准面转换(见下文)
+units     meters(米), US survey feet(美国测量英尺),等.
+vto_meter 垂直变换为米.
+vunits    垂直单位.
+x_0       东伪偏移
+y_0       北伪偏移
+zone      UTM区域
```

**扩展参数**

```text
+a         椭球体长半轴长度
+alpha     ? 用于斜墨卡托和其它几个可能的投影
+azi
+b         椭球体短半轴长度
+belgium
+beta
+czech
+e         椭球体的偏心率= sqrt(1 - b^2/a^2) = sqrt( f*(2-f) )
+ellps     椭球体名(见`proj -le`)
+es        椭球体的偏心率的平方
+f         椭球体扁平程度= 1-sqrt(1-e^2) (经常用倒数表示,例:1/298)
+geoc
+guam
+h
+k         比例因子(old name)
+K
+k_0       比例因子(new name)
+lat_0     维度起点
+lat_1     标准平行纬线第一条
+lat_2     标准平行纬线第二条
+lat_b
+lat_t
+lat_ts    Latitude of true scale
+lon_0     中央经线
+lon_1
+lon_2
+lonc      ? 经度用于斜墨卡托和其它几个可能的投影
+lsat
+m
+M
+n
+no_cut
+no_off
+no_rot
+ns
+o_alpha
+o_lat_1
+o_lat_2
+o_lat_c
+o_lat_p
+o_lon_1
+o_lon_2
+o_lon_c
+o_lon_p
+o_proj
+over
+p
+path
+proj      投影名(见`proj -l`)
+q
+R
+R_a
+R_A       计算半径，使得球体的面积是等同于椭圆体的面积
+rf        椭球体扁平程度倒数(例:298)
+R_g
+R_h
+R_lat_a
+R_lat_g
+rot
+R_V
+s
+south     表示南半球UTM区域
+sym
+t
+theta
+tilt
+to_meter  乘数，转换地图单位为1.0m
+units     meters(米), US survey feet(美国测量英尺),等.
+vopt
+W
+westo
+x_0       东伪偏移
+y_0       北伪偏移
+zone      UTM区域
```

## **单位**

水平单位可以使用`+units= `关键字，指定一个单位的符号名(如:us-ft)。另外转换为米单位可以使用`+to_meter`关键字指定(如: 美国英尺为0.304800609601219米)。-lu参数用于`cs2cs`或`proj`可以列出支持单位名称.默认单位是度(degrees)。



## **垂直单位**

垂直单位(Z)可以使用`+vunits=`关键字指定一个单位的符号名(如: `us-ft`)。与单位相同的转换为米单位可以使用`+vto_meter`关键字指定(如: 美国英尺为0.304800609601219米)。`-lu`参数用于`cs2cs`或`proj`可以列出支持单位名称。如果没有指定垂直单位，垂直单元将默认为与水平坐标相同的.

**注意**垂直单位转换仅在`pj_transform()`和建立在这基础上的程序(如cs2cs)。低层次的投影函数`pj_fwd()`和`pj_inv()`以及直接使用它们的程序(如`proj`)，根本不处理垂直单位.



## **东/北伪偏移**

几乎所有的坐标系统都运行东伪偏移(+x_0)和北伪偏移(+y_0)。请注意，这些值是米单位的，即使坐标系是一些其它单位的.一些坐标系统(如UTM)具有隐含的东/北伪偏移值.

lon_wrap, 超范围部分经度环绕

默认情况下PROJ.4在经度范围-180到180环绕包覆。`+lon_wrap=180表示通过经度转换后其参数被包含在0-360度的范围内，180度为其中心点， +over`可用于禁用默认warp(环绕包覆)。



## **本初子午线**

![img](https://pic3.zhimg.com/v2-cfe0a5e0a5f973a7abb278ada8821b5a_b.jpg)![img](data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='300' height='154'></svg>)

本初子午线可以声明表示声明的坐标系本初子午线和格林威治之间的偏移。本初子午线是使用"pm"参数声明的，可能被分配一个符号名称或替代相对於格林尼治子午线的经度（`例如:+pm=-10，即表示本初子午线为相对格林尼治子午线东偏10度`）。

当前子午线声明只被`pj_transform()` API利用,而不被`pj_inv()`和`pj_fwd()`利用。因此用户工具`cs2cs`遵守本初子午线参数，但是`proj`程序忽略它.

支持以下预先声明本初子午线名称。这些都可以使用`cs2cs -lm`列出.

```text
   greenwich 0dE                           
      lisbon 9d07'54.862"W                 
       paris 2d20'14.025"E                 
      bogota 74d04'51.3"E                  
      madrid 3d41'16.48"W                  
        rome 12d27'8.4"E                   
        bern 7d26'22.5"E                   
     jakarta 106d48'27.79"E                
       ferro 17d40'W                       
    brussels 4d22'4.71"E                   
   stockholm 18d3'29.8"E                   
      athens 23d42'58.815"E                
        oslo 10d43'22.5"E                  


使用示例：位置long=0, lat=0在基于格林威治的lat/long坐标转换到基于马德里作为本初子午线的lat/long坐标.

# 源坐标系    	+proj=latlong +datum=WGS84
# 目标坐标系	+proj=latlong +datum=WGS84 +pm=madrid
 cs2cs +proj=latlong +datum=WGS84 +to +proj=latlong +datum=WGS84 +pm=madrid
0 0                           <i>(input)</i>
3d41'16.48"E    0dN 0.000     <i>(output)</i>
```



## 基准面转换到WGS84

基准面变换可以使用3参数空间变换(地心空间直角坐标系)，或7参数变换(平移 + 旋转 + 缩放)。可以使用`**towgs84**`参数来描述.

在三个参数的情况下，这三个参数转换以米为单位的地心坐标位置。

例如，下面演示了从希腊GGRS87基准变换到WGS84.

```text
# 源坐标系		+proj=latlong +ellps=GRS80 +towgs84=-199.87,74.79,246.62 
# 目标坐标系	+proj=latlong +datum=WGS84 s2cs +proj=latlong +ellps=GRS80
   +towgs84=-199.87,74.79,246.62 \  
   +to +proj=latlong +datum=WGS84 20 35 20d0'5.467"E    35d0'9.575"N 8.570
```

EPSG提供示例，使用近似7参数变换WGS72到WGS84。

```js
cs2cs +proj=latlong +ellps=WGS72 +towgs84=0,0,4.5,0,0,0.554,0.219\    
+to +proj=latlong +datum=WGS84 4 55 4d0'0.554"E     55d0'0.09"N 3.223
```

七参数情况下使用**`delta_x`, `delta_y`, `delta_z`, `Rx - rotation X`, `Ry - rotation Y`, `Rz - rotation Z`, `M_BF - Scaling`**。

三个平移参数是米单位，如同3参数情况。旋转参数是角秒(角度单位)。缩放值的百万分之一，是尺度变化值(实际缩放值=1.0+缩放因子/1000000)。

在3和7参数变换的更完整的讨论，可以在EPSG数据库中找到(trf_method的9603和9606)。在PROJ.4内，以下计算被用于`towgs84`变换(going to WGS84)。x、y和 z坐标是地心坐标.

三参数变换(simple offsets):

```text
x[io] = x[io] + defn->datum_params[0];   
y[io] = y[io] + defn->datum_params[1];   
z[io] = z[io] + defn->datum_params[2];
```

七参数变换(translation, rotation and scaling):

```text
#define Dx_BF (defn->datum_params[0]) 
#define Dy_BF (defn->datum_params[1]) 
#define Dz_BF (defn->datum_params[2]) 
#define Rx_BF (defn->datum_params[3]) 
#define Ry_BF (defn->datum_params[4]) 
#define Rz_BF (defn->datum_params[5]) 
#define M_BF  (defn->datum_params[6])    
x_out = M_BF*(       x[io] - Rz_BF*y[io] + Ry_BF*z[io]) + Dx_BF;   y_out = M_BF*( Rz_BF*x[io] +       y[io] - Rx_BF*z[io]) + Dy_BF;   z_out = M_BF*(-Ry_BF*x[io] + Rx_BF*y[io] +       z[io]) + Dz_BF;
```

**注意**EPSG方法9607(coordinate frame rotation)系数可以由PROJ.4通过对旋转参数取负数得到转换到EPSG方法9606 (position vector 7-parameter)支持。这些方法其他方面是相同的。


**这里实际的意思是，对于布尔沙模型的七参数（ArcGIS使用的也是），与这里使用的七参数（实际测试是DSNP+模型），在三个旋转参数上正负号是相反的。**

在许多地方(尤其是北美洲和澳大利亚)国家大地测量组织针对不同的基准(比如NAD27到NAD83之间进行转换)提供网格转换(gird shift)的文件。这些网格转换文件包括在每个网格位置上施加的偏移。实际上，网格位移通常是基于包含四个网格点之间的内插计算的。

PROJ.4当前支持在某些情况下使用网格转换文件在当前基准和WGS84直接转换。网格转换表的格式是ctable(使用PROJ.4 `nad2bin`程序生成二进制格式), NTv1 (旧的加拿大格式), and NTv2 (`.gsb`新的加拿大和澳大利亚格式).

网格变换的使用，是在坐标系统定义中指定`nadgrids`关键字时使用。例如:

```text
# +nadgrids=ntv1_can.dat 指定使用网格变换文件
% cs2cs +proj=latlong +ellps=clrk66 +nadgrids=ntv1_can.dat \   
  +to +proj=latlong +ellps=GRS80 +datum=NAD83 << EOF 
-111 50 EOF 111d0'2.952"W   50d0'0.111"N 0.000
```

在上面例子中，网格转换文件`/usr/local/share/proj/ntv1_can.dat`被加载，并用于获得选定的点进行网格转换后的值。

它可能列出多个网格转换文件，在这种情况下，将依次尝试每一个grid shift文件，直到找到包含被转换点的。

```text
cs2cs +proj=latlong +ellps=clrk66 \          
+nadgrids=conus,alaska,hawaii,stgeorge,stlrnc,stpaul \     
+to +proj=latlong +ellps=GRS80 +datum=NAD83 << EOF 
-111 44 EOF 111d0'2.788"W   
43d59'59.725"N 0.000
```

### **跳过丢失网格**

可选的特定前缀`@`可用于网格转换文件。如果它不存在，将继续搜索下一个网格。通常没有找到任何网格，将产生错误。例如,下面将使用`ntv2_0.gsb`文件(见 [[NonFreeGrids]]),如果不可以则回退使用`ntv1_can.dat`文件.

```js
cs2cs +proj=latlong +ellps=clrk66 +nadgrids=@ntv2_0.gsb,ntv1_can.dat \     
+to +proj=latlong +ellps=GRS80 +datum=NAD83 << EOF 
-111 50 
EOF 
111d0'3.006"W   50d0'0.103"N 0.000
```

### null网格

一个特殊的'''null'''网格转换文件在4.4.6(不含)版本后发布。这个文件给全世界提供一个零点(zero)转换。它可以添加在nadgrids文件列表的末尾，在你想在所有其它网格有效区域外的点施加一个零点转换的时候。通常情况下，如果要转换的点不在任何网格中，将发生错误。

```text
cs2cs +proj=latlong +ellps=clrk66 +nadgrids=conus,null \
    +to +proj=latlong +ellps=GRS80 +datum=NAD83 << EOF
-111 45 EOF 111d0'3.006"W   
50d0'0.103"N 0.000 

 cs2cs +proj=latlong +ellps=clrk66 +nadgrids=conus,null \     
+to +proj=latlong +ellps=GRS80 +datum=NAD83 << EOF 
-111 44 -111 55 EOF 111d0'2.788"W   
43d59'59.725"N 0.000 111dW   
55dN 0.000
```

## 轴定向

从PROJ 4.8.0开始,`+axis`可以用于控制坐标系的轴方向。默认的定向是"easting, northing, up"，但方向或轴可以翻转,使用`axes`组合在`+axis`切换。axes的值是:

- "e" - 东
- "w" - 西
- "n" - 北
- "s" - 南
- "u" - 上
- "d" - 下

它们与`+axis`结合的形式如下:

- `+axis=enu` - 默认的东、北、标高.
- `+axis=neu` - northing, easting, up - 针对"lat/long"地理坐标,或南向的横轴墨卡托很有用.
- `+axis=wnu` - westing, northing, up - 一些行星坐标系具有"west positive"坐标系统.

**注意**`+axis`参数只适用于通过`pj_transform()`进行坐标转换 (它可用于命令行程序`cs2cs`,但不用于proj).