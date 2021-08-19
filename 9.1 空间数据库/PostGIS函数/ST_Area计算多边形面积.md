- [使用PostGIS的ST_Area函数计算多边形面积](https://hanbo.blog.csdn.net/article/details/104730199)

## 问题

最近遇到了一个很奇怪的问题，是使用ST_Area计算出的面积特别小。

 

```
select st_area(
ST_SetSRID(ST_GeomFromText(
'POLYGON ((115.440261 33.8547281, 115.4400647 33.8548702, 
115.4403265 33.8549768, 115.4404674 33.8549267, 115.4404397 33.8547365, 
115.440261 33.8547281))'),4326))
```

- 计算结果

  ![img](https://imgconvert.csdnimg.cn/aHR0cHM6Ly91cGxvYWQtaW1hZ2VzLmppYW5zaHUuaW8vdXBsb2FkX2ltYWdlcy8xOTg1Mzc1NC0wZWU1MTk5MWEyZWVlZTJiLnBuZw?x-oss-process=image/format,png)

   

  发现计算出的结果是一个特备小的值，明显是不正确的。

## 原因

最后查看官方文档

> Synopsis
>  float ST_Area(geometry g1);
>  float ST_Area(geography geog, boolean use_spheroid=true);
>  Description
>  Returns the area of a polygonal geometry. For geometry types a 2D  Cartesian (planar) area is computed, with units specified by the SRID.  For geography types by default area is determined on a spheroid with  units in square meters. To compute the area using the faster but less  accurate spherical model use

可以看出st_area必须在以米为单位的坐标系中才能计算中准确的面积，WGS84(4326)是以度为单位，所以这个函数计算出来的面积才会特别小，需要使用**st_transform**将几何体转换到以米为单位的坐标系中，这里我准备使用2000坐标系，因为在我国的平面计算精准还比较精准

## 改进后计算方法

 

```
select st_area(st_transform(
ST_SetSRID(ST_GeomFromText(
'POLYGON ((115.440261 33.8547281, 115.4400647 33.8548702, 
115.4403265 33.8549768, 115.4404674 33.8549267, 115.4404397 33.8547365, 
115.440261 33.8547281))'),4326),4527))
```

![img](https://imgconvert.csdnimg.cn/aHR0cHM6Ly91cGxvYWQtaW1hZ2VzLmppYW5zaHUuaW8vdXBsb2FkX2ltYWdlcy8xOTg1Mzc1NC05MDhiMzlhZWQ4MmIwZDJjLnBuZw?x-oss-process=image/format,png)

 