GeoServer发布多层级天地图、谷歌地图、高德地图等底图切片服务：https://blog.csdn.net/zhengjie0722/article/details/100034677



总体来说有三种方法，多层级MBTiles 、多层级地图大图拼接、发布arcgisserver切好的切片缓存数据。

# 一、多层级MBTiles规范数据发布

配置MBTiles扩展包，需要下载 geoserver-2.15-SNAPSHOT-wps-plugin 和 geoserver-2.15-SNAPSHOT-mbtiles-plugin 包，本地安装哪个geoserver的版本，就去下载对应的版本，下载完成后把解压的jar包放到geoserver安装路径下webapps/geoserver/WEB-INF/lib文件夹内，重启geoserver。

配置成功后在数据存储的目录会有MBTiles的扩展数据源。

![img](https://img-blog.csdnimg.cn/20190823115631242.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3poZW5namllMDcyMg==,size_16,color_FFFFFF,t_70)

最终因为目录文件的问题没有选择这个方法进行切片。

# 二、多层级地图大图拼接格式

我们所拿到的数据是天地图各层级构建好金字塔后的tif文件，每个层级对应一份tif文件，这个主要就是要解决多层级的问题。

1、首先我们需要在Gridsets里添加下载的天地图各层级所对应的比例尺和坐标；

![img](https://img-blog.csdnimg.cn/2019082312042165.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3poZW5namllMDcyMg==,size_16,color_FFFFFF,t_70)

2、然后可以通过数据存储的GeoTIFF格式的数据加载各层级的天地图tif文件，对每个层级的文件都进行切片。也就是假设是第8层级的数据，我们只切8级的瓦片，第9级的数据，我们只切9级的瓦片。

![img](https://img-blog.csdnimg.cn/20190823120532676.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3poZW5namllMDcyMg==,size_16,color_FFFFFF,t_70)

3、所有层级的瓦片都切好后，去切片路径下将多个文件夹内的切片服务合并成一个完整的目录，然后直接去tile caching中选择完整目录的服务预览即可。

![img](https://img-blog.csdnimg.cn/20190823144658845.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3poZW5namllMDcyMg==,size_16,color_FFFFFF,t_70)

这种方法完全可以实现，但是预览的时候遇到了bug，缩放的时候会有经纬度的闪跳，后期解决了再更新。

# 三、GeoWebCache插件发布ArcGIS切片服务

我本地安装的是geoserver的1.15版本，本身已经继承了geowebcache的发部分功能，但是想调用arcgisserver的瓦片，还是需要在本地安装geowebcache插件，我一开始用的是与geoserver版本一致的1.15版本，但是测试后有问题， 报503错误。网上查了很多资料，最终确定用相对比较稳定的geowebcache1.10.0（war包）版本，完美发布。

1、下载好geowebcache1.10.0后，解压并将其拷贝到webapps的目录下

![img](https://img-blog.csdnimg.cn/20190823145530340.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3poZW5namllMDcyMg==,size_16,color_FFFFFF,t_70)

2、重新启动geoserver，在浏览器中一次输入http://localhost:16080/geoserver/web/ 和http://localhost:16080/geowebcache/home，如果出现下图即安装成功。

![img](https://img-blog.csdnimg.cn/2019082314572444.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3poZW5namllMDcyMg==,size_16,color_FFFFFF,t_70)

3、配置geowebcache的缓存目录: geoserver-2.15.2\webapps\geowebcache\WEB-INF目录下，打开web.xml并在context-param下添加节点，然后重启geoserver，在E:\geoserver\arcgis目录下会自动生成如下文件。

```xml
<context-param>
    <param-name>GEOWEBCACHE_CACHE_DIR</param-name>
    <param-value>E:\geoserver\arcgis</param-value>
</context-param>
```

![img](https://img-blog.csdnimg.cn/20190823150043659.png)

4：配置arcgis server的缓存切片路径

![img](https://img-blog.csdnimg.cn/20190823150203505.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3poZW5namllMDcyMg==,size_16,color_FFFFFF,t_70)

arcgisserver切片缓存的目录如上图所有，我们需在第3点生成geowebcache.xml中配置缓存路径，在layers节点下添加代码：

```xml
<arcgisLayer>
    <name>tdtLayer_map</name>
    <tilingScheme>D:\arcgisserver\directories\arcgiscache\eastChinaSea_eastSeaMap\Layers\Conf.xml</tilingScheme>
    <tileCachePath>D:\arcgisserver\directories\arcgiscache\eastChinaSea_eastSeaMap\Layers\_alllayers</tileCachePath>
    <hexZoom>false</hexZoom>
</arcgisLayer>
```

网上很多教程说需要更改Conf.xml和conf.cdi文件，但是经过测试，是不需要改的。

重启geoserver服务，如果能够正常访问http://localhost:16080/geowebcache/home，则表示配置成功，如果不行，则去geoserver-2.15.2\webapps\geowebcache\WEB-INF目录下，在geowebcache-core-context.xml文件中添加代码：

```xml
<bean id="gwcArcGIGridsetConfigutation" class="org.geowebcache.arcgis.layer.ArcGISCacheGridsetConfiguration"/>
```

5、预览geowebcache服务：打开http://localhost:16080/geowebcache/home ，点击

 [A list of all the layers and automatic demos](http://192.168.1.236:16080/geowebcache/demo)进入图层选择：

![img](https://img-blog.csdnimg.cn/20190823151316516.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3poZW5namllMDcyMg==,size_16,color_FFFFFF,t_70)

点击png进行预览

![img](https://img-blog.csdnimg.cn/2019082315141932.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3poZW5namllMDcyMg==,size_16,color_FFFFFF,t_70)