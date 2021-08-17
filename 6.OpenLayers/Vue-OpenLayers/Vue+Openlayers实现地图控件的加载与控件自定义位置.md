- [Vue+Openlayers实现地图控件的加载与控件自定义位置](https://blog.csdn.net/Oruizn/article/details/111401372)



# 1、Openlayers自带的地图控件介绍与展示

注意：括号中的英文名称链接到控件的API文档。由于每个控件比较零散，所以把代码全部放在最后面的controls.js文件中，读者请根据注释对应

- 地图基本信息控件[(Attribution)](https://openlayers.org/en/latest/apidoc/module-ol_control_Attribution-Attribution.html)：显示地图资源的版权信息

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201219165724910.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L09ydWl6bg==,size_16,color_FFFFFF,t_70#pic_center)

- 地图全屏显示控件[(FullScreen)](https://openlayers.org/en/latest/apidoc/module-ol_control_FullScreen-FullScreen.html)：在浏览器中全屏显示地图，按esc退出全屏

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201219170301120.png#pic_center)

![img](https://img-blog.csdnimg.cn/2020121917034719.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L09ydWl6bg==,size_16,color_FFFFFF,t_70#pic_center)

- 鼠标位置控件[(MousePosition)](https://openlayers.org/en/latest/apidoc/module-ol_control_MousePosition-MousePosition.html)：实时显示鼠标当前的坐标



![在这里插入图片描述](https://img-blog.csdnimg.cn/20201219170822771.png#pic_center)


 对于位置覆盖的控件，可以查看第三小节了解如何调整位置

- 地图鹰眼拖拽控件[(OverviewMap)](https://openlayers.org/en/latest/apidoc/module-ol_control_OverviewMap-OverviewMap.html)：用户拖拽鹰眼图中的小矩形，主图显示对应的区域

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201219171142765.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L09ydWl6bg==,size_16,color_FFFFFF,t_70#pic_center)

- 地图比例尺控件[(ScaleLine)](https://openlayers.org/en/latest/apidoc/module-ol_control_ScaleLine-ScaleLine.html)：显示当前的地图比例尺

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201219172238678.png#pic_center)

- 地图缩放按钮控件[(Zoom)](https://openlayers.org/en/latest/apidoc/module-ol_control_Zoom-Zoom.html)：点击+/-，实现放大和缩小显示等级

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201219172353484.png#pic_center)

- 地图缩放拉条控件[(ZoomSlider)](https://openlayers.org/en/latest/apidoc/module-ol_control_ZoomSlider-ZoomSlider.html)：通过拉动条位置，实现实现放大和缩小显示等级

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201219172707928.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L09ydWl6bg==,size_16,color_FFFFFF,t_70#pic_center)

- 地图指定范围跳转控件[(ZoomToExtent)](https://openlayers.org/en/latest/apidoc/module-ol_control_ZoomToExtent-ZoomToExtent.html)不常用：移动到指定范围的位置

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201219172945512.png#pic_center)

# 2、Openlayers-Extension提供的地图控件介绍与展示

- 图层切换控件(LayerSwitch)：用于控制图层显示与否，可以拖拽图层移动到顶层

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201219174402404.png#pic_center)

- WMS加载控件(WMSCapabilities)：在线搜索与加载wms地图数据

![在这里插入图片描述](https://img-blog.csdnimg.cn/2020121917434470.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L09ydWl6bg==,size_16,color_FFFFFF,t_70#pic_center)

- 地图鹰眼点击控件(Overview)：点击鹰眼图上的位置，然后主图平移到对应的位置

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201219180110898.png#pic_center)

- 地球鹰眼转动控件(Globle)：移动主图后在地球鹰眼图同时定位显示

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201219204347982.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L09ydWl6bg==,size_16,color_FFFFFF,t_70#pic_center)

- 地图书签标记控件(GeoBookMark)：为当前的界面添加界面，点击书签名字自动切换到对应界面

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201219180637935.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L09ydWl6bg==,size_16,color_FFFFFF,t_70#pic_center)

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201219180900769.png#pic_center)

- 屏幕滑动对比控件(Swipe)：中间的控件可以拉动，类似帘子效果，有水平模式与垂直模式

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201219181353116.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L09ydWl6bg==,size_16,color_FFFFFF,t_70#pic_center)

- 地图工具栏控件(ControlBar)：将相关性比较高控件整合为一个工具栏

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201219210236968.png#pic_center)

- 地图界面打印控件(Print))：将当前的地图页面进行下载，省去用其他工具截图，而且更加清晰。需要依赖file-saver库。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201219214050514.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L09ydWl6bg==,size_16,color_FFFFFF,t_70#pic_center)

- 地图中心控件(Target)：显示地图的中心

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201219224049208.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L09ydWl6bg==,size_16,color_FFFFFF,t_70#pic_center)

- 图例控件(Legend)：用于显示图层的图例信息

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201219224345584.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L09ydWl6bg==,size_16,color_FFFFFF,t_70#pic_center)

# 3、地图控件位置调整

以上介绍了那么多控件，总有一些控件会重叠在一起，如果此时我们都需要这些控件的话，就需要调整控件的位置(上图的OverviewMap 与 Legend 控件就重叠在一起了)。下面以调整Legend控件到右边为例，介绍如何通过CSS文件调整控件的位置。

- 在src/assets下新建一个文件夹scss并创建一个scss文件

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201219230410665.png#pic_center)

- 针对控件编写CSS样式

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201219230607484.png#pic_center)

- 引入到BaseMap.vue文件中

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201219230655585.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L09ydWl6bg==,size_16,color_FFFFFF,t_70#pic_center)

- 通过className引入自定义的类样式，调整放置位置。注意：需要在控件原样式之前添加我们自己定义的样式

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201219230757491.png#pic_center)

- 调整结果

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201219230915500.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L09ydWl6bg==,size_16,color_FFFFFF,t_70#pic_center)

## 4、相关源码

目前相关文件已经上传至[GitHub](https://github.com/oruizn/webgisv2)中，请需要的同学自行clone学习。
 controls.js

```js
/**
 * 地图控件
 * 方便使用
 */
import {
  OverviewMap,
  ZoomSlider,
  Zoom,
  ScaleLine,
  FullScreen,
  Attribution,
  MousePosition,
  ZoomToExtent, Rotate
} from 'ol/control';
import {defaults} from 'ol/control';
import Baselayers from "@c/js/baselayers";
import {createStringXY} from "ol/coordinate";
import Legend from 'ol-ext/control/Legend';
import LayerSwitcher from 'ol-ext/control/LayerSwitcher';
import WMSCapabilities from "ol-ext/control/WMSCapabilities";
import Overview from "ol-ext/control/Overview";
import GeoBookmark from "ol-ext/control/GeoBookmark";
import Swipe from "ol-ext/control/Swipe";
import Globe from "ol-ext/control/Globe";
import Bar from "ol-ext/control/Bar";
import Print from "ol-ext/control/Print";
import Compass from "ol-ext/control/Compass";
import Target from "ol-ext/control/Target";
import {Style, Fill, Text} from "ol/style";

/**
 * ol 自带控件
 */
export const controls = {
  // 鹰眼图
  overview: new OverviewMap({
    collapsed: true,
    layers: [
      //ol6版本需要开发者设置一个新的地图资源，而ol5版本直接显示主图的缩略图
      Baselayers.OSMLayer(true, true)//ol6需要设置图层，ol5不需要
    ]
  }),
  // 缩放滑块
  zoomSlider: new ZoomSlider({
    duration: 800
  }),
  // 缩放按钮
  // className: 'control-right'
  zoom: new Zoom({
    duration: 800,
  }),
  // 比例尺
  scale: new ScaleLine({
    className: 'scale-left ol-scale-line'
  }),
  // 旋转
  rotate: new Rotate({

  }),
  // 地图版权
  attr: new Attribution({
    //该控件自动绑定网络地图的相关信息，如果没有提供则不显示
    //默认信息是收起状态，点击后显示
    className: 'attr-right ol-attribution'
  }),
  // 鼠标位置
  mousePosition: new MousePosition({
    coordinateFormat: createStringXY(4),
    projection: 'EPSG:4326',
    undefinedHTML: '&nbsp'
  }),
  // 地图全屏
  fullScreen: new FullScreen({

  }),
  zoomToExtend: new ZoomToExtent({
    //不设置时显示全图
  }),
  // 地图图层切换
  switcher: new LayerSwitcher({
    show_progress: true,
    extent: true
  }),
  // wsm地图服务的查询与加载
  wmsCapabilities: new WMSCapabilities({
    srs: ['EPSG:4326'],
    cors: true
  }),
  // 平移到鹰眼图上的点击位置
  clickOverview: new Overview({
    collapsed: true,
    layers: [
      //ol6版本需要开发者设置一个新的地图资源，而ol5版本直接显示主图的缩略图
      Baselayers.OSMLayer(true, true)//ol6需要设置图层，ol5不需要
    ]
  }),
  // 地图位置书签
  geoBookmark: new GeoBookmark({

  }),
  // 地图对比控件
  swipe: new Swipe({
    orientation: 'vertical' //'vertical'：水平对比；'horizontal'：垂直对比
  }),
  // 地球鹰眼控件
  globalOverview: new Globe({
    layers: [Baselayers.BingMapLayer(Baselayers.BingMapLayerTypes.AerialWithLabels)],
    panAnimation: 'elastic',
    follow: true,
  }),
  // 工具栏控件
  controlBar: new Bar({

  }),
  // 打印控件
  print: new Print({
    imageType: 'image/png', //也可以是image/png
  }),
  // 指北针控件
  compass: new Compass({
    className: 'bottom',
    rotateVithView: true,
    src: 'http://viglino.github.io/ol-ext/examples/data/piratecontrol.png'
  }),
  // 地图中心控件
  center: new Target({
    style: new Style({
      text: new Text({
        text: '\uf140',
        font: '25px Fontawesome',
        fill: new Fill({color: 'red'})
      })
    }),
    composite: 'default'
  }),

  //图例
  legend: new Legend({
    className: 'legend-right ol-legend',
    title: 'Legend',
    size: [100, 210],
    collapsed: true,
  }),

  // 默认控件（）
  default: defaults() // 没有new
};
```

BaseMap.vue

```js
<template>
  <div>
    <div id="map">
    </div>
  </div>
</template>

<script>
  import Baselayers from "@c/js/baselayers";
  import {Map, View} from 'ol';
  import {addCoordinateTransforms, addProjection, fromLonLat} from 'ol/proj';
  import {controls} from "@c/js/controls";
  import Projection from "ol/proj/Projection";
  import {applyTransform} from "ol/extent";
  import projzh from "projzh";
  import saveAs from "file-saver";

export default {
  name: "base-map",
  mounted() {
    //添加百度地图的投影
    let extent = [-179.9, -90, 179.9, 90];
    let baiduMercator = new Projection({
      code: 'baidu',
      extent: applyTransform(extent, projzh.ll2bmerc),
      units: 'm'
    });
    addProjection(baiduMercator);
    addCoordinateTransforms('EPSG:4326', baiduMercator, projzh.ll2bmerc, projzh.bmerc2ll);
    addCoordinateTransforms('EPSG:3857', baiduMercator, projzh.smerc2bmerc, projzh.bmerc2smerc);

    let bingMap = Baselayers.BingMapLayer(Baselayers.BingMapLayerTypes.AerialWithLabels);
    let osm = Baselayers.OSMLayer(true, false);
    let bdMapLayer = Baselayers.BaiDuLayer('百度地图');
    let bdMapLayerCustom = Baselayers.BaiDuLayerCustom('自定义百度地图');
    let baseLayerGroup = Baselayers.BaseLayersGroup([bingMap, osm, bdMapLayer, bdMapLayerCustom]);
    let vectorLayer = Baselayers.VectorLayer();

    let centerPoint = fromLonLat([118.8, 32.0]);
    let view = new View({
      center: centerPoint,
      zoom: 11
    });
    
    //设置显示两个滑动地图
    controls.swipe.addLayer(bingMap);
    controls.swipe.addLayer(osm, true);

    // 组织控件工具栏
    controls.controlBar.addControl(controls.fullScreen);
    controls.controlBar.addControl(controls.wmsCapabilities);
    controls.controlBar.addControl(controls.zoomToExtend);
    controls.controlBar.addControl(controls.rotate);
    controls.controlBar.setPosition('right');

    // 监听点击事件，设置图片保存事件
    controls.print.on(['print', 'error'], (e) => {
      e.canvas.toBlob((blob => {
        saveAs(blob, 'map.' + e.imageType.replace('image/', ''))
      }), e.imageType);
    });

    new Map({
      //挂载元素
      target: 'map',
      //显示的地图
      layers: [baseLayerGroup, vectorLayer],
      //表层图层
      overlays: [],
      //在此设置地图控件
      controls: [controls.zoom, controls.clickOverview, controls.switcher, controls.controlBar, controls.print, controls.legend],
      //开启交互时加载瓦片
      loadTilesWhileInteracting: true,
      //地图显示中心
      view: view
    });
  }
}
</script>

// 注意不要加上scope属性
<style lang="scss">
//引入自定义的样式文件
 @import "../assets/scss/widgets.scss";
  #map {
    height: 100%;
    width: 100%;
    position: fixed;
  }
</style>
```

widgets.scss

```scss
// 定义变量
$widget-top: 5rem;
$widget-left: 1rem;
$widget-right: 1rem;
$widget-5right: 5rem;
// 缩放控件：右侧
// ol默认：ol-zoom
.control-right {
  bottom: 5.5rem;
  right: $widget-right;
}
.scale-left {
  left: $widget-left + 2rem;
}
.attr-right {
  right: $widget-right;
}
// 对于原生css文件已经使用的，可以使用initial!important强制初始化
.legend-right{
  left:initial!important;
  right:$widget-5right;
  z-index:1;
  max-height:90%;
  max-width:90%;
  overflow-x:hidden;
  overflow-y:auto
}
```

