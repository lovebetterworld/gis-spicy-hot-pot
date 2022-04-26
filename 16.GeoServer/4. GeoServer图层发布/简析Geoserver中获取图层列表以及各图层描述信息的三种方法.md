- [简析Geoserver中获取图层列表以及各图层描述信息的三种方法](https://www.cnblogs.com/naaoveGIS/p/5257286.html)

# 1.背景

实际项目中需要获取到Geoserver中的图层组织以及各图层的描述信息：比如字段列表等。在AGS中，我们可以直接通过其提供的REST服务获取到图层组织情况以及图层详细信息列表，具体如下所示：

 ![img](https://images2015.cnblogs.com/blog/656746/201603/656746-20160309105857257-1533502274.png)

![img](https://images2015.cnblogs.com/blog/656746/201603/656746-20160309105908085-535039921.png)

那么在Geoserver中是否也有相关用法？各种方法之间有何优劣？

# 2.REST请求方法

## 2.1方法描述

该方法与上面讲解的AGS的REST请求方法类似，也是先获取到组织情况然后再进行各个图层的描述信息获取：

获取workspace信息：

 ![img](https://images2015.cnblogs.com/blog/656746/201603/656746-20160309105929069-439036951.png)

获取workspace下的datasource信息：![img](https://images2015.cnblogs.com/blog/656746/201603/656746-20160309105939366-763092509.png)获取workspace下datasource中的layer信息：

![img](https://images2015.cnblogs.com/blog/656746/201603/656746-20160309105959460-2015180204.png)

 

##  2.2 缺点

该方法在Geoserver中，必须先登陆获取到权限，发送rest请求时才能成功。在代码中如果不做模拟登陆直接发送请求，会报403错误。

 ![img](https://images2015.cnblogs.com/blog/656746/201603/656746-20160309110008616-493398916.png)

# 3.使用GeoServerManager开发包进行获取

## 3.1方法描述

### 3.1.1环境准备

该环境不仅仅只是需要引用geoserver-manager-1.6.0.jar，想要真正能够使用，还需要引用其多个依赖jar:

 ![img](https://images2015.cnblogs.com/blog/656746/201603/656746-20160309110019147-1425567759.png)

 ![img](https://images2015.cnblogs.com/blog/656746/201603/656746-20160309110026241-896914011.png)

### 3.1.2代码编写

 ![img](https://images2015.cnblogs.com/blog/656746/201603/656746-20160309110034725-1686447916.png)

## 3.2缺点

a.需要添加太多的jar。

b.对中文目前不能支持。当图层名为中文，以及当图层字段名有中文时均无法获取到。

# 4.通过WFS请求获取

在WFS请求中有一个DescribeFeatureType，具体描述可参考：http://docs.geoserver.org/stable/en/user/services/wfs/reference.html。

 ![img](https://images2015.cnblogs.com/blog/656746/201603/656746-20160309110045413-360694106.png)

获取到图层组织（http://192.168.101.14/geoserver/ows?service=wfs&version=2.0.0&request=DescribeFeatureType）：

 ![img](https://images2015.cnblogs.com/blog/656746/201603/656746-20160309110054725-514788321.png)

 获取具体图层的详细信息（http://192.168.101.14/geoserver/urbanlayer/ows?service=wfs&version=1.0.0&request=DescribeFeatureType&typeName=cell）：

 ![img](https://images2015.cnblogs.com/blog/656746/201603/656746-20160309110121929-1290519002.png)

# 5.总结

WFS方法即能支持中文字段、也能回避Jar的添加，而且权限上不再需要先做登陆，只需对返回的XML数据进行解析即可。综合来看，是目前首选的方法。