- [openlayers学习——8、openlayers画图形_WangConvey的博客-CSDN博客_openlayers 画面](https://blog.csdn.net/weixin_43390116/article/details/122411081)

**openlayers核心：Map对象、View视图、Layer图层、Source来源、Feature特征等**

*需要引入和包*

```javascript
// 这里就不一点点删了，按需引入即可
import GeoJSON from 'ol/format/GeoJSON'
import Feature from 'ol/Feature'
import { Point, Circle as CircleGeo } from 'ol/geom'
import VectorSource from 'ol/source/Vector'
import Cluster from 'ol/source/Cluster'
import TileArcGISRest from 'ol/source/TileArcGISRest'
// 自己下载的GEOJSON
import Chzu from '@/assets/geojson/Chzu.json'
import { Fill, Stroke, Style, Icon, Circle, Text } from 'ol/style'
import { Vector as VectorLayer, Tile } from 'ol/layer'
import { Draw } from 'ol/interaction'
import { boundingExtent, getCenter } from 'ol/extent'
import Overlay from 'ol/Overlay'
```

这里提供的Demo只是画多边形，其他形状请参考官网
https://openlayers.org/en/latest/examples/draw-features.html

```javascript
// 画选图形
// 核心思想：创建图层，创建绘画工具类Draw，添加交互
drawPolygon () {
  const source = new VectorSource({wrapX: false})
  if (this.drawLayer) {
    this.map.removeLayer(this.drawLayer)
  }
  this.drawLayer = new VectorLayer({
    source: source
  })
  this.map.addLayer(this.drawLayer)

  if (this.draw) {
    this.map.removeInteraction(this.draw)
  }
  this.draw = new Draw({
    source: source, // 和图层使用同一个source，画的图形在图层上，图层在地图上即可展示
    type: 'Polygon', // 可选择三角形，多边形，圆形等具体见官网demo
    freehand: false // 画选还是点选
  })
  // 添加交互
  this.map.addInteraction(this.draw)
},
// 画图形取消
drawCancel () {
  this.map.removeInteraction(this.draw)
  this.map.removeLayer(this.drawLayer)
  this.draw = null
  this.drawLayer = null
}
```

效果如下

![在这里插入图片描述](https://img-blog.csdnimg.cn/2addc68d8e8f45efbf6ed7ce95bcbb9f.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAV2FuZ0NvbnZleQ==,size_20,color_FFFFFF,t_70,g_se,x_16)