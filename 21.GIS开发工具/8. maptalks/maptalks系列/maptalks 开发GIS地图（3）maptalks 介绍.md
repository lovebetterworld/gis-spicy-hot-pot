- [maptalks 开发GIS地图（3）maptalks 介绍](https://www.cnblogs.com/googlegis/p/14718638.html)

21. flash-marker

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210429155600093-1800149757.png)

```js
function flash() {
    marker.flash(
      200,  //flash interval in ms
      5,    // count
      function () { // callback when flash end
        alert('flash ended');
      });
  }
```

22. filter-marker

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210429155533345-1571668138.png)

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210429155521808-1196772771.png)

```js
function filter() {
    // condition can be a mapbox filter or a function
    var filtered = collection.filter(['==', 'foo', 'polygon']);
    filtered.forEach(function (polygon) {
      polygon.updateSymbol({
        'polygonFill' : '#f00'
      });
    });
  }
```

23. image-marker

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210429155449749-192221821.png)

```js
var marker1 = new maptalks.Marker(
    center.sub(0.009, 0),
    {
        'symbol' : {
            'markerFile'   : '../../img/1.png',
            'markerWidth'  : 28,
            'markerHeight' : 40,
            'markerDx'     : 0,
            'markerDy'     : 0,
            'markerOpacity': 1
        }
    }
).addTo(layer);
```

24. vector-marker

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210429155432271-241202106.png)

```js
var marker1 = new maptalks.Marker(
    c.sub(0.020, 0),
    {
      'symbol' : {
        'markerType': 'ellipse',
        'markerFill': 'rgb(135,196,240)',
        'markerFillOpacity': 1,
        'markerLineColor': '#34495e',
        'markerLineWidth': 3,
        'markerLineOpacity': 1,
        'markerLineDasharray':[],
        'markerWidth': 40,
        'markerHeight': 40,
        'markerDx': 0,
        'markerDy': 0,
        'markerOpacity' : 1
      }
    }
  ).addTo(layer);
```

25.vector marker with gradient

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210429155352867-2088798364.png)

```js
var marker0 = new maptalks.Marker([-0.109049,51.49856], {
    symbol:{
        'markerType' : 'ellipse',
        'markerFill' : {
            'type' : 'linear',
            'places' : [0, 0, 1, 1],
            'colorStops' : [
                [0.00, '#fff'],
                [0.50, '#fff27e'],
                [1, '#f87e4b']
            ]
        },
        'markerLineWidth' : 0,
        'markerWidth' : 100,
        'markerHeight' : 100
    }
}).addTo(layer);
```

26. text-marker

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210429160831722-164783513.png)

```js
var text = new maptalks.Marker(
    [-0.113049, 51.49856],
    {
      'properties' : {
        'name' : 'Hello\nMapTalks'
      },
      'symbol' : {
        'textFaceName' : 'sans-serif',
        'textName' : '{name}',          //value from name in geometry's properties
        'textWeight'        : 'normal', //'bold', 'bolder'
        'textStyle'         : 'normal', //'italic', 'oblique'
        'textSize'          : 40,
        'textFont'          : null,     //same as CanvasRenderingContext2D.font, override textName, textWeight and textStyle
        'textFill'          : '#34495e',
        'textOpacity'       : 1,
        'textHaloFill'      : '#fff',
        'textHaloRadius'    : 5,
        'textWrapWidth'     : null,
        'textWrapCharacter' : '\n',
        'textLineSpacing'   : 0,

        'textDx'            : 0,
        'textDy'            : 0,

        'textHorizontalAlignment' : 'middle', //left | middle | right | auto
        'textVerticalAlignment'   : 'middle',   // top | middle | bottom | auto
        'textAlign'               : 'center' //left | right | center | auto
      }
    }
  ).addTo(layer);
```

27. ine-pattern-animation

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210429161150128-1215047376.gif)

```js
var line = new maptalks.LineString(
    [
      map.getCenter().sub(0.1, 0),
      map.getCenter().add(0.1, 0)
    ],
    {
      symbol:{
        'linePatternFile' : '../../img/pattern.png',
        'linePatternDx' : 0,
        'lineWidth' : 10
      }
    }
  ).addTo(layer);

  line.animate({
    symbol : {
      // 20 is the width of pattern.png to ensure seamless animation
      linePatternDx : 20
    }
  }, {
    repeat : true
  });
```

