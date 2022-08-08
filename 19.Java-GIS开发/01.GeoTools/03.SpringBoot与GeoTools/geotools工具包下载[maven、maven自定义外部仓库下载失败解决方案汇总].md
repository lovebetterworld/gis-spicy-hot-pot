- [geotools工具包下载[maven、maven自定义外部仓库下载失败解决方案汇总\]_Dongzfdb的博客-CSDN博客_geotools下载](https://blog.csdn.net/qq_37306786/article/details/113933062)

## 导入geotools步骤：

**1. 参考官方文档的maven导入指南\***【重要,请随时参考官网的地址更新，以官网为准】

geotools官网文档地址：[Maven Quickstart — GeoTools 27-SNAPSHOT User Guide](http://docs.geotools.org/latest/userguide/tutorial/quickstart/maven.html)

项目的pom.xml的核心导包配置如下：

```xml
<properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <geotools.version>25-SNAPSHOT</geotools.version>
</properties>
 
<dependencies>
    <dependency>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
        <version>4.13.1</version>
        <scope>test</scope>
    </dependency>
    <dependency>
        <groupId>org.geotools</groupId>
        <artifactId>gt-shapefile</artifactId>
        <version>${geotools.version}</version>
    </dependency>
    <dependency>
        <groupId>org.geotools</groupId>
        <artifactId>gt-swing</artifactId>
        <version>${geotools.version}</version>
    </dependency>
</dependencies>
 
<repositories>
    <repository>
      <id>osgeo</id>
      <name>OSGeo Release Repository</name>
      <url>https://repo.osgeo.org/repository/release/</url>
      <snapshots><enabled>false</enabled></snapshots>
      <releases><enabled>true</enabled></releases>
    </repository>
    <repository>
      <id>osgeo-snapshot</id>
      <name>OSGeo Snapshot Repository</name>
      <url>https://repo.osgeo.org/repository/snapshot/</url>
      <snapshots><enabled>true</enabled></snapshots>
      <releases><enabled>false</enabled></releases>
    </repository>
    <!--GeoServer-->
     <repository>
       <id>GeoSolutions</id>
       <url>http://maven.geo-solutions.it/</url>
     </repository>
     
</repositories>
```

2. **请检查maven的setting.xml是否配置了全局仓库\***【重要，目的是检查项目的repositories是否生效】,

如果配置了，请将**步骤一**中的仓库id加入到setting.xml中排除，以使得项目的pom.xml的repositories生效，该方法适用于其他maven项目仓库不生效的情况。

具体maven的setting.xml配置参考如下：

```xml
<?xml version="1.0" encoding="UTF-8"?>
 
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">
<localRepository>D:\Repository</localRepository>
  <mirrors>
    <mirror>
	    <id>nexus-aliyun</id>
	    <mirrorOf>*,!osgeo,!GeoSolutions,!osgeo-snapshot,!alfresco</mirrorOf>
	    <name>Nexus aliyun</name>
	    <url>http://maven.aliyun.com/nexus/content/groups/public</url>
	</mirror>
  </mirrors>
 
  <profiles>
  	<profile>  
	  	<id>jdk-1.8</id>  
	   	<activation>  
	     	<activeByDefault>true</activeByDefault>  
	     	<jdk>1.8</jdk>  
	   	</activation>  
		<properties>  
			<maven.compiler.source>1.8</maven.compiler.source>  
			<maven.compiler.target>1.8</maven.compiler.target>  
			<maven.compiler.compilerVersion>1.8</maven.compiler.compilerVersion>  
		</properties>
	</profile>
  </profiles>
 
</settings>
```

核心配置在mirror标签的mirrorOf子标签中，标签值为：***\**,!osgeo,!GeoSolutions,!osgeo-snapshot,!alfresco\****

***\*意思是后面几个仓库不走阿里云镜像仓库，优先使用默认项目配置的仓库\****