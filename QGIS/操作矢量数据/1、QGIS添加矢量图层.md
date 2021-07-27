QGIS 可以支持多种的矢量数据，如常见的 Shapefile 和 MapInfo MIF、TAB。另外 QGIS 亦支持在 PostgreSQL 数据库中的 PostGIS 图层。以及提供 CSV(delimited text)纯文本导入。

​    

目前 QGIS 可以读取的矢量数据有：

- Arc/Info Binary Coverage
- ESRI Shapefile
- Mapinfo File
- SDTS

目前最多使用的文件格式为 ESRI Shapefiles，它是由三种格式组成。分别为：

- .shp：此档案为几何图元数据
- .dbf：此档案为 dBase 格式的属性数据
- .shx：索引档案

添加矢量图层的步骤如下：

# 1.启动 QGIS

进入 QGIS 的操作画面，如图。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image67.jpg)

# 2.选择SHP格式工具

在文件类型中选择 ESRI Shape 檔[OGR] (*.shp ,*SHP)后或工具栏的![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image68.jpg)，选择加入的矢量图「twCounty.shp」，如图所示 ，并点选开启。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image69.jpg)

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image70.jpg)

  

# 3.完成载入图层

如图所示。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image71.jpg)

# 4.打开鹰眼

显示左边中间的全览图：鼠标在「twCounty」图层名称上点击，按鼠标右键，勾选[在全览图中显示]即可。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image72.jpg)

**Tip**: 左边的图例、全览图等不见怎么办？在工具栏空白处按鼠标右键会出现下拉菜单，将关闭图例或全览图的框框打 X 之后就会显示，同理如果工具栏不见了，亦可依相同的方法处理。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image73.jpg)

  

