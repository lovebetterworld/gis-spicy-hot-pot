- [GIS系统开发流程](https://www.cnblogs.com/googlegis/p/14640897.html)

GIS 系统因其独特的地理位置特性，越来越受到重视，在各行业中也有越来越多的展示机会。

那 GIS 系统开发的主要流程有哪些？我来整理一下。

# 1. 确定需求，确定硬件环境

首选确定业务功能需求，只有需求确定下来了，才能确定使用什么技术路线。是BS构架还是CS构架，需要的开发工具等。一般BS系统偏向内容展示，CC系统偏向内容编辑。

硬件环境主要为网络环境，因为网络环境牵涉到地图底图的来源，如果不能访问外网，还需要考虑采用离线底图。

# 2. 确定开发技术

## 2.1 地图引擎

地图引擎，说明白点就是SDK或者JS库，可以提供将地图数据转化为地图位置的功能，并且可以提供加载底图的功能。总的来说，它提供了地图显示的所有接口。

具体可以结合2.3查看。　　　　

## 2.2 底图

除了上面提到的网络环境影响底图的选择，还要根据客户需求以及开发技术来确定底图图源的情况。

一般的底图除了常见的类似百度地图服务器提供的图片格式底图，还包括.shp ,.tab, geojson文件格式。通过不同的地图引擎库加载不同的文件，最终实现在地图上显示点线面的效果。

国内在线底图图源： 百度地图、高德、天地图、腾讯。

国外在线底图图源： 谷歌地图、OpenStreet、ArcGIS、Bing。

## 2.3 开发技术

综合上面的地图引擎，底图来源，可以为项目开发选择合适的开发技术路线。

一般分为以下几种：

### 2.3.1 ArcGIS 全家桶

由美国ESRI公司（国内公司为易智瑞，其对应产品为GeoScene）提供的全套支持地图开发的系列软件，包括地图数据处理 ArcGIS Desktop (ArcMap 和 ARCGIS Pro)，

用于地图服务的ArcGIS Server（ArcGIS Enterprise），用于BS页面开发的  ArcGIS JavaScript API（支持2D、3D），用于桌面CS软件开发的 ArcGIS Engine，Android SDK  ，iOS SDK 等。

其优点是功能齐全，文档规范，示例全面，覆盖面广，包含了所有可能涉及到的应用场景。 缺点是系统复杂，安装配置内容繁琐，接口多而杂，入门门槛高。非开源且收费贵。

**可选技术**： C# + ArcGIS JavaScript +ArcGISServer + ArcEngine + SDK　　

**底图可选**： ArcGIS + OSM + GoogleMap + 天地图

可见shp文件通过ArcGIS Server 发布为局域网内地图服务作为底图。支持离线。

### 2.3.2 开源开发

#### 2.3.2.1 Openlayers 和 Leaflet 

开源的二维地图JS开发库，其源码在GitHub开源，团队型开发，由很多地图基础功能，很多人会以此为基础写很多plugin。包括国内地图访问，地图工具，地图分析等。

**可选技术**： Openlayers/LeafletJS + GeoServer/PostGIS/天地图/OSM ,

其中GeoServer和PostGIS为地图服务引擎，可以通过这两个服务发布地图服务，用来作为底图。免费，支持离线。

#### 2.3.2.2 Cesium 和 maptalks

开源的三维地图JS开发库。其源码在GitHub开发，公司型开发，如果只使用其他JS库，不使用其服务资源不收费。

**可选技术**：CesiumJS/maptalks + CesiumMap/OSM/天地图

可通过加载三维模型以及使用WebGL技术对地图内容进行操作和效果展示。 目前不确认是否支持离线。

### 2.3.3 API开发

GoogleMap ：其地图API在国内已无法访问。

BaiduMap：百度公司提供的地图API，可在线访问百度地图的底图资源包括三维建筑等信息，并根据接口进行相关功能开发。

根据国测局要求，其底图进行了加密，必须使用其API加载数据才能显示正常位置。

可选技术：JavaScript + BaiduMap API ， 不支持离线。

非开源软件，接口固定，无法进行修改，底图不收费，其他服务类接口超过访问次数后收费。

AMap：高德公司提供的地图API，可在线访问高德地图的底图资源包括三维建筑等信息，并根据接口进行相关功能开发。

根据国测局要求，其底图进行了加密，必须使用其API加载数据才能显示正常位置。

可选技术：JavaScript + AMap API ， 不支持离线。

非开源软件，接口固定，无法进行修改，底图不收费，其他服务类接口超过访问次数后收费。

天地图：天地图以提供底图资源为主，在实际开发过程中，很少直接使用天地图的API进行项目开发。

可选技术：JavaScript + TMap API ， 不支持离线。

# 3. 业务数据

　　业务数据必须包含地理位置信息，也就是常说的经纬度信息，只有有了经纬度信息，才能知道在地图上将对象放在哪里，否则无法确定位置。也就是失去了GIS系统的优势和意义。

 　需要对相应的数据进行地图入库，如ArcGIS Server、GeoServer、

# 4. 业务逻辑

　　根据功能需求，设计交互操作以及信息展示。各个行业的需求模式不同，其交互逻辑也不相同。

# 5. 开发

　　根据业务逻辑，使用对应的技术，开发出对应的功能。

# 6. 部署

　　部署的时候，除了考虑项目文件的部署，还要考虑底图的部署，离线地图要放在对应的文件夹，如果是ArcGIS Server、GeoServer、PostGIS这样的地图服务软件，

要单独进行安装，并将地图源文件导入发布。

说明：离线底图除了 ArcGIS/GeoServer/PostGIS 这样的发布局域网服务的地图服务外，可以使用下载软件将在线底图下载到本地加载，也称之为离线底图。



# 参考：

- ArcGIS Developer Documents：[ https://developers.arcgis.com/documentation/](https://developers.arcgis.com/documentation/)

- LeafletJS: https://leafletjs.com/

- openlayersJS:[ https://openlayers.org/](https://openlayers.org/)

- CesiumJS:[ https://cesium.com/](https://cesium.com/)

- maptalksJS: https://maptalks.org/

- GeoServer: http://geoserver.org/

- PostGIS: https://postgis.net/

- 天地图: http://lbs.tianditu.gov.cn/server/MapService.html

- BaiduMapAPI: http://lbsyun.baidu.com/index.php?title=jspopular3.0

- AMapAPI: https://lbs.amap.com/api/javascript-api/summary/

- openstreetMap: https://www.openstreetmap.org/