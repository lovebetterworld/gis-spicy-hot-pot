- [实战 Java读取shp文件内容_lakernote的博客-CSDN博客_java shp读取](https://laker.blog.csdn.net/article/details/111035327)

# Java读取shp文件内容

## 背景

近期项目需求，需要读取shp中的点、线、面以及属性信息。

## pom.xml引入

官网的指导文档下不下来，要换源

```xml
<dependency>
    <groupId>org.geotools</groupId>
    <artifactId>gt-shapefile</artifactId>
    <version>22-RC</version>
</dependency>
```

`重点`、`重点`、`重点` **换成这个源**

```xml
<repository>
    <id>geotools</id>
    <name>geotools</name>
    <url>http://maven.icm.edu.pl/artifactory/repo/</url>
    <releases>
        <enabled>true</enabled>
    </releases>
</repository>
```

## 实例代码

```java
Map<String, Object> map = new HashMap<String, Object>();
        File file = new File("C:\\Users\\86182\\Desktop\\ziyuan\\zj-dj\\zj-dj.shp");
        map.put("url", file.toURI().toURL());// 必须是URL类型
        ArrayList<Map> models = new ArrayList<>();
        DataStore dataStore = DataStoreFinder.getDataStore(map);
        //字符转码，防止中文乱码
        ((ShapefileDataStore) dataStore).setCharset(Charset.forName("utf8"));
        String typeName = dataStore.getTypeNames()[0];
        FeatureSource<SimpleFeatureType, SimpleFeature> source = dataStore.getFeatureSource(typeName);
        FeatureCollection<SimpleFeatureType, SimpleFeature> collection = source.getFeatures();
        FeatureIterator<SimpleFeature> features = collection.features();
        while (features.hasNext()) {
            // 迭代提取属性
            SimpleFeature feature = features.next();
            Iterator<? extends Property> iterator = feature.getValue().iterator();
            String name = "";
            String type = "";
            String mapId = "";
            while (iterator.hasNext()) {
                Property property = iterator.next();
                // property 属性自己debug看下
                // "the_geom" 点、线、面
                if (property.getName().toString().equals("type")) {
                    type = property.getValue().toString();

                }
                if (property.getName().toString().equals("name")) {
                    name = property.getValue().toString();
                }
                if (property.getName().toString().equals("id")) {
                    mapId = property.getValue().toString();
                }

            }
             System.out.println(name + type + mapId);

        }
```