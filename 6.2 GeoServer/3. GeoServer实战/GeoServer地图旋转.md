GeoServer发布地图后，在浏览时可以旋转地图。操作方式：在浏览URL中加入&angle=，角度值可以为负，范围-360——360，单位度。

 示例：

```
http://localhost:8080/geoserver/wms?
REQUEST=GetMap
&SERVICE=WMS 
&VERSION=1.1.1
&LAYERS=masmap 
&STYLES= 
&FORMAT=image/png
&BGCOLOR=0xD6EAB3 
&TRANSPARENT=FALSE 
&SRS=EPSG:4326 
&BBOX=101.53219,3.00787,101.54219,3.01787 
&WIDTH=600 
&HEIGHT=600 
&reaspect=false 
&tiled=false 
&tilesOrigin=0,0 
&angle=-322.73
```