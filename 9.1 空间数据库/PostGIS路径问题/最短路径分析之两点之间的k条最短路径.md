- [最短路径分析之两点之间的k条最短路径](https://hanbo.blog.csdn.net/article/details/117166257)

## 前言

在用高德地图导航的时候都会发现，高德会推荐多条线路。我们之前做的dijkstra算法只能实现两点之间的1条最短路径的计算。dijkstra算法需要和yen算法结合，才能实现获取两点之间的k条最短路径。关于后面的数据准备有疑惑的，可以参考上篇博文[WebGIS开发之最短路径分析入门](https://blog.csdn.net/GISuuser/article/details/116720552?spm=1001.2014.3001.5501)

## Yen算法

> 首先利用Dijkstra算法求得从源节点到目的节点的第一条最短路径Q(1)。求接下来K-1条短路径时，采用递推法中的偏离路径算法思想。在求Q（i+1）时，将Q（1）上除了目的节点外的所有节点都视为偏离节点，并计算每个偏离节点到目的节点之间的最短路径，然后将其与Q（1）上的源节点到偏离节点的路径拼接到一起共同构成候选路径，从而求得最短偏离路径。

## 数据准备

数据准备和[WebGIS开发之最短路径分析入门](https://blog.csdn.net/GISuuser/article/details/116720552?spm=1001.2014.3001.5501)一样就可以，不需要做新的处理

## 求取k条最短路径（KSP）

PostGIS里调用ksp算法，计算从102号点到30号点的98条最短路线
 ![点位示意图](https://img-blog.csdnimg.cn/20210522172257217.png)

代码如下：

```sql
 SELECT  * FROM pgr_ksp('SELECT id,source,target,
                         length::double precision AS cost
                        FROM unimelb_edges',102, 30, 9,false)				
```

结果部分如下图：
 ![查询结果](https://img-blog.csdnimg.cn/2021052217235375.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0dJU3V1c2Vy,size_16,color_FFFFFF,t_70)

## 预览结果

利用下面代码可以同时查出点和线，在pgAdmin中进行进行预览

```sql
		select shp,id from unimelb_edges where id in (SELECT  edge FROM pgr_ksp('SELECT id,source,target,
                         length::double precision AS cost
                        FROM unimelb_edges',102, 30, 9,false))union select shp,id from unimelb_nodes where id in(102,30)	
```

查询结果如下图所示
 ![结果预览](https://img-blog.csdnimg.cn/20210522172523978.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0dJU3V1c2Vy,size_16,color_FFFFFF,t_70)