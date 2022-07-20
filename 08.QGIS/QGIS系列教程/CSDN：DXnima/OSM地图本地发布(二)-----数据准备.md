- [OSM地图本地发布(二)-----数据准备_DXnima的博客-CSDN博客_osm2pgsql](https://blog.csdn.net/qq_40953393/article/details/120604270)

# 一、准备工作

1.安装[PostgreSQL](https://so.csdn.net/so/search?q=PostgreSQL&spm=1001.2101.3001.7020)+PostGIS，版本不限（推荐最新版本）安装教程：[Windows上安装](https://www.cnblogs.com/haolb123/p/14330532.html)、[Linux上安装](https://blog.csdn.net/qq_40953393/article/details/116203749)。

2.osm2pgsql工具，[下载地址](https://osm2pgsql.org/doc/install.html)。

3.安装[QGIS](https://so.csdn.net/so/search?q=QGIS&spm=1001.2101.3001.7020)，方便查看数据，[下载地址](https://www.qgis.org/en/site/forusers/download.html)。

# 二、具体步骤

### 1.windows安装osm2pgsql

下载地址：[Index of /download/windows (osm2pgsql.org)](https://osm2pgsql.org/download/windows/)

![img](https://img-blog.csdnimg.cn/20211004154949518.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

windows版解压即用：

![img](https://img-blog.csdnimg.cn/20211004155622338.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

### 2.下载OSM数据

​    1.下载全国数据量太大，以台湾省为例；下载地址：http://download.geofabrik.de/asia.html，下载.osm.pbf格式数据。

![img](https://img-blog.csdnimg.cn/20211004155411917.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

2.将下载后的数据放在osm2pgsql根目录下备用：

 ![img](https://img-blog.csdnimg.cn/20211004160227550.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

###  3.打开Postgres并创建数据库

 1.创建名为：taiwan数据库

![img](https://img-blog.csdnimg.cn/2021100416043326.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_17,color_FFFFFF,t_70,g_se,x_16)

 2.运行sql给该数据库添加扩展：

```sql
CREATE EXTENSION postgis;



CREATE EXTENSION hstore;
```

![img](https://img-blog.csdnimg.cn/2021100416104540.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_14,color_FFFFFF,t_70,g_se,x_16)

###  4.osm2pgsql导入数据到postgres

1.为了避免输入密码报错：ERROR: Cannot detect file format for 'XXXXX'. Try using -r

将postgres安装目录里的文件pg_hba.conf（文件路径：...\PostgreSQL\版本号\data）里面的md5，下图所示的两个md5改为trust：

![img](https://img-blog.csdnimg.cn/20211004161648649.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)



2.在osm2pgsql根目录打开cmd，运行命令：

```css
osm2pgsql -s -U postgres -H 127.0.0.1 -P 5432 -d taiwan --hstore --style default.style --tag-transform style.lua --cache 12000 taiwan-latest.osm.pbf
```

 注意：-U 用户名  -W 密码  -d 数据库名，其他命名参考[osm2pgsql常见命令](https://blog.csdn.net/diyuan365760/article/details/102213821)。

 3.等待导入完成：![img](https://img-blog.csdnimg.cn/20211004161845385.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

### ![img](https://img-blog.csdnimg.cn/20211004162347562.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)



###  5.查看数据

**1.**打开taiwan数据库查看数据表：

![img](https://img-blog.csdnimg.cn/20211004162443867.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

| 表名               | 说明             |
| ------------------ | ---------------- |
| planet_osm_point   | 点类型地理数据表 |
| planet_osm_line    | 线类型地理数据表 |
| planet_osm_polygon | 面类型地理数据表 |
| planet_osm_roads   | 路线地理数据表   |

所有图层数据都在这四张表里面，nodes\rels\ways为导入过程生成的中间表，可以删除。

**2.**使用QGIS连接Postgres数据库查看数据

![img](https://img-blog.csdnimg.cn/20211004163116430.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_18,color_FFFFFF,t_70,g_se,x_16)

**3.**连接成功QGIS会显示四个图层：

![img](https://img-blog.csdnimg.cn/20211004163223186.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)**4.**添加图层查看数据：

planet_osm_line：

![img](https://img-blog.csdnimg.cn/20211004163527606.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

planet_osm_point：

![img](https://img-blog.csdnimg.cn/20211004163539870.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)planet_osm_polygon：

![img](https://img-blog.csdnimg.cn/20211004163554610.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

planet_osm_roads：

![img](https://img-blog.csdnimg.cn/20211004163607118.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBARFhuaW1h,size_20,color_FFFFFF,t_70,g_se,x_16)

**到此数据准备完成，后面将对数据进行查询生成不同的地图图层。**