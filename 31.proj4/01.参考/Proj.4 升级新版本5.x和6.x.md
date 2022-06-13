- [Proj.4 升级新版本5.x和6.x - 乌合之众 - 博客园 (cnblogs.com)](https://www.cnblogs.com/oloroso/p/10955620.html)

## 0、缘起[#](https://www.cnblogs.com/oloroso/p/10955620.html#3660024020)

今天（2019年5月30日）去编译最新版本的GDAL，发现其对Proj.4的依赖已经要求为6.x版本了。于是去https://github.com/OSGeo/proj.4看了一下最新的代码，又去https://proj4.org/看了一下文档，感觉5.x和6.x的更新挺大的，有必要测试一下，看工作中的项目是不是要升级过来。

## 1、5.x和6.x更新情况简述[#](https://www.cnblogs.com/oloroso/p/10955620.html#4226194041)

我没有仔细去看5.x版本的代码，仅看了一下最新的`Proj.4` 版本6的代码，与早前使用的4.9.3版本简单对比了一下，感觉区别还是挺大的，这里列出几点我关注的地方的对比。

1、新版本改用C++编写，相比4.9版本代码量增加了不少，功能也多了不少。代码层次结构清晰了许多，比如各种转换算法都在[src/transformations](https://github.com/OSGeo/proj.4/tree/master/src/transformations)目录下可以找到，各种投影方法相关的算法都在[src/projections](https://github.com/OSGeo/proj.4/tree/master/src/projections)目录可以找到。

2、支持了从`WKT/WKT2`字符串和EPSG代码直接创建坐标系对象，也支持导出WKT字符串。老版本中记录EPSG坐标系定义的的[nad/epsg](https://github.com/OSGeo/proj.4/blob/4.9.2-maintenance/nad/epsg)被弃用，改用SQLite数据库来记录（在[data/sql](https://github.com/OSGeo/proj.4/tree/master/data/sql/)目录下保存着用于生成`proj.db`文件的SQL脚本），不过新版本需要依赖SQLite3。

3、新版的实现使用了缓存机制，在创建操作坐标系对象及搜索查找等都有用到。代码可见 [src/iso19111/factory.cpp](https://github.com/OSGeo/proj.4/tree/master/src/factory.cpp)、[src/iso19111/crs.cpp](https://github.com/OSGeo/proj.4/tree/master/src/crs.cpp)、[src/iso19111/coordinateoperation.cpp](https://github.com/OSGeo/proj.4/tree/master/src/coordinateoperation.cpp)、

[src/iso19111/coordinateoperation.cpp](https://github.com/OSGeo/proj.4/tree/master/src/io.cpp) 等文件。

4、新版添加了[proj_math.h](https://github.com/OSGeo/proj.4/tree/master/src/proj_math.h)、[math.cpp](https://github.com/OSGeo/proj.4/tree/master/src/math.cpp)，添加了`pj_hypot`等函数，这解决了一些编译问题（因为之前版本projects.h中声明了`hypot`函数，但这个函数在非_WIN32环境中也可能是存在math.h中的）。

以下主要翻译自：[PROJ.4 News](https://proj4.org/news.html#release-notes)

### PROJ 5.x 更新[#](https://www.cnblogs.com/oloroso/p/10955620.html#2152714815)

此版本的 PROJ 对系统的大地测量功能 (主要是) 引入了一些重要的扩展和改进。

引入新功能的主要驱动因素是动态参考框架的出现、高精度全球导航卫星系统的使用日益增加以及对精确坐标变换的相关需求的增加。虽然旧版本的 PROJ 包含一些大地测量功能, 但新框架为将 PROJ 转变为通用地理空间坐标转换引擎奠定了基础。

内部架构也有了许多变化和改进。到目前为止，这些改进都遵循现有的编程接口。但是这个过程已经显示出需要简化和减少代码库，以支持持续的主动开发。

新的主要版本号使该项目在名称上留下了一些难题。在产品的大部分使用寿命中，它被称为PROJ.4，但由于我们现在已达到版本5，因此名称不再与版本号对齐。

因此，我们决定将名称与版本号和该版本分离，然后将产品简称为PROJ。为了表彰软件的历史，我们将PROJ.4作为组织项目的名称。同一个项目团队也会生成datum-grid 包。

综上所述:

- PROJ.4项目提供产品PROJ，现在版本为5.0.0。
- PROJ的基础组件是库libproj。
- 其他PROJ组件包括应用程序proj，它为libproj提供命令行界面。
- PROJ.4项目还分发了基准网格(datum-grid)包，在编写本文时，它是1.6.0版本。

#### 5.0.0 更新[#](https://www.cnblogs.com/oloroso/p/10955620.html#2701965300)

- 推出新的API在`proj.h`
  - 新版API增加了4D空间坐标转换功能
  - 新API中的函数使用`proj_`命名空间(名称前缀)
  - 新API中的数据类型使用`PJ_`命名空间(名称前缀)
- 引入“转换管道”(transformation pipelines)的概念，可以通过 [菊花链](https://baike.baidu.com/item/菊花链#3) 的方式简化坐标操作，可以对坐标进行复杂的大地转换。
- 采用 **OGC/ISO-19100** 地理空间标准系列术语。关键定义是：
  - 在通用层面上，坐标操作是基于从一个坐标参考系统到另一个坐标参考系统的一对一关系的坐标变换。
  - 变换(*transformation* )是一种坐标操作，其中两个坐标参考系统基于不同的基准，例如，从全局参考框架改变到区域框架。
  - 转换(*conversion* )是一种坐标操作，其中两个坐标参考系统都基于相同的数据，例如，坐标单位的变化。
  - 投影是从椭球坐标系到平面坐标系的坐标转换。虽然投影只是根据标准进行的转换, 但它们在 PROJ 中被视为单独的实体, 因为它们占库中绝大多数操作。
- 新操作
  - 管线操作 [The pipeline operator](https://proj4.org/operations/pipeline.html#pipeline) (`pipeline`)
  - 变换 Transformations
    - 霍默特变换 [Helmert transform](https://proj4.org/operations/transformations/helmert.html#helmert) (`helmert`)
    - 霍纳实数和复数的多项式评估 (`horner`)
    - [Horizontal gridshift](https://proj4.org/operations/transformations/hgridshift.html#hgridshift) (`hgridshift`)
    - [Vertical gridshift](https://proj4.org/operations/transformations/vgridshift.html#vgridshift) (`vgridshift`)
    - 莫洛金斯基变换 [Molodensky transform](https://proj4.org/operations/transformations/molodensky.html#molodensky) (`molodensky`)
    - [Kinematic gridshift with deformation model](https://proj4.org/operations/transformations/deformation.html#deformation) (`deformation`)
  - 转换 Conversions
    - 单位转换 [Unit conversion](https://proj4.org/operations/conversions/unitconvert.html#unitconvert) (`unitconvert`)
    - 轴向交换 [Axis swap](https://proj4.org/operations/conversions/axisswap.html#axisswap) (`axisswap`)
  - 投影 Projections
    - 中央圆锥投影 [Central Conic projection](https://proj4.org/operations/projections/ccon.html#ccon) (`ccon`)
- 新的“自由格式”(free format)选项，运行在指定**key/value**键值对时候通过空白字符进行分割标记，例如`proj = merc lat_0 = 45`
- 添加到**init-files**的元数据，可以通过`proj.h`中新的API函数`proj_init_info()`读取它们。
- 添加了具有ITRF转换参数的ITRF2000，ITRF2008和ITRF2014初始化文件，包括板块运动模型参数。
- 添加椭球参数到GSK2011,PZ90和"danish"。后者类似于已经支持的andrae椭球体，但长半轴略微不同。
- 添加哥本哈根本初子午线.
- 将EPSG数据库更新至9.2.0版。
- Geodesic库已更新至1.49.2-c版。
- 对分析性偏导数的支持已被移除。
- 改善了Winkel Tripel和Aitoff的表现。
- 将`pj_has_inverse()`函数引入`proj_api.h`，使用它检测一个操作是否可反转，而不是检测`P->inv`是否存在。
- ABI版本号更新为13:0:0。
- 删除了对Windows CE的支持。
- 删除了VB6 COM接口。

#### 5.1.0 更新[#](https://www.cnblogs.com/oloroso/p/10955620.html#413958589)

- 添加函数[`proj_errno_string()`](https://proj4.org/development/reference/functions.html#c.proj_errno_string) 到 `proj.h`
- 验证管道步骤之间的单位，并确保转换的完整性。
- 在没有参数的情况下调用[cct](https://proj4.org/apps/cct.html#cct)和[gie](https://proj4.org/apps/gie.html#gie)程序时打印帮助。
- CITATION文件添加到源码发行。
- 添加了Web墨卡托操作。
- 提高了赤道附近(4326)向spherical Mercator(3857)前向转换的数值精度。
- 为cct添加了`--skip-lines`选项。
- 始终对输入`NaN` 处返回`Nan`值。
- 移除没有使用的`src/org_proj4_Projections.h`文件。
- Java Native Interface绑定已更新
- 水平和垂直网格移位操作扩展到时域(temporal domain)。

#### 5.2.0 更新[#](https://www.cnblogs.com/oloroso/p/10955620.html#2899139392)

- 在unitconvert中增加了对deg，rad和grad的支持。
- 当没有另外指定时，假设`+t_epoch`为时间输入。
- 添加了逆拉格朗日投影。
- 添加`-multiplier`选项到vgridshift。
- 添加等地球投影。（等地球地图投影是用于世界地图的新的等面积假圆柱投影）
- 为gie添加了“require_grid”选项。
- 将 Helmert 变换的`+transpose`选项替换为`+convention`。从现在开始应当显示指定convertion使用，使用+transpose选项将返回错误。
- 改进的逆spherical Mercator投影数值精度
- 当前**cct**会将前向输入的坐标，转发到输出流。 ([#1111](https://github.com/OSGeo/proj.4/issues/1111))

### PROJ 6.x 更新[#](https://www.cnblogs.com/oloroso/p/10955620.html#485446990)

PROJ6 进行了广泛的更改, 以增加其功能范围, 从具有所谓 "早期绑定" 大地测量基准转换功能的制图投影引擎, 到更完整的库, 支持坐标变换和坐标参考系统。

作为其他增强功能的基础, PROJ 现在包括由 iso-19111:2019 标准/OGC 抽象规范主题 2: "按坐标引用" 的模型的 C++ 实现, 用于大地测量参照框 (基准), 坐标参考系统和协调操作。这些大地测量对象的构造和查询可通过新的 C++ API 进行, 并且在很大程度上可以从 C API 中的绑定中访问。

这些大地测量对象可以从 OGC 已知文本格式 (WKT) 以不同的变体导入和导出: ESRI WKT、GDAL WKT 1、WKT2:2015 (ISO 191.2: 2015) 和 WKT2:2018 (ISO 19162: 2018)。还支持从 PROJ 字符串导入和导出 crs 对象。此功能以前在 GDAL 软件库中可用 (WKT2 支持除外, 这是一项新功能), 现在是 PROJ 不可或缺的一部分。

现在, sqlite3 数据库文件 **proj.db** 中提供了一个统一的大地测量对象数据库、坐标参考系统及其元数据以及这些 CRS 之间的坐标操作。这包括从 IOMP EPSG 数据集 (v9.6.0 版本)、法国国家测绘机构大地测量登记册和 ESRI 投影引擎数据库中导入的定义。PROJ 现在是此 CRS 和坐标操作数据库的 "OSGeo C stack" 中的参考软件, 而以前此功能分布在 PROJ、GDAL 和歌词地理, 并使用 CSV 或其他基于特定文本的格式。

添加了考虑到元数据 (如使用区域和准确性) 的后期绑定坐标操作功能。这可以在许多情况下避免过去使用 WGS84 作为中间系统的要求, 这可能会导致不必要的精度损失, 或者在无法转换到 WGS84 的情况下有时是无法实现的。这些后期绑定功能现在由 proj_create_crs_to_crs() 函数和 cs2cs 实用程序使用。

添加了一个新的命令行实用程序 projinfo 来查询有关数据库的大地测量对象的信息, 从 WKT 字符串和 PROJ 字符串导入和导出大地测量对象, 并显示两个 CRS(坐标参考系统) 之间可用的坐标操作。

#### 6.0.0 更新[#](https://www.cnblogs.com/oloroso/p/10955620.html#2813567082)

- 公开接口中移除projects.h（当前仅作为内部接口）([#835](https://github.com/OSGeo/proj.4/issues/835))
- 不推荐使用proj_api.h接口。头文件仍然可用，但将在下一个主要版本的PROJ中删除。现在需要定义`ACCEPT_USE_OF_DEPRECATED_PROJ_API_H`宏接口才可用。 ([#836](https://github.com/OSGeo/proj.4/issues/836))
- 删除了对nmake构建系统的支持。([#838](https://github.com/OSGeo/proj.4/issues/838))
- 删除对`proj_def.dat` 默认文件的支持。 ([#201](https://github.com/OSGeo/proj.4/issues/201))
- 构建PROJ需要支持C++11编译器。
- 构建添加对SQLite 3.7的依赖。([#1175](https://github.com/OSGeo/proj.4/issues/1175))
- 添加 **projinfo** 命令行程序。
- 添加一些用于处理ISO19111功能函数的到`proj.h`。([#1175](https://github.com/OSGeo/proj.4/issues/1175))
- 更新了cs2cs以使用后期绑定特性。([#1182](https://github.com/OSGeo/proj.4/issues/1182))
- 移除 `nad2bin` 程序。现在可以在[proj-datumgrid](https://github.com/OSGeo/proj-datumgrid)仓库中查看。
- 在proj中删除了对Chebyshev多项式的支持
- 从proj.h中移除`proj_geocentric_latitude()` API
- 更改**proj**行为：现在只允许投影的初始化 ([#1162](https://github.com/OSGeo/proj.4/issues/1162))
- 更改[tmerc](https://proj4.org/operations/projections/tmerc.html#tmerc)行为：现在默认扩展横轴墨卡托算法 (`etmerc`)。旧的实现可以通过添加 `+approx`参数([#404](https://github.com/OSGeo/proj.4/issues/404))
- 更改行为：默认椭球现在设置为GRS80 (之前是WGS84) ([#1210](https://github.com/OSGeo/proj.4/issues/1210))
- 允许在 [`PROJ_LIB`](https://proj4.org/usage/environmentvars.html#envvar-PROJ_LIB) 环境变量中使用多个目录 ([#1218](https://github.com/OSGeo/proj.4/pull/1218))
- 添加[Lambert Conic Conformal (2SP Michigan)](https://proj4.org/operations/projections/lcc.html#lcc) 投影 ([#1142](https://github.com/OSGeo/proj.4/issues/1142))
- 添加 [Bertin1953](https://proj4.org/operations/projections/bertin1953.html#bertin1953) 投影 ([#1133](https://github.com/OSGeo/proj.4/issues/1133))
- 添加[Tobler-Mercator](https://proj4.org/operations/projections/tobmerc.html#tobmerc) 投影 ([#1153](https://github.com/OSGeo/proj.4/issues/1153))
- 添加[Molodensky-Badekas](https://proj4.org/operations/transformations/molobadekas.html#molobadekas) 变换 ([#1160](https://github.com/OSGeo/proj.4/issues/1160))
- 添加[push](https://proj4.org/operations/conversions/push.html#push) 和[pop](https://proj4.org/operations/conversions/pop.html#pop) 坐标操作 ([#1250](https://github.com/OSGeo/proj.4/issues/1250))
- 添加`+t_obs` 参数，从helmert 和deformation中 ([#1264](https://github.com/OSGeo/proj.4/issues/1264))
- 添加[`+dt`](https://proj4.org/operations/transformations/deformation.html#cmdoption-arg-dt) 参数到deformation中，用于替换移除的 `+t_obs` ([#1264](https://github.com/OSGeo/proj.4/issues/1264))

#### 6.1.0 更新[#](https://www.cnblogs.com/oloroso/p/10955620.html#2445104813)

- 包含 QGIS 中定义的椭球 ([#1137](https://github.com/OSGeo/proj.4/issues/1337))
- 添加 `-k ellipsoid` 选项到 projinfo ([#1338](https://github.com/OSGeo/proj.4/issues/1338))
- cs2cs支持4D坐标 ([#1355](https://github.com/OSGeo/proj.4/issues/1355))
- WKT2 解析：更新到OGC 18-010r6 ([#1360](https://github.com/OSGeo/proj.4/issues/1360) [#1366](https://github.com/OSGeo/proj.4/issues/1366)))
- 更新googletest内部版本到v1.8.1 ([#1361](https://github.com/OSGeo/proj.4/issues/1361))
- 数据库更新：EPSG v9.6.2 ([#1462](https://github.com/OSGeo/proj.4/issues/1462)), IGNF v3.0.3, ESRI 10.7.0 并添加operation_version列([#1368](https://github.com/OSGeo/proj.4/issues/1368))
- 添加[`proj_normalize_for_visualization()`](https://proj4.org/development/reference/functions.html#c.proj_normalize_for_visualization) 尝试应用大多数 GIS 应用和 PROJ <6 使用的轴序 ([#1387](https://github.com/OSGeo/proj.4/issues/1387))
- 添加 noop（空）操作 ([#1391](https://github.com/OSGeo/proj.4/issues/1391))
- 用户设置的路径优先于 [`PROJ_LIB`](https://proj4.org/usage/environmentvars.html#envvar-PROJ_LIB) 搜索路径 ([#1398](https://github.com/OSGeo/proj.4/issues/1398))
- 缩小数据库大小 ([#1438](https://github.com/OSGeo/proj.4/issues/1438))
- 添加对compoundCRS 和concatenatedOperation组件命名的支持 ([#1441](https://github.com/OSGeo/proj.4/issues/1441))

## 2、从PROJ.4向新版本迁移[#](https://www.cnblogs.com/oloroso/p/10955620.html#1368038709)

以下内容主要来自[Version 4 to 5/6 API Migration](https://proj4.org/development/migration.html)。

### 迁移到5.x版本[#](https://www.cnblogs.com/oloroso/p/10955620.html#2295975532)

这是希望将代码迁移到使用PROJ 5的开发人员的过渡指南。

#### 背景[#](https://www.cnblogs.com/oloroso/p/10955620.html#365422874)

原文太长，这里简单抽取一部分。

- 1、之前老的API两个坐标参考系统之间的任何转换都必须通过未明确定义的WGS84框架进行中转，新的API取消了对PROJ中转换的限制。虽然任然可以进行这种类型的转换，但是在多数情况下，有更好的替代方案。

- 2、如果你只关心到米级精度，那么旧的API是够用的。但是WGS84并非真实世界的基础，其它一切都可以通过WGS84进行转换的观点是有缺陷的。并且这里说的WGS84是6个实现中的哪一个呢？

- 3、对许多坐标系统而言，转换到WGS84，在旧系统之间可能变换精度在厘米级。

- 4、hub（这里说的就是把所有坐标之间的转换都通过WGS84做中转）框架（"基准"）概念本身没有大问题。但世界本质是4维的，为了获得大地测量精确变换，可能需要在四个维度下计算，新的API允许这样做。

- 旧的API下，坐标从坐标系A转换到坐标系B的过程，需要从A变换到WGS84（反算），再从WGS84变换到B（正算）

  ```c
  Copy Highlighter-hljs$ echo 300000 6100000 | cs2cs +proj=utm +zone=33 +ellps=GRS80 +to +proj=utm +zone=32 +ellps=GRS80
  683687.87       6099299.66 0.00
  ```

- 新的命令行工具`cct`使用新的API，所以同样的转换可能结果不一样

  ```c
  Copy Highlighter-hljs$ echo 300000 6100000 0 0 | cct +proj=pipeline +step +inv +proj=utm +zone=33 +ellps=GRS80 +step +proj=utm +zone=32 +ellps=GRS80
  683687.8667   6099299.6624    0.0000    0.0000
  ```

#### 代码示例[#](https://www.cnblogs.com/oloroso/p/10955620.html#3624640990)

这里显示了旧API和新API之间的区别，并举了几个例子。 下面我们用两个不同的API实现相同的程序。 程序从命令行读取输入经度和纬度，并使用墨卡托投影将它们转换为投影坐标。

我们首先编写PROJ v.4的程序：

```c
Copy Highlighter-hljs#include <proj_api.h>

main(int argc, char **argv) {
    projPJ pj_merc, pj_longlat;
    double x, y;

    // 创建坐标参考系对象
    if (!(pj_longlat = pj_init_plus("+proj=longlat +ellps=clrk66")) )
        return 1;
    if (!(pj_merc = pj_init_plus("+proj=merc +ellps=clrk66 +lat_ts=33")) )
        return 1;

    // PROJ.4 API 默认的经纬度都是使用弧度值
    while (scanf("%lf %lf", &x, &y) == 2) {
        x *= DEG_TO_RAD; /* 经度 */
        y *= DEG_TO_RAD; /* 纬度 */
        // 进行坐标转换
        p = pj_transform(pj_longlat, pj_merc, 1, 1, &x, &y, NULL );
        printf("%.2f\t%.2f\n", x, y);
    }

    pj_free(pj_longlat);
    pj_free(pj_merc);

    return 0;
}
```

使用PROJ v.5实现的相同程序：

```c
Copy Highlighter-hljs// 使用新的头文件
#include <proj.h>

main(int argc, char **argv) {
    PJ *P;
    PJ_COORD c;

    // 创建墨卡托投影坐标系
    P = proj_create(PJ_DEFAULT_CTX, "+proj=merc +ellps=clrk66 +lat_ts=33");
    if (P==0)
        return 1;

    while (scanf("%lf %lf", &c.lp.lam, &c.lp.phi) == 2) {
        // 度转弧度
        c.lp.lam = proj_torad(c.lp.lam);
        c.lp.phi = proj_torad(c.lp.phi);
        // 进行坐标转换（正算）
        c = proj_trans(P, PJ_FWD, c);
        printf("%.2f\t%.2f\n", c.xy.x, c.xy.y);
    }

    proj_destroy(P);
}
```

#### 新旧API函数对照表[#](https://www.cnblogs.com/oloroso/p/10955620.html#3940516450)

| 旧版 API 函数        | 新版 API 函数                                                |
| -------------------- | ------------------------------------------------------------ |
| pj_fwd               | [`proj_trans()`](https://proj4.org/development/reference/functions.html#c.proj_trans) |
| pj_inv               | [`proj_trans()`](https://proj4.org/development/reference/functions.html#c.proj_trans) |
| pj_fwd3              | [`proj_trans()`](https://proj4.org/development/reference/functions.html#c.proj_trans) |
| pj_inv3              | [`proj_trans()`](https://proj4.org/development/reference/functions.html#c.proj_trans) |
| pj_transform         | proj_trans_array or proj_trans_generic                       |
| pj_init              | [`proj_create()`](https://proj4.org/development/reference/functions.html#c.proj_create) |
| pj_init_plus         | [`proj_create()`](https://proj4.org/development/reference/functions.html#c.proj_create) |
| pj_free              | [`proj_destroy()`](https://proj4.org/development/reference/functions.html#c.proj_destroy) |
| pj_is_latlong        | [`proj_angular_output()`](https://proj4.org/development/reference/functions.html#c.proj_angular_output) |
| pj_is_geocent        | [`proj_angular_output()`](https://proj4.org/development/reference/functions.html#c.proj_angular_output) |
| pj_get_def           | [`proj_pj_info()`](https://proj4.org/development/reference/functions.html#c.proj_pj_info) |
| pj_latlong_from_proj | *No equivalent*                                              |
| pj_set_finder        | *No equivalent*                                              |
| pj_set_searchpath    | *No equivalent*                                              |
| pj_deallocate_grids  | *No equivalent*                                              |
| pj_strerrno          | *No equivalent*                                              |
| pj_get_errno_ref     | [`proj_errno()`](https://proj4.org/development/reference/functions.html#c.proj_errno) |
| pj_get_release       | [`proj_info()`](https://proj4.org/development/reference/functions.html#c.proj_info) |

### 迁移到6.x版本[#](https://www.cnblogs.com/oloroso/p/10955620.html#2809926991)

这是希望迁移代码以使用PROJ 6的开发人员的过渡指南。

#### 代码示例[#](https://www.cnblogs.com/oloroso/p/10955620.html#600177244)

这里显示了旧API和新API之间的区别，并举了几个例子。 下面我们用两个不同的API实现相同的程序。 程序从命令行读取输入经度和纬度，并使用墨卡托投影将它们转换为投影坐标。

我们首先编写PROJ v.4的程序：

```c
Copy Highlighter-hljs#include <proj_api.h>

main(int argc, char **argv) {
    projPJ pj_merc, pj_longlat;
    double x, y;

    // 创建坐标参考系对象
    if (!(pj_longlat = pj_init_plus("+proj=longlat +ellps=clrk66")) )
        return 1;
    if (!(pj_merc = pj_init_plus("+proj=merc +ellps=clrk66 +lat_ts=33")) )
        return 1;

    // PROJ.4 API 默认的经纬度都是使用弧度值
    while (scanf("%lf %lf", &x, &y) == 2) {
        x *= DEG_TO_RAD; /* 经度 */
        y *= DEG_TO_RAD; /* 纬度 */
        // 进行坐标转换
        p = pj_transform(pj_longlat, pj_merc, 1, 1, &x, &y, NULL );
        printf("%.2f\t%.2f\n", x, y);
    }

    pj_free(pj_longlat);
    pj_free(pj_merc);

    return 0;
}
```

使用PROJ v.6实现的相同程序：

```c
Copy Highlighter-hljs#include <proj.h>

main(int argc, char **argv) {
    PJ *P;
    PJ_COORD c;

    /* 注意: 在PROJ 6中强烈建议不要使用 PROJ 格式字符串来定义 CRS ，因为 PROJ 格式字符串*/
    /* 不是描述 CRS 的一种好方式，准确说来是其对大地基准的描述不够详细。                 */
    /* 使用权威机构提供的坐标系代码(例如"EPSG:4326", etc...)或者WKT字符串来创建，将能够 */
    /* 充分利用PROJ的“transformation engine”来确定两个CRS直接的最佳转换方式          */
    P = proj_create_crs_to_crs(PJ_DEFAULT_CTX,
                               "+proj=longlat +ellps=clrs66",
                               "+proj=merc +ellps=clrk66 +lat_ts=33",
                               NULL);
    if (P==0)
        return 1;

    {
        /* 对于特定的使用情况下（转换前后坐标系已知），这是没有必要的。                */
        /* proj_normalize_for_visualization() 确保预期坐标顺序和由 proj_trans() */
        /* 返回的顺序是 大地坐标系下先经度后纬度，投影坐标系下先东向后北向             */
        /* 如果不是使用上面的PROJ字符串，而是使用 "EPSG:XXXX" 代码，这可能是必要的。  */
        PJ* P_for_GIS = proj_normalize_for_visualization(C, P);
        if( 0 == P_for_GIS )  {
            proj_destroy(P);
            return 1;
        }
        proj_destroy(P);
        P = P_for_GIS;
    }

    while (scanf("%lf %lf", &c.lp.lam, &c.lp.phi) == 2) {
        /* 不需要转换到弧度 */
        c = proj_trans(P, PJ_FWD, c);
        printf("%.2f\t%.2f\n", c.xy.x, c.xy.y);
    }

    proj_destroy(P);
}
```

#### 新旧API函数对照表[#](https://www.cnblogs.com/oloroso/p/10955620.html#2310158752)

| 旧版 API 函数        | 新版 API 函数                                                |
| -------------------- | ------------------------------------------------------------ |
| pj_fwd               | [`proj_trans()`](https://proj4.org/development/reference/functions.html#c.proj_trans) |
| pj_inv               | [`proj_trans()`](https://proj4.org/development/reference/functions.html#c.proj_trans) |
| pj_fwd3              | [`proj_trans()`](https://proj4.org/development/reference/functions.html#c.proj_trans) |
| pj_inv3              | [`proj_trans()`](https://proj4.org/development/reference/functions.html#c.proj_trans) |
| pj_transform         | [`proj_create_crs_to_crs()`](https://proj4.org/development/reference/functions.html#c.proj_create_crs_to_crs) + ([`proj_normalize_for_visualization()`](https://proj4.org/development/reference/functions.html#c.proj_normalize_for_visualization) +) [`proj_trans()`](https://proj4.org/development/reference/functions.html#c.proj_trans), [`proj_trans_array()`](https://proj4.org/development/reference/functions.html#c.proj_trans_array) or [`proj_trans_generic()`](https://proj4.org/development/reference/functions.html#c.proj_trans_generic) |
| pj_init              | [`proj_create()`](https://proj4.org/development/reference/functions.html#c.proj_create) / [`proj_create_crs_to_crs()`](https://proj4.org/development/reference/functions.html#c.proj_create_crs_to_crs) |
| pj_init              | [`proj_create()`](https://proj4.org/development/reference/functions.html#c.proj_create) / [`proj_create_crs_to_crs()`](https://proj4.org/development/reference/functions.html#c.proj_create_crs_to_crs) |
| pj_free              | [`proj_destroy()`](https://proj4.org/development/reference/functions.html#c.proj_destroy) |
| pj_is_latlong        | `proj_get_type()`                                            |
| pj_is_geocent        | `proj_get_type()`                                            |
| pj_get_def           | [`proj_pj_info()`](https://proj4.org/development/reference/functions.html#c.proj_pj_info) |
| pj_latlong_from_proj | *No direct equivalent*, but can be accomplished by chaining [`proj_create()`](https://proj4.org/development/reference/functions.html#c.proj_create), `proj_crs_get_horizontal_datum()` and `proj_create_geographic_crs_from_datum()` |
| pj_set_finder        | `proj_context_set_file_finder()`                             |
| pj_set_searchpath    | `proj_context_set_search_paths()`                            |
| pj_deallocate_grids  | *No equivalent*                                              |
| pj_strerrno          | *No equivalent*                                              |
| pj_get_errno_ref     | [`proj_errno()`](https://proj4.org/development/reference/functions.html#c.proj_errno) |
| pj_get_release       | [`proj_info()`](https://proj4.org/development/reference/functions.html#c.proj_info) |