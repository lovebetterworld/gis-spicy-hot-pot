- [Lanelet2地图框架代码解析 | 攻城狮の家 (xchu.net)](http://xchu.net/2020/02/25/42lanelet2-codeparsing/)

这段时间阅读了Lanelet2的源码文档，本章将结合代码和文档来阐述Lanelet2地图框架的具体使用方法，比较底层的源码部分由于篇幅限制暂未涉及。Lanelet2地图框架的基本概念和软件架构在上一篇博客中已经做了讲解。

![img](http://xchu.net/2020/02/25/42lanelet2-codeparsing/2.png)



## Lanelet2地图概述

我们先看一下地图数据文件，关于地图格式官方推荐的是OSM格式（XML），开源可编辑。当然也可以是二进制文件，加载速度快，缺点是不可直接编辑。下面的地图文件是按XML形式来存储的，结构十分明朗。关于OSM规范，可以参考其WIKI，`https://wiki.openstreetmap.org/wiki/Map_Features`。

![image-20200226160214918](http://xchu.net/2020/02/25/42lanelet2-codeparsing/image-20200226160214918.png)

结合上一篇我们可以简单地看到，地图里面的每一个3D点都会用一个node标签存储，包含其经纬度LaLon，id是其唯一标志。后续的way标签存储lineString形式的元素，通过id引用node节点存储的3D点。而和交规相关的relation标签则又引用这些way id。

![image-20200225173544237](http://xchu.net/2020/02/25/42lanelet2-codeparsing/image-20200225173544237.png)

![image-20200225173657652](http://xchu.net/2020/02/25/42lanelet2-codeparsing/image-20200225173657652.png)

![image-20200225173808448](http://xchu.net/2020/02/25/42lanelet2-codeparsing/image-20200225173808448.png)

我们在JOSM编辑器中打开可以看到地图的基本形状，此编辑器的使用方法可查看官网`https://learnosm.org/en/josm/correcting-imagery-offset/`。下图是一个复杂的十字路口，地图上所有的黄色小框框都是一个3D/2D坐标点。这里红色的线是地图里面的stop_line，在软件界面右侧可以看到其属性是`stop line`，并且有四个节点。地图上画出来了所有的车道线，路沿，人行横道，绿化带区域等，还有各个`road user`（比如行人，车辆等）需要遵守的交通规则，以及车辆在十字路口可能的换道路线（现实中是没有的，属性定义为virtual）。

![image-20200225174147551](http://xchu.net/2020/02/25/42lanelet2-codeparsing/image-20200225174147551.png)

![img](http://xchu.net/2020/02/25/42lanelet2-codeparsing/1-1583905067966.png)

Lanelet2代码的安装可以参考官方文档https://github.com/JokerJohn/Lanelet2，其层级结构如下

![image-20200225180448733](http://xchu.net/2020/02/25/42lanelet2-codeparsing/image-20200225180448733.png)

我们常用的代码在lanelet_core、lanelet_io、lanelet_projection、lanelet_routing和lanelet_traffic_rules这几个模块中。项目采用gtest框架来测试，阅读起来比较容易。

这里我们首先需要知道如何去使用，首先是图元的基本定义方法（增删改查），还有交通规则的定义方法及其与车道和`road user`的关联关系。之后是如何去构建、加载使用OSM地图，并且根据需求查询相关的车道等信息。最后是如何生成生成路由图，并利用路由图和实际需求进行合理的路径规划。

## 基本图元对象的使用

主要有Points、Area、Lanelet、LineString、Polygon，首先引入头文件，这些图元的基本处理方法都在lanelet_core模块中，下面将详细介绍其使定义和利用他们来进行几何运算。

```
copy#include <lanelet2_core/LaneletMap.h>
#include <lanelet2_core/geometry/Area.h>
#include <lanelet2_core/geometry/Lanelet.h>
#include <lanelet2_core/primitives/Area.h>
#include <lanelet2_core/primitives/Lanelet.h>
#include <lanelet2_core/primitives/LineString.h>
#include <lanelet2_core/primitives/Point.h>
#include <lanelet2_core/primitives/Polygon.h>
#include <lanelet2_core/utility/Units.h>

#include "../ExampleHelpers.h" //example工具类
```

lanelet_core模块中使用嵌套的namespace来组织相关的方法，这里我们先引入两个重要的命名空间，后续不一一说明。

```
copyusing namespace lanelet;
using namespace lanelet::units::literals;
```

比如这里看一下lanelet::units::literals里面定义了距离，速度、加速度、时间相关单位。![image-20200225213348459](http://xchu.net/2020/02/25/42lanelet2-codeparsing/image-20200225213348459.png)

### Points使用

这里我们开始定义一个Point，通常定义为Point3d，在我们不关注高度的时候可定义为Point2d，在Lanelet2里面是很少会进行变量拷贝的，一般都是指针引用，而地图数据在使用过程中一般不会发生改变，这里我们可以定义为ConstPoint3d等，在代码里面ConstPoint3d和Point3d使用方法完全相同，除了无法修改数据。

每个Point必须要有一个唯一的id，一般为正数，Lanelet2里面提供了相应的id生成器`utils::getId()`。这里pCopy完全等于p，当p的数据修改时，pCopy也会共享。

```
copyPoint3d p(utils::getId(), 0, 0, 0);//定义一个点(0,0,0)

Point3d pCopy = p;
assert(p == pCopy);

p.z() = 2;
p.setId(utils::getId());//再生成一个id

assert(p.id() == pCopy.id());
assert(p.z() == pCopy.z());
```

下面设定点p的一些属性

```
copyp.attributes()["type"] = "point";
p.attributes()["pi"] = 3.14;
p.attributes()["velocity"] = "5 kmh";

assert(p.attributes() == pCopy.attributes());
assert(p.attribute("type") == "point");
assert(!!p.attribute("pi").asDouble());  // returns an optional value that is only valid if conversion was sucessful
assert(p.attribute("velocity").asVelocity() == 5_kmh);

// 不确定属性是否存在可以使用 "attributeOr"
assert(p.attributeOr("nonexistent", -1) == -1);
assert(p.attributeOr("type", 0) == 0);  // "point" 不能转换成数字
assert(p.attributeOr("velocity", 0_kmh) == 5_kmh);
```

Point3d变量可以转化成ConstPoint3d，但反过来不行。

```
copyConstPoint3d pConst = p;
assert(pConst.z() == 2);
// pConst.z() = 3; // impossible

p.z() = 3;
assert(pConst.z() == 3);//p数据修改了，pconst也会跟着变

ConstPoint3d &pConstRef = p;//Point3d继承自ConstPoint3d
assert(pConstRef.z() == 3);

// Point3d pNonConst = pConst; // not possible
assert(p.constData() == pConst.constData());//constData是基础数据
```

Point3d与Point2d相互转换

```
copyPoint3d p3d(utils::getId(), 1, 2, 3);
BasicPoint3d &p3dBasic = p3d.basicPoint();

Point2d p2d = utils::to2D(p3d);
Point3d p3dNew = utils::to3D(p2d);
assert(p3dNew.constData() == p3d.constData());
```

### LineString使用

LineString至少要求有一个点，下述代码创建一条连接点（0，0，0）、（1，0，0）、（2，0，0）的LineString。

```
copyPoint3d p1{utils::getId(), 0, 0, 0}, p2{utils::getId(), 1, 0, 0}, p3{utils::getId(), 2, 0, 0};

LineString3d ls(utils::getId(), {p1, p2, p3});
```

LineString在使用上和vector类似，可以进行push和pop

```
copyassert(ls[1] == p2);
assert(ls.size() == 3);
for (Point3d &p : ls) {//遍历
    assert(p.y() == 0);
}
ls.push_back(Point3d(utils::getId(), 3, 0, 0));
assert(ls.size() == 4);
ls.pop_back();
assert(ls.size() == 3);
```

LineString也可以设置一些属性，比如细线，虚线等

```
copyls.attributes()[AttributeName::Type] = AttributeValueString::LineThin;
ls.attributes()[AttributeName::Subtype] = AttributeValueString::Dashed;
```

在LineString中，两个相邻点组成线段，除了遍历点，还可以遍历线段。

```
copyassert(ls.numSegments() >= 2);
Segment3d segment = ls.segment(1);
assert(segment.first == p2);
assert(segment.second == p3);
```

LineString也可以进行反转，反转两次后和原来的LineString一样。

```
copyLineString3d lsInv = ls.invert();
assert(lsInv.front() == p3);
assert(lsInv.inverted());  
assert(lsInv.constData() == ls.constData());  // still the same data

LineString3d lsInvInv = lsInv.invert();
assert(lsInvInv == ls);
assert(lsInvInv.front() == p1);
```

LineString也有const，2d版本。

```
copyConstLineString3d lsConst = ls;
// lsConst.pop_back() // not possible
ConstPoint3d p1Const = ls[0];  // const linestrings return const points
assert(lsConst.constData() == ls.constData());

LineString2d ls2d = utils::to2D(ls);
Point2d front2d = ls2d.front();//起点
assert(front2d == utils::to2D(p1));
```

LinString还有一个混合版本ConstHybridLineString3d，BasicLineString3d。 这有点特殊，因为它返回BasicPoints（也就是Eigen点），非常适合几何计算，特别是后面使用boost.geometry库时。

```
copyConstHybridLineString3d lsHybrid = utils::toHybrid(ls);
BasicPoint3d p1Basic = lsHybrid[0];
assert(p1Basic.x() == p1.x());

BasicLineString3d lsBasic = ls.basicLineString();
assert(lsBasic.front() == lsHybrid.front());
```

### Polygon的使用

和LineString使用方法类似，重要的区别就是首末点是连接成线段的，是闭合的，而且Polygon是无法反转的，默认方向是顺时针。Polygon的类型和LineString一致，const, 2d, 3d, hybrid。

```
copyPoint3d p1{utils::getId(), 0, 0, 0}, p2{utils::getId(), 1, 0, 0}, p3{utils::getId(), 2, -1, 0};
Polygon3d poly(utils::getId(), {p1, p2, p3});

assert(poly.size() == 3);
assert(poly.numSegments() == 3);  // not 2, see?

Segment3d lastSegment = poly.segment(2);//最后一条线段是p3->p1
assert(lastSegment.first == p3);
assert(lastSegment.second == p1);

// poly.invert(); // no.
ConstPolygon3d polyConst = poly;
ConstHybridPolygon3d polyHybrid = utils::toHybrid(poly);
ConstPolygon2d poly2dConst = utils::to2D(polyConst);
assert(polyHybrid.constData() == poly2dConst.constData());
```

### Lanelet使用

Lanelet有左右两条边界，也就是两条LineString

```
copyLineString3d left = examples::getLineStringAtY(1);//(1,0)(1,1)(1,2)
LineString3d right = examples::getLineStringAtY(0);//(0,0)(1,0)(2,0)
Lanelet lanelet(utils::getId(), left, right);//创建Lanelet
lanelet.setLeftBound(left); 

assert(lanelet.leftBound() == left);
assert(lanelet.rightBound() == right);
```

这里`getLineStringAtY`就是生成两条示例线段

![image-20200225225959447](http://xchu.net/2020/02/25/42lanelet2-codeparsing/image-20200225225959447.png)

Lanelet还有centerLine的概念，但是自动计算的，且不可修改。并且中心线在自动计算之后会被缓存起来，当Lanelet的左右边界发生变化时，这个缓存会被清空。但是左右边界修改时，系统不会自动提醒，需要reset缓存。

```
copyConstLineString3d centerline = lanelet.centerline();
ConstLineString3d centerline2 = lanelet.centerline();  
assert(centerline2 == centerline);

lanelet.setLeftBound(examples::getLineStringAtY(2));//左边界更改

ConstLineString3d centerline3 = lanelet.centerline();
assert(centerline3 != centerline); 

right.push_back(Point3d(utils::getId(), 4, 0, 0));//右边界新增一个点
assert(centerline3 == lanelet.centerline());  // centerline未变化
lanelet.resetCache(); //reset
assert(centerline3 != lanelet.centerline());  // 计算新的centerline

right.pop_back();
lanelet.resetCache();
```

Lanelet还可以进行反转，实际上就是左右边界分别反转，现实中就是表示双向车道。

```
copyLanelet laneletInv = lanelet.invert();
assert(laneletInv.leftBound().front() == lanelet.rightBound().back());
assert(laneletInv.constData() == lanelet.constData());
```

进行几何计算的时候会经常用到Lanelet的轮廓，这里我们用CompoundPolygon类型来表示，看起来像之前提到的Polygon类型，实际上是由多个线串一起按顺时针方向组合形成的。Lanelet由const版本，但是没有3d或者2d版本

```
copyCompoundPolygon3d polygon = lanelet.polygon3d();
assert(polygon.size() == 6);              // both boundaries have 3 points
assert(polygon[0] == lanelet.leftBound().front()); //第一个点是左边界起点     
assert(polygon.back() == lanelet.rightBound().front());  // 尾点是右边界起点

ConstLanelet laneletConst = lanelet;
assert(laneletConst.constData() == lanelet.constData());
ConstLineString3d leftConst = lanelet.leftBound();  //此边界时const
// laneletConst.setLeftBound(left); // no
```

Lanelet有相关联的regElem的，后续再讲解。

```
copyassert(lanelet.regulatoryElements().empty());
```

### Area的使用

Area的使用和Lanelet差不多，区别就是Area没有左右边界的概念，而是由LineString组成的集合，按顺时针方向连接在一起形成外围边界。Area可以用来描述坑这种有内外框的情况，内框是逆时针方向。他们都有const版本和相关联的regElem。

```
copyLineString3d top = examples::getLineStringAtY(2);
LineString3d right = examples::getLineStringAtX(2).invert();
LineString3d bottom = examples::getLineStringAtY(0).invert();
LineString3d left = examples::getLineStringAtY(0);
Area area(utils::getId(), {top, right, bottom, left});

LineStrings3d outer = area.outerBound();//get
area.setOuterBound(outer);//set

CompoundPolygon3d outerPolygon = area.outerBoundPolygon();//get a polygon

assert(area.innerBounds().empty());

ConstArea areaConst = area;// areas can be const
ConstLineStrings3d outerConst = areaConst.outerBound();  // the outer bound linestrings are also const

assert(area.regulatoryElements().empty());
```

### 几何计算

这里我们运用定义好的基本类型进行几何计算，比如计算距离等。这里我们定义一个Point(1，4，0)，一条LineString(从（0，2，0）到（2，2，0）)，一个Polygon，一个Lanelet(x:0->3，y:2->0)，一个Area。

```
copyPoint3d point(utils::getId(), 1, 4, 1);
LineString3d ls = examples::getLineStringAtY(2);
Polygon3d poly = examples::getAPolygon(); // (0,0,0), (2,0,0), (2, -2, 0)
Lanelet lanelet = examples::getALanelet();
Area area = examples::getAnArea(); // 对角点 (0,0,0) and (2,2,0)

// 注意：linestrings、polygons比hybrid类型计算量小
ConstHybridLineString3d lsHybrid = utils::toHybrid(ls);
ConstHybridPolygon3d polyHybrid = utils::toHybrid(poly);

// 点到直线的距离 3d
auto dP2Line3d = geometry::distance(point, lsHybrid);
assert(dP2Line3d > 2);
// 点到直线的距离 2d
auto dP2Line2d = geometry::distance(utils::to2D(point), utils::to2D(lsHybrid));
assert(dP2Line2d == 2);

// LineString、Polygon 总长度
auto l3d = geometry::length(lsHybrid);
assert(l3d == 2);
auto ar = geometry::area(utils::to2D(polyHybrid));  // not defined in 3d
assert(ar == 2);

// 不使用混合类型计算点在直线上的投影
BasicPoint3d pProj = geometry::project(ls, point); 
assert(pProj.y() == 2);

//转换成弧坐标计算
ArcCoordinates arcCoordinates = geometry::toArcCoordinates(utils::to2D(ls),utils::to2D(point)); 
assert(arcCoordinates.distance == 2);  // signed distance to linestring
assert(arcCoordinates.length == 1); // length along linestring
```

我们现在可以使用bounding boxes进行有效的交点估计。 如果两个框仅接触但共享区域仍为0，则相交也返回true。如果想求的不仅仅是估计，则可以直接使用基本图元。 仅当两个图元的共享区域大于0时，Overlaps才返回true。 在3d中，z中的距离也必须小于边距。

```
copy//所有类型均可计算其bounding boxes
BoundingBox3d pointBox = geometry::boundingBox3d(point);  //离散的点框
BoundingBox3d lsBox = geometry::boundingBox3d(ls);
BoundingBox2d laneletBox = geometry::boundingBox2d(lanelet);
BoundingBox2d areaBox = geometry::boundingBox2d(area);

assert(geometry::intersects(laneletBox, areaBox));//lanelet与area是否相交
assert(!geometry::intersects(pointBox, lsBox));//points是否在ls线段上
assert(geometry::overlaps3d(area, lanelet, 3));//area和lanelet是否有重叠区域
```

### RegElem的使用

Lanelet2定义了很多基本的RegElem，例如traffic light 和speed limit，以下主要讲解这些RegElem是如何和lanelet进行关联的，后面的Area，Polygon等关联方法也是一致的。

traffic lights使用LineString来表示的，与其相关联的还有stop line。

```
copy// 创建trafficLight，设置type
LineString3d trafficLight = examples::getLineStringAtY(1);//3个点
trafficLight.attributes()[AttributeName::Type] = AttributeValueString::TrafficLight;

// Regelems作为共享指针传递，父对象类型RegulatoryElement，具体的对象类型是 TrafficLight
RegulatoryElementPtr trafficLightRegelem = lanelet::TrafficLight::make(utils::getId(), {}, {trafficLight});
```

创建好了相应的RegElem需要与相应的lanelet关联起来。

```
copy// 创建lanelet,并设定相关联的regElem
Lanelet lanelet = examples::getALanelet();
lanelet.addRegulatoryElement(trafficLightRegelem); 

// 查询lnelet相关的reglem
assert(lanelet.regulatoryElements().size() == 1);
RegulatoryElementPtr regelem = lanelet.regulatoryElements()[0];

// 也可以直接使用子类型TrafficLight、SpeedLimit
assert(lanelet.regulatoryElementsAs<SpeedLimit>().empty());  // no speed limits
std::vector <TrafficLight::Ptr> trafficLightRegelems = lanelet.regulatoryElementsAs<TrafficLight>();
assert(trafficLightRegelems.size() == 1);

TrafficLight::Ptr tlRegelem = trafficLightRegelems.front(); // 起点
assert(tlRegelem->constData() == trafficLightRegelem->constData());
```

traffic lights也可以用Polygon来描述，这里可以有一种兼容写法。需要注意的是，我们可以修改RegElem，但一个RegElem可能与多个lanelet关联起来了，是共享数据，如果修改的话会影响其他的lanelets。

```
copyLineStringOrPolygon3d theLight = tlRegelem->trafficLights().front();
assert(theLight == trafficLight);

tlRegelem->setStopLine(examples::getLineStringAtY(2));//设定相关联的stop line
assert(!!tlRegelem->stopLine());
```

为了编码方便，我们可以采用GenericRegulatoryElement对任何交通规则进行建模。但是，实际工程中一般不使用，因为它的通用结构很难理解。以下代码，我们给某一个road user增加其相关联的图元。

```
copyGenericRegulatoryElement regelem(utils::getId());

Lanelet lanelet = examples::getALanelet();
regelem.addParameter(RoleName::Refers, lanelet);//road user关联lanelet

Point3d point(utils::getId(), 0, 0, 0);
regelem.addParameter(RoleName::Refers, point);// road user关联point

Points3d pts = regelem.getParameters<Point3d>(RoleName::Refers);
assert(!pts.empty() && pts.front() == point);
```

现在我们来注册一个新的RegElem元素到Lanelet2中，叫做LightsOn，它代表车辆能够在经过特定的line的时候打开车灯。首先LightsOn类应该继承自RegulatoryElement类。

```
copynamespace example {
    class LightsOn : public lanelet::RegulatoryElement { 
        public:
        static constexpr char RuleName[] = "lights_on";

        // 返回准备stop的时候的关联line
        lanelet::ConstLineString3d fromWhere() const {
            return getParameters<lanelet::ConstLineString3d>(lanelet::RoleName::RefLine).front();
        }

        private:
        LightsOn(lanelet::Id id, lanelet::LineString3d fromWhere) : RegulatoryElement{std::make_shared<lanelet::RegulatoryElementData>(id)} {
                parameters().insert({lanelet::RoleNameString::RefLine, {fromWhere}});
            }

        // 加载osm地图文件时创建此RegElem
        friend class lanelet::RegisterRegulatoryElement<LightsOn>;

        explicit LightsOn(const lanelet::RegulatoryElementDataPtr &data) : RegulatoryElement(data) {}
    };

    #if __cplusplus < 201703L //判断编译器版本
    constexpr char LightsOn::RuleName[];  // 实例化
    #endif
}

// RegisterRegulatoryElement是实际上的注册对象
namespace {
    lanelet::RegisterRegulatoryElement<example::LightsOn> reg;
}
```

注册好了rule类型之后，下面是具体的关联方法。RegulatoryElementFactory工厂类是在lanelet_io中定义，在加载地图的时候自动创建，去注册相关的RegElem和相应的rule，最后与特定的lanelet关联起来。

```
copyLineString3d fromWhere = examples::getLineStringAtX(1);//创建一条关联line
RuleParameterMap rules{{RoleNameString::RefLine, {fromWhere}}};//定义rule

RegulatoryElementPtr regelem = RegulatoryElementFactory::create("lights_on", utils::getId(), rules);//定义RegElem

Lanelet lanelet = examples::getALanelet();
lanelet.addRegulatoryElement(regelem);//关联lanelet
assert(!lanelet.regulatoryElementsAs<example::LightsOn>().empty());
```

## LaneletMap及IO

#### LaneletMap使用

LaneletMap类可以理解为管理所有创建好的图元数据的容器，它提供了查询各种地图数据的基本方法。按之前的分层，LaneletMap也分为pointLayer和lineStringLayer两层，其他图元都可以用此两层的通用方法来处理。每一层都类似于无序地图，需要经过遍历或者通过id查询。注意下面的map是无法被拷贝的，而是通过std::move将左值引用转换为右值引用，进行变量的“转移”，这也符合我们之前分析的，尽量避免数据的拷贝操作。在进行move之后，原来的map变量是清空的。最后一点是和先前一样，LaneletMap也有const版本。

```
copyLaneletMap map = examples::getALaneletMap(); 
PointLayer &points = map.pointLayer;
LineStringLayer &linestrings = map.lineStringLayer;

Point3d aPoint = *points.begin();//起始点
Point3d samePoint = *points.find(aPoint.id());
assert(samePoint == aPoint);
assert(points.exists(aPoint.id()));

assert(!linestrings.empty());

LaneletMap newMap = std::move(map);
// map.exists(aPoint.id()); // map is no longer valid after move!
assert(newMap.pointLayer.exists(aPoint.id()));

// or be passed around as a pointer:
LaneletMapUPtr mapPtr = std::make_unique<LaneletMap>(std::move(newMap));

// const
const LaneletMap &constMap = *mapPtr;
ConstPoint3d aConstPoint = *constMap.pointLayer.begin();
assert(aConstPoint == aPoint);
```

##### LaneletMap生成

下面演示map的创建方法，无非定义对象，给实例填充数据。一般有两种方法，一是少量数据一个个的填充，二是直接从多个对象中创建。在添加对象的时候，会自动加入其相关属性，(points, linestrings, regulatory elements)。

```
copyLaneletMap laneletMap;

Lanelet lanelet = examples::getALanelet();
laneletMap.add(lanelet);// 添加lanelet
assert(laneletMap.laneletLayer.size() == 1);
assert(!laneletMap.pointLayer.empty());
assert(laneletMap.pointLayer.exists(lanelet.leftBound().front().id()));

// 构造多条lanelet
Lanelets lanelets{examples::getALanelet(), examples::getALanelet(), examples::getALanelet()};
LaneletMapUPtr laneletsMap = utils::createMap(lanelets);
assert(laneletsMap->laneletLayer.exists(lanelets.front().id()));
```

之前我们定义的所有id均为正整数，那么也就可以用id=0来标识不属于此地图中的数据。在添加无效id的图元数据时，Lanlet2会自动重新给它生成有效id。

```
copyPoint3d invalPoint1(InvalId, 0, 0, 0);// InvalId = 0
Point3d invalPoint2(InvalId, 1, 0, 0);
LineString3d invalLs(InvalId, {invalPoint1, invalPoint2});
laneletMap.add(invalLs); // 自动生成新id
assert(invalPoint1.id() != InvalId);
```

##### 地图数据查询

LaneletMap提供两种数据查询方法，一是根据其关联关系，比如可根据当前lanelet查询其关联的traffic light(regelems)和stop line（linestring），根据Points查询Linestring，二是根据位置，比如查询当前lanelet 50米范围内所有的lanelet，RegElem等。

```
copyLaneletMap laneletMap = examples::getALaneletMap();
Lanelet mapLanelet = *laneletMap.laneletLayer.begin();
TrafficLight::Ptr trafficLight = mapLanelet.regulatoryElementsAs<TrafficLight>().front();//查地图上的traffic light

// 根据lanlet左边界(linestring)查询其特定类型
auto laneletsOwningLinestring = laneletMap.laneletLayer.findUsages(mapLanelet.leftBound());
assert(laneletsOwningLinestring.size() == 1 && laneletsOwningLinestring.front() == mapLanelet);

// find regelems with linestrings
auto regelemsOwningLs = laneletMap.regulatoryElementLayer.findUsages(*trafficLight->trafficLights().front().lineString());
assert(regelemsOwningLs.size() == 1 && regelemsOwningLs.front() == trafficLight);

// find lanelets with regelems
auto laneletsOwningRegelems = laneletMap.laneletLayer.findUsages(trafficLight);
assert(!laneletsOwningRegelems.empty());
```

下面是根据位置查询，从空间上意味着我们可以使用几何查询找到图元。 由于内部所有的图元都存储为边界框，因此这些查询仅返回关于它们的“边界框”的图元。对于高级用法，有searchUntil和nearestUntil函数。 向它传递一个函数，该函数将使用具有增加的边界框距离的图元函数调用，直到该函数返回true。

```
copy// 1 means the nearest "1" lanelets
// 查询距离(0,0)最近的lanelet，其实是查到的是lanelet边框
Lanelets lanelets = laneletMap.laneletLayer.nearest(BasicPoint2d(0, 0), 1);  
assert(!lanelets.empty()); 

// 找到事实上最近的，一般用下面这个方法
std::vector <std::pair<double, Lanelet>> actuallyNearestLanelets =
    geometry::findNearest(laneletMap.laneletLayer, BasicPoint2d(0, 0), 1);
assert(!actuallyNearestLanelets.empty());

// search region (this also runs on the bounding boxes):
Lanelets inRegion = laneletMap.laneletLayer.search(BoundingBox2d(BasicPoint2d(0, 0), BasicPoint2d(10, 10)));
assert(!inRegion.empty());  // inRegion包含其边界框与查询相交的所有lanelet


// 查询距离点(10,10)大于3米的最近lanelet边框
BasicPoint2d searchPoint = BasicPoint2d(10, 10);
auto searchFunc = [&searchPoint](const BoundingBox2d &lltBox, const Lanelet & /*llt*/) {
    return geometry::distance(searchPoint, lltBox) > 3;
};

Optional <Lanelet> lanelet = laneletMap.laneletLayer.nearestUntil(searchPoint, searchFunc);
assert(!!lanelet && geometry::distance(geometry::boundingBox2d(*lanelet), searchPoint) > 3);
```

上面的`getALaneletMap`表示生成示例地图，一个Area，一条Lanelet和一个相关联的RegElem。

![image-20200226130329868](http://xchu.net/2020/02/25/42lanelet2-codeparsing/image-20200226130329868.png)

##### LaneletSubmap子图

LaneletMap类包含了所有处理地图数据的方法，此外还有LaneletSubmap不包含RegElem，除非在创建LaneletSubmap时明确加入的关联。

```
copyLaneletSubmap submap{examples::getALaneletMap()};  

//search its layers
Lanelets inRegion = submap.laneletLayer.search(BoundingBox2d(BasicPoint2d(0, 0), BasicPoint2d(10, 10)));

// create new submaps from some elements
LaneletSubmapUPtr newSubmap = utils::createSubmap(inRegion);
assert(newSubmap->pointLayer.empty());
assert(newSubmap->size() == inRegion.size());

// 转换成laneletMap后，会包含所有的图元数据
LaneletMapUPtr newMap = newSubmap->laneletMap();
assert(!newMap->pointLayer.empty());
```

#### 现实OSM地图的加载与生成

继续文章开头内容，我们来读取示例的OSM地图数据。

```
copy#include <lanelet2_core/primitives/Lanelet.h>
#include <lanelet2_io/Io.h>
#include <lanelet2_io/io_handlers/Factory.h>
#include <lanelet2_io/io_handlers/Writer.h>
#include <lanelet2_projection/UTM.h>
#include <cstdio>

namespace {
    std::string exampleMapPath = std::string(PKG_DIR) + "/../lanelet2_maps/res/mapping_example.osm";

    // 简单处理一下路径问题
    std::string tempfile(const std::string &name) {
        char tmpDir[] = "/tmp/lanelet2_example_XXXXXX";
        auto file = mkdtemp(tmpDir);
        if (file == nullptr) {
            throw lanelet::IOError("Failed to open a temporary file for writing");
        }
        return std::string(file) + '/' + name;
    }
}
```

注意，加载真实地图的时候需要考虑坐标系转换，一般是地理系与平面系的转换，Lanelet中推荐转换的地理系是UTM系。考虑地理系，就必须知道地图起点的经纬LaLon坐标，在Lanelet2中定义了projector来专门处理lat/lon->x/y。

```
copyprojection::UtmProjector projector(Origin({49, 8.4}));  //地图原点latlon
LaneletMapPtr map = load(exampleMapPath, projector); //加载地图

// 转化成bin数据，读取二进制地图数据会比.osm快很多 
write(tempfile("map.bin"), *map);

// 加载出错时会抛出error
ErrorMessages errors;
map = load(exampleMapPath, projector, &errors);
assert(errors.empty());
```

Lanelet2中也提供了经纬转UTM坐标的处理方法。

```
copy// lat/lon->x/y conversion.  
projection::UtmProjector projector(Origin({49, 8.4}));
BasicPoint3d projection = projector.forward(GPSPoint{49, 8.4, 0});
assert(std::abs(projection.x()) < 1e-6);

// 如果从osm加载地图而没有提供合适的投影仪或原点，则会抛出异常。
// LaneletMapPtr map = load(exampleMapPath); // throws: loading from osm without projector
```

此外，不只是OSM格式，我们也可以自定义解析器来解析符合Lanet2要求的其他格式地图数据。

```
copynamespace example {
    class FakeWriter : public lanelet::io_handlers::Writer {
        public:
        using Writer::Writer;

        void write(const std::string & /*filename*/, const lanelet::LaneletMap & /*laneletMap*/,lanelet::ErrorMessages & /*errors*/) const override {
            // this writer does just nothing
        }

        static constexpr const char *extension() {
            return ".fake";  // this is the extension that we support
        }

        static constexpr const char *name() {
            return "fake_writer";  // this is the name of the writer. Users can also pick the writer by its name.
        }
    };
}

namespace {
    // this registers our new class for lanelet2_io
    lanelet::io_handlers::RegisterWriter <example::FakeWriter> reg;
}
```

以上我们注册了解析.fake格式数据的解析器，使用起来就很方便。

```
copyLaneletMap map;
write("anypath.fake", map);
```

## 使用交规对象解释地图数据

本节主要讲解如何使用Traffic rules来解释地图数据。这里的解释主要是将我们已经建模好的关联关系，让汽车或者其他road user容易理解。这里我们构建三条横向连续的lanelet，分别为left、middle、right，其边界分别为left/middleLs、middleLs/rightLs、nextLeftLs/nextRightLs。

```
copy#include <lanelet2_core/utility/Units.h>
#include <lanelet2_traffic_rules/TrafficRules.h>
#include <lanelet2_traffic_rules/TrafficRulesFactory.h>

using namespace lanelet::units::literals;

// 构建三条横向相邻的lanelet，六条边
LineString3d leftLs{examples::getLineStringAtY(3)}, middleLs{examples::getLineStringAtY(2)},
rightLs{examples::getLineStringAtY(0)};
LineString3d nextLeftLs{utils::getId(), {middleLs.back(), Point3d(utils::getId(), middleLs.back().x() + 1., middleLs.back().y())}};
LineString3d nextRightLs{utils::getId(),{rightLs.back(), Point3d(utils::getId(), rightLs.back().x() + 1, rightLs.back().y())}};

Lanelet left{utils::getId(), leftLs, middleLs};
Lanelet right{utils::getId(), middleLs, rightLs};
Lanelet next{utils::getId(), nextLeftLs, nextRightLs};
```

为了知道当前位置，哪些地方是可以通行的，我们需要知道相关联的具体的交规。我们使用TrafficRulesFactory来获取当前lanelet相关联的所有road user的所有rule。之后我们就能确定此处车辆和行人是否可通行，当前车辆能否变道。默认的lanelet只有一个方向，如何当前行人和车辆均不可通行，那么反转之后的lanelet也不可通行。我们也能查询当前的限速信息。

```
copy// 示例的交规在德国
traffic_rules::TrafficRulesPtr trafficRules =
    traffic_rules::TrafficRulesFactory::create(Locations::Germany, Participants::Vehicle);
// 行人交规
traffic_rules::TrafficRulesPtr pedestrianRules =
    traffic_rules::TrafficRulesFactory::create(Locations::Germany, Participants::Pedestrian);

assert(trafficRules->canPass(right));      // 右边车道不可通行
assert(!pedestrianRules->canPass(right));  // 行人也不可通行
assert(!trafficRules->canPass(right.invert())); //反转
assert(!trafficRules->canPass(right, left));//不可变道

// speed limit.
traffic_rules::SpeedLimitInformation limit = trafficRules->speedLimit(right);
assert(limit.speedLimit == 50_kmh);
assert(limit.isMandatory);  // 强制限宿

// 设置当前车道的一些具体属性
middleLs.attributes()[AttributeName::Type] = AttributeValueString::LineThin;
middleLs.attributes()[AttributeName::Subtype] = AttributeValueString::Dashed;
right.attributes()[AttributeName::Type] = AttributeValueString::Lanelet;
right.attributes()[AttributeName::Subtype] = AttributeValueString::Road;
right.attributes()[AttributeName::Location] = AttributeValueString::Nonurban;
left.attributes() = right.attributes();
next.attributes() = right.attributes();
left.attributes()[AttributeName::OneWay] = false;

// 这样就可以变道了
assert(trafficRules->canChangeLane(right, left));
assert(trafficRules->canChangeLane(left, right));

// 左车道不能逆行
assert(trafficRules->canPass(left.invert()));
// 右车道不能逆行，无法变道
assert(!trafficRules->canChangeLane(left, right.invert()));
assert(!trafficRules->canChangeLane(left.invert(), right.invert()));

// 获取右车道限速信息
limit = trafficRules->speedLimit(right);
assert(limit.speedLimit == 100_kmh);  // on german nonurban roads

// 修改限速
LineString3d sign = examples::getLineStringAtX(3);
SpeedLimit::Ptr speedLimit =
    SpeedLimit::make(utils::getId(), {}, {{sign}, "de274-60"});  // 限速60kM/h
right.addRegulatoryElement(speedLimit);
assert(trafficRules->speedLimit(right).speedLimit == 60_kmh);

// 把lanelet改成人行横道，那么汽车不可通行，行人可通行
right.attributes()[AttributeName::Subtype] = AttributeValueString::Crosswalk;
assert(!trafficRules->canPass(right));
assert(pedestrianRules->canPass(right));
```

## 路由图的生成及使用

本节主要讲解如何根据加载的地图，创建和使用路由图。从map，交规，routing cost中可以得到路由图。路由代价主要是根据距离和时间（限速信息）综合计算，路由图可用于查询三种不同的信息：

- 特定Lanelet/Area的相邻关系
- 来自Lanelet/Area的可能通行的路线
- 两个Lanelet之间的最短路线。

### 绘制路由图

road user的选择会影响从哪个角度生成路由图，下面我们将为车辆绘制路线图。我们还可以搜索冲突的Lanelet/Area，但这只会返回与相同road user的其他Lanelet的冲突。 例如。 此图用于车辆时，这将永远不会返回人行横道。我们还可以从当前出发找出可能的路径。 我们选择的路由代价的id为0，这将为我们提供至少100m长的路由。

```
copy// 加载地图 获取交规
LaneletMapPtr map = load(exampleMapPath, projection::UtmProjector(Origin({49, 8.4})));
traffic_rules::TrafficRulesPtr trafficRules = traffic_rules::TrafficRulesFactory::create(Locations::Germany, Participants::Vehicle);
routing::RoutingGraphUPtr routingGraph = routing::RoutingGraph::build(*map, *trafficRules);//创建路由图

// 示例：搜索id为4984315的lanelet,在路由图中一般使用const版本
ConstLanelet lanelet = map->laneletLayer.get(4984315);
// 查询当前车道的一些相邻车道
assert(!routingGraph->adjacentLeft(lanelet));
assert(!routingGraph->adjacentRight(lanelet));  // 无法通过换道到达
assert(!!routingGraph->right(lanelet));         // 右侧车道可换道
// besides将当前lanelet所在的road按顺序进行切割
assert(routingGraph->besides(lanelet).size() == 3);  
assert(routingGraph->following(lanelet).size() == 1);
assert(routingGraph->conflicting(lanelet).empty());  //无冲突区域

// 搜索代价为x，并且距离当前位置100米的路线，false表示不包括变道
routing::LaneletPaths paths = routingGraph->possiblePaths(lanelet, 100, 0, false);
assert(paths.size() == 1);  // 不包括变道，只有一条路线
paths = routingGraph->possiblePaths(lanelet, 100, 0, true);
assert(paths.size() == 4);  //包括变道右4条路线

// 您也可以获取所有的可达路线集合，该集与可能路径集合基本相同，但是lanlet未排序，不包含重复项。 //同样，可能集合会丢弃低于成本阈值的路径，而可达集合会保留所有路径。
ConstLanelets reachableSet = routingGraph->reachableSet(lanelet, 100, 0);
assert(reachableSet.size() > 10);
```

最后是路由内容。 在这里，我们仅关注最短路径。最短路径可以包含（突然的）变道。 对于车辆，应该建议优先选择哪个车道（局部）而不是整条路线（全局）。 可以在路径中查询可以遵循的车道顺序，直到必须换道为止。路由图还具有一种自检机制，该机制可验证图的所有部分是否处于健全状态。

```
copyConstLanelet toLanelet = map->laneletLayer.get(2925017);
Optional <routing::LaneletPath> shortestPath = routingGraph->shortestPath(lanelet, toLanelet, 1);
assert(!!shortestPath);

// 最短路径的lanlet序列
LaneletSequence lane = shortestPath->getRemainingLane(shortestPath->begin());
assert(!lane.empty());//变道

routingGraph->checkValidity();//自检
```

### 使用路由图

Route对象建立在起点和终点之间的最短路径上。 但是，它不仅包含沿最短路径的lanelets，还包含可用于目的地而无需离开所选道路的所有lanelets。 当需要知道到达目的地的所有选项（包括变道）时，这就是我们要追求的目标。

```
copyLaneletMapPtr map = load(exampleMapPath, projection::UtmProjector(Origin({49, 8.4})));
traffic_rules::TrafficRulesPtr trafficRules =
    traffic_rules::TrafficRulesFactory::create(Locations::Germany, Participants::Vehicle);
routing::RoutingGraphUPtr routingGraph = routing::RoutingGraph::build(*map, *trafficRules);
ConstLanelet lanelet = map->laneletLayer.get(4984315);//当前位置
ConstLanelet toLanelet = map->laneletLayer.get(2925017);//目的地

// 获取route
Optional <routing::Route> route = routingGraph->getRoute(lanelet, toLanelet, 0);
assert(!!route);

// 获取实际最基本的路线
routing::LaneletPath shortestPath = route->shortestPath();
assert(!shortestPath.empty());

//现在，我们可以从路线中获取各个车道。他们能提供在到达目的地或我们必须进行换道之前的最长路线：
LaneletSequence fullLane = route->fullLane(lanelet);
assert(!fullLane.empty());

//但我们也需要检查路线变更的早期可能性或查询其他关系，类似于路线图。
auto right = route->rightRelation(lanelet);
assert(!!right);

// 最后，我们还可以从仅包含所选路线的相关图元中创建子图：
LaneletSubmapConstPtr routeMap = route->laneletSubmap();
assert(!routeMap->laneletLayer.empty());
```

由于路由图仅包含可用于一个特定参与者的原语，因此我们不能使用它们来查询不同`road user`之间的可能冲突。 `RoutingGraphContainer`可解决此问题：它通过比较不同的拓扑图来查找各个`road user`之间的冲突。

```
copyLaneletMapPtr map = load(exampleMapPath, projection::UtmProjector(Origin({49, 8.4})));
traffic_rules::TrafficRulesPtr trafficRules =
    traffic_rules::TrafficRulesFactory::create(Locations::Germany, Participants::Vehicle);
traffic_rules::TrafficRulesPtr pedestrianRules =
    traffic_rules::TrafficRulesFactory::create(Locations::Germany, Participants::Pedestrian);//行人交规

routing::RoutingGraphConstPtr vehicleGraph = routing::RoutingGraph::build(*map, *trafficRules);
routing::RoutingGraphConstPtr pedestrGraph = routing::RoutingGraph::build(*map, *pedestrianRules);//行人路由图

//用路由图容器统一管理
routing::RoutingGraphContainer graphs({vehicleGraph, pedestrGraph});
ConstLanelet lanelet = map->laneletLayer.get(4984315);
ConstLanelet intersectLanelet = map->laneletLayer.get(185265);

assert(graphs.conflictingInGraph(lanelet, 1).empty());
assert(graphs.conflictingInGraph(intersectLanelet, 1).size() == 1);
```