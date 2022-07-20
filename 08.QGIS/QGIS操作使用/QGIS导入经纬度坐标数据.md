- [QGIS如何导入经纬度坐标点数据？ - 知乎 (zhihu.com)](https://www.zhihu.com/question/500119752)

## QGIS默认可支持txt、csv、dat和wkt格式，推荐将数据先转换为[csv](https://www.zhihu.com/search?q=csv&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A2240981277})

QGIS中可以通过默认方式或者借助插件来添加点数据。

### 方法一：添加分隔文本图层，以csv为例

![img](https://pic1.zhimg.com/80/v2-f95e5da095a96ea547dae49599eb4555_720w.jpg?source=1940ef5c)

1. 在【图层】-【添加图层】-【添加分隔文本图层】，弹出【数据资源管理器|分隔文本】界面，支持txt、csv、dat和wkt；
2. 选择文件名，如果中文出现乱码，在【编码】选择GBK即可；
3. 【文件格式】可以选择csv格式、分隔符为[正则表达式](https://www.zhihu.com/search?q=正则表达式&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A2240981277})、自定义分隔符；
4. 【记录和字段选项】可以选择是否忽略首行、检测字段类型、小数点转为逗号、裁剪字段前的空格、忽略空字段；
5. 【几何图形定义】点坐标，设置X字段为经度，Y字段为纬度，Z字段和M字段为可选项；如果[经纬度](https://www.zhihu.com/search?q=经纬度&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A2240981277})为度分秒格式，可以勾选度分秒格式，同时需要选择坐标系，这里选择EPSG:4326；
6. 点击【添加】，即可实现点数据的导入；

![img](https://pic1.zhimg.com/80/v2-8132e02f49fabaa1b147e54d1091db5a_720w.jpg?source=1940ef5c)

### 方法二：HCMGIS插件，以csv为例，支持批量转换

![img](https://pica.zhimg.com/80/v2-fea488ae7afa86ca8e4922ae45b4d7a5_720w.jpg?source=1940ef5c)

1. 【HCMGIS】-【Batch Converter】-【CSV to Point】即可；
2. 具体设置参数如下：导入文件夹，选择经纬度，点击【Apply】；

![img](https://pica.zhimg.com/80/v2-b299a4615a95091889c14cf7e80626fa_720w.jpg?source=1940ef5c)

3.转换出的格式为.geojson格式。

![img](https://pica.zhimg.com/80/v2-924073692237b2a48a5cedbb89ffdaf9_720w.jpg?source=1940ef5c)

### 方法三：MMQGIS插件，以csv为例

![img](https://pic2.zhimg.com/80/v2-9ea9f3e69dd111b8222d27a34126098c_720w.jpg?source=1940ef5c)

1. 【MMQGIS】-【Import/Export】-【Geometry import from CSV File】即可；
2. 具体设置参数如下：导入文件夹，选择类型、经纬度，点击【Apply】；

![img](https://pic1.zhimg.com/80/v2-a0f458faf6c4bd950f6cfa02d6a7a946_720w.jpg?source=1940ef5c)

3.转换出的格式为.shp格式。

![img](https://pic1.zhimg.com/80/v2-ea0af62601caff7b8a84a1c3dd605094_720w.jpg?source=1940ef5c)

![img](https://pic1.zhimg.com/80/v2-11a5449ca83cdd0b88f702b7649a5a99_720w.jpg?source=1940ef5c)