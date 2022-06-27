- [openlayers学习——3、openlayers加点加圆加图标图片_WangConvey的博客-CSDN博客_openlayers添加图标](https://blog.csdn.net/weixin_43390116/article/details/122346857)

参考资料：

openlayers官网：https://openlayers.org/

geojson下载网站：https://datav.aliyun.com/portal/school/atlas/area_selector

地图坐标拾取网站：https://api.map.baidu.com/lbsapi/getpoint/index.html

**openlayers核心：Map对象、View视图、Layer图层、Source来源、Feature特征等**

```javascript
// 这里就不一点点删了，按需引入即可
import GeoJSON from 'ol/format/GeoJSON'
import Feature from 'ol/Feature'
import { Point, Circle as CircleGeo } from 'ol/geom'
import VectorSource from 'ol/source/Vector'
import Cluster from 'ol/source/Cluster'
import TileArcGISRest from 'ol/source/TileArcGISRest'
import { Fill, Stroke, Style, Icon, Circle, Text } from 'ol/style'
import { Vector as VectorLayer, Tile } from 'ol/layer'
import { Draw } from 'ol/interaction'
import {boundingExtent} from 'ol/extent'
import Overlay from 'ol/Overlay'
```

**加图标图片**

```javascript
// 主要思想构建Feature，构建Source，构建Layer，最后添加Layer到map即可
// 相关变量在data中申明即可，eg：iconLayer: null,
// 添加图标
addIcon () {
  this.removeIcon()
  const vectorSource = new VectorSource()
  this.iconLayer = new VectorLayer({
    source: vectorSource
  })
  // 添加图层
  this.map.addLayer(this.iconLayer)
  // 设置图片位置
  const iconFeature = new Feature({
    geometry: new Point([118.339408, 32.261271])
  })
  // 设置样式，这里使用图片
  iconFeature.setStyle(new Style({
    image: new Icon({
      src: require('@/assets/logo.png')
    })
  }))
  // 将图片Feature添加到Source
  this.iconLayer.getSource().addFeature(iconFeature)
},
// 取消图标
removeIcon () {
  if (this.iconLayer) {
  	// 移除图层
    this.map.removeLayer(this.iconLayer)
    this.iconLayer = null
  }
}
```

最后效果

![在这里插入图片描述](https://img-blog.csdnimg.cn/35422b103f714d85b77d734f74d76494.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAV2FuZ0NvbnZleQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

**加点**

```javascript
// 核心思想和加图标图片一样，构建Feature，构建Source，构建Layer，最后添加Layer到map即可
// 加点
addPoint () {
  this.removeCircle()
  // 创建Feature 设置点的位置
  const pointFeature = new Feature({
    geometry: new Point([118.339408, 32.261271])
  })
  const source = new VectorSource({
    features: [pointFeature]
  })
  this.pointLayer = new VectorLayer({
    source: source,
    style: new Style({
      image: new Circle({
        radius: 9,// 圆的半径
        fill: new Fill({color: 'red'}) // 填充颜色
      })
    })
  })
  // 最后别忘了把图层加到地图上
  this.map.addLayer(this.pointLayer)
}
```

**加圆**

```javascript
// 核心思想同上
// 加圆形
addCircle () {
  this.removeCircle()
  // 圆心位置和半径
  const circleFeature = new Feature({
    geometry: new CircleGeo([118.339408, 32.261271], 0.02)
  })
  const source = new VectorSource({
    features: [circleFeature]
  })
  // 图层
  this.layer = new VectorLayer({
    source: source,
    // 设置样式
    style: new Style({
      fill: new Fill({ // 填充
        color: 'rgba(255, 255, 255, 0.6)'
      }),
      stroke: new Stroke({ // 边框
        color: '#319FD3',
        width: 3
      })
    })
  })
  // 图层加到地图上
  this.map.addLayer(this.layer)
},
// 清除圆形
removeCircle () {
  if (this.layer) {
  	// 移除圆形图层
    this.map.removeLayer(this.layer)
    this.layer = null
  }
  if (this.pointLayer) {
  	// 移除点图层
    this.map.removeLayer(this.pointLayer)
    this.pointLayer = null
  }
}
```

最后效果

![在这里插入图片描述](https://img-blog.csdnimg.cn/96cbfa9785354ed9aabdd8f2954586eb.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAV2FuZ0NvbnZleQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

![在这里插入图片描述](https://img-blog.csdnimg.cn/15a4714581fe416fad0310e902bf50be.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAV2FuZ0NvbnZleQ==,size_20,color_FFFFFF,t_70,g_se,x_16)