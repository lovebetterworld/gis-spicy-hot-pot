- [android 使用proj4j库，转换部分解释（Java 版纠正高程没有计算）_mmsx的博客-CSDN博客_proj4j](https://blog.csdn.net/qq_16064871/article/details/83117248)

之前写过一篇文章介绍proj4，不过后面测试发现那个库高程没有参与计算，所以自己调试源代码，封装了一个高程参与计算的。搞着也是不容易啊。下面介绍库还是proj4j-0.1.1.jar

之前的文章：[android 使用proj4j库（Java版本）](https://blog.csdn.net/qq_16064871/article/details/79663631)

### 1、封装坐标转换的代码

```java
package com.mapzoom.demo.until;
 
import org.osgeo.proj4j.CoordinateReferenceSystem;
import org.osgeo.proj4j.CoordinateTransform;
import org.osgeo.proj4j.Proj4jException;
import org.osgeo.proj4j.ProjCoordinate;
import org.osgeo.proj4j.datum.GeocentricConverter;
 
/**
 * 修复proj4 高程没有转换的bug
 */
public class BLHCoordinateTransform implements CoordinateTransform {
    private CoordinateReferenceSystem srcCRS;
    private CoordinateReferenceSystem tgtCRS;
    private ProjCoordinate geoCoord = new ProjCoordinate(0.0D, 0.0D, 0.0D);
    private boolean doInverseProjection = true;
    private boolean doForwardProjection = true;
    private boolean doDatumTransform = false;
    private boolean transformViaGeocentric = false;
    private GeocentricConverter srcGeoConv;
    private GeocentricConverter tgtGeoConv;
 
    public BLHCoordinateTransform(CoordinateReferenceSystem srcCRS, CoordinateReferenceSystem tgtCRS) {
        this.srcCRS = srcCRS;
        this.tgtCRS = tgtCRS;
        this.doInverseProjection = srcCRS != null && srcCRS != CoordinateReferenceSystem.CS_GEO;
        this.doForwardProjection = tgtCRS != null && tgtCRS != CoordinateReferenceSystem.CS_GEO;
        this.doDatumTransform = this.doInverseProjection && this.doForwardProjection && srcCRS.getDatum() != tgtCRS.getDatum();
        if (this.doDatumTransform) {
            boolean isEllipsoidEqual = srcCRS.getDatum().getEllipsoid().isEqual(tgtCRS.getDatum().getEllipsoid());
            if (!isEllipsoidEqual) {
                this.transformViaGeocentric = true;
            }
 
            if (srcCRS.getDatum().hasTransformToWGS84() || tgtCRS.getDatum().hasTransformToWGS84()) {
                this.transformViaGeocentric = true;
            }
 
            if (this.transformViaGeocentric) {
                this.srcGeoConv = new GeocentricConverter(srcCRS.getDatum().getEllipsoid());
                this.tgtGeoConv = new GeocentricConverter(tgtCRS.getDatum().getEllipsoid());
            }
        }
 
    }
 
    public CoordinateReferenceSystem getSourceCRS() {
        return this.srcCRS;
    }
 
    public CoordinateReferenceSystem getTargetCRS() {
        return this.tgtCRS;
    }
 
    public ProjCoordinate transform(ProjCoordinate src, ProjCoordinate tgt) throws Proj4jException {
        if (this.doInverseProjection) {
            this.srcCRS.getProjection().inverseProjectRadians(src, this.geoCoord);
            //高程赋值
            this.geoCoord.z = src.z;
        } else {
            this.geoCoord.setValue(src);
        }
 
        if (this.doDatumTransform) {
            this.datumTransform(this.geoCoord);
        }
 
        if (this.doForwardProjection) {
            this.tgtCRS.getProjection().projectRadians(this.geoCoord, tgt);
            //高程赋值
            tgt.z = this.geoCoord.z;
        } else {
            tgt.setValue(this.geoCoord);
        }
 
        return tgt;
    }
 
    //涉及到七参数 或者 三参数转换
    private void datumTransform(ProjCoordinate pt) {
//        if (this.srcCRS.getDatum().isEqual(this.tgtCRS.getDatum())) {
        if (this.transformViaGeocentric) {
            this.srcGeoConv.convertGeodeticToGeocentric(pt);
            if (this.srcCRS.getDatum().hasTransformToWGS84()) {
                this.srcCRS.getDatum().transformFromGeocentricToWgs84(pt);
            }
 
            if (this.tgtCRS.getDatum().hasTransformToWGS84()) {
                this.tgtCRS.getDatum().transformToGeocentricFromWgs84(pt);
            }
 
            this.tgtGeoConv.convertGeocentricToGeodetic(pt);
        }
 
//        }
    }
}
```

### 2、测试代码

```java
package com.mapzoom.demo.activity;
 
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.TextView;
 
import com.mapzoom.demo.R;
import com.mapzoom.demo.until.BLHCoordinateTransform;
 
import org.osgeo.proj4j.CRSFactory;
import org.osgeo.proj4j.CoordinateReferenceSystem;
import org.osgeo.proj4j.CoordinateTransform;
import org.osgeo.proj4j.CoordinateTransformFactory;
import org.osgeo.proj4j.ProjCoordinate;
import org.osgeo.proj4j.io.Proj4FileReader;
 
import java.io.IOException;
import java.util.Locale;
 
public class ProjTestActivity extends AppCompatActivity implements View.OnClickListener {
    TextView showTextView, showTextView1, showTextView2, showTextView3,showTextView4,showTextView5;
    CRSFactory crsFactory = new CRSFactory();
    CoordinateTransformFactory ctf = new CoordinateTransformFactory();
    ProjCoordinate projCoordinate = new ProjCoordinate();
    BLHCoordinateTransform blhCoordinateTransform = null;
    CoordinateReferenceSystem wgs84;
    CoordinateReferenceSystem targetSystem;
    private String showResult = "";
    private CoordinateTransform transform;
    private double dNorth = 0;
    private double dEast = 0;
    private double dHigh = 0;
 
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_proj_test);
 
        initWGS84();
        initUI();
    }
 
    private void initUI() {
        showTextView = (TextView) findViewById(R.id.textView);
        showTextView1 = (TextView) findViewById(R.id.textView1);
        showTextView2 = (TextView) findViewById(R.id.textView3);
        showTextView3 = (TextView) findViewById(R.id.textView4);
        showTextView4 = (TextView) findViewById(R.id.textView5);
        showTextView5 = (TextView) findViewById(R.id.textView6);
        findViewById(R.id.button).setOnClickListener(this);
        findViewById(R.id.button1).setOnClickListener(this);
        findViewById(R.id.button2).setOnClickListener(this);
        findViewById(R.id.button3).setOnClickListener(this);
        findViewById(R.id.button4).setOnClickListener(this);
        String result = String.format(Locale.ENGLISH, "%.3f", 113.0) + "\n" +
                String.format(Locale.ENGLISH, "%.3f", 23.0) + "\n" +
                String.format(Locale.ENGLISH, "%.3f", 10.0) + "\n";
        showTextView5.setText(result);
    }
 
    private void initWGS84() {
        //wgs84 ����4326
        Proj4FileReader proj4FileReader = new Proj4FileReader();
        String[] paramStr = new String[0];
        //Դ����ϵͳ
        try {
            paramStr = proj4FileReader.readParametersFromFile("epsg", "4326");
        } catch (IOException e) {
            e.printStackTrace();
        }
//        String wgs84_param = "+title=long/lat:WGS84 +proj=longlat +ellps=WGS84 +datum=WGS84 +units=degress";
 
        wgs84 = crsFactory.createFromParameters("WGS84", paramStr);
    }
 
    private void initMathTransform() {
        //beijng54  ����2435
        Proj4FileReader proj4FileReader = new Proj4FileReader();
        String[] paramStr = new String[0];
        try {
            paramStr = proj4FileReader.readParametersFromFile("epsg", "2435");
        } catch (IOException e) {
            e.printStackTrace();
        }
        targetSystem = crsFactory.createFromParameters("2435", paramStr);
        transform = ctf.createTransform(wgs84, targetSystem);
        blhCoordinateTransform = new BLHCoordinateTransform(wgs84, targetSystem);
    }
 
    public void transform(double x, double y, double z) {
        if (transform != null) {
            projCoordinate.setValue(x, y, z);
            transform.transform(projCoordinate, projCoordinate);
            dNorth = projCoordinate.y;
            dEast = projCoordinate.x;
            dHigh = projCoordinate.z;
        }
    }
 
    public void blhTransform(double x, double y, double z) {
        if (blhCoordinateTransform != null) {
            projCoordinate.setValue(x, y, z);
            blhCoordinateTransform.transform(projCoordinate, projCoordinate);
            dNorth = projCoordinate.y;
            dEast = projCoordinate.x;
            dHigh = projCoordinate.z;
        }
    }
 
    @Override
    public void onClick(View v) {
        CRSFactory crsFactory = new CRSFactory();
        String result = "";
        String proj4 = "";
        switch (v.getId()) {
            case R.id.button:
                initWGS84();
                initMathTransform();
 
                transform(113, 23, 10);
                result = String.format(Locale.ENGLISH, "%.3f", dNorth) + "\n" +
                        String.format(Locale.ENGLISH, "%.3f", dEast) + "\n" +
                        String.format(Locale.ENGLISH, "%.3f", dHigh) + "\n";
                showTextView.setText(result);
                break;
            case R.id.button1:
                initWGS84();
                //tmerc 指的是高斯投影
                proj4 = "+proj=tmerc +lat_0=0 +lon_0=114 +k=1 +x_0=500000 +y_0=0 +ellps=krass +towgs84=0,0,0,0,0,0,0 +units=m +no_defs";
 
                targetSystem = crsFactory.createFromParameters("2435", proj4);
                blhCoordinateTransform = new BLHCoordinateTransform(wgs84, targetSystem);
                transform(113, 23, 10);
 
                result = String.format(Locale.ENGLISH, "%.3f", dNorth) + "\n" +
                        String.format(Locale.ENGLISH, "%.3f", dEast) + "\n" +
                        String.format(Locale.ENGLISH, "%.3f", dHigh) + "\n";
                showTextView1.setText(result);
                break;
            case R.id.button2:
 
                initWGS84();
                initMathTransform();
 
                blhTransform(113, 23, 10);
                result = String.format(Locale.ENGLISH, "%.3f", dNorth) + "\n" +
                        String.format(Locale.ENGLISH, "%.3f", dEast) + "\n" +
                        String.format(Locale.ENGLISH, "%.3f", dHigh) + "\n";
                showTextView2.setText(result);
                break;
            case R.id.button3:
                initWGS84();
 
                proj4 = "+proj=tmerc +lat_0=0 +lon_0=114 +k=1 +x_0=500000 +y_0=0 +ellps=krass +towgs84=0,0,0,0,0,0,0 +units=m +no_defs";
                targetSystem = crsFactory.createFromParameters("2435", proj4);
                blhCoordinateTransform = new BLHCoordinateTransform(wgs84, targetSystem);
                blhTransform(113, 23, 10);
 
                result = String.format(Locale.ENGLISH, "%.3f", dNorth) + "\n" +
                        String.format(Locale.ENGLISH, "%.3f", dEast) + "\n" +
                        String.format(Locale.ENGLISH, "%.3f", dHigh) + "\n";
                showTextView3.setText(result);
                break;
 
            case R.id.button4:
                //+proj=longlat 指的是经纬度坐标
                proj4 = "+proj=longlat +ellps=krass +no_defs";
                wgs84 = crsFactory.createFromParameters("wgs84", proj4);
 
                proj4 = "+proj=tmerc +lat_0=0 +lon_0=114 +k=1 +x_0=500000 +y_0=0 +ellps=krass +towgs84=0,0,0,0,0,0,0 +units=m +no_defs";
                targetSystem = crsFactory.createFromParameters("2435", proj4);
                blhCoordinateTransform = new BLHCoordinateTransform(wgs84, targetSystem);
                blhTransform(113, 23, 10);
 
                result = String.format(Locale.ENGLISH, "%.3f", dNorth) + "\n" +
                        String.format(Locale.ENGLISH, "%.3f", dEast) + "\n" +
                        String.format(Locale.ENGLISH, "%.3f", dHigh) + "\n";
                showTextView4.setText(result);
                break;
            default:
 
                break;
        }
    }
 
 
}
```

### 3、测试效果

最后面的是原始经纬度，分别转换了。用的是高斯投影。

![img](https://img-blog.csdn.net/20181017203603921?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzE2MDY0ODcx/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

### 4、部分prj语句解释

​    **兰勃脱投影**

"+proj=lcc  +a=6378137 +b=6356752.3142  +x_0=500000  +y_0=0  +lon_0=114  +lat_1=35  +lat_2=35 +k=1 +lat_0=0"

​    该字符串定义的就是兰勃脱投影（+proj=lcc），椭球长轴为6378137m（+a=6378137），短轴为6356752.3142m（+b=6356752.3142），向东偏移500000m（+x_0=500000），向北偏移0m（+y_0=0），中央子午线是东经114°（+lon_0=114），第一标准纬线是北纬35°（+lat_1=35），第二标准纬线是北纬35°（+lat_2=35），比例为1（+k=1），起始纬度为0°（+lat_0=0，赤道）。

​    需要说明的是，第一标准纬线和第二标准纬线一致是为切投影，或者不输入第二标准纬线，两者不一样时，为割投影。

​    **墨卡托投影**

"+proj=merc +a=6378137 +b=6356752.3142  +x_0=500000 +y_0=0 +lon_0=114 +k=1 +lat_ts=60"

​    该字符串定义的是墨卡托投影（+proj=merc），椭球长轴为6378137m（+a=6378137），短轴为6356752.3142m（+b=6356752.3142），向东偏移500000m（+x_0=500000），向北偏移0m（+y_0=0），中央子午线是东经114°（+lon_0=114），比例为1（+k=1），真纬度为北纬60°（+lat_ts=60，也就是旧库里说的割纬线半径）。

​    **高斯—克吕格投影**

"+proj=tmerc +a=6378137 +b=6356752.3142  +x_0=500000 +y_0=0 +lon_0=114 +k=1 +lat_0=0"

​    该字符串定义的高斯投影（+proj=tmerc），椭球长轴为6378137m（+a=6378137），短轴为6356752.3142m（+b=6356752.3142），向东偏移500000m（+x_0=500000），向北偏移0m（+y_0=0），中央子午线是东经114°（+lon_0=114），比例为1（+k=1，当+k=0.996时可变为通用横轴墨卡托投影），起始纬度为0°（+lat_0=0，赤道）。

 

其中（+proj=longlat）代表是经纬度坐标

其中（+proj=geocent）代表是空间坐标坐标

一条语句代表一个椭球下面的坐标。有什么什么椭球下的经纬度坐标（longlat）、空间坐标|（geocent）、投影坐标（平面坐标）。所以投影是有很多类型的，就是不同的平面坐标了。转换出来的。