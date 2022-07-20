- [OSM地图本地发布(三)-----自定义图层提取_DXnima的博客-CSDN博客_osm地图](https://blog.csdn.net/qq_40953393/article/details/120605543)

# 一、准备工作

1.完成数据准备[OSM本地发布(二)-----数据准备](https://blog.csdn.net/qq_40953393/article/details/120604270)

2.推荐使用**Navicat**操作数据库

3.下文是在《[在GeoServer中为OpenStreetMap数据设置OSM样式](https://www.cnblogs.com/think8848/p/6013939.html)》基础上的改进，可直接看该文实现图层发布

# 二、OSM字段说明

​    planet_osm_line,planet_osm_point,planet_osm_polygon和planet_osm_roads四个数据表中字段**官方说明文档：**https://wiki.openstreetmap.org/wiki/Zh-hans:Map_Features；以下为对部分字段的整理。

### 1.**共有字段**

| 字段名 | 说明               |
| ------ | ------------------ |
| osm_id | 主键               |
| way    | 存储的地理数据     |
| name   | 属性名称           |
| tags   | 标签，属性描述信息 |

### **2.道路相关字段**

官方详细说明文档：[Map Features - OpenStreetMap highway](https://wiki.openstreetmap.org/wiki/Zh-hans:Map_Features#.E5.85.AC.E8.B7.AF)

| 字段名称          | 字段取值                                                 | 说明                             |
| ----------------- | -------------------------------------------------------- | -------------------------------- |
| highway           | motorway                                                 | 国家级/省级高速公路。            |
| trunk             | 国道/城市快速路。                                        |                                  |
| primary           | 省道/主干道。                                            |                                  |
| motorway_link     | 其他公路通往高速公路的连接道路，高速公路之间的连接匝道。 |                                  |
| trunk_link        | 连接国道/快速路与其他国道/快速路或更低级道路的连接路。   |                                  |
| primary_link      | 连接省道/主干道与其他省道/主干道或更低级道路的连接路。   |                                  |
| proposed          | 规划道路（未建成道路）。                                 |                                  |
| construction      | 在建道路。                                               |                                  |
| motorway_junction | 指定高速公路出口，一般标记在出口匝道与主线的分流处。     |                                  |
| services          | 服务区。通常位于高速公路或快速公路上                     |                                  |
| barrier           | toll_booth                                               | 一个收取道路使用费或费用的地点。 |

### **3.水路相关字段**

官方详细说明文档：[Map Features - OpenStreetMap waterway](https://wiki.openstreetmap.org/wiki/Zh-hans:Map_Features#Waterway)

| 字段名称  | 字段取值                                                   | 说明                         |
| --------- | ---------------------------------------------------------- | ---------------------------- |
| waterway  | river                                                      | 河流的线性流动，在流动的方向 |
| riverbank | 河流的水域覆盖区域                                         |                              |
| canal     | 人工"开放式流动"水道用于输送有用的水用于运输、供水或灌溉。 |                              |
| fairway   | 湖或海中的通航路线，通常以浮标或信标为标志。               |                              |

### **4.铁路相关字段**

官方详细说明文档：[Map Features - OpenStreetMap railway](https://wiki.openstreetmap.org/wiki/Zh-hans:Map_Features#.E9.93.81.E8.B7.AF)

| 字段名称         | 字段取值                                | 说明                                                        |
| ---------------- | --------------------------------------- | ----------------------------------------------------------- |
| railway          | construction                            | 在建铁路。                                                  |
| disused          | 废弃铁路，路基、铁轨还没有被拆除。      |                                                             |
| rail             | 在该国标准轨距上的全尺寸旅客或货物列车  |                                                             |
| station          | 火车站                                  |                                                             |
| bridge           | yes                                     | 桥梁                                                        |
| electrified      | contact_line/rail/yes/no                | 架空电力线/第三轨供电/电气化，但是供电方式不详/非电气化铁路 |
| service          | siding                                  | 侧线，长度较短的轨道，并行(及连接)于主线。                  |
| spur             | 专用线，长度较短，连接企业、厂矿。      |                                                             |
| yard             | 站线，车站内的线路。                    |                                                             |
| usage            | main/branch/industrial/military/tourism | 铁路主要用途(主线/支线/工业/军事/旅游)                      |
| public_transport | station                                 | 铁路客运专站。                                              |

### **5.设施相关字段**

官方详细说明文档：[Map Features - OpenStreetMap amenity](https://wiki.openstreetmap.org/wiki/Zh-hans:Map_Features#.E8.AE.BE.E6.96.BD.28Amenity.29)

| 字段名称 | 字段取值                                                 | 说明                                          |
| -------- | -------------------------------------------------------- | --------------------------------------------- |
| amenity  | ferry_terminal                                           | 渡轮站/渡轮码头，渡轮停靠站可供人和车辆上船。 |
| townhall | 市政厅，乡，镇，市等地方政府的办公大楼，或者是社区公所。 |                                               |

### **6.土地类型相关字段**

官方详细说明文档：[Map Features - OpenStreetMap landuse](https://wiki.openstreetmap.org/wiki/Zh-hans:Map_Features#.E5.9C.9F.E5.9C.B0.E5.88.A9.E7.94.A8)

| 字段名称     | 字段取值                             | 说明         |
| ------------ | ------------------------------------ | ------------ |
| landuse      | commercial                           | 商业办公用地 |
| construction | 建筑工地                             |              |
| education    | 主要用于教育目的/设施的区域。        |              |
| industrial   | 工业用地，包括工厂、车间和仓储用地。 |              |
| residential  | 居住区。                             |              |
| forest       | 林业用地。                           |              |
| railway      | 铁路用地，一般不对公众开放。         |              |
| reservoir    | 水库                                 |              |

### **7.线路相关字段**

官方详细说明文档：[Map Features - OpenStreetMap route](https://wiki.openstreetmap.org/wiki/Zh-hans:Map_Features#.E8.B7.AF.E7.BA.BF)

| 字段名称 | 字段取值 | 说明                               |
| -------- | -------- | ---------------------------------- |
| route    | ferry    | 渡轮从两端来回行驶的线路。（航线） |

### **8.边界相关字段**

官方详细说明文档：[Map Features - OpenStreetMap boundary](https://wiki.openstreetmap.org/wiki/Zh-hans:Map_Features#Boundary)

| 字段名称 | 字段取值                                         | 说明       |
| -------- | ------------------------------------------------ | ---------- |
| boundary | administrative                                   | 行政边界。 |
| maritime | 不是行政边界的海洋边界：基线、毗连区和专属经济区 |            |

### **9.地区相关字段**

官方详细说明文档：[Map Features - OpenStreetMap place](https://wiki.openstreetmap.org/wiki/Zh-hans:Map_Features#Place)

| 字段名称 | 字段取值                                 | 说明                    |
| -------- | ---------------------------------------- | ----------------------- |
| place    | country                                  | 国家高级政治/行政区域。 |
| province | 省                                       |                         |
| county   | 县                                       |                         |
| city     | 市                                       |                         |
| suburb   | 城镇或城市的一部分，有一个众所周知的名字 |                         |
| borough  | 大城市的一部分被归入行政单位。           |                         |
| town     | 一个重要的城市中心，在村庄和城市之间     |                         |

# **三、执行sql语句生成不同图层的表**

# **注意：默认生成图层的坐标系：EPSG:3857**

这里以生成简易地图为例，图层主要包括：建筑物、地名、道路、河流、水域等。

### 表 1 建筑物面图层(building)

| 字段名   | 类型 | 是否不为空 | 说明           |
| -------- | ---- | ---------- | -------------- |
| name     | text | 否         | 名称           |
| building | text | 否         | 建筑物类型     |
| aeroway  | text | 否         | 航空相关建筑物 |

```sql
DROP TABLE IF EXISTS "building";
CREATE TABLE "building" AS (
		SELECT "name",way,building,aeroway
		FROM planet_osm_polygon
		WHERE
		( "building" IS NOT NULL AND "building" != 'no' )
		OR "aeroway" = 'terminal' 
		OR "waterway" = 'dam' 
		OR man_made = 'pier'
		ORDER BY z_order ASC
);
CREATE INDEX "building_way_idx" ON "building" USING gist (way);
```

### 表 2 全国行政地名点图层(placenames_medium)

| 字段名  | 类型 | 是否不为空 | 说明                                                         |
| ------- | ---- | ---------- | ------------------------------------------------------------ |
| name    | text | 否         | 名称                                                         |
| place   | text | 否         | 地名行政等级类型：state首都/city城市/ferry港口码头/small_town村庄、乡/large_town街道、办事处/town镇 |
| capital | text | 否         | 城市分类：3首都/4省会城市/5二级城市/6城市各区                |
| amenity | text | 否         | 其他属性                                                     |

```sql
DROP TABLE IF EXISTS "placenames_medium";
CREATE TABLE "placenames_medium" AS ( 
  SELECT
	   (CASE WHEN "name" = '澳門 Macau' THEN '澳门'
        WHEN "name" = '香港 Hong Kong' THEN '香港'
        ELSE "name" END) as "name",
	   way,
		 (CASE WHEN "amenity" = 'ferry_terminal' THEN 'ferry'
        ELSE place END) as place,
		(CASE WHEN capital = 'yes' and name = '北京市' THEN '3'
        WHEN capital = 'yes' and name <> '北京市' THEN '4'
				WHEN capital = '3' and name <> '北京市' THEN null
				WHEN name in ('澳門 Macau', '香港 Hong Kong') and place = 'city' THEN '4'
        ELSE capital END) as capital,
        amenity 
  FROM planet_osm_point
  WHERE place IN ('state','city','metropolis','town','large_town','small_town') AND osm_id <> '8899974086' OR amenity = 'ferry_terminal'
);
CREATE INDEX "placenames_medium_way_idx" ON "placenames_medium" USING gist (way);
```

### 表 3 道路线图层(route_line)

| 字段名  | 类型     | 是否不为空 | 说明                     |
| ------- | -------- | ---------- | ------------------------ |
| osm_id  | int8(64) | 否         | 主键id                   |
| name    | text     | 否         | 道路名称                 |
| highway | text     | 否         | 道路类型                 |
| aeroway | text     | 否         | 航空道路类型             |
| oneway  | text     | 否         | 是否单向道路：yes是      |
| tunnel  | text     | 否         | 是否为隧道：yes是/no不是 |

```sql
DROP TABLE IF EXISTS "route_line";
CREATE TABLE "route_line" AS ( 
  SELECT osm_id,"name",way,
	  (CASE WHEN route = 'ferry' THEN	'ferry' 
		 ELSE highway END) AS highway,
		 aeroway,
	  CASE WHEN oneway IN ('yes','true','1') THEN 'yes'::text END AS oneway,
    case when tunnel IN ( 'yes', 'true', '1' ) then 'yes'::text
      else 'no'::text end as tunnel,
    case when service IN ( 'parking_aisle',
      'drive_through','driveway' ) then 'INT_minor'::text
      else service end as service
  FROM planet_osm_line
  WHERE highway IS NOT NULL
  OR "aeroway" IN ('apron','runway','taxiway')
  OR route = 'ferry'
  ORDER BY z_order
);
CREATE INDEX "route_line_way_idx" ON "route_line" USING gist (way);
```

### 表 4 河流线图层(river)

| 字段名   | 类型 | 是否不为空 | 说明                |
| -------- | ---- | ---------- | ------------------- |
| name     | text | 否         | 名称                |
| natural  | text | 否         | 自然或人工河流      |
| landuse  | text | 否         | 土地利用类型        |
| waterway | text | 否         | 水路类型：river河流 |

```sql
DROP TABLE IF EXISTS "river";
CREATE TABLE "river" AS ( 
  SELECT 
	(CASE WHEN name in ('金沙江','长江','扬子江') THEN '长江'
		WHEN name in ('黄河','རྨ་ཆུ། 玛曲','黄河 济南市—德州市界') THEN '黄河'
		WHEN name in ('喀拉额尔齐斯河','喀拉额尔齐斯河;额尔齐斯河','Джалгызагат-Хэ') THEN '额尔齐斯河'
		ELSE "name" END) as "name" ,
	"natural", "landuse", "waterway", "way"
  FROM planet_osm_line
  WHERE "waterway" IN ('river','riverbank')
  ORDER BY z_order asc
);
CREATE INDEX "river_idx" ON "river" USING gist (way);
```

### 表 5 水域边界线图层(water_outline)

| 字段名   | 类型 | 是否不为空 | 说明                                                         |
| -------- | ---- | ---------- | ------------------------------------------------------------ |
| name     | text | 否         | 名称                                                         |
| natural  | text | 否         | 水域类型：water水域                                          |
| landuse  | text | 否         | 土地利用类型：reservoir蓄水池/basin盆地/grass草地            |
| waterway | text | 否         | 水路类型：stream自然流动水路/river河流/canal运河/riverbank河岸/fish_pass/drain下水道 |
| water    | text | 否         | 河流类型                                                     |

```sql
DROP TABLE IF EXISTS "water_outline";
CREATE TABLE "water_outline" AS ( 
  SELECT "name","natural", "landuse", "waterway",  "water", "way"
  FROM planet_osm_line
  WHERE "natural" IN ('lake','water')
  OR "waterway" IN ('canal','mill_pond','river','riverbank')
  OR "landuse" IN ('basin','reservoir','water')
  ORDER BY z_order asc
);
CREATE INDEX "water_outline_way_idx" ON "water_outline" USING gist (way);
```

### 表 6 水域面图层(water)

| 字段名   | 类型 | 是否不为空 | 说明                                                         |
| -------- | ---- | ---------- | ------------------------------------------------------------ |
| name     | text | 否         | 名称                                                         |
| natural  | text | 否         | 水域类型：hot_spring温泉/lake湖泊/shingle河滨海滨/water水域/wetland湿地 |
| landuse  | text | 否         | 土地利用类型                                                 |
| waterway | text | 否         | 水路类型                                                     |
| water    | text | 否         | 系列水域名称                                                 |

```sql
DROP TABLE IF EXISTS "water";
CREATE TABLE "water" AS ( 
  SELECT "name","natural", "landuse", "waterway",  "water", "way"
  FROM planet_osm_polygon
  WHERE "natural" IN ('lake','water')
  OR "waterway" IN ('canal','mill_pond','river','riverbank')
  OR "landuse" IN ('basin','reservoir','water')
  ORDER BY z_order asc
);
CREATE INDEX "water_way_idx" ON "water" USING gist (way);
```

### 完整SQL:

```sql
DROP TABLE IF EXISTS "building";
CREATE TABLE "building" AS (
		SELECT "name",way,building,aeroway
		FROM planet_osm_polygon
		WHERE
		( "building" IS NOT NULL AND "building" != 'no' )
		OR "aeroway" = 'terminal' 
		OR "waterway" = 'dam' 
		OR man_made = 'pier'
		ORDER BY z_order ASC
);
CREATE INDEX "building_way_idx" ON "building" USING gist (way);
 
 
DROP TABLE IF EXISTS "placenames_medium";
CREATE TABLE "placenames_medium" AS ( 
  SELECT
	   (CASE WHEN "name" = '澳門 Macau' THEN '澳门'
        WHEN "name" = '香港 Hong Kong' THEN '香港'
        ELSE "name" END) as "name",
	   way,
		 (CASE WHEN "amenity" = 'ferry_terminal' THEN 'ferry'
        ELSE place END) as place,
		(CASE WHEN capital = 'yes' and name = '北京市' THEN '3'
        WHEN capital = 'yes' and name <> '北京市' THEN '4'
				WHEN capital = '3' and name <> '北京市' THEN null
				WHEN name in ('澳門 Macau', '香港 Hong Kong') and place = 'city' THEN '4'
        ELSE capital END) as capital,
        amenity 
  FROM planet_osm_point
  WHERE place IN ('state','city','metropolis','town','large_town','small_town') AND osm_id <> '8899974086' OR amenity = 'ferry_terminal'
);
CREATE INDEX "placenames_medium_way_idx" ON "placenames_medium" USING gist (way);
 
DROP TABLE IF EXISTS "route_line";
CREATE TABLE "route_line" AS ( 
  SELECT osm_id,"name",way,
	  (CASE WHEN route = 'ferry' THEN	'ferry' 
		 ELSE highway END) AS highway,
		 aeroway,
	  CASE WHEN oneway IN ('yes','true','1') THEN 'yes'::text END AS oneway,
    case when tunnel IN ( 'yes', 'true', '1' ) then 'yes'::text
      else 'no'::text end as tunnel,
    case when service IN ( 'parking_aisle',
      'drive_through','driveway' ) then 'INT_minor'::text
      else service end as service
  FROM planet_osm_line
  WHERE highway IS NOT NULL
  OR "aeroway" IN ('apron','runway','taxiway')
  OR route = 'ferry'
  ORDER BY z_order
);
CREATE INDEX "route_line_way_idx" ON "route_line" USING gist (way);
 
DROP TABLE IF EXISTS "river";
CREATE TABLE "river" AS ( 
  SELECT 
	(CASE WHEN name in ('金沙江','长江','扬子江') THEN '长江'
		WHEN name in ('黄河','རྨ་ཆུ། 玛曲','黄河 济南市—德州市界') THEN '黄河'
		WHEN name in ('喀拉额尔齐斯河','喀拉额尔齐斯河;额尔齐斯河','Джалгызагат-Хэ') THEN '额尔齐斯河'
		ELSE "name" END) as "name" ,
	"natural", "landuse", "waterway", "way"
  FROM planet_osm_line
  WHERE "waterway" IN ('river','riverbank')
  ORDER BY z_order asc
);
CREATE INDEX "river_idx" ON "river" USING gist (way);
 
DROP TABLE IF EXISTS "water_outline";
CREATE TABLE "water_outline" AS ( 
  SELECT "name","natural", "landuse", "waterway",  "water", "way"
  FROM planet_osm_line
  WHERE "natural" IN ('lake','water')
  OR "waterway" IN ('canal','mill_pond','river','riverbank')
  OR "landuse" IN ('basin','reservoir','water')
  ORDER BY z_order asc
);
CREATE INDEX "water_outline_way_idx" ON "water_outline" USING gist (way);
 
DROP TABLE IF EXISTS "water";
CREATE TABLE "water" AS ( 
  SELECT "name","natural", "landuse", "waterway",  "water", "way"
  FROM planet_osm_polygon
  WHERE "natural" IN ('lake','water')
  OR "waterway" IN ('canal','mill_pond','river','riverbank')
  OR "landuse" IN ('basin','reservoir','water')
  ORDER BY z_order asc
);
CREATE INDEX "water_way_idx" ON "water" USING gist (way);
```

### 执行上述SQL语句生成不同图层。

# 四、QGIS查看图层

![img](https://img-blog.csdnimg.cn/20211004204655252.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

 到此地图雏形基本显现，但直观看上去很乱，后面将对其进行样式调节并发布到Geoserver中。