- [OpenLayers教程十八：多源数据加载之矢量切片](https://blog.csdn.net/qq_35732147/article/details/96586800)



在看本篇文章之前，可以先看我翻译的这篇文章：https://zhuanlan.zhihu.com/p/62751184

 

矢量切片就是将矢量数据以金字塔的组织方式，切割成一个一个描述性文件，目前矢量切片主要有以下三种格式：

- GeoJSON
- TopoJSON
- MapBox Vector Tile（MVT）

上面的文章介绍了使用GeoServer来发布矢量切片。其实在GeoServer中完成切片工作的是GeoWebCache，而GeoWebCache的数据存储文件的默认路径（这个路径可以更改）一般为：

C:\Users\%YOUR-PC-NAME%\AppData\Local\Temp\geowebcache

我们打开这个文件，可以发现有多层文件结构，那是因为矢量切片也跟瓦片地图一样使用金字塔组织方式来组织矢量切片：

![img](https://img-blog.csdnimg.cn/20190720141301199.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

随便打开一个文件夹可以发现有三种类型的矢量切片，也就是对应上面提到的那三种类型。

![img](https://img-blog.csdnimg.cn/20190720141419488.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

随便打开一个geojson文件，可以发现也就是普通的geojson数据：

![img](https://img-blog.csdnimg.cn/20190720141616727.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

