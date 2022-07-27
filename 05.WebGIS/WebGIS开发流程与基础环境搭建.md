- [WebGIS开发流程与基础环境搭建 (qq.com)](https://mp.weixin.qq.com/s/PWivYb4pcwTWc6KqJkaPuA)

## **1、什么是WebGIS**

关于什么是`WebGIS`这个问题，我在之前的博客里面也陆陆续续写过好多次，今天继续占用大家一点时间再来介绍下，我感觉任何文本描述都比不上一张图来的实际，所以直接来看图：

WebGIS学习路线



![图片](https://mmbiz.qpic.cn/mmbiz_png/UpmXBibR8hUwibaSU5GA9O4leKGVNqYj5p8gibb33icOL5rld5XibtRnQEtpCZYOyWS1jiaL1ruI4ItkfqyVFTgguPYg/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

上图大概罗列了一下大家在接触`WebGIS`开发时听到的各种名词以及他们之间的包含关系，同时，这张图也可以作为你入门`WebGIS`的学习路线图，上述标明红色优先级的，是入门`WebGIS`开发必须要学习的内容。

如上图所示，`WebGIS`就是我们所说的前端开发和GIS开发的结合，其实就是Web开发的一个子领域，只不过这个Web系统里面包含了一些地图相关的操作，所以它被叫做`WebGIS`系统，例如我们经常看到的京东商城、淘宝商城、小米官方网站、百度地图、高德地图之类系统，他们之间的共同点就是都属于Web系统，区别在于前三个网站没有包含地图类的操作，后面两个系统里面包含地图类的操作，所以后两个我们就可以称之为`WebGIS`系统，当然，如果京东、淘宝之类的网站中后期增加了一些地图的操作，例如地址查询、路径导航规划等功能，我们照样可以将其称之为`WebGIS`系统。这样解释的话，是不是比百度百科对于`WebGIS`给出的解释更加通俗易懂了。

当然，我们刚才只是从开发层面对于`WebGIS`做了一个简单解释和范围划分，`WebGIS`其实包含很多东西，在此系列结束后我们返回来再给大家完整解释下`WebGIS`，相信那时候大家会对这个词有一个新的认知。

总结一下：`WebGIS`系统首先是一个Web系统，在这个Web系统中因为有一些地图相关的操作，我们将其称之为`WebGIS`系统。

## **2、WebGIS开发流程**

`WebGIS`的开发流程其实相对来说比较简单，跟我们正常的Web系统开发流程没有差别，但是因为其中涉及到了GIS方面的开发，所以相比Web开发来说多了一些工作需要我们开发人员来做，例如GIS模块需要用到的数据处理、服务发布、数据渲染等，当然，这些工作我们后续会给大家一一做介绍，在这里只是为了让大家有一个认知。一个比较完整的`WebGIS`系统开发流程我们看下图：

![图片](https://mmbiz.qpic.cn/mmbiz_png/UpmXBibR8hUwibaSU5GA9O4leKGVNqYj5phf3ySukanvmYIm8IKPRbzPIqtg6iasU8gG4VNxTwucHibAnPkMtRT39A/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

上图中列出了一个`WebGIS`系统开发的主要流程，其中涉及到的数据处理、服务发布等操作属于`WebGIS`开发领域独有的一些工作，这也是区别一般前端开发人员和`WebGIS`开发人员的边界，大家对此有一个大概的认知即可，后续的文章我们会给大家一一做介绍。

通过上述两部分的讲解，相信大家对`WebGIS`的开发有了一个大概的认知，接下来的文章我们真正进入到此系列的正文中。

## **3、WebGIS基础环境搭建**

WebGIS环境搭建主要分为两大块：数据处理环境和开发环境。其中数据处理环境又可以分为桌面端数据处理环境和服务器端服务托管环境，本文先来介绍下数据处理环境的搭建过程。

在整个WebGIS开发过程中，我们可以从数据流向的角度来梳理一下一份原始数据从我们拿到手到最终在地图上呈现的过程，如下图所示：

![图片](https://mmbiz.qpic.cn/mmbiz_png/UpmXBibR8hUzKlwv2UYAbo8qpynJJ7r26EiaZ111ECrq03ibn3OMxW0tN16Xn8T1kXJgHRkiaoNzEADs7jtISnw87A/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

图中大致描绘了一份原始数据从数据处理、服务发布到API调用渲染的完整步骤，以及在其中各个阶段中所用到的软件，今天我们就来介绍下数据处理环境的搭建，也就是上图中的数据处理环境和服务发布环境。此系列主要开通的是ArcGIS平台的技术栈，所以我们全程所用的软件都是ArcGIS系列软件，后期会给大家开通开源技术栈，欢迎大家关注学习。

数据处理环境搭建需要安装部署桌面端软件环境以及服务器端软件环境，两套环境中所使用的软件如下：

桌面端：

- ArcGIS Pro

服务器端：

- ArcGIS Server 
- Portal for ArcGIS
- ArcGIS Data Store
- ArcGIS Web Adaptor

### **3.1、桌面端数据处理环境搭建**

桌面端的环境搭建其实很简单，只需要安装一个数据处理软件即可，在此处我们推荐使用`ArcGIS Pro`。`ArcGIS Pro`软件使用之前需要有软件安装包和软件许可，其中软件安装包可以联系当地esri销售人员或者自己在网络上搜索下载，也可私信博主获取。安装包是一份exe的windows安装程序，没有mac版本。

软件许可可以联系当地esri销售人员购买或自己在网站购买个人版，也可在网站申请21天试用许可，网址如下：

```
https://www.esri.com/en-us/arcgis/products/arcgis-pro/trial(官方网站)
https://www.esri.com/zh-cn/arcgis/products/arcgis-pro/trial(中文网站)
```

`ArcGIS Pro`的安装部署很简单，按照其他windows程序安装一样，一路点击“下一步”即可安装成功，中途没有值的注意的地方，建议默认安装路径C盘，不要自行切换安装路径。安装完成后，使用拿到的许可账户登录`ArcGIS Pro`进行授权即可。

### **3.2、服务器端软件环境搭建**

相比于桌面端部署过程，服务器端的软件环境部署过程较为复杂，因为涉及到各个软件的安装以及相互之间的配置，所以建议搭建反复多联系几次，在这里值得注意的是服务器环境搭建时一定要在虚拟机中安装一套服务器系统环境，例如windows server系统或linux系统，不要在本机的windows 10或者windows 8甚至windows 7中进行，因为会给你带来很多很多意想不到的报错，这些报错你没有能力处理。

针对windows和linux环境下服务托管环境的部署，由于篇幅过长，步骤较多，我在这里整理了很详细的两篇文章，大家安装步骤一步一步操作即可，文章如下：

- 《[Portal for ArcGIS 10.7安装部署教程（windows环境）](http://mp.weixin.qq.com/s?__biz=MzU5MzY2OTU2NA==&mid=2247484058&idx=1&sn=e7d42880331b850d52465e1876ba325d&chksm=fe0dbe49c97a375fc098e86485c37b5d145ac9f2d708308c6e8002687b59ed8b0b965c28592a&scene=21#wechat_redirect)》
- 《[Portal for ArcGIS 10.7安装部署教程（centos7.6环境）](http://mp.weixin.qq.com/s?__biz=MzU5MzY2OTU2NA==&mid=2247484177&idx=1&sn=1050f28d13204460c047a06d4a2c2031&chksm=fe0dbfc2c97a36d4b384a6b3b9718453492076bb53528b0eb6ae2c6a500f6dcb22ea7422ff83&scene=21#wechat_redirect)》

如果不想看文字描述，也可以参考视频资料安装（最后一章），地址如下：

```
https://download.csdn.net/course/detail/27649
```

当然，在我们学习过程中还是不建议大家直接去上手安装部署Portal这一套服务器端环境，因为复杂的安装部署过程可能会让你失去学习WebGIS的信心。在这里我们推荐使用`ArcGIS Online`，这是一套esri官方在公网服务器上面已经安装部署好的Portal环境，你可以这么理解，我们只需要申请一个试用账号之后就可以使用它，当然你也可以直接购买个人版。

ArcGIS Online地址如下：

```
https://www.arcgis.com/index.html
```

经过上述两部分的介绍，我们WebGIS开发中数据处理环境的搭建基本完成，其实就是安装一个`ArcGIS Pro`软件，对于服务器端的环境我们直接用`ArcGIS Online`代替即可。如果涉及到公司内网真实的项目开发，需要用户自行购买正版软件，搭建服务器端的Portal环境来托管数据服务。