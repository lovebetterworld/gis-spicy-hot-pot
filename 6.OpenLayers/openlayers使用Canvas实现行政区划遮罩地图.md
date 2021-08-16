- [openlayers使用Canvas实现行政区划遮罩地图](https://www.freesion.com/article/2011578367/)

显示某个区域的地图，需要把其他地方遮罩住，比如下图这样：

![img](https://www.freesion.com/images/779/f4a758fd3e2cc2311dc283ac31b729db.png)

```js
//添加遮罩
    function clipmap(data) {
        $.getJSON(data, function(data) {
            var fts = new ol.format.GeoJSON().readFeatures(data);
            var ft = fts[0];
            var converGeom =ft.getGeometry()
            converGeom.applyTransform(ol.proj.getTransform('EPSG:4326', 'EPSG:3857'));
            //var convertFt =new  ol.Feature(converGeom);
            //converLayer.getSource().addFeature(convertFt);
            var center,pixelScale,offsetX,offsetY,rotation;
            map.on('precompose',function(evt) {
                var canvas=evt.context;
                canvas.save();
               
                var coords=converGeom.getCoordinates();
                var frameState = evt.frameState;
                var pixelRatio = frameState.pixelRatio;
                var viewState = frameState.viewState;
                center = viewState.center;
                var resolution = viewState.resolution;
                rotation = viewState.rotation;
                var size = frameState.size;
                var size1=map.getSize();
                offsetX = Math.round(pixelRatio * size[0] / 2);
                offsetY = Math.round(pixelRatio * size[1] / 2);
                pixelScale = pixelRatio / resolution;
 
                canvas.beginPath();
                if(converGeom.getType() == 'MultiPolygon'){
                    for(var i=0;i<coords.length;i++){
                        createClip(coords[i][0], canvas);
                    }
                }
                else if(converGeom.getType() == 'Polygon'){
                    createClip(coords[0], canvas);
                }
                canvas.backgroundColor="red";
                canvas.clip();
            });
 
            function createClip(coords, canvas) {
                for (var i = 0, cout = coords.length; i < cout; i++) {
                    var xLen = Math.round((coords[i][0] - center[0]) * pixelScale);
                    var yLen = Math.round((center[1] - coords[i][1]) * pixelScale);
                    var x = offsetX;
                    var y = offsetY;
                    if (rotation) {
                        x = xLen * Math.cos(rotation) - yLen * Math.sin(rotation) + offsetX;
                        y = xLen * Math.sin(rotation) + yLen * Math.cos(rotation) + offsetY;
                    } else {
                        x = xLen + offsetX;
                        y = yLen + offsetY;
                    }
                    if (i == 0) {
                        canvas.moveTo(x, y);
                    } else {
                        canvas.lineTo(x, y);
                    }
                }
                canvas.closePath();
                
            }
            
 
            map.on('postcompose', function(event) {
                var ctx = event.context;
                ctx.restore();
            });
 
 
 
        })
    }
 
    var dataURL="../data/geojson/hubei.geojson";
    clipmap(dataURL);
```

