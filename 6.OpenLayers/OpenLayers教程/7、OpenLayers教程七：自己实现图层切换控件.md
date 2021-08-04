- [OpenLayers教程七：自己实现图层切换控件](https://blog.csdn.net/qq_35732147/article/details/94383578)



OpenLayers并没有封装图层切换的控件，所以我们需要自己来实现图层控件。

自定义图层切换控件的原理很简单：显示某个图层时，将其他图层隐藏。

完整代码：

layerSwitch.html:

```js
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>图层切换控件</title>
    <link rel="stylesheet" href="../v5.3.0/css/ol.css" />
    <script src="../v5.3.0/build/ol.js"></script>
</head>
<body>
    <div id="controls">
        <input type="checkbox" id="osm" checked />OpenStreetMap
        <input type="checkbox" id="bingmap" />Bing Map
        <input type="checkbox" id="stamen" />Stamen Map
    </div>
    <div id="map"></div>
 
    <script>
        let map = new ol.Map({
            target: 'map',                          // 关联到对应的div容器
            layers: [
                new ol.layer.Tile({                 // OpenStreetMap图层
                    source: new ol.source.OSM()     
                }),
                new ol.layer.Tile({                 // Bing Map图层
                    source: new ol.source.BingMaps({
                        key: '略',    // 可以自行到Bing Map官网申请key
                        imagerySet: 'Aerial'
                    }),
                    visible: false                  // 先隐藏该图层
                }),
                new ol.layer.Tile({
                    source: new ol.source.Stamen({
                        layer: 'watercolor'
                    }),
                    visible: false                  // 先隐藏该图层
                })
            ],
            view: new ol.View({                     // 地图视图
                projection: 'EPSG:3857',
                center: [0, 0],
                zoom: 0
            })
        });
 
        let controls = document.getElementById('controls');     
        // 事件委托
        controls.addEventListener('click', (event) => {
            if(event.target.checked){                       // 如果选中某一复选框
                // 通过DOM元素的id值来判断应该对哪个图层进行显示
                switch(event.target.id){
                    case "osm": 
                        map.getLayers().item(0).setVisible(true);
                        break;
                    case "bingmap":
                        map.getLayers().item(1).setVisible(true);
                        break;
                    case "stamen": 
                        map.getLayers().item(2).setVisible(true);
                        break;
                    default: break;
                }
            }else{                                         // 如果取消某一复选框
                // 通过DOM元素的id值来判断应该对哪个图层进行隐藏
                switch(event.target.id){
                    case "osm": 
                        map.getLayers().item(0).setVisible(false);
                        break;
                    case "bingmap":
                        map.getLayers().item(1).setVisible(false);
                    case "stamen": 
                        map.getLayers().item(2).setVisible(false);
                    default: break;
                }
            } 
        });
    </script>
</body>
</html>
```
实现效果：

![img](https://img-blog.csdnimg.cn/20190701120452933.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

代码整体逻辑是很简单的，其中使用了事件委托这一机制来绑定事件，事件委托可以减少事件绑定导致的内存消耗，所以平时开发时推荐多使用事件委托。

另外，map.getLayers()返回一个ol.Collection类的对象，该对象中包含了地图中的三个图层对象（ol.layer.Tile），可以为item()方法传入对应索引来取出对应图层对象。

最后，ol.layer.Tile类的setVisible()方法可以设置图层的显示与隐藏。