28. line-marker-autorotation

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210429161334682-834903472.png)

```js
var line = new maptalks.LineString(
    [
      [4.460010082031204, 50.41204897711654],
      [3.7129397695312036, 51.05869036408862],
      [3.2295413320312036, 51.20347195727524],
      [1.0872073476562036, 51.27225609350862],
      [-0.15424773046879636, 51.5053534272480]
    ],
    {
      symbol:{
        'lineColor' : '#1bbc9b',
        'lineWidth' : 3,
        'lineDasharray' : [10, 10],
        'markerFile'  : '../../img/plane.png',
        'markerPlacement' : 'vertex', //vertex, point, vertex-first, vertex-last, center
        'markerVerticalAlignment' : 'middle',
        'markerWidth'  : 30,
        'markerHeight' : 30
      }
    }
  ).addTo(layer);
```

29. polygon-gradient

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210429161456708-1579282271.png)

```js
var rect1 = new maptalks.Rectangle(
    c.sub(0.03, 0), 600, 600,
    {
      symbol:{
        'polygonFill' : {
          'type' : 'linear',
          'colorStops' : [
            [0.00, '#fff'],
            [0.50, '#fff27e'],
            [1, '#f87e4b']
          ]
        },
        'polygonOpacity' : 1,
        'lineColor' : '#fff'
      }
    }
  ).addTo(layer);

  var rect2 = new maptalks.Rectangle(
    c.sub(0.02, 0), 600, 600,
    {
      symbol:{
        'polygonFill' : {
          'type' : 'linear',
          'places' : [0, 0, 1, 1],
          'colorStops' : [
            [0.00, '#fff'],
            [0.50, '#fff27e'],
            [1, '#f87e4b']
          ]
        },
        'polygonOpacity' : 1,
        'lineColor' : '#fff'
      }
    }
  ).addTo(layer);

  var rect3 = new maptalks.Rectangle(
    c, 600, 600,
    {
      symbol:{
        'polygonFill' : {
          'type' : 'radial',
          'colorStops' : [
            [0.00, 'rgba(216,115,149,0)'],
            [0.50, 'rgba(216,115,149,1)'],
            [1.00, 'rgba(216,115,149,1)']
          ]
        },
        'polygonOpacity' : 1,
        'lineWidth' : 0
      }
    }
  ).addTo(layer);

  var rect4 = new maptalks.Rectangle(
    c.add(0.01, 0), 600, 600,
    {
      symbol:{
        'polygonFill' : {
          'type' : 'radial',
          'places' : [0.5, 0.5, 1, 1, 1, 0.1],
          'colorStops' : [
            [0.00, '#1bbc9b'],
            [0.55, 'rgb(135,196,240)'],
            [1.00, '#34495e']
          ]
        },
        'polygonOpacity' : 1,
        'lineColor' : '#fff'
      }
    }).addTo(layer);
```

30. composite-symbol

![img](https://img2020.cnblogs.com/blog/59231/202104/59231-20210429161602425-1674512860.png)

```js
var marker = new maptalks.Marker(
    map.getCenter(),
    {
      'symbol' : [
        {
          'markerType' : 'ellipse',
          'markerFill' : '#fff',
          'markerFillOpacity' : 1,
          'markerWidth' : 20,
          'markerHeight' : 20,
          'markerLineWidth' : 0
        },
        {
          'markerType' : 'ellipse',
          'markerFill' : '#1bc8ff',
          'markerFillOpacity' : 0.9,
          'markerWidth' : 55,
          'markerHeight' : 55,
          'markerLineWidth' : 0
        },
        {
          'markerType' : 'ellipse',
          'markerFill' : '#0096cd',
          'markerFillOpacity' : 0.8,
          'markerWidth' : 91,
          'markerHeight' : 91,
          'markerLineWidth' : 0
        },
        {
          'markerType' : 'ellipse',
          'markerFill' : '#0096cd',
          'markerFillOpacity' : 0.3,
          'markerWidth' : 130,
          'markerHeight' : 130,
          'markerLineWidth' : 0
        },
        {
          'markerType' : 'ellipse',
          'markerFill' : '#0096cd',
          'markerFillOpacity' : 0.2,
          'markerWidth' : 172,
          'markerHeight' : 172,
          'markerLineWidth' : 0
        }
      ]
    }
  ).addTo(layer);
```