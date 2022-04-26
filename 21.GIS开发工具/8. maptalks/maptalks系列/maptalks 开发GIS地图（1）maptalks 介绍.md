- [maptalks 开发GIS地图（1）maptalks  介绍](https://www.cnblogs.com/googlegis/p/14717849.html)

maptalks 是一个3D（2.5D）得GIS地图引擎，支持基础得WebGL功能，从其官网上看，地图功能是都有得。

但是呈现效果不够酷炫，不过maptalks是支持plugin的，有很多很好的plugin对其提供强大的支撑，比如D3、echart，threejs。其中对 threejs 的支持起到很强的呈现效果支撑，如果没有 threejs的支持，估计 maptalks 的使用人数减少一半以上。 本篇先对 maptalks 的功能进行简单的介绍，后面会有对 threeJS 支持的介绍和效果呈现。

 maptalks 官网 ：[ https://maptalks.org/](https://maptalks.org/)  示例地址：https://maptalks.org/examples/cn/map/load/

　 我把里面的例子自己又跑了一边，可参考 GitHub 地址： [https://github.com/WhatGIS/maptalksMap](https://github.com/WhatGIS/maptalkMap)

　 这里简单介绍一下maptalks基础性的功能。源码请参考官网或者我的GitHub项目。

3. 初始化地图：

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210429160500902-1650232890.png)

```js
var map = new maptalks.Map('map', {
    center: [-0.113049,51.498568],
    zoom: 14,
    baseLayer: new maptalks.TileLayer('base', {
      urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
      subdomains: ['a','b','c','d'],
      attribution: '© <a href="http://osm.org">OpenStreetMap</a> contributors, © <a href="https://carto.com/">CARTO</a>'
    })
  });
```

4. 地图控件：

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210429160441190-1724752641.png)

```js
var map = new maptalks.Map('map', {
    center: [-0.113049,51.498568],
    zoom: 14,
    pitch : 45,
    attribution: true,
    zoomControl : true, // add zoom control
    scaleControl : true, // add scale control
    overviewControl : true, // add overview control
    baseLayer: new maptalks.TileLayer('base', {
      urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
      subdomains: ['a','b','c','d'],
      attribution: '© <a href="http://osm.org">OpenStreetMap</a> contributors, © <a href="https://carto.com/">CARTO</a>'
    })
  });
```

5. 地图状态

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210429160405188-1545703292.png)

```js
function getStatus() {
    var extent = map.getExtent(),
      ex = [
        '{',
        'xmin:' + extent.xmin.toFixed(5),
        ', ymin:' + extent.ymin.toFixed(5),
        ', xmax:' + extent.xmax.toFixed(5),
        ', ymax:' + extent.xmax.toFixed(5),
        '}'
      ].join('');
    var center = map.getCenter();
    var mapStatus = [
      'Center : [' + [center.x.toFixed(5), center.y.toFixed(5)].join() + ']',
      'Extent : ' + ex,
      'Size : ' + map.getSize().toArray().join(),
      'Zoom : '   + map.getZoom(),
      'MinZoom : ' + map.getMinZoom(),
      'MaxZoom : ' + map.getMaxZoom(),
      'Projection : ' + map.getProjection().code
    ];

    document.getElementById('status').innerHTML = '<div>' + mapStatus.join('<br>') + '</div>';
  }
```

6. extend

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210429160340980-1806361408.png)

 

```js
var center = map.getCenter();
  var polygon = new maptalks.Polygon([
    center.add(-0.005, 0.005),
    center.add(0.005, 0.005),
    center.add(0.005, -0.005),
    center.add(-0.005, -0.005)
  ], {
    symbol : {
      polygonFill : '#fff',
      polygonOpacity : 0.5
    }
  });
  map.getLayer('v').addGeometry(polygon);

  function fitExtent() {
    // fit map's extent to polygon's
    // 0 is the zoom offset
    map.fitExtent(polygon.getExtent(), 0);
  }
```

7. 地图事件

```js
map.on('click', function (param) {
    var infoDom = document.getElementById('info');
    infoDom.innerHTML = '<div>' + new Date().toLocaleTimeString() +
        ': click map on ' + param.coordinate.toFixed(5).toArray().join() + '</div>' +
        infoDom.innerHTML;
});
```

8. 导出地图

```js
function save() {
    var data = map.toDataURL({
      'mimeType' : 'image/jpeg', // or 'image/png'
      'save' : true,             // to pop a save dialog
      'fileName' : 'map'         // file name
    });
  }
```

9. tilelayer 图层

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210429160258137-163345165.png)

```js
var map = new maptalks.Map('map', {
    center:     [-0.113049,51.498568],
    zoom:  6,
    pitch : 40,
    baseLayer : new maptalks.TileLayer('base',{
      'urlTemplate': 'https://{s}.basemaps.cartocdn.com/dark_nolabels/{z}/{x}/{y}.png',
      'subdomains'  : ['a','b','c','d']
    }),
    // additional TileLayers in create options
    layers : [
      new maptalks.TileLayer('boudaries',{
        'urlTemplate': 'https://{s}.basemaps.cartocdn.com/dark_only_labels/{z}/{x}/{y}.png',
        'subdomains'  : ['a','b','c','d']
      })
    ]
  });
```

10. group_tileLayer

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210429160220383-1611840227.png)

```js
var map = new maptalks.Map('map', {
    center:     [-0.113049,51.498568],
    zoom:  6,
    pitch : 40,
    attribution: {
      content: '© <a href="http://osm.org">OpenStreetMap</a> contributors, © <a href="https://carto.com/">CARTO</a>, © BoudlessGeo'
    },
    // add 2 TileLayers with a GroupTileLayer
    baseLayer : new maptalks.GroupTileLayer('base', [
      new maptalks.TileLayer('tile2', {
        urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_nolabels/{z}/{x}/{y}.png',
        subdomains  : ['a','b','c','d']
      }),

      new maptalks.WMSTileLayer('wms', {
        'urlTemplate' : 'https://demo.boundlessgeo.com/geoserver/ows',
        'crs' : 'EPSG:3857',
        'layers' : 'ne:ne',
        'styles' : '',
        'version' : '1.3.0',
        'format': 'image/png',
        'transparent' : true,
        'uppercase' : true
      })
    ])
  });
```

