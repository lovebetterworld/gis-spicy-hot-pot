- [简析GeoServer服务的内部文件组织以及GeoServer自动化服务发布工具的开发思路](https://www.cnblogs.com/naaoveGIS/p/4212093.html)

# 1.前言

通过GeoServer发布的服务，在GeoServer内部有固定的文件组织和构造。如果对该文件组织和构造有足够的了解，可以通过此规则来自己开发GeoServer服务的发布工具，简化工程人员的操作流程。此篇文章将跟大家一起探讨其中规则。

# 2.了解GeoServer中与服务相关的基本文件

在GeoServer的Data文件夹中有如下文件：

  ![img](https://images0.cnblogs.com/blog/656746/201501/082258536404727.png)          

其中，workspaces文件是图层服务相关的配置文件存放处。

styles文件夹是style相关文件的默认存放处。

## 2.1workspaces文件夹

此文件夹中包括了：namespace.xml，workspace.xml，datastore.xml，featuretype.xml，layer.xml。

此文件夹中的文件组织如下图：

 ![img](https://images0.cnblogs.com/blog/656746/201501/082259047966318.png)

## 2.2styles文件夹

 ![img](https://images0.cnblogs.com/blog/656746/201501/082259136712040.png)

 

 

# 3.以一个图层的发布为例，详解与此服务相关的各配置文件以及它们之间的关系

一个服务能够被GeoServer成功的发布，得益于GeoServer内部对与该服务相关的配置文件的读取。这里，我详细的与大家一起探讨一个以postGIS为数据源的图层服务的各配置文件的编写。

## 3.1编写workspace.xml和namespace.xml文件

workspace.xml的文件如下：

 ![img](https://images0.cnblogs.com/blog/656746/201501/082259235624819.png)

namespace.xml的文件如下：

 ![img](https://images0.cnblogs.com/blog/656746/201501/082259304371886.png)

**注意：**以上两个配置文件中，workspaceID和namespaceID在会接下来的配置文件中使用。

## 3.2编写datastore.xml文件

 ![img](https://images0.cnblogs.com/blog/656746/201501/082259442186774.png)

**注意：**其中namespaceUrl与之前的namespaceUrl要保持一致。DatasourceID在还在接下来的配置文件中使用。

## 3.3编写样式文件（test.sld和test.xml）

test.sld文件如下所示（具体sld如何编写可以参考我的博客http://www.cnblogs.com/naaoveGIS/p/4176198.html）：

 ![img](https://images0.cnblogs.com/blog/656746/201501/082259534537452.png)

test.xml的文件编写如下：

 ![img](https://images0.cnblogs.com/blog/656746/201501/082300023283175.png)

**注意：**text.xml中的filename配置为想要关联的sld文件。StyleName在接下来的配置文件中使用。

## 3.4编写featuretype.xml文件

该文件详细描述了所要发布的图层的信息，具体如下：

 ![img](https://images0.cnblogs.com/blog/656746/201501/082300087968298.png)

**注意：**此处datastoreID和namespaceID均使用以上配置中生成的ID。nativeName中使用postgis中数据源的名称（图层表名）。FeaturetypeID会在接下来的配置中使用。

## 3.5编写layer.xml文件

layer.xml为发布前的最后一个配置了，其具体配置如下：

 ![img](https://images0.cnblogs.com/blog/656746/201501/082300177343236.png)

**注意：**styleID和featuretypeID均为以上配置文件中生成的ID。

# 4.GeoServer自动化发布服务工具的探索

在了解了GeoServer发布一个图层所需的配置文件，以及各配置文件之间的联系后，我们可以基于这个规则制作一个GeoServer自动化发布服务的工具。其流程图如下：

 ![img](https://images0.cnblogs.com/blog/656746/201501/082300462502857.png)

**注意：**配置文件可以由模板生成，针对不同图层，在模板上修改即可。

# 5.结果展示

以下是通过自动化工具生成的文件：

 ![img](https://images0.cnblogs.com/blog/656746/201501/082300596876019.png)

![img](https://images0.cnblogs.com/blog/656746/201501/082301094218610.png)

 