- [QGIS获取OSM地图矢量数据_DXnima的博客-CSDN博客_qgis下载矢量数据](https://blog.csdn.net/qq_40953393/article/details/116019466#:~:text=一、QGIS加载OSM底图图层,1.安装QuickMapServices插件，在网络菜单下可以加载各类底图 2.插件安装后，通过插件打开OSM)

# 一、[QGIS](https://so.csdn.net/so/search?q=QGIS&spm=1001.2101.3001.7020)加载OSM底图图层

### 1.安装QuickMapServices插件，在网络菜单下可以加载各类底图

![img](https://img-blog.csdnimg.cn/20210422163322667.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQwOTUzMzkz,size_16,color_FFFFFF,t_70)

![img](https://img-blog.csdnimg.cn/20210422163323758.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQwOTUzMzkz,size_16,color_FFFFFF,t_70)

### 2.插件安装后，通过插件打开OSM 

![img](https://img-blog.csdnimg.cn/20210422163451896.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQwOTUzMzkz,size_16,color_FFFFFF,t_70)

# 二、quickosm插件导入[openstreetmap](https://so.csdn.net/so/search?q=openstreetmap&spm=1001.2101.3001.7020)数据

### 1.启动插件。

![img](https://img-blog.csdnimg.cn/20210422214625531.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQwOTUzMzkz,size_16,color_FFFFFF,t_70)

### 2.在 Quick query 标签中，您可以设置过滤器以选择[子集](https://so.csdn.net/so/search?q=子集&spm=1001.2101.3001.7020)。OSM数据库中地图要素的属性存储为 [标签](https://wiki.openstreetmap.org/wiki/Tags)。 标签用键和值表示。关键字是主题，值是特定形式。请参阅 [本页](https://wiki.openstreetmap.org/wiki/Map_Features)，以获得各种功能标签的完整列表。酒吧使用标签 `amenity:bar` 表示，酒馆使用标签 `amenity:pub` 表示。我们将首先提取条。从下拉菜单中选择 `amenity` 作为 Key。输入 “湖北省”作为 In 来将搜索限制在城市范围内。

![img](https://img-blog.csdnimg.cn/20210422214802908.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQwOTUzMzkz,size_16,color_FFFFFF,t_70)

### 3.展开 Advanced 部分。在OSM数据模型中，要素是使用 [节点，方式和关系](https://wiki.openstreetmap.org/wiki/Elements) 来表示的。由于我们对点要素感兴趣，因此只能选择 `节点` 和 `点`。点击 Run query。

![img](https://img-blog.csdnimg.cn/20210422214934922.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQwOTUzMzkz,size_16,color_FFFFFF,t_70)

### 4.查询完成后，切换到QGIS主窗口。您会看到一个新的图层添加到了 Layers 面板中。画布将显示提取条的位置。

![img](https://img-blog.csdnimg.cn/20210422215137369.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQwOTUzMzkz,size_16,color_FFFFFF,t_70)

# **三、数据导出**

### 1.将数据导出 点击图层右键 -》导出-》要素另存为

![img](https://img-blog.csdnimg.cn/20210422215350335.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQwOTUzMzkz,size_16,color_FFFFFF,t_70)

### 2.在弹窗选取 文件格式 文件输出位置等 这里输出为ESRC的shp格式 下面配置默认 也可以自行设置

![img](https://img-blog.csdnimg.cn/20210422215532465.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQwOTUzMzkz,size_16,color_FFFFFF,t_70)![img](https://img-blog.csdnimg.cn/20210422215635562.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQwOTUzMzkz,size_16,color_FFFFFF,t_70)

### 3.导出文件有五个 拖入arcmap就可显示

![img](https://img-blog.csdnimg.cn/20210422215805428.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQwOTUzMzkz,size_16,color_FFFFFF,t_70)![img](https://img-blog.csdnimg.cn/20210422215920832.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQwOTUzMzkz,size_16,color_FFFFFF,t_70)

# 四、Overpass query查询用法

### 1.点击show query查看XML语法

![img](https://img-blog.csdnimg.cn/20210422230902529.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQwOTUzMzkz,size_16,color_FFFFFF,t_70)

### 2.Overpass query 部分将显示根据用户输入构造的查询。此字段是可编辑的，并且可以输入任何查询。查询的格式为 [天桥查询语言（QL）](https://wiki.openstreetmap.org/wiki/Overpass_API/Language_Guide)。 出于我们的目的，选择<query> … </ query> XML标记之间的部分并复制它。

![img](https://img-blog.csdnimg.cn/20210422230923373.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQwOTUzMzkz,size_16,color_FFFFFF,t_70)

### 3.可以通过直接修改XML语法实现查询素，这样可以多图层一起查询。例如加入下面语句，然后点run query

```xml
        <query type="node">



            <has-kv k="amenity" v="pub"/>



            <area-query from="area_0"/>



        </query>
```

![img](https://img-blog.csdnimg.cn/20210422231314646.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQwOTUzMzkz,size_16,color_FFFFFF,t_70)

### 4.最终数据如图

![img](https://img-blog.csdnimg.cn/20210422231532705.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQwOTUzMzkz,size_16,color_FFFFFF,t_70)

# 五、写在最后

由于项目需要，通过各种途径在网上寻找需要的shp数据；但是很难找到需要的数据，大部分只有行政区划、省会城市等shp数据，其他数据都很难获取，后面在网上发现这种方法获取----------QGIS+OSM+quickSOM。分别查看了以下博客:

###    搜索和下载OpenStreetMap数据:[搜索和下载OpenStreetMap数据（QGIS3） — QGIS Tutorials and Tips](https://www.osgeo.cn/qgis-tutorial/docs/3/downloading_osm_data.html)

###    QGIS的openstreetmap数据加载：[QGIS的openstreetmap数据加载_仓鼠的藏宝库-CSDN博客](https://blog.csdn.net/qq_23034515/article/details/112715801)

###    Overpass query XML语法：[overpass language 笔记_n_fly的博客-CSDN博客](https://blog.csdn.net/n_fly/article/details/104298399)

#   官方文档：

###    OpenStreetMap地图图层分类：https://wiki.openstreetmap.org/wiki/Zh-hans:Map_Features    Overpass query XML代码说明：[Overpass API - OpenStreetMap Wiki](https://wiki.openstreetmap.org/wiki/Overpass_API)