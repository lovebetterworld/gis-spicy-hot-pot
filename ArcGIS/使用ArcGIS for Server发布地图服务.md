- [使用ArcGIS for Server发布地图服务](https://www.cnblogs.com/ssjxx98/p/12565211.html)

# 一、安装ArcGIS for Server

这里可以参考[ArcGIS for Server 10.2下载及安装](https://blog.csdn.net/nominior/article/details/80211963)这篇博客安装ArcGIS for Server 10.2 。需要注意一点，在同一台机器上，ArcGIS for Server 的版本需要与已有的 ArcGIS for Desktop的版本一致。

安装好之后，会自动打开http://localhost:6080/arcgis/manager/，首次进入需要创建站点管理员账户，并配置服务器站点的文件位置，创建完成之后登录即可。

![Snipaste_2020-03-24_20-24-43](https://s1.ax1x.com/2020/03/25/8XrN1s.png)

# 二、发布地图服务

ArcGIS发布地图服务有三种方式，具体参考[ArcGIS发布地图服务--ArcMap](https://blog.csdn.net/fyc__iOS/article/details/93093871)。这里介绍最常用的通过**ArcMap**发布地图服务。

1. 在ArcMap新建一个mxd，导入待发布的地图数据，并按自己的需求配置地图。

   这一步就是对ArcMap的使用，比较熟悉的同学很快就能完成。

2. 将配置好的地图发布为服务。

   在File目录下找到Share As，选择Service进行地图发布

![Snipaste_2020-03-24_20-26-15](https://s1.ax1x.com/2020/03/25/8XraXq.png)

选择Publish a service，并单击下一步，如图：

![Snipaste_2020-03-24_20-17-28](https://s1.ax1x.com/2020/03/25/8Xr178.png)

连接ArcGIS for Server的站点，其中：

- Server URL：指ArcGIS for Server站点的URL，默认是安装ArcGIS for  Server之后跳出来的页面的URL。如果Server在本地即为http://localhost:6080/arcgis，如果是远程，应为http://ip:port/arcgis。
   至于ArcGIS Spatial Data Server（空间数据服务器），与ArcGIS for Server不同，它是一个轻量级，占用很小内存的服务器。不过在这里我们不作讨论。
- Server Type：选择ArcGIS Server
- Staging Folder： 默认就好
- Authentication：需要输入对ArcGIS Server站点具有发布者权限的用户名和密码。这里输入我们之前创建的站点管理员用户名和密码即可。

点击Finish，稍作等待即可完成对ArcGIS Server的连接。

![Snipaste_2020-03-24_20-19-40](https://s1.ax1x.com/2020/03/25/8Xrl0f.png)

设置发布服务的名称，并选择发布服务的文件位置。

![Snipaste_2020-03-24_20-20-30](https://s1.ax1x.com/2020/03/25/8XrQnP.png)![Snipaste_2020-03-24_20-20-42](https://s1.ax1x.com/2020/03/25/8XrKXt.png)

1. 接下来会弹出一个Service Editor窗口，可以在里面修改一些服务参数以及服务类型等，右上角的Preview可以预览当前服务，如果能够正常显示我们的地图，那么可以点击Publish发布地图。
    ![Snipaste_2020-03-24_20-23-48](https://s1.ax1x.com/2020/03/25/8XrJhQ.png)

注意：如果点击Publish之后出现如下错误，说明Data Frame没有设置空间参考。在View中点击Data Frame Properties，设置一种空间参考即可（这里我选择地理坐标系的WGS 84，WKID 4326相当于EPSG 4326）。

![Snipaste_2020-03-24_20-22-33](https://s1.ax1x.com/2020/03/25/8Xr8AS.png)![Snipaste_2020-03-24_20-22-58](https://s1.ax1x.com/2020/03/25/8XrGtg.png)

# 三、登录ArcGIS Server站点查看发布的地图

通过http://localhost:6080/arcgis/manager访问本地的ArcGIS Server 管理器，输入管理员用户名、密码登录站点。刷新一下服务，可以看到我们刚才发布的地图服务。

点击下图中圈出来的位置就可以预览发布的地图啦！

![Snipaste_2020-03-24_20-25-07](https://s1.ax1x.com/2020/03/25/8XrUcn.png)

------

当然，除了ESRI的ArcGIS for Server，商业化的软件还有Autodesk公司 推出的MapGuide  Enterprise（也有免费的开源版本MapGuide OpenSource），超图公司的SuperMap iServer等，有兴趣可以尝试。