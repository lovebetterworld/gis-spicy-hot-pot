- [OpenLayers教程：图形绘制之设置图形的样式](https://blog.csdn.net/qq_35732147/article/details/97764760)



OpenLayers可以对整个矢量图层统一设置样式，也可以单独对某个要素设置样式，本文介绍对整个矢量图层设置样式。

OpenLayers的ol.style.Style类用于设置样式，它需要结合另外三个类ol.style.Image、ol.style.Stroke、ol.style.fill分别设置点或圆的样式、边界线的样式、填充样式，另外ol.style.Text类用于设置要素注记。

![img](https://img-blog.csdnimg.cn/20190730114314507.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

来看示例：

样式效果：

![img](https://img-blog.csdnimg.cn/20190730114206624.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

graphicStyle.html:

```js
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>设置几何图形样式</title>
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
            source: vectorSource,
            // 设置图层样式
            style: new ol.style.Style({
                // 将点设置成圆形样式
                image: new ol.style.Circle({
                    // 点的颜色
                    fill: new ol.style.Fill({
                        color: '#F00'
                    }),
                    // 圆形半径
                    radius: 5
                }),
                // 线样式
                stroke: new ol.style.Stroke({
                    color: '#0F0',
                    lineCap: 'round',       // 设置线的两端为圆头
                    width: 5                
                }),
                // 填充样式
                fill: new ol.style.Fill({
                    color: '#00F'
                })
            })
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
                console.log(type);
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