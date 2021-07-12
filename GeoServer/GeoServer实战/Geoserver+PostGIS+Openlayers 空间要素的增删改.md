# Geoserver+PostGIS+Openlayers 空间要素的增删改

原文地址：CSDN——rrrrroy_Ha：[Geoserver+PostGIS+Openlayers 空间要素的增删改](https://blog.csdn.net/rrrrroy_Ha/article/details/90904465?utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromMachineLearnPai2%7Edefault-1.base&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromMachineLearnPai2%7Edefault-1.base)



![img](https://img-blog.csdnimg.cn/20190606161415771.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3JycnJyb3lfSGE=,size_16,color_FFFFFF,t_70)

# 一、数据制作与发布

下面是一些gis基础，不想看的可以直接从分割线往下看。

在gis中数据按类型可分为点、线、面。

数据可以存放在数据库中，也可以存放在文件中。

- 数据库需要支持空间属性存储才行，比如oracle、postgresql、sqlserver，当然不能直连，需要一些“中间件”或插件，如：ArcSDE、postgis。
- 文件可以是shapefile（.shp格式，下称shp文件）、mdb、gdb、txt等。

只有相同类型的数据才可以放在一个表或文件中，比如线数据和面数据无法放在同一个shp文件中。

一般情况下，我们都会把相同类型、具有共同属性且被我们归为一类的数据放在同一个表或文件中。

一个数据库表或一个文件，在gis中又可称为一个图层。

# 二、点、线、面的增、删、改操作

## 2.1 创建shp文件

可以用Arcmap工具生成点、线、面文件，这里我们生成shp文件。

创建文件前，如果你要做三维数据的操作，那么你可以不用看这篇文章了。如果是二维数据操作，无论是新建或是有现成文件，请确保红框处未勾选，如果现成文件已勾选，请重新创建新文件并尝试将原文件数据导入。

![img](https://img-blog.csdnimg.cn/20190606162337433.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3JycnJyb3lfSGE=,size_16,color_FFFFFF,t_70)

随便做的数据如下

![img](https://img-blog.csdnimg.cn/20190606163836335.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3JycnJyb3lfSGE=,size_16,color_FFFFFF,t_70)

## 2.2 导入postgis

没有安装postgresql、postgis的可以看[postgresql+postgis安装、postgresql汉化](https://blog.csdn.net/rrrrroy_Ha/article/details/90751760)。

打开postgis的“postgis shapefile and dbf loader exporter”程序。

![img](https://img-blog.csdnimg.cn/20190606170506163.png)

点击“View connection details”，连接postgresql数据库。输入之前建好的数据库和用户名密码

![img](https://img-blog.csdnimg.cn/20190606170730975.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3JycnJyb3lfSGE=,size_16,color_FFFFFF,t_70)

![img](https://img-blog.csdnimg.cn/20190606170833444.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3JycnJyb3lfSGE=,size_16,color_FFFFFF,t_70)

连接成功后，logwindow会提示成功。

![img](https://img-blog.csdnimg.cn/20190606170936790.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3JycnJyb3lfSGE=,size_16,color_FFFFFF,t_70)

点击Options，勾选如下，点OK。

![img](https://img-blog.csdnimg.cn/2019060617104647.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3JycnJyb3lfSGE=,size_16,color_FFFFFF,t_70)

点击Add File，选择要导入的shp文件，可以多选。修改SRID，本图层采用的坐标系为WGS84，因此SRID为4326（postgis的SRID等同于arcgis里的wkid）。点击Import导入，可以看到log出现导入完毕提示。

![img](https://img-blog.csdnimg.cn/20190610100928900.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3JycnJyb3lfSGE=,size_16,color_FFFFFF,t_70)

导入线图层提示如上图。

导入点图层提示：

![img](https://img-blog.csdnimg.cn/20190610101050711.png)

导入面图层提示：

![img](https://img-blog.csdnimg.cn/2019061010110848.png)

依次导入其他数据后，就可以打开postgresql看到了。

![img](https://img-blog.csdnimg.cn/20190606172740177.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3JycnJyb3lfSGE=,size_16,color_FFFFFF,t_70)

## 2.3 将表发布到Geoserver中

登录Geoserver。

创建工作区，“命名”无所谓，只用于在geoserver内部使用，“命名空间URI”很重要（命名自己看着来吧）。

![img](https://img-blog.csdnimg.cn/20190606173017574.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3JycnJyb3lfSGE=,size_16,color_FFFFFF,t_70)

创建新的数据连接到postgis，根据红框输入postgis的连接信息即可，工作区选择上面创建的工作区。

![img](https://img-blog.csdnimg.cn/20190606173401773.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3JycnJyb3lfSGE=,size_16,color_FFFFFF,t_70)

![img](https://img-blog.csdnimg.cn/20190606173517925.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3JycnJyb3lfSGE=,size_16,color_FFFFFF,t_70)

发布图层，选择对应的数据源。

![img](https://img-blog.csdnimg.cn/20190606173610612.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3JycnJyb3lfSGE=,size_16,color_FFFFFF,t_70)

![img](https://img-blog.csdnimg.cn/20190606174237512.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3JycnJyb3lfSGE=,size_16,color_FFFFFF,t_70)

![img](https://img-blog.csdnimg.cn/20190606173710684.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3JycnJyb3lfSGE=,size_16,color_FFFFFF,t_70)

![img](https://img-blog.csdnimg.cn/20190606173736639.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3JycnJyb3lfSGE=,size_16,color_FFFFFF,t_70)

可能还需要设置这个：

![img](https://img-blog.csdnimg.cn/20190606173821111.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3JycnJyb3lfSGE=,size_16,color_FFFFFF,t_70)

设置完工作区、数据存储后，只需要重复发布图层的步骤即可，发布完成后，就可在layer preview里查看了。

![img](https://img-blog.csdnimg.cn/20190606174351844.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3JycnJyb3lfSGE=,size_16,color_FFFFFF,t_70)

# 三、代码

openlayers中要达到动态显示增删改效果，一定要选用WFS服务。

## 3.1 创建WFS服务的方法（以点图层为例）

```js
var pointSource = new ol.source.Vector({
    url: 'http://localhost:9010/geoserver/wfs?' +
         'service=WFS&' +
         'version=1.1.0&' +
         'request=GetFeature&' +
         'typeNames=postgis:point&' + // Here goes your-workspace:your-layer
         'outputFormat=json&' +
         'srsname=EPSG:4326',
    format: new ol.format.GeoJSON({
        geometryName: 'geom'//postgis的空间存储字段名
    })
});
var pointLayer = new ol.layer.Vector({
    // preload: Infinity,
    source: pointSource
});
```

## 3.2 公共增删改方法

```js
//transType为增删改类型
//feat为要增删改的要素
//layerName为要进行操作的目标图层名称
function transact(transType, feat, layerName) {
	if(layerName == ''){
		return;
	}
  var formatWFS = new ol.format.WFS();
  var formatGML = new ol.format.GML({
      featureNS: 'http://localhost/postgis', // Your namespace
      featureType: layerName, //此处填写图层名称
      gmlOptions:{srsName: 'EPSG:4326'}
  });
  switch (transType) {
      case 'insert':
          node = formatWFS.writeTransaction([feat], null, null, formatGML);
          break;
      case 'update':
          node = formatWFS.writeTransaction(null, [feat], null, formatGML);
          break;
      case 'delete':
          node = formatWFS.writeTransaction(null, null, [feat], formatGML);
          break;
  }
 
  s = new XMLSerializer();
  str = s.serializeToString(node);
  $.ajax('http://localhost:9010/geoserver/wfs',{
      type: 'POST',
      // dataType: 'xml',
      // processData: false,
      contentType: 'text/xml',
      data: str
  }).done();
 
}
```

## 3.3（新增）绘制的方法

```js
map.getInteractions().clear();
drawInteraction = new ol.interaction.Draw({
    source: pointSource,//上面创建的点图层数据源
    type: 'Point',//可选Point,LineString,Polygon
    geometryName: 'geometry',
    freehand:freemode//是否徒手模式
});
map.addInteraction(drawInteraction);
 
drawInteraction.on('drawend', function (e) {
    var geometry = e.feature.getGeometry().clone();
    // 设置feature对应的属性，这些属性是根据数据源的字段来设置的
    var newFeature = new ol.Feature();
    newFeature.setGeometryName('geom');//这里必须命名为postgis对应字段名
    newFeature.setGeometry(geometry);
    newFeature.set('id', 2);//这里可以设置其他属性
    
    transact('insert', newFeature, 'point');
});
```

“applyTransform”方法其实是将横纵坐标颠倒，原理还不清楚（猜测是geoserver要求），通过查看控制台，很直观的看到输入：

![img](https://img-blog.csdnimg.cn/20190606182837846.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3JycnJyb3lfSGE=,size_16,color_FFFFFF,t_70)

目前只有编辑需要调换这一步骤。

删除的方法：

```js
map.getInteractions().clear();
var select = new ol.interaction.Select();
map.addInteraction(select);
select.on('select', function (e) {
    if(select.getFeatures().getLength() == 0) {
        console.log('null');
    } else {
        var f;
        f = pointSource.getFeatureById(e.target.getFeatures().getArray()[0].getId());
        pointSource.removeFeature(f);
        e.target.getFeatures().clear();
        transact('delete', f, 'point');
    }
});
```

## 3.4 全部代码

### 3.4.1 html

```html
<!DOCTYPE html>
<html>
<head>
	<title></title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="v5.2.0/css/ol.css" type="text/css">
	<script src="v5.2.0/build/ol.js"></script>
	<script src="js/jquery-3.3.1.min.js"></script>
</head>
<body>
	<div id="map" class="map"></div>
	<div style="position: absolute;top: 50px;left: 50px;">
		<input id="draw-tool" type="checkbox" value="add" />新增
		<select id="selectType">
			<option value="line">线</option>
			<option value="point">点</option>
			<option value="polygon">面</option>
		</select>
		徒手模式:<select id="drawMode">
			<option value="true">是</option>
			<option value="false">否</option>
		</select>
 
		<hr>
		<input type="checkbox" value="modify" id="modify-tool" />编辑
		<hr>
 
		<input type="button" value="删除选中Feature" id="delete-tool" />
 
		  <!-- <input type="button" value="保存"/> -->
	</div>
	<script type="text/javascript" src="js/editTool.js"></script>
</body>
</html>
```

### 3.4.2 editTool.js

```js
 
var drawInteraction;
 
// // 创建ImageWMS数据源
// var wmsSource = new ol.source.TileWMS({
//   url: 'http://localhost:9010/geoserver/postgis/wms',
//   params: {'LAYERS': 'postgis:sishui'},
//   serverType: 'geoserver',
//   projection: "EPSG:4326"
// });
 
// // 创建Image图层
// var wmsLayer = new ol.layer.Tile({
//   source: wmsSource
// });
 
var pointSource = new ol.source.Vector({//点数据源
    url: 'http://localhost:9010/geoserver/wfs?' +
         'service=WFS&' +
         'version=1.1.0&' +
         'request=GetFeature&' +
         'typeNames=postgis:point&' + // Here goes your-workspace:your-layer
         'outputFormat=json&' +
         'srsname=EPSG:4326',
    format: new ol.format.GeoJSON({geometryName: 'geom'})
});
 
var polygonSource = new ol.source.Vector({//面数据源
    url: 'http://localhost:9010/geoserver/wfs?' +
	    'service=wfs&' +
	    'version=1.1.0&' +
	    'request=GetFeature&' +
	    'typeNames=postgis:sishui&' + // Here goes your-workspace:your-layer
	    'outputFormat=application/json&' +
	    'srsname=EPSG:4326',
    format: new ol.format.GeoJSON({
        geometryName: 'geom' // 将shp格式矢量文件导入PostgreGIS数据库中，对应的表中增加了一个字段名为geom的字段，所有这里的名称就是数据库表中增加的那个字段名称
    })
});
var lineSource = new ol.source.Vector({//线数据源
    url: 'http://localhost:9010/geoserver/wfs?' +
	    'service=WFS&' +
	    'version=1.1.0&' +
	    'request=GetFeature&' +
	    'typeNames=postgis:road&' + // Here goes your-workspace:your-layer
	    'outputFormat=application/json&' +
	    'srsname=EPSG:4326',
    format: new ol.format.GeoJSON({geometryName: 'geom'})
});
var pointLayer = new ol.layer.Vector({//点图层
    // preload: Infinity,
    source: pointSource
});
var polygonLayer = new ol.layer.Vector({//面图层
    // preload: Infinity,
    source: polygonSource
});
var lineLayer = new ol.layer.Vector({//线图层
    preload: Infinity,
    source: lineSource
});
var view = new ol.View({
  center: [117.331,35.647],
  zoom: 11,
  projection:"EPSG:4326"
});
var map = new ol.Map({
  layers: [new ol.layer.Tile({//加载open street map
    source:new ol.source.OSM()
	})],
  target: 'map',
  view: view
});
map.addLayer(lineLayer);
map.addLayer(polygonLayer);
map.addLayer(pointLayer);
 
 
//重选绘制类型时，清空所有的操作工具
$('#selectType').change(function () {
    map.getInteractions().clear();
});
//根据选择的绘制类型，动态返回绘图工具类型和数据源
function defineType() {
    var geom_type;
    var geom_source;
    switch($('#selectType').val()) {
        case 'polygon':
            geom_type = 'Polygon';
            geom_source = polygonSource;
            return [geom_type, geom_source];
        case 'line':
            geom_type = 'LineString';
            geom_source = lineSource;
            return [geom_type, geom_source];
        case 'point':
            geom_type = 'Point';
            geom_source = pointSource;
            return [geom_type, geom_source];
        default:
            console.log('Nothing selected!!!');
    }
}
//返回是否是徒手模式
function freeMode(){
	switch($('#drawMode').val()){
		case 'true':
			return true;
		case 'false':
			return false;
		default:
            console.log('Nothing selected!!!');
	}
}
//新增按钮点击事件
$('#draw-tool').click(function () {
	if(this.checked){
        var type = defineType()[0];//当前要绘制的是点？线？面？
        var source = defineType()[1];//对应的数据源
        var freemode = freeMode();//是否徒手模式
        map.getInteractions().clear();
        drawInteraction = new ol.interaction.Draw({
            source: source,
            type: type,
            geometryName: 'geometry',//这里必须是geometry，不能提前定义成geom
            freehand:freemode
        });
        map.addInteraction(drawInteraction);
 
        drawInteraction.on('drawend', function (e) {//绘制完成
            var layerName = '';
            var geometry = e.feature.getGeometry().clone();
 
            // 设置feature对应的属性，这些属性是根据数据源的字段来设置的
            var newFeature = new ol.Feature();
 
            if(defineType()[0]=='LineString'){
                newFeature.setGeometryName('geom');
                // newFeature.set('geom', null);
                // newFeature.setGeometry(new ol.geom.MultiLineString([geometry.getCoordinates()]));
                newFeature.setGeometry(geometry);
                newFeature.set('id', 2);
                // newFeature.setId('road.'+1);
                layerName = 'road';
            }else if(defineType()[0]=='Polygon'){
                newFeature.setGeometryName('geom');
                // newFeature.set('geom', null);
                // newFeature.setGeometry(new ol.geom.MultiPolygon([geometry.getCoordinates()]));
                newFeature.setGeometry(geometry);
                newFeature.set('id', 2);
                // newFeature.setId('sishui.'+1);
                layerName = 'sishui';
            }else if(defineType()[0]=='Point'){
                newFeature.setGeometryName('geom');
                // newFeature.set('geom', null);
                // newFeature.setGeometry(new ol.geom.MultiPoint([geometry.getCoordinates()]));
                newFeature.setGeometry(geometry);
                newFeature.set('id', 2);
                // newFeature.setId('point.'+1);
                layerName = 'point';
            }
            transact('insert', newFeature, layerName);
        });
	}else{
		map.removeInteraction(drawInteraction);
    // if (drawedFeature) {
    //   drawLayer.getSource().removeFeature(drawedFeature);
    // }
    // drawedFeature = null;
	}
});
 
//Modify
$('#modify-tool').click(function () {
    map.getInteractions().clear();
    var select = new ol.interaction.Select();
    var modify = new ol.interaction.Modify({
        features: select.getFeatures()
    });
    map.addInteraction(select);
    map.addInteraction(modify);
 
    modify.on('modifyend', function (e) {
        var layerName = '';
 
        var feature = e.features.item(0).clone();
        feature.setId(e.features.item(0).getId());
        var geomType = feature.getGeometry().getType().toLowerCase();//openlayers绘制类型
        if(geomType=='linestring'){
        	layerName = 'road';
        }else if(geomType=='polygon'){
            layerName = 'sishui';
        }else if(geomType=='point'){
            layerName = 'point';
		}
        // 调换经纬度坐标，以符合wfs协议中经纬度的位置
        feature.getGeometry().applyTransform(function(flatCoordinates, flatCoordinates2, stride) {
            for (var j = 0; j < flatCoordinates.length; j += stride) {
                var y = flatCoordinates[j];
                var x = flatCoordinates[j + 1];
                flatCoordinates[j] = x;
                flatCoordinates[j + 1] = y;
            }
        });
        transact('update',feature, layerName);
    });
 
});
 
//Delete
$('#delete-tool').click(function () {
    map.getInteractions().clear();
    var select = new ol.interaction.Select();
    map.addInteraction(select);
    select.on('select', function (e) {
        if(select.getFeatures().getLength() == 0) {
            console.log('null');
        } else {
            var geomType = e.target.getFeatures().getArray()[0].getGeometry().getType().toLowerCase();
            //var geomType = e.target.getFeatures().item(0).getGeometry().getType().toLowerCase();//getArray()[0]和item(0)均可
            var layerName = '';
            var f;
            switch(geomType) {
                case 'polygon':
                    layerName = 'sishui';
                    f = polygonSource.getFeatureById(e.target.getFeatures().getArray()[0].getId());
                    polygonSource.removeFeature(f);
                    e.target.getFeatures().clear();
                    break;
                case 'linestring':
                    layerName = 'road';
                    f = lineSource.getFeatureById(e.target.getFeatures().getArray()[0].getId());
                    lineSource.removeFeature(f);
                    e.target.getFeatures().clear();
                    break;
                case 'point':
                    layerName = 'point';
                    f = pointSource.getFeatureById(e.target.getFeatures().getArray()[0].getId());
                    pointSource.removeFeature(f);
                    e.target.getFeatures().clear();
                    break;
                default:
                    console.log('Type of feature unknown!!!');
            }
            transact('delete', f, layerName);
        }
    });
});
/** -------------------------------------------- */
 
function transact(transType, feat, layerName) {
	if(layerName == ''){
		return;
	}
  var formatWFS = new ol.format.WFS();
  var formatGML = new ol.format.GML({
      featureNS: 'http://localhost/postgis', // Your namespace
      featureType: layerName,
      gmlOptions:{srsName: 'EPSG:4326'}
  });
  switch (transType) {
      case 'insert':
          node = formatWFS.writeTransaction([feat], null, null, formatGML);
          break;
      case 'update':
          node = formatWFS.writeTransaction(null, [feat], null, formatGML);
          break;
      case 'delete':
          node = formatWFS.writeTransaction(null, null, [feat], formatGML);
          break;
  }
 
  s = new XMLSerializer();
  str = s.serializeToString(node);
  $.ajax('http://localhost:9010/geoserver/wfs',{
      type: 'POST',
      // dataType: 'xml',
      // processData: false,
      contentType: 'text/xml',
      data: str
  }).done();
 
}
```

# 易错点

## 导入shp文件时，一定要检查是否带Z值！

如果导入带Z值的文件，导入日志会发现type:PolygonZ。

![img](https://img-blog.csdnimg.cn/20190612174817847.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3JycnJyb3lfSGE=,size_16,color_FFFFFF,t_70)

调用时会发现，这都是些啥？通过控制台可以看到，数据变成了3维数组，但截取的过程中发生了什么问题，导致数据乱了。

![img](https://img-blog.csdnimg.cn/20190612175124315.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3JycnJyb3lfSGE=,size_16,color_FFFFFF,t_70)

这是正常的：

![img](https://img-blog.csdnimg.cn/20190612181654960.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3JycnJyb3lfSGE=,size_16,color_FFFFFF,t_70)

## 导入时，最好要在Options中勾选最后一个，导入时内部会自动将MULTI 类型转成Simple类型，会使得代码相对简单。当然也可以不勾选。如果未勾选，在导入时log下会提示PostGIS type:【MULTI】xxx，可以区分出来。

![img](https://img-blog.csdnimg.cn/20190606171407737.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3JycnJyb3lfSGE=,size_16,color_FFFFFF,t_70)

如果导入的是【MULTI】xxx类型，原有的代码将不能成功运行（参考如下新增的代码片段）：

```java
// newFeature.setGeometry(new ol.geom.MultiLineString([geometry.getCoordinates()]));
newFeature.setGeometry(geometry);
```

在geoserver/logs/wrapper.log文件中可以看到提示，提示插入要素错误，原因类型不匹配（错误一大串，需要往下翻才看到）。

![img](https://img-blog.csdnimg.cn/20190612174241520.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3JycnJyb3lfSGE=,size_16,color_FFFFFF,t_70)

此时，就要用被注掉的代码，用这种方式新增。

```js
newFeature.setGeometry(new ol.geom.MultiLineString([geometry.getCoordinates()]));
```

## 注意区分Openlayers和PostGIS中点、线、面类型的名称

在Openlayers中为Point、LineString、Polygon。

在PostGIS返回的数据类型中为point、linestring、polygon（如果是multi类型的，好像是multilinestring）。

## 代码新增数据时，一定要设置新feature的geometry名称

```js
newFeature.setGeometryName('geom');//geom为postgis表的控件属性存储字段名称
newFeature.setGeometry(geometry);
```

否则会发现，控制台中拼装的是<geometry>，而geoserver识别的是geom，得到null。

![img](https://img-blog.csdnimg.cn/20190612183434558.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3JycnJyb3lfSGE=,size_16,color_FFFFFF,t_70)

![img](https://img-blog.csdnimg.cn/20190612183651387.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3JycnJyb3lfSGE=,size_16,color_FFFFFF,t_70)

## 代码创建点线面数据源时，一定设置format

![img](https://img-blog.csdnimg.cn/20190612182437469.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3JycnJyb3lfSGE=,size_16,color_FFFFFF,t_70)

否则会在编辑、删除时报错。应识别的属性为geom，然而默认是geometry，各位也可以仿照新增，单独设置geometryName，在source设置一劳永逸罢了。

![img](https://img-blog.csdnimg.cn/20190612184138944.png)

![img](https://img-blog.csdnimg.cn/20190612184221419.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3JycnJyb3lfSGE=,size_16,color_FFFFFF,t_70)



参考文档：

- [geoserver+postGIs+openlayer 空间要素的增删改查](https://blog.csdn.net/u010878640/article/details/87623871)

- [Openlayers进行WFS-T操作完整代码](https://blog.csdn.net/shaxiaozilove/article/details/61623129)

- [使用Openlayer利用GeoServer编辑要素到postGIS注意问题（WFS-T）](https://blog.csdn.net/shaxiaozilove/article/details/61619388)

- [Openlayers-3 WFS-T (Post feature to postgis via geoserver)](https://stackoverflow.com/questions/30440460/openlayers-3-wfs-t-post-feature-to-postgis-via-geoserver)

- https://download.csdn.net/download/u010878640/10963127