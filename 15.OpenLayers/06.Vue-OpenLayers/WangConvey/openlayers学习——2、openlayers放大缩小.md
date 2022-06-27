- [openlayers学习——2、openlayers放大缩小_WangConvey的博客-CSDN博客_openlayers监听放大缩小事件](https://blog.csdn.net/weixin_43390116/article/details/122346468)

参考资料：

openlayers官网：https://openlayers.org/

geojson下载网站：https://datav.aliyun.com/portal/school/atlas/area_selector

地图坐标拾取网站：https://api.map.baidu.com/lbsapi/getpoint/index.html

**openlayers核心：Map对象、View视图、Layer图层、Source来源、Feature特征等**

```javascript
// 地图缩小
zoomOut () {
  // 使用map对象获取view视图，然后设置View视图的放大，缩小参数即可
  const view = this.map.getView()
  const zoom = view.getZoom()
  view.setZoom(zoom - 1)
},
// 地图放大
zoomIn () {
  const view = this.map.getView()
  const zoom = view.getZoom()
  view.setZoom(zoom + 1)
}
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/fd510b79948c49d48630a99e1857e599.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAV2FuZ0NvbnZleQ==,size_20,color_FFFFFF,t_70,g_se,x_16)