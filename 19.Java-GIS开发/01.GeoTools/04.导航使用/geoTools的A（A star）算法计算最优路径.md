- [geoTools的A*（A star）算法计算最优路径 - 掘金 (juejin.cn)](https://juejin.cn/post/6844904020595884046)

## 1 概述

寻路算法有很多种，A*寻路算法被公认为最好的寻路算法，对A*算法的原理想要详细了解的，推荐以下两篇文章

- [blog.csdn.net/qq_36946274…](https://link.juejin.cn?target=https%3A%2F%2Fblog.csdn.net%2Fqq_36946274%2Farticle%2Fdetails%2F81982691)

- [blog.csdn.net/denghecsdn/…](https://link.juejin.cn?target=https%3A%2F%2Fblog.csdn.net%2Fdenghecsdn%2Farticle%2Fdetails%2F78778769)

本文主要内容不会对A*算法的详细介绍，而是通过已经实现的A*算法的geotools工具来寻找最优路径。

## 2 核心依赖包

开发语言java

```xml
<dependency>   
    <groupId>org.geotools</groupId>    
    <artifactId>gt-graph</artifactId>   
    <version>18.0</version>
</dependency>
```

Geotools提供了一个Graph的扩展包，这个扩展包不只是对A*算法进行了实现，也对算法[Dijkstra](https://link.juejin.cn?target=http%3A%2F%2Fwww.cnblogs.com%2FE%3A%2Fgis%E8%B5%84%E6%96%99%2F%E5%BC%80%E6%BA%90%E8%B5%84%E6%96%99%2Fgeotools-14.2-doc%2Fapidocs%2Forg%2Fgeotools%2Fgraph%2Fpath%2FDijkstraShortestPathFinder.html)进行了实现，两种算法在Geotools中的用法基本一致。

## 3 基本概念介绍

![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2019/12/13/16efe8d961d12391~tplv-t2oaga2asx-zoom-in-crop-mark:3024:0:0:0.awebp)

### 3.1 Graph（图）

可以理解为是一个将要建模的对象的容器，图里面存放的是很多的点（node）和边（edge）。

### 3.2 Node（点）

Node（点）是将要建模的对象，它可以指的是实际地图中的一个坐标点，也可以指的是任意坐标系中的一个点，也可以指的是拓扑图里面的一个节点。构建好的Node全部都存放在Graph中。

### 3.3 Edge（边）

边是指两个Node（点）的关联，一个边下面会有两个点，在图中的边是认为两个点之间可到达，边下面两个点分别表示NodeA和NodeB，节点方向为NodeA->NodeB,

## 4 第一步：构图

既然是路径搜索，那必然是在图上进行搜索，无论是实际的地图，平面图还是流程图或者是自己构想的概念图，首先需要构建出一张图，然后才能在给定的图中根据条件去搜索最短路径。图是由很多的点和边构成，所以构图的同时要构建点和边，放到图中。

构图可以有多种方式：

### 4.1 通过导入shp文件构建

该文件格式已经成为了地理信息软件界的一个开放标准，需要引入依赖

```xml
<dependency>
    <groupId>org.geotools</groupId>
    <artifactId>gt-shapefile</artifactId>
    <version>24.2</version>
</dependency>
```

```java
public static void main(String[] args) throws IOException {
    String filePath = "F:/binjiang.shp";
    File shapeFile = new File(filePath);

    FileDataStore dataStore = FileDataStoreFinder.getDataStore(shapeFile);
    SimpleFeatureSource featureSource = dataStore.getFeatureSource();

    SimpleFeatureCollection simpleFeatureCollection = featureSource.getFeatures();
    Graph graph = buildGraph(simpleFeatureCollection);
}

private static Graph buildGraph(FeatureCollection fc) {
    LineStringGraphGenerator lineStringGen = new LineStringGraphGenerator();
    FeatureGraphGenerator featureGen = new FeatureGraphGenerator(lineStringGen);
    FeatureIterator iter = fc.features();
    while (iter.hasNext()) {
        Feature next = iter.next();
        featureGen.add(next);
    }
    iter.close();
    return featureGen.getGraph();
}
```

### 4.2 LineString

和上面的方式差不多，传入LineString的数据格式，通过LineStringGraphGenerator构建图，生成器会将lineString转换成图中的点和边放入图中

```java
LineStringGraphGenerator lineStringGraphGenerator = new LineStringGraphGenerator();
lineStringGraphGenerator.add(lineString);
BasicDirectedGraph graph = (BasicDirectedGraph)generator.getGraph();
```

### 4.3 手动构建

通过GraphGenerator手动构建Node（点）和Edge（边）来构造图。这种方式虽然需要手动去绘制点和边，但灵活性最高，可以构建流程图或是构想的概念图。

#### 4.3.1 简单介绍构图的辅助类有向图生成器BasicDirectedGraphGenerator 

该生成器继承GraphGenerator，内部使用了一个有向图构造器BasicDirectedGraphBuilder来构造点、边和图。该构造器继承了BasicGraphBuilder，如下图源码

![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2019/12/14/16f03b019aebad81~tplv-t2oaga2asx-zoom-in-crop-mark:3024:0:0:0.awebp)

可以发现，构建器在构建(Node)点和(Edge)边时，是用了HashSet来作为底层数据结构存储，**所以这里需要注意一个问题：当用这个方法手动构建时，需要用到多线程进行批量建模的时候，要注意线程安全的问题。**

#### 4.3.2 构造Node(点)

```
Node node = graphGenerator.getGraphBuilder().buildNode();
//将构造出来的点添加到生成器中
graphGenerator.getGraphBuilder().addNode(node);
```

构造点的时候，实际是通过GraphGenerator创建了一个Node对象。如果是有向图的点，点在被构建时，会初始化Node中的两个连接点列表

![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2019/12/14/16f03eb67f4ff786~tplv-t2oaga2asx-zoom-in-crop-mark:3024:0:0:0.awebp)

m_In和m_out存放的是当前Node有关系的边，m_In表示的是方向指向自身的Edge，m_out表示的是从自身出去的Edge。

例如：NodeA->NodeB可达 NodeC -> NodeA 可达

则在NodeA中的m_in会有NodeC -> NodeA，在m_out中会有NodeA->NodeB

当然这部分是到了构造边的时候才会添加入值，因为有边才表示两个点之间可达。

另外，Node继承的BasicGraphable中维护了一个Object类型的字段，我们可以在这个字段中放置一些标识该Node特性的信息。比如坐标，或者节点名称等。

![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2019/12/14/16f03fa38c165dfc~tplv-t2oaga2asx-zoom-in-crop-mark:3024:0:0:0.awebp)

```
node.setObject(new Coordinate(26.061743,119.169153));
```

#### 4.3.3 构造Edge(边)

Edge表示的就是图里面Node与Node之间的关系，所以一个边是包含了两个点。有边也认为两个点之间是可直达的。

![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2019/12/14/16f04016dba67f50~tplv-t2oaga2asx-zoom-in-crop-mark:3024:0:0:0.awebp)

```
Edge edge = graphGenerator.getGraphBuilder().buildEdge(nodeA, nodeB);
Long distance = getDistance(nodeA, nodeB)
edge.setObject(distance);
graphGenerator.getGraphBuilder().addEdge(edge);
```

同样我们可以在源码中看到，构建边的时候，会分别往边下面的两个Node中的m_in和m_out列表中去添加值

![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2019/12/14/16f04096dde771ae~tplv-t2oaga2asx-zoom-in-crop-mark:3024:0:0:0.awebp)

#### 4.3.4 获取图（Graph）

当完成点和边的构造之后，图也就构造完了，直接从生成器中getGraph()即可得到图

```
Graph graph = graphGenerator.getGraph();
```

## 4.4 第二步：设值权重，编写消耗函数和启发函数

这部分是寻找最短路径中的核心，不同权重的设值，对于最后计算出的结果息息相关

A*算法的遍历中,f(x) = g(x) + h(x)。g(x)对应的是两个点之间移动的消耗规则， h(x)是引导函数，引导路径朝着终点的方向进行。

```java
AStarIterator.AStarFunctions asFunction = new AStarIterator.AStarFunctions(destination) {

    @Override
    public double cost(AStarIterator.AStarNode aStarNode, AStarIterator.AStarNode aStarNode1) {
        Edge edge;
        double cost = Integer.MAX_VALUE;
        edge = ((DirectedNode)aStarNode.getNode()).getOutEdge((DirectedNode) aStarNode1.getNode());
        if(edge != null){
            cost = (double) edge.getObject();
        }
        return cost;
    }

    @Override
    public double h(Node node) {
        double h = 0d;
        Coordinate destCoor = (Coordinate) destination.getObject();    
        Coordinate nodeCoor = (Coordinate) node.getObject();
        distance = destCoor.distance(nodeCoor);
        return distance;
    }
};
```

## 4.5 第三步：寻找最短路径

传入构建好的graph，起点Node，终点Node和权重函数。通过AstarShortestPathFinder中的calculate()进行计算并最终会返回路径

```java
public Path findAStarShortestPath(Graph graph, Node source, Node destination, AStarIterator.AStarFunctions asFunction) throws Exception {
    Path shortestPath;
    // 求解最短路径
    AStarShortestPathFinder pf = new AStarShortestPathFinder(graph, source, destination, asFunction);
    // geotools 20.x 以上的版本才支持有向图的查找，其他版本会将有向图视作无向图
    pf.calculate();
    shortestPath = pf.getPath();
    return shortestPath;
}
```

返回的path中是路径中包含的所有Node，可以将路径遍历出来

```java
Iterator it = path.iterator();
String result = "";
while (it.hasNext()) {
    Node node = (Node) it.next();
    result = result + node.getObject().toString(); 
}
```

Path中遍历出来的路径是从终点到起点的，例如实际最短路径是NodeA-> NodeD -> NodeB ->NodeC，从path中遍历出来的结果是NodeC、NodeB、NodeD、NodeA

## **tips**：

这里还有一个点需要说明，由于寻找最短路径时，我们需要给定start Node和destination Node，但是通常情况下我们一般给定的是两个坐标点，或者两个流程节点的标识。

如果是在坐标地图中，我们可以通过graph的queryNodes()来找到条件范围内的所有点（通过重写其visit方法，可以设定在给定点的多少范围内认为可选，返回PASS_AND_CONTINUE状态，否则返回FAIL_QUERY状态），从而去找到起点和终点相应的Node。

如果是流程图或者概念图，可以在内存中放一个Map<String, Node> nodeMap去存储图中的所有Node，这样我们可以通过每个node的特性快速找到对应的Node。