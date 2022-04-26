- [PostGIS算法示例](https://hanbo.blog.csdn.net/article/details/79102591)



# 点的最近点查询

```sql
select smoke, ST_AsGeoJSON(geom) as geom, company, address from power t order by ST_Distance(t.geom,ST_GeometryFromText('POINT(113.77990722656251 34.63320791137959)',4326))  limit 1
```

4326为坐标系编号；原理是根据距离找最近的一个记录
  

# 根据点在数据库里查询在哪个多边形中，11万条记录只需要94ms

```sql
SELECT * from dt_cy where ST_Contains(geom, st_geometryfromtext('POINT(113.458729 34.816974)',4326));																		   
```

# 使用knn(最近邻法)，计算距离多边形最近的点，测试结果174ms

```sql
select * from teatcyd ORDER BY teatcyd.geom <-> (SELECT geom from dt_cy where gid =74833) limit 1
```

# 创建索引（通用索引），添加后执行3直接变为100ms

```sql
CREATE INDEX teatcyd_geom_idx ON teatcyd USING GIST (shape);
```

