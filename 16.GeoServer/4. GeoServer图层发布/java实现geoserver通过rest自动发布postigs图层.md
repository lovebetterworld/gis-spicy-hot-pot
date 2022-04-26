# Java实现geoserver通过rest自动发布postigs图层

geoserver自带rest服务，可以发布shp，postgis等数据源。本文目前只说明怎么通过geoserver的rest发布postgis表数据。

## 1、maven添加geoserver-manager的依赖。

```xml
   <dependencies>
        <dependency>
            <groupId>org.slf4j</groupId>
            <artifactId>jcl-over-slf4j</artifactId>
            <version>1.7.5</version>
        </dependency>
        <dependency>
            <groupId>org.slf4j</groupId>
            <artifactId>slf4j-api</artifactId>
            <version>1.7.5</version>
        </dependency>
        <dependency>
            <groupId>org.slf4j</groupId>
            <artifactId>slf4j-log4j12</artifactId>
            <version>1.7.5</version>
        </dependency>

        <dependency>
            <groupId>nl.pdok</groupId>
            <artifactId>geoserver-manager</artifactId>
            <version>1.7.0-pdok2</version>
        </dependency>
    </dependencies>

```

## 2、java代码

```java
import it.geosolutions.geoserver.rest.GeoServerRESTManager;
import it.geosolutions.geoserver.rest.GeoServerRESTPublisher;
import it.geosolutions.geoserver.rest.decoder.RESTDataStore;
import it.geosolutions.geoserver.rest.decoder.RESTLayer;
import it.geosolutions.geoserver.rest.encoder.GSLayerEncoder;
import it.geosolutions.geoserver.rest.encoder.datastore.GSPostGISDatastoreEncoder;
import it.geosolutions.geoserver.rest.encoder.feature.GSFeatureTypeEncoder;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.List;

public class Temp {
    public static void main(String[] args) throws MalformedURLException {
        //GeoServer的连接配置
        String url = "http://localhost:8080/geoserver" ;
        String username = "admin" ;
        String passwd = "geoserver" ;

        //postgis连接配置
        String postgisHost = "localhost" ;
        int postgisPort = 5432 ;
        String postgisUser = "postgres" ;
        String postgisPassword = "19920318" ;
        String postgisDatabase = "postgis_24_sample" ;

        String ws = "wzf" ;     //待创建和发布图层的工作区名称workspace
        String store_name = "wafangdianshi" ; //待创建和发布图层的数据存储名称store
        String table_name = "wafangdianshi" ; // 数据库要发布的表名称,后面图层名称和表名保持一致


        //判断工作区（workspace）是否存在，不存在则创建
        URL u = new URL(url);
        GeoServerRESTManager manager = new GeoServerRESTManager(u, username, passwd);
        GeoServerRESTPublisher publisher = manager.getPublisher() ;
        List<String> workspaces = manager.getReader().getWorkspaceNames();
        if(!workspaces.contains(ws)){
            boolean createws = publisher.createWorkspace(ws);
            System.out.println("create ws : " + createws);
        }else {
            System.out.println("workspace已经存在了,ws :" + ws);
        }


        //判断数据存储（datastore）是否已经存在，不存在则创建
        RESTDataStore restStore = manager.getReader().getDatastore(ws, store_name);
        if(restStore == null){
            GSPostGISDatastoreEncoder store = new GSPostGISDatastoreEncoder(store_name);
            store.setHost(postgisHost);//设置url
            store.setPort(postgisPort);//设置端口
            store.setUser(postgisUser);// 数据库的用户名
            store.setPassword(postgisPassword);// 数据库的密码
            store.setDatabase(postgisDatabase);// 那个数据库;
            store.setSchema("public"); //当前先默认使用public这个schema
            store.setConnectionTimeout(20);// 超时设置
            //store.setName(schema);
            store.setMaxConnections(20); // 最大连接数
            store.setMinConnections(1);     // 最小连接数
            store.setExposePrimaryKeys(true);
            boolean createStore = manager.getStoreManager().create(ws, store);
            System.out.println("create store : " + createStore);
        } else {
            System.out.println("数据存储已经存在了,store:" + store_name);
        }


        //判断图层是否已经存在，不存在则创建并发布
        RESTLayer layer = manager.getReader().getLayer(ws, table_name);
        if(layer == null){
            GSFeatureTypeEncoder pds = new GSFeatureTypeEncoder();
            pds.setTitle(table_name);
            pds.setName(table_name);
            pds.setSRS("EPSG:4326");
            GSLayerEncoder layerEncoder = new GSLayerEncoder();
            boolean publish = manager.getPublisher().publishDBLayer(ws, store_name,  pds, layerEncoder);
            System.out.println("publish : " + publish);
        }else {
            System.out.println("表已经发布过了,table:" + table_name);
        }
    }
}
```

