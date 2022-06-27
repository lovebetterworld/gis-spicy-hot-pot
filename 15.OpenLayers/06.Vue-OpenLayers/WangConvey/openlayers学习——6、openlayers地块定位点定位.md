- [openlayers学习——6、openlayers地块定位点定位_WangConvey的博客-CSDN博客_openlayers定位](https://blog.csdn.net/weixin_43390116/article/details/122359805)

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

***定位地块***

```javascript
// 定位地块
locationDK () {
  // 使用GeoJSON构建source
  const source = new VectorSource({
    features: new GeoJSON().readFeatures(Chzu)
  })
  // 设置地块区域样式
  const style = new Style({
    fill: new Fill({ // 填充
      color: 'rgba(255, 255, 255, 0.6)'
    }),
    stroke: new Stroke({ // 边框
      color: '#319FD3',
      width: 3
    })
  })
  if (this.geoLayer) {
    this.map.removeLayer(this.geoLayer)
  }
  // 构建地块图层
  this.geoLayer = new VectorLayer({
    source: source,
    style: style
  })
  // 添加到map中
  this.map.addLayer(this.geoLayer)
  let [width, height] = this.map.getSize()
  width = Math.ceil(width)
  height = Math.ceil(height / 5)
  const view = this.map.getView()
  // 定位重点方法View中的fit方法，第一个传区域范围，第二个传一些配置参数，具体参数可见官网，padding：做偏移让地块定位在我们视线中的中心，自行调整设置，duration：动画时长
  view.fit(source.getExtent(), {padding: [height, width, height, width + 500], duration: 500}) // , {padding: [170, 50, 30, 150]}

  // 获取中心点，添加弹出框（下面的可要可不要，为了加弹出层，和定位没有直接关系）
  // addPopup就不放了，可以注释掉，相加的
  // 相加的代码在这片文章中 https://blog.csdn.net/weixin_43390116/article/details/122350894
  var extent = boundingExtent(source.getFeatures()[0].getGeometry().getCoordinates()[0][0]) // 获取一个坐标数组的边界，格式为[minx,miny,maxx,maxy]
  var center = getCenter(extent) // 获取边界区域的中心位置
  this.addPopup(center)
},
```

***定位点***

```javascript
// 定位点
locationPoint () {
  // 创建一个点的source
  const source = new VectorSource({
    features: [new Feature(new Point([118.339408, 32.261271]))]
  })
  // 样式
  const style = new Style({
    image: new Circle({ // 圆形
      radius: 9, // 半径
      fill: new Fill({color: 'red'}) // 填充色
    })
  })
  if (this.pointLayer) {
    this.map.removeLayer(this.pointLayer)
  }
  // 点图层
  this.pointLayer = new VectorLayer({
    source,
    style
  })
  this.map.addLayer(this.pointLayer)
  let [width, height] = this.map.getSize()
  width = Math.ceil(width)
  height = Math.ceil(height / 5)
  const view = this.map.getView()
  // 定位重点方法View中的fit方法，第一个传区域范围，第二个传一些配置参数，具体参数可见官网，padding：做偏移让地块定位在我们视线中的中心，自行调整设置，duration：动画时长
  view.fit(source.getExtent(), {padding: [height, width, height, width + 500], duration: 500}) // , {padding: [170, 50, 30, 150]}

  // 下面也是弹出框，可以先注释掉
  this.addPopup([118.339408, 32.261271])
}
```

清除

```javascript
// 清除
clear () {
  if (this.geoLayer) {
    this.map.removeLayer(this.geoLayer)
    this.geoLayer = null
  }
  if (this.pointLayer) {
    this.map.removeLayer(this.pointLayer)
    this.pointLayer = null
  }
  // 清除完之后还原地图
  const view = this.map.getView()
  view.setCenter([118.339408, 32.261271])
  view.setZoom(12)
}
```

效果

![在这里插入图片描述](https://img-blog.csdnimg.cn/126efde416084921be99c1470fb09519.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAV2FuZ0NvbnZleQ==,size_20,color_FFFFFF,t_70,g_se,x_16)
![在这里插入图片描述](https://img-blog.csdnimg.cn/c9038c98b99b4ac08e818a735e955a9c.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAV2FuZ0NvbnZleQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

相关博文加弹出框：https://blog.csdn.net/weixin_43390116/article/details/122350894