- [openlayers学习——11、openlayers图形计算面积长度_WangConvey的博客-CSDN博客_openlayers计算面积](https://blog.csdn.net/weixin_43390116/article/details/122447109)

**openlayers核心：Map对象、View视图、Layer图层、Source来源、Feature特征等**

*需要引入和包*

```javascript
// 这里就不一点点删了，按需引入即可
import GeoJSON from 'ol/format/GeoJSON'
import Feature from 'ol/Feature'
import { Point, Circle as CircleGeo, LineString, Polygon } from 'ol/geom'
import VectorSource from 'ol/source/Vector'
import Cluster from 'ol/source/Cluster'
import TileArcGISRest from 'ol/source/TileArcGISRest'
import { Fill, Stroke, Style, Icon, Circle, Text } from 'ol/style'
import { Vector as VectorLayer, Tile } from 'ol/layer'
import { Draw } from 'ol/interaction'
import { boundingExtent, getCenter } from 'ol/extent'
import Overlay from 'ol/Overlay'
import { getArea, getLength } from 'ol/sphere'
import { unByKey } from 'ol/Observable'
import { MousePosition, ScaleLine } from 'ol/control'
import { createStringXY } from 'ol/coordinate'
```

注：如何画图形, 加弹框，请参考之前博客，这里就不详细介绍了。

[openlayers学习——8、openlayers画图形](https://blog.csdn.net/weixin_43390116/article/details/122411081)
[openlayers学习——4、openlayers弹出框popup弹出层Overlay](https://blog.csdn.net/weixin_43390116/article/details/122350894)

核心思想就是监听Draw对象，利用openlayers提供的getArea、getLength方法来计算所画图形的面积和长度

```javascript
// 画选图形
drawPolygon () {
  const source = new VectorSource({wrapX: false})
  if (this.drawLayer) {
    this.map.removeLayer(this.drawLayer)
  }
  this.drawLayer = new VectorLayer({
    source: source,
    style: new Style({
      fill: new Fill({ // 填充
        color: 'rgba(255, 255, 255, 0.6)'
      }),
      stroke: new Stroke({ // 边框
        color: '#0099FF',
        width: 3
      })
    })
  })
  this.map.addLayer(this.drawLayer)

  if (this.draw) {
    this.map.removeInteraction(this.draw)
  }
  // 根据下拉框判定是画线还是画多边形
  let type = this.value === 'line' ? 'LineString' : 'Polygon'
  this.draw = new Draw({
    source: source,
    type: type,
    freehand: false // 画选还是点选
  })
  this.map.addInteraction(this.draw)
  // 这里是重点，给Draw对象添加 开始画，结束画 事件
  this.draw.on('drawend', this.drawFinish)
  this.draw.on('drawstart', this.drawStart)
},
// 画图形开始处理事件
drawStart (e) {
  this.drawLayer.getSource().clear()
  this.sketch = e.feature
  let tooltipCoord = e.coordinate
  // 监听正在画的图形，动态计算长度或面积
  this.listener = this.sketch.getGeometry().on('change', (evt) => {
    const geom = evt.target
    let output
    // 获取图形数据和坐标
    // 多边形获取内部点坐标，线段获取最后落点坐标
    if (geom instanceof Polygon) {
      output = this.formatArea(geom)
      tooltipCoord = geom.getInteriorPoint().getCoordinates()
    } else if (geom instanceof LineString) {
      output = this.formatLength(geom)
      tooltipCoord = geom.getLastCoordinate()
    }
    // 添加信息弹框
    this.addPopup(tooltipCoord, output)
  })
},
// 画图形结束处理事件
drawFinish (e) {
  let [width, height] = this.map.getSize()
  width = Math.ceil(width)
  height = Math.ceil(height / 5)
  const view = this.map.getView()
  // 这里给画的图形定个位
  // 定位重点方法View中的fit方法，第一个传区域范围，第二个传一些配置参数，具体参数可见官网，padding：做偏移让地块定位在我们视线中的中心，自行调整设置，duration：动画时长
  view.fit(this.sketch.getGeometry(), {padding: [height, width, height, width + 500], duration: 500, maxZoom: 12}) // , {padding: [170, 50, 30, 150]}
  this.sketch = null
  unByKey(this.listener)
},
// 计算图形面积
formatArea (polygon) {
  // 这里一定要给坐标，和地图坐标保持一致，否则面积不准
  const area = getArea(polygon, {projection: 'EPSG:4326'})
  let output
  if (area > 10000) {
    output = Math.round((area / 1000000) * 100) / 100 + ' ' + 'km<sup>2</sup>'
  } else {
    output = Math.round(area * 100) / 100 + ' ' + 'm<sup>2</sup>'
  }
  return output
},
// 计算线段长度
formatLength (line) {
  // 这里一定要给坐标，和地图坐标保持一致，否则长度不准
  const length = getLength(line, {projection: 'EPSG:4326'})
  let output
  if (length > 100) {
    output = Math.round((length / 1000) * 100) / 100 + ' ' + 'km'
  } else {
    output = Math.round(length * 100) / 100 + ' ' + 'm'
  }
  return output
},
// 画图形取消
drawCancel () {
  this.map.removeInteraction(this.draw)
  this.map.removeLayer(this.drawLayer)
  this.draw = null
  this.drawLayer = null
  this.removePopup()
},
// 弹出框
addPopup (ctn = [118.339408, 32.261271], contentHTML = '') {
  this.removePopup()
  // 获取弹出层DOM
  const container = document.getElementById('popup')
  const content = document.getElementById('popup-content')
  if (this.overlay) {
  } else {
    // 创建Overlay弹出层绑定DOM
    this.overlay = new Overlay({
      element: container,
      autoPan: {
        animation: {
          duration: 250
        }
      }
    })
    // 添加到map
    this.map.addOverlay(this.overlay)
  }
  // 弹出层内容
  if (contentHTML === '') {
    content.innerHTML = `
                      <b style='color: blue'>弹出层信息</b>
                      <br/>
                      <table>
                        <tr>
                          <th>信息1：</th>
                          <td>XXXXXXXXX</td>
                        </tr>
                        <tr>
                          <th>信息2：</th>
                          <td>XXXXXXXXX</td>
                        </tr>
                      </table>
                      `
  } else {
    content.innerHTML = contentHTML
  }
  // 设置弹出层位置即可出现
  this.overlay.setPosition(ctn)
},
// 清除弹出框
removePopup () {
  if (this.overlay) {
    // 设置位置undefined可达到隐藏清除弹出框
    this.overlay.setPosition(undefined)
  }
}
```

效果如下

![在这里插入图片描述](https://img-blog.csdnimg.cn/282ef31547fd43a195fda83324586549.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAV2FuZ0NvbnZleQ==,size_20,color_FFFFFF,t_70,g_se,x_16)



![在这里插入图片描述](https://img-blog.csdnimg.cn/61b3ef45fe9e4d83bb1d60a183afe4df.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAV2FuZ0NvbnZleQ==,size_20,color_FFFFFF,t_70,g_se,x_16)