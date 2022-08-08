- [手写GIS二三维地理空间几何计算GeoTools工具类_洛阳泰山的博客-CSDN博客_geotools 包](https://blog.csdn.net/weixin_40986713/article/details/123088384)

目前工具类提供的方法有：

1. polylineDivide 折线等分方法，就是把线段分成若干相等的点，求出分割点的坐标。
2. pointAlong 根据某点占比线段的比例，求出该点的坐标。
3. onLineSegment 判断点是否在线段上
4. onLine 判断点是否在一条直线上
5. midPoint 求线段中心点坐标
6. nearestLineSegment 求距离目标点最近的线段
7. distance 求某点到线段的距离 和 某点到某点的距离
8. closestPoint 求目标点 ，距离线段上的最近点
9. project 求目标点 在线段上的投影点
10. projectionFactor 求目标点 在线段上的投影的投影系数
11. 相对坐标转换
12. 巴比伦左边转换

**pom文件引入第三方jar包**

```XML
<dependency>
    <groupId>org.geotools</groupId>
    <artifactId>gt-main</artifactId>
    <version>24.3</version>
</dependency>
```

 **gis空间几何计算工具类代码（二维的计算，z坐标传0即可）**

```java

import org.geotools.geometry.jts.GeometryBuilder;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.LineSegment;
import org.locationtech.jts.geom.LineString;
import org.locationtech.jts.geom.Point;
 
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
 
/**
 *
 *  原jts里的很多方法都是基于2d计算的，重写了部分方法按照3d计算
 *
 * @version 1.0
 * @since JDK1.8
 * @author tarzan
 */
public class GeoTools {
 
 
    /**
     * 方法描述:  折线等分
     *
     * @param p0  起点
     * @param p1  终点
     * @param num 等分数
     * @throws
     * @Return {@link List< Coordinate>}
     * @author tarzan
     * @date 2022年02月22日 14:11:09
     */
    public static List<Coordinate> polylineDivide (Coordinate p0, Coordinate p1, int num) {
        double factor=1.0D/num;
        int points=num-1;
        List<Coordinate> coordinates = new ArrayList<>(points);
        for (int i = 0; i < points; i++) {
            coordinates.add(pointAlong(p0,p1,factor*(i+1)));
        }
        return coordinates;
    }
 
    /**
     * 方法描述: 线段比例点坐标计算
     *
     * @param p0
     * @param p1
     * @param factor
     * @return {@link Coordinate}
     * @throws
     * @author tarzan
     * @date 2022年02月23日 13:49:52
     */
    public static Coordinate pointAlong(Coordinate p0,Coordinate p1,double factor) {
        Coordinate coord = new Coordinate();
        coord.x = p0.x + factor * (p1.x - p0.x);
        coord.y = p0.y + factor * (p1.y - p0.y);
        coord.z = p0.y + factor * (p1.z - p0.z);
        return coord;
    }
 
    /**
     * 方法描述:  判断点是否在线段上
     *
     * @param p     给定点
     * @param p0 线段开始点坐标
     * @param p1   线段结束点坐标
     * @Return {@link boolean}
     * @author tarzan
     * @date 2022年02月20日 16:51:49
     */
    public static boolean onLineSegment (Coordinate p, Coordinate p0, Coordinate p1) {
        double total = distance(p0, p1);
        double toStart = distance(p, p0);
        double toEnd = distance(p, p1);
        double diff = total - toEnd - toStart;
        return diff==0;
    }
    /**
     * 方法描述:  判断点是否在一条直线上
     *
     * @param p     给定点
     * @param p0 线段开始点坐标
     * @param p1   线段结束点坐标
     * @Return {@link boolean}
     * @author tarzan
     * @date 2022年02月22日 16:51:49
     */
    public static boolean onLine(Coordinate p, Coordinate p0, Coordinate p1) {
        double lsLen = distance(p0, p1);
        double toStart = distance(p, p0);
        double toEnd = distance(p, p1);
        double diff = lsLen - toEnd - toStart;
        if(diff==0) {
            return true;
        }
        diff = toEnd - toStart - lsLen;
        if(diff==0) {
            return true;
        }
        diff = toStart - toEnd - lsLen;
        if(diff==0) {
            return true;
        }
        return false;
    }
 
 
    /**
     * 方法描述: 线段中间点
     *
     * @param p0
     * @param p1
     * @return {@link Coordinate}
     * @throws
     * @author tarzan
     * @date 2022年02月23日 09:33:01
     */
    public static Coordinate midPoint(Coordinate p0, Coordinate p1) {
        return new Coordinate((p0.x + p1.x) / 2.0D, (p0.y + p1.y) / 2.0D, (p0.z + p1.z) / 2.0D);
    }
 
 
 
    /**
     * 方法描述:  点与点的距离
     *
     * @param p0
     * @param p1
     * @return {@link double}
     * @throws
     * @author tarzan
     * @date 2022年02月23日 09:30:03
     */
    public static double distance(Coordinate p0,Coordinate p1) {
        return p0.distance3D(p1);
    }
 
    /**
     * 方法描述:  转换点坐标
     *
     * @param x
     * @param y
     * @param z
     * @return {@link Coordinate}
     * @throws
     * @author tarzan
     * @date 2022年02月22日 10:35:28
     */
    public static Coordinate getCoordinate(BigDecimal x, BigDecimal y, BigDecimal z){
        if(x==null){
            x=BigDecimal.ZERO;
        }
        if(y==null){
            y=BigDecimal.ZERO;
        }
        if(z==null){
            z=BigDecimal.ZERO;
        }
        Coordinate coordinate=new Coordinate(x.doubleValue(),y.doubleValue(),z.doubleValue());
        return coordinate;
    }
 
    /**
     * 方法描述: 线段角度 (基于xy的二维角度)
     *
     * @param p0
     * @param p1
     * @return {@link double}
     * @throws
     * @author tarzan
     * @date 2022年02月24日 14:14:33
     */
    public static double angle(Coordinate p0,Coordinate p1){
        LineSegment ls=new LineSegment(p0,p1);
        return ls.angle();
    }
 
    /**
     * 方法描述: 移动点
     *
     * @param p
     * @param angle
     * @param distance
     * @return {@link Coordinate}
     * @throws
     * @author tarzan
     * @date 2022年02月24日 14:14:49
     */
    public static Coordinate movePoint(Coordinate p,double angle,double distance){
        double sin=Math.sin(angle);
        Double a= distance*sin;
        double cos=Math.cos(angle);
        Double b= distance*cos;
        return new Coordinate(p.x+b.floatValue(),p.y+a.floatValue());
    }
 
 
    /**
     * 方法描述: 获取点离多段线最近的线及投影点
     *
     * @param
     * @return LineSegment
     * @auther tarzan
     * @date 2022年02月28日 14:09:10
     */
    public static LineSegment nearestLineSegment(Coordinate p, List<LineSegment> lines) {
        double distance = Double.MAX_VALUE;
        LineSegment result = null;
        for (LineSegment ls : lines) {
            double distance2 = distance(p, ls.p0, ls.p1);
            distance = Double.min(distance, distance2);
            if (distance2 <= distance) {
                result = ls;
            }
        }
        return result;
    }
 
    /**
     * 方法描述: 点到线的距离
     *
     * @param p
     * @param p0
     * @param p1
     * @return {@link double}
     * @throws
     * @author tarzan
     * @date 2022年02月23日 09:21:13
     */
    public static double distance(Coordinate p, Coordinate p0, Coordinate p1) {
        GeometryBuilder builder = new GeometryBuilder();
        Point point = builder.pointZ(p.x, p.y, p.z);
        LineString ls = builder.lineStringZ(p0.x, p0.y, p0.z, p1.x, p1.y, p1.z);
        return point.distance(ls);
    }
 
    /**
     * 方法描述:  点与线段上的最近点计算
     *
     * @param p  给定点
     * @param p0 起始点
     * @param p1 结束点
     * @throws
     * @Return {@link Coordinate}
     * @author tarzan
     * @date 2021年08月03日 18:01:42
     */
    public static Coordinate closestPoint(Coordinate p, Coordinate p0, Coordinate p1) {
        double factor = projectionFactor(p, p0, p1);
        if (factor > 0.0D && factor < 1.0D) {
            return project(p, p0, p1);
        } else {
            double dist0 = p0.distance3D(p);
            double dist1 = p1.distance3D(p);
            return dist0 < dist1 ? p0 : p1;
        }
    }
 
    /**
     * 方法描述: 点在线上的投影点
     *
     * @param p
     * @param p0
     * @param p1
     * @return {@link org.locationtech.jts.geom.Coordinate}
     * @throws
     * @author tarzan
     * @date 2022年02月23日 09:25:31
     */
    public static Coordinate project(Coordinate p, Coordinate p0, Coordinate p1) {
        if (!p.equals3D(p0) && !p.equals3D(p1)) {
            double r = projectionFactor(p, p0, p1);
            Coordinate coord = new Coordinate();
            coord.x = p0.x + r * (p1.x - p0.x);
            coord.y = p0.y + r * (p1.y - p0.y);
            coord.z = p0.z + r * (p1.z - p0.z);
            return coord;
        } else {
            return new Coordinate(p);
        }
    }
 
    /**
     * 方法描述:  投影系数
     *
     * @param p
     * @param p0
     * @param p1
     * @return {@link double}
     * @throws
     * @author tarzan
     * @date 2022年02月23日 09:26:33
     */
    private static double projectionFactor(Coordinate p, Coordinate p0, Coordinate p1) {
        if (p.equals3D(p0)) {
            return 0.0D;
        } else if (p.equals3D(p1)) {
            return 1.0D;
        } else {
            double dx = p1.x - p0.x;
            double dy = p1.y - p0.y;
            double dz = p1.z - p0.z;
            double len = dx * dx + dy * dy+ dz * dz;
            if (len == 0.0D) {
                return 0.0D / 0.0;
            } else {
                double r = ((p.x - p0.x) * dx + (p.y - p0.y) * dy+ + (p.z - p0.z) * dz) / len;
                return r;
            }
        }
    }
 
    public static void main(String[] args) {
        System.out.println(0.0D / 0.0);
    }
 
 
    /**
     * 方法描述:  转相对坐标
     *
     * @param p 坐标点
     * @param baseP 基准点
     * @return {@link Coordinate}
     * @throws
     * @author tarzan
     * @date 2022年04月22日 10:05:31
     */
    private static Coordinate relativeCoordinate(Coordinate p, Coordinate baseP) {
        double x=p.getX()-baseP.getX();
        double y=p.getY()-baseP.getY();
        double z=p.getZ()-baseP.getZ();
        return new Coordinate(x,y,z);
    }
 
    /**
     * 方法描述: 转巴比伦坐标
     *
     * @param p
     * @param baseP
     * @return {@link Coordinate}
     * @throws
     * @author tarzan
     * @date 2022年04月22日 10:06:03
     */
    private static Coordinate babylonCoordinate(Coordinate p, Coordinate baseP) {
        Coordinate p0=relativeCoordinate(p,baseP);
        p0.setX(-p0.getX());
        p0.setY(p0.getZ());
        p0.setZ(-p0.getY());
        return  p0;
    }
}
```