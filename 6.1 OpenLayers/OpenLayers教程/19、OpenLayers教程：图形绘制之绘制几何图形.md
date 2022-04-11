- [OpenLayers教程：图形绘制之绘制几何图形](https://blog.csdn.net/qq_35732147/article/details/97556260)



OpenLayers的ol.interaction.Draw类实现了交互式绘制几何图形的功能，可以把它看作一个绘制图形的控件，使用合适的参数初始化它，并将它加入地图对象就可以进行交互式的图形绘制。

我们直接来看一个示例：

![img](https://img-blog.csdnimg.cn/20190727212626151.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

drawShapes.html:

```js
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Draw Shapes</title>
    <link rel="stylesheet" href="../v5.3.0/css/ol.css" />
    <script src="../v5.3.0/build/ol.js"></script>
</head>
<body>
    <div id="map"></div>
    <label>Shape type &nbsp;</label>
    <select id="type">
        <option value="Point">Point</option>
        <option value="LineString">LineString</option>
        <option value="Polygon">Polygon</option>
        <option value="Circle">Circle</option>
        <option value="Square">Square</option>
        <option value="Box">Box</option>
        <option value="None">None</option>
    </select>
 
    <script>
        let vectorSource = new ol.source.Vector();
        let vectorLayer = new ol.layer.Vector({
            source: vectorSource
        });
 
        let map = new ol.Map({
            target: 'map',                          
            layers: [
                new ol.layer.Tile({                 // 瓦片图层
                    source: new ol.source.OSM()     // OpenStreetMap数据源
                }),
                vectorLayer
            ],
            view: new ol.View({                     // 地图视图
                projection: 'EPSG:3857',
                center: [0, 0],
                zoom: 0
            })
        });
        let typeSelect = document.getElementById('type');
        let draw;
        function addInteraction(){
            let type = typeSelect.value;
            if(type !== 'None'){
                let geometryFunction;
                switch(type){   
                    case "Square": 
                        type = 'Circle';
                        // 生成规则的四边形的图形函数
                        geometryFunction = ol.interaction.Draw.createRegularPolygon(4);
                        break;
                    case 'Box':
                        type = 'Circle';
                        // 生成盒形状的图形函数
                        geometryFunction = ol.interaction.Draw.createBox();
                        break;
                    default:break;
                }
                
                // 初始化Draw绘图控件
                draw = new ol.interaction.Draw({
                    source: vectorSource,
                    type: type,
                    geometryFunction: geometryFunction
                });
                // 将Draw绘图控件加入Map对象
                map.addInteraction(draw);
            }
        }
 
        typeSelect.addEventListener('change', () => {
            // 移除Draw绘图控件
            map.removeInteraction(draw);
            addInteraction();
        });
 
        addInteraction();
    </script>
</body>
</html>
```

这个示例展示了初始化ol.interaction.Draw对象时设置的三个参数：

- source     ——    绘制的几何图形将会被存储到这个地图源中
- type    ——    要绘制的几何图形的类型，可以设置为：'Point', 'LineString', 'LinearRing', 'Polygon', 'MultiPoint', 'MultiLineString', 'MultiPolygon', 'GeometryCollection', 'Circle'
- geometryFunction —— 这个参数可以比较自由地设置要绘制的几何图形的形状，比如这个示例中使用createBox()和createRegularPolygon()这两个函数来生成特定的图形函数，以代替绘制圆，但是使用这两个函数必须要将type参数设置为'Circle'

 另外，还可以按住键盘的Shift键来触发手绘（free hand)模式，Draw类实现了这个功能。
