- [Java精准地图坐标转换 高德 百度 谷歌 腾讯 高德 批量转换工具类达到项目生产精度_lakernote的博客-CSDN博客](https://laker.blog.csdn.net/article/details/111667829)

## 前言

美国GPS使用的是`WGS84`的坐标系统，以经纬度的形式来表示地球平面上的某一个位置，这应该是`国际共识`。但在我国，**出于国家安全考虑**，**国内所有导航电子地图必须使用国家测绘局制定的加密坐标系统**，即将一个真实的经纬度坐标[加密](https://so.csdn.net/so/search?q=加密&spm=1001.2101.3001.7020)成一个不正确的经纬度坐标，我们在业内将前者称之为地球坐标，后者称之为火星坐标

## 主流坐标系介绍

现在互联网主要使用坐标系为以下三种：

**国际标准坐标 (WGS84)**

- 国际标准，从 GPS 设备中取出的数据的坐标系
- 国际地图提供商使用的坐标系

**火星坐标 (GCJ-02)也叫国测局坐标系**

- 中国标准，从国行移动设备中定位获取的坐标数据使用这个坐标系
- 国家规定： 国内出版的各种地图系统（包括电子形式），必须至少采用GCJ-02对地理位置进行首次加密。

**百度坐标 (BD-09)**

- 百度标准，百度 SDK，百度地图，Geocoding 使用
- 在GCJ-02基础上二次加密而成

### 从设备获取经纬度坐标

- gps设备一般采用的是WGS84，经纬度格式转换工具`CoordinateUtil`
- 如果使用的是百度sdk那么可以获得百度坐标（bd09）或者火星坐标（GCJ02),默认是bd09
- 如果使用的是ios的原生定位库，那么获得的坐标是WGS84
- 如果使用的是高德sdk,那么获取的坐标是GCJ02

### 互联网在线地图使用的坐标系

```
WGS84坐标系
```

- 谷歌国外地图
- osm地图等国外的地图

```
火星坐标系
```

- 高德地图
- 腾讯地图
- 谷歌国内地图

```
百度坐标系
```

- 百度地图

## 转换方式

| 方式          | 优点                         | 缺点                                                         |
| ------------- | ---------------------------- | ------------------------------------------------------------ |
| 各官网在线api | 转换结果准确                 | 有各种api调用限制，例如：频率，次数等                        |
| 算法工具类    | 无任何限制，想怎么用就怎么用 | 可能找的算法或者工具类不准；所以我找了很久并测试到了一个，nice |

### 1. 各官网在线[api](https://so.csdn.net/so/search?q=api&spm=1001.2101.3001.7020)

- 高德地图

https://lbs.amap.com/api/webservice/guide/api/convert

- 百度地图

https://lbsyun.baidu.com/index.php?title=webapi/guide/changeposition

- 腾讯地图

https://lbs.qq.com/service/webService/webServiceGuide/webServiceTranslate

### 2. 算法工具类

- 百度坐标（BD09）、国测局坐标（火星坐标，GCJ02）、和WGS84坐标系之间的转换的工具

```java
/**
 * 百度坐标（BD09）、国测局坐标（火星坐标，GCJ02）、和WGS84坐标系之间的转换的工具
 * 
 * @see 参考https://github.com/wandergis/coordtransform实现的Java版本
 * @author geosmart
 */
public class CoordinateTransformUtil {
	static double x_pi = 3.14159265358979324 * 3000.0 / 180.0;
	// π
	static double pi = 3.1415926535897932384626;
	// 长半轴
	static double a = 6378245.0;
	// 扁率
	static double ee = 0.00669342162296594323;

	/**
	 * 百度坐标系(BD-09)转WGS坐标
	 * 
	 * @param lng 百度坐标纬度
	 * @param lat 百度坐标经度
	 * @return WGS84坐标数组
	 */
	public static double[] bd09towgs84(double lng, double lat) {
		double[] gcj = bd09togcj02(lng, lat);
		double[] wgs84 = gcj02towgs84(gcj[0], gcj[1]);
		return wgs84;
	}

	/**
	 * WGS坐标转百度坐标系(BD-09)
	 * 
	 * @param lng WGS84坐标系的经度
	 * @param lat WGS84坐标系的纬度
	 * @return 百度坐标数组
	 */
	public static double[] wgs84tobd09(double lng, double lat) {
		double[] gcj = wgs84togcj02(lng, lat);
		double[] bd09 = gcj02tobd09(gcj[0], gcj[1]);
		return bd09;
	}

	/**
	 * 火星坐标系(GCJ-02)转百度坐标系(BD-09)
	 * 
	 * @see 谷歌、高德——>百度
	 * @param lng 火星坐标经度
	 * @param lat 火星坐标纬度
	 * @return 百度坐标数组
	 */
	public static double[] gcj02tobd09(double lng, double lat) {
		double z = Math.sqrt(lng * lng + lat * lat) + 0.00002 * Math.sin(lat * x_pi);
		double theta = Math.atan2(lat, lng) + 0.000003 * Math.cos(lng * x_pi);
		double bd_lng = z * Math.cos(theta) + 0.0065;
		double bd_lat = z * Math.sin(theta) + 0.006;
		return new double[] { bd_lng, bd_lat };
	}

	/**
	 * 百度坐标系(BD-09)转火星坐标系(GCJ-02)
	 * 
	 * @see 百度——>谷歌、高德
	 * @param lng 百度坐标纬度
	 * @param lat 百度坐标经度
	 * @return 火星坐标数组
	 */
	public static double[] bd09togcj02(double bd_lon, double bd_lat) {
		double x = bd_lon - 0.0065;
		double y = bd_lat - 0.006;
		double z = Math.sqrt(x * x + y * y) - 0.00002 * Math.sin(y * x_pi);
		double theta = Math.atan2(y, x) - 0.000003 * Math.cos(x * x_pi);
		double gg_lng = z * Math.cos(theta);
		double gg_lat = z * Math.sin(theta);
		return new double[] { gg_lng, gg_lat };
	}

	/**
	 * WGS84转GCJ02(火星坐标系)
	 * 
	 * @param lng WGS84坐标系的经度
	 * @param lat WGS84坐标系的纬度
	 * @return 火星坐标数组
	 */
	public static double[] wgs84togcj02(double lng, double lat) {
		if (out_of_china(lng, lat)) {
			return new double[] { lng, lat };
		}
		double dlat = transformlat(lng - 105.0, lat - 35.0);
		double dlng = transformlng(lng - 105.0, lat - 35.0);
		double radlat = lat / 180.0 * pi;
		double magic = Math.sin(radlat);
		magic = 1 - ee * magic * magic;
		double sqrtmagic = Math.sqrt(magic);
		dlat = (dlat * 180.0) / ((a * (1 - ee)) / (magic * sqrtmagic) * pi);
		dlng = (dlng * 180.0) / (a / sqrtmagic * Math.cos(radlat) * pi);
		double mglat = lat + dlat;
		double mglng = lng + dlng;
		return new double[] { mglng, mglat };
	}

	/**
	 * GCJ02(火星坐标系)转GPS84
	 * 
	 * @param lng 火星坐标系的经度
	 * @param lat 火星坐标系纬度
	 * @return WGS84坐标数组
	 */
	public static double[] gcj02towgs84(double lng, double lat) {
		if (out_of_china(lng, lat)) {
			return new double[] { lng, lat };
		}
		double dlat = transformlat(lng - 105.0, lat - 35.0);
		double dlng = transformlng(lng - 105.0, lat - 35.0);
		double radlat = lat / 180.0 * pi;
		double magic = Math.sin(radlat);
		magic = 1 - ee * magic * magic;
		double sqrtmagic = Math.sqrt(magic);
		dlat = (dlat * 180.0) / ((a * (1 - ee)) / (magic * sqrtmagic) * pi);
		dlng = (dlng * 180.0) / (a / sqrtmagic * Math.cos(radlat) * pi);
		double mglat = lat + dlat;
		double mglng = lng + dlng;
		return new double[] { lng * 2 - mglng, lat * 2 - mglat };
	}

	/**
	 * 纬度转换
	 * 
	 * @param lng
	 * @param lat
	 * @return
	 */
	public static double transformlat(double lng, double lat) {
		double ret = -100.0 + 2.0 * lng + 3.0 * lat + 0.2 * lat * lat + 0.1 * lng * lat + 0.2 * Math.sqrt(Math.abs(lng));
		ret += (20.0 * Math.sin(6.0 * lng * pi) + 20.0 * Math.sin(2.0 * lng * pi)) * 2.0 / 3.0;
		ret += (20.0 * Math.sin(lat * pi) + 40.0 * Math.sin(lat / 3.0 * pi)) * 2.0 / 3.0;
		ret += (160.0 * Math.sin(lat / 12.0 * pi) + 320 * Math.sin(lat * pi / 30.0)) * 2.0 / 3.0;
		return ret;
	}

	/**
	 * 经度转换
	 * 
	 * @param lng
	 * @param lat
	 * @return
	 */
	public static double transformlng(double lng, double lat) {
		double ret = 300.0 + lng + 2.0 * lat + 0.1 * lng * lng + 0.1 * lng * lat + 0.1 * Math.sqrt(Math.abs(lng));
		ret += (20.0 * Math.sin(6.0 * lng * pi) + 20.0 * Math.sin(2.0 * lng * pi)) * 2.0 / 3.0;
		ret += (20.0 * Math.sin(lng * pi) + 40.0 * Math.sin(lng / 3.0 * pi)) * 2.0 / 3.0;
		ret += (150.0 * Math.sin(lng / 12.0 * pi) + 300.0 * Math.sin(lng / 30.0 * pi)) * 2.0 / 3.0;
		return ret;
	}

	/**
	 * 判断是否在国内，不在国内不做偏移
	 * 
	 * @param lng
	 * @param lat
	 * @return
	 */
	public static boolean out_of_china(double lng, double lat) {
		if (lng < 72.004 || lng > 137.8347) {
			return true;
		} else if (lat < 0.8293 || lat > 55.8271) {
			return true;
		}
		return false;
	}
}
```

- 经纬度格式转换工具类

```java
/**
 * Created by liusj on 2019/5/27
 * <p>
 * 经纬度格式转换工具类.
 */
public class CoordinateUtil {

    /**
     * 经纬度转化，度分秒转度.
     * 如：108°13′21″= 108.2225
     * @param jwd
     * @return
     */
    public static String DmsTurnDD(String jwd) {
        if (Strings.isNotEmpty(jwd) && (jwd.contains("°"))) {//如果不为空并且存在度单位
            //计算前进行数据处理
            jwd = jwd.replace("E", "").replace("N", "").replace(":", "").replace("：", "");
            double d = 0, m = 0, s = 0;
            d = Double.parseDouble(jwd.split("°")[0]);
            //不同单位的分，可扩展
            if (jwd.contains("′")) {//正常的′
                m = Double.parseDouble(jwd.split("°")[1].split("′")[0]);
            } else if (jwd.contains("'")) {//特殊的'
                m = Double.parseDouble(jwd.split("°")[1].split("'")[0]);
            }
            //不同单位的秒，可扩展
            if (jwd.contains("″")) {//正常的″
                //有时候没有分 如：112°10.25″
                s = jwd.contains("′") ? Double.parseDouble(jwd.split("′")[1].split("″")[0]) : Double.parseDouble(jwd.split("°")[1].split("″")[0]);
            } else if (jwd.contains("''")) {//特殊的''
                //有时候没有分 如：112°10.25''
                s = jwd.contains("'") ? Double.parseDouble(jwd.split("'")[1].split("''")[0]) : Double.parseDouble(jwd.split("°")[1].split("''")[0]);
            }
            jwd = String.valueOf(d + m / 60 + s / 60 / 60);//计算并转换为string

        }
        return jwd;
    }

    /**
     * 经纬度转换，度分转度度.
     * 如：112°30.4128 = 112.50688
     */
    public static String DmTurnDD(String jwd) {
        jwd = jwd.replace("′", "");
        if (Strings.isNotEmpty(jwd) && (jwd.contains("°"))) {//如果不为空并且存在度单位
            double d = 0, m = 0;
            d = Double.parseDouble(jwd.split("°")[0]);
            m = Double.parseDouble(jwd.split("°")[1]) / 60;
            jwd = String.valueOf(d + m);
        }
        return jwd;
    }
}
```

## 验证

### WGS84转GCJ02

- [高德在线转换](https://lbs.amap.com/api/webservice/guide/api/convert)

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201225113725100.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2FidTkzNTAwOTA2Ng==,size_16,color_FFFFFF,t_70)

- 工具类`CoordinateTransformUtil`

```java
   double[] gcj02 = CoordinateTransformUtil.wgs84togcj02(116.481499, 39.990475);
   116.48758557081051,39.99175425467313
```

**结论：小数点后6位一致，在地图上是同一个点**。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201225113738220.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2FidTkzNTAwOTA2Ng==,size_16,color_FFFFFF,t_70)

