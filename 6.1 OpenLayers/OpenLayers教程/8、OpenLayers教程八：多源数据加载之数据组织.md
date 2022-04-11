- [OpenLayers教程八：多源数据加载之数据组织](https://blog.csdn.net/qq_35732147/article/details/94441579)



数据是GIS的血液，可以说GIS应用系统的几乎所有活动与行为都围绕数据展开。那么在GIS对数据加载、存储、分析与操作这几个过程中，我们首先讨论在由OpenLayers构建的WebGIS系统中，数据如何合理加载。    

随着WebGIS应用的不断发展，目前出现了大量网络地图服务资源，包括国外互联网公司的Google地图、Bing 地图、Yahoo 地图，国外的开源地图OpenStreetMap，也包括国内互联网公司的百度地图、高德地图、腾讯地图。还有ESRI、超图、中地数码等大型GIS厂商提供的自定格式的GIS数据，以及其他企事业单位或研究机构提供的各种格式的GIS数据等。如何将这些多源异构数据加载到Web客户端中进行显示，实现数据无缝融合，这是WebGIS中需要首先解决的关键问题。

OpenLayers的地图数据通过图层（Layer）进行组织渲染，然后通过数据源（Source）设置具体的地图数据来源。

Layer可看作渲染地图的层容器，具体的数据需要通过Source设置。

地图数据根据数据源（Source）可分为Image、Tile、Vector三大类型的数据源类，对应设置到地图图层（Layer）的Image、Tile、Vector三大类的图层中。其中，矢量图层Vector通过样式（Style）来设置矢量要素渲染的方式和外观。

Source和Layer是一对一的关系，有一个Source，必然需要一个Layer，然后把Layer添加到Map上，就可以显示出来了。

![img](https://img-blog.csdn.net/20180727115727932?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)



在数据源中：

- Tile类为瓦片抽象基类，其子类作为各类瓦片数据的数据源。
- Vector类为矢量数据源基类，为矢量图层提供具体的数据来源，包括直接组织或读取的矢量数据（Features）、远程数据源的矢量数据（即通过url设置数据源路径）等。若是url设置的矢量数据源，则通过解析器Format（即ol.format.Feature的子类）来解析各类矢量数据，如XML、Text、JSON、GML、KML、GPS、WFS、WKT、GeoJSON等地图数据。
- Image类为单一图像基类，其子类为画布（canvas）元素、服务器图片、单个静态图片、WMS单一图像等的数据源。它与Tile类的区别在于，Image类对应的是一整张大图片，而不像瓦片那样很多张小图片，从而无需切片，也可以加载一些地图，适用于一些小场景地图。



从复杂度来分析，Image类和Vector类都不复杂，其数据格式和来源方式都简单。而Tile类则不一样，由于一些历史问题，多个服务提供商，多种标准等诸多原因，导致要支持世界上大多数的瓦片数据源，就需要针对这些差异（这些差异主要是瓦片坐标系不同、分辨率不同等，后面会详细介绍）提供不同的Tile数据源支持。我们先来看一下OpenLayers现在支持的Source具体有哪些：

![img](https://img-blog.csdnimg.cn/20190702151246260.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

上图中的类是按照继承关系，从左向右展开的，左边的为父类，右边的为子类。在使用时，一般来说，都是直接使用叶子节点上的类，基本就可以完成需求。父类需要自己进一步扩展或者处理才能有效使用。

我们先了解最为复杂的ol.source.Tile，其叶子节点类有很多，大致可以分为几类：

- 在线服务的Source，包括ol.source.BingMaps（使用的是微软提供的Bing在线地图数据）、ol.source.Stamen（使用的是Stamen提供的在线地图数据）。没有自己的地图服务器的情况下，可直接使用它们，加载地图底图。
- 支持协议标准的Source，包括ol.source.TileArcGISRest、ol.source.TileWMS、ol.source.WMTS、ol.source.UTFGrid、ol.source.TileJSON。如果要使用它们，首先你得先学习对应的协议，之后必须找到支持这些协议的服务器来提供数据源，这些服务器可以是底图服务提供商提供的，也可以是自己搭建的服务器，关键是得支持这些协议。
- ol.source.XYZ，这个需要单独提一下，因为是可以直接使用的，而且现在很多地图服务（在线的，或者自己搭建的服务器）都支持xyz方式的请求。国内在线的地图服务，高德、天地图等，都可以通过这种方式加载，本地离线瓦片地图也可以，用途广泛，且简单易学。

ol.source.Image虽然有几种不同的子类，但大多比较简单，因为不牵涉到过多的协议和服务提供商。而ol.source.Vector就更加简单了，但有时候其唯一的子类ol.source.Cluster在处理大量的要素时，我们可能需要使用。

在大概了解了整个Source之后，紧接着该介绍它的搭档Layer了，同样的，我们还是先从OpenLayers现有的Layer类图大致了解一下：

![img](https://img-blog.csdn.net/20180731110040946?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

为了便于了解和使用，图中标注了每一个Layer对应的Source。通过上图可以看到Layer相对于Source而言，真是太简单了。

其中ol.layer.Group是一个用于将多个图层存储在一起的集合类。