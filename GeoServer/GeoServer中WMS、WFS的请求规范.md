- [GeoServer中WMS、WFS的请求规范](https://www.cnblogs.com/naaoveGIS/p/5508882.html)

# 1.背景

## 1.1 WMS简介

Web地图服务（WMS）利用具有地理空间位置信息的数据制作地图。其中将地图定义为地理数据可视的表现。这个规范定义了三个操作：GetCapabitities返回服务级元数据，它是对服务信息内容和要求参数的一种描述；  GetMap返回一个地图影像，其地理空间参考和大小参数是明确定义了的；GetFeatureInfo（可选）返回显示在地图上的某些特殊要素的信息。

GeoServer官网上对其WMS规范的描述地址为http://docs.geoserver.org/stable/en/user/services/wms/index.html。

## 1.2 WFS简介

Web要素服务（WFS）返回的是要素级的GML编码，并提供对要素的增加、修改、删除等事务操作，是对Web地图服务的进一步深入。OGC  Web要素服务允许客户端从多个Web要素服务中取得使用地理标记语言（GML）编码的地理空间数据，这个远东定义了五个操作：GetCapabilites返回Web要素服务性能描述文档（用XML描述）；DescribeFeatureType返回描述可以提供服务的任何要素结构的XML文档；GetFeature为一个获取要素实例的请求提供服务；Transaction为事务请求提供服务；LockFeature处理在一个事务期间对一个或多个要素类型实例上锁的请求。

GeoServer官网上对其WFS规范的描述地址为http://docs.geoserver.org/stable/en/user/services/wfs/index.html。

# 2.WMS请求规范详解

## 2.1 GetCapabitities（返回服务级元数据）

URL例子：

http://localhost:8680/geoserver/wms?service=wms&version=1.1.1&request=GetCapabilities。

参数意义：

 ![img](https://images2015.cnblogs.com/blog/656746/201605/656746-20160519152704935-1662891757.png)            

返回结果：

其返回结果为一个描述性XML文档，包含了以下三个要素：

![img](https://images2015.cnblogs.com/blog/656746/201605/656746-20160519152720201-661772758.png) 

## 2.2 GetMap（获取影像）

URL例子：

http://localhost:8680/geoserver/urbanlayer/wms?LAYERS=urbanlayer%3ADIJI&STYLES=&FORMAT=image%2Fpng&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&SRS=EPSG%3A3857&BBOX=10008053.503544,5274522.8578226,10039584.01305,5292493.614536&WIDTH=579&HEIGHT=330。

参数意义：

![img](https://images2015.cnblogs.com/blog/656746/201605/656746-20160519152737732-251384701.png) 

这里对返回的格式（format）有如下选择：

 ![img](https://images2015.cnblogs.com/blog/656746/201605/656746-20160519152756138-1587832693.png)

返回结果：

 ![img](https://images2015.cnblogs.com/blog/656746/201605/656746-20160519152809779-884812518.png)

注意：此请求同样支持XML格式请求，如下：

 ![img](https://images2015.cnblogs.com/blog/656746/201605/656746-20160519152824919-1363800780.png)

## 2.3 GetFeatureInfo（返回要素信息）

URL例子：

[http://localhost:8680/geoserver/urbanlayer/wms?REQUEST=GetFeatureInfo&EXCEPTIONS=application%2Fvnd.ogc.se_xml&BBOX=10008053.503544%2C5274522.857823%2C10039584.01305%2C5292493.614536&SERVICE=WMS&INFO_FORMAT=text/plain&QUERY_LAYERS=urbanlayer%3ADIJI&FEATURE_COUNT=50&Layers=urbanlayer%3ADIJI&WIDTH=579&HEIGHT=330&format=image%2Fpng&styles=&srs=EPSG%3A3857&version=1.1.1&x=315&y=147](http://localhost:8680/geoserver/urbanlayer/wms?REQUEST=GetFeatureInfo&EXCEPTIONS=application%2Fvnd.ogc.se_xml&BBOX=10008053.503544%2C5274522.857823%2C10039584.01305%2C5292493.614536&SERVICE=WMS&INFO_FORMAT=application/json&QUERY_LAYERS=urbanlayer%3ADIJI&FEATURE_COUNT=50&Layers=urbanlayer%3ADIJI&WIDTH=579&HEIGHT=330&format=image%2Fpng&styles=&srs=EPSG%3A3857&version=1.1.1&x=315&y=147)。

参数意义：

 ![img](https://images2015.cnblogs.com/blog/656746/201605/656746-20160519152838669-1939956498.png)

 这里对返回的文本格式（info_format）有如下选择：

 ![img](https://images2015.cnblogs.com/blog/656746/201605/656746-20160519152857951-734944933.png)

返回结果(忽略中文乱码)：

 ![img](https://images2015.cnblogs.com/blog/656746/201605/656746-20160519152914951-958671769.png) 

 

# 3.WFS请求规范

## 3.1 GetCapabilities(返回服务描述文档)

URL例子：

http://localhost:8680/geoserver/wfs?service=wfs&version=1.1.0&request=GetCapabilities。

参数意义：

 ![img](https://images2015.cnblogs.com/blog/656746/201605/656746-20160519152935857-274324739.png)

返回结果：

返回的结果为描述性XML，包含以下五个主要部分：

 ![img](https://images2015.cnblogs.com/blog/656746/201605/656746-20160519152952560-80750426.png)

## 3.2 DescribeFeatureType（返回图层描述信息）

URL例子：

http://localhost:8680/geoserver/urbanlayer/ows?service=wfs&version=1.0.0&request=DescribeFeatureType&typeName=DIJI。

参数意义：

 ![img](https://images2015.cnblogs.com/blog/656746/201605/656746-20160519153012576-1969976173.png)

 返回结果：

 ![img](https://images2015.cnblogs.com/blog/656746/201605/656746-20160519153028607-1181442872.png)

## 3.3 GetFeature（获取图层要素）

### 3.3.1 GET查询

这里首先给出一个例子：

 ![img](https://images2015.cnblogs.com/blog/656746/201605/656746-20160519153048201-1636992940.png)

[http://localhost:8080/eGovaGISV14//home/gis/proxy.htm?http://192.168.101.14/geoserver/urbanlayer/wfs?request=GetFeature&version=1.1.0&typename=jianfudanhistory&Filter=%3CFilter%20xmlns:ogc=%22http://www.opengis.net/ogc%22%20xmlns:gml=%22http://www.opengis.net/gml%22%3E%3CIntersects%3E%20%3CPropertyName%3Ethe_geom%3C/PropertyName%3E%20%3Cgml:Envelope%20srsName=%22EPSG:4326%22%3E%09%20%3Cgml:lowerCorner%3E120.1762573834964%2030.280899047851562%3C/gml:lowerCorner%3E%20%09%20%3Cgml:upperCorner%3E120.18999029365265%2030.294631958007812%3C/gml:upperCorner%3E%20%3C/gml:Envelope%3E%3C/Intersects%3E%3C/Filter%3E&outputformat=json](http://localhost:8080/eGovaGISV14/home/gis/proxy.htm?http://192.168.101.14/geoserver/urbanlayer/wfs?request=GetFeature&version=1.1.0&typename=jianfudanhistory&Filter= the_geom 	 120.1762573834964 30.280899047851562 	 120.18999029365265 30.294631958007812 &outputformat=json)。

此请求常见的参数有：typeNames,featureID,propertyName,Filter, count, sortBy。其中Filter参数最为重要，主要负责进行选择过滤。关于Filter的具体描述可参考：http://docs.geoserver.org/stable/en/user/filter/function.html。

 返回结果为：

```json
{
    "type": "FeatureCollection",
    "features": [
        {
            "type": "Feature",
            "id": "jianfudan.322",
            "geometry": {
                "type": "MultiPolygon",
                "coordinates": [
                    [
                        [
                            [
                                30.276436000822056,
                                120.20021
                            ],
                            [
                                30.275750000822033,
                                120.20021
                            ],
                            [
                                30.22768400082126,
                                120.22562
                            ],
                            [
                                30.245537000821543,
                                120.17343000000001
                            ],
                            [
                                30.276436000822056,
                                120.20021
                            ]
                        ]
                    ]
                ]
            },
            "geometry_name": "the_geom",
            "properties": {
                "limitid": 71,
                "displayorder": null,
                "regionid": 3,
                "validfromdate": "2016-05-15Z",
                "validtodate": "2016-06-14Z",
                "validflag": 1,
                "media": null,
                "shape_length": null,
                "shape_area": null,
                "graphicid": 322,
                "regionname": "江干区",
                "eventtypes": null,
                "otherrequest": null,
                "limitname": "上报区域71"
            }
        },
        {
            "type": "Feature",
            "id": "jianfudan.318",
            "geometry": {
                "type": "MultiPolygon",
                "coordinates": [
                    [
                        [
                            [
                                30.26407600082185,
                                120.19668600000001
                            ],
                            [
                                30.26407600082185,
                                120.196434
                            ],
                            [
                                30.262875000821833,
                                120.20785
                            ],
                            [
                                30.24708200082157,
                                120.203896
                            ],
                            [
                                30.255150000821704,
                                120.187164
                            ],
                            [
                                30.26407600082185,
                                120.19668600000001
                            ]
                        ]
                    ]
                ]
            },
            "geometry_name": "the_geom",
            "properties": {
                "limitid": 72,
                "displayorder": null,
                "regionid": 3,
                "validfromdate": "2016-05-04Z",
                "validtodate": "2016-06-03Z",
                "validflag": 1,
                "media": "http://172.18.6.197:8081/MediaRoot/null/20160505/72/84989ee1-9bab-4640-8f24-4a7381f1c4e8/机票预订.png",
                "shape_length": null,
                "shape_area": null,
                "graphicid": 318,
                "regionname": "江干区",
                "eventtypes": "乱搭乱建,暴露垃圾,积存垃圾渣土,路面不洁,河道不洁(含沟渠、湖面)",
                "otherrequest": "测试",
                "limitname": "上报区域72"
            }
        }
    ],
    "crs": {
        "type": "EPSG",
        "properties": {
            "code": "4490"
        }
    }
}
```

#### 3.3.1.1点查询Filter

```xml
<Filter xmlns:ogc="http://www.opengis.net/ogc" xmlns:gml="http://www.opengis.net/gml">
    <Intersects>
        <PropertyName>the_geom</PropertyName>
            <gml:Envelope srsName="EPSG:4326">   
                <gml:lowerCorner>120.15336460382575 30.2743621901609</gml:lowerCorner>
                <gml:upperCorner>120.167097513982 30.28809510031715</gml:upperCorner>
            </gml:Envelope>
    </Intersects>
</Filter>
```

#### 3.3.1.2自定义多边形查询Filter

```xml
<Filter xmlns:ogc="http://www.opengis.net/ogc" xmlns:gml="http://www.opengis.net/gml">
    <Intersects> 
        <PropertyName>the_geom</PropertyName>
        <gml:MultiPolygon srsName="EPSG:4326"> 
            <gml:polygonMember> 
                <gml:Polygon> 
                    <gml:outerBoundaryIs> 
                        <gml:LinearRing>
                            <gml:coordinates xmlns:gml="http://www.opengis.net/gml" decimal="." cs="," ts="">
                            120.15677,30.2557 120.15677,30.26351 120.16833,30.26351 120.16833,30.2557 120.15677,30.2557
                            </gml:coordinates> 
                        </gml:LinearRing> 
                    </gml:outerBoundaryIs> 
                </gml:Polygon> 
            </gml:polygonMember> 
        </gml:MultiPolygon>
    </Intersects>
</Filter>
```

### 3.3.2 Post查询

因为GET请求的数据量大小在4kb以内，所以Post为更常用的方法。以下为一个具体的例子：

![img](https://images2015.cnblogs.com/blog/656746/201605/656746-20160519153112701-1878646546.png) 

其中直接发送的为一个XML文件，其Filter中可以填写的内容和GET中的Filter一样。

具体内容如下：

```xml
<?xml version='1.0' encoding='GBK'?><wfs:GetFeature service='WFS' version='1.0.0' outputFormat='JSON'
xmlns:wfs='http://www.opengis.net/wfs'
xmlns:ogc='http://www.opengis.net/ogc'
xmlns:gml='http://www.opengis.net/gml'  xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'  xsi:schemaLocation='http://www.opengis.net/wfs http://schemas.opengis.net/wfs/1.0.0/WFS-basic.xsd'>
    <wfs:Query typeName='cell'>
        <wfs:PropertyName>the_geom</wfs:PropertyName>
        <wfs:PropertyName>test1</wfs:PropertyName>
            <ogc:Filter>
                <Or>
                    <PropertyIsEqualTo><PropertyName>test1</PropertyName><Literal>valuetest1</Literal></PropertyIsEqualTo>
                    <PropertyIsEqualTo><PropertyName>test2</PropertyName><Literal>valuetest2</Literal></PropertyIsEqualTo>
                </Or>
            </ogc:Filter>
    </wfs:Query>
</wfs:GetFeature>
```

## 3.4 Transaction（编辑要素）

该方法支持对要素的增删改。这里直接给出Post请求中发送的XML组织格式：

### 3.4.1添加要素

```xml
<wfs:Transaction service="WFS" version="1.0.0"  
    outputFormat="GML2"  
    xmlns:opengis="[http://www.cetusOpengis.com](http://www.cetusopengis.com/)" 
     xmlns:wfs="http://www.opengis.net/wfs" 
     xmlns:ogc="http://www.opengis.net/ogc" 
     xmlns:gml="http://www.opengis.net/gml" 
     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
     xsi:schemaLocation="http://www.opengis.net/wfs  http://schemas.opengis.net/wfs/1.0.0/WFS-basic.xsd">  
    <wfs:Insert handle="someprj1">
        <opengis:someprj>
            <opengis:the_geom>
                <gml:Point srsName="http://www.opengis.net/gml/srs/epsg.xml#3395" >
                    <gml:coordinates decimal="." cs="," ts="">13404701.212,3850391.781</gml:coordinates> 
                </gml:Point>
            </opengis:the_geom>
            <opengis:ssds>13</opengis:ssds>
            <opengis:qqybh>12</opengis:qqybh>
            <opengis:status>0</opengis:status>
        </opengis:someprj>
    </wfs:Insert>  
</wfs:Transaction>
```

### 3.4.2修改要素

```xml
<wfs:Transaction service="WFS" version="1.0.0"  
    outputFormat="GML2"  
    xmlns:opengis="[http://www.cetusOpengis.com](http://www.cetusopengis.com/)" 
     xmlns:wfs="http://www.opengis.net/wfs" 
     xmlns:ogc="http://www.opengis.net/ogc" 
     xmlns:gml="http://www.opengis.net/gml" 
     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
     xsi:schemaLocation="http://www.opengis.net/wfs  http://schemas.opengis.net/wfs/1.0.0/WFS-basic.xsd">  
    <wfs:Update typeName="opengis:qqyproject"> 
        <wfs:Property> 
            <wfs:Name>qqybh</wfs:Name>
            <wfs:Value>12</wfs:Value>
        </wfs:Property>
        <ogc:Filter>  
            <ogc:PropertyIsEqualTo>
                <ogc:PropertyName>qqybh</ogc:PropertyName>
                <ogc:Literal>0</ogc:Literal>
            </ogc:PropertyIsEqualTo> 
        </ogc:Filter>  
    </wfs:Update>  
</wfs:Transaction>
```

### 3.4.3 删除要素

```xml
<wfs:Transaction service="WFS" version="1.0.0"  
    outputFormat="GML2"  
    xmlns:opengis="[http://www.cetusOpengis.com](http://www.cetusopengis.com/)" 
     xmlns:wfs="http://www.opengis.net/wfs" 
     xmlns:ogc="http://www.opengis.net/ogc" 
     xmlns:gml="http://www.opengis.net/gml" 
     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
     xsi:schemaLocation="http://www.opengis.net/wfs  http://schemas.opengis.net/wfs/1.0.0/WFS-basic.xsd">  
    <wfs:Delete typeName="opengis:qqyproject"> 
        <ogc:Filter>  
            <ogc:PropertyIsLessThan>
                <ogc:PropertyName>qqybh</ogc:PropertyName>
                <ogc:Literal>12</ogc:Literal>
            </ogc:PropertyIsLessThan> 
            <ogc:PropertyIsGreaterThan>
                <ogc:PropertyName>qqybh</ogc:PropertyName>
                <ogc:Literal>0</ogc:Literal>
            </ogc:PropertyIsGreaterThan> 
        </ogc:Filter>  
    </wfs:Delete>  
</wfs:Transaction>
```

## 4.总结

a.动态出图可以使用WMS中的GetMap请求。

b.矢量查询可以使用WFS中的GetFeature请求。

c.要素编辑可以使用WFS中的Transaction请求。