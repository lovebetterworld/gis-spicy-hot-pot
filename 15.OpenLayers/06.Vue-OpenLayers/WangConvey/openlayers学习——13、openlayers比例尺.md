- [openlayers学习——13、openlayers比例尺_WangConvey的博客-CSDN博客_openlayers 地图比例尺](https://blog.csdn.net/weixin_43390116/article/details/122441638)

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

***两种方式***
1、使用地图控件方式ScaleLine，但不精确(也可能我没有找到精确地方式)
2、监听地图分辨率，配合公式动态计算

比例尺DOM

```html
<span id="scaleWrapper" style="display: none">
  比例尺(km)&nbsp;1:&nbsp;
  <span id="scale" style="display: inline-block" />
</span>
```

***1、ScaleLine方式***

```javascript
// 添加比例尺
// 官网关于比例尺demo：https://openlayers.org/en/latest/examples/scale-line.html
addScale () {
  document.getElementById('scaleWrapper').style.display = 'inline-block'
  this.scaleControl = new ScaleLine({
    Units: 'metric', // 单位有5种：degrees imperial us nautical metric
    target: document.getElementById('scale') // 显示比例尺的Dom
  })
  // 添加控件到地图
  this.map.addControl(this.scaleControl)
},
// 取消比例尺
removeScale () {
  document.getElementById('scaleWrapper').style.display = 'none'
  if (this.scaleControl) {
    // 移除控件
    this.map.removeControl(this.scaleControl)
    this.scaleControl = null
  }
}
```

效果如下
![在这里插入图片描述](https://img-blog.csdnimg.cn/4691856be3cc476aa76ac2425df281c5.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAV2FuZ0NvbnZleQ==,size_20,color_FFFFFF,t_70,g_se,x_16)
***2、监听分辨率方式***

```javascript
// 添加比例尺
// 计算的公式详解请参考大佬博文：https://segmentfault.com/a/1190000019169455?utm_source=tag-newest
addScale () {
  document.getElementById('scaleWrapper').style.display = 'inline-block'
  // 监听分辨率变化，通过dpi和像素关系（比例尺=dpi/0.0254*分辨率）输出比例尺
  document.getElementById('scale').innerHTML = (this.map.getView().getResolution() * 3779.5275590551).toFixed(4)
  // 重点监听View的resolution改变
  this.map.getView().on('change:resolution', this.viewChange)
},
// 取消比例尺
removeScale () {
  document.getElementById('scaleWrapper').style.display = 'none'
  this.map.getView().un('change:resolution', this.viewChange)
},
// 视图监听
viewChange () {
  document.getElementById('scale').innerHTML = (this.map.getView().getResolution() * 3779.5275590551).toFixed(4)// 这里使用了View中的getResolution方法获得当前View的分辨率。
}
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/50ff468dca2f476eaf654c5707058dea.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAV2FuZ0NvbnZleQ==,size_20,color_FFFFFF,t_70,g_se,x_16)