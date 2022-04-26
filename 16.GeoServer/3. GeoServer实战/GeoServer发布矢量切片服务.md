geoserver矢量切片是webGIS展示的重要服务，矢量切片服务即增加了服务的访问速度，又保留数据本身的属性信息，支持用户的属性选择功能。

下载geoserver对应版本的geoserver-2.15.2-vectortiles-plugin的插件包，解压出来拷贝到对应“geoserver-2.15.2\webapps\geoserver\WEB-INF\lib“ 目录下，重新启动geoserver。

![img](https://img-blog.csdnimg.cn/2019092616401891.png)

（1）创建工作区

![img](https://img-blog.csdnimg.cn/20190926164501690.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3poZW5namllMDcyMg==,size_16,color_FFFFFF,t_70)

（2）添加数据存储

![img](https://img-blog.csdnimg.cn/20190926164605927.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3poZW5namllMDcyMg==,size_16,color_FFFFFF,t_70)

选择对应的shape文件

![img](https://img-blog.csdnimg.cn/20190926164804988.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3poZW5namllMDcyMg==,size_16,color_FFFFFF,t_70)

（3）发布服务

选择对应的坐标系，数据范围

![img](https://img-blog.csdnimg.cn/20190926164941880.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3poZW5namllMDcyMg==,size_16,color_FFFFFF,t_70)

![img](https://img-blog.csdnimg.cn/20190926165025871.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3poZW5namllMDcyMg==,size_16,color_FFFFFF,t_70)

选择图层的style，如果需要自定义，可用udig文件设置样式，新建新的样式。

![img](https://img-blog.csdnimg.cn/2019092616510633.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3poZW5namllMDcyMg==,size_16,color_FFFFFF,t_70)

添加对应坐标系

![img](https://img-blog.csdnimg.cn/20190926165300139.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3poZW5namllMDcyMg==,size_16,color_FFFFFF,t_70)

（4）预览图层

![img](https://img-blog.csdnimg.cn/20190926165427865.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3poZW5namllMDcyMg==,size_16,color_FFFFFF,t_70)

![img](https://img-blog.csdnimg.cn/20190926165458847.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3poZW5namllMDcyMg==,size_16,color_FFFFFF,t_70)