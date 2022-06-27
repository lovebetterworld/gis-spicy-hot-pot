- [openlayers学习——10、openlayers监听获取鼠标坐标位置_WangConvey的博客-CSDN博客_openlayers 获取坐标](https://blog.csdn.net/weixin_43390116/article/details/122441363)

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

鼠标坐标位置DOM，具体位置大家可自行设置CSS即可

```html
<span id="mousePosition" style="display: inline-block" />

// 鼠标位置
// 核心思想：给地图加控制组件MousePosition即可
addMousePosition () {
  this.removeMousePosition ()
  this.mousePositionControl = new MousePosition({
    // coordinateFormat: createStringXY(4), // 默认格式 **,**
    coordinateFormat: function (e) { // 这里格式化成 X: **  Y: **
      let stringifyFunc = createStringXY(4)
      let str = stringifyFunc(e)
      return 'X: ' + str.split(',')[0] + '&nbsp;' + ' Y: ' + str.split(',')[1]
    },
    projection: 'EPSG:4326', // 和地图坐标系保持一致
    className: 'custom-mouse-position', // css类名
    target: document.getElementById('mousePosition') // 显示位置鼠标坐标位置DOM
  })
  // 添加控制控件到地图上即可
  this.map.addControl(this.mousePositionControl)
},
// 移除鼠标位置
removeMousePosition () {
  if (this.mousePositionControl) {
    // 移除
    this.map.removeControl(this.mousePositionControl)
    this.mousePositionControl = null
  }
}
```

效果如下

![在这里插入图片描述](https://img-blog.csdnimg.cn/756be7918528445fb6d92bd3c49e8871.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAV2FuZ0NvbnZleQ==,size_20,color_FFFFFF,t_70,g_se,x_16)