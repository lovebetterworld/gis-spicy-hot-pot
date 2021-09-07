- [maptalks 开发GIS地图（5）maptalks 介绍 ](https://www.cnblogs.com/googlegis/p/14720832.html)

41. Distance measure

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210429164422153-849755866.png)

```js
var distanceTool = new maptalks.DistanceTool({
    'symbol': {
      'lineColor' : '#34495e',
      'lineWidth' : 2
    },
    'vertexSymbol' : {
      'markerType'        : 'ellipse',
      'markerFill'        : '#1bbc9b',
      'markerLineColor'   : '#000',
      'markerLineWidth'   : 3,
      'markerWidth'       : 10,
      'markerHeight'      : 10
    },

    'labelOptions' : {
      'textSymbol': {
        'textFaceName': 'monospace',
        'textFill' : '#fff',
        'textLineSpacing': 1,
        'textHorizontalAlignment': 'right',
        'textDx': 15,
        'markerLineColor': '#b4b3b3',
        'markerFill' : '#000'
      },
      'boxStyle' : {
        'padding' : [6, 2],
        'symbol' : {
          'markerType' : 'square',
          'markerFill' : '#000',
          'markerFillOpacity' : 0.9,
          'markerLineColor' : '#b4b3b3'
        }
      }
    },
    'clearButtonSymbol' :[{
      'markerType': 'square',
      'markerFill': '#000',
      'markerLineColor': '#b4b3b3',
      'markerLineWidth': 2,
      'markerWidth': 15,
      'markerHeight': 15,
      'markerDx': 20
    }, {
      'markerType': 'x',
      'markerWidth': 10,
      'markerHeight': 10,
      'markerLineColor' : '#fff',
      'markerDx': 20
    }],
    'language' : 'en-US'
  }).addTo(map);
```

42. Area Measure

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210429164642696-582668744.png)

```js
var areaTool = new maptalks.AreaTool({
    'symbol': {
      'lineColor' : '#1bbc9b',
      'lineWidth' : 2,
      'polygonFill' : '#fff',
      'polygonOpacity' : 0.3
    },
    'vertexSymbol' : {
      'markerType'        : 'ellipse',
      'markerFill'        : '#34495e',
      'markerLineColor'   : '#1bbc9b',
      'markerLineWidth'   : 3,
      'markerWidth'       : 10,
      'markerHeight'      : 10
    },
    'labelOptions' : {
      'textSymbol': {
        'textFaceName': 'monospace',
        'textFill' : '#fff',
        'textLineSpacing': 1,
        'textHorizontalAlignment': 'right',
        'textDx': 15
      },
      'boxStyle' : {
        'padding' : [6, 2],
        'symbol' : {
          'markerType' : 'square',
          'markerFill' : '#000',
          'markerFillOpacity' : 0.9,
          'markerLineColor' : '#b4b3b3'
        }
      }
    },
    'clearButtonSymbol' :[{
      'markerType': 'square',
      'markerFill': '#000',
      'markerLineColor': '#b4b3b3',
      'markerLineWidth': 2,
      'markerWidth': 15,
      'markerHeight': 15,
      'markerDx': 22
    }, {
      'markerType': 'x',
      'markerWidth': 10,
      'markerHeight': 10,
      'markerLineColor' : '#fff',
      'markerDx': 22
    }],
    language: ''
  }).addTo(map);
```

43. Draw Tool

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210429165929922-1687404260.png)

```js
var drawTool = new maptalks.DrawTool({
    mode: 'Point'
  }).addTo(map).disable();

  drawTool.on('drawend', function (param) {
    console.log(param.geometry);
    layer.addGeometry(param.geometry);
  });

  var items = ['Point', 'LineString', 'Polygon', 'Circle', 'Ellipse', 'Rectangle', 'FreeHandLineString', 'FreeHandPolygon'].map(function (value) {
    return {
      item: value,
      click: function () {
        drawTool.setMode(value).enable();
      }
    };
  });

  var toolbar = new maptalks.control.Toolbar({
    items: [
      {
        item: 'Shape',
        children: items
      },
      {
        item: 'Disable',
        click: function () {
          drawTool.disable();
        }
      },
      {
        item: 'Clear',
        click: function () {
          layer.clear();
        }
      }
    ]
  }).addTo(map);
```

