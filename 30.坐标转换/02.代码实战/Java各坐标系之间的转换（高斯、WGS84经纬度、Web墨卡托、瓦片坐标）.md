- [Java各坐标系之间的转换（高斯、WGS84经纬度、Web墨卡托、瓦片坐标）_tumenooe的博客-CSDN博客_jts 坐标转换](https://blog.csdn.net/u010410697/article/details/110003422)

本文整理了一些地理坐标系之间的转换（Java代码）

## pom依赖

```xml
        <dependency>
            <groupId>com.vividsolutions</groupId>
            <artifactId>jts</artifactId>
            <version>1.13</version>
        </dependency>

        <dependency>
            <groupId>org.osgeo</groupId>
            <artifactId>proj4j</artifactId>
            <version>0.1.0</version>
        </dependency>
```

## 坐标转换工具类

```java
package com.mytest.algorithm.geometry;

import com.mytest.algorithm.model.Pixel;
import com.mytest.algorithm.model.Tile;
import com.vividsolutions.jts.geom.Coordinate;
import com.vividsolutions.jts.geom.Envelope;
import org.osgeo.proj4j.BasicCoordinateTransform;
import org.osgeo.proj4j.CRSFactory;
import org.osgeo.proj4j.CoordinateReferenceSystem;
import org.osgeo.proj4j.ProjCoordinate;

/*************************************
 *Class Name:GeoTransform
 *Description:<坐标转换工具类>
 *@since 1.0.0
 *************************************/
public class GeoTransform {
    /**
     * 赤道半径
     */
    private final static double EarthRadius = 6378137.0;
    /**
     * 地球周长
     */
    private final static double EarthPerimeter = 2 * Math.PI * EarthRadius;
    /**
     * 瓦片大小,默认256
     */
    private final static int tileSize = 256;
    /**
     * 初始像素分辨率.
     */
    private final static double initialResolution = EarthPerimeter / tileSize;
    /**
     * 坐标原点
     */
    private final static Coordinate origin = new Coordinate(-EarthPerimeter / 2.0, EarthPerimeter / 2.0);

    private final static BasicCoordinateTransform transform1;
    private final static BasicCoordinateTransform transform2;
    private final static CRSFactory crsFactory = new CRSFactory();
    private final static CoordinateReferenceSystem WGS84CRS = crsFactory.createFromName("EPSG:4326");
    private final static CoordinateReferenceSystem WebMercatorCRS = crsFactory.createFromName("EPSG:3857");

    static {
        transform1 = new BasicCoordinateTransform(WGS84CRS, WebMercatorCRS);
        transform2 = new BasicCoordinateTransform(WebMercatorCRS, WGS84CRS);
    }

    /**
     * 缩放级别换算地图分辨率
     *
     * @param zoom 级别
     */
    public double zoomToResolution(int zoom) {
        return initialResolution / Math.pow(2, zoom);
    }

    /**
     * 经纬度转墨卡托
     *
     * @param pt 经纬度坐标
     * @return 墨卡托坐标
     */
    public Coordinate geographic2Mercator(Coordinate pt) {

        synchronized (transform1) {
            ProjCoordinate pt1 = new ProjCoordinate(pt.x, pt.y);
            ProjCoordinate pt2 = new ProjCoordinate();
            transform1.transform(pt1, pt2);
            return new Coordinate(pt2.x, pt2.y);
        }
    }

    /**
     * 墨卡托转经纬度
     *
     * @param pt 墨卡托坐标
     * @return 经纬度坐标
     */
    public Coordinate mercator2Geographic(Coordinate pt) {

        synchronized (transform2) {
            ProjCoordinate pt1 = new ProjCoordinate(pt.x, pt.y);
            ProjCoordinate pt2 = new ProjCoordinate();
            transform2.transform(pt1, pt2);
            return new Coordinate(pt2.x, pt2.y);
        }
    }

    /**
     * 高斯转经纬度
     *
     * @param pt 高斯坐标
     * @param d  度带号(3度带)
     * @return 经纬度坐标
     */
    public Coordinate gk2Geographic(Coordinate pt, int d) {
        synchronized (crsFactory) {
            CoordinateReferenceSystem GKCRS = crsFactory.createFromParameters("WGS84", String.format("+proj=tmerc +lat_0=0 +lon_0=%d +k=1 +x_0=500000 +y_0=0 +ellps=WGS84 +units=m +no_defs", d * 3));
            BasicCoordinateTransform transform = new BasicCoordinateTransform(GKCRS, WGS84CRS);
            ProjCoordinate pt1 = new ProjCoordinate(pt.x, pt.y);
            ProjCoordinate pt2 = new ProjCoordinate();
            transform.transform(pt1, pt2);
            return new Coordinate(pt2.x, pt2.y);
        }
    }

    /**
     * 经纬度转高斯
     *
     * @param pt 经纬度坐标
     * @return 高斯坐标
     */
    public Coordinate geographic2GK(Coordinate pt) {
        synchronized (crsFactory) {
            int d = (int) Math.floor((pt.y + 1.5) / 3);
            CoordinateReferenceSystem GKCRS = crsFactory.createFromParameters("WGS84", String.format("+proj=tmerc +lat_0=0 +lon_0=%d +k=1 +x_0=500000 +y_0=0 +ellps=WGS84 +units=m +no_defs", d * 3));
            BasicCoordinateTransform transform = new BasicCoordinateTransform(WGS84CRS, GKCRS);
            ProjCoordinate pt1 = new ProjCoordinate(pt.x, pt.y);
            ProjCoordinate pt2 = new ProjCoordinate();
            transform.transform(pt1, pt2);
            return new Coordinate(pt2.x, pt2.y);
        }
    }

    /**
     * 高斯转web墨卡托
     *
     * @param pt 高斯坐标
     * @param d  度带好(3度带)
     * @return 墨卡托坐标
     */
    public Coordinate gk2Mercator(Coordinate pt, int d) {
        synchronized (crsFactory) {
            CoordinateReferenceSystem GKCRS = crsFactory.createFromParameters("WGS84", String.format("+proj=tmerc +lat_0=0 +lon_0=%d +k=1 +x_0=500000 +y_0=0 +ellps=WGS84 +units=m +no_defs", d * 3));
            BasicCoordinateTransform transform = new BasicCoordinateTransform(GKCRS, WebMercatorCRS);
            ProjCoordinate pt1 = new ProjCoordinate(pt.x, pt.y);
            ProjCoordinate pt2 = new ProjCoordinate();
            transform.transform(pt1, pt2);
            return new Coordinate(pt2.x, pt2.y);
        }
    }

    /**
     * 墨卡托转像素
     *
     * @param pt   墨卡托坐标
     * @param zoom 缩放级别
     * @return 像素坐标
     */
    public Pixel mercator2Pixel(Coordinate pt, int zoom) {
        double res = zoomToResolution(zoom);
        Double px = (pt.x - origin.x) / res;
        Double py = -(pt.y - origin.y) / res;
        //System.out.println(px+","+py);
        //fixme 精度向下取整
        return new Pixel((long) Math.floor(px), (long) Math.floor(py));
    }

    /**
     * 像素转墨卡托
     *
     * @param pixel 像素坐标
     * @param zoom  缩放级别
     * @return 墨卡托坐标
     */
    public Coordinate pixel2Mercator(Pixel pixel, int zoom) {
        double res = zoomToResolution(zoom);
        double x = pixel.getX() * res + origin.x;
        double y = origin.y - pixel.getY() * res;
        return new Coordinate(x, y);
    }

    /**
     * 像素坐标所在瓦片
     *
     * @param pixel 像素坐标
     * @return 瓦片坐标
     */
    public Tile pixelAtTile(Pixel pixel) {
        long tileX = pixel.getX() / tileSize;
        long tileY = pixel.getY() / tileSize;
        return new Tile(tileX, tileY);
    }

    /**
     * 像素转瓦片内像素
     *
     * @param pixel 像素坐标
     * @param tile  瓦片坐标
     * @return 瓦片内像素坐标
     */
    public Pixel pixel2Tile(Pixel pixel, Tile tile) {
        long pX = pixel.getX() - tile.getX() * tileSize;
        long pY = pixel.getY() - tile.getY() * tileSize;
        return new Pixel(pX, pY);
    }

    /**
     * 瓦片内像素转像素
     *
     * @param p    瓦片内像素坐标
     * @param tile 瓦片坐标
     * @return 像素坐标
     */
    public Pixel tile2Pixel(Pixel p, Tile tile) {
        long pixelX = p.getX() + tile.getX() * tileSize;
        long pixelY = p.getY() + tile.getY() * tileSize;
        return new Pixel(pixelX, pixelY);
    }

    /**
     * 墨卡托转瓦片内像素
     *
     * @param pt   墨卡托坐标
     * @param tile 瓦片坐标
     * @param zoom 缩放级别
     * @return 瓦片内像素坐标
     */
    public Pixel mercator2Tile(Coordinate pt, Tile tile, int zoom) {
        Pixel p = mercator2Pixel(pt, zoom);
        Pixel pixel = pixel2Tile(p, tile);
        return pixel;
    }

    /**
     * 经纬度转像素
     *
     * @param pt   经纬度坐标
     * @param zoom 缩放级别
     * @return 像素坐标
     */
    public Pixel geographic2Pixel(Coordinate pt, int zoom) {
        Coordinate mpt = geographic2Mercator(pt);
        Pixel pixel = mercator2Pixel(mpt, zoom);
        return pixel;
    }

    /**
     * 经纬度转瓦片内像素
     *
     * @param pt   经纬度坐标
     * @param tile 瓦片坐标
     * @param zoom 缩放级别
     * @return 瓦片内像素坐标
     */
    public Pixel geographic2Tile(Coordinate pt, Tile tile, int zoom) {
        Pixel pixel = geographic2Pixel(pt, zoom);
        Pixel p = this.pixel2Tile(pixel, tile);
        return p;
    }

    /**
     * 像素转经纬度
     *
     * @param pixel 像素坐标
     * @param zoom  缩放级别
     * @return 经纬度坐标
     */
    public Coordinate pixel2Geographic(Pixel pixel, int zoom) {
        Coordinate mpt = pixel2Mercator(pixel, zoom);
        Coordinate lonlat = this.mercator2Geographic(mpt);
        return lonlat;
    }

    /**
     * Tile坐标转换为所在的Tile的矩形
     *
     * @param tile 瓦片坐标
     * @return 矩形
     */
    public Envelope tile2Envelope(Tile tile) {
        long px = tile.getX() * tileSize;
        long py = tile.getY() * tileSize;
        Pixel pixel1 = new Pixel(px, py + 256);//左下
        Pixel pixel2 = new Pixel(px + 256, py);//右上
        Coordinate sw = pixel2Geographic(pixel1, tile.getZ());
        Coordinate ne = pixel2Geographic(pixel2, tile.getZ());
        return new Envelope(sw, ne);
    }

    /**
     * 瓦片坐标转换为QuadKey四叉树键值
     *
     * @param tile 瓦片坐标
     * @return String QuadKey四叉树键值
     */
    public String tile2QuadKey(Tile tile) {
        long tileX = tile.getX();
        long tileY = tile.getY();
        StringBuilder quadKey = new StringBuilder();
        for (int i = tile.getZ(); i > 0; i--) {
            char digit = '0';
            int mask = 1 << (i - 1);
            if ((tileX & mask) != 0) {
                digit++;
            }
            if ((tileY & mask) != 0) {
                digit++;
                digit++;
            }
            quadKey.append(digit);
        }
        return quadKey.toString();
    }

    /**
     * QuadKey四叉树键值转换为瓦片坐标
     *
     * @param quadKey QuadKey四叉树键值
     * @return 瓦片坐标
     */
    public Tile quadKey2Tile(String quadKey) {
        long tileX = 0;
        long tileY = 0;
        int levelOfDetail = quadKey.length();

        for (int i = levelOfDetail; i > 0; i--) {
            int mask = 1 << (i - 1);
            switch (quadKey.charAt(levelOfDetail - i)) {
                case '0':
                    break;
                case '1':
                    tileX |= mask;
                    break;
                case '2':
                    tileY |= mask;
                    break;
                case '3':
                    tileX |= mask;
                    tileY |= mask;
                    break;

                //default:throw new ArgumentException("Invalid QuadKey digit sequence.");
            }
        }
        return new Tile(tileX, tileY, levelOfDetail);
    }

}
```

### Pixel类

```java
import lombok.Data;

/**
 *
 * 屏幕像素坐标类，该类为基础类（单位：像素）。
 * 像素坐标系（Pixel Coordinates）单位。
 * 以左上角为原点(0,0)，向右向下为正方向。
 * @version	1.0
 * @author 
 */
@Data
public class Pixel {
    /**
     * 横向像素
     */
    long x;
    /**
     * 纵向像素
     */
    long y;

    /**
     * 根据给定参数构造Pixel的新实例
     * @param x 横向像素
     * @param y 纵向像素
     */
    public Pixel(long x, long y){
        this.x=x;
        this.y=y;
    }
}
```

### Tile类

```java
import lombok.Getter;
import lombok.Setter;

/**
 *
 * 瓦片类，该类为基础类（单位：块）。
 * 地图瓦片坐标系（Tile Coordinates）单位。
 * 瓦片坐标系以左上角为原点(0, 0)，到右下角(2 ^ 图像级别 - 1, 2 ^ 图像级别 - 1)为止。
 * @version	1.0
 * @author 
 */
@Getter
@Setter
public class Tile{
    /**
     * 横向瓦片数
     */
    long x;
    /**
     * 纵向瓦片数
     */
    long y;
    /**
     * 级别
     */
    int z;

    public Tile(){
    }

    /**
     * 根据给定参数构造Tile的新实例
     * @param x 横向瓦片数
     * @param y 纵向瓦片数
     */
    public Tile(long x, long y){
        this.x=x;
        this.y=y;
    }
    /**
     * 根据给定参数构造Tile的新实例
     * @param x 横向瓦片数
     * @param y 纵向瓦片数
     * @param z 级别
     */
    public Tile(long x, long y, int z){
        this.x=x;
        this.y=y;
        this.z=z;
    }

    @Override
    public String toString(){
        return "Tile("+x+","+y+","+z+")";
    }
}
```

over！