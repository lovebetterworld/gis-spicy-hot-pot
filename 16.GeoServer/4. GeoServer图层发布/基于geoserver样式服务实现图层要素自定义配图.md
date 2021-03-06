- [基于geoserver样式服务实现图层要素自定义配图](https://www.cnblogs.com/naaoveGIS/p/9732132.html)

# 1. 背景

​     在一般项目中，我们将geoserver样式服务中的SLD各参数写为了固定参数，这样整个与SLD关联的图层均会以此作为默认样式渲染。但是，当我们需要对图层中的某个特定要素进行自定义配图时，则会纠结于是否对该数据独立以图层发布，再单独配置一个样式供其使用呢。

​    如果只有少数几个要素需要单独配置则不失为一种方案，但是当几乎所有要素均需满足自定义配置时，该方案机会是不可能的。这里，我们需要利用到样式服务对动态参数的支持。

# 2.详细描述

​    a.将需要动态设置的样式值以数据源中的属性值命名：

 ![img](https://img2018.cnblogs.com/blog/656746/201809/656746-20180930155515378-1187154830.png)

​    b.在数据源中创建样式对应属性字段，发布：

 ![img](https://img2018.cnblogs.com/blog/656746/201809/656746-20180930155524308-659574883.png)

​    c.图层与动态样式服务关联：

 ![img](https://img2018.cnblogs.com/blog/656746/201809/656746-20180930155533138-524760388.png)

​    d:结果预览：

 ![img](https://img2018.cnblogs.com/blog/656746/201809/656746-20180930155546354-1141695582.png)

# 3.整体功能设计

![img](https://img2018.cnblogs.com/blog/656746/201809/656746-20180930155614987-494007439.png)

 