- [openlayers学习——1、openlayers加载天地图_WangConvey的博客-CSDN博客_openlayers加载天地图](https://blog.csdn.net/weixin_43390116/article/details/122326847)

## [openlayers](https://so.csdn.net/so/search?q=openlayers&spm=1001.2101.3001.7020)加载天地图

```
前言：基于Vue，学习openlayers，根据官网demo，记录常用功能写法。
     本人不是专业GIS开发，只是记录，方便后续查找。
```

参考资料：

- openlayers官网：https://openlayers.org/

- geojson下载网站：https://datav.aliyun.com/portal/school/atlas/area_selector

- 地图坐标拾取网站：https://api.map.baidu.com/lbsapi/getpoint/index.html

**openlayers核心：Map对象、View视图、Layer图层、Source来源、Feature特征等**

```html
<template>
  <!-- 承载地图的容器，注意宽高一定要有，否则不显示 （后面将该文件封装为组件，以便调用） -->
  <div class="base-map" id="base-map" />
</template>
1234
<script>
import Map from 'ol/Map'
import View from 'ol/View'
import { defaults as Defaults } from 'ol/control.js'
import TileLayer from 'ol/layer/Tile'
import XYZ from 'ol/source/XYZ'

export default {
  name: 'BaseMap',
  data () {
    return {
      // 地图实例对象
      map: null
    }
  },
  mounted () {
    // 窗口拖拉，更新地图大小
    window.addEventListener('resize', () => {
      if (this.map) {
        this.map.updateSize()
      }
    })
    this.$nextTick(() => {
      this.initMap()
    })
  },
  methods: {
    // 加载地图
    initMap () {
      // T=vec_c表示请求的是路网数据，x 表示切片的 x 轴坐标，y 表示切片的y轴坐标，z表示切片所在的缩放级别。
      // 使用 ol.source.XYZ 加载切片，并将获取的数据初始化一个切片图层 ol.layer.Tile：
      // 天地图底图
      var source = new XYZ({
        url: 'http://t4.tianditu.com/DataServer?T=vec_w&tk=b9031f80391e6b65bd1dd80dcde1b097&x={x}&y={y}&l={z}'
      })
      var tileLayer = new TileLayer({
        title: '天地图',
        source: source
      })
      // 标注图层(就是我们所看见的行政区名称，道路)
      var sourceMark = new XYZ({
        url: 'http://t4.tianditu.com/DataServer?T=cva_w&tk=b9031f80391e6b65bd1dd80dcde1b097&x={x}&y={y}&l={z}'
      })
      var tileMark = new TileLayer({
        title: '标注图层',
        source: sourceMark
      })
      //  创建地图对象
      this.map = new Map({
        target: 'base-map', // 地图容器 对应id
        layers: [tileLayer, tileMark], // 图层
        view: new View({ // 视图
          projection: 'EPSG:4326', // 坐标系
          // 初始化地图中心 可以去地图坐标拾取网站获取想要的坐标
          center: [118.339408, 32.261271],
          // 缩放
          zoom: 12,
          // 最大缩放
          maxZoom: 18,
          // 最小缩放
          minZoom: 1
        }),
        // 地图自带控件，这里我们不需要，后续自己做类似功能
        controls: new Defaults({
          zoom: false,
          rotate: false
        })
      })
      // 将地图对象抛出去
      this.$emit('getMap', this.map)
    }
  }
}
</script>
<style scoped>
.base-map {
  width: 100%;
  height: 100%;
  z-index: -1;
}
</style>
```

包版本

![在这里插入图片描述](https://img-blog.csdnimg.cn/6ef31f6d0243431ea76d794a767709c6.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAV2FuZ0NvbnZleQ==,size_10,color_FFFFFF,t_70,g_se,x_16)

若加载不成功，请自行申请天地图key，天地图官网：https://www.tianditu.gov.cn/

![在这里插入图片描述](https://img-blog.csdnimg.cn/8bf1efa0f37f48ec9665e00192392219.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAV2FuZ0NvbnZleQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

加载成功效果

![在这里插入图片描述](https://img-blog.csdnimg.cn/500ce4da9a70410a95ef73d920c79947.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAV2FuZ0NvbnZleQ==,size_20,color_FFFFFF,t_70,g_se,x_16)