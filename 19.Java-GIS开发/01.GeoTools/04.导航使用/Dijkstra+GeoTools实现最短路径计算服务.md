- [`Dijkstra+GeoTools实现最短路径计算服务 - 简书 (jianshu.com)](https://www.jianshu.com/p/d16683d849ec)

## 为什么会有这篇

作者在给一个园区做地图时候，甲方有需求能够针对这个园区进行路径规划服务，也即告知起止点（甚至途径点），计算出一条路径。

这是一个典型的路径规划问题，各个地图大厂都有路径规划服务，但是针对园区内还没有。也有很多前辈基于pgRouting实现过，例如：[基于pgrouting的任意两点间的最短路径查询函数二
 ](https://links.jianshu.com/go?to=https%3A%2F%2Fblog.csdn.net%2Flongshengguoji%2Farticle%2Fdetails%2F46793111)

但是需要借助PostgreSQL、Postgis、GeoServer等。针对一个园区，这些有点重，工程施工也比较繁琐。园区内道路简单，节点也不算多，可以把Postgis替我们干的活我们自己做。

如果你正在做一个园区的最短路径服务，并且希望服务轻量（不需要那么多依赖工具）这篇文章适合你。

## 准备工作

1、你有一个要做最短路径规划的园区平面图（可能是甲方给你的CAD图纸、或者你从OSM亦或百度高德谷歌地图上临摹的道路中心线Shp文件），进行空间配准后将其导出为shp文件或geojson文件。

![img](https:////upload-images.jianshu.io/upload_images/3610588-d6f674448ada3ad0.png?imageMogr2/auto-orient/strip|imageView2/2/w/790/format/webp)

2、对这个文件进行处理，完成一部分Postgis替我们干的活。主要是给道路进行编号、给道路节点进行编号、给道路添加起止节点（引用道路节点）。生成两个文件，暂且给它命名为（roadline、roadpoint）。

 其属性表如下

![img](https:////upload-images.jianshu.io/upload_images/3610588-3e5851e169972091.png?imageMogr2/auto-orient/strip|imageView2/2/w/536/format/webp)

roadline.png

![img](https:////upload-images.jianshu.io/upload_images/3610588-832b46186921d909.png?imageMogr2/auto-orient/strip|imageView2/2/w/314/format/webp)

roadpoint.png

roadpoint字段单一，这里只给出了一个节点编号，重点解释一下roadline。

roadline是道路中心线的分段，每条线段有由线段ID(ID)、起点编号(start)、终点编号(target)、是否双向(twoway)、权重(weight)构成，其权重值即为路段长度。

![img](https:////upload-images.jianshu.io/upload_images/3610588-cf2f42d83cd53ef2.png?imageMogr2/auto-orient/strip|imageView2/2/w/529/format/webp)
PS：在对道路进行分段的时候，遵循的技巧是在岔道口分段。

将数据手动填充完，把两个文件保存为geojson格式，放置在项目resource文件夹内备用。

完成上述工作，基本上数据就准备完毕了。

## 算法开发

Dijkstra是成熟的最短路径算法，可以到github上找一个脚手架算法。把代码下载并在本地调试，它会帮助你理解该算法。

但是，github上的算法基本上是告诉你这条路径应该按什么样的节点顺序走，而我们的应用中希望是获得一条或者多条道路中心线（前端页面最想获得的就是一串道路中心线坐标或者linestring 这样的wkt）。所以我们得把算法改动一下，增加途径的路段。

### 构造实体对象

首先是节点对象，它包含这样几个字段，分别为节点编号、节点相连的路段列表、节点与目标节点途经路径（由节点列表构成）、节点与目标节点途经的路段（由路段ID列表构成）

```java
public class Vertex implements Comparable<Vertex> {
    public String id; 
    public ArrayList<Edge> neighbours;
    public LinkedList<Vertex> path;
    public LinkedList<String> linkedgeid;
}
```

其次是路段对象，它由起始节点、终止节点、权重、双向标志位、路段编号、路段Geometry对象构成

```cpp
public class Edge {
    public Vertex start;
    public Vertex target;
    public double weight;
    public String twoway;
    public String edgeid;
    public LineString lineString;
}
```

最后是图，它就是由节点列表和路段列表构成

```cpp
public class Graph {
    private ArrayList<Vertex> vertices;
    private ArrayList<Edge> edges;
}
```

### 图的初始化

Dijkstra算法最重要一步是图的初始化工作。

首先，读取节点对应的geojson文件，来初始化图中的节点列表。

其次，读取路段对应的geojson文件，构建节点的连接关系，并填充图中的路段列表。（这里，根据路段双向标志物进行判断，如果是双向起止节点要添加两次，如果是单向只添加一次）

### 算法实现

这部分可以参照postgis实现，把sql语句改写为java代码即可。作者在这就直接上代码。

```dart
    //输入起点终点坐标，计算最短路径
    public static List calculateMinRoute(double startlon, double startlat, double endlon, double endlat, Graph graph) {
        List resultls = new ArrayList();
        Edge startEdge = calculateEdge(startlon, startlat, graph.getEdges());
        Edge endEdge = calculateEdge(endlon, endlat, graph.getEdges());
        List ss = calculatePath(startEdge.start, endEdge.start, graph);
        List st = calculatePath(startEdge.start, endEdge.target, graph);
        List ts = calculatePath(startEdge.target, endEdge.start, graph);
        List tt = calculatePath(startEdge.target, endEdge.target, graph);
        List<Edge> minls = ss;
        double minlenss = calculateWeight(ss);
        double minlenst = calculateWeight(st);
        double minlents = calculateWeight(ts);
        double minlentt = calculateWeight(tt);
        if(minlenss > minlenst) {
            minls = st;
        }
        if(minlenst > minlents) {
            minls = ts;
        }
        if(minlents > minlentt) {
            minls = tt;
        }

        LineMerger lineMerger = new LineMerger();
        List<Geometry> list = new ArrayList<Geometry>();
        list.add(startEdge.getLineString());
        for(Edge edge:minls) {
            if(edge.start.getId() != startEdge.start.getId() && edge.target.getId() != startEdge.target.getId()) {
                list.add(edge.getLineString());
            }
        }
        if(startEdge.start.getId() != endEdge.start.getId() && startEdge.target.getId() != endEdge.target.getId()) {
            list.add(endEdge.getLineString());
        }
        lineMerger.add(list);
        WKTWriter writer = new WKTWriter();
        //将所有线段进行合并(如若首位坐标不匹配，可能合并后不止一条线段)
        Collection<Geometry> mergerLineStrings = lineMerger.getMergedLineStrings();
        if(mergerLineStrings.size() == 1) {
            LocationIndexedLine mergeline=new LocationIndexedLine(mergerLineStrings.iterator().next());
            Coordinate spoint = new Coordinate(startlon, startlat);
            LinearLocation shere=mergeline.project(spoint);

            Coordinate epoint = new Coordinate(endlon, endlat);
            LinearLocation ehere=mergeline.project(epoint);

            LinearLocation temp;
            if(shere.compareTo(ehere) > 0) {
                temp = shere;
                shere = ehere;
                ehere = temp;
            }

            LineString result = (LineString)mergeline.extractLine(shere, ehere);
            resultls.add(writer.write(result));
        }
    }
```

这里用到来geotools中的linemerge功能（在此特别感谢[polong](https://www.jianshu.com/u/2dab1981109e)，每每遇到问题都能从他那找到答案）

### 结果

让前端帮我测试了一下，效果还不错。

![img](https:////upload-images.jianshu.io/upload_images/3610588-373509c7aa063c69.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

image.png

![img](https:////upload-images.jianshu.io/upload_images/3610588-c4ef7d4daafca763.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

image.png

![img](https:////upload-images.jianshu.io/upload_images/3610588-1477bce590cc2c7c.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)