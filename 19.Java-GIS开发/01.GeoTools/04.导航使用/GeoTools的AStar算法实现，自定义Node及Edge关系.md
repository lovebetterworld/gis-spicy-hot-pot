## 1 核心依赖包

开发语言java

```xml
<dependency>   
    <groupId>org.geotools</groupId>    
    <artifactId>gt-graph</artifactId>   
    <version>18.0</version>
</dependency>
```

Geotools提供了一个Graph的扩展包，这个扩展包不只是对A*算法进行了实现，也对算法[Dijkstra](https://link.juejin.cn?target=http%3A%2F%2Fwww.cnblogs.com%2FE%3A%2Fgis%E8%B5%84%E6%96%99%2F%E5%BC%80%E6%BA%90%E8%B5%84%E6%96%99%2Fgeotools-14.2-doc%2Fapidocs%2Forg%2Fgeotools%2Fgraph%2Fpath%2FDijkstraShortestPathFinder.html)进行了实现，两种算法在Geotools中的用法基本一致。

## 2 基本概念介绍

![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2019/12/13/16efe8d961d12391~tplv-t2oaga2asx-zoom-in-crop-mark:3024:0:0:0.awebp)

### 2.1 Graph（图）

可以理解为是一个将要建模的对象的容器，图里面存放的是很多的点（node）和边（edge）。

### 2.2 Node（点）

Node（点）是将要建模的对象，它可以指的是实际地图中的一个坐标点，也可以指的是任意坐标系中的一个点，也可以指的是拓扑图里面的一个节点。构建好的Node全部都存放在Graph中。

### 2.3 Edge（边）

边是指两个Node（点）的关联，一个边下面会有两个点，在图中的边是认为两个点之间可到达，边下面两个点分别表示NodeA和NodeB，节点方向为NodeA->NodeB,

## 3 在地图上标注POI点，并采集每个点的坐标

如图，合肥紫云山公园（随便选的公园），随意标注13个POI点（随便标注的点），采集这13个点的坐标。

![image-20220809144414623](https://www.lovebetterworld.com:8443/uploads/2022/08/09/62f2064ab2439.png)

坐标采集可以通过百度、或者高德的坐标采集器实现。

如高德坐标采集器地址：[高德地图获取地图坐标（GCJ-02坐标） - openGPS.cn](https://www.opengps.cn/Map/Tools/PickUpGPS_AMap.aspx)

定位到该公园：117.329088,31.739236

获取到13个点的坐标。

## 4 标注出13个POI的拓扑关系，即到达关系

如图，标注出每个POI的拓扑关系（随便标注的）

![image-20220809144803665](https://www.lovebetterworld.com:8443/uploads/2022/08/09/62f2064de4f9c.png)

## 5 生成Node节点以及Edge边，并标注POI点与Node节点对应关系

Node生成出来是无序的，如图所示（需根据生成的Node节点和POI点进行对应）。

```java
//构造点
BasicGraphGenerator basicGraphGenerator = new BasicGraphGenerator();
BasicGraphBuilder basicGraphBuilder = new BasicGraphBuilder();
Coordinate[] coordinates = new Coordinate[12];
coordinates[0] = new Coordinate(104.069649, 30.542246);
coordinates[1] = new Coordinate(104.071001, 30.542283);
coordinates[2] = new Coordinate(104.073458, 30.542329);
coordinates[3] = new Coordinate(104.075775, 30.541063);
coordinates[4] = new Coordinate(104.075743, 30.537792);
coordinates[5] = new Coordinate(104.073469, 30.537505);
coordinates[6] = new Coordinate(104.071098, 30.537431);
coordinates[7] = new Coordinate(104.069832, 30.537367);
coordinates[8] = new Coordinate(104.074756, 30.540897);
coordinates[9] = new Coordinate(104.073458, 30.540887);
coordinates[10] = new Coordinate(104.072857, 30.538882);
coordinates[11] = new Coordinate(104.071023, 30.540961);
List<Node> nodeList = new ArrayList<>();
for (int i = 0; i < 12; i++) {
    Node node = basicGraphGenerator.getGraphBuilder().buildNode();
    basicGraphGenerator.getGraphBuilder().addNode(node);
    node.setObject(coordinates[i]);
    node.setID(i);
    node.setCount(i);
    node.setVisited(true);
    basicGraphBuilder.addNode(node);
    nodeList.add(node);
}
```

Node生成示例数据如下：V=[6, 9, 1, 7, 4, 2, 8, 10, 5, 11, 3, 0]

![image-20220809145009794](https://www.lovebetterworld.com:8443/uploads/2022/08/09/62f206517e969.png)

Edge生成：

```java
public static Graph buildEdge(BasicGraphBuilder basicGraphBuilder, List<Node> nodeList) {
    BasicGraphGenerator basicGraphGenerator = new BasicGraphGenerator();
    Map<Integer, String> map = new HashMap<>();
    map.put(1, "2");
    map.put(2, "3,12");
    map.put(3, "4,10");
    map.put(4, "5");
    map.put(5, "6");
    map.put(6, "7,11");
    map.put(7, "8");
    map.put(8, "1");
    map.put(9, "4");
    map.put(10, "9,11");
    map.put(11, "12,7");
    map.put(12, "7");
    for (Map.Entry<Integer, String> entry : map.entrySet()) {
        if (entry.getValue().split(",").length > 1) {
            String[] strings = entry.getValue().split(",");
            for (String string : strings) {
                if (Integer.parseInt(string) == 12) {
                    string = "11";
                }
                Edge edge = new BasicEdge(nodeList.get(entry.getKey()), nodeList.get(Integer.parseInt(string)));
                Long distance = getDistance(nodeList.get(entry.getKey()), nodeList.get(Integer.parseInt(string)));
                edge.setObject(distance);
                edge.setVisited(true);
                basicGraphBuilder.addEdge(edge);
            }
        } else {
            Integer key = entry.getKey();
            if (Integer.parseInt(entry.getValue()) == 12) {
                entry.setValue("11");
            }
            if (key == 12) {
                key = 11;
            }
            //构造边
            Edge edge = new BasicEdge(nodeList.get(key), nodeList.get(Integer.parseInt(entry.getValue())));
            Long distance = getDistance(nodeList.get(key), nodeList.get(Integer.parseInt(entry.getValue())));
            edge.setObject(distance);
            edge.setVisited(true);
            basicGraphBuilder.addEdge(edge);
        }
    }
    System.out.println(basicGraphBuilder.getNodes());
    System.out.println(basicGraphBuilder.getGraph());
    return basicGraphBuilder.getGraph();
}
```

Edge生成示例数据如下：

`E=[13 (2,3), 25 (10,11), 14 (2,11), 16 (3,10), 18 (5,6), 17 (4,5), 15 (3,4), 24 (10,9), 22 (8,1), 19 (6,7), 23 (9,4), 21 (7,8), 28 (11,7), 20 (6,11), 26 (11,11), 12 (1,2), 27 (11,7)]`

注意，Edge括号中，描述的为POI点的序号。

标注Edge的关系，示例如图。

![image-20220809145416205](https://www.lovebetterworld.com:8443/uploads/2022/08/09/62f2065730684.png)

## 6 使用AStar导航进行计算路径

```java
public static void AStarShortestPath(Graph graph, Node startNode, Node endNode) {
        AStarIterator.AStarFunctions aStarFunction = new AStarIterator.AStarFunctions(endNode) {
            @Override
            public double cost(AStarIterator.AStarNode aStarNode, AStarIterator.AStarNode aStarNode1) {
                Edge edge = aStarNode.getNode().getEdge(aStarNode1.getNode());
                System.out.println("edge=" + edge.getID() + ",Distance" + edge.getObject());
                /*SimpleFeature feature = (SimpleFeature) edge.getObject();
                Geometry geometry = (Geometry) feature.getDefaultGeometry();
                System.out.println(aStarNode.getH());
                return geometry.getLength();*/
//                return Integer.parseInt(String.valueOf(edge.getObject()));
                return 10;
            }

            @Override
            public double h(Node node) {
                return -10;
            }
        };
        Date start = new Date();
        AStarShortestPathFinder aStarPf = new AStarShortestPathFinder(graph, startNode, endNode, aStarFunction);
        try {
            aStarPf.calculate();
            Date end = new Date();
            System.out.println("AStar算法耗时：" + (end.getTime() - start.getTime()));
            aStarPf.getPath();
            System.out.println("AStar算法距离：" + getPathLength(aStarPf.getPath()));
/*            Iterator it = aStarPf.getPath().iterator();
            String result = "";
            while (it.hasNext()) {
                Node node = (Node) it.next();
                result = result + node.getObject().toString();
            }
            System.out.println("result:" + result);*/
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
```

## 7 完整代码

```java
import org.geotools.data.DataStore;
import org.geotools.data.shapefile.ShapefileDataStore;
import org.geotools.data.simple.SimpleFeatureCollection;
import org.geotools.feature.FeatureIterator;
import org.geotools.graph.build.basic.BasicGraphBuilder;
import org.geotools.graph.build.basic.BasicGraphGenerator;
import org.geotools.graph.build.feature.FeatureGraphGenerator;
import org.geotools.graph.build.line.LineStringGraphGenerator;
import org.geotools.graph.path.AStarShortestPathFinder;
import org.geotools.graph.path.Path;
import org.geotools.graph.structure.Edge;
import org.geotools.graph.structure.Graph;
import org.geotools.graph.structure.Node;
import org.geotools.graph.structure.basic.BasicEdge;
import org.geotools.graph.traverse.standard.AStarIterator;
import org.geotools.referencing.GeodeticCalculator;
import org.geotools.referencing.crs.DefaultGeographicCRS;
import org.locationtech.jts.geom.Coordinate;
import org.opengis.feature.Feature;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.util.*;

public class NavigationUtil {
    
    /*public static void main(String[] args) throws IOException {

        File file = new File("E:\\公交路线.shp");
        //1.读取shp数据
        DataStore dataStore = readShapeFile(file);
        SimpleFeatureSource featureSource = dataStore.getFeatureSource(dataStore.getTypeNames()[0]);
        SimpleFeatureCollection simFeatureCollect = featureSource.getFeatures();
        System.out.println("shp文件原始线的个数：" + simFeatureCollect.size());
        //2.创建graph数据结构
        Graph graph = buildGraph(simFeatureCollect);
        Iterator<Node> iterator = graph.getNodes().iterator();
        List<Node> nodeArrayList = new ArrayList<>();
        while (iterator.hasNext()) {
            nodeArrayList.add(iterator.next());
        }
        System.out.println("节点：" + graph.getNodes());
        System.out.println("边：" + graph.getEdges());
        System.out.println(nodeArrayList.get(74));
        System.out.println(nodeArrayList.get(283));
        AStarShortestPath(graph, nodeArrayList.get(74), nodeArrayList.get(283));
    }*/

    public static void main(String[] args) throws IOException {
        buildNodeAndEdgeGraph();
    }

    public static void AStarShortestPath(Graph graph, Node startNode, Node endNode) {
        AStarIterator.AStarFunctions aStarFunction = new AStarIterator.AStarFunctions(endNode) {
            @Override
            public double cost(AStarIterator.AStarNode aStarNode, AStarIterator.AStarNode aStarNode1) {
                Edge edge = aStarNode.getNode().getEdge(aStarNode1.getNode());
                System.out.println("edge=" + edge.getID() + ",Distance" + edge.getObject());
                /*SimpleFeature feature = (SimpleFeature) edge.getObject();
                Geometry geometry = (Geometry) feature.getDefaultGeometry();
                System.out.println(aStarNode.getH());
                return geometry.getLength();*/
//                return Integer.parseInt(String.valueOf(edge.getObject()));
                return 10;
            }

            @Override
            public double h(Node node) {
                return -10;
            }
        };
        Date start = new Date();
        AStarShortestPathFinder aStarPf = new AStarShortestPathFinder(graph, startNode, endNode, aStarFunction);
        try {
            aStarPf.calculate();
            Date end = new Date();
            System.out.println("AStar算法耗时：" + (end.getTime() - start.getTime()));
            aStarPf.getPath();
            System.out.println("AStar算法距离：" + getPathLength(aStarPf.getPath()));
/*            Iterator it = aStarPf.getPath().iterator();
            String result = "";
            while (it.hasNext()) {
                Node node = (Node) it.next();
                result = result + node.getObject().toString();
            }
            System.out.println("result:" + result);*/
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static DataStore readShapeFile(File shpFile) throws MalformedURLException {
        ShapefileDataStore shapefileDataStore = new ShapefileDataStore(shpFile.toURI().toURL());
        return shapefileDataStore;
    }

    public static Graph buildNodeAndEdgeGraph() {
        //构造点
        BasicGraphGenerator basicGraphGenerator = new BasicGraphGenerator();
        BasicGraphBuilder basicGraphBuilder = new BasicGraphBuilder();
        Coordinate[] coordinates = new Coordinate[12];
        coordinates[0] = new Coordinate(104.069649, 30.542246);
        coordinates[1] = new Coordinate(104.071001, 30.542283);
        coordinates[2] = new Coordinate(104.073458, 30.542329);
        coordinates[3] = new Coordinate(104.075775, 30.541063);
        coordinates[4] = new Coordinate(104.075743, 30.537792);
        coordinates[5] = new Coordinate(104.073469, 30.537505);
        coordinates[6] = new Coordinate(104.071098, 30.537431);
        coordinates[7] = new Coordinate(104.069832, 30.537367);
        coordinates[8] = new Coordinate(104.074756, 30.540897);
        coordinates[9] = new Coordinate(104.073458, 30.540887);
        coordinates[10] = new Coordinate(104.072857, 30.538882);
        coordinates[11] = new Coordinate(104.071023, 30.540961);
        List<Node> nodeList = new ArrayList<>();
        for (int i = 0; i < 12; i++) {
            Node node = basicGraphGenerator.getGraphBuilder().buildNode();
            basicGraphGenerator.getGraphBuilder().addNode(node);
            node.setObject(coordinates[i]);
            node.setID(i);
            node.setCount(i);
            node.setVisited(true);
            basicGraphBuilder.addNode(node);
            nodeList.add(node);
        }
        buildEdge(basicGraphBuilder, nodeList);
        System.out.println("nodeList:" + nodeList);
        AStarShortestPath(basicGraphBuilder.getGraph(), nodeList.get(1), nodeList.get(5));
        return basicGraphBuilder.getGraph();
    }

    public static Graph buildGraph(SimpleFeatureCollection simFeatureCollect) {
        //构造线
        LineStringGraphGenerator lineStringGen = new LineStringGraphGenerator();
        FeatureGraphGenerator featureGen = new FeatureGraphGenerator(lineStringGen);
        FeatureIterator iter = simFeatureCollect.features();
        while (iter.hasNext()) {
            Feature next = iter.next();
            featureGen.add(next);
        }
        iter.close();
        return featureGen.getGraph();
    }

    public static Graph buildEdge(BasicGraphBuilder basicGraphBuilder, List<Node> nodeList) {
        BasicGraphGenerator basicGraphGenerator = new BasicGraphGenerator();
        Map<Integer, String> map = new HashMap<>();
        map.put(1, "2");
        map.put(2, "3,12");
        map.put(3, "4,10");
        map.put(4, "5");
        map.put(5, "6");
        map.put(6, "7,11");
        map.put(7, "8");
        map.put(8, "1");
        map.put(9, "4");
        map.put(10, "9,11");
        map.put(11, "12,7");
        map.put(12, "7");
        for (Map.Entry<Integer, String> entry : map.entrySet()) {
            if (entry.getValue().split(",").length > 1) {
                String[] strings = entry.getValue().split(",");
                for (String string : strings) {
                    if (Integer.parseInt(string) == 12) {
                        string = "11";
                    }
                    Edge edge = new BasicEdge(nodeList.get(entry.getKey()), nodeList.get(Integer.parseInt(string)));
                    Long distance = getDistance(nodeList.get(entry.getKey()), nodeList.get(Integer.parseInt(string)));
                    edge.setObject(distance);
                    edge.setVisited(true);
                    basicGraphBuilder.addEdge(edge);
                }
            } else {
                Integer key = entry.getKey();
                if (Integer.parseInt(entry.getValue()) == 12) {
                    entry.setValue("11");
                }
                if (key == 12) {
                    key = 11;
                }
                //构造边
                Edge edge = new BasicEdge(nodeList.get(key), nodeList.get(Integer.parseInt(entry.getValue())));
                Long distance = getDistance(nodeList.get(key), nodeList.get(Integer.parseInt(entry.getValue())));
                edge.setObject(distance);
                edge.setVisited(true);
                basicGraphBuilder.addEdge(edge);
            }
        }
        System.out.println(basicGraphBuilder.getNodes());
        System.out.println(basicGraphBuilder.getGraph());
        return basicGraphBuilder.getGraph();
    }

    public static String getPathLength(Path path) {
        return path.toString();
    }

    //计算两个节点的经纬度距离
    public static Long getDistance(Node nodeA, Node nodeB) {
        // 84坐标系构造GeodeticCalculator
        GeodeticCalculator geodeticCalculator = new GeodeticCalculator(DefaultGeographicCRS.WGS84);
        Coordinate coordinate1 = (Coordinate) nodeA.getObject();
        Coordinate coordinate2 = (Coordinate) nodeB.getObject();
        // 起点经纬度
        geodeticCalculator.setStartingGeographicPoint(coordinate1.getX(), coordinate1.getY());
        // 末点经纬度
        geodeticCalculator.setDestinationGeographicPoint(coordinate2.getX(), coordinate2.getY());
        // 计算距离，单位：米
        double orthodromicDistance = geodeticCalculator.getOrthodromicDistance();
        return new Double(orthodromicDistance).longValue();
    }
}
```

## 8 参考文章

- [geoTools的A*（A star）算法计算最优路径 - 掘金 (juejin.cn)](https://juejin.cn/post/6844904020595884046)
