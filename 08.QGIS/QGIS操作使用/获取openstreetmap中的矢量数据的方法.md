- [获取openstreetmap中的矢量数据的方法_DXnima的博客-CSDN博客_openstreetmap数据](https://blog.csdn.net/qq_40953393/article/details/116035344)

前提先安装[QGIS](https://so.csdn.net/so/search?q=QGIS&spm=1001.2101.3001.7020)和quickOSM插件，可转到[这里](https://blog.csdn.net/qq_40953393/article/details/116019466)查看。

## 方法一：在[openstreetmap](https://so.csdn.net/so/search?q=openstreetmap&spm=1001.2101.3001.7020)上查看要素属性

### 获取海南省码头矢量数据

1.在openstreetmap上随机查找一个码头，查看其标签属于哪一类，码头是 amenity:ferry_terminal

![img](https://img-blog.csdnimg.cn/20210422233900860.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQwOTUzMzkz,size_16,color_FFFFFF,t_70)

2.修改代码 <has-kv k="**amenity**" v="**ferry_terminal**"/>和 geocodeArea:**海南省** 就可以了，完整代码如下：

```xml
<osm-script output="xml" timeout="25">



    <id-query {{geocodeArea:海南省}} into="area_0"/>



    <union>



        <query type="node">



            <has-kv k="amenity" v="ferry_terminal"/>



            <area-query from="area_0"/>



        </query>



    </union>



    <union>



        <item/>



        <recurse type="down"/>



    </union>



    <print mode="body"/>



</osm-script>
```

3.粘贴进quickOSM插件 的Overpass query标签下，点运行 run query.

![img](https://img-blog.csdnimg.cn/20210422235110933.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQwOTUzMzkz,size_16,color_FFFFFF,t_70)

4.QGIS查看结果

![img](https://img-blog.csdnimg.cn/20210422235228785.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQwOTUzMzkz,size_16,color_FFFFFF,t_70)

## 方法二：在[说明文档](https://wiki.openstreetmap.org/wiki/Zh-hans:Map_Features)查看要素属性

### 获取海南省,铁路站点矢量数据

1.在说明文档里找到铁路-》车站

![img](https://img-blog.csdnimg.cn/20210422235542470.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQwOTUzMzkz,size_16,color_FFFFFF,t_70)

2.可以看到车站类型有很多种，这里选择火车站，即标签为 **railway:station**

![img](https://img-blog.csdnimg.cn/20210422235653995.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQwOTUzMzkz,size_16,color_FFFFFF,t_70)

3.打开quickOSM插件，Quick query标签页分别在key，value下拉框选择**railway**和**station，**in这里输入 **海南省** 限制查询范围，最后点 **run query** 运行。

![img](https://img-blog.csdnimg.cn/20210423000002618.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQwOTUzMzkz,size_16,color_FFFFFF,t_70)

4.在QGIS中查看查询结果。

![img](https://img-blog.csdnimg.cn/20210423000224468.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQwOTUzMzkz,size_16,color_FFFFFF,t_70)