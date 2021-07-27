地图是将地球上的自然现象和社会现象通过概括和符号缩绘在平面上的图形，这些信息便成为 GIS  数据分析的重要来源。由于地图是平面的，将把地球球面上的信息描绘到平面上时，平面与球面的矛盾就产生了。例如大范围的地区，强行将球面数据变成平面，会产生断裂或重迭的情形，如此就不能获得完整与连续的地表数据。为了解决这个问题，于是科学家透过不同的地图投影来解决这个问题。

所谓投影（Projection）就是透过一些数学法则，将地球球面的位置转成平面位置，并建立起相对应的经纬栅格。在转成平面的过程中，会有部分地区发生变形的情形，需视情况选择变形最小的投影方法。

## 按变形特性划分

**正形投影（conformal projection）**

保持原来地物的角度不变，目的确保形状不受扭曲变形，缺点是面积在投影过程中，会造成扭曲。如兰柏特（Lambert）圆锥投影及麦卡托（Mercator）圆柱投影。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image30.jpg)

图：兰柏特圆锥投影图

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image31.jpg)

图：麦卡托圆柱投影图

**等积投影（equivalent projection）**

确保投影前后之区域面积不变，但形状、角度、比例都可能会扭曲。如穆尔威（Mollweid）投影、彭纳（Bonne）投影、正弦（Sinusoidal）等积投影。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image32.jpg)

图：正弦等积投影图

**等距投影（Equidistanct projection）**

投影前后两地之前的距离不变。如圆锥投影。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image33.jpg)

图:兰柏特等距圆锥投影图

**等角投影（Azimuthal projection）**

投影前后两点的方位角（夹角）保持不变，代表与球面上所量得的方位一致，而且依据此投影方式所得地图上两点之直线距离并非为最短距离。例如地图上的飞行航线，大圆航线才是最短距离。许多的等角投影也会是等形(如Mercator 投影)、等面积或等距离投影。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image34.jpg)

图 : 等角等距投影图

## 依投影面与地球接触位置分

**圆锥投影（Conical projection）**

将地球球面投影至与之相切或相割的圆锥面，再展开成平面。通常在球面与圆椎面相交的地方附近的面积最准确，属于等距离投影。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image35.jpg)

图 :圆锥投影图

**圆柱投影（Cylindrical projection）**

地球球面投影在圆柱筒上，在将圆柱加以展开，地球球面与圆柱相交的地方是一个大圆，通常是赤道。投影出的地图的经线和纬线和原本地球仪上的一样，互相垂直。属于一种正形投影。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image36.jpg)

图 :圆柱投影图

**方位投影（Azimuthal projection）**

又称平面投影，将地球球面与投影平面相切或相割，依照光源位置可分为正射与中心投影。投影出来的平面地图呈圆形，纬线为同心圆，经线则从圆心向外作放射线。这种投影法所投影出来的地图面积比例和实际相符。

![img](https://image.malagis.com/pic/gis/qgis-handbook-2-2/image37.jpg)

图:方位投影图