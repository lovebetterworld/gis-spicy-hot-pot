- [通过QGIS XYZ Tiles访问国内四大图商地图服_QGIS课堂的博客-CSDN博客_xyz 地图服务](https://blog.csdn.net/QGISClass/article/details/112637978?spm=1001.2014.3001.5502)

#  **01 天地图**

天地图发布了矢量、影像、地形和全球境界线四种数据，提供两种坐标系类型：球面墨卡托投影和经纬度坐标系，大家可根据需要选择对应的底图。

- **球面墨卡托投影**

**矢量**：

https://t3.tianditu.gov.cn/vec_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=vec&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TileMatrix={z}&TileRow={y}&TileCol={x}&tk=ec899a50c7830ea2416ca182285236f3

**矢量注记**：

http://t0.tianditu.gov.cn/cva_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=cva&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TileMatrix={z}&TileRow={y}&TileCol={x}&tk=ec899a50c7830ea2416ca182285236f3 

**矢量英文注记**：

http://t0.tianditu.gov.cn/eva_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=eva&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TileMatrix={z}&TileRow={y}&TileCol={x}&tk=ec899a50c7830ea2416ca182285236f3

**影像**：

http://t0.tianditu.gov.cn/img_w/wmts?service=wmts&request=GetTile&version=1.0.0&LAYER=img&tileMatrixSet=w&TileMatrix={z}&TileRow={y}&TileCol={x}&style=default&format=tiles&tk=ec899a50c7830ea2416ca182285236f3

**影像注记**：

http://t0.tianditu.gov.cn/cia_w/wmts?service=wmts&request=GetTile&version=1.0.0&LAYER=cia&tileMatrixSet=w&TileMatrix={z}&TileRow={y}&TileCol={x}&style=default&format=tiles&tk=ec899a50c7830ea2416ca182285236f3

**影像英文注记**：

http://t0.tianditu.gov.cn/eia_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=eia&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TileMatrix={z}&TileRow={y}&TileCol={x}&tk=ec899a50c7830ea2416ca182285236f3

**地形晕渲**：

http://t0.tianditu.gov.cn/ter_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=ter&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TileMatrix={z}&TileRow={y}&TileCol={x}&tk=ec899a50c7830ea2416ca182285236f3

**地形晕渲注记**：

http://t0.tianditu.gov.cn/cta_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=cta&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TileMatrix={z}&TileRow={y}&TileCol={x}&tk=ec899a50c7830ea2416ca182285236f3

**全球境界线**：

http://t0.tianditu.gov.cn/ibo_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=ibo&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TileMatrix={z}&TileRow={y}&TileCol={x}&tk=ec899a50c7830ea2416ca182285236f3

- **经纬度坐标系**

**矢量**：

http://t0.tianditu.gov.cn/vec_c/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=vec&STYLE=default&TILEMATRIXSET=c&FORMAT=tiles&TileMatrix={z}&TileRow={y}&TileCol={x}&tk=ec899a50c7830ea2416ca182285236f3

**矢量注记**：

http://t0.tianditu.gov.cn/cva_c/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=cva&STYLE=default&TILEMATRIXSET=c&FORMAT=tiles&TileMatrix={z}&TileRow={y}&TileCol={x}&tk=ec899a50c7830ea2416ca182285236f3

**矢量英文注记**：

http://t0.tianditu.gov.cn/eva_c/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=eva&STYLE=default&TILEMATRIXSET=c&FORMAT=tiles&TileMatrix={z}&TileRow={y}&TileCol={x}&tk=ec899a50c7830ea2416ca182285236f3

**影像**：

http://t0.tianditu.gov.cn/img_c/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=img&STYLE=default&TILEMATRIXSET=c&FORMAT=tiles&TileMatrix={z}&TileRow={y}&TileCol={x}&tk=ec899a50c7830ea2416ca182285236f3

**影像注记**：

http://t0.tianditu.gov.cn/cia_c/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=cia&STYLE=default&TILEMATRIXSET=c&FORMAT=tiles&TileMatrix={z}&TileRow={y}&TileCol={x}&tk=ec899a50c7830ea2416ca182285236f3

**影像英文注记**：

http://t0.tianditu.gov.cn/eia_c/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=eia&STYLE=default&TILEMATRIXSET=c&FORMAT=tiles&TileMatrix={z}&TileRow={y}&TileCol={x}&tk=ec899a50c7830ea2416ca182285236f3

**地形**：

http://t0.tianditu.gov.cn/ter_c/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=ter&STYLE=default&TILEMATRIXSET=c&FORMAT=tiles&TileMatrix={z}&TileRow={y}&TileCol={x}&tk=ec899a50c7830ea2416ca182285236f3

**地形注记**：

http://t0.tianditu.gov.cn/cta_c/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=cta&STYLE=default&TILEMATRIXSET=c&FORMAT=tiles&TileMatrix={z}&TileRow={y}&TileCol={x}&tk=ec899a50c7830ea2416ca182285236f3

**全球境界线**：

http://t0.tianditu.gov.cn/ibo_c/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=ibo&STYLE=default&TILEMATRIXSET=c&FORMAT=tiles&TileMatrix={z}&TileRow={y}&TileCol={x}&tk=ec899a50c7830ea2416ca182285236f3

#  **02 高德地图**

**影像**：

https://webst02.is.autonavi.com/appmaptile?style=6&x={x}&y={y}&z={z}

**矢量**：

http://webrd03.is.autonavi.com/appmaptile?lang=zh_cn&size=1&scale=1&style=8&x={x}&y={y}&z={z}

**路网(不含注记）**：

https://wprd02.is.autonavi.com/appmaptile?x={x}&y={y}&z={z}&lang=zh_cn&size=1&scl=2&style=8

**路网（含注记）**：

https://wprd02.is.autonavi.com/appmaptile?x={x}&y={y}&z={z}&lang=zh_cn&size=1&scl=1&style=8

#  **03 腾讯地图**

**腾讯路网**：

http://rt0.map.gtimg.com/tile?z={z}&x={x}&y={-y}&type=vector&styleid=3&version=628

#  **04 百度地图**

**矢量**：

https://maponline3.bdimg.com/tile/?qt=vtile&x={x}&y={-y}&z={z}&styles=pl&udt=20210108&scaler=1&showtext=1

#  **05 使用方法**

可以手工输入URL。打开QGIS，在浏览器面板中找到【XYZ Tiles】节点，右键点击，选择【新建连接…】，在弹出对话框中，输入任意字符作为名称，如“天地图矢量”，然后填入对应的URL地址即可。

![img](https://img-blog.csdnimg.cn/img_convert/7695b12856cb1af10d1082f5671970c7.png)

 除了逐个输入，QGIS也提供批量导入的方式。本文所整理的URL已经导出为XML文件并上传到百度网盘，连接为：

链接：https://pan.baidu.com/s/1f5WbPmUTu2preNXjR4spIQ

提取码：gi1u

有需要的朋友可以下载该文件后批量导入到QGIS中，免去逐个手工输入的过程。批量导入操作步骤为：右键点击【XYZ Tiles】节点，选择【加载连接…】，浏览本地目录找到下载的XML文件，在弹出的【管理连接】对话框中可以看到文件所包含的地图连接名称，点击【全选】->【导入】按钮，将文件所包含的连接全部导入到QGIS中。

![img](https://img-blog.csdnimg.cn/img_convert/4075ca44148c54f268547857dcdb422e.png)

##  **06 几点说明**

1.访问天地图需要注册并申请许可，注意，在创建天地图应用时，应选择“浏览器端”应用类型，然后将生成的key替换本文提供的URL中tk参数值。如墨卡托投影矢量底图的URL为：

https://t3.tianditu.gov.cn/vec_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=vec&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TileMatrix={z}&TileRow={y}&TileCol={x}&tk=ec899a50c7830ea2416ca182285236f3

红色部分使用的是我本人的key，如果这个key配额超过限制导致无法访问，大家可以用自己的key替代。

2.每个厂商一般由多个服务器提供XYZ瓦片服务，例如天地图的二级域名由t0-t7组成，代表8个服务器，所以在使用URL时，任意选择一个二级域名均可正常访问，如：http://t2.tianditu.gov.cn/vec_c/wmts?tk=您的密钥。

3. 腾讯地图的瓦片采用TMS（Tile Map Service）方式组织，其原点在左下角，因此在URL中对y参数进行取反才能正常显示，且在QGIS中，缩放级别小于4的地图为空白，所以如果腾讯地图全图状态时地图窗口为空白，不要着急，放大到级别4以后即可看到地图。

![img](https://img-blog.csdnimg.cn/img_convert/5c2f2b66dc65a8fc67fb55e2cef00e3e.png)

 4.百度地图使用了自己的坐标系，与其他底图无法叠加，同样，如果发现地图窗口空白，全图状态对着左下角放大即可看到地图。

![img](https://img-blog.csdnimg.cn/img_convert/a864e3c3b9a990c46d55186f753b68ff.png)

 