### 百度坐标系(BD-09)转火星坐标系(GCJ-02)

- [高德在线转换](https://lbs.amap.com/api/webservice/guide/api/convert)

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201225113754964.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2FidTkzNTAwOTA2Ng==,size_16,color_FFFFFF,t_70)

- 工具类`CoordinateTransformUtil`

```java
double[] gcj02 = CoordinateTransformUtil.bd09togcj02(116.481499, 39.990475);

116.47489604504428,39.98471586964859
```

**结论：小数点后6位一致，在地图上是同一个点**。

### WGS坐标转百度坐标系(BD-09)

- [百度在线转换](http://api.map.baidu.com/geoconv/v1/?coords=114.21892734521,29.575429778924&from=1&to=5&ak=你的密钥)

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201225113910631.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2FidTkzNTAwOTA2Ng==,size_16,color_FFFFFF,t_70)

- 工具类`CoordinateTransformUtil`

```java
double[] gcj02 = CoordinateTransformUtil.wgs84tobd09(114.21892734521,29.575429778924);

114.23074697114104,29.5790799569647
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201225113946776.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2FidTkzNTAwOTA2Ng==,size_16,color_FFFFFF,t_70)

**结论：小数点后6位基本一致，在地图上是同一个点，这个误差非常非常小，可忽略不计**。

### 火星坐标系(GCJ-02)转百度坐标系(BD-09)

- [百度在线转换](http://api.map.baidu.com/geoconv/v1/?coords=114.21892734521,29.575429778924&from=1&to=5&ak=你的密钥)

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201225114012550.png)

- 工具类`CoordinateTransformUtil`

```java
double[] gcj02 = CoordinateTransformUtil.gcj02tobd09(114.21892734521,29.575429778924);
114.22539195427781,29.5815853675143
```

## 结论

这个工具类`CoordinateTransformUtil`非常的nice，能达到生产级别的准度。

**参考：**

https://github.com/wandergis/coordtransform

https://github.com/geosmart/coordtransform