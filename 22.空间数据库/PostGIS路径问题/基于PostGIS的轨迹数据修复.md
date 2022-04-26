- [基于PostGIS的轨迹数据修复](https://hanbo.blog.csdn.net/article/details/99733230)



目前有大量的共享单车数据，轨迹数据确是无序的，只有起点和终点坐标是正确的，中间的节点坐标是乱序的。因此需要对轨迹数据进行修复。考虑的效率和操作的方便，选择在Postgresql数据库中，利用PostGIS插件对轨迹进行修复。

## 现状

在postgresql中进行预览如下图所示：

![img](https://img-blog.csdnimg.cn/20190819160226655.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0dJU3V1c2Vy,size_16,color_FFFFFF,t_70)

可以看到中间的轨迹不仅混乱而且几乎没法看，不能称之为轨迹数据。

## 思路

因为起点和终点固定，中间点是乱序的。有的人说使用路网数据进行路线的计算。个人认为这种方法并不合适。原因有以下几点：

1. 轨迹点大部分不会正好落在路网上
2. 轨迹数据很难找到时期匹配的路网数据
3. 比较复杂，计算难度大
4. 节点是乱序的，无法计算任何两个点之间的路线

因为只能采用不太科学的办法，思路如下：

1. 首先计算除了终点之外，与起点最近的点
2. 计算与1的距离最近的点（起点和终点除外）
3. 计算与2的距离最近的点（起点、终点、1的结果除外）
4. 重复上面过程，直到没有选择的点还剩余1个，将剩余点作为倒数第二个点
5. 将点按照计算顺序重新拼接为线

## 代码

首先编写的脚本函数

```sql
CREATE OR REPLACE function repair_line(mline geometry) 
 
--限制返回类型
returns geometry as 
 
$body$  
declare
points geometry[];--线的节点
point_count integer;--点数
point_start geometry;--起点
point_end geometry;--终点
line geometry;--修复后的线

point_temp geometry;--临时点
temp_index integer;--临时点
temp_index_close integer;--最近点索引
temp_point_close geometry;--最近点索引
temp_point_current geometry;--当前点
distance1 float;--距离1
distance2 float;--距离2

turn integer;--第几轮
begin

select ST_NPoints(mline) into point_count;
--三个点以内直接返回
if(point_count < 4) then 
       return mline;
end if;
--取起点和终点
select ST_StartPoint(mline) into point_start;
select ST_EndPoint(mline) into point_end;
points[0]=point_start;
points[point_count-1]=point_end;
temp_point_current=point_start;


--移除起点和终点
select ST_RemovePoint(mline,(point_count-1)) into mline;
select ST_RemovePoint(mline,0) into mline;
--重新计算点数
point_count=point_count-2;

turn=1;
while point_count > 1 loop
	temp_index_close=0;
	temp_index=0;
	distance1=9999999999;
    while temp_index<point_count loop
       --raise notice '%', temp_index;
       select ST_Distance(temp_point_current,ST_PointN(mline,temp_index+1)) into distance2;
       if(distance2 < distance1) then
			distance1=distance2;									   
            temp_index_close=temp_index;
														
       end if;
    
       temp_index=temp_index+1;
    end loop;
	--取点													
	select ST_PointN(mline,temp_index_close+1) into temp_point_close;
	points[turn]=temp_point_close;
	raise notice '%', '加入点';	
	raise notice '%', turn;												   
	--拿最近点再去遍历													
	temp_point_current=temp_point_close;											   
	turn=turn+1;
	--移除上一个最近点
	  if(point_count > 2) then	
		select ST_RemovePoint(mline, temp_index_close) into mline;																									
       end if;												   
	--重新计算点数
     point_count=point_count-1;													
end loop;
													   
temp_index_close = 1-temp_index_close;													   
--取最后一个点														
select ST_PointN(mline,temp_index_close+1) into temp_point_close;
points[turn]=temp_point_close;
   raise notice '%', '加入点';	
	raise notice '%', turn;															
select ST_MakeLine(points) into line;
return line;

end; 
$body$
LANGUAGE plpgsql VOLATILE STRICT;	
```

然后调用这个脚本 

```sql
update public.travel set track=repair_line(track);
```

## 结果

运行之后的结果如下图所示：

![img](https://img-blog.csdnimg.cn/20190819161434129.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0dJU3V1c2Vy,size_16,color_FFFFFF,t_70)

可以看出来轨迹还是不是准确的，不过效果已经比修复之前的好很多了，可利用信息实在有限。