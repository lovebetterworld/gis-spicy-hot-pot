- [maptalks 开发GIS地图（2）maptalks 介绍](https://www.cnblogs.com/googlegis/p/14718485.html)

11. arcgis_tile_layer

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210429160153810-386841228.png)

```js
var arcUrl = 'https://services.arcgisonline.com/arcgis/rest/services/ESRI_Imagery_World_2D/MapServer';

  maptalks.SpatialReference.loadArcgis(arcUrl + '?f=pjson', function (err, conf) {
    if (err) {
      throw new Error(err);
    }
    var ref = conf.spatialReference;
    ref.projection = 'EPSG:4326';

    var map = new maptalks.Map('map', {
      center: [121, 0],
      zoom: 1,
      minZoom: 1,
      maxZoom : 16,
      spatialReference : ref,
      baseLayer: new maptalks.TileLayer('base', {
        'tileSystem' : conf.tileSystem,
        'tileSize' : conf.tileSize, // [512, 512]
        'urlTemplate' : arcUrl + '/tile/{z}/{y}/{x}',
        'attribution' : '© <a target="_blank" href="' + arcUrl + '"">ArcGIS</a>'
      })
    });
  });
```

12. layer-mask

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210429160120271-1466556812.png)

```js
var mask = new maptalks.Polygon(boundary, {
    'symbol' : [
      {
        'lineColor' : '#ccc',
        'lineWidth' : 8,
        'polygonFillOpacity' : 0
      },
      {
        'lineColor' : '#404040',
        'lineWidth' : 6,
        'polygonFillOpacity' : 0
      }
    ]
  });

  //Copy the mask to add as mask's outline
  var outline = mask.copy();

  var maskedLayer = new maptalks.TileLayer('masked', {
    'urlTemplate' : 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
    'subdomains'  : ['a','b','c','d']
  })
    .setMask(mask) // set boundary as the mask to the tilelayer
    .addTo(map);
```

13. 百度 Projection

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210429160015392-521969333.png)

 

```js
var map = new maptalks.Map('map', {
    center: [105.08052356963802, 36.04231948670001],
    zoom: 5,
    minZoom:1,
    maxZoom:19,
    spatialReference:{
      projection : 'baidu'
    },
    baseLayer: new maptalks.TileLayer('base', {
      'urlTemplate' : 'http://online{s}.map.bdimg.com/onlinelabel/?qt=tile&x={x}&y={y}&z={z}&styles=pl&scaler=1&p=1',
      'subdomains'  : [0,1,2,3,4,5,6,7,8,9],
      'attribution' :  '© <a target="_blank" href="http://map.baidu.com">Baidu</a>'
    })
  });
```

14. css-filter

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210429155828321-1667226814.png)

```js
var map = new maptalks.Map('map', {
    center: [105.08052356963802, 36.04231948670001],
    zoom: 5,
    minZoom:1,
    maxZoom:19,
    baseLayer: new maptalks.TileLayer('base', {
      urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
      subdomains: ['a','b','c','d'],
      attribution: '© <a href="http://osm.org">OpenStreetMap</a> contributors, © <a href="https://carto.com/">CARTO</a>',

      // css filter
      cssFilter : 'sepia(100%) invert(90%)'
    })
  });
```

15. marker 

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210429155800042-1332117320.png)

```js
var point = new maptalks.Marker(
    [-0.113049, 51.498568],
    {
      visible : true,
      editable : true,
      cursor : 'pointer',
      shadowBlur : 0,
      shadowColor : 'black',
      draggable : false,
      dragShadow : false, // display a shadow during dragging
      drawOnAxis : null,  // force dragging stick on a axis, can be: x, y
      symbol : {
        'textFaceName' : 'sans-serif',
        'textName' : 'MapTalks',
        'textFill' : '#34495e',
        'textHorizontalAlignment' : 'right',
        'textSize' : 40
      }
    }
  );

  new maptalks.VectorLayer('vector', point).addTo(map);
```

16. multiMarker

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210429155739312-732515827.png)

```js
var rectangle = new maptalks.Rectangle(center.add(-0.018,0.012), 800, 700, {
    symbol: {
      lineColor: '#34495e',
      lineWidth: 2,
      polygonFill: '#34495e',
      polygonOpacity: 0.4
    }
  });
  var circle = new maptalks.Circle(center.add(0.002,0.008), 500,{
    symbol: {
      lineColor: '#34495e',
      lineWidth: 2,
      polygonFill: '#1bbc9b',
      polygonOpacity: 0.4
    }
  });
  var sector = new maptalks.Sector(center.add(-0.013,-0.001), 900, 240, 300, {
    symbol: {
      lineColor: '#34495e',
      lineWidth: 2,
      polygonFill: 'rgb(135,196,240)',
      polygonOpacity: 0.4
    }
  });

  var ellipse = new maptalks.Ellipse(center.add(0.003,-0.005), 1000, 600, {
    symbol: {
      lineColor: '#34495e',
      lineWidth: 2,
      polygonFill: 'rgb(216,115,149)',
      polygonOpacity: 0.4
    }
  });

  new maptalks.VectorLayer('vector')
    .addGeometry([rectangle, circle, sector, ellipse])
    .addTo(map);
```

