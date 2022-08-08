- [GeoTools：WKT、GeoJson、Feature、FeatureCollection相互转换_一个不称职的程序猿的博客-CSDN博客_featurejson](https://blog.csdn.net/qq_39035773/article/details/121122915)

# 测试用例：

```java
package top.reid.smart.geo;
 
import cn.hutool.core.util.ArrayUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.json.JSONArray;
import cn.hutool.json.JSONObject;
import cn.hutool.json.JSONUtil;
import org.geotools.data.DataUtilities;
import org.geotools.data.collection.ListFeatureCollection;
import org.geotools.data.simple.SimpleFeatureCollection;
import org.geotools.feature.simple.SimpleFeatureBuilder;
import org.geotools.geojson.GeoJSONUtil;
import org.geotools.geojson.feature.FeatureJSON;
import org.geotools.geojson.geom.GeometryJSON;
import org.locationtech.jts.geom.Geometry;
import org.locationtech.jts.geom.GeometryCollection;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.io.WKTReader;
import org.opengis.feature.simple.SimpleFeature;
import org.opengis.feature.simple.SimpleFeatureType;
 
import java.io.IOException;
import java.io.Reader;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.List;
 
/**
 * <p>
 * 地质工具
 * </p>
 *
 * @Author REID
 * @Blog https://blog.csdn.net/qq_39035773
 * @GitHub https://github.com/BeginnerA
 * @Data 2020/11/11
 * @Version V1.0
 **/
public class GeoTools {
 
    private static final WKTReader READER = new WKTReader();
 
    /**
     * 要素集合根节点
     */
    private static final String[] COLLECTION_TYPE = new String[]{"FeatureCollection"};
 
    /**
     * 地理要素类型
     */
    private static final String[] FEATURES_TYPE = new String[]{"Feature"};
 
    /**
     * 地理数据类型
     * 点、线、面、几何集合
     */
    private static final String[] GEO_TYPE = new String[]{"Geometry", "Point", "LineString", "Polygon", "MultiPoint", "MultiLineString", "MultiPolygon", "GeometryCollection"};
 
    /**
     * 获取 Geo 几何类型
     * @param wktStr WKT 字符串
     * @return Geo 几何类型
     */
    public static String getGeometryType(String wktStr) {
        String type = null;
        if (StrUtil.isNotEmpty(wktStr)) {
            try {
                Geometry read = READER.read(wktStr);
                type = read.getGeometryType();
            }catch (Exception e) {
                System.out.println("非规范 WKT 字符串："+ e);
                e.printStackTrace();
            }
        }
        return type;
    }
 
    /**
     * 是规范的 WKT
     * @param wktStr WKT 字符串
     * @return 是、否
     */
    public static boolean isWkt(String wktStr) {
        for (String s : GEO_TYPE) {
            if (wktStr.toLowerCase().startsWith(s.toLowerCase())) {
                return true;
            }
        }
        return false;
    }
 
    /**
     * 不是规范的 WKT
     * @param wktStr WKT 字符串
     * @return 是、否
     */
    public static boolean isNotWkt(String wktStr) {
        return !isWkt(wktStr);
    }
 
    /**
     * 是规范的 GeoJson
     * @param geoJsonStr GeoJson 字符串
     * @return 是、否
     */
    public static boolean isGeoJson(String geoJsonStr) {
        try {
            JSONObject jsonObject = JSONUtil.parseObj(geoJsonStr);
            return isGeoJson(jsonObject);
        }catch (Exception e) {
            return false;
        }
    }
 
    /**
     * 不是规范的 GeoJson
     * @param geoJsonStr GeoJson 字符串
     * @return 是、否
     */
    public static boolean isNotGeoJson(String geoJsonStr) {
        return !isGeoJson(geoJsonStr);
    }
 
    /**
     * 是规范的 GeoJson
     * @param geoJson GeoJson 对象
     * @return 是、否
     */
    public static boolean isGeoJson(JSONObject geoJson) {
        String type = geoJson.getStr("type");
        boolean mark = false;
        // 判断根节点
        if (ArrayUtil.containsIgnoreCase(COLLECTION_TYPE, type)) {
            JSONArray jsonArray = geoJson.get("features", JSONArray.class);
            for (Object jsonStr : jsonArray) {
                JSONObject jsonObject = JSONUtil.parseObj(jsonStr);
                type = jsonObject.getStr("type");
                // 判断地理要素
                if (ArrayUtil.containsIgnoreCase(FEATURES_TYPE, type)) {
                    type = jsonObject.get("geometry", JSONObject.class).getStr("type");
                    // 判断几何要素
                    mark = ArrayUtil.containsIgnoreCase(GEO_TYPE, type);
                }
                if (!mark) {
                    return false;
                }
            }
        }else {
            // 判断地理要素
            if (ArrayUtil.containsIgnoreCase(FEATURES_TYPE, type)) {
                type = geoJson.get("geometry", JSONObject.class).getStr("type");
            }
            // 数据是几何数据
            mark = ArrayUtil.containsIgnoreCase(GEO_TYPE, type);
        }
        return mark;
    }
 
    /**
     * 不是规范的 GeoJson
     * @param geoJson GeoJson 对象
     * @return 是、否
     */
    public static boolean isNotGeoJson(JSONObject geoJson) {
        return !isGeoJson(geoJson);
    }
 
    /**
     * GeoJson 转 WKT
     * @param geoJson GeoJson 对象
     * @return WKT 字符串
     */
    public static String geoJsonToWkt(JSONObject geoJson) {
        String wkt = null;
        GeometryJSON gJson = new GeometryJSON();
        try {
            if(isGeoJson(geoJson)){
                String type = geoJson.getStr("type");
                // 判断是否根节点
                if (ArrayUtil.containsIgnoreCase(COLLECTION_TYPE, type)) {
                    JSONArray geometriesArray = geoJson.get("features", JSONArray.class);
                    // 定义一个数组装图形对象
                    int size = geometriesArray.size();
                    Geometry[] geometries = new Geometry[size];
                    for (int i = 0; i < size; i++){
                        String str = JSONUtil.parseObj(geometriesArray.get(i)).getStr("geometry");
                        // 使用 GeoUtil 去读取 str
                        Reader reader = GeoJSONUtil.toReader(str);
                        Geometry geometry = gJson.read(reader);
                        geometries[i] = geometry;
                    }
                    GeometryCollection geometryCollection = new GeometryCollection(geometries, new GeometryFactory());
                    wkt = geometryCollection.toText();
                }else {
                    String geoStr = geoJson.toString();
                    // 判断是否地理要素节点
                    if (ArrayUtil.containsIgnoreCase(FEATURES_TYPE, type)) {
                        geoStr = geoJson.getStr("geometry");
                    }
                    Reader reader = GeoJSONUtil.toReader(geoStr);
                    Geometry read = gJson.read(reader);
                    wkt = read.toText();
                }
            }
        } catch (IOException e){
            System.out.println("GeoJson 转 WKT 出现异常："+ e);
            e.printStackTrace();
        }
        return wkt;
    }
 
    /**
     * WKT 转 GeoJson
     * @param wktStr WKT 字符串
     * @return GeoJson 对象
     */
    public static JSONObject wktToGeoJson(String wktStr) {
        JSONObject jsonObject = new JSONObject();
        try {
            Geometry geometry = READER.read(wktStr);
            StringWriter writer = new StringWriter();
            GeometryJSON geometryJson = new GeometryJSON();
            geometryJson.write(geometry, writer);
            jsonObject = JSONUtil.parseObj(writer.toString());
        } catch (Exception e) {
            System.out.println("WKT 转 GeoJson 出现异常："+ e);
            e.printStackTrace();
        }
        return jsonObject;
    }
 
    /**
     * WKT 转 Feature
     * @param wktStr WKT 字符串
     * @return Feature JSON 对象
     */
    public static JSONObject wktToFeature(String wktStr) {
        JSONObject jsonObject = new JSONObject();
        try {
            SimpleFeatureType type = DataUtilities.createType("Link", "geometry:"+getGeometryType(wktStr));
            SimpleFeatureBuilder featureBuilder = new SimpleFeatureBuilder(type);
            // 按照TYPE中声明的顺序为属性赋值就可以，其他方法我暂未尝试
            featureBuilder.add(READER.read(wktStr));
            SimpleFeature feature = featureBuilder.buildFeature(null);
            StringWriter writer = new StringWriter();
            FeatureJSON fJson = new FeatureJSON();
            fJson.writeFeature(feature, writer);
            jsonObject = JSONUtil.parseObj(writer.toString());
        }catch (Exception e) {
            System.out.println("WKT 转 Feature 出现异常："+ e);
            e.printStackTrace();
        }
        return jsonObject;
    }
 
    /**
     * WKT 转 FeatureCollection
     * @param wktStr  WKT 字符串
     * @return FeatureCollection JSON 对象
     */
    public static JSONObject wktToFeatureCollection(String wktStr) {
        JSONObject jsonObject = new JSONObject();
        try {
            String geometryType = getGeometryType(wktStr);
            if (StrUtil.isNotEmpty(geometryType)) {
                SimpleFeatureType type = DataUtilities.createType("Link", "geometry:" + geometryType);
                SimpleFeatureBuilder featureBuilder = new SimpleFeatureBuilder(type);
                List<SimpleFeature> features = new ArrayList<>();
                SimpleFeatureCollection collection = new ListFeatureCollection(type, features);
                featureBuilder.add(READER.read(wktStr));
                SimpleFeature feature = featureBuilder.buildFeature(null);
                features.add(feature);
                StringWriter writer = new StringWriter();
                FeatureJSON fJson = new FeatureJSON();
                fJson.writeFeatureCollection(collection, writer);
                jsonObject = JSONUtil.parseObj(writer.toString());
            }
        }catch (Exception e) {
            System.out.println("WKT 转 FeatureCollection 出现异常："+ e);
            e.printStackTrace();
        }
        return jsonObject;
    }
}
```

# 小工具：

```java
package top.reid.smart.geo;
 
import cn.hutool.core.util.ArrayUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.json.JSONArray;
import cn.hutool.json.JSONObject;
import cn.hutool.json.JSONUtil;
import org.geotools.data.DataUtilities;
import org.geotools.data.collection.ListFeatureCollection;
import org.geotools.data.simple.SimpleFeatureCollection;
import org.geotools.feature.simple.SimpleFeatureBuilder;
import org.geotools.geojson.GeoJSONUtil;
import org.geotools.geojson.feature.FeatureJSON;
import org.geotools.geojson.geom.GeometryJSON;
import org.locationtech.jts.geom.Geometry;
import org.locationtech.jts.geom.GeometryCollection;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.io.WKTReader;
import org.opengis.feature.simple.SimpleFeature;
import org.opengis.feature.simple.SimpleFeatureType;
 
import java.io.IOException;
import java.io.Reader;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.List;
 
/**
 * <p>
 * 地质工具
 * </p>
 *
 * @Author REID
 * @Blog https://blog.csdn.net/qq_39035773
 * @GitHub https://github.com/BeginnerA
 * @Data 2020/11/11
 * @Version V1.0
 **/
public class GeoTools {
 
    private static final WKTReader READER = new WKTReader();
 
    /**
     * 要素集合根节点
     */
    private static final String[] COLLECTION_TYPE = new String[]{"FeatureCollection"};
 
    /**
     * 地理要素类型
     */
    private static final String[] FEATURES_TYPE = new String[]{"Feature"};
 
    /**
     * 地理数据类型
     * 点、线、面、几何集合
     */
    private static final String[] GEO_TYPE = new String[]{"Geometry", "Point", "LineString", "Polygon", "MultiPoint", "MultiLineString", "MultiPolygon", "GeometryCollection"};
 
    /**
     * 获取 Geo 几何类型
     * @param wktStr WKT 字符串
     * @return Geo 几何类型
     */
    public static String getGeometryType(String wktStr) {
        String type = null;
        if (StrUtil.isNotEmpty(wktStr)) {
            try {
                Geometry read = READER.read(wktStr);
                type = read.getGeometryType();
            }catch (Exception e) {
                System.out.println("非规范 WKT 字符串："+ e);
                e.printStackTrace();
            }
        }
        return type;
    }
 
    /**
     * 是规范的 WKT
     * @param wktStr WKT 字符串
     * @return 是、否
     */
    public static boolean isWkt(String wktStr) {
        for (String s : GEO_TYPE) {
            if (wktStr.toLowerCase().startsWith(s.toLowerCase())) {
                return true;
            }
        }
        return false;
    }
 
    /**
     * 不是规范的 WKT
     * @param wktStr WKT 字符串
     * @return 是、否
     */
    public static boolean isNotWkt(String wktStr) {
        return !isWkt(wktStr);
    }
 
    /**
     * 是规范的 GeoJson
     * @param geoJsonStr GeoJson 字符串
     * @return 是、否
     */
    public static boolean isGeoJson(String geoJsonStr) {
        try {
            JSONObject jsonObject = JSONUtil.parseObj(geoJsonStr);
            return isGeoJson(jsonObject);
        }catch (Exception e) {
            return false;
        }
    }
 
    /**
     * 不是规范的 GeoJson
     * @param geoJsonStr GeoJson 字符串
     * @return 是、否
     */
    public static boolean isNotGeoJson(String geoJsonStr) {
        return !isGeoJson(geoJsonStr);
    }
 
    /**
     * 是规范的 GeoJson
     * @param geoJson GeoJson 对象
     * @return 是、否
     */
    public static boolean isGeoJson(JSONObject geoJson) {
        String type = geoJson.getStr("type");
        boolean mark = false;
        // 判断根节点
        if (ArrayUtil.containsIgnoreCase(COLLECTION_TYPE, type)) {
            JSONArray jsonArray = geoJson.get("features", JSONArray.class);
            for (Object jsonStr : jsonArray) {
                JSONObject jsonObject = JSONUtil.parseObj(jsonStr);
                type = jsonObject.getStr("type");
                // 判断地理要素
                if (ArrayUtil.containsIgnoreCase(FEATURES_TYPE, type)) {
                    type = jsonObject.get("geometry", JSONObject.class).getStr("type");
                    // 判断几何要素
                    mark = ArrayUtil.containsIgnoreCase(GEO_TYPE, type);
                }
                if (!mark) {
                    return false;
                }
            }
        }else {
            // 判断地理要素
            if (ArrayUtil.containsIgnoreCase(FEATURES_TYPE, type)) {
                type = geoJson.get("geometry", JSONObject.class).getStr("type");
            }
            // 数据是几何数据
            mark = ArrayUtil.containsIgnoreCase(GEO_TYPE, type);
        }
        return mark;
    }
 
    /**
     * 不是规范的 GeoJson
     * @param geoJson GeoJson 对象
     * @return 是、否
     */
    public static boolean isNotGeoJson(JSONObject geoJson) {
        return !isGeoJson(geoJson);
    }
 
    /**
     * GeoJson 转 WKT
     * @param geoJson GeoJson 对象
     * @return WKT 字符串
     */
    public static String geoJsonToWkt(JSONObject geoJson) {
        String wkt = null;
        GeometryJSON gJson = new GeometryJSON();
        try {
            if(isGeoJson(geoJson)){
                String type = geoJson.getStr("type");
                // 判断是否根节点
                if (ArrayUtil.containsIgnoreCase(COLLECTION_TYPE, type)) {
                    JSONArray geometriesArray = geoJson.get("features", JSONArray.class);
                    // 定义一个数组装图形对象
                    int size = geometriesArray.size();
                    Geometry[] geometries = new Geometry[size];
                    for (int i = 0; i < size; i++){
                        String str = JSONUtil.parseObj(geometriesArray.get(i)).getStr("geometry");
                        // 使用 GeoUtil 去读取 str
                        Reader reader = GeoJSONUtil.toReader(str);
                        Geometry geometry = gJson.read(reader);
                        geometries[i] = geometry;
                    }
                    GeometryCollection geometryCollection = new GeometryCollection(geometries, new GeometryFactory());
                    wkt = geometryCollection.toText();
                }else {
                    String geoStr = geoJson.toString();
                    // 判断是否地理要素节点
                    if (ArrayUtil.containsIgnoreCase(FEATURES_TYPE, type)) {
                        geoStr = geoJson.getStr("geometry");
                    }
                    Reader reader = GeoJSONUtil.toReader(geoStr);
                    Geometry read = gJson.read(reader);
                    wkt = read.toText();
                }
            }
        } catch (IOException e){
            System.out.println("GeoJson 转 WKT 出现异常："+ e);
            e.printStackTrace();
        }
        return wkt;
    }
 
    /**
     * WKT 转 GeoJson
     * @param wktStr WKT 字符串
     * @return GeoJson 对象
     */
    public static JSONObject wktToGeoJson(String wktStr) {
        JSONObject jsonObject = new JSONObject();
        try {
            Geometry geometry = READER.read(wktStr);
            StringWriter writer = new StringWriter();
            GeometryJSON geometryJson = new GeometryJSON();
            geometryJson.write(geometry, writer);
            jsonObject = JSONUtil.parseObj(writer.toString());
        } catch (Exception e) {
            System.out.println("WKT 转 GeoJson 出现异常："+ e);
            e.printStackTrace();
        }
        return jsonObject;
    }
 
    /**
     * WKT 转 Feature
     * @param wktStr WKT 字符串
     * @return Feature JSON 对象
     */
    public static JSONObject wktToFeature(String wktStr) {
        JSONObject jsonObject = new JSONObject();
        try {
            SimpleFeatureType type = DataUtilities.createType("Link", "geometry:"+getGeometryType(wktStr));
            SimpleFeatureBuilder featureBuilder = new SimpleFeatureBuilder(type);
            // 按照TYPE中声明的顺序为属性赋值就可以，其他方法我暂未尝试
            featureBuilder.add(READER.read(wktStr));
            SimpleFeature feature = featureBuilder.buildFeature(null);
            StringWriter writer = new StringWriter();
            FeatureJSON fJson = new FeatureJSON();
            fJson.writeFeature(feature, writer);
            jsonObject = JSONUtil.parseObj(writer.toString());
        }catch (Exception e) {
            System.out.println("WKT 转 Feature 出现异常："+ e);
            e.printStackTrace();
        }
        return jsonObject;
    }
 
    /**
     * WKT 转 FeatureCollection
     * @param wktStr  WKT 字符串
     * @return FeatureCollection JSON 对象
     */
    public static JSONObject wktToFeatureCollection(String wktStr) {
        JSONObject jsonObject = new JSONObject();
        try {
            String geometryType = getGeometryType(wktStr);
            if (StrUtil.isNotEmpty(geometryType)) {
                SimpleFeatureType type = DataUtilities.createType("Link", "geometry:" + geometryType);
                SimpleFeatureBuilder featureBuilder = new SimpleFeatureBuilder(type);
                List<SimpleFeature> features = new ArrayList<>();
                SimpleFeatureCollection collection = new ListFeatureCollection(type, features);
                featureBuilder.add(READER.read(wktStr));
                SimpleFeature feature = featureBuilder.buildFeature(null);
                features.add(feature);
                StringWriter writer = new StringWriter();
                FeatureJSON fJson = new FeatureJSON();
                fJson.writeFeatureCollection(collection, writer);
                jsonObject = JSONUtil.parseObj(writer.toString());
            }
        }catch (Exception e) {
            System.out.println("WKT 转 FeatureCollection 出现异常："+ e);
            e.printStackTrace();
        }
        return jsonObject;
    }
}
```