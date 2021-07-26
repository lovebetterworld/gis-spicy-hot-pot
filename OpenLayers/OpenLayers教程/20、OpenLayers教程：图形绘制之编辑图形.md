- [OpenLayers教程：图形绘制之编辑图形](https://blog.csdn.net/qq_35732147/article/details/97938480)



除了能够交互式地绘制几何图形，OpenLayers还支持我们编辑已经绘制的几何图形。

ol.interaction.Modify类封装了编辑图形的功能，只要将它初始化作为交互控件加入Map对象，就可以对几何图形进行动态编辑。

来看示例：

![img](https://img-blog.csdnimg.cn/20190731173535414.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

editGraphic.html:

```js
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>编辑图形</title>
    <link rel="stylesheet" href="../v5.3.0/css/ol.css" />
    <script src="../v5.3.0/build/ol.js"></script>
</head>
<body>
    <div id="map"></div>
    <form>
        <label>Geometry type &nbsp;</label>
        <select id="type">
          <option value="Point">Point</option>
          <option value="LineString">LineString</option>
          <option value="Polygon">Polygon</option>
          <option value="Circle">Circle</option>
        </select>
    </form>
 
    <script>
        // 矢量地图源
        let vectorSource = new ol.source.Vector();
        // 矢量地图
        let vectorLayer = new ol.layer.Vector({
            source: vectorSource
        });
 
        // 初始化地图
        let map = new ol.Map({
            target: 'map',
            layers: [
                new ol.layer.Tile({
                    source: new ol.source.OSM()
                }),
                vectorLayer
            ],
            view: new ol.View({
                center: [0, 0],
                zoom: 5
            })
        });
 
        // 创建一个Modify控件
        let modify = new ol.interaction.Modify({
            source: vectorSource
        });
        // 将Modify控件加入到Map对象中
        map.addInteraction(modify);
 
        let draw, snap;
        let typeSelect = document.getElementById('type');
 
        function addInteractions(){
            // 创建一个Draw控件，并加入到Map对象中
            draw = new ol.interaction.Draw({
                source: vectorSource,
                type: typeSelect.value
            });
            map.addInteraction(draw);
 
            // 创建一个Snap控件，并加入到Map对象中
            snap = new ol.interaction.Snap({
                source: vectorSource
            });
            map.addInteraction(snap);
        }
 
        typeSelect.addEventListener('click', () => {
            // 移除Draw控件和Snap控件
            map.removeInteraction(draw);
            map.removeInteraction(snap);
            addInteractions();
        });
 
        addInteractions();
    </script>
</body>
</html>
```
创建Modify控件时，需要指定source参数来指定可以对哪些地图源进行图形编辑。

像Map对象中加入Modify控件后，就可以使用鼠标对已绘制的图形进行编辑。除了可以用鼠标拖拽图形节点外，也可以使用鼠标拖拽直线，这将会拖拽出新的节点。如果想删除某个节点，只需要按住键盘的Alt键，然后鼠标点击该节点即可。

这个示例同时加入了捕捉的功能，ol.interaction.Snap控件封装了图形捕捉的功能，将鼠标光标靠近图形就会触发捕捉功能。