17. label

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210429155722008-1104617330.png)

```js
var label = new maptalks.Label('label without box',
    [-0.126049, 51.496568],
    {
      'draggable' : true,
      'textSymbol': {
        'textFaceName' : 'monospace',
        'textFill' : '#34495e',
        'textHaloFill' : '#fff',
        'textHaloRadius' : 4,
        'textSize' : 18,
        'textWeight' : 'bold',
        'textVerticalAlignment' : 'top'
      }
    });

  var labelBox = new maptalks.Label('label with box',
    [-0.109049, 51.496568],
    {
      'draggable' : true,
      'boxStyle' : {
        'padding' : [12, 8],
        'verticalAlignment' : 'top',
        'horizontalAlignment' : 'left',
        'minWidth' : 200,
        'minHeight' : 30,
        'symbol' : {
          'markerType' : 'square',
          'markerFill' : 'rgb(135,196,240)',
          'markerFillOpacity' : 0.9,
          'markerLineColor' : '#34495e',
          'markerLineWidth' : 1
        }
      },
      'textSymbol': {
        'textFaceName' : 'monospace',
        'textFill' : '#34495e',
        'textHaloFill' : '#fff',
        'textHaloRadius' : 4,
        'textSize' : 18,
        'textWeight' : 'bold',
        'textVerticalAlignment' : 'top'
      }
    });

  new maptalks.VectorLayer('vector', [labelBox, label]).addTo(map);
```

18. text-box

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210429155700562-1930521555.png)

```js
var textbox = new maptalks.TextBox(
    'This is a textbox, with very long content', // content
    [-0.113049, 51.498568],  // coordinate
    200,                 // width
    90,                  // height
    {
        'draggable' : true,
        'textStyle' : {
            'wrap' : true,          // auto wrap text
            'padding' : [12, 8],    // padding of textbox
            'verticalAlignment' : 'top',
            'horizontalAlignment' : 'right',
            'symbol' : {
                'textFaceName' : 'monospace',
                'textFill' : '#34495e',
                'textHaloFill' : '#fff',
                'textHaloRadius' : 4,
                'textSize' : 18,
                'textWeight' : 'bold'
            }
        },
        'boxSymbol': {
            // box's symbol
            'markerType' : 'square',
            'markerFill' : 'rgb(135,196,240)',
            'markerFillOpacity' : 0.9,
            'markerLineColor' : '#34495e',
            'markerLineWidth' : 1
        }
    });

new maptalks.VectorLayer('vector', textbox).addTo(map);
```

19. connected-line

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210429155634060-1936117174.png)

```js
// connector line
  var line = new maptalks.ConnectorLine(src, dst, {
    showOn : 'always', //'moving', 'click', 'mouseover', 'always'
    arrowStyle : 'classic',
    arrowPlacement : 'vertex-last',// 'vertex-last', //vertex-first, vertex-last, vertex-firstlast, point
    symbol: {
      lineColor: '#34495e',
      lineWidth: 2
    }
  });

  layer.addGeometry(src, dst, line);

  var src2 = src.copy().translate(0, -0.01);
  var dst2 = dst.copy().translate(0, -0.01);
  // Arc Connector Line
  var line2 = new maptalks.ArcConnectorLine(src2, dst2, {
    arcDegree : 90,
    showOn : 'always',
    symbol: {
      lineColor: '#34495e',
      lineWidth: 2
    }
  });

  layer.addGeometry(src2, dst2, line2);
```

20. listen-events

```js
function addListen() {
    //mousemove and touchmove is annoying, so not listening to it.
    marker.on('mousedown mouseup click dblclick contextmenu touchstart touchend', onEvent);
  }
  function removeListen() {
    //mousemove and touchmove is annoying, so not listening to it.
    marker.off('mousedown mouseup click dblclick contextmenu touchstart touchend', onEvent);
  }

  var events = [];

  function onEvent(param) {
    events.push(param);
    var content = '';
    for (var i = events.length - 1; i >= 0; i--) {
      content += events[i].type + ' on ' +
        events[i].coordinate.toArray().map(function (c) { return c.toFixed(5); }).join() +
        '<br>';
    }
    document.getElementById('events').innerHTML = '<div>' + content + '</div>';
    //return false to stop event propagation
    return false;
  }
```

