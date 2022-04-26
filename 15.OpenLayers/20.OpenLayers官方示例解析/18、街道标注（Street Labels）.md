- [OpenLayers官方示例详解十八之街道标注（Street Labels）](https://blog.csdn.net/qq_35732147/article/details/85777954)



# 一、示例简介

    这个示例展示了设置placement:'line'的文本样式将沿路径渲染文本。

![img](https://img-blog.csdnimg.cn/20190104151651427.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1NzMyMTQ3,size_16,color_FFFFFF,t_70)

# 二、代码详解

```js
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Document</title>
    <link href="ol_v5.0.0/css/ol.css" rel="stylesheet" type="text/css" />
    <script src="ol_v5.0.0/build/ol.js" type="text/javascript"></script>
</head>
<body>
    <div id="map"></div>
 
    <script>
        var style = new ol.style.Style({
            text: new ol.style.Text({
                font: 'bold 11px "Open Sans", "Arial Unicode MS", "sans-serif"',
                placement: 'line',              // 标注设置为沿线方向排列
                fill: new ol.style.Fill({
                    color: 'white'
                })
            })
        });
 
        var viewExtent = [1817379, 6139595, 1827851, 6143616];
        var map = new ol.Map({
            target: 'map',
            layers: [
                new ol.layer.Tile({
                    source: new ol.source.BingMaps({
                        key: '你的Bing Map Key',
                        imagerySet: 'Aerial'
                    })
                }),
                new ol.layer.Vector({
                    declutter: true,
                    source: new ol.source.Vector({
                        format: new ol.format.GeoJSON(),
                        url: './data/vienna-streets.geojson'
                    }),
                    style: function(feature){       // 为每个要素设置样式
                        style.getText().setText(feature.get('name'));   
                        return style;
                    }
                })
            ],
            view: new ol.View({
                extent: viewExtent,     // 设置地图的视图范围，使用户不能见到这个范围以外的内容
                center: ol.extent.getCenter(viewExtent),  
                zoom: 17,
                minZoom: 14
            })
        });
    </script>
</body>
</html>
```