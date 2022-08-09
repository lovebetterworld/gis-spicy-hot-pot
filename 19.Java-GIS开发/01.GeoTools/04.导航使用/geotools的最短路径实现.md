- [geotools的最短路径实现-爱码网 (likecs.com)](https://www.likecs.com/show-308099985.html)

Geotools提供了一个Graph的扩展包，使用它可以实现最短路径的查找，提供的算法有[Dijkstra](https://www.likecs.com/default/index/url?u=aHR0cDovL3d3dy5jbmJsb2dzLmNvbS9FOi9naXMlRTglQjUlODQlRTYlOTYlOTkvJUU1JUJDJTgwJUU2JUJBJTkwJUU4JUI1JTg0JUU2JTk2JTk5L2dlb3Rvb2xzLTE0LjItZG9jL2FwaWRvY3Mvb3JnL2dlb3Rvb2xzL2dyYXBoL3BhdGgvRGlqa3N0cmFTaG9ydGVzdFBhdGhGaW5kZXIuaHRtbA==)和AStar。Api的功能非常强大，只需要提供line的features对象，即可创建graph，然后调用算法即可实现最短路径查找，权重可以自由设置，对于不懂算法的人用起来也毫不费力。

Dijkstra的使用

```java
String filePath = "E:\\gis资料\\测试数据\\道路中心线.shp";
//读取shp数据
DataStore dataStore = *readShapeFile(filePath);
SimpleFeatureSource featureSource = dataStore.getFeatureSource(dataStore.getTypeNames()[0]);
SimpleFeatureCollection simFeatureCollect =featureSource.getFeatures();
final Integer num = new Integer(0);
System.out.println("shp文件原始线的个数：" + simFeatureCollect.size());
//创建graph数据结构
Graph graph = buildGraph(simFeatureCollect);
//这里是定义权重
DijkstraIterator.EdgeWeighter weighter = new DijkstraIterator.EdgeWeighter(){
    @Override
    public double getWeight(Edge edge) {
        //这个方法返回的值就是权重，这里使用的最简单的线的长度
        //如果有路况、限速等信息，可以做的更复杂一些
        SimpleFeature feature = (SimpleFeature)edge.getObject();
        Geometry geometry = (Geometry)feature.getDefaultGeometry();
        return geometry.getLength();
    }
};
Date startT = new Date();
//初始化查找器
DijkstraShortestPathFinder pf = new DijkstraShortestPathFinder(graph,start,weighter);
pf.calculate();
//传入终点，得到最短路径
Path path = pf.getPath(destination);
Date end = new Date();
System.out.println("迪杰斯特拉算法耗时：" +(end.getTime() - startT.getTime()));
System.out.println("迪杰斯特拉算法距离："+getPathLength(path));
System.out.println(destination.getID()+""+start.equals(destination));
```

//AStar算法

```java
public static void AStarShortestPath(Graph graph,Node startNode,Node endNode){
    AStarIterator.AStarFunctions aStarFunction = new  AStarIterator.AStarFunctions(endNode){
        @Override
        public double cost(AStarIterator.AStarNode aStarNode, AStarIterator.AStarNode aStarNode1) {
            Edge edge = aStarNode.getNode().getEdge(aStarNode1.getNode());
            SimpleFeature feature = (SimpleFeature)edge.getObject();
            Geometry geometry = (Geometry)feature.getDefaultGeometry();
            System.out.println(aStarNode.getH());
            return geometry.getLength();
        }

        @Override
        public double h(Node node) {
            return -10;
        }
    };
    Date start = new Date();
    AStarShortestPathFinder aStarPf = new AStarShortestPathFinder(graph,startNode,endNode,aStarFunction);
    try {
        aStarPf.calculate();
        Date end = new Date();
        System.out.println("AStar算法耗时：" +(end.getTime() - start.getTime()));
        System.out.println("AStar算法距离：" + getPathLength(aStarPf.getPath()));
    } catch (Exception e) {
        e.printStackTrace();
    }

}
```



 

 ![geotools的最短路径实现](https://www.likecs.com/default/index/img?u=aHR0cHM6Ly9pbWFnZXMyMDE1LmNuYmxvZ3MuY29tL2Jsb2cvOTE1MDM2LzIwMTYwNi85MTUwMzYtMjAxNjA2MjIxNjMxMzE3OTctNzE5MzA1MjA3LnBuZw==)



AStar算法使用也很简单，可参考api使用文档。两个算法效率比较下来，AStar算法效率更好。算法验证和效率比较：

使用同样的起点和终点，分别调用上面两个算法，计算结果如下：

shp文件原始线段的个数：67749

AStar算法耗时：84ms

AStar距离：0.2307215100346536

迪杰斯特拉耗时：188ms

迪杰斯特拉距离：0.2307215100346536