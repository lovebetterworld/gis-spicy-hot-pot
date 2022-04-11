- [Lanelet2标注指南 - Yida (mchook.cn)](https://blog.mchook.cn/2020/08/12/Lanelet2标注指南/)

**自动驾驶里面，常见的地图格式有百度的Apollo OpenDrive，Autoware的VectorMap(已淘汰)，德国FZI研究中心开源的Lanelet2（也是autoware目前的方案）。**

至于NDS格式，奈何本人不是nds协会的会员，实在是拿不到资料，所以不在本文讨论范围内。本文将介绍如何从头开始绘制lanelet2地图，并用于实际车辆的导航。

## 地理坐标系

------

阅读本文，建议先阅读：

> [JokerJohn的博客](http://xchu.net/)
>
> [自动驾驶中你需要知道的地理坐标系知识](https://blog.mchook.cn/2020/06/23/自动驾驶中你需要知道的地理坐标系知识)

## Lanelet2介绍

------

[Lanelet2](https://github.com/fzi-forschungszentrum-informatik/Lanelet2)是德国FZI研究院开发的一个高精度地图格式/库。建议先阅读一遍他仓库里面的文档：[Lanelet2文档](https://github.com/fzi-forschungszentrum-informatik/Lanelet2/tree/master/lanelet2_core/doc)、[Lanelet2投影坐标系](https://github.com/fzi-forschungszentrum-informatik/Lanelet2/blob/master/lanelet2_projection/doc/Map_Projections_Coordinate_Systems.md)

Autoware中的Lanelet2有些许改动，见[autoware的lanelet2定义](https://github.com/tier4/AutowareArchitectureProposal.proj/blob/master/design/Map/SemanticMap/AutowareLanelet2Format.md)

## 在JOSM中标注

------

[Lanelet2标注说明](https://github.com/fzi-forschungszentrum-informatik/Lanelet2/tree/master/lanelet2_maps)



[![JOSM标注效果](https://img-1251825784.cos.ap-guangzhou.myqcloud.com/img/z3FqlUn4sNEQSiv.png)](https://img-1251825784.cos.ap-guangzhou.myqcloud.com/img/z3FqlUn4sNEQSiv.png)



[JOSM标注效果](https://img-1251825784.cos.ap-guangzhou.myqcloud.com/img/z3FqlUn4sNEQSiv.png)

## 在Maptoolbox中标注

------

[MapToolbox](https://github.com/autocore-ai/MapToolbox)

[![Maptoolbox标注效果](https://img-1251825784.cos.ap-guangzhou.myqcloud.com/img/zWKml4hpeYIrqQN.png)](https://img-1251825784.cos.ap-guangzhou.myqcloud.com/img/zWKml4hpeYIrqQN.png)



[Maptoolbox标注效果](https://img-1251825784.cos.ap-guangzhou.myqcloud.com/img/zWKml4hpeYIrqQN.png)



## 两者的转换

------

- Maptoolbox标注出来的只有当地坐标系，没有WGS84坐标
- Maptoolbox标注出来的点id为从0开始
- 不能打开空线条
- JOSM打开osm文件需要wgs84坐标
- JOSM打开osm文件中点的id需要小于0或大于0
- josm标注出来可能存在空的线条

根据以上可以自己写一个脚本转换，我稍微改了改Maptoolbox代码（[MapToolbox修改后](https://github.com/GDUT-IIDCC/MapToolbox)），修改如下：

- 现保存的ID大于0
- 要求pcd中坐标为正确的mgrs坐标
- 保存文件前需要MGRS code，以生成wgs84坐标
- 重新编译了GeographicWarpper.dll, 添加了UTMUPS_Reverse 和 MGRS_Reverse 函数.