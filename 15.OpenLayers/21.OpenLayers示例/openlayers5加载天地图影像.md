```js
<!DOCTYPE html>
    <html>
    <head>
    <title>WMTS</title>
<link rel="stylesheet" href="https://openlayers.org/en/v5.3.0/css/ol.css" type="text/css">
    <!-- The line below is only needed for old environments like Internet Explorer and Android 4.x -->
        <script src="https://cdn.polyfill.io/v2/polyfill.min.js?features=requestAnimationFrame,Element.prototype.classList,URL"></script>
<script src="https://openlayers.org/en/v5.3.0/build/ol.js"></script>
</head>
<style type="text/css">  
    body, #map {  
border: 0px;  
margin: 0px;  
padding: 0px;  
width: 100%;  
height: 100%;  
font-size: 13px;  
}  
#map{  
width:100%;
height:100% 
    border:1px solid red;           
} 
    </style>
<body>
        <div id="map" class="map"></div>
<script>
            var center = ol.proj.transform([112.73, 38.42], "EPSG:4326", "EPSG:3857");
var map = new ol.Map({
    target: 'map',
    layers: [
        new ol.layer.Tile({
            source: new ol.source.XYZ({
                url: 'https://t0.tianditu.gov.cn/img_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=img&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TILECOL={x}&TILEROW={y}&TILEMATRIX={z}&tk=01648a46241de4244d518d8e151b3528',
            }),
            isGroup: true,
            name: '天地图路网'
        }),
        new ol.layer.Tile({
            source: new ol.source.XYZ({
                url: 'https://t0.tianditu.gov.cn/DataServer?T=cia_w&x={x}&y={y}&l={z}&tk=2ce94f67e58faa24beb7cb8a09780552'
            }),
            isGroup: true,
            name: '天地图文字标注'
        })
    ],

    view: new ol.View({
        center: center,
        zoom: 12
    })
});
</script>
</body>
</html>
```

