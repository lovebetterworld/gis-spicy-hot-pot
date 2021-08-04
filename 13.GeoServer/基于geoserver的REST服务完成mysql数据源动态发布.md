- [基于geoserver的REST服务完成mysql数据源动态发布](https://www.cnblogs.com/naaoveGIS/p/9729625.html)

# 1. 背景

​    在之前的《[简析GeoServer服务的内部文件组织以及GeoServer自动化服务发布工具的开发思路](https://www.cnblogs.com/naaoveGIS/p/4212093.html)》（https://www.cnblogs.com/naaoveGIS/p/4212093.html）文章中，我详细的介绍了Geoserver如何通过构造其内部的featuretype.xml、layer.xml等文件以实现数据源的快捷发布。但是该方案主要针对项目环境预搭建时的快速处理，但是当Geoserver已经开始运行，系统不能时刻重启情况下，该方案是不能解决数据的实时动态发布的。因此，我们还需要其他方案来解决。

   目前有两种方案来实现，一种是利用已封装好的geoserverManager.jar来开发，另一种就是直接基于geoserver的Rest服务来开发。这里，我们主要对如何使用geoserver的Rest服务完成开发来进行描述。

# 2. RestAPI

​    Geoserver的每一个版本均有在线使用说明，这里给出其中一个版本中关于RestAPI介绍的地址：http://docs.geoserver.org/stable/en/user/rest/index.html

 ![img](https://img2018.cnblogs.com/blog/656746/201809/656746-20180930145817633-1848897944.png)

​     我所列出的workspaces、datastores、featuretypes、layers、styles是服务发布中均会涉猎的类型。我们利用workspaces来创建工作空间，利用datasotores来创建数据源，利用featuretypes来将数据源中具体数据创建为要素类型，利用styles来创建样式，利用layer来将数据类型与样式进行关联。

​    以datastores为例，点击该链接可进入其支持的所有API请求：

 ![img](https://img2018.cnblogs.com/blog/656746/201809/656746-20180930145830741-27126967.png)

​    其中包含了数据源的增、删、改、查等。其他模块类似。

# 3.  实现

## 3.1  DataStores

​    该操作包含判断DataStores是否存在，以及创建。

### 3.1.1判断是否存在

​    依赖 gisBaseLayer.getServiceUrl()+"/rest/workspaces/cite/datastores.json"请求可获取到所有dataStores描述，进而判断指定的DataStores是否存在。

### 3.1.2创建

​    再依据构造创建dataStores的XML，发送Rest请求完成创建，这里以mysql数据源为例：

 ![img](https://img2018.cnblogs.com/blog/656746/201809/656746-20180930145855712-2121603978.png)

​    其中，发送请求时，一定要设置其权限认证：

 ![img](https://img2018.cnblogs.com/blog/656746/201809/656746-20180930145905564-1002179485.png)

​    请求方式为POST。

## 3.2  FeatureTypes

​    当dataStores创建成功后，需将其中的数据发布为要素类型服务。这里主要包含存在判断、删除操作、创建操作。

### 3.2.1判断是否存在

​     通过发送：gisBaseLayer.getServiceUrl()+"/rest/workspaces/cite/datastores/"+storeName+"/featuretypes.json"，可以获取到指定的stores下的所有featuretype，  通过遍历可判断指定的featuretype是否存在。

### 3.2.2删除

​    以DELETE请求类型，发送：

​     gisBaseLayer.getServiceUrl()+"/rest/workspaces/urbanlayer/datastores/"+storeName+"/featuretypes/"+featureTypeName+"?recurse=true"

​    请求，便可删除指定的featuretype。

### 3.2.3 创建

​    获取到要素的几何范围、坐标系等，便可以构造XML：

 ![img](https://img2018.cnblogs.com/blog/656746/201809/656746-20180930145916753-34300995.png)

​    请求方式为POST。

## 3.3Styles

### 3.3.1判断是否存在

​    通过发送：gisBaseLayer.getServiceUrl()+"/rest/styles.json"，可以获得所有style，通过遍历可判断指定的style是否存在。

### 3.3.2删除

​    以DELETE请求方式，发送：

gisBaseLayer.getServiceUrl()+"/rest/styles/"+styleName+"?purge=ture&recurse=true"

​    便可删除指定的style。

### 3.3.3创建

​    Geoserver中的样式内容均为SLD格式，这里创建样式服务有多种方式，这里以style.sld和style.xml一同创建为例：

 ![img](https://img2018.cnblogs.com/blog/656746/201809/656746-20180930145930812-1365551699.png)

​    红框中分别为样式名称，以及创建Style时传入的数据格式。

​    请求方式为POST请求。

## 3.4Layers

### 3.4.1修改

​    该功能主要目的是修改layer与style的关联：

 ![img](https://img2018.cnblogs.com/blog/656746/201809/656746-20180930145939927-150071740.png)

​    请求方式为PUT。

# 4. 功能设计

​    a.开发数据源选择框，提供业务库中待发布数据选择、几何字段选择、数据条件过滤等。

​    b.开发样式配置模板，提供填充色、边框、图标等配置。

​    c.开发地理服务器选择框，提供选择发布至某个geoserver。

​    d.一键发布。

​    e.元数据获取，服务托管。