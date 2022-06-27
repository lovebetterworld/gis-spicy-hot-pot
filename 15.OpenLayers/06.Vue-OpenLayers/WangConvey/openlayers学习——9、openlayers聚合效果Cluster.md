- [openlayers学习——9、openlayers聚合效果Cluster_WangConvey的博客-CSDN博客_openlayers聚合](https://blog.csdn.net/weixin_43390116/article/details/122411467)

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

// 添加聚合
addCluster () {
  this.removeCluster()
  // 创建几个聚合效果所在的点
  const features = [new Feature(new Point([118.389426, 32.350872])), new Feature(new Point([118.201428, 32.274216])), new Feature(new Point([118.339408, 32.261271])), new Feature(new Point([118.673066, 32.132925]))]
  const source = new VectorSource({
    features: features
  })
  // Cluster聚合类
  const clusterSource = new Cluster({
    // distance: 20, // 聚合点与点之间的距离
    minDistance: 15, // 聚合点与点之间的最小距离
    source: source
  })
  // 聚合图层
  this.clustersLayer = new VectorLayer({
    source: clusterSource,
    // 聚合样式
    style: function (feature) {
      // 点的个数
      const size = feature.get('features').length
      return new Style({
        image: new Circle({ // 圆形
          radius: 15, // 半径
          stroke: new Stroke({ // 边框
            color: '#fff'
          }),
          fill: new Fill({ // 填充
            color: '#3399CC'
          })
        }),
        text: new Text({ // 文字样式
          font: '15px sans-serif',
          text: size.toString(),
          fill: new Fill({
            color: '#fff'
          })
        })
      })
    }
  })
  this.map.addLayer(this.clustersLayer)
  // 地图添加点击事件
  this.map.on('click', this.clusterClickHandle)
},
// 清除聚合
removeCluster () {
  if (this.clustersLayer) {
    this.map.removeLayer(this.clustersLayer)
    this.clustersLayer = null
  }
  // 解除点击事件
  this.map.un('click', this.clusterClickHandle)
},
// 聚合点击效果处理函数
clusterClickHandle (e) {
  this.clustersLayer.getFeatures(e.pixel).then((clickedFeatures) => {
    if (clickedFeatures.length) {
      const features = clickedFeatures[0].get('features')
      // 点的个数大于1才有效果
      if (features.length > 1) {
        const extent = boundingExtent(
          features.map((r) => r.getGeometry().getCoordinates())
        )
        let [width, height] = this.map.getSize()
        width = Math.ceil(width)
        height = Math.ceil(height / 5)
        // 定位到点击位置
        this.map.getView().fit(extent, {duration: 500, padding: [height, width, height, width + 500]})
      }
    }
  })
}
```

效果如下

![在这里插入图片描述](https://img-blog.csdnimg.cn/5535e3c875584a78812d924c6ca866a4.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAV2FuZ0NvbnZleQ==,size_20,color_FFFFFF,t_70,g_se,x_16)