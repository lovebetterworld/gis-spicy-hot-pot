# GeoTools

Github地址：https://github.com/geotools/geotools



GeoTools 是一个开源的 Java GIS 工具包，可利用它来开发符合标准的地理信息系统。GeoTools 提供了 OGC(Open Geospatial Consortium)规范的一个实现来作为他们的开发。

GeoTools 被许多项目使用，包括 Web 服务，命令行工具和桌面应用程序。

![img](https://static.oschina.net/uploads/space/2020/0612/184241_eoac_4489239.png)

## 核心功能

- 定义关键空间概念和数据结构的接口

  - Java 拓扑套件（JTS）提供的集成几何支持
  - 使用 OGC 过滤器编码规范的属性和空间过滤器

- 干净的数据访问 API，支持功能访问，事务支持和线程之间的锁定

  - 以多种文件格式和空间数据库访问 GIS 数据
  - 坐标参考系统和转换支持
  - 处理广泛的地图投影
  - 根据空间和非空间属性过滤和分析数据

- 无状态的低内存渲染器，在服务器端环境中特别有用。

  - 撰写和显示样式复杂的地图
  - 供应商扩展，可以更好地控制文本标签和颜色混合

- 使用 XML 模式绑定到 GML 内容的强大*模式辅助*解析技术

  解析/编码技术提供了许多 OGC 标准的绑定，包括 GML，Filter，KML，SLD和SE。

- GeoTools 插件：开放式插件系统，可让您教授库其他格式

  - 用于 ImageIO-EXT 项目的插件，允许 GeoTools从GDAL 读取其他栅格格式

- GeoTools 扩展

  提供使用核心库的空间设施构建的其他功能。

  ![_images / extension.png](https://static.oschina.net/uploads/img/202006/12184334_LKR8.png)

  扩展提供图形和网络支持（用于查找最短路径），验证，Web 地图服务器客户端，用于 XML 解析和编码的绑定以及颜色调制器！

- 不支持 GeoTools

  GeoTools 也是更广泛的社区的一部分，其工作区用于培养新人才和促进实验。

  一些重点包括摇摆支持（在我们的教程中使用！），SWT，本地和 Web 流程支持，附加符号，附加数据格式，网格的生成以及 ISO Geometry的一些实现。