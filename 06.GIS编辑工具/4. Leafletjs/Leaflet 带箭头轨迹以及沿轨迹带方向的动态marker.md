- [Leaflet 带箭头轨迹以及沿轨迹带方向的动态marker](https://juejin.cn/post/6934988629571797028)



下图是我基于leaflet实现的效果。

![202101280101](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b11dc2fbf3f84b23a572506629f3e034~tplv-k3u1fbpfcp-watermark.image)

接下来分享一下在我基于leaflet实现该效果时一些思路以及踩到的坑。

### 轨迹线添加箭头效果

leaflet无法像`mapboxgl`似的直接通过样式实现轨迹箭头效果，需要通过引用[L.polylineDecorator](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2Fbbecquet%2FLeaflet.PolylineDecorator)扩展实现。核心代码如下。

注意：此处添加箭头图层应在轨迹线和实时轨迹线之后，不然箭头会被覆盖。

![20210204103224](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/e710d42c985f422abf36418879e492eb~tplv-k3u1fbpfcp-watermark.image)

### 沿轨迹线带方向动态marker

实现该效果首先想到的是类似之前在用mapboxgl 实现的思路，将线打断，然后通过[requestAnimationFrame](https://link.juejin.cn?target=https%3A%2F%2Fblog.csdn.net%2Fvhwfr2u02q%2Farticle%2Fdetails%2F79492303)循环更新marker的位置和角度实现；这种方式最终可以实现动态效果，但是流畅度差了一些，会有卡顿的现象。

为了得到更流畅的效果，又翻看[Leaflet Plugins](https://link.juejin.cn?target=https%3A%2F%2Fleafletjs.com%2Fplugins.html)，搜索`animate`关键字，发现了[Leaflet.AnimatedMarker](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2Fopenplans%2FLeaflet.AnimatedMarker)，动画效果挺流畅的，于是拉取代码研究了一下。

该插件主要是使用CSS3动画来实现marker在线段间的移动，所以效果比较流畅。

但是该插件并未考虑marker角度的问题，而且在做地图缩放的时候会有`marker`偏移轨迹的问题。查找相关资料时，发现有人也尝试解决此问题[leaflet-moving-marker](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2Fmohsen1%2Fleaflet-moving-marker)。

但这里对于轨迹线的动态绘制并未考虑。

参考`Leaflet.AnimatedMarker`、`leaflet-moving-marker`中核心代码并考虑我们要实现的效果，最终解决了角度问题以及轨迹线动态绘制问题。

![20210208152058](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/ce1acb09e2ab450e88b70aabf9e982ff~tplv-k3u1fbpfcp-watermark.image)

另外，在播放过程中当前后两个点位角度变化超过180度时，会出现`marker`旋转的问题。

![202102080101](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/1d23c50a2d5d473db3c5748fe8f29cb6~tplv-k3u1fbpfcp-watermark.image)

通过如下代码我们解决了此问题。

![20210208152905](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/8219b7bc290447529a4eac96c6185fff~tplv-k3u1fbpfcp-watermark.image)

我们把代码重新封装，简单调用即可实现了文章开头的轨迹带箭头以及沿轨迹线带方向的动态`marker`。

![20210302124540](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/c5bb6f73dfb94111a537d48e7221a519~tplv-k3u1fbpfcp-watermark.image)

注意：在动态播放的过程中缩放地图，标记点由于播放延迟，有时仍然会出现偏离轨迹线的问题，目前该问题暂未解决，后续解决后更新。

## 总结

1. 使用用`L.polylineDecorator`插件可以实现轨迹带箭头效果。
2. `Leaflet.AnimatedMarker`插件可以更流畅的实现marker沿线播放，但是没有考虑`marker`角度和轨迹线的动态绘制。
3. 参考`Leaflet.AnimatedMarker`、`leaflet-moving-marker`中核心代码，解决角度问题以及轨迹线动态绘制等问题。
4. 将代码重新封装成插件，方便调用。

## 在线示例

在线示例：[gisarmory.xyz/blog/index.…](https://link.juejin.cn?target=http%3A%2F%2Fgisarmory.xyz%2Fblog%2Findex.html%3Fdemo%3DLeafletRouteAnimate)

示例代码地址：[gisarmory.xyz/blog/index.…](https://link.juejin.cn?target=http%3A%2F%2Fgisarmory.xyz%2Fblog%2Findex.html%3Fsource%3DLeafletRouteAnimate)

插件地址：[gisarmory.xyz/blog/index.…](https://link.juejin.cn?target=http%3A%2F%2Fgisarmory.xyz%2Fblog%2Findex.html%3Fsource%3DLeafletAnimatedMarker)