- [OpenLayer+Geoserver+postgis实现路径分析_HPUGIS的博客-CSDN博客_geoserver 路径分析](https://hpugis.blog.csdn.net/article/details/82970999)

关于做一些GIS的空间分析，我们有两种选择，一是选择geotools，二结合postgis，两者选一个即可，我发现postgis+geoserver组合，本质上还是通过geotools来实现的，废话不多说，进入正题

## 一、路网shapfile文件导入数据库

### 1、创建数据空间数据库

具体做法在这里不再叙述，网上有许多的教程关于空间数据创建

### 2、导入shapfile文件

![img](https://img-blog.csdn.net/2018100817443195?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MDE4NDI0OQ==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

选择插件中的PostGIS shapfile and DBF Loader工具，点击出现如下对话框：

![img](https://img-blog.csdn.net/20181008174734827?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MDE4NDI0OQ==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

 

点击Add File按钮添加，所要导入的shapfile文件（注意：这里存放shapfile文件的路径必须为纯英文，路径中不能含有汉字，SRD必须设置，这里我设置为4326）

在Options点选下面对号

![img](https://img-blog.csdn.net/2018100817512117?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MDE4NDI0OQ==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

注意最后一个复选框必须打勾，以此来生成LineString类型，否则无法进行路径规划。

### 3、查看导入数据

![img](https://img-blog.csdn.net/20181008175543158?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MDE4NDI0OQ==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

选中roa_4m表格，点击上面的按钮可以查看表格数据。

## 二、路径规划函数生成

### 1、添加字段、

```sql
--添加起点id
 
ALTER TABLE roa_4m ADD COLUMN source integer;
 
--添加终点id
 
ALTER TABLE roa_4m ADD COLUMN target integer;
 
--添加道路权重值
 
ALTER TABLE roa_4m ADD COLUMN length double precision;
```

2、创建拓扑结构

```sql
--为sampledata表创建拓扑布局，即为source和target字段赋值
 
SELECT pgr_createTopology('roa_4m',0.0001, 'geom', 'gid');
```

### 3、创建索引

```sql
--为source和target字段创建索引
 
CREATE INDEX source_idx ON roa_4m("source");
 
CREATE INDEX target_idx ON roa_4m("target");
 
 
ALTER TABLE roa_4m ADD COLUMN x1 double precision;		--创建起点经度x1
ALTER TABLE roa_4m ADD COLUMN y1 double precision;		--创建起点纬度y1
ALTER TABLE roa_4m ADD COLUMN x2 double precision;		--创建起点经度x2
ALTER TABLE roa_4m ADD COLUMN y2 double precision;		--创建起点经度y2
            
UPDATE roa_4m SET x1 =ST_x(ST_PointN(geom, 1));	
UPDATE roa_4m SET y1 =ST_y(ST_PointN(geom, 1));	
UPDATE roa_4m SET x2 =ST_x(ST_PointN(geom, ST_NumPoints(geom)));	
UPDATE roa_4m SET y2 =ST_y(ST_PointN(geom, ST_NumPoints(geom)));	--给x1、y1、x2、y2赋值
```

### 4、给索引赋值

```sql
--为length赋值
--设置为双向
update roa_4m set length =st_length(geom);
--将长度值赋给reverse_cost，作为路线选择标准
ALTER TABLE roa_4m ADD COLUMN reverse_cost double precision;
UPDATE roa_4m SET reverse_cost = st_length(geom);
```

### 5、路径函数的生成

```sql
-- Function: pgr_fromctod(character varying, double precision, double precision, double precision, double precision)
 
-- DROP FUNCTION pgr_fromctod(character varying, double precision, double precision, double precision, double precision);
 
CREATE OR REPLACE FUNCTION pgr_fromctod(
    tbl character varying,
    startx double precision,
    starty double precision,
    endx double precision,
    endy double precision)
  RETURNS geometry AS
$BODY$  
 
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
 
begin
 
    --查询离起点最近的线 
    --4326坐标系
    --找起点15米范围内的最近线
 
    execute 'select geom, source, target  from ' ||tbl||
 
                            ' where ST_DWithin(geom,ST_Geometryfromtext(''point('||startx ||' ' || starty||')'',4326),15)
                            order by ST_Distance(geom,ST_GeometryFromText(''point('|| startx ||' '|| starty ||')'',4326))  limit 1'
 
                            into v_startLine, v_startSource ,v_startTarget; 
 
     
 
    --查询离终点最近的线 
    --找终点15米范围内的最近线
 
    execute 'select geom, source, target from ' ||tbl||
 
                            ' where ST_DWithin(geom,ST_Geometryfromtext(''point('|| endx || ' ' || endy ||')'',4326),15)
                            order by ST_Distance(geom,ST_GeometryFromText(''point('|| endx ||' ' || endy ||')'',4326))  limit 1'
 
                            into v_endLine, v_endSource,v_endTarget; 
 
 
 
    --如果没找到最近的线，就返回null 
 
    if (v_startLine is null) or (v_endLine is null) then 
 
        return null; 
 
    end if ; 
 
 
 
    select  ST_ClosestPoint(v_startLine, ST_Geometryfromtext('point('|| startx ||' ' || starty ||')',4326)) into v_statpoint; 
 
    select  ST_ClosestPoint(v_endLine, ST_GeometryFromText('point('|| endx ||' ' || endy ||')',4326)) into v_endpoint; 
 
   
 
   -- ST_Distance 
 
     
 
    --从开始的起点到结束的起点最短路径
 
    execute 'SELECT st_linemerge(st_union(b.geom)) ' ||
    'FROM pgr_kdijkstraPath( 
    ''SELECT gid as id, source, target, length as cost FROM ' || tbl ||''',' 
 
    ||v_startSource|| ', ' ||'array['||v_endSource||'] , false, false 
    ) a, ' 
 
    ||tbl|| ' b 
    WHERE a.id3=b.gid   
    GROUP by id1   
    ORDER by id1' into v_res ;
 
   
 
    --从开始的终点到结束的起点最短路径
 
    execute 'SELECT st_linemerge(st_union(b.geom)) ' ||
 
    'FROM pgr_kdijkstraPath( 
    ''SELECT gid as id, source, target, length as cost FROM ' || tbl ||''',' 
 
    ||v_startTarget|| ', ' ||'array['||v_endSource||'] , false, false 
    ) a, ' 
 
    ||tbl|| ' b 
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
 
    --if(v_res is null) then 
 
    --    return null; 
 
    --end if; 
 
     
 
    --将v_res,v_startLine,v_endLine进行拼接 
 
    select  st_linemerge(ST_Union(array[v_res,v_startLine,v_endLine])) into v_res;
 
 
 
    select  ST_Line_Locate_Point(v_res, v_statpoint) into v_perStart; 
 
    select  ST_Line_Locate_Point(v_res, v_endpoint) into v_perEnd; 
 
        
 
    if(v_perStart > v_perEnd) then 
 
        tempnode =  v_perStart;
 
        v_perStart = v_perEnd;
 
        v_perEnd = tempnode;
 
    end if;
 
        
 
    --截取v_res 
    --拼接线
 
    SELECT ST_Line_SubString(v_res,v_perStart, v_perEnd) into v_shPath;
 
 
 
    return v_shPath; 
 
 
 
end; 
 
$BODY$
  LANGUAGE plpgsql VOLATILE STRICT
  COST 100;
ALTER FUNCTION pgr_fromctod(character varying, double precision, double precision, double precision, double precision)
  OWNER TO postgres;
```

（上面函数是不是不知道怎么定义，基本套路在这里[postgresql存储过程](https://www.yiibai.com/postgresql/postgresql-functions.html)）生成后的函数，可以在public中函数中查看。

## 三、PostGIS连接Geoserver发布数据，以及发布视图

### 1、geoserver连接postgis

点击数据存储---->添加新的数据存储

![img](https://img-blog.csdn.net/20181008181939108?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MDE4NDI0OQ==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

选择新建数据源 点击postgis

![img](https://img-blog.csdn.net/20181008182104807?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MDE4NDI0OQ==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

j将红线框选中部分，填写

![img](https://img-blog.csdn.net/20181008182426930?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MDE4NDI0OQ==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

数据名称--->要连接的数据库名称----->用户名------->密码------->保存

### 2、发布roa_4m表格为服务

点击图层----->添加新的资源----新建图层（下拉框中选择刚才上面所间的资源）

![img](https://img-blog.csdn.net/20181008183504104?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MDE4NDI0OQ==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

 

选择我们在postgis中数据表，点击发布即可

![img](https://img-blog.csdn.net/20181008184039819?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MDE4NDI0OQ==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

### 3、创建sql视图

方法和上述发布roa_4m表格类似，只不过在一步，选择 配置新的SQL视图。

![img](https://img-blog.csdn.net/20181008184538741?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MDE4NDI0OQ==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

编辑视图

1）填写视图名称（自己自定义）

2)SQL语句

```perl
select * from pgr_fromctod('roa_4m',%x1%, %y1%, %x2%, %y2%)
```

3）点击从SQL猜想的参数，D的默认值，全部为0，验证的正则表达式全部为^-?[\d.]+$

4）点击刷新，类型选为LineString类型，SRD为4326

5）点击保存，然后发布

![img](https://img-blog.csdn.net/20181008185703861?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MDE4NDI0OQ==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 四、OL调用demo

```javascript
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>室内路径规划</title>
    <link href="../script/ol4/ol.css" rel="stylesheet" />
    <style>
        #id {
            width:1000px;
            height:1000px;
        }
    </style>
    <script src="../script/ol4/ol.js"></script>
</head>
<body>
    <div id="map"></div>
    <script>
 
        var roadLayer = new ol.layer.Tile({
            source: new ol.source.TileWMS({
                url: 'http://localhost:8080/geoserver/cite/wms',
                params: { 'LAYERS': 'cite:roa_4', 'TILED': true },
                serverType: 'geoserver'
            })
        })
        var map = new ol.Map({
            target: document.getElementById("map"),
            layers: [ 
                roadLayer
            ],
            view: new ol.View({
                center: [117.34211730957, 49.6271781921387],
                projection: 'EPSG:4326',
                zoom: 4
            })
        });
        var startCoord = [117.34211730957, 49.6271781921387]
        var destCoord = [127.216133117676, 45.7485237121582]
        var params = {
            LAYERS: 'cite:testSqlView',
            FORMAT: 'image/png',
        };
        var viewparams = [
            'x1:' + startCoord[0], 'y1:' + startCoord[1],
            'x2:' + destCoord[0], 'y2:' + destCoord[1]
            //'x1:' + 12952117.2529, 'y1:' + 4836395.5717,
            //'x2:' + 12945377.2585, 'y2:' + 4827305.7549
        ];
        console.log(viewparams);   
        params.viewparams = viewparams.join(';');
        result = new ol.layer.Image({
            source: new ol.source.ImageWMS(
                {
                    url: 'http://localhost:8080/geoserver/cite/wms',
                    params: params
                })
        });
        console.info(result);
        map.addLayer(result);
    </script>
</body>
</html>
```

## 五、效果图（蓝色线段）

![img](https://img-blog.csdn.net/20181008191801389?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MDE4NDI0OQ==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

 