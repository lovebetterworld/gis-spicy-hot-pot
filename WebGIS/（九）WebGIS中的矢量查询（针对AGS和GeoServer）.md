- [（九）WebGIS中的矢量查询（针对AGS和GeoServer）](https://www.cnblogs.com/naaoveGIS/p/3928488.html)

## 1.前言

在第七章里我们知道了WebGIS中要素的本质是UIComponent，而矢量图层的本质是包含了n（n>=0）个UIComponent的Canvas。我们在UIComponent的graphics中，根据矢量数据画出矢量的形状(shape)，并且将矢量数据的属性(attributes)赋予该UIComponent。

在接下来进行要素和矢量图层的设计前，我们有必要了解这四个问题

（1）矢量数据是什么？

（2）矢量数据从何而来？

（3）矢量数据如何组织的？

（4）矢量数据得到后如何使用？

在这一章里，我将着重回答第1、2、3个问题，第四个问题涉及到一些算法知识，我们将专门在下一章进行讲解。

## 2.矢量数据的本质

矢量数据跟一般性数据最大的差别在于矢量数据是包含了空间（geometry）信息的。我们知道要素是由有序的空间坐标连接组成，而这个空间信息中便包含了该序列坐标。如果geometry为空，说明此要素不存在。同时矢量数据还包含一般性数据所有的信息，即属性数据。不过属性数据并不是必须的，只要geometry信息存在，attributes信息没有，要素也是同样存在的。

## 3.矢量数据的来源

我将矢量数据的来源分为两种：

(1)非向后台请求获得。

这些数据是已经存在于前台代码中，或者由第三方调用者通过参数在前台调用我们系统时本身通过参数传递进来。

(2)向后台请求获得。

向后台请求获得又要分为两种：

a.向业务服务器请求获得。

b.向地图服务器请求获得。

向业务服务器请求获得矢量数据跟一般的请求并没有区别，业务服务器只要按照一定的规范，组织好矢量数据，返回即可。本章的重点是向大家介绍后者，如何向地图服务器请求矢量数据。

### 3.1通过ArcGIS Server获得矢量数据

#### 3.1.1 AGS中几种服务的介绍

在我们发布地图服务时，如果勾选了Mapping（必须勾选），我们将能发布一个MapServer服务。当然，我们的AGS还能发布多个其他种类服务，比如NAServer、GeometryServer、FeatureServer、GPServer。其中NAServer可以用来进行路径分析，GeometryServer服务中包含了一系列拓扑操作的服务，FeatureServer可以用来进行要素编辑，GPServer则可以利用发布的模型来进行复杂的空间操作。下面两张图分别是10.0中发布的几种服务，以及Geometry服务中提供的一些功能（在10.1和10.2中Geometry服务的默认地址有变化）。

 ![img](https://images0.cnblogs.com/blog/656746/201408/220701525035506.png)

 ![img](https://images0.cnblogs.com/blog/656746/201408/220702032534856.png)

这一章里，我主要讲的是MapServer中的Query服务。其他服务在我们以后的功能设计模块中，如果涉及，会跟大家再一起探讨。

#### 3.1.2MapServer的详解

首先MapServer支持两种请求方式，并且支持一些查询操作。具体如下：

 ![img](https://images0.cnblogs.com/blog/656746/201408/220702221286856.png)

在MapServer的页面中，我们还可以看到该服务中所包含的图层的具体信息：

 ![img](https://images0.cnblogs.com/blog/656746/201408/220702303938249.png)

点击具体图层，进入该图层页面后，能看到该图层的详细信息，同样此页面中也详细的描述了可以支持的操作。如下图所示：

 ![img](https://images0.cnblogs.com/blog/656746/201408/220702382687355.png)

点击Query后便可以进入该图层空间查询的具体页面：

 ![img](https://images0.cnblogs.com/blog/656746/201408/220702491742221.png)

在此页面中，我们可以通过对各个查询参数的设置来获取想要的查询结果。

#### 3.1.3 Query查询的具体URL

MapServer中图层提供的查询服务是只支持rest样式的。通过上面的Query截图我们可以知道，Query查询的参数为：objectIds、where、geometry、geometryType、spatialRel、outFields、returnGeometry、returnIdsOnly、f、time。

这些参数所代表的实际含义如下：

objectIds：要素的ObjectID号。比如：objectIds=37, 462。

where：查询条件，支持标准sql中的where写法。比如：where=POP2000 > 350000。

geometry:geometry中为要查询的范围。其与Geometrytype应保持一致。geometry中，有点、线、面三种写法。这里给出接口API中的描述：

 ![img](https://images0.cnblogs.com/blog/656746/201408/220703237375945.png)

geometryType:它的内容与geometry中的内容是对应的，它可以选择的值有：esriGeometryPoint 、  esriGeometryMultipoint 、 esriGeometryPolyline 、esriGeometryPolygon 、  esriGeometryEnvelope。

spatialRel：为空间参考参数。

outFields：为需要返回的属性字段。

returnGeometry：是否范围几何信息。默认是ture。

returnIdsOnly：是否只范围ObjectID。默认是false。

f:返回数据的格式。有html、json 、kmz 、 amf。对我们开发者来说，返回json是最适合的。

time：赋为一个随机值即可，设置了此参数，可以避免查询读缓存。

这里给出一个URL示例的截图：

 ![img](https://images0.cnblogs.com/blog/656746/201408/220703396438672.png)

注意：我在这里将where设置为1=1，此表示能够返回我们在发布服务时已经设置好的返回的最大数据个数。默认为返回1000个数据。outFields设置为*是返回数据中所有关键字段的信息。另外，对于URL还想做进一步了解的读者，可以参考ArcGIS Server中的API Reference。

我们在程序中，向AGS服务器发送请求，查询某个关键字段时，便可以仿照这个URL的样式来进行请求。AGS的Query服务支持GET和POST两种请求方式。

### 3.2通过GeoServer获得矢量数据

#### 3.2.1Geoserver的简介

GeoServer作为开源的地图服务工具，由于其易扩展性、开源性、功能完整性等等优点，被越来越多的实际项目所使用。Geoserver支持OGC中的WMS、WFS等标准，且Geoserver的请求方式同样支持Rest和Soap两种协议。GeoServer本身是由Maven进行组织的，内部使用了struts和Spring框架，这里我跟大家展示一下GeoServer的源码内部构造，让大家对GeoServer的本质有个稍微清晰的认识：

​                        ![img](https://images0.cnblogs.com/blog/656746/201408/220703508462095.png)

如何开发GeoServer并不是我们这个系列的重点，我们这个系列是跟大家一起探索WebGIS的一些原理知识，设计并实现一些基于原理知识的模型和功能。如果大家对Geoserver有兴趣，我将在以后的其他系列里和大家一起研究。

Geoserver发布成功后，便可以登陆、进入如下页面：

 ![img](https://images0.cnblogs.com/blog/656746/201408/220704119093496.png)

回到正题上，如何用GeoServer来实现如AGS中的Query查询呢？

#### 3.1.2 详解Query查询

查询图层信息为WFS服务中的getFeature服务，其请求方式与标准的WFS请求方式是一样的。但是，与AGS相比，Geoserver的Query查询条件编写是相对复杂的，并且一般有两种方式。

##### 3.1.2.1第一种方式，URL方式

http://www.someserver.com/wfs?SERVICE=WFS& VERSION=1.1.0&  REQUEST=GetFeature&  PROPERTYNAME=InWaterA_1M/wkbGeom,InWaterA_1M/tileId&  TYPENAME=InWaterA_1M&  FILTER=<Filter><Within><PropertyName>InWaterA_1M/wkbGeom<PropertyName>  <gml:Envelope><gml:lowerCorner>10,10</gml:lowerCorner> <gml:upperCorner>20  20</gml:upperCorner></gml:Envelope></Within></Filter>

##### 3.1.2.2第二种：连接后发送XML方式

在连接到http://www.someserver.com/wfs 后，向其发送下面的XML：

 ![img](https://images0.cnblogs.com/blog/656746/201408/220704267994279.png)

##### 3.1.2.3对两种请求方式的小结

这两种方式中，Filter均是编写重点。Filter本身是一种基于XML的并且符合OGC规范的语言。WFS在所有需要定位操作对象的地方都会使用Filter。Filter的作用是构建一个表达式，返回值就是Feature的集合，换句话说Filter就如它的名字一般为我们从一个集合中过滤出一个满足我们要求的子集。而过滤的方法就是Filter定义的操作符。Filter定义了三种操作符：地理操作符（Spatial operators），比较操作符（Comparison operators）和逻辑操作符（Logical operators）。

Spatial operators定义了地理属性的操作方式，他们有：Equals、Disjoint、Touches、Within、Overlaps、Crosses、Intersects、Contains、Dwithin、Beyond、BBOX。

 Comparison  operators定义了标量属性的操作方式，他们有：PropertyIsEqualTo、PropertyIsNotEqualTo、PropertyIsLessThan、PropertyIsGreaterThan、PropertyIsLessThanOrEq、PropertyIsLike、PropertyIsNull、PropertyIsBetween。

 Logical operators逻辑操作符，定义了组合这些操作的方式，他们有：And、Or、Not。

在Query编写中，Geometry参数的编写也很重要，同时也有一定的难度，他需要我们对GML语言有一定的了解。这里给出GML的三个例子，分别对应point、box、Polygon：

 ![img](https://images0.cnblogs.com/blog/656746/201408/220704396125759.png)

 ![img](https://images0.cnblogs.com/blog/656746/201408/220704511591754.png)

 ![img](https://images0.cnblogs.com/blog/656746/201408/220705254242623.png)

如果我们希望前台直接向Geoserver发送请求，可以选择第一种URL方式。如果我们是通过我们的业务服务器转发对Geoserver的请求，建议使用第二种方式。第二种可以发送的数据量更大，并且易于形成标准请求。

## 4.矢量数据的组织

矢量数据本身的组织方式并没有规定的格式，可以视具体的项目而定。不过对于AGS和Geoserver返回的数据，是有固定格式的。这里我们分别给出例子。

### 4.1AGS的矢量数据组织格式

下图便为一个AGS标准的矢量数据格式：

 ![img](https://images0.cnblogs.com/blog/656746/201408/220705413153877.png)

它由attributes和geometry组成。Attributes中包含了查询得到的属性结果，geometry中则包含了查询所得要素的空间信息。针对不同的要素，返回的geometry的组织是各不相同的。Geometry对线和面分别有paths和rings两种数据组织格式。

### 4.2Geoserver的矢量数据组织格式

Geoserver中返回的矢量数据组织格式与AGS的差不多，需要注意的是两点：

（1）表示点、线、面的字段名称有不同之处。在Geoserver中线和面的字段名分别是：Line、Polygon| MultiPolygon。

（2）返回的坐标，相对于AGS中的坐标（X，Y），Geoserver中的是相反的，即为（Y，X）。

## 5.总结

在这一章里，我们对AGS和Geoserver中的WFS服务进行了详细的讲解。实际项目中，矢量图层的数据大多是来源于此服务所返回的数据的。我们回到我在本章开头时提出的第四个问题：矢量数据得到后如何使用？

矢量数据中的Geometry数据为地理坐标数据，我们在前端表现矢量图层时，是在要素（UIComponent）中画出Geometry的形状，所以这里就涉及到，如何将得到的地理坐标转换为对应的屏幕坐标，让前端的UIComponent上可以画出该要素形状。