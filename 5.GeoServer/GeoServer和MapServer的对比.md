- [GeoServer和MapServer的对比](https://www.cnblogs.com/boonya/p/14861023.html)

#### 1. 选型

基于C、C++系列的：Mapserver（服务器）+QGIS（桌面软件）+PostGIS（数据库）+[Openlayers](http://www.opengeo.cn/bbs/thread.php?fid=5)(JS)/ openscale (FLex)(浏览器客户端)

基于JavaEE系列的：Geoserver（服务器）+uDig（桌面软件）+PostGIS（数据库） +[Openlayers](http://www.opengeo.cn/bbs/thread.php?fid=5)(JS)/ openscale (FLex)(浏览器客户端)

#### 2. 对比

功能上：MapServer弱于GeoServer，QGIS要强于UDIG

效率上：Mapserver对WMS（Web Map service）的支持更为高效，而Geoserver则更擅长于结合WFS（Web Feature service）规范的属性查询