- [vue项目中实现maptalks地图上弹框使用videojs播放实时视频rtmp流](https://blog.csdn.net/liona_koukou/article/details/84325190)

不限制于vue项目，区别只是相关文件的引入

最终实现效果如下：

![img](https://img-blog.csdnimg.cn/20181121162802598.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpb25hX2tvdWtvdQ==,size_16,color_FFFFFF,t_70)

 1、首先引入需要的资源：vue-video-player、maptalks相关

```js
npm install vue-video-player --save
 
npm install maptalks --save
```

2、以vue cli3.0为例，在vue.conig.js文件中添加配置

```js
chainWebpack: config => {
    config.module
      .rule('swf')
      .test(/\.swf$/)
      .use('url-loader')
      .loader('url-loader')
      .options({
        limit: 10000
      })
  },
```

3、在地图页面引入

```js
import * as maptalks from 'maptalks'
import videojs from 'video.js'
import 'video.js/dist/video-js.css'
import 'vue-video-player/src/custom-theme.css'
import 'videojs-flash'
import SWF_URL from 'videojs-swf/dist/video-js.swf'
 
videojs.options.flash.swf = SWF_URL // 设置flash路径，Video.js会在不支持html5的浏览中使用flash播放视频文件
```


​     4、在地图上打点标注点位并给点位添加弹框

```js
markerInMap() {
  const that = this
  for (var m = 0; m < that.monitor.length; m++) {
    var markerm = new maptalks.Marker(
      that.monitor[m].position, // lon and lat in here
      { // 图形样式
        'symbol': {
          'markerFile': require('./../../assets/baseImg/monitor_map.png'),
          'markerWidth': 28,
          'markerHeight': 36,
          'markerDx': 0,
          'markerDy': 0,
          'markerOpacity': 1
        }
      }
    ).addTo(that.layer_monitor)
    markerm.setInfoWindow({
      'autoPan': true,
      'width': 485,
      'minHeight': 330,
      'dy': 4,
      'custom': false, // 只使用定制自定义true
      'autoOpenOn': 'click', // set to null if not to open when clicking on marker
      'autoCloseOn': 'click',
      // 支持自定义html内容
      'content': '<div class="content equip-content">' +
        '<div class="pop-video"><video id="video_' + that.monitor[m].id + '" class="video-js vjs-default-skin vjs-big-play-centered" controls fluid="true" width="485" height="275">' +
        '  <source src="rtmp://212.64.34.125:10935/hls/stream_27" type="rtmp/flv">' +
        '</video></div>' +
        '<div class="pop-bottom">' + that.monitor[m].name + '<a id="moreMonitor" style="cursor:pointer;" data-id="' + that.monitor[m].id + '">查看更多<i class="el-icon-arrow-right"></i></a></div>' +
        '</div>'
    }).on('mousedown', onClick)
    function onClick(e) {
      setTimeout(function() {
        const moreMonitor = document.getElementById('moreMonitor')
        moreMonitor.onclick = function() {
          that.$router.push({ path: '/video/realMonitor', query: { id: moreMonitor.dataset.id }})
        }
        that.videoPlayer = videojs(document.getElementById('video_' + moreMonitor.dataset.id), {}, function() {
          this.play()
        })
      }, 1000)
    }
  }
```

5、下面这段代码就实现了点击播放视频

```js
function onClick(e) {
  setTimeout(function() {
    const moreMonitor = document.getElementById('moreMonitor')
    moreMonitor.onclick = function() {
      that.$router.push({ path: '/video/realMonitor', query: { id: moreMonitor.dataset.id }})
    }
    that.videoPlayer = videojs(document.getElementById('video_' + moreMonitor.dataset.id), {}, function() {
      this.play()
    })
  }, 1000)
}
```

6、但其实这时候是有一个bug的，就是当我不论以什么方式关闭了这个弹框都会开始大量报错

![img](https://img-blog.csdnimg.cn/20181121163145920.png)

要解决这个问题需要在弹框关闭的时候销毁之前创建的video对象，解决方案为监听地图点击事件，只要地图有点击操作我们就判断是否有video对象并对其销毁置null

我们在mounted里加上下面的代码

```js
// 监听地图点击事件
this.map.on('click', function(e) {
  if (that.videoPlayer) {
    that.videoPlayer.dispose()
    that.videoPlayer = null
  }
})
```

整个页面代码如下

```html
<template>
  <div id="map" class="base-map" />
</template>
 
<script>
import * as maptalks from 'maptalks'
import videojs from 'video.js'
import 'video.js/dist/video-js.css'
import 'vue-video-player/src/custom-theme.css'
import 'videojs-flash'
import SWF_URL from 'videojs-swf/dist/video-js.swf'
import { getBuild, getCustom, getMapMarks } from './../../api/park'
 
videojs.options.flash.swf = SWF_URL // 设置flash路径，Video.js会在不支持html5的浏览中使用flash播放视频文件
export default {
  name: 'BaseMap',
  data() {
    return {
      videoPlayer: null,
      map: null,
      clusterLayer: [],
      addressPoints: [],
      drawTool: null,
      layer_build: null,
      layer_monitor: null,
      layer_face: null,
      layer_car: null,
      layer_fire: null,
      layer_polygon: null,
      monitor: [],
      face: [],
      car: [],
      fire: [],
      building: [],
      custom: []
    }
  },
  mounted() {
    const that = this
    // --0--//地图对象的初始化
    this.map = new maptalks.Map('map', {
      center: [121.6050804009, 31.2015354151],
      // 中心点标记红十字
      centerCross: true,
      // limit max pitch to 60 as mapbox-gl-js required,just for mapbox
      maxPitch: 60,
      zoom: 18,
      zoomControl: true, // add zoom control
      scaleControl: true, // add scale control
      overviewControl: false, // add overview control
      spatialReference: {
        projection: 'EPSG:4326'
        // 与map一样，支持更详细的设置resolutions，fullExtent等
      },
      baseLayer: new maptalks.WMSTileLayer('wms', {
        'urlTemplate': 'http://xxx.xx.xx.xx:xxxx/geoserver/bcmp_puruan/wms',
        'crs': 'EPSG:4326',
        'tiled': true,
        'layers': 'bcmp_puruan:new3d_puruan',
        'styles': '',
        'version': '1.1.1',
        'format': 'image/png',
        'transparent': true,
        'uppercase': true
        // 以上为wms服务基本配置项（服务相关）
        // ----------------------------------------
        // 以下可以加配maptalk相关属性配置项，如css
        // css filter 滤镜配置,滤镜配置比较丰富
        // cssFilter : 'sepia(5%) invert(95%)'
      }),
      layers: [// 配置相关的layers
        new maptalks.VectorLayer('v')
      ],
      minZoom: 12,
      maxZoom: 19,
      attribution: {// 左下角info
        content: '&maptalk for qmap'
      }
    })
 
    // -1-//中心点增加标注，并点击弹框
    // var center = this.map.getCenter()
    // 声明放置楼宇和自定义区域的图层
    this.layer_build = new maptalks.VectorLayer('build').addTo(this.map)
    // 声明放置监控设备的图层
    this.layer_monitor = new maptalks.VectorLayer('monitor').addTo(this.map)
    // 声明放置人脸门禁的图层
    this.layer_face = new maptalks.VectorLayer('face').addTo(this.map)
    // 声明放置车辆卡口的图层
    this.layer_car = new maptalks.VectorLayer('car').addTo(this.map)
    // 声明放置消防设施的图层
    this.layer_fire = new maptalks.VectorLayer('fire').addTo(this.map)
    // 声明放置画多边形的图层
    this.layer_polygon = new maptalks.VectorLayer('polygon').addTo(this.map)
 
    // -2-// 拖动范围限制，黑框,矩形框可以自定义
    const extent = this.map.getExtent()
    // set map's max extent to map's extent at zoom 18
    this.map.setMaxExtent(extent)
    this.map.setZoom(this.map.getZoom(), { animation: true })
    this.map.getLayer('build')
      .addGeometry(
        new maptalks.Polygon(extent.toArray(), {
          symbol: { 'polygonOpacity': 0, 'lineWidth': 0 }
        })
      )
        // 监听地图点击事件
    this.map.on('click', function(e) {
      if (that.videoPlayer) {
        that.videoPlayer.dispose()
        that.videoPlayer = null
      }
    })
    // 监控设备上图
    this.getMarks()
    this.getBuildCustom()
  },
  methods: {
    // 获取设备
    getMarks() {
      const that = this
      /* getMapMarks().then((res) => {
        if (res.code === 0) {
          // 处理数据
        } else {
          this.$message.error(res.msg)
          return
        }
      }) */
      const res = [
        {
          id: 11,
          type: 'monitor',
          name: '奥克斯广场5楼H座',
          position: [121.60183757543565, 31.200640797615055]
        },
        {
          id: 12,
          type: 'fire',
          name: '奥克斯广场4楼H座',
          position: [121.60308748483658, 31.201885342597965]
        },
        {
          id: 13,
          type: 'car',
          name: '奥克斯广场3楼H座',
          position: [121.60235390067102, 31.19988441467285]
        },
        {
          id: 14,
          type: 'monitor',
          name: '奥克斯广场2楼H座',
          position: [121.60212725400926, 31.199884414672855]
        },
        {
          id: 15,
          type: 'monitor',
          name: '奥克斯广场1楼H座',
          position: [121.6019180417061, 31.200351119041446]
        }
      ]
      const monitor = []
      const face = []
      const car = []
      const fire = []
      res.forEach((item, index) => {
        if (item.type === 'monitor') {
          monitor.push(item)
        }
        if (item.type === 'face') {
          face.push(item)
        }
        if (item.type === 'car') {
          car.push(item)
        }
        if (item.type === 'fire') {
          fire.push(item)
        }
      })
      that.monitor = monitor
      that.face = face
      that.car = car
      that.fire = fire
      that.markerInMap()
    },
    // 楼宇和自定义区域搜索
    getBuildCustom() {
      const that = this
      // 自定义区域搜索
      that.custom = [
        {
          id: 31,
          name: '中心湖',
          position: [
            [121.60619238941621, 31.20185829162874],
            [121.60590807526063, 31.20207823276796],
            [121.6057578715558, 31.20204604625978],
            [121.60483519165467, 31.202249894144913],
            [121.60468498794984, 31.202190885546585],
            [121.60442749588441, 31.202228436472794],
            [121.6042290124173, 31.20208896160402],
            [121.60413245289277, 31.201949486735245],
            [121.60370329945039, 31.201933393481156],
            [121.60349945156526, 31.20180464744844],
            [121.60347799389314, 31.20157397747316],
            [121.60360673992585, 31.201166281702896],
            [121.60361746876191, 31.20109654426851],
            [121.60358528225373, 31.200951704981705],
            [121.60363892643403, 31.200726399424454],
            [121.60397152035188, 31.200495729449173],
            [121.60436312286805, 31.20029724598207],
            [121.6047493609662, 31.20029724598207],
            [121.60501758186768, 31.200377712252518],
            [121.60535017578553, 31.200624475481888],
            [121.60538236229371, 31.200876603129288],
            [121.60536626903962, 31.201160917284867],
            [121.60594562618684, 31.20131648540773],
            [121.60619238941621, 31.201219925883194],
            [121.6067127379651, 31.201219925883194],
            [121.60728673069428, 31.20136476517],
            [121.60738865463685, 31.20130039215364],
            [121.60745302765321, 31.20131648540773],
            [121.60745839207124, 31.201472053530594],
            [121.60720626442384, 31.201477417948624],
            [121.60681466190766, 31.201413044932266],
            [121.60641769497346, 31.201461324694534],
            [121.60622457592439, 31.20158470630922],
            [121.60617093174409, 31.201734910014054],
            [121.60619775383424, 31.20186365604677]
          ]
        }
      ]
      /* getCustom().then((res) => {
        if (res.code === 0) {
          that.custom = res.data
        } else {
          this.$message.error(res.msg)
          return
        }
      })*/
      // 楼宇搜索
      that.building = [
        {
          id: 21,
          name: '海航万邦中心',
          position: [
            [121.60635445018207, 31.200443756030936],
            [121.60635445018207, 31.199907314227957],
            [121.60639200110828, 31.19983757679357],
            [121.60646173854266, 31.19981075470342],
            [121.60678896804248, 31.1998429412116],
            [121.60681579013263, 31.199885856555838],
            [121.60682115455066, 31.200411569522757],
            [121.60680506129657, 31.200486671375174],
            [121.60679433246051, 31.200534951137442],
            [121.60671386619006, 31.200524222301382],
            [121.60670850177203, 31.200502764629263],
            [121.60663876433765, 31.200497400211233],
            [121.60662267108356, 31.200513493465323],
            [121.6065046538869, 31.200486671375174],
            [121.60649392505084, 31.200459849285025],
            [121.60641882319842, 31.200449120448965],
            [121.6063598146001, 31.200454484866995],
            [121.60635445018207, 31.200438391612906]
          ]
        }
      ]
      /* getBuild().then((res) => {
        if (res.code === 0) {
          that.building = res.data
        } else {
          this.$message.error(res.msg)
          return
        }
      })*/
      that.markBuilding()
      that.markCustom()
    },
    doDraw() {
      this.drawTool.setMode('Polygon').enable()
      document.getElementById('map').setAttribute('title', '单击左键开始绘制，双击左键结束绘制')
    },
    // 设备资源上图
    markerInMap() {
      const that = this
      for (var m = 0; m < that.monitor.length; m++) {
        var markerm = new maptalks.Marker(
          that.monitor[m].position, // lon and lat in here
          { // 图形样式
            'symbol': {
              'markerFile': require('./../../assets/baseImg/monitor_map.png'),
              'markerWidth': 28,
              'markerHeight': 36,
              'markerDx': 0,
              'markerDy': 0,
              'markerOpacity': 1
            }
          }
        ).addTo(that.layer_monitor)
        markerm.setInfoWindow({
          'autoPan': true,
          'width': 485,
          'minHeight': 330,
          'dy': 4,
          'custom': false, // 只使用定制自定义true
          'autoOpenOn': 'click', // set to null if not to open when clicking on marker
          'autoCloseOn': 'click',
          // 支持自定义html内容
          'content': '<div class="content equip-content">' +
            '<div class="pop-video"><video id="video_' + that.monitor[m].id + '" class="video-js vjs-default-skin vjs-big-play-centered" controls fluid="true" width="485" height="275">' +
            '  <source src="rtmp://212.64.34.125:10935/hls/stream_27" type="rtmp/flv">' +
            '</video></div>' +
            '<div class="pop-bottom">' + that.monitor[m].name + '<a id="moreMonitor" style="cursor:pointer;" data-id="' + that.monitor[m].id + '">查看更多<i class="el-icon-arrow-right"></i></a></div>' +
            '</div>'
        }).on('mousedown', onClick)
        function onClick(e) {
          setTimeout(function() {
            const moreMonitor = document.getElementById('moreMonitor')
            moreMonitor.onclick = function() {
              that.$router.push({ path: '/video/realMonitor', query: { id: moreMonitor.dataset.id }})
            }
            that.videoPlayer = videojs(document.getElementById('video_' + moreMonitor.dataset.id), {}, function() {
              this.play()
            })
          }, 1000)
        }
      }
 
      for (var f = 0; f < that.face.length; f++) {
        var markerf = new maptalks.Marker(
          that.face[f].position, // lon and lat in here
          { // 图形样式
            'symbol': {
              'markerFile': require('./../../assets/baseImg/monitor_map.png'),
              'markerWidth': 28,
              'markerHeight': 36,
              'markerDx': 0,
              'markerDy': 0,
              'markerOpacity': 1
            }
          }
        ).addTo(that.layer_face)
        markerf.setInfoWindow({
          'autoPan': true,
          'width': 485,
          'minHeight': 330,
          'dy': 4,
          'custom': false, // 只使用定制自定义true
          'autoOpenOn': 'click', // set to null if not to open when clicking on marker
          'autoCloseOn': 'click',
          // 支持自定义html内容
          'content': '<div class="content equip-content">' +
            '<div class="pop-video"><video id="video_' + that.face[f].id + '" class="video-js vjs-default-skin vjs-big-play-centered" controls fluid="true" width="485" height="275">' +
            '  <source src="rtmp://212.64.34.125:10935/hls/stream_27" type="rtmp/flv">' +
            '</video></div>' +
            '<div class="pop-bottom">' + that.face[f].name + '<a id="moreMonitor" style="cursor:pointer;" data-id="' + that.face[f].id + '">查看更多<i class="el-icon-arrow-right"></i></a></div>' +
            '</div>'
        }).on('mousedown', onClick)
        function onClick(e) {
          setTimeout(function() {
            const moreMonitor = document.getElementById('moreMonitor')
            moreMonitor.onclick = function() {
              that.$router.push({ path: '/video/realMonitor', query: { id: moreMonitor.dataset.id }})
            }
            that.videoPlayer = videojs(document.getElementById('video_' + moreMonitor.dataset.id), {}, function() {
              this.play()
            })
          }, 500)
        }
      }
 
      for (var c = 0; c < that.car.length; c++) {
        var markerc = new maptalks.Marker(
          that.car[c].position, // lon and lat in here
          { // 图形样式
            'symbol': {
              'markerFile': require('./../../assets/baseImg/car_map.png'),
              'markerWidth': 28,
              'markerHeight': 36,
              'markerDx': 0,
              'markerDy': 0,
              'markerOpacity': 1
            }
          }
        ).addTo(that.layer_car)
        markerc.setInfoWindow({
          'autoPan': true,
          'width': 485,
          'minHeight': 330,
          'dy': 4,
          'custom': false, // 只使用定制自定义true
          'autoOpenOn': 'click', // set to null if not to open when clicking on marker
          'autoCloseOn': 'click',
          // 支持自定义html内容
          'content': '<div class="content equip-content">' +
            '<div class="pop-video"><video id="video_' + that.car[c].id + '" class="video-js vjs-default-skin vjs-big-play-centered" controls fluid="true" width="485" height="275">' +
            '  <source src="rtmp://212.64.34.125:10935/hls/stream_27" type="rtmp/flv">' +
            '</video></div>' +
            '<div class="pop-bottom">' + that.car[c].name + '<a id="moreMonitor" style="cursor:pointer;" data-id="' + that.car[c].id + '">查看更多<i class="el-icon-arrow-right"></i></a></div>' +
            '</div>'
        }).on('mousedown', onClick)
        function onClick(e) {
          setTimeout(function() {
            const moreMonitor = document.getElementById('moreMonitor')
            moreMonitor.onclick = function() {
              that.$router.push({ path: '/video/realMonitor', query: { id: moreMonitor.dataset.id }})
            }
            that.videoPlayer = videojs(document.getElementById('video_' + moreMonitor.dataset.id), {}, function() {
              this.play()
            })
          }, 500)
        }
      }
 
      for (var i = 0; i < that.fire.length; i++) {
        var markeri = new maptalks.Marker(
          that.fire[i].position, // lon and lat in here
          { // 图形样式
            'symbol': {
              'markerFile': require('./../../assets/baseImg/fire_map.png'),
              'markerWidth': 28,
              'markerHeight': 36,
              'markerDx': 0,
              'markerDy': 0,
              'markerOpacity': 1
            }
          }
        ).addTo(that.layer_fire)
        markeri.setInfoWindow({
          'autoPan': true,
          'width': 485,
          'minHeight': 330,
          'dy': 4,
          'custom': false, // 只使用定制自定义true
          'autoOpenOn': 'click', // set to null if not to open when clicking on marker
          'autoCloseOn': 'click',
          // 支持自定义html内容
          'content': '<div class="content equip-content">' +
            '<div class="pop-video"><video id="video_' + that.fire[i].id + '" class="video-js vjs-default-skin vjs-big-play-centered" controls fluid="true" width="485" height="275">' +
            '  <source src="rtmp://212.64.34.125:10935/hls/stream_27" type="rtmp/flv">' +
            '</video></div>' +
            '<div class="pop-bottom">' + that.fire[i].name + '<a id="moreMonitor" style="cursor:pointer;" data-id="' + that.fire[i].id + '">查看更多<i class="el-icon-arrow-right"></i></a></div>' +
            '</div>'
        }).on('mousedown', onClick)
        function onClick(e) {
          setTimeout(function() {
            const moreMonitor = document.getElementById('moreMonitor')
            moreMonitor.onclick = function() {
              that.$router.push({ path: '/video/realMonitor', query: { id: moreMonitor.dataset.id }})
            }
            that.videoPlayer = videojs(document.getElementById('video_' + moreMonitor.dataset.id), {}, function() {
              this.play()
            })
          }, 500)
        }
      }
    },
    // 楼宇上图
    markBuilding() {
      // -5-//多边形悬停，点击事件，同样支持marker
      const that = this
      for (var i = 0; i < that.building.length; i++) {
        var building = new maptalks.Polygon(
          that.building[i].position, // lon and lat in here
          { // 图形样式
            visible: true,
            editable: true,
            cursor: 'pointer',
            shadowBlur: 0,
            shadowColor: 'black',
            draggable: false,
            dragShadow: false, // display a shadow during dragging
            drawOnAxis: null, // force dragging stick on a axis, can be: x, y
            symbol: {
              'lineColor': 'rgba(0,208,223,0.5)',
              'lineWidth': 0,
              'polygonFill': 'rgba(0,208,223,0.5)',
              'polygonOpacity': 0.6
            }
          }
        ).addTo(that.layer_build)
        building.setInfoWindow({
          'autoPan': true,
          'width': 410,
          'minHeight': 190,
          'dy': 4,
          'custom': false, // 只使用定制自定义true
          'autoOpenOn': 'click', // set to null if not to open when clicking on marker
          'autoCloseOn': 'click',
          // 支持自定义html内容
          'content': '<div class="content build-content">' +
            '<div class="pop-img"><img src="https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1542365932900&di=615c41113e473f04a66bafe71fd39d6e&imgtype=0&src=http%3A%2F%2Fpic.ynshangji.com%2F00user%2Fproduct0_13%2F2014-2-11%2F354395-16103365.jpg"/><p class="pop-name"><span class="text-ellipsis" title="' + that.building[i].name + '">' + that.building[i].name + '</span><a id="viewDetial" data-id="' + that.building[i].id + '">详情<i class="el-icon-arrow-right"></i></a></p></div>' +
            '<div class="pop-txt"><ul><li>入驻企业：87 家 </li><li>登记人员：56 家 </li><li>今日访客：30 人 </li><li>登记车辆：67 辆 </li><li>实时人数：392 人 </li><li>监控点位：87 个 </li><li>人脸门禁：16 个 </li><li>消防设施：188 个</li></ul></div>' +
            '</div>'
        }).on('mousedown', onClick)
        function onClick(e) {
          setTimeout(function() {
            const viewDetial = document.getElementById('viewDetial')
            viewDetial.onclick = function() {
              that.$router.push({ path: '/building/index', query: { id: viewDetial.dataset.id }})
            }
          }, 500)
        }
      }
      // 鼠标悬移,支持多种事件。。。
      building.on('mouseenter', function(e) {
        // update markerFill to highlight
        e.target.updateSymbol({
          'polygonFill': 'rgb(135,196,240)'
        })
      }).on('mouseout', function(e) {
        // reset color
        e.target.updateSymbol({
          'polygonFill': 'rgba(0,208,223,0.5)'
        })
      })
    },
    // 自定义区域上图
    markCustom() {
      // -5-//多边形悬停，点击事件，同样支持marker
      const that = this
      for (var i = 0; i < that.custom.length; i++) {
        var custom = new maptalks.Polygon(
          that.custom[i].position, // lon and lat in here
          { // 图形样式
            visible: true,
            editable: true,
            cursor: 'pointer',
            shadowBlur: 0,
            shadowColor: 'black',
            draggable: false,
            dragShadow: false, // display a shadow during dragging
            drawOnAxis: null, // force dragging stick on a axis, can be: x, y
            symbol: {
              'lineColor': 'rgba(0,208,223,0.5)',
              'lineWidth': 0,
              'polygonFill': 'rgba(0,208,223,0.5)',
              'polygonOpacity': 0.6
            }
          }
        ).addTo(that.layer_build)
        custom.setInfoWindow({
          'autoPan': true,
          'width': 330,
          'minHeight': 220,
          'dy': 4,
          'custom': false, // 只使用定制自定义true
          'autoOpenOn': 'click', // set to null if not to open when clicking on marker
          'autoCloseOn': 'click',
          // 支持自定义html内容
          'content': '<div class="content custom-content">' +
            '<div class="pop-img"><img src="https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1542365932900&di=615c41113e473f04a66bafe71fd39d6e&imgtype=0&src=http%3A%2F%2Fpic.ynshangji.com%2F00user%2Fproduct0_13%2F2014-2-11%2F354395-16103365.jpg"/><p class="pop-name"><span class="text-ellipsis" title="' + that.custom[i].name + '">' + that.custom[i].name + '</span><a  id="viewDetial" data-id="' + that.custom[i].id + '">详情<i class="el-icon-arrow-right"></i></a></p></div>' +
            '<div class="pop-txt"><ul><li>值班人员：刘佳慧  </li><li>值班电话：17778098789 </li></ul></div>' +
            '</div>'
        }).on('mousedown', onClick)
        function onClick(e) {
          setTimeout(function() {
            const viewDetial = document.getElementById('viewDetial')
            viewDetial.onclick = function() {
              that.$router.push({ path: '/building/index', query: { id: viewDetial.dataset.id }})
            }
          }, 500)
        }
      }
      // 鼠标悬移,支持多种事件。。。
      custom.on('mouseenter', function(e) {
        // update markerFill to highlight
        e.target.updateSymbol({
          'polygonFill': 'rgb(135,196,240)'
        })
      }).on('mouseout', function(e) {
        // reset color
        e.target.updateSymbol({
          'polygonFill': 'rgba(0,208,223,0.5)'
        })
      })
    },
    // 飞行视角定位到某地点
    changeView(center) {
      this.map.animateTo({
        zoom: 18,
        center: center
      }, {
        duration: 1000
      })
    }
  }
}
</script>
 
<style scoped>
 
</style>
<style lang="less">
  .base-map {
    .container {
      width: 100%;
      height: 100%;
    }
    .content {
      color: #666;
      width: 410px;
      height: 300px;
      overflow:hidden;
      background-color: #fff;
      border-radius:8px;
      -webkit-box-shadow: 0 0 8px 5px rgba(0,0,0,0.2);
      -moz-box-shadow: 0 0 8px 5px rgba(0,0,0,0.2);
      box-shadow: 0 0 8px 5px rgba(0,0,0,0.2);
      &:after{
        display:inline-block;
        content:'';
        border-width:0 0 25px 30px;
        border-color:transparent transparent #fff transparent;
        border-style:solid dashed dashed dashed;
        position: absolute;
        bottom: -11px;
        left: 50%;
        margin-left: -15px;
        -webkit-transform: rotate(-36deg);
        -moz-transform: rotate(-36deg);
        -ms-transform: rotate(-36deg);
        -o-transform: rotate(-36deg);
        transform: rotate(-36deg);
        z-index:0;
      }
      .pop-img{
        position:relative;
        width:100%;
        height:190px;
        overflow:hidden;
      }
      img{
        width:100%;
      }
      ul li{
        line-height:24px;
        float:left;
        width:33%;
        text-align:left;
      }
      .pop-name{
        position: absolute;
        left:50%;
        top:8px;
        width:236px;
        height:40px;
        margin-left:-118px;
        line-height:40px;
        border-radius:30px;
        background:url('./../../assets/baseImg/pop_img.png') no-repeat 100%;
        color:#fff;
        font-size: 16px;
      }
      a{
        float:right;
        margin-right:10px;
        font-size: 14px;
        color: rgba(255,255,255,0.8);
      }
      a:hover{
        color:#fff;
      }
      span{
        display:inline-block;
        width:160px;
        text-align:center;
      }
      .pop-txt{
        padding:15px;
        font-size: 14px;
        color: #646464;
      }
      &.custom-content{
        width:350px;
        height:220px;
        .pop-img{
          height:170px;
        }
        ul li{
          width:50%;
        }
        .pop-name{
          width:160px;
          margin-left:-80px;
          background:url('./../../assets/baseImg/pop_img.png') no-repeat 100%;
          color:#fff;
          font-size: 16px;
        }
        span{
          width:100px;
        }
      }
      &.equip-content{
        height:330px;
        .pop-bottom{
          height:54px;
          line-height:54px;
          font-size:14px;
          color:#323232;
          padding:0 18px;
        }
        a{
          float:right;
          font-size:14px;
          color:#323232;
        }
        a:hover{
          color:#347eff;
        }
      }
    }
    .pop-title {
      padding-left:10px;
      font-size: 14px;
      height:36px;
      line-height:36px;
    }
    .pop-video{
      width:100%;
      height:275px;
    }
    .video-js{
      width:100%;
      height:100%;
    }
  }
</style>
```
