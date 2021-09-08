- [maptalks,mapboxgl实现3D楼宇,摄像头悬浮](https://www.jianshu.com/p/d6ad77acc431)

```xml
<!DOCTYPE html>
<html>
<head>
    <title>maptalks.mapboxgl demo</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link type="text/css" rel="stylesheet" href="https://cdn.jsdelivr.net/npm/maptalks/dist/maptalks.css">
    <script type="text/javascript" src="https://unpkg.com/maptalks/dist/maptalks.min.js"></script>
    <script src='https://api.tiles.mapbox.com/mapbox-gl-js/v1.9.1/mapbox-gl.js'></script>
    <link href='https://api.tiles.mapbox.com/mapbox-gl-js/v1.9.1/mapbox-gl.css' rel='stylesheet' />
    <script type="text/javascript" src="maptalks.mapboxgl.js"></script>
    <script type="text/javascript" src="build.js"></script>
    <style>
        html,body{
            margin:0px;
            height:100%;
        }
        #map {
            width: 100%;
            height:100%;
        }
    </style>
</head>
<body>
<div id="map"></div>
<script type="text/javascript" >
    mapboxgl.accessToken = 'pk.eyJ1Ijoiemh1bGlwaWFvIiwiYSI6ImNqemtsbXZwdzBtNjAzZG9hOWt4Z21ocHUifQ.dsdPomNsO7w4Q-rRduoBcg';

    var baseLayer = new maptalks.MapboxglLayer('tile',{
        glOptions : {
            'style' : 'mapbox://styles/mapbox/dark-v10'
        }
    });

    var map = new maptalks.Map("map",{
        //limit max pitch to 60 as mapbox-gl-js required
        maxPitch : 60,
        center:   [121.57792019,31.26885962],
        zoom   :  16,
        pitch: 56,
        bearing: 0,
        baseLayer : baseLayer
    });
    var markers=[];//所有摄像头
    let cameraWidth=15,cameraHeight=15,textSize=4;
     //根据层级来控制摄像头大小
     map.on('zoomend',function(zoom){
        let temp=zoom.from-zoom.to;
        if(temp>0){
            temp=1.5*temp;
            cameraWidth=cameraWidth/temp;
            cameraHeight=cameraHeight/temp;
            textSize=textSize/temp;
        }else if(temp<0){
            temp=Math.abs(temp)*1.5;
            cameraWidth=cameraWidth*temp;
            cameraHeight=cameraHeight*temp;
            textSize=textSize*temp;
        }
        markers.forEach(function(g){
            g.updateSymbol({
            'markerWidth' : cameraWidth,
            'markerHeight' : cameraHeight,
            'textSize' : textSize
          });
        });
     });
     
     var layer=new maptalks.VectorLayer('vector',{
        enableAltitude : true,        // enable altitude
        altitudeProperty : 'altitude' // altitude property in properties, default by 'altitude'
      }).addTo(map);
      
      
      var marker1 = new maptalks.Marker(
        [121.57792019,31.26885962],
        {
          symbol: 
          {
            'markerFile'   : '1.png',//摄像头图片
            'markerWidth'  : cameraWidth,
            'markerHeight' : cameraHeight,
            'markerDx'     : 0,
            'markerDy'     : 0,
            'markerOpacity': 1,
            'textFaceName' : 'sans-serif',
            'textName' : '{name}',
            'textSize' : textSize,
            'textDy'   : 3
          },
          properties : {
            altitude : 50,
            name:'摄像头1'
          }
        }
      );
      var marker2 = new maptalks.Marker(
        [121.57880035,31.26726501],
        {
          symbol: 
          {
            'markerFile'   : '2.png',//摄像头图片
            'markerWidth'  : cameraWidth,
            'markerHeight' : cameraHeight,
            'markerDx'     : 0,
            'markerDy'     : 0,
            'markerOpacity': 1,
            'textFaceName' : 'sans-serif',
            'textName' : '{name}',
            'textSize' : textSize,
            'textDy'   : 3
          },
          properties : {
            altitude : 50,
            name:'摄像头2'
          }
        }
      );
      marker1.on('click',function(){
      });
      markers.push(marker1);
      markers.push(marker2);
      
      var multiPolygon = new maptalks.MultiPolygon([
                    [
                        [
                            [
                                121.57791602,
                                31.26885628
                            ],
                            [
                                121.57559574,
                                31.2672609
                            ],
                            [
                                121.57405076,
                                31.26650217
                            ],
                            [
                                121.57531057,
                                31.26453833
                            ],
                            [
                                121.57501869,
                                31.2643849
                            ],
                            [
                                121.57525944,
                                31.26404894
                            ],
                            [
                                121.57639994,
                                31.26319769
                            ],
                            [
                                121.57685333,
                                31.26344285
                            ],
                            [
                                121.57791642,
                                31.26454417
                            ],
                            [
                                121.57824748,
                                31.26493524
                            ],
                            [
                                121.57754657,
                                31.26540716
                            ],
                            [
                                121.57655069,
                                31.26546411
                            ],
                            [
                                121.57665163,
                                31.26625151
                            ],
                            [
                                121.57877251,
                                31.26606947
                            ],
                            [
                                121.57880035,
                                31.26726501
                            ],
                            [
                                121.57845355,
                                31.26765787
                            ],
                            [
                                121.57894712,
                                31.2680297
                            ],
                            [
                                121.57812851,
                                31.26882507
                            ],
                            [
                                121.57791602,
                                31.26885628
                            ]
                        ]
                    ],
                    [
                        [
                            [
                                121.57792019,
                                31.26885962
                            ],
                            [
                                121.57812435,
                                31.26882937
                            ],
                            [
                                121.5780214,
                                31.26892802
                            ],
                            [
                                121.57792019,
                                31.26885962
                            ]
                        ]
                    ]
                ], {
        visible : true,
        editable : true,
        cursor : null,
        shadowBlur : 0,
        shadowColor : 'black',
        draggable : false,
        dragShadow : false, // display a shadow during dragging
        drawOnAxis : null,  // force dragging stick on a axis, can be: x, y
        symbol: {
          'polygonFill' : 'rgb(135,196,240)',
          'polygonOpacity' : 0.1,
          'lineWidth' : 0
        },
        properties : {
          altitude : 60
        }
      });
      
      layer.addGeometry(markers);
      //二楼楼面呈现(凸显层)
      layer.addGeometry(multiPolygon);
      var glMap=baseLayer.getGlMap();
      glMap.on('load',function(){
        glMap.addLayer({
                'id': 'buildings',
                'type': 'fill-extrusion',
                'minzoom': 1,
                'source': {
                    'type': 'geojson',
                    //楼宇坐标,层级 json文件
                    'data': build
                },
                'layout': {
                    'visibility': 'visible'
                },
                'paint': {
                    'fill-extrusion-color': ['get', 'color'],
                    'fill-extrusion-height': ['get', 'height'],
                    'fill-extrusion-base': ['get', 'baseHeight'],
                    'fill-extrusion-opacity': 0.6
                }
            });
      });
</script>
</body>
</html>
```

build.js

```csharp
var build={
    "features":[
        {
            "type":"Feature",
            "properties":{
                "name":null,
                "type":"building",
                "key":"长征村|151号",
                "height":60,
                "color":"#00cec9",
                "baseHeight":0,
                "floor":"1"
            },
            "geometry":{
                "type":"MultiPolygon",
                "coordinates":[
                    [
                        [
                            [
                                121.57791602,
                                31.26885628
                            ],
                            [
                                121.57559574,
                                31.2672609
                            ],
                            [
                                121.57405076,
                                31.26650217
                            ],
                            [
                                121.57531057,
                                31.26453833
                            ],
                            [
                                121.57501869,
                                31.2643849
                            ],
                            [
                                121.57525944,
                                31.26404894
                            ],
                            [
                                121.57639994,
                                31.26319769
                            ],
                            [
                                121.57685333,
                                31.26344285
                            ],
                            [
                                121.57791642,
                                31.26454417
                            ],
                            [
                                121.57824748,
                                31.26493524
                            ],
                            [
                                121.57754657,
                                31.26540716
                            ],
                            [
                                121.57655069,
                                31.26546411
                            ],
                            [
                                121.57665163,
                                31.26625151
                            ],
                            [
                                121.57877251,
                                31.26606947
                            ],
                            [
                                121.57880035,
                                31.26726501
                            ],
                            [
                                121.57845355,
                                31.26765787
                            ],
                            [
                                121.57894712,
                                31.2680297
                            ],
                            [
                                121.57812851,
                                31.26882507
                            ],
                            [
                                121.57791602,
                                31.26885628
                            ]
                        ]
                    ],
                    [
                        [
                            [
                                121.57792019,
                                31.26885962
                            ],
                            [
                                121.57812435,
                                31.26882937
                            ],
                            [
                                121.5780214,
                                31.26892802
                            ],
                            [
                                121.57792019,
                                31.26885962
                            ]
                        ]
                    ]
                ]
            }
        },
        {
            "type":"Feature",
            "properties":{
                "name":null,
                "type":"building",
                "key":"长征村|151号",
                "height":120,
                "color":"#00cec9",
                "baseHeight":60,
                "floor":"2"
            },
            "geometry":{
                "type":"MultiPolygon",
                "coordinates":[
                    [
                        [
                            [
                                121.57791602,
                                31.26885628
                            ],
                            [
                                121.57559574,
                                31.2672609
                            ],
                            [
                                121.57405076,
                                31.26650217
                            ],
                            [
                                121.57531057,
                                31.26453833
                            ],
                            [
                                121.57501869,
                                31.2643849
                            ],
                            [
                                121.57525944,
                                31.26404894
                            ],
                            [
                                121.57639994,
                                31.26319769
                            ],
                            [
                                121.57685333,
                                31.26344285
                            ],
                            [
                                121.57791642,
                                31.26454417
                            ],
                            [
                                121.57824748,
                                31.26493524
                            ],
                            [
                                121.57754657,
                                31.26540716
                            ],
                            [
                                121.57655069,
                                31.26546411
                            ],
                            [
                                121.57665163,
                                31.26625151
                            ],
                            [
                                121.57877251,
                                31.26606947
                            ],
                            [
                                121.57880035,
                                31.26726501
                            ],
                            [
                                121.57845355,
                                31.26765787
                            ],
                            [
                                121.57894712,
                                31.2680297
                            ],
                            [
                                121.57812851,
                                31.26882507
                            ],
                            [
                                121.57791602,
                                31.26885628
                            ]
                        ]
                    ],
                    [
                        [
                            [
                                121.57792019,
                                31.26885962
                            ],
                            [
                                121.57812435,
                                31.26882937
                            ],
                            [
                                121.5780214,
                                31.26892802
                            ],
                            [
                                121.57792019,
                                31.26885962
                            ]
                        ]
                    ]
                ]
            }
        }
    ],
    "type":"FeatureCollection"
}
```

![img](https://upload-images.jianshu.io/upload_images/20346718-c2bc81348c6cc01b.png?imageMogr2/auto-orient/strip|imageView2/2/w/1053)

