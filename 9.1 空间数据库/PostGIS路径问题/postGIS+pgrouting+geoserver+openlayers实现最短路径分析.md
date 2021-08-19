- [postGIS+pgrouting+geoserver+openlayers实现最短路径分析](https://hanbo.blog.csdn.net/article/details/78625246)

最短路径分析原理阐述：将路网数据存储在postgresql中，构建拓扑，使用pgrouting写出一个查询最短路径的功能函数，在GeoServer中配置sqlview图层，调用前面发布的函数，客户端访问WMS服务，同时将起点终点坐标作为参数传过去，GeoServer就可以返回最短路径瓦片图层，叠加在当前地图就可以了。

效果图如下：

![img](https://img-blog.csdn.net/20171124154359020?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvR0lTdXVzZXI=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)
 

首先需要在postgresql创建空间数据库，存储空间数据；

在数据库运行如下代码



```sql
CREATE EXTENSION postgis;
CREATE EXTENSION pgrouting;
CREATE EXTENSION postgis_topology;
CREATE EXTENSION fuzzystrmatch;
CREATE EXTENSION postgis_tiger_geocoder;
CREATE EXTENSION address_standardizer;
```


 然后利用PostGIS自带数据导入插件将线数据ShapFile文件导入空间数据库




 

处理数据，添加拓扑关系



```sql
--roa_4m为表名

--source为线表起点字段名称
--target为线表终点字段名称
--source和target可以在导入数据库前直接先自己定义
--如果不自己定义起点终点，则自动生成起点和终点点号
ALTER TABLE roa_4m ADD COLUMN "source" integer;
ALTER TABLE roa_4m ADD COLUMN "target" integer;

--创建拓扑
SELECT pgr_createTopology('roa_4m', 0.00001, 'geom', 'gid');

--为起点号终点号加空间索引
CREATE INDEX source_idx ON roa_4m("source");
CREATE INDEX target_idx ON roa_4m("target");

--添加长度字段、并计算赋值
ALTER TABLE road_line ADD COLUMN length double precis;
update road_line set length =st_length(geom);

--将长度值赋给reverse_cost，作为路线选择标准
ALTER TABLE roa_4m ADD COLUMN reverse_cost double precision;
UPDATE roa_4m SET reverse_cost = length;
```


 通过下面代码可以通过起点号、终点号计算经过的路径编号





```sql
--通过起点号、终点号查询最短路径
--source为线表起点字段名称
--target为线表终点字段名称
--起点终点前后顺序无固定要求
--length为长度字段，也可以使用自己的评价体系
--1、9为测试使用起点号\终点号
--roa_4m路网表名
--id1经过节点号
--id2经过路网线的gid
SELECT seq, id1 AS node, id2 AS edge, cost FROM pgr_dijkstra('
                SELECT  gid AS id,
                         source::integer,
                         target::integer,
                         length::double precision AS cost
                        FROM roa_4m',
                1, 9, false, false);
```


 输出结果 ![img](https://img-blog.csdn.net/20180115190947216)




 

在数据库里输入建立脚本函数


 



```sql
--删除已存在的函数
DROP FUNCTION pgr_fromAtoB(tbl varchar,startx float, starty float,endx float,endy float);

--tbl路网表名
--startx起点经度
--starty起点纬度
--endx终点经度
--endy终点纬度
CREATE OR REPLACE function pgr_fromAtoB(tbl varchar,startx float, starty float,endx float,endy float) 
 
--限制返回类型
returns geometry as 

$body$  

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

                            ' where ST_DWithin(geom,ST_Geometryfromtext(''point('||         startx ||' ' || starty||')'',4326),15)

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

$body$ 

LANGUAGE plpgsql VOLATILE STRICT;
```







在GeoServer里添加存储数据的数据库为数据源，并设置SQL视图

![img](https://img-blog.csdn.net/20180115191606978)
 

然后在Openlayer请求这个地图服务，核心代码如下：



```javascript
var params = {
  LAYERS: 'indoor:test',
  FORMAT: 'image/png'
};
var result;
var startPoint;
var destPoint;
var vectorLayer;

function initMap() {
  startPoint = new ol.Feature();
  destPoint = new ol.Feature();

	// The vector layer used to display the "start" and "destination" features.
	vectorLayer = new ol.layer.Vector({
		source: new ol.source.Vector({
		features: [startPoint, destPoint]
		}),
		style:new ol.style.Style({
			image:new ol.style.Icon(({
				size:[24,36],
				anchor:[0.5,0.75],
				anchorXUnits:'fraction',
				anchorYUnits:'fraction',
				src:'marker.png'
			}))
		})
	});
	map.addLayer(vectorLayer);
	map.on('click', clickMap);
	
	//清空路径规划结果
	var clearButton = document.getElementById('clear');
	clearButton.addEventListener('click', function(event) {
		// Reset the "start" and "destination" features.
    clearResult();
  });
}

function clearResult() {
	startPoint.setGeometry(null);
	destPoint.setGeometry(null);
	// Remove the result layer.
	map.removeLayer(result);
}

function clickMap(event) {
  if (startPoint.getGeometry() != null && destPoint.getGeometry() != null) {
    clearResult();  
  }

	if (startPoint.getGeometry() == null) {
    // First click.
    startPoint.setGeometry(new ol.geom.Point(event.coordinate));
    console.info(event.coordinate);
  } else if (destPoint.getGeometry() == null) {
    // Second click.
    destPoint.setGeometry(new ol.geom.Point(event.coordinate));
    console.info(event.coordinate);
    // Transform the coordinates from the map projection (EPSG:3857)
    // to the server projection (EPSG:4326).
    var startCoord = (startPoint.getGeometry().getCoordinates());
    var destCoord = (destPoint.getGeometry().getCoordinates());
    var viewparams = [
      'x1:' + startCoord[0], 'y1:' + startCoord[1],
      'x2:' + destCoord[0], 'y2:' + destCoord[1]
        ,'fnumber:4'
	  //'x1:' + 113.557656, 'y1:' + 34.825177,
      //'x2:' + 113.557901, 'y2:' + 34.825086
    ];
    console.log(viewparams);
    params.viewparams = viewparams.join(';');
    result = new ol.layer.Image({
      source: new ol.source.ImageWMS({
        url: ServerUrl + '/geoserver/indoor/wms',
        params: params
      })
    });
        console.info(result);
    map.addLayer(result);
  }
}
```


 最后的结果就是上图了