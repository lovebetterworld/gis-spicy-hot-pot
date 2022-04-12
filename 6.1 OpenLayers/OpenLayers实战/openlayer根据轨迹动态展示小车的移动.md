- [如何用openlayer根据轨迹动态展示小车的移动 - 掘金 (juejin.cn)](https://juejin.cn/post/6989925984250101767)

## 前提

前面如何创建地图对象与矢量图层这里就省略了，这里格外针对openlayer提供的api方法如何在原有的轨迹动态移动小车

## 方法

### **getCoordinateAt()**

首先我们要了解下**getCoordinateAt()** 这个方法,官方解释是返回**linestring**中提供的分式处的坐标，分数是0到1之间的一个数字，其中0是行字符串的开始，1是结束。

那好办，相当于**linestring** 的插值方法，然后对去到的点与上一个点构建移动的轨迹。

两点成线算出方位角，设置小车的移动方向，一切准备好，开干！！

### js方法

```js
  function animation(step) {
      requestID = window.requestAnimationFrame(function () {
        if (step <= 1) {
          var second = fastLine.getGeometry().getCoordinateAt(step);  //  获取第二点的坐标 fastLine:表示已经渲染好的轨迹路线
          var first = point.getGeometry().getCoordinates();  // point: 小车对象
          var angle = -Math.atan2(second[1] - first[1], second[0] - first[0])  // 算出移动点与上一个点的角度

          point.getGeometry().setCoordinates(fastLine.getGeometry().getCoordinateAt(step))  // 小车开始移动到下一点
          point.getStyle().getImage().setRotation(angle)  // 小车的方向

          let coord = []
          coord.push(first)
          coord.push(second)
          var Tempfeature = new ol.Feature({    // 小车移动的轨迹
            geometry: new ol.geom.LineString(coord)
          })
          vector2.getSource().addFeature(Tempfeature);
          step = step + 0.0003;
          animation(step);
        } else {
          var second = ol.proj.fromLonLat([111, 20])
          var first = point.getGeometry().getCoordinates()
          var angle = -Math.atan2(second[1] - first[1], second[0] - first[0])
          point.getGeometry().setCoordinates(second)
          point.getStyle().getImage().setRotation(angle)
          let coord = []
          coord.push(first)
          coord.push(second)
          var Tempfeature = new ol.Feature({
            geometry: new ol.geom.LineString(coord)
          })
          vector2.getSource().addFeature(Tempfeature)
        }
      }, 1)
    }
```

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/8258ce059ab74096a3012afdd82e02ea~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

**源码**：[tande1124/carTrack: 基于openlayer的行驶动画 (github.com)](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2Ftande1124%2FcarTrack)