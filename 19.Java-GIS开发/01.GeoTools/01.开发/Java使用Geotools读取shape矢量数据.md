- [Java使用Geotools读取shape矢量数据 - 开放GIS - 博客园 (cnblogs.com)](https://www.cnblogs.com/share-gis/p/16001897.html)

maven依赖

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" 
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
                             https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>org.dudu.liuyang</groupId>
    <artifactId>gis</artifactId>
    <version>0.0.1-SNAPSHOT</version>

    <repositories>
        <repository>
            <id>central</id>
            <name>aliyun maven</name>
            <url>https://maven.aliyun.com/repository/central</url>
            <snapshots>
                <enabled>false</enabled>
            </snapshots>
            <releases>
                <enabled>true</enabled>
            </releases>
        </repository>

        <repository>
            <id>osgeo-releases</id>
            <name>OSGeo Nexus Release Repository</name>
            <url>https://repo.osgeo.org/repository/release/</url>
            <snapshots>
                <enabled>false</enabled>
            </snapshots>
            <releases>
                <enabled>true</enabled>
            </releases>
        </repository>

        <repository>
            <id>osgeo-snapshots</id>
            <name>OSGeo Nexus Snapshot Repository</name>
            <url>https://repo.osgeo.org/repository/snapshot/</url>
            <snapshots>
                <enabled>false</enabled>
            </snapshots>
            <releases>
                <enabled>true</enabled>
            </releases>
        </repository>

        <repository>
            <id>geosolutions</id>
            <name>geosolutions repository</name>
            <url>https://maven.geo-solutions.it/</url>
            <snapshots>
                <enabled>false</enabled>
            </snapshots>
            <releases>
                <enabled>true</enabled>
            </releases>
        </repository>
    </repositories>

    <dependencies>
        <dependency>
            <groupId>org.geotools</groupId>
            <artifactId>gt-shapefile</artifactId>
            <version>25.2</version>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <version>2.2.8.RELEASE</version>
            </plugin>
        </plugins>
    </build>

</project>
```

主要代码：

```java
package gis;

import java.io.File;
import java.io.IOException;
import java.util.List;

import org.geotools.data.FeatureSource;
import org.geotools.data.Query;
import org.geotools.data.shapefile.ShapefileDataStore;
import org.geotools.data.simple.SimpleFeatureCollection;
import org.geotools.data.simple.SimpleFeatureIterator;
import org.geotools.geometry.jts.ReferencedEnvelope;
import org.opengis.feature.simple.SimpleFeature;
import org.opengis.feature.type.AttributeDescriptor;
import org.opengis.feature.type.GeometryType;
import org.opengis.referencing.crs.CoordinateReferenceSystem;

/**
 * shape文件读取
 * @author ly
 *
 */
public class ShapeFileReaderTest {

    private static final String FILE_PATH = "F:\\data\\vector\\shape\\line\\xian_sheng.shp";

    public static void main(String[] args) {
        File file = new File(FILE_PATH);
        readShapeFile(file);
    }

    /**
     * 
     * @param shpFile  传递的是shape文件中的.shp文件
     */
    private static void readShapeFile(File shpFile) {
        /**
         * 直接使用shapefileDatastore,如果不知道，也可以使用工厂模式(见下个方法)
         * 建议，如果确定是shape文件，就直使用shapefileDatastore
         */
        try {
            ShapefileDataStore shapefileDataStore = new ShapefileDataStore(shpFile.toURI().toURL());
            //这个typeNamae不传递，默认是文件名称
            FeatureSource featuresource = shapefileDataStore.getFeatureSource(shapefileDataStore.getTypeNames()[0]);
            //读取bbox
            ReferencedEnvelope bbox  =featuresource.getBounds();
            //读取投影
            CoordinateReferenceSystem crs = featuresource.getSchema().getCoordinateReferenceSystem();
            //特征总数
            int count = featuresource.getCount(Query.ALL);
            //获取当前数据的geometry类型（点、线、面）
            GeometryType geometryType = featuresource.getSchema().getGeometryDescriptor().getType();
            //读取要素
            SimpleFeatureCollection simpleFeatureCollection = (SimpleFeatureCollection) featuresource.getFeatures();
            //获取当前矢量数据有哪些属性字段值
            List<AttributeDescriptor> attributes = simpleFeatureCollection.getSchema().getAttributeDescriptors();
            //
            SimpleFeatureIterator simpleFeatureIterator = simpleFeatureCollection.features();
            //
            while(simpleFeatureIterator.hasNext()) {
                SimpleFeature simpleFeature = simpleFeatureIterator.next();
                attributes.stream().forEach((a) -> {
                    //依次读取这个shape中每一个属性值，当然这个属性值，可以处理其它业务
                    System.out.println(simpleFeature.getAttribute(a.getLocalName()));
                });
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

    }

}
```

当然GeoTools对于shape数据的操作非常多，除了简单的读取，还有高级的过滤查询，当然这个就需要借助ECSQL(其实在我看来就是sql语句的条件查询，只是用一种标准把它定义了出来)，还有就是对矢量数据的增删改查。