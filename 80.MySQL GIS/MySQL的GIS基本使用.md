> MySQL的GIS基础使用方法。

```bash
# 插入空间数据
INSERT INTO `t_pot` VALUES ('1', '北京', POINT(116.401394,39.916042));
INSERT INTO `t_pot` VALUES ('2', '广州', ST_GEOMFROMTEXT('POINT(113.295701 23.008163)'));

#查询
SELECT pot FROM t_pot
SELECT ST_ASTEXT(pot) FROM t_pot

# ST_Distance_Sphere 两点的直线距离：米
SELECT ST_Distance_Sphere(POINT(113.950339,22.54387),POINT(113.295701,23.008163))

# st_distance返回的距离不是米
SELECT st_distance (POINT (1, 1),POINT(2,2) ) * 111195 

# 添加空间索引
ALTER TABLE t_pot ADD SPATIAL INDEX(pot);

# 文本转化为空间数据
SELECT ST_GEOMFROMTEXT("POINT(1 2)")
# 空间数据字符串化
SELECT ST_ASTEXT(POINT(1,2))
SELECT ST_ASTEXT(ST_GEOMFROMTEXT("POINT(1 2)"))

# 经纬度转geoHash
SELECT st_geohash(POINT(113.295701,23.008163),8)
```



