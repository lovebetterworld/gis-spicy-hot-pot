- [uDig 快速入门](http://live.osgeo.org/archive/8.0/zh/quickstart/udig_quickstart.html#id11)

# 启动 uDig

1. 从桌面 *Geospatial ‣ Desktop GIS ‣ uDig* 启动。
2. 系统初始化将花费一些时间。

[![../../_images/udig_Quickstart1Splash.png](http://live.osgeo.org/archive/8.0/_images/udig_Quickstart1Splash.png)](http://live.osgeo.org/archive/8.0/_images/udig_Quickstart1Splash.png)

　　若启动软件有任何问题，请查看 [Running uDig](http://udig.refractions.net/files/docs/latest/user/Running uDig.html) 文档。

# 欢迎界面

1. 首次启动时，欢迎界面将展示教程、文档和项目网站信息。
2. 点击箭头形的 Workbench 图标（右上角）开启主界面。

> [![../../_images/udig_welcome.png](http://live.osgeo.org/archive/8.0/_images/udig_welcome.png)](http://live.osgeo.org/archive/8.0/_images/udig_welcome.png)

　　在主界面菜单栏选择 *Help ‣ Welcome* 可以回到欢迎界面。

# 主界面

　　主界面提供了一种编辑面板（显示地图）和信息面板（显示与地图和要素有关的信息）。

> [![../../_images/udig_workbench.png](http://live.osgeo.org/archive/8.0/_images/udig_workbench.png)](http://live.osgeo.org/archive/8.0/_images/udig_workbench.png)

　　一个典型的 uDig 会话如下：

> 1. 图层 (1),
> 2. 项目 (2),
> 3. 编录 (3),
> 4. 地图 (4).

　　其具体功能详见后述。

# 文件

　　首先，读取 Live 系统上内建的数据集。

1. 从菜单选择 *Layer ‣ Add* 打开 **Add Data** 界面。

2. 从数据来源（data sources）选择 **Files** 。

3. 点击 *Next* 打开文件对话框。

4. 在 OSGeo-Live DVD 包含的示例数据位于：

   - `~/data` (a short cut to `/usr/local/share/data`)

5. 从 

   natural_earth2

    选择：

   - `ne_10m_admin_0_countries.shp`

6. 点击 

   Open

    打开。

   - 一个新的编辑器将启动。其默认名称和投影是根据源文件设定的。
   - 同时，在 **Catalog view** 显示了数据文件 `ne_10m_admin_0_countries.shp` 。这个面板显示当前 uDig 使用的数据。
   - 在 **Layers** 图层表显示了一个图层。该面板可以更改图层顺序和样式。
   - 在 **Projects** 工程面板可以看到当前工程是 projects > ne 10m admin 0 countries 。用户可以同时操作多个工程，各个工程也可以同时使用多个地图视图。

7. 从文件管理器打开 `~/data/natural_earth2/` 目录：

8. 将 `HYP_50M_SR_W.tif` 拖拽到地图试图即可添加新图层。

9. 图层表显示了图层的叠压顺序。当前 HYP_50M_SR_W 位于 ne 10m admin 0 countries 之上。

10. 选择 HYP_50M_SR_W 图层拖拽至列表底部。

> [![../../_images/udig_QuickstartCountriesMap.png](http://live.osgeo.org/archive/8.0/_images/udig_QuickstartCountriesMap.png)](http://live.osgeo.org/archive/8.0/_images/udig_QuickstartCountriesMap.png)

Note

企业和大型组织用户常常关心的一个问题是 uDig 的内存消耗。uDig 系统的内存资源占用很小，只有在必须渲染或操作时数据才会载入内存。

Tip

您也可以直接推拽 shp 文件载入。

# Map

　　在地图编辑界面中，顶部导航工具栏的工具可用于移动和缩放视野。

1. 缩放 

   

    是默认工具。

   - 拖拽放大到指定区域
   - 右键缩小，右键推拽将控制当前视野在缩放后的范围。

2. 平移 ![PAN](http://live.osgeo.org/archive/8.0/_images/udig_pan_mode.png) 工具用于移动视野。

3. 其它工具：

   - 全局试图 ![SHOWALL](http://live.osgeo.org/archive/8.0/_images/udig_zoom_extent_co.png)
   - 放大 ![ZOOM_IN](http://live.osgeo.org/archive/8.0/_images/udig_zoom_in_co.png) 和缩小 ![ZOOM_OUT](http://live.osgeo.org/archive/8.0/_images/udig_zoom_out_co.png) 每次动作的比例可以调节。
   - 回退 ![BNAV](http://live.osgeo.org/archive/8.0/_images/udig_backward_nav.png) 前进 ![FNAV](http://live.osgeo.org/archive/8.0/_images/udig_forward_nav.png) 可以返回之前的设置。

Tip

按住鼠标中键可以平移，滚轮可用于缩放。

# 网络地图服务（WMS）

　　使用 uDig 可以方便地使用众多的公共网络地图服务。本例使用 WMS 服务混合其它信息。

Note

若没有英特网连接，运行 *Geospatial ‣ Web Services ‣ GeoServer ‣ Start GeoServer* 可以获得一个本地 WMS 服务。该脚本会开启一个 “Service Capabilities” 并显示两个 WMS URL 。将其拖拽至 uDig 即可。

Tip

使用 **Add Data** （:menuselection:[`](http://live.osgeo.org/archive/8.0/zh/quickstart/udig_quickstart.html#id6)Layer –> Add...`）也可以连接 WMS 。

1. 从菜单选择 *File ‣ New ‣ New Map* 。

2. 点击 **Catalog** 旁边的 *Web* 更换至网络服务试图。

   > [![../../_images/udig_WebViewClick.png](http://live.osgeo.org/archive/8.0/_images/udig_WebViewClick.png)](http://live.osgeo.org/archive/8.0/_images/udig_WebViewClick.png)

3. 点击 link WMS:[dm solutions](http://www2.dmsolutions.ca/cgi-bin/mswms_gmap?Service=WMS&VERSION=1.1.0&REQUEST=GetCapabilities) 连接

   > 

4. 在 Resource Selection 选择：

   - Elevation/Bathymetry

   - Parks

   - Cities

     > [![../../_images/udig_AddWMSLayers.png](http://live.osgeo.org/archive/8.0/_images/udig_AddWMSLayers.png)](http://live.osgeo.org/archive/8.0/_images/udig_AddWMSLayers.png)

5. 点击 *Finish* 添加图层

   > [![../../_images/udig_WMSMap.png](http://live.osgeo.org/archive/8.0/_images/udig_WMSMap.png)](http://live.osgeo.org/archive/8.0/_images/udig_WMSMap.png)

6. 使用 ![ZOOM](http://live.osgeo.org/archive/8.0/_images/udig_zoom_mode.png) 放大至一个公园（park）

7. 使用 ![INFO](http://live.osgeo.org/archive/8.0/_images/udig_info_mode.png) 属性工具点击一个要素了解其属性

Tip

使用 Z 和 I 可以在两个工具间快速切换。

# 样式

1. 选择 project > ne 10m admin 0 countries 并双击打开。

2. 选择 countries 图层。

3. 右击 ne 10m admin 0 countries 选择 *Change Style* 打开 **Style Editor** 样式编辑器。

4. 调整该图层的几个样式设置：

   - 边界线：点击 *Border* 选择颜色（color）并调整。
   - 填充：点击 *Fill* 并取消 *enable/disable fill* 可关闭填充。
   - 标注：点击 *Labels* 选择 *enable/disable labeling* 并选中 **NAME** 字段用于标注。

   ![../../_images/udig_StyleEditor.png](http://live.osgeo.org/archive/8.0/_images/udig_StyleEditor.png)

5. 点击 *Apply* 应用样式，在 **Layer** 视图中的渲染结果会更新。

6. 点击 *Close* 关闭。

Note

有些文件可以存储样式信息，例如 `*.sld` 。其主文件名同相应的数据文件应相同。这样的 [*Styled Layer Description (SLD)*](http://live.osgeo.org/archive/8.0/zh/standards/sld_overview.html) 样式文件存在时会被自动应用。

　　若图层较多，编辑样式时可能难以看清效果。点击 *Map ‣ Mylar* 并在 *Layer* 试图关闭一些图层可能有助于编辑。再次选取 *Map ‣ Mylar* 可以关闭这一效果。

> [![../../_images/udig_MapMylar.png](http://live.osgeo.org/archive/8.0/_images/udig_MapMylar.png)](http://live.osgeo.org/archive/8.0/_images/udig_MapMylar.png)

# 其它尝试

　　您可以继续尝试其它操作：

1. 添加您自己的数据或 [*Web Feature Service*](http://live.osgeo.org/archive/8.0/zh/standards/wfs_overview.html) 服务。
2. 更改 WFS 样式。

# 其它信息

　　完成以上基本的演示后，您可以通过 **Walkthrough** 文档了解更多有关 uDig 的具体信息。

- Walkthrough 1

  使用 [*PostGIS*](http://live.osgeo.org/archive/8.0/zh/overview/postgis_overview.html) 从 WFS 读取要素。了解 **Themes** 主题配置和 Color Brewer 技术。

  `/usr/local/share/udig/udig-docs/uDigWalkthrough 1.pdf`

- Walkthrough 2 - 学习如何创建 shp 文件并编辑要素数据。本文涉及安装 [*GeoServer*](http://live.osgeo.org/archive/8.0/zh/overview/geoserver_overview.html) 和配置 WFS 。

  地址：http://udig.refractions.net/