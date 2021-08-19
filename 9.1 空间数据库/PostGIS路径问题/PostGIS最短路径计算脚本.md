- [PostGIS最短路径计算脚本](https://hanbo.blog.csdn.net/article/details/86649930)



这个路径导航计算脚本从前面的室内路径导航的脚本上修改而来，将室内楼层序号去掉，导航结果分为三段，分别为起点到路网连线、路线连线、路网到终点连线。脚本如下：

```sql
-- DROP FUNCTION pgr_road(character varying, double precision, double precision, double precision, double precision);

CREATE OR REPLACE FUNCTION pgr_road(
	tbl character varying,
	startx double precision,
	starty double precision,
	endx double precision,
	endy double precision,
	OUT linetype integer,
	OUT geom geometry)
    RETURNS SETOF record 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE STRICT 
    ROWS 1000
AS $BODY$  
 
  
 
declare 

 
    v_startLine geometry;--离起点最近的线 
 
    v_endLine geometry;--离终点最近的线 
 
     
 
    v_startTarget integer;--距离起点最近线的终点
 
    v_startSource integer;
 
    v_endSource integer;--距离终点最近线的起点
 
    v_endTarget integer;
 
 
 
    v_statpoint geometry;--在v_startLine上距离起点最近的点 
 
    v_endpoint geometry;--在v_endLine上距离终点最近的点 
 
     
 
    v_res geometry;--最短路径分析结果
 
    v_res_a geometry;
 
    v_res_b geometry;
 
    v_res_c geometry;
 
    v_res_d geometry; 
 
 
 
    v_perStart float;--v_statpoint在v_res上的百分比 
 
    v_perEnd float;--v_endpoint在v_res上的百分比 
 
 
 
    v_shPath_se geometry;--开始到结束
 
    v_shPath_es geometry;--结束到开始
 
    v_shPath geometry;--最终结果
 
    tempnode float;  
    
    startpoint geometry;
    endpoint geometry;
 
    v_shPath1 geometry;--一次结果
    v_shPath2 geometry;--二次结果
    star_line geometry; --起点到最近点的线
    end_line geometry; --终点到最近点的线
    geoARR geometry[];
    
    geoType integer[];
    
  
    
    ii integer;
 
begin
 

    --查询离起点最近的线 
    --4326坐标系
    --找起点15米范围内的最近线
 
    execute 'select geom, source, target  from ' ||tbl||
 
                            ' where ST_DWithin(geom,ST_Geometryfromtext(''point('||         startx ||' ' || starty||')'',4326),15000)
                             order by ST_Distance(geom,ST_GeometryFromText(''point('|| startx ||' '|| starty ||')'',4326))  limit 1'
 
                            into v_startLine, v_startSource ,v_startTarget; 
 
raise notice '%',  v_startSource;
raise notice '%', v_startTarget;
 
    --查询离终点最近的线 
    --找终点15米范围内的最近线
 
    execute 'select geom, source, target from ' ||tbl||
 
                            ' where ST_DWithin(geom,ST_Geometryfromtext(''point('|| endx || ' ' || endy ||')'',4326),15000) 
                           
                            order by ST_Distance(geom,ST_GeometryFromText(''point('|| endx ||' ' || endy ||')'',4326))  limit 1'
 
                            into v_endLine, v_endSource,v_endTarget; 
raise notice '%',  v_endSource;
raise notice '%', v_endTarget;
 
 
    --如果没找到最近的线，就返回null 
 
    if (v_startLine is null) or (v_endLine is null) then 
 
        return; 
 
    end if ; 
 
 
 
    select  ST_ClosestPoint(v_startLine, ST_Geometryfromtext('point('|| startx ||' ' || starty ||')',4326)) into v_statpoint; 
 
    select  ST_ClosestPoint(v_endLine, ST_GeometryFromText('point('|| endx ||' ' || endy ||')',4326)) into v_endpoint; 
 
   
 
   -- ST_Distance 
 
     
 
    --从开始的起点到结束的起点最短路径
 
    execute 'SELECT st_linemerge(st_union(b.geom)) ' ||
 
    'FROM pgr_kdijkstraPath( 
    ''SELECT gid as id, source, target, length as cost FROM ' || tbl ||''',' 
 
    ||v_startSource || ', ' ||'array['||v_endSource||'] , false, false 
    ) a, ' 
 
    || tbl || ' b 
    WHERE a.id3=b.gid   
    GROUP by id1   
    ORDER by id1' into v_res ;
 
   
 
    --从开始的终点到结束的起点最短路径
 
    execute 'SELECT st_linemerge(st_union(b.geom)) ' ||
 
    'FROM pgr_kdijkstraPath( 
    ''SELECT gid as id, source, target, length as cost FROM ' || tbl ||''',' 
 
    ||v_startTarget || ', ' ||'array['||v_endSource||'] , false, false 
    ) a, ' 
 
    || tbl || ' b 
    WHERE a.id3=b.gid   
    GROUP by id1   
    ORDER by id1' into v_res_b ;
 
 
 
    --从开始的起点到结束的终点最短路径
 
    execute 'SELECT st_linemerge(st_union(b.geom)) ' ||
 
    'FROM pgr_kdijkstraPath( 
    ''SELECT gid as id, source, target, length as cost FROM ' || tbl ||''',' 
 
    ||v_startSource || ', ' ||'array['||v_endTarget||'] , false, false 
    ) a, ' 
 
    || tbl || ' b 
    WHERE a.id3=b.gid   
    GROUP by id1   
    ORDER by id1' into v_res_c ;
 
 
 
    --从开始的终点到结束的终点最短路径
 
    execute 'SELECT st_linemerge(st_union(b.geom)) ' ||
 
    'FROM pgr_kdijkstraPath( 
    ''SELECT gid as id, source, target, length as cost FROM ' || tbl ||''',' 
 
    ||v_startTarget || ', ' ||'array['||v_endTarget||'] , false, false 
    ) a, ' 
 
    || tbl || ' b 
    WHERE a.id3=b.gid   
    GROUP by id1   
    ORDER by id1' into v_res_d ;
 
 
 
    if(ST_Length(v_res) > ST_Length(v_res_b)) then
 
       v_res = v_res_b;
 
    end if;
 
   
 
    if(ST_Length(v_res) > ST_Length(v_res_c)) then
 
       v_res = v_res_c;
 
    end if;
 
   
 
    if(ST_Length(v_res) > ST_Length(v_res_d)) then
 
       v_res = v_res_d;
 
    end if;
 
             
 
 
 
    --如果找不到最短路径，就返回null 
 
    if(v_res is null) then 
 
        return; 
 
    end if; 
 
     
 
    --将v_res,v_startLine,v_endLine进行拼接 
 
    select  st_linemerge(ST_Union(array[v_res,v_startLine,v_endLine])) into v_res;
 
    --return v_res;
 
    select  ST_LineLocatePoint(v_res, v_statpoint) into v_perStart; 
 
    select  ST_LineLocatePoint(v_res, v_endpoint) into v_perEnd; 
 
        
 
    if(v_perStart > v_perEnd) then 
 
        tempnode =  v_perStart;
 
        v_perStart = v_perEnd;
 
        v_perEnd = tempnode;
 
    end if;
 
        
 
    --截取v_res 
    --拼接线
 
    SELECT ST_Line_SubString(v_res,v_perStart, v_perEnd) into v_shPath1;
 
 --接下来进行
 --找线的端点

   select ST_SetSRID( ST_MakePoint(startx , starty),4326 )into startpoint;
 select ST_SetSRID( ST_MakePoint(endx , endy),4326 )into endpoint;
 select ST_MakeLine( v_statpoint,startpoint) into star_line; 
 select ST_MakeLine( v_endpoint,endpoint) into end_line; 

 

geoARR :=array[end_line,v_shPath1,star_line];
geoType :=array[1,2,1];

    FOR ii IN 1..3 Loop 
 
    lineType:=geoType[ii];
    geom:=geoARR[ii];
    raise notice '%', '返回数据';
    return next;
    end loop;
 return;
 
end; 
 
$BODY$;

ALTER FUNCTION pgr_road(character varying, double precision, double precision, double precision, double precision)
    OWNER TO postgres;
```

这个脚本可用于GeoServer也可以用于直接后台请求PostgreSQL数据库使用的计算效果如下：

![img](https://img-blog.csdnimg.cn/20190125174753691.png)