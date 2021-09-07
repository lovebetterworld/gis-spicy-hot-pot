- [maptalks 开发GIS地图（4）maptalks 介绍](https://www.cnblogs.com/googlegis/p/14720815.html)

31. html Marker

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210429161749596-508139386.png)

```js
var marker = new maptalks.ui.UIMarker([-0.113049,51.49856], {
    'draggable'     : true,
    'single'        : false,
    'content'       : '<div class="text_marker">HTML Marker</div>'
});
marker.addTo(map).show();
```

32. D3-marker

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210429162106001-1896722218.png)

```js
var d3 = new maptalks.ui.UIMarker([-0.113049,51.49856], {
    'draggable'     : false,
    'single'        : false,
    'content'       : createD3Dom()
});
d3.addTo(map).show();
```

33. echart-marker

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210429162541452-854480867.png)

```js
var chartDom = document.createElement('div');
  chartDom.style.cssText = 'width:650px; height:300px;';
  createChart(chartDom);

  var echartsUI = new maptalks.ui.UIMarker([-0.113049,51.49856], {
    'draggable'     : true,
    'content'       : chartDom
  }).addTo(map).show();
```

34. highchart-marker

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210429162645394-638496113.png)

```js
var highChartsUI = new maptalks.ui.UIMarker([-0.113049, 51.49856], {
    'draggable'     : true,
    'content'       : createBar()
  }).addTo(map).show();

  function createBar() {
    var dom = document.createElement('div');
    dom.style.cssText = 'min-width: 300px; height: 300px; margin: 0 auto;';
    new Highcharts.Chart({
      chart: {
        renderTo: dom,
        backgroundColor: 'rgba(255, 255, 255, 0.8)',
        type: 'area',
        spacingBottom: 30
      },
      title: {
        text: 'Fruit consumption *'
      },
      subtitle: {
        text: '* Jane\'s banana consumption is unknown',
        floating: true,
        align: 'right',
        verticalAlign: 'bottom',
        y: 15
      },
      legend: {
        layout: 'vertical',
        align: 'left',
        verticalAlign: 'top',
        x: 150,
        y: 100,
        floating: true,
        borderWidth: 1,
        backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF'
      },
      xAxis: {
        categories: ['Apples', 'Pears', 'Oranges', 'Bananas', 'Grapes', 'Plums', 'Strawberries', 'Raspberries']
      },
      yAxis: {
        title: {
          text: 'Y-Axis'
        },
        labels: {
          formatter: function () {
            return this.value;
          }
        }
      },
      tooltip: {
        formatter: function () {
          return '<b>' + this.series.name + '</b><br/>' +
            this.x + ': ' + this.y;
        }
      },
      plotOptions: {
        area: {
          fillOpacity: 0.5
        }
      },
      credits: {
        enabled: false
      },
      series: [{
        name: 'John',
        data: [0, 1, 4, 4, 5, 2, 3, 7]
      }, {
        name: 'Jane',
        data: [1, 0, 3, null, 3, 1, 2, 1]
      }]
    });
    return dom;
  }
```

35. layer-add-remove-hide-show

```js
var layer = new maptalks.VectorLayer('vector', [marker])
    .addTo(map);

  function add() {
    map.addLayer(layer);
  }

  function remove() {
    map.removeLayer(layer);
  }

 function show() {
    layer.show();
  }

  function hide() {
    layer.hide();
  }
```

36. layer-mask

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210429163048517-1887097287.png)

```js
map.on('mousemove', function (e) {
    if (!layer.getMask()) {
      layer.setMask(new maptalks.Marker(e.coordinate, {
        'symbol': {
          'markerType': 'ellipse',
          'markerWidth': 200,
          'markerHeight': 200
        }
      }));
    } else {
      layer.getMask().setCoordinates(e.coordinate);
    }
  });
```

37. filter marker by property

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210429163233032-626937713.png)

```js
// select features and update symbol
  function filter() {
    layer.filter(['>=', 'count', 200])
      .forEach(function (feature) {
        feature.updateSymbol([
          {
            'polygonFill': 'rgb(216,115,149)'
          }
        ]);
      });
  }
```

38. particle-layer

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210429163447729-11075040.gif)

```js
// An animated particle circle
  var particles = new maptalks.ParticleLayer('c', {
    'forceRenderOnMoving' : true
  });

  var center = map.getCenter();
  // circle's radius in meters
  var radius = 1000;

  particles.getParticles = function (t) {
    var point = map.coordinateToContainerPoint(center);
    // particle's angle at current time
    var angle = (t / 16 % 360) * Math.PI / 180;
    // convert distance in meter to pixel length
    var pxLen = map.distanceToPixel(radius, radius);
    var r = pxLen.width;
    // caculate pixel offset from circle's center
    var x = r * Math.cos(angle),
      y = r * Math.sin(angle);
    return [
      {
        point : point.add(x, y),
        r : 4,
        color : 'rgb(135,196,240)'
      }
    ];
  };

  map.addLayer(particles);
```

39. swipe map

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210429163614369-2105960898.png)

```js
var swipe = document.getElementById('swipe');

  var renderer = layer.getRenderer();
  var canvasGetter = renderer.getCanvasImage;
  //override renderer's default method to get layer canvas image
  renderer.getCanvasImage = function () {
    var dpr = map.getDevicePixelRatio();
    //original layer canvas image
    var layerImage = canvasGetter.call(renderer);
    if (!layerImage || !layerImage.image) {
      return layerImage;
    }
    //drawn width after layer is erased by swipper
    var ctx = renderer.context;
    var width = renderer.canvas.width * (swipe.value / 100);
    var height = ctx.canvas.height;

    //copy drawn rect of original layer canvas
    var drawnRect = document.createElement('canvas');
    drawnRect.width = width;
    drawnRect.height = ctx.canvas.height;
    drawnRect.getContext('2d').drawImage(layerImage.image, 0, 0);

    //clear the erased part
    ctx.clearRect(0, 0, ctx.canvas.width, ctx.canvas.height);
    //draw a white background to cover the bottom layers when zooming
    ctx.beginPath();
    ctx.rect(0, 0, width / dpr, height / dpr);
    ctx.fillStyle = '#fff';
    ctx.fill();

    //draw the drawn part on layer's canvas
    ctx.drawImage(drawnRect, 0, 0, width / dpr, height / dpr);
    layerImage.image = ctx.canvas;
    return layerImage;
  };

  swipe.addEventListener('input', function () {
    //let layer redraw self in the next frame
    layer.getRenderer().setToRedraw();
  });
```

40. image layer 

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210429163854375-292269522.png)

```js
var imageLayer = new maptalks.ImageLayer('images',
    [
      {
        url : '../../img/1.png',
        extent: [-0.11854216406254636, 51.50043810048564, -0.09081885168461667, 51.50994770979011],
        opacity : 1
      },
      {
        url : '../../img/2.png',
        extent: [-0.10343596289067136, 51.50797115663946, -0.07897421667485105, 51.51876102463089],
        opacity : 1
      }
    ]);
  map.addLayer(imageLayer);
```

