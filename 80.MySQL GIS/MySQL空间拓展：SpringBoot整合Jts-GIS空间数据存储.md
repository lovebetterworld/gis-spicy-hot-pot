- [MySQL空间拓展：SpringBoot整合Jts-GIS空间数据存储_似曾不相识的博客-CSDN博客_opengis](https://blog.csdn.net/weixin_43524214/article/details/124040605)

# 1. MySQL空间拓展

  遵从OpenGIS联盟（OGC）的规范，MySQL实施了空间扩展。
1997年，OpenGIS联盟（OGC）发布了针对SQL的OpenGIS简单特征规范，在该文档中，提出了拓展SQL RDBMS以支持空间数据的一些概念性方法。
  MySQL实施了OGC建议的具有Geometry类型的的SQL环境的一个子集，即：针对Geometry类型，MySQL提供了对应的字段类型支持，以及作用在这些类型上用于创建和分析几何值的函数

## 1.1 OpenGIS几何模型结构

  OpenGIS几何模型结构在MySQL中的实现与基本结构如下图所示。这是一张有意思的图，在后面可以根据这张图，来通过jts套件，实现一些更有意思的功能。
![在这里插入图片描述](https://img-blog.csdnimg.cn/36edbc26a10f4c009670c5367b52b717.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5Ly85pu-5LiN55u46K-G,size_20,color_FFFFFF,t_70,g_se,x_16)

## 1.2 MySQL的空间数据存储方式

  针对上述几何模型结构中定义的若干个空间数据类型，MySQL数据库是如何进行存储的呢？
![在这里插入图片描述](https://img-blog.csdnimg.cn/68e44022dfeb4f0ea1a91caefd9c2cc7.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5Ly85pu-5LiN55u46K-G,size_20,color_FFFFFF,t_70,g_se,x_16)
  MySQL数据库提供了与该模型相对应的——gemetry及其子类型的字段类型，以wkt的文本形式，来存储OpenGIS几何模型中定义的若干种数据类型。举一下几何对象WKT表示的示例：

```java
·         Point类型的  wkt表示：
·                POINT(15 20)

·         具有4个点的LineString  wkt表示：
·                LINESTRING(0 0, 10 10, 20 25, 50 60)

·         具有1个外部环和1个内部环的Polygon：
·         				 POLYGON((0 0,10 0,10 10,0 10,0 0),(5 5,7 5,7 7,5 7, 5 5))

·         具有三个Point值的MultiPoint：
·           			MULTIPOINT(0 0, 20 20, 60 60)

·         具有2个LineString值的MultiLineString：
·                MULTILINESTRING((10 10, 20 20), (15 15, 30 15))

·         具有2个Polygon值的MultiPolygon：
·                MULTIPOLYGON(((0 0,10 0,10 10,0 10,0 0)),((5 5,7 5,7 7,5 7, 5 5)))

·         由2个Point值和1个LineString构成的GeometryCollection：
·                GEOMETRYCOLLECTION(POINT(10 10), POINT(30 30), LINESTRING(15 15, 20 20))
```

  除了wkt，还有一种著名的二进制(WKB)格式可用于表示Geometry类型的数据，印象中PostGreSQL数据库的空间拓展模块PostGIS默认提供wkt格式来存储Geometry几何类型的空间数据。

## 1.3 MySQL的空间数据操作函数

  除了空间数据类型，MySQL还提供了空间数据的操作函数。可以参考[此处](https://www.mysqlzh.com/doc/177.html)。当然，对于一些空间索引和优化，MySQL也提供了相应的支持。

# 2. JTS Topology Suite-JTS

  既然MySQL数据库厂商对于OpenGIS标准的子集进行了实现，提供了空间数据的存储、查询、计算等功能，那么，不由得会去思考：有没有这样一种开发库，也针对OpenGIS标准的子集进行了实现，并提供了对象的类实现、空间运算功能的实现呢？
  答案是有的，这就是JTS（JTS Topology Suite）。

## 2.1 JTS与OpenGIS几何模型

  通过查看Jts中所定义的Geometry类的层次结构，可以发现，基本上是与MySQL中的实现是一一对应的，这就意味着，可以通过某种方式将两者结合起来，实现一些空间数据存储和查询的基本功能。
![在这里插入图片描述](https://img-blog.csdnimg.cn/544f52bc2ab24186b2c446bac4144b00.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5Ly85pu-5LiN55u46K-G,size_13,color_FFFFFF,t_70,g_se,x_16)

## 2.2 JTS与空间运算函数

  JTS除了对OpenGIS几何模型进行了实现，也提供了大量的空间运算函数，可以参考[官方文档](http://locationtech.github.io/jts/jts-features.html)。

# 3. SpringBoot整合Jts

  以下，将尝试在创建好的SpringBoot项目中，引入Jts开发包，并基于MySQL的geometry属性字段，完成数据值的自动映射、到数据查询结果的序列化操作，将其返回到前端浏览器显示。

## 3.1 Jts套件：引入依赖

```xml
<!--jts-->
<dependency>
    <groupId>org.locationtech.jts</groupId>
    <artifactId>jts-core</artifactId>
    <version>1.16.0</version>
</dependency>
```

## 3.2 Jts:GeometryJSON

  在前后端交互时，不得不思考这样的问题：如何实现GeoJson格式数据的反序列化/序列化操作？GeoJson数据和Geometry类型数据之间的关系是什么？
  第一个问题将在后面进行论述，对于第二个问题：jts套件中提供了GeometryJSON类，用于实现Geometry和GeoJSON数据之间的转换操作，源码中的解释如下，并给出了示例：

```c
GeoJSON：Reads and writes geometry objects to and from geojson.
   //示例：
	 Point point = new Point(1,2);
   GeometryJSON g = new GeometryJSON();
   g.writePoint(point, "point.json"));
   Point point2 = g.readPoint("point.json");
```

  这样，对于一个GeoJson格式的字符串，就可以借助GeometryJSON类，转换为Geometry类的对象。代码示例如下：

```java
  @Test
    public void cityService() throws IOException {
        String geojson = "{\"type\":\"Polygon\",\"coordinates\":[[[119.273071,33.093843],[119.273071,33.254767],[119.775696,33.254767],[119.775696,33.093843],[119.273071,33.093843]]]}";
        //GeometryJSON:Reads and writes geometry objects to and from geojson
        GeometryJSON geometryJSON = new GeometryJSON();
        Geometry geometry = geometryJSON.read(new StringReader(geojson));
        System.out.println(geometry.toString());

    }
```

  调用Geometry类的toString()方法，得到以下结果。这个结果的形式正好也是上面提供的——MYSQL所支持的wkt文本格式的geometry字段值的形式。
![在这里插入图片描述](https://img-blog.csdnimg.cn/0c661ac436304a62bd8ecfe35955a30e.png)  那么，在执行MySQL数据库——包含Geometry字段的记录插入时，就可以使用这个GeometryJSON工具类进行geojson字符串和Geometry类之间的转换。

# 4. [MyBatis](https://so.csdn.net/so/search?q=MyBatis&spm=1001.2101.3001.7020)-TypeHandler类型处理器定制

## 4.1 MyBatis：TypeHandler类型处理器

  MyBatis中虽然针对Java中的基本数据类型、集合等，提供了诸多TypeHandler类型处理器（如上图），但是，并没有提供对Jts套件的Geometry的类型处理支持，无法对MySQL的空间拓展geometry字段进行解析，将字段值自动映射到Geometry类型的属性上。因此，就需要通过继承BaseTypeHandler父类，来自定义类型处理器，完成MySQL的geometry字段到Jts的Geometry类类型字段的映射。
![在这里插入图片描述](https://img-blog.csdnimg.cn/786a299a783c42808e08ea09db44fc90.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5Ly85pu-5LiN55u46K-G,size_20,color_FFFFFF,t_70,g_se,x_16)

## 4.2 Geometry:TypeHandler定制类型转换器

  Geometry是Jts提供的一个抽象类，基于OpenGIS标准，提供了Point、LineString、Polygon、MultiPolygon等多个子类的实现。而预期目标是：通过整合MyBatis框架，将MySQL数据库中的Geometry字段类型，映射到Jts套件中的Geometry及其子类对象上，便于后续步骤的数据处理。

### 4.2.1 Geometry类-类型转换器AbstractGeometryTypeHandler

  核心思想：类型转换器涉及到两部分内容，
    ①向数据库写入数据时，如何将JavaType=Geometry转换为jdbcType=geometry，
    ②从数据库查出数据时，如何将jdbcType=geometry类型转换为JavaType=Geometry。
  对于问题①，注意到：在通过SQL语句向MySQL增加包含Geometry空间字段的记录时，SQL语句类似于这样：

```c
INSERT INTO city(cityid,cityname,geom,parantid,centerpoint)
VALUES('321300','宿迁市',ST_GeomFromGeoJSON('{
      "type": "MultiPolygon",
      "coordinates": [
          [
              [
                  [119.174931, 34.093494],
                  [119.166849, 34.10746],
                  [119.176166, 34.118579],
                 
  }'),'320000',ST_GeomFromText('POINT(118.275162 33.963008)'))
```

  那么，在添加数据时，只需要向SQL语句提供对应的字符串形式即可，
  对于问题②，注意到：从MySQL数据库中读取到的数据是以字符串/文本类型传递给Java应用程序的，

```cpp
package com.example.typehandler;

import org.apache.ibatis.type.*;
import org.geotools.geojson.geom.GeometryJSON;
import org.locationtech.jts.geom.Geometry;


import java.io.IOException;
import java.io.StringReader;
import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * @ClassName AbstractGeometryTypeHandler
 * @Description: com.example.typehandler_将字符串转换为JTS对应的Geometry几何类型
 * @Auther: xiwd
 * @version: 1.0
 */
//用户自定义TypeHandler的注解
//@Configuration
@MappedJdbcTypes({JdbcType.OTHER})
@MappedTypes(Geometry.class)
public class AbstractGeometryTypeHandler<T extends Geometry> extends BaseTypeHandler<Geometry> {
    //methods
    @Override
    public void setNonNullParameter(PreparedStatement ps, int i, Geometry parameter, JdbcType jdbcType) throws SQLException {
        System.out.println(jdbcType);
        ps.setObject(i,parameter);
    }

    @Override
    public Geometry getNullableResult(ResultSet rs, String columnName) throws SQLException {
        String srcSource = rs.getObject(columnName).toString();
//        System.out.println("111");
        GeometryJSON geometryJSON = new GeometryJSON();
        try {
            return geometryJSON.read(new StringReader(srcSource));
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public Geometry getNullableResult(ResultSet rs, int columnIndex) throws SQLException {
        String srcSource = rs.getObject(columnIndex).toString();
//        System.out.println("222");
        GeometryJSON geometryJSON = new GeometryJSON();
        try {
            return geometryJSON.read(new StringReader(srcSource));
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public Geometry getNullableResult(CallableStatement cs, int columnIndex) throws SQLException {
        String srcSource = cs.getObject(columnIndex).toString();
//        System.out.println("333");
        GeometryJSON geometryJSON = new GeometryJSON();
        try {
            return geometryJSON.read(new StringReader(srcSource));
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

}
```

### 4.2.2 Geometry子类-类型转换器XxxTypeHandler

Geometry的子类，例如：Point、LineString、Polygon、MultiPolygon等，可以通过继承AbstractGeometryTypeHandler类的方式，定制对应的类型转换器，例如：

```java
package com.example.typehandler;

import org.apache.ibatis.type.MappedTypes;
import org.locationtech.jts.geom.MultiPolygon;

/**
 * @ClassName MultiPolygonTypeHandler
 * @Description: com.example.config.typehandler
 * @Auther: xiwd
 * @version: 1.0
 */
@MappedTypes(MultiPolygon.class)
public class MultiPolygonTypeHandler extends AbstractGeometryTypeHandler<MultiPolygon> {
    //properties

    //methods
}
```

  其它子类也是如上所示。

### 4.2.3 自定义类型转换器的配置

  在SpringBoot项目的application.yml文件中添加type-handlers-package属性的配置：

```java
mybatis:
  mapper-locations: classpath:mapper/*.xml
  type-aliases-package: com.msb.pojo
  type-handlers-package: com.example.typehandler
```

## 4.3 Geometry:Mapper接口与xml配置文件的编写

  以City类为例（此处略过Service层的编写），

### 4.3.1 Pojo定义：City

  City类的geom和centerpoint字段类型，均属于Geometry的子类类型。

```java
package com.example.pojo;


import com.bedatadriven.jackson.datatype.jts.serialization.GeometryDeserializer;
import com.bedatadriven.jackson.datatype.jts.serialization.GeometrySerializer;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.locationtech.jts.geom.MultiPolygon;
import org.locationtech.jts.geom.Point;

import java.io.Serializable;

/**
 * @ClassName Tb_City
 * @Description: com.example.pojo
 * @Auther: xiwd
 * @version: 1.0
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class City implements Serializable {
    private static final long serialVersionUID = 7008471087772270587L;
    //properties
    private String cityid;
    private String cityname;
    @JsonSerialize(using = GeometrySerializer.class)
    @JsonDeserialize(contentUsing = GeometryDeserializer.class)
    private MultiPolygon geom;
    private String parentid;
    @JsonSerialize(using = GeometrySerializer.class)
    @JsonDeserialize(contentUsing = GeometryDeserializer.class)
    private Point centerpoint;

}
```

### 4.3.2 Mapper定义：CityMapper

  **【1】CityMapper接口定义**

```java
package com.example.mapper;
import com.example.pojo.City;

import java.util.List;

/**
 * @ClassName CityMapper
 * @Description: com.example.mapper
 * @Auther: xiwd
 * @version: 1.0
 */
public interface CityMapper {
    //methods

    /**
     * 查询所有City
     * @return
     */
    public abstract List<City> selectAll();
}
```

  **【2】CityMapper.xml配置文件编写**,此时，要注意的一点是：对于Geometry及其子类型的字段映射，需要为其添加TypeHandler类型处理器，即：上面我们已经定义完成的类型处理器，根据实际需要选择对应的类型即可。

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.example.mapper.CityMapper">

    <!-- 查询-->
    <sql id="selectAll_SQL">
        cityid,cityname,ST_ASGEOJSON(geom) as geom,parentid,ST_ASGEOJSON(centerpoint) as centerpoint
    </sql>
    <resultMap id="selectAll_Map" type="com.example.pojo.City">
        <id property="cityid" column="cityid"/>
        <result property="cityname" column="cityname"/>
        <result property="geom" column="geom" javaType="org.locationtech.jts.geom.MultiPolygon" typeHandler="com.example.typehandler.MultiPolygonTypeHandler"/>
        <result property="parentid" column="parentid"/>
        <result property="centerpoint" column="centerpoint" javaType="org.locationtech.jts.geom.Point" typeHandler="com.example.typehandler.PointTypeHandler"/>
    </resultMap>

    <select id="selectAll" resultType="com.example.pojo.City">
        SELECT <include refid="selectAll_SQL"></include> FROM `tb_city`
    </select>

</mapper>
```

### 4.3.3 Test单元测试:打印结果

  将通过调用Mapper接口，获取查询结果，将其打印，查看Geometry字段类型的数据值是否映射成功。
![在这里插入图片描述](https://img-blog.csdnimg.cn/a6d78e96d8ec4d3a9bfb72dff521107f.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5Ly85pu-5LiN55u46K-G,size_20,color_FFFFFF,t_70,g_se,x_16)  可以看到，Geometry类型的字段已经具有了属性值，那么，基于上述思路，完成了MySQL的geometry属性字段到Java的拓展开发包Geometry类型的属性值映射。

# 5 SpringMVC:Geometry的序列化&反序列化

  既然已经可以通过jts+自定义类型转换器获取到包含Geometry空间几何属性字段的结果列表，那么，能不能直接将其返回到前端浏览器进行解析呢？
  答案是：现在还不可以。因为：SpringMVC默认内置的JackSon工具，不支持Geometry及其子类的序列化操作。

## 5.1 SpringMVC集成JackSon序列化工具

  SpringMVC的默认支持使用JackSon来对@RequestBody中的内容进行反序列化、对@ResponseBody中的内容进行序列化操作。
  JackSon的依赖如下：

```xml
<!--jackson-->
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-core</artifactId>
</dependency>
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-annotations</artifactId>
</dependency>
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
</dependency>
```

   通常情况下，在创建一个SpringBoot项目之后，SpringBoot-web启动器默认为项目引入上述3个依赖包。例如下图：
![在这里插入图片描述](https://img-blog.csdnimg.cn/aaa1928fbc5a43de8b14d60703763d2c.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5Ly85pu-5LiN55u46K-G,size_16,color_FFFFFF,t_70,g_se,x_16)
   此时，很方便的可以基于注解@RequestBody、@ResponseBody进行自定义数据类型的反序列化和序列化操作。常见操作可以参考：《[JackSon常用操作](https://zhuanlan.zhihu.com/p/150106508?from_voters_page=true)》。

## 5.2 SpringMVC:Jackson工具拓展

  通常情况下，Jackson内置的序列化和反序列化方法是能够满足开发需求的，但是，也有一些特殊情况，例如：在使用jts的org.locationtech.jts.geom下的Geometry及其子类Point等，JackSon无法自动完成Geometry的序列化/反序列化操作。
  此时，有两种解决方案：
    【1】拓展Jackson，通过继承StdSerializer、StdDeserializer，针对要处理的类型自定义序列化/反序列化类；
    【2】集成第三方开发库，例如：针对jts的org.locationtech.jts.geom下的Geometry及其子类Point等的序列化/反序列化操作，可以引入jackson-datatype-jts——JTS数据绑定包的方式，来实现操作。

### 5.2.1 SpringMVC:自定义JackSon拓展类实现Geometry序列化

  可以参考：[自定义JackSon拓展类](https://cloud.tencent.com/developer/ask/sof/372723)。

### 5.2.2 SpringMVC:集成jackson-datatype-jts实现Geometry序列化

  【1】引入jackson-datatype-jts依赖，

```xml
<!-- https://mvnrepository.com/artifact/com.graphhopper.external/jackson-datatype-jts -->
<dependency>
    <groupId>com.graphhopper.external</groupId>
    <artifactId>jackson-datatype-jts</artifactId>
    <version>1.0-2.7</version>
</dependency>
```

  【2】配置SpringMVC，注册JtsModule模块，

```c
package com.example.config;

import com.bedatadriven.jackson.datatype.jts.JtsModule;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.converter.*;
import org.springframework.http.converter.json.Jackson2ObjectMapperBuilder;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.http.converter.support.AllEncompassingFormHttpMessageConverter;
import org.springframework.http.converter.xml.Jaxb2RootElementHttpMessageConverter;
import org.springframework.http.converter.xml.SourceHttpMessageConverter;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.util.List;

/**
 * @ClassName CorsConfig
 * @Description: com.example.config
 * @Auther: xiwd
 * @version: 1.0
 */
@Configuration
@EnableWebMvc
public class AppWebMvcConfigurer implements WebMvcConfigurer {
    //properties

    //methods
    @Override
    public void configureMessageConverters(List<HttpMessageConverter<?>> converters) {
        //初始化MappingJackson2HttpMessageConverter，注册自定义模块
        Jackson2ObjectMapperBuilder builder = new Jackson2ObjectMapperBuilder().modules(new JtsModule());
        MappingJackson2HttpMessageConverter mappingJackson2HttpMessageConverter = new MappingJackson2HttpMessageConverter(builder.build());

        ByteArrayHttpMessageConverter byteArrayHttpMessageConverter = new ByteArrayHttpMessageConverter();
        StringHttpMessageConverter stringHttpMessageConverter = new StringHttpMessageConverter();
        ResourceHttpMessageConverter resourceHttpMessageConverter = new ResourceHttpMessageConverter();
        ResourceRegionHttpMessageConverter resourceRegionHttpMessageConverter = new ResourceRegionHttpMessageConverter();
        SourceHttpMessageConverter sourceHttpMessageConverter = new SourceHttpMessageConverter();
        AllEncompassingFormHttpMessageConverter allEncompassingFormHttpMessageConverter = new AllEncompassingFormHttpMessageConverter();
        Jaxb2RootElementHttpMessageConverter jaxb2RootElementHttpMessageConverter = new Jaxb2RootElementHttpMessageConverter();

        //转换器，根据实际情况添加或减少
        //此处的mappingJackson2HttpMessageConverter就是我们自定义的转换器，其实核心就是
        //初始化的时候注册了JtsModule，支持Geometry的序列化
        converters.add(mappingJackson2HttpMessageConverter);
        converters.add(stringHttpMessageConverter);
        converters.add(resourceHttpMessageConverter);
        converters.add(byteArrayHttpMessageConverter);
        converters.add(resourceRegionHttpMessageConverter);
        converters.add(sourceHttpMessageConverter);
        converters.add(allEncompassingFormHttpMessageConverter);
        converters.add(jaxb2RootElementHttpMessageConverter);
    }

}
```

  【3】为Geometry类型的属性添加序列化/反序列化注解，
例如，现在定义了一个City的类，里面包含Geometry字段，现在为其添加@JsonSerialize、@JsonDeserialize反序列化注解。

```c
package com.example.pojo;


import com.bedatadriven.jackson.datatype.jts.serialization.GeometryDeserializer;
import com.bedatadriven.jackson.datatype.jts.serialization.GeometrySerializer;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.locationtech.jts.geom.MultiPolygon;
import org.locationtech.jts.geom.Point;

import java.io.Serializable;

/**
 * @ClassName Tb_City
 * @Description: com.example.pojo
 * @Auther: xiwd
 * @version: 1.0
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class City implements Serializable {
    private static final long serialVersionUID = 7008471087772270587L;
    //properties
    private String cityid;
    private String cityname;
    @JsonSerialize(using = GeometrySerializer.class)
    @JsonDeserialize(contentUsing = GeometryDeserializer.class)
    private MultiPolygon geom;
    private String parentid;
    @JsonSerialize(using = GeometrySerializer.class)
    @JsonDeserialize(contentUsing = GeometryDeserializer.class)
    private Point centerpoint;
}

```

  【4】正常编写Controller，将其返回即可。

```java
    /**
     * 获取所有city
     * @return
     */
    @RequestMapping(value = "/GET/all")
    @ResponseBody
    public List<City> getAll(){
        Map<String,Object> map = new HashMap<>();
        return cityService.selectAll();
    }
```

  【5】返回结果如下，数据太多，仅截取一小部分。
![在这里插入图片描述](https://img-blog.csdnimg.cn/17e09ac221bc420d93b297d1b3087716.png)
  如此，基于上述思路，就实现了MySQL的geometry属性字段到Jts套件中Geometry及其子类的属性值映射，已经结果列表的序列化操作。