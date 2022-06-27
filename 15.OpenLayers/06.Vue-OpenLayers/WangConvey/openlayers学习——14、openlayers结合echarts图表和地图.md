- [openlayers学习——14、openlayers结合echarts图表和地图_WangConvey的博客-CSDN博客_openlayers销毁地图](https://blog.csdn.net/weixin_43390116/article/details/122703387)

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
// 这个第二种会用到
import EChartsLayer from 'ol-echarts'
```

# 一、普通饼图、柱图

步骤一：加载echarts图表（和普通使用echarts图表一样）

步骤二：创建Overlay，绑定echarts图表DOM

直接上代码

```html
<el-row style="margin-top: 10px">
  <span>echarts：</span>
  <el-button type="primary" @click="addEcharts" size="small">饼图</el-button>
  <el-button type="primary" @click="addMark" size="small">标记</el-button>
  <el-button type="success" @click="removeEcharts" size="small">取消</el-button>
  <div class="chart" id="chart" style="width: 300px;height:300px" />
</el-row>

// 添加echarts
addEcharts () {
  this.removeEcharts()
  /** 普通echarts加载 Start **/
  var data = [{name: 'A', value: 20}, {name: 'B', value: 23}, {name: 'C', value: 45}, {name: 'D', value: 34}, {name: 'E', value: 14}]
  var option = {
    tooltip: {
      trigger: 'item',
      formatter: '{b} : {c} ({d}%)'
    },
    toolbox: {
      show: true,
      feature: {
        mark: {show: true},
        magicType: {
          show: true,
          type: ['pie', 'funnel']
        }
      }
    },
    calculable: true,
    series: [{
      type: 'pie',
      radius: '60%',
      startAngle: '45',
      label: {
        normal: {
          show: false
        },
        emphasis: {
          show: false,
          textStyle: {
            color: '#000000',
            fontWeight: 'bold',
            fontSize: 16
          }
        }
      },
      lableLine: {
        normal: {
          show: false
        },
        emphasis: {
          show: false
        }
      },
      data: data
    }]
  }
  this.chart = this.$echarts.init(document.getElementById('chart'))
  this.chart.setOption(option)
  /** 普通echarts加载 End **/

  // 下面是加载Overlay
  var pt = [118.339408, 32.261271]
  if (this.overlay) {
  } else {
    // 创建Overlay弹出层绑定DOM
    this.overlay = new Overlay({
      element: document.getElementById('chart'), // echarts图表DOM
      autoPan: {
        animation: {
          duration: 250
        }
      },
      position: pt,
      positioning: 'center-center'
    })
    // 添加到map
    this.map.addOverlay(this.overlay)
  }
},
// 取消echarts
removeEcharts () {
  // 图表销毁
  if (this.chart) {
    this.chart.dispose()
    this.chart = null
  }
  // 注记图层销毁
  if (this.echartsLayer) {
    this.echartsLayer.remove()
    this.echartsLayer = null
  }
  // 弹出层销毁
  if (this.overlay) {
    // 设置位置undefined可达到隐藏清除弹出框
    this.overlay.setPosition(undefined)
    this.overlay = null
  }
}  
```

效果如下
![在这里插入图片描述](https://img-blog.csdnimg.cn/9a115277fd3443859cb211d1a98bbdfe.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAV2FuZ0NvbnZleQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

# 二、加载炫酷地图标记

这种方式为了加载例如基于echarts的炫酷地图上的标记图层，eg: [make a pie](https://www.makeapie.com/explore.html)

类似于下面所示的效果，将其加入到openlayers中

![在这里插入图片描述](https://img-blog.csdnimg.cn/cd992e3c52aa4bbc8f8c6dbdf319b82b.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAV2FuZ0NvbnZleQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

![在这里插入图片描述](https://img-blog.csdnimg.cn/1f2ebafcfa0546aebb67c5da9a14b82c.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAV2FuZ0NvbnZleQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

这里需要使用到一个工具 [ol-echarts](https://www.npmjs.com/package/ol-echarts/v/1.3.6)

```javascript
npm install ol-echarts --save
import EChartsLayer from 'ol-echarts'
```

注：截止目前这个工具包只支持**echarts版本5以下**，请注意这一点，否则加载不出来

```javascript
// 标记
addMark () {
  this.removeEcharts()
  /** 全是复制make a pie 中的echarts图表配置 Start**/
  var chinaGeoCoordMap = {
    '黑龙江': [127.9688, 45.368],
    '内蒙古': [110.3467, 41.4899],
    '吉林': [125.8154, 44.2584],
    '北京市': [116.4551, 40.2539],
    '辽宁': [123.1238, 42.1216],
    '河北': [114.4995, 38.1006],
    '天津': [117.4219, 39.4189],
    '山西': [112.3352, 37.9413],
    '陕西': [109.1162, 34.2004],
    '甘肃': [103.5901, 36.3043],
    '宁夏': [106.3586, 38.1775],
    '青海': [101.4038, 36.8207],
    '新疆': [87.9236, 43.5883],
    '西藏': [91.11, 29.97],
    '四川': [103.9526, 30.7617],
    '重庆': [108.384366, 30.439702],
    '山东': [117.1582, 36.8701],
    '河南': [113.4668, 34.6234],
    '江苏': [118.8062, 31.9208],
    '安徽': [117.29, 32.0581],
    '湖北': [114.3896, 30.6628],
    '浙江': [119.5313, 29.8773],
    '福建': [119.4543, 25.9222],
    '江西': [116.0046, 28.6633],
    '湖南': [113.0823, 28.2568],
    '贵州': [106.6992, 26.7682],
    '云南': [102.9199, 25.4663],
    '广东': [113.12244, 23.009505],
    '广西': [108.479, 23.1152],
    '海南': [110.3893, 19.8516],
    '上海': [121.4648, 31.2891]
  }
  var chinaDatas = [
    [{
      name: '黑龙江',
      value: 0
    }],	[{
      name: '内蒙古',
      value: 0
    }],	[{
      name: '吉林',
      value: 0
    }],	[{
      name: '辽宁',
      value: 0
    }],	[{
      name: '河北',
      value: 0
    }],	[{
      name: '天津',
      value: 0
    }],	[{
      name: '山西',
      value: 0
    }],	[{
      name: '陕西',
      value: 0
    }],	[{
      name: '甘肃',
      value: 0
    }],	[{
      name: '宁夏',
      value: 0
    }],	[{
      name: '青海',
      value: 0
    }],	[{
      name: '新疆',
      value: 0
    }], [{
      name: '西藏',
      value: 0
    }],	[{
      name: '四川',
      value: 0
    }],	[{
      name: '重庆',
      value: 0
    }],	[{
      name: '山东',
      value: 0
    }],	[{
      name: '河南',
      value: 0
    }],	[{
      name: '江苏',
      value: 0
    }],	[{
      name: '安徽',
      value: 0
    }], [{name: '湖北', value: 0}], [{
      name: '浙江',
      value: 0
    }],	[{
      name: '福建',
      value: 0
    }],	[{
      name: '江西',
      value: 0
    }],	[{
      name: '湖南',
      value: 0
    }],	[{
      name: '贵州',
      value: 0
    }], [{
      name: '广西',
      value: 0
    }],	[{
      name: '海南',
      value: 0
    }],	[{
      name: '上海',
      value: 1
    }]
  ]
  var convertData = function (data) {
    var res = []
    for (var i = 0; i < data.length; i++) {
      var dataItem = data[i]
      var fromCoord = chinaGeoCoordMap[dataItem[0].name]
      var toCoord = [116.4551, 40.2539]
      if (fromCoord && toCoord) {
        res.push([{
          coord: fromCoord,
          value: dataItem[0].value
        }, {
          coord: toCoord
        }])
      }
    }
    return res
  }
  var series = [];
  [['北京市', chinaDatas]].forEach(function (item, i) {
    series.push({
      type: 'lines',
      zlevel: 2,
      effect: {
        show: true,
        period: 4, // 箭头指向速度，值越小速度越快
        trailLength: 0.02, // 特效尾迹长度[0,1]值越大，尾迹越长重
        symbol: 'arrow', // 箭头图标
        symbolSize: 5 // 图标大小
      },
      lineStyle: {
        normal: {
          width: 1, // 尾迹线条宽度
          opacity: 1, // 尾迹线条透明度
          curveness: 0.3 // 尾迹线条曲直度
        }
      },
      data: convertData(item[1])
    }, {
      type: 'effectScatter',
      coordinateSystem: 'geo',
      zlevel: 2,
      rippleEffect: { // 涟漪特效
        period: 4, // 动画时间，值越小速度越快
        brushType: 'stroke', // 波纹绘制方式 stroke, fill
        scale: 4 // 波纹圆环最大限制，值越大波纹越大
      },
      label: {
        normal: {
          show: true,
          position: 'right', // 显示位置
          offset: [5, 0], // 偏移设置
          formatter: function (params) { // 圆环显示文字
            return params.data.name
          },
          fontSize: 13
        },
        emphasis: {
          show: true
        }
      },
      symbol: 'circle',
      symbolSize: function (val) {
        return 5 + val[2] * 5 // 圆环大小
      },
      itemStyle: {
        normal: {
          show: false,
          color: '#f00'
        }
      },
      data: item[1].map(function (dataItem) {
        return {
          name: dataItem[0].name,
          value: chinaGeoCoordMap[dataItem[0].name].concat([dataItem[0].value])
        }
      })
    },
      // 被攻击点
    {
      type: 'scatter',
      coordinateSystem: 'geo',
      zlevel: 2,
      rippleEffect: {
        period: 4,
        brushType: 'stroke',
        scale: 4
      },
      label: {
        normal: {
          show: true,
          position: 'right',
          // offset:[5, 0],
          color: '#0f0',
          formatter: '{b}',
          textStyle: {
            color: '#0f0'
          }
        },
        emphasis: {
          show: true,
          color: '#f60'
        }
      },
      symbol: 'pin',
      symbolSize: 50,
      data: [{
        name: item[0],
        value: chinaGeoCoordMap[item[0]].concat([10])
      }]
    }
    )
  })

  let option = {
    tooltip: {
      trigger: 'item',
      backgroundColor: 'rgba(166, 200, 76, 0.82)',
      borderColor: '#FFFFCC',
      showDelay: 0,
      hideDelay: 0,
      enterable: true,
      transitionDuration: 0,
      extraCssText: 'z-index:100',
      formatter: function (params, ticket, callback) {
        // 根据业务自己拓展要显示的内容
        var res = ''
        var name = params.name
        var value = params.value[params.seriesIndex + 1]
        res = "<span style='color:#fff;'>" + name + '</span><br/>数据：' + value
        return res
      }
    },
    // backgroundColor: '#013954',
    visualMap: { // 图例值控制
      min: 0,
      max: 1,
      calculable: true,
      show: true,
      color: ['#f44336', '#fc9700', '#ffde00', '#ffde00', '#00eaff'],
      textStyle: {
        color: '#fff'
      }
    },
    geo: {
      map: 'china',
      zoom: 1.2,
      label: {
        emphasis: {
          show: false
        }
      },
      roam: true, // 是否允许缩放
      itemStyle: {
        normal: {
          color: 'rgba(51, 69, 89, .5)', // 地图背景色
          borderColor: '#516a89', // 省市边界线00fcff 516a89
          borderWidth: 1
        },
        emphasis: {
          color: 'rgba(37, 43, 61, .5)' // 悬浮背景
        }
      }
    },
    series: series
  }
  /** 全是复制make a pie 中的echarts图表配置 End**/

  // 下面是工具包中的类或方法
  this.echartsLayer = new EChartsLayer(option, {
    hideOnMoving: true,
    hideOnZooming: false,
    forcedPrecomposeRerender: false
  })
  // 加进去即可
  this.echartsLayer.appendTo(this.map)
},
    // 取消echarts
removeEcharts () {
  // 图表销毁
  if (this.chart) {
    this.chart.dispose()
    this.chart = null
  }
  // 注记图层销毁
  if (this.echartsLayer) {
    this.echartsLayer.remove()
    this.echartsLayer = null
  }
  // 弹出层销毁
  if (this.overlay) {
    // 设置位置undefined可达到隐藏清除弹出框
    this.overlay.setPosition(undefined)
    this.overlay = null
  }
}  
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/0d62ed19cc2b4ea0ba177b534abbb9ed.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAV2FuZ0NvbnZleQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

到此结束