44. mouse contains

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210430090003098-1230606568.png)

```js
// add markers on map
  // set to green if inside the square
  // set to red if outside the square
  map.on('click', function (e) {
    var marker = new maptalks.Marker(e.coordinate);
    if (polygon.containsPoint(e.containerPoint)) {
      marker.updateSymbol({
        markerFill : '#0e595e'
      });
    }
    marker.addTo(markerLayer);
  });
```

45. fly location

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210430090556350-1507052273.gif)

```js
function changeView() {
    map.animateTo({
      center: [-74.08087539941407, 40.636167734187026],
      zoom: 13,
      pitch: 0,
      bearing: 20
    }, {
      duration: 5000
    });
    setTimeout(function () {
      map.animateTo({
        center: [-74.10704772446428, 40.66032606133018],
        zoom: 18,
        pitch: 65,
        bearing: 360
      }, {
        duration: 7000
      });
    }, 7000);
  }
```

46. marker animation

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210430090954110-1649821266.gif)

```js
function animate() {
    bars[0].animate({
      'symbol': {
        'markerHeight': 82
      }
    }, {
      'duration': 1000
    });

    bars[1].animate({
      'symbol': {
        'markerHeight': 197
      }
    }, {
      'duration': 1000
    });

    bars[2].animate({
      'symbol': {
        'markerHeight': 154
      }
    }, {
      'duration': 1000
    });
  }
```

47. move line animation

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210430091403872-1877281758.gif)

```js
function replay() {
    marker.setCoordinates(start);
    marker.bringToFront().animate({
      //animation translate distance
      translate: [offset['x'], offset['y']]
    }, {
      duration: 2000,
      //let map focus on the marker
      focus : true
    });
  }
```

48.InfoWindow

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210430091713669-544612549.png)

```js
marker.setInfoWindow({
    'title'     : 'Marker\'s InfoWindow',
    'content'   : 'Click on marker to open.'

    // 'autoPan': true,
    // 'width': 300,
    // 'minHeight': 120,
    // 'custom': false,
    //'autoOpenOn' : 'click',  //set to null if not to open when clicking on marker
    //'autoCloseOn' : 'click'
  });

  marker.openInfoWindow();
```

49.Custom InfoWindow

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210430091835255-1773315845.png)

```js
var options = {
    //'autoOpenOn' : 'click',  //set to null if not to open window when clicking on map
    'single' : false,
    'width'  : 183,
    'height' : 105,
    'custom' : true,
    'dx' : -3,
    'dy' : -12,
    'content'   : '<div class="content">' +
      '<div class="pop_title">Custom InfoWindow</div>' +
      '<div class="pop_time">' + new Date().toLocaleTimeString() + '</div><br>' +
      '<div class="pop_dept">' + coordinate.x + '</div>' +
      '<div class="pop_dept">' + coordinate.y + '</div>' +
      '<div class="arrow"></div>' +
      '</div>'
  };
  var infoWindow = new maptalks.ui.InfoWindow(options);
  infoWindow.addTo(map).show(coordinate);
```

50. layer switcher

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210430092047696-562709606.png)

```js
var map = new maptalks.Map('map', {
    center: [-0.113049,51.498568],
    zoom: 14,
    layerSwitcherControl: {
      'position'  : 'top-right',
      // title of base layers
      'baseTitle' : 'Base Layers',
      // title of layers
      'overlayTitle' : 'Layers',
      // layers you don't want to manage with layer switcher
      'excludeLayers' : [],
      // css class of container element, maptalks-layer-switcher by default
      'containerClass' : 'maptalks-layer-switcher'
    },
    baseLayer: new maptalks.GroupTileLayer('Base TileLayer', [
      new maptalks.TileLayer('Carto light',{
        'urlTemplate': 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
        'subdomains'  : ['a','b','c','d']
      }),
      new maptalks.TileLayer('Carto dark',{
        'visible' : false,
        'urlTemplate': 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
        'subdomains'  : ['a','b','c','d']
      })
    ])
  });
```

