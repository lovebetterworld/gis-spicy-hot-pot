- [GeoServer发布数据库中的空间数据表](https://blog.csdn.net/xtfge0915/article/details/85136797)

实际工作中，数据存储在本地的情况应该不多，大多数都是存储在数据库中，那么Geoserver如何以数据库作为数据源发布地图服务呢，GeoServer支持绝大多数主流的空间数据库，比如PostGIS、H2、ArcSDE、DB2、MySQL、Oracle、Microsoft SQL Server 等。下面以PostGIS为例，说明GeoServer以空间数据库作为数据源发布地图服务的过程

# 1.矢量数据发布

## (1) 将数据存储到PostGis中

如果创建一个PostGIS数据库就不提了，PostGIS提供了导入shp数据的工具shp2pgsql，使用方法可以参考这篇文章：
[PostGIS导入矢量数据和栅格数据](https://blog.csdn.net/xtfge0915/article/details/85097575)

```plsql
shp2pgsql -s 3587 -c -W 'gbk' China_province.shp China_province | sudo -u postgres psql -d test
shp2pgsql -s 3587 -c  -W 'gbk' weather_station.shp China_weather_station | sudo -u postgres psql -d test
raster2pgsql -s 4326 -I -C -M China_dem -F -t 256x256 China_dem | sudo -u postgres psql -d test
```

这里在数据库中存储了两个矢量数据，一个栅格数据。

##  (2) 从postgis创建stores

 选择Stores ‣ Add a new store ‣PostGIS

![在这里插入图片描述](https://img-blog.csdnimg.cn/20181219152225890.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h0ZmdlMDkxNQ==,size_16,color_FFFFFF,t_70)

参数配置完成后点击save保存后就可以看到数据库中所有数据。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20181219162842580.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h0ZmdlMDkxNQ==,size_16,color_FFFFFF,t_70)

## (3)发布数据

 选择要发布的数据点击Publish，发布过程和从文件发布数据没有区别。

## (4)在openlayers中预览

![在这里插入图片描述](https://img-blog.csdnimg.cn/20181219152846726.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h0ZmdlMDkxNQ==,size_16,color_FFFFFF,t_70)

ps：也可以创建stores完成后直接发布
另外，GeoServer也可以发布PostGIS中的视图(View)，和发布数据表(Table）没有区别，但是要求这个视图必须在geometry_columns中。如果没有需要手动创建。

```plsql
INSERT INTO geometry_columns VALUES ('','public','my_view','my_geom', 2, 4326, 'POINT' );
```

# 2.栅格数据发布

利用GeoServer发布栅格数据比较麻烦，需要用到`Image Mosaic JDBC`插件，直接在下图中对China_dem点Publish是不可以的，如果可以，我希望永远也不要用GeoServer发布PostGis中的栅格数据。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20181219162842580.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h0ZmdlMDkxNQ==,size_16,color_FFFFFF,t_70)

下面的内容翻译自官方文档，有任何疑问请参考[GeoServer官网原](https://docs.geoserver.org/stable/en/user/data/raster/imagemosaicjdbc.html)文

## 2.1 安装Image Mosaic JDBC扩展

(1)下载`Image Mosaic JDBC`包

```bash
wget https://sourceforge.net/projects/geoserver/files/GeoServer/2.14.1/extensions/geoserver-2.14.1-imagemosaic-jdbc-plugin.zip
```

版本一定要匹配，这里下载的是针对GeoServer 2.14.1的扩展，其它版本请去[官网](http://geoserver.org/download/)下载对应的扩展
 (2)移动这个包到WEB-INF/lib目录下

```bash
sudo cp gt-imagemosaic-jdbc-20.1.jar $GEOSERVER_HOME/webapps/geoserver/WEB-INF/lib
```

（3）重启GeoServer就可以New Data Source下看到刚才添加的扩展了。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20181220184700289.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h0ZmdlMDkxNQ==,size_16,color_FFFFFF,t_70)

## 2.2 准备金字塔和瓦片

*ps:如果对这两个概念有疑问的请百度。*
 GeoServer推荐利用[gdal_retile](https://www.gdal.org/gdal_retile.html)工具（需要安装gdal）切割瓦片，命令如下：

```bash
gdal_retile -co "WORLDFILE=YES"  -r bilinear -ps 128 128 -of PNG -levels 3 -targetDir tiles China_dem.tif
```

完成后在当前目录会有一个tiles文件夹，里面是切割好的瓦片数据。

## 2.3 创建配置文件

配置文件可以放在任意位置，但它们需要在同一目录。
 (1) `connect.postgis.xml.inc`

```xml
<connect>
   <dstype value="DBCP"/>
   <username value="postgres"/>
   <password value="postgres"/>
   <jdbcUrl value="jdbc:postgresql://localhost:5432/test"/>
   <driverClassName value="org.postgresql.Driver"/>
   <maxActive value="10"/>
   <maxIdle value="0"/>
</connect>
```

(2) `mapping.postgis.xml.inc`

```xml
<spatialExtension name="postgis"/>
<mapping>
    <masterTable name="dem" >
      <coverageNameAttribute name="name"/>
      <maxXAttribute name="maxX"/>
      <maxYAttribute name="maxY"/>
      <minXAttribute name="minX"/>
      <minYAttribute name="minY"/>
      <resXAttribute name="resX"/>
      <resYAttribute name="resY"/>
      <tileTableNameAtribute  name="TileTable" />
      <spatialTableNameAtribute name="SpatialTable" />
    </masterTable>
    <spatialTable>
      <keyAttributeName name="location" />
      <geomAttributeName name="data" />
      <tileMaxXAttribute name="maxX"/>
      <tileMaxYAttribute name="maxY"/>
      <tileMinXAttribute name="minX"/>
      <tileMinYAttribute name="minY"/>
    </spatialTable>
</mapping>
```

(3) `dem.postgis.xml`

```xml
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!DOCTYPE ImageMosaicJDBCConfig [
  <!ENTITY mapping PUBLIC "mapping"  "mapping.postgis.xml.inc">
  <!ENTITY connect PUBLIC "connect"  "connect.postgis.xml.inc">]>
<config version="1.0">
  <coverageName name="dem"/>
  <coordsys name="EPSG:4326"/>
  <!-- interpolation 1 = nearest neighbour, 2 = bilinear, 3 = bicubic -->
  <scaleop  interpolation="1"/>
  <verify cardinality="false"/>
  &mapping;
  &connect;
</config>
```

## 2.4 创建数据库

```bash
sudo java -jar $GEOSERVER_HOME/webapps/geoserver/WEB-INF/lib/gt-imagemosaic-jdbc-20.1.jar ddl -config dem.postgis.xml -spatialTNPrefix tiledem -pyramids 3 -statementDelim ";" -srs 4326 -targetDir sqls
```

执行完成后在sqls文件夹会有四个.sql文件
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20181220221110301.png)
 依次执行

```plsql
sudo -u postgres psql -d test -f sqls/createmeta.sql
sudo -u postgres psql -d test -f sqls/add_dem.sql 
```

然后数据库在就会出现5个表，分别是dem,demile_0,demtile_1,demtile_2,demtile_3
接下来要做的就是把数据存入数据库了。

```bash
java -jar $GEOSERVER_HOME/webapps/geoserver/WEB-INF/lib/gt-imagemosaic-jdbc-20.1.jar import -config dem.postgis.xml -spatialTNPrefix tiledem -tileTNPrefix tiledem -dir tiles -ext png
```

到此，数据已经存入到数据库了
![在这里插入图片描述](https://img-blog.csdnimg.cn/20181220222851585.png)

## 2.5 发布数据

在New Data Source中选择Raster Data Sources中的ImageMosaicJCBD

![在这里插入图片描述](https://img-blog.csdnimg.cn/20181220223328302.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h0ZmdlMDkxNQ==,size_16,color_FFFFFF,t_70)

url中填写dem.postgis.xml的绝对路径。
点击save没有出错说明创建Stores成功了，后面的发布过程与其它数据的发布并无差异。

## 2.6 可能遇到的坑

1. 如果在利用imagemosaic-jdbc数据导入PostGIS的过程中出现ClassNotFoundException: org.postgresql.Driver的错误，请用-Xbootclasspath/a指定postgresql.jar的路径，如下：

```bash
java -Xbootclasspath/a:$GEOSERVER_HOME/webapps/geoserver/WEB-INF/lib/postgresql-42.1.1.jar -jar $GEOSERVER_HOME/webapps/geoserver/WEB-INF/lib/gt-imagemosaic-jdbc-20.1.jar import -config dem.postgis.xml -spatialTNPrefix tiledem -tileTNPrefix tiledem -dir tiles -ext png
```

2. 上述过程执行的几条命令和配置文件中某些参数是对应的，操作过程中需要注意。