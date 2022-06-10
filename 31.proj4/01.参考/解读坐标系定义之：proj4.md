- [解读坐标系定义之：proj4_高端客户的博客-CSDN博客_proj4](https://blog.csdn.net/u013240519/article/details/113243000)

# 一、proj-strings

“proj-strings”. A proj-string describes any transformation regardless of how simple or complicated it might be

## 0、参数列表

| Parameter | Description                                                  |
| --------- | ------------------------------------------------------------ |
| +a        | Semimajor radius of the ellipsoid axis 长轴                  |
| +axis     | Axis orientation 长轴方向                                    |
| +b        | Semiminor radius of the ellipsoid axis 短轴                  |
| * +ellps  | Ellipsoid name 椭球体                                        |
| * +datum  | Datum name 基准面                                            |
| +k        | Scaling factor (deprecated) 缩放系数                         |
| +k_0      | Scaling factor 缩放系数                                      |
| +lat_0    | Latitude of origin 原点纬度                                  |
| +lon_0    | Central meridian 中央子午线                                  |
| +lon_wrap | Center longitude to use for wrapping                         |
| +over     | Allow longitude output outside -180 to 180 range, disables wrapping |
| +pm       | Alternate prime meridian (typically a city name 备用本初子午线 |
| * +proj   | Projection name 坐标系名称                                   |
| +units    | meters, US survey feet.etc. 水平单位，米、英寸等             |
| +vunits   | vertical units 垂直单位                                      |
| +x_0      | False easting 向东偏移距离                                   |
| +y_0      | False northing 向北偏移距离                                  |

补充：

| Parameter   | Description                                                  |
| ----------- | ------------------------------------------------------------ |
| +geoidgrids | Filename of GTX grid file to use for vertical datum transforms |
| +nadgrids   | Filename of NTv2 grid file to use for datum transforms       |
| +towgs84    | 3 or 7 term datum transform parameters                       |
| +to_meter   | Multiplier to convert map units to 1.0m                      |
| +vto_meter  | Vertical conversion to meters                                |

## 1、+axis

### 1.1 组合值

- “e” - Easting
- “w” - Westing
- “n” - Northing
- “s” - Southing
- “u” - Up
- “d” - Down

### 1.2 +axis常用值

- +axis=enu - the default easting, northing, elevation.
- +axis=neu - northing, easting, up - useful for “lat/long” geographic coordinates, or south orientated transverse mercator.
- +axis=wnu - westing, northing, up - some planetary coordinate systems have “west positive” coordinate systems

## 2、+ellps 椭球体

| 名称      | 长半轴 a     | 短半轴 b     | 1/扁率 rf         | 描述                            |
| --------- | ------------ | ------------ | ----------------- | ------------------------------- |
| MERIT     | 6378137.0    |              | 298.257           | MERIT 1983                      |
| SGS85     | 6378136.0    |              | 298.257           | Soviet Geodetic System 85       |
| * GRS80   | 6378137.0    |              | 298.257222101     | GRS 1980(IUGG, 1980)            |
| IAU76     | 6378140.0    |              | 298.257           | IAU 1976                        |
| airy      | 6377563.396  |              | 299.3249646       | Airy 1830                       |
| APL4.9    | 6378137.0    |              | 298.25            | Appl. Physics. 1965             |
| NWL9D     | 6378145.0    |              | 298.25            | Naval Weapons Lab., 1965        |
| mod_airy  | 6377340.189  | 6356034.446  |                   | Modified Airy                   |
| andrae    | 6377104.43   |              | 300.0             | Andrae 1876 (Den., Iclnd.)      |
| danish    | 6377019.2563 |              | 300.0             | Andrae 1876 (Denmark, Iceland)  |
| aust_SA   | 6378160.0    |              | 298.25            | Australian Natl & S. Amer. 1969 |
| GRS67     | 6378160.0    |              | 298.2471674270    | GRS 67(IUGG 1967)               |
| GSK2011   | 6378136.5    |              | 298.2564151       | GSK-2011                        |
| bessel    | 6377397.155  |              | 299.1528128       | Bessel 1841                     |
| bess_nam  | 6377483.865  |              | 299.1528128       | Bessel 1841 (Namibia)           |
| clrk66    | 6378206.4    | 6356583.8    |                   | Clarke 1866                     |
| clrk80    | 6378249.145  |              | 293.4663          | Clarke 1880 mod.                |
| clrk80ign | 6378249.2    |              | 293.4660212936269 | Clarke 1880 (IGN).              |
| CPM       | 6375738.7    |              | 334.29            | Comm. des Poids et Mesures 1799 |
| delmbr    | 6376428.     |              | 311.5             | Delambre 1810 (Belgium)         |
| engelis   | 6378136.05   |              | 298.2566          | Engelis 1985                    |
| evrst30   | 6377276.345  |              | 300.8017          | Everest 1830                    |
| evrst48   | 6377304.063  |              | 300.8017          | Everest 1948                    |
| evrst56   | 6377301.243  |              | 300.8017          | Everest 1956                    |
| evrst69   | 6377295.664  |              | 300.8017          | Everest 1969                    |
| evrstSS   | 6377298.556  |              | 300.8017          | Everest (Sabah & Sarawak)       |
| fschr60   | 6378166.     |              | 298.3             | Fischer (Mercury Datum) 1960    |
| fschr60m  | 6378155.     |              | 298.3             | Modified Fischer 1960           |
| fschr68   | 6378150.     |              | 298.3             | Fischer 1968                    |
| helmert   | 6378200.     |              | 298.3             | Helmert 1906                    |
| hough     | 6378270.0    |              | 297.              | Hough                           |
| intl      | 6378388.0    |              | 297.              | International 1909 (Hayford)    |
| krass     | 6378245.0    |              | 298.3             | Krassovsky, 1942                |
| kaula     | 6378163.     |              | 298.24            | Kaula 1961                      |
| lerch     | 6378139.     |              | 298.257           | Lerch 1979                      |
| mprts     | 6397300.     |              | 191.              | Maupertius 1738                 |
| new_intl  | 6378157.5    | 6356772.2    |                   | New International 1967          |
| plessis   | 6376523.     | 6355863      |                   | Plessis 1817 (France)           |
| PZ90      | 6378136.0    |              | 298.25784         | PZ-90                           |
| SEasia    | 6378155.0    | 6356773.3205 |                   | Southeast Asia                  |
| walbeck   | 6376896.0    | 6355834.8467 |                   | Walbeck                         |
| WGS60     | 6378165.0    |              | 298.3             | WGS 60                          |
| WGS66     | 6378145.0    |              | 298.25            | WGS 66                          |
| WGS72     | 6378135.0    |              | 298.26            | WGS 72                          |
| * WGS84   | 6378137.0    |              | 298.257223563     | WGS 84                          |
| sphere    | 6370997.0    | 6370997.0    |                   | Normal Sphere (r=6370997)       |

## 3、+datum 基准面

基准面是在具有明确方向的椭球体

| datum 基准面  | ellipse 椭球体 | Description                                                  |
| ------------- | -------------- | ------------------------------------------------------------ |
| WGS84         | WGS84          | towgs84=0,0,0                                                |
| GGRS87        | GRS80          | towgs84=-199.87,74.79,246.62 Greek_Geodetic_Reference_System_1987 |
| NAD83         | GRS80          | towgs84=0,0,0 North_American_Datum_1983                      |
| NAD27         | clrk66         | nadgrids=@conus,@alaska,@ntv2_0.gsb,@ntv1_can.dat North_American_Datum_1927 |
| potsdam       | bessel         | nadgrids=@BETA2007.gsb Potsdam Rauenberg 1950 DHDN           |
| carthage      | clrk80ign      | towgs84=-263.0,6.0,431.0 Carthage 1934 Tunisia               |
| hermannskogel | bessel         | towgs84=577.326,90.129,463.919,5.137,1.474,5.297,2.4232 Hermannskogel |
| ire65         | mod_airy       | towgs84=482.530,-130.596,564.557,-1.042,-0.214,-0.631,8.15 Ireland 1965 |
| nzgd49        | intl           | towgs84=59.47,-5.04,187.44,0.47,-0.1,1.024,-4.5993 New Zealand Geodetic Datum 1949 |
| OSGB36        | airy           | towgs84=446.448,-125.157,542.060,0.1502,0.2470,0.8421,-20.4894 Airy 1830 |

## 3、+pm （prime meridian）中央子午线

| Meridian  | Longitude         |
| --------- | ----------------- |
| greenwich | 0° E              |
| lisbon    | 9° 07’ 54.862” W  |
| paris     | 2° 20’ 14.025” E  |
| bogota    | 74° 04’ 51.3” E   |
| madrid    | 3° 41’ 16.48” W   |
| rome      | 12° 27’ 8.4” E    |
| bern      | 7° 26’ 22.5” E    |
| jakarta   | 106° 48’ 27.79” E |
| ferro     | 17° 40’ W         |
| brussels  | 4° 22’ 4.71” E    |
| stockholm | 18° 3’ 29.8” E    |
| athens    | 23° 42’ 58.815” E |
| oslo      | 10° 43’ 22.5” E   |

## 4、+proj 坐标系

| Value       | Description                                                  |
| ----------- | ------------------------------------------------------------ |
| aea         | Albers Equal Area                                            |
| aeqd        | Azimuthal Equidistant                                        |
| affine      | Affine transformation                                        |
| airy        | Airy                                                         |
| aitoff      | Aitoff                                                       |
| alsk        | Mod. Stereographic of Alaska                                 |
| apian       | Apian Globular I                                             |
| august      | August Epicycloidal                                          |
| axisswap    | Axis ordering                                                |
| bacon       | Bacon Globular                                               |
| bertin1953  | Bertin 1953                                                  |
| bipc        | Bipolar conic of western hemisphere                          |
| boggs       | Boggs Eumorphic                                              |
| bonne       | Bonne (Werner lat_1=90)                                      |
| calcofi     | Cal Coop Ocean Fish Invest Lines/Stations                    |
| cart        | Geodetic/cartesian conversions                               |
| cass        | Cassini                                                      |
| cc          | Central Cylindrical                                          |
| ccon        | Central Conic                                                |
| cea         | Equal Area Cylindrical                                       |
| chamb       | Chamberlin Trimetric                                         |
| collg       | Collignon                                                    |
| comill      | Compact Miller                                               |
| crast       | Craster Parabolic (Putnins P4)                               |
| deformation | Kinematic grid shift                                         |
| denoy       | Denoyer Semi-Elliptical                                      |
| eck1        | Eckert I                                                     |
| eck2        | Eckert II                                                    |
| eck3        | Eckert III                                                   |
| eck4        | Eckert IV                                                    |
| eck5        | Eckert V                                                     |
| eck6        | Eckert VI                                                    |
| eqearth     | Equal Earth                                                  |
| eqc         | Equidistant Cylindrical (Plate Carree)                       |
| eqdc        | Equidistant Conic                                            |
| euler       | Euler                                                        |
| etmerc      | Extended Transverse Mercator                                 |
| fahey       | Fahey                                                        |
| fouc        | Foucaut                                                      |
| fouc_s      | Foucaut Sinusoidal                                           |
| gall        | Gall (Gall Stereographic)                                    |
| geoc        | Geocentric Latitude                                          |
| geogoffset  | Geographic Offset                                            |
| geos        | Geostationary Satellite View                                 |
| gins8       | Ginsburg VIII (TsNIIGAiK)                                    |
| gn_sinu     | General Sinusoidal Series                                    |
| gnom        | Gnomonic                                                     |
| goode       | Goode Homolosine                                             |
| gs48        | Mod. Stereographic of 48 U.S.                                |
| gs50        | Mod. Stereographic of 50 U.S.                                |
| hammer      | Hammer & Eckert-Greifendorff                                 |
| hatano      | Hatano Asymmetrical Equal Area                               |
| healpix     | HEALPix                                                      |
| rhealpix    | rHEALPix                                                     |
| helmert     | 3(6)-, 4(8)- and 7(14)-parameter Helmert shift               |
| hgridshift  | Horizontal grid shift                                        |
| horner      | Horner polynomial evaluation                                 |
| igh         | Interrupted Goode Homolosine                                 |
| imw_p       | International Map of the World Polyconic                     |
| isea        | Icosahedral Snyder Equal Area                                |
| kav5        | Kavraisky V                                                  |
| kav7        | Kavraisky VII                                                |
| krovak      | Krovak                                                       |
| labrd       | Laborde                                                      |
| laea        | Lambert Azimuthal Equal Area                                 |
| lagrng      | Lagrange                                                     |
| larr        | Larrivee                                                     |
| lask        | Laskowski                                                    |
| * lonlat    | Lat/long (Geodetic)                                          |
| latlon      | Lat/long (Geodetic alias)                                    |
| lcc         | Lambert Conformal Conic                                      |
| lcca        | Lambert Conformal Conic Alternative                          |
| leac        | Lambert Equal Area Conic                                     |
| lee_os      | Lee Oblated Stereographic                                    |
| loxim       | Loximuthal                                                   |
| lsat        | Space oblique for LANDSAT                                    |
| mbt_s       | McBryde-Thomas Flat-Polar Sine (No. 1)                       |
| mbt_fps     | McBryde-Thomas Flat-Pole Sine (No. 2)                        |
| mbtfpp      | McBride-Thomas Flat-Polar Parabolic                          |
| mbtfpq      | McBryde-Thomas Flat-Polar Quartic                            |
| mbtfps      | McBryde-Thomas Flat-Polar Sinusoidal                         |
| * merc      | Mercator 墨卡托                                              |
| mil_os      | Miller Oblated Stereographic                                 |
| mill        | Miller Cylindrical                                           |
| misrsom     | Space oblique for MISR                                       |
| moll        | Mollweide                                                    |
| molobadekas | Molodensky-Badekas transformation                            |
| molodensky  | Molodensky transform                                         |
| murd1       | Murdoch I                                                    |
| murd2       | Murdoch II                                                   |
| murd3       | Murdoch III                                                  |
| natearth    | Natural Earth                                                |
| natearth2   | Natural Earth 2                                              |
| nell        | Nell                                                         |
| nell_h      | Nell-Hammer                                                  |
| nicol       | Nicolosi Globular                                            |
| nsper       | Near-sided perspective                                       |
| nzmg        | New Zealand Map Grid                                         |
| noop        | No operation                                                 |
| ob_tran     | General Oblique Transformation                               |
| ocea        | Oblique Cylindrical Equal Area                               |
| oea         | Oblated Equal Area                                           |
| omerc       | Oblique Mercator                                             |
| ortel       | Ortelius Oval                                                |
| ortho       | Orthographic                                                 |
| pconic      | Perspective Conic                                            |
| patterson   | Patterson Cylindrical                                        |
| pipeline    | Transformation pipeline manager                              |
| poly        | Polyconic (American)                                         |
| pop         | Retrieve coordinate value from pipeline stack                |
| push        | Save coordinate value on pipeline stack                      |
| putp1       | Putnins P1                                                   |
| putp2       | Putnins P2                                                   |
| putp3       | Putnins P3                                                   |
| putp3p      | Putnins P3’                                                  |
| putp4p      | Putnins P4’                                                  |
| putp5       | Putnins P5                                                   |
| putp5p      | Putnins P5’                                                  |
| putp6       | Putnins P6                                                   |
| putp6p      | Putnins P6’                                                  |
| qua_aut     | Quartic Authalic                                             |
| qsc         | Quadrilateralized Spherical Cube                             |
| robin       | Robinson                                                     |
| rouss       | Roussilhe Stereographic                                      |
| rpoly       | Rectangular Polyconic                                        |
| sch         | Spherical Cross-track Height                                 |
| sinu        | Sinusoidal (Sanson-Flamsteed)                                |
| somerc      | Swiss. Obl. Mercator                                         |
| stere       | Stereographic                                                |
| sterea      | Oblique Stereographic Alternative                            |
| gstmerc     | Gauss-Schreiber Transverse Mercator (aka Gauss-Laborde Reunion) |
| tcc         | Transverse Central Cylindrical                               |
| tcea        | Transverse Cylindrical Equal Area                            |
| times       | Times                                                        |
| tissot      | Tissot                                                       |
| * tmerc     | Transverse Mercator 横向墨卡托                               |
| tobmerc     | Tobler-Mercator                                              |
| tpeqd       | Two Point Equidistant                                        |
| tpers       | Tilted perspective                                           |
| unitconvert | Unit conversion                                              |
| ups         | Universal Polar Stereographic                                |
| urm5        | Urmaev V                                                     |
| urmfps      | Urmaev Flat-Polar Sinusoidal                                 |
| utm         | Universal Transverse Mercator (UTM)                          |
| vandg       | van der Grinten (I)                                          |
| vandg2      | van der Grinten II                                           |
| vandg3      | van der Grinten III                                          |
| vandg4      | van der Grinten IV                                           |
| vitk1       | Vitkovsky I                                                  |
| vgridshift  | Vertical grid shift                                          |
| wag1        | Wagner I (Kavraisky VI)                                      |
| wag2        | Wagner II                                                    |
| wag3        | Wagner III                                                   |
| wag4        | Wagner IV                                                    |
| wag5        | Wagner V                                                     |
| wag6        | Wagner VI                                                    |
| wag7        | Wagner VII                                                   |
| webmerc     | Web Mercator / Pseudo Mercator                               |
| weren       | Werenskiold I                                                |
| wink1       | Winkel I                                                     |
| wink2       | Winkel II                                                    |
| wintri      | Winkel Tripel                                                |

## 5、+units 、+vunits 单位

| Value  | to_meter          | Description                  |
| ------ | ----------------- | ---------------------------- |
| km     | 1000              | Kilometer                    |
| m      | 1                 | Meter                        |
| dm     | 1/10              | Decimeter                    |
| cm     | 1/100             | Centimeter                   |
| mm     | 1/1000            | Millimeter                   |
| kmi    | 1852              | International Nautical Mile  |
| in     | 0.0254            | International Inch           |
| ft     | 0.3048            | International Foot           |
| yd     | 0.9144            | International Yard           |
| mi     | 1609.344          | International Statute Mile   |
| fath   | 1.8288            | International Fathom         |
| ch     | 20.1168           | International Chain          |
| link   | 0.201168          | International Link           |
| us-in  | 1/39.37           | U.S. Surveyor’s Inch         |
| us-ft  | 0.304800609601219 | U.S. Surveyor’s Foot         |
| us-yd  | 0.914401828803658 | U.S. Surveyor’s Yard         |
| us-ch  | 20.11684023368047 | U.S. Surveyor’s Chain        |
| us-mi  | 1609.347218694437 | U.S. Surveyor’s Statute Mile |
| ind-yd | 0.91439523        | Indian Yard                  |
| ind-ft | 0.30479841        | Indian Foot                  |
| ind-ch | 20.11669506       | Indian Chain                 |

## 6、+x_0 、+y_0 偏移量

在高斯-克吕格投影中：规定中央经线为X轴，赤道为Y轴，中央经线与赤道交点为坐标原点，x值在北半球为正，南半球为负，y值在中央经线以东为正，中央经线以西为负。由于我国疆域均在北半球，x值均为正值，为了避免y值出现负值，规定各投影带的坐标纵轴均西移500km，中央经线上原横坐标值由0变为500km。由于某一个投影带的坐标都是对本带坐标原点的相对值，所以各带的坐标完全相同，为了区分某一坐标系统属于哪一带，在横轴坐标前加上带好。
例：CGCS2000 / Gauss-Kruger zone 13 EPSG:4491

```javascript
"+proj=tmerc +lat_0=0 +lon_0=75 +k=1 +x_0=13500000 +y_0=0 +ellps=GRS80 +units=m +no_defs"
```

+x_0=13500000 表示： 13带，偏移500 000m
+y_0=0

# 二、常用的坐标系定义 （可http://epsg.io/进行搜索）

## 1、WGS 84 / Pseudo-Mercator EPSG:3857

```javascript
"+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +wktext  +no_defs"
```

## 2、WGS84 - World Geodetic System 1984 EPSG:4326

```javascript
"+proj=longlat +datum=WGS84 +no_defs"
```

## 3、China Geodetic Coordinate System 2000 EPSG:4490

```javascript
"+proj=longlat +ellps=GRS80 +no_defs"
```

## 4、CGCS2000 / 高斯-克吕格 6°带

```javascript
// GCS2000 / Gauss-Kruger zone 13  EPSG:4491
"+proj=tmerc +lat_0=0 +lon_0=75 +k=1 +x_0=13500000 +y_0=0 +ellps=GRS80 +units=m +no_defs"

// GCS2000 / Gauss-Kruger zone 14  EPSG:4492
"+proj=tmerc +lat_0=0 +lon_0=81 +k=1 +x_0=14500000 +y_0=0 +ellps=GRS80 +units=m +no_defs "

// GCS2000 / Gauss-Kruger zone 15  EPSG:4493
"+proj=tmerc +lat_0=0 +lon_0=87 +k=1 +x_0=15500000 +y_0=0 +ellps=GRS80 +units=m +no_defs "

// 依次下去  +lon_0 += 6  +x_0=${带号}500000
```