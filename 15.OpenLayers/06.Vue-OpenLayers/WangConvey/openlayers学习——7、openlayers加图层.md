- [openlayers学习——7、openlayers加图层_WangConvey的博客-CSDN博客_openlayers添加图层](https://blog.csdn.net/weixin_43390116/article/details/122366149)

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

注：这里只展示了ArcGIS服务如何添加，如果是其他类型图层
参考大佬博文：https://www.cnblogs.com/2008nmj/p/14069514.html

```javascript
// 添加图层
addLayer () {
  // TileArcGISRest是重点
  // 需要自己有一个正常的gis服务，放在url位置即可
  const source = new TileArcGISRest({
    url: 'http://XXXXXXXXXXXX/arcgis/rest/services/zp/klyzy/MapServer'
  })
  this.map.removeLayer(this.layer)
  // 构建图层
  this.layer = new Tile({
    source: source
  })
  this.map.addLayer(this.layer)
  // 加完之后将视图转到gis服务图层大概位置，方便看见图层加后的效果
  const view = this.map.getView()
  view.setCenter([120.655258, 27.761194])
  view.setZoom(14)
},
// 取消图层
removeLayer () {
  if (this.layer) {
    this.map.removeLayer(this.layer)
    this.layer = null
  }
  // 移除图层后，还原地图位置
  const view = this.map.getView()
  view.setCenter([118.339408, 32.261271])
  view.setZoom(12)
}
```

最后效果

![在这里插入图片描述](https://img-blog.csdnimg.cn/a2b28a5efc3b4f269cb5e0a236eab324.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAV2FuZ0NvbnZleQ==,size_20,color_FFFFFF,t_70,g_se,x_16)