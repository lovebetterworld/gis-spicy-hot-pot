- [GeoTools jts java 构建线的缓冲区 判断点在面内_小杨丿的博客-CSDN博客](https://blog.csdn.net/qq_39425958/article/details/88837473)

java部分代码：

```java
package com.jeeplus.modules.zzbdapp.web.patrol;
import com.vividsolutions.jts.geom.Coordinate;
import com.vividsolutions.jts.geom.Geometry;
import com.vividsolutions.jts.geom.GeometryFactory;
import com.vividsolutions.jts.operation.buffer.BufferOp;
import com.vividsolutions.jts.algorithm.PointLocator;
/**
 * @Author: ys
 * @Date: 2019-03-27 9:51
 */
 
public class GeoTest {
    public static void main(String[] args) {
        //创建一条直线
        Coordinate[] coordinates4 = new Coordinate[] {
                new Coordinate(116.664496,40.387171),
                new Coordinate(116.663463,40.387158),
        };
 
        GeometryFactory gf=new GeometryFactory();
        Geometry gfLineString = gf.createLineString(coordinates4);
        double degree = 10 / (2*Math.PI*6371004)*360;
        //缓冲区建立
        BufferOp bufOp = new BufferOp(gfLineString);
        bufOp.setEndCapStyle(BufferOp.CAP_BUTT);
        Geometry bg = bufOp.getResultGeometry(degree);
        System.out.println("缓冲区---"+bg);
        //点是否在多边形内判断
        Coordinate point = new Coordinate(116.663609,40.387187);
        PointLocator a=new PointLocator();
        boolean p1=a.intersects(point, bg);
        if(p1)
            System.out.println("point1:"+"该点在多边形内"+p1);
        else
            System.out.println("point1:"+"该点不在多边形内"+p1);
    }
}
```

打印输出的结果：

![img](https://img-blog.csdnimg.cn/20190327100425555.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NDI1OTU4,size_16,color_FFFFFF,t_70)

将结果的缓冲区坐标填充jsp即可。

需要注意的是：bufOp.setEndCapStyle(BufferOp.CAP_BUTT);是生成的缓冲区样式类型。一共分三种：

![img](https://img-blog.csdnimg.cn/20190327100615129.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NDI1OTU4,size_16,color_FFFFFF,t_70)

double degree = 10 / (2*Math.PI*6371004)*360;是将度换算成米，公式为：degree = meter / (2 * Math.PI * 6371004) * 360

因为使用Geometry bg = bufOp.getResultGeometry（参数）里面的参数不是距离单位，而是一个度数单位，具体我也不清楚了。这里是同事帮忙解决的。

最终结果如下：

![img](https://img-blog.csdnimg.cn/20190327100930672.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NDI1OTU4,size_16,color_FFFFFF,t_70)