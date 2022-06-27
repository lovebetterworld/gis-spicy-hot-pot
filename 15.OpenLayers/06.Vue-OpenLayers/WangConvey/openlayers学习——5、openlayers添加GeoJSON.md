- [openlayers学习——5、openlayers添加GeoJSON_WangConvey的博客-CSDN博客_openlayers加载geojson](https://blog.csdn.net/weixin_43390116/article/details/122351332)

**openlayers核心：Map对象、View视图、Layer图层、Source来源、Feature特征等**

需要的GEOJSON可以再上面给的网站中自行下载

```javascript
// 需要的包，这里就不一点点删了，按需引入即可
import GeoJSON from 'ol/format/GeoJSON'
import Feature from 'ol/Feature'
import { Point, Circle as CircleGeo } from 'ol/geom'
import VectorSource from 'ol/source/Vector'
import Cluster from 'ol/source/Cluster'
import TileArcGISRest from 'ol/source/TileArcGISRest'
// 这里就是准备好的GeoJSON
import { GEOJSON_CONST } from '@/assets/js/resource.js'
import { Fill, Stroke, Style, Icon, Circle, Text } from 'ol/style'
import { Vector as VectorLayer, Tile } from 'ol/layer'
import { Draw } from 'ol/interaction'
import { boundingExtent, getCenter } from 'ol/extent'
import Overlay from 'ol/Overlay'
1234567891011121314
// 添加GeoJOSN
addGeoJSON () {
  this.clearGeoJSON()
  let source = new VectorSource({
  	// 准备好的GeoJSON
  	// 注意自己下载的geojson要在中心点附近，否则可能添加成功后找不到在哪
    features: new GeoJSON().readFeatures(GEOJSON_CONST)
  })
  this.geoLayer = new VectorLayer({
    source: source,
    // 设置样式，边框和填充
    style: new Style({
      stroke: new Stroke({
        color: 'green',
        width: 5
      }),
      fill: new Fill({
        color: 'rgba(255, 255, 0, 0.5)'
      })
    })
  })
  // 添加GeoJSON到map上
  this.map.addLayer(this.geoLayer)
  // 地图视图缩小一点
  const view = this.map.getView()
  view.setZoom(9)
},
// 清除GeoJSON
clearGeoJSON () {
  if (this.geoLayer) {
    this.map.removeLayer(this.geoLayer)
    this.geoLayer = null
  }
  // 清除之后将地图中心还原
  const view = this.map.getView()
  view.setCenter([118.339408, 32.261271])
  view.setZoom(12)
}

```

最后效果

![在这里插入图片描述](https://img-blog.csdnimg.cn/e31b84a7320342038387fa59fc5fd36a.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAV2FuZ0NvbnZleQ==,size_20,color_FFFFFF,t_70,g_se,x_16)