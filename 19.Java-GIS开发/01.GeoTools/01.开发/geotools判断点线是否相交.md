- [geotools 判断点线是否相交_码路漫漫，上下求索的博客-CSDN博客](https://blog.csdn.net/weixin_42598269/article/details/112871534)

## 主要的maven依赖

```xml
<dependency>
  <groupId>org.locationtech</groupId>
  <artifactId>jts</artifactId>
  <version>1.13</version>
</dependency>
```

## 代码实现

```java
// 工厂
GeometryFactory geometryFactory = JTSFactoryFinder.getGeometryFactory();
// WKTReader 
WKTReader reader = new WKTReader(geometryFactory);
// 线对象
Geometry line = reader.read("LINESTRING(120 40,120 20)");
// 点对象
Geometry point = reader.read("POINT(120 30)");
// 是否相交
boolean intersects = line.intersects(point);
System.out.println(intersects);
```

## 常用的空间关系函数

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210120144721681.jpg?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjU5ODI2OQ==,size_16,color_FFFFFF,t_70)
[点击跳转geotools官方链接](http://docs.geotools.org/stable/userguide/library/jts/index.html)