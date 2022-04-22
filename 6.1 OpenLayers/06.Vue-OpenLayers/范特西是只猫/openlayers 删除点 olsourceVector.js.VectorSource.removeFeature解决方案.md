- [openlayers 删除点 ol/source/Vector.js.VectorSource.removeFeature解决方案_范特西是只猫的博客-CSDN博客_openlayers清空feature](https://xiehao.blog.csdn.net/article/details/104789967)

背景：[openlayers](https://so.csdn.net/so/search?q=openlayers&spm=1001.2101.3001.7020) 实现地图打点，根据数据的变化修改点的位置

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200311100127608.gif)

data

```js
// 点的经纬度
coordinates: [
// { x: 37.12638163, y: 15.1353712537 },
// { x: 82.56253054272383, y: 42.63299560546875 },
// { x: 87.52801179885864, y: 44.15955126285553 }
]
```

methods

```js
/**
* 批量添加坐标点
*/
handleAddBatchFeature() {
 const _that = this;
 // 设置图层
 _that.flagLayer = new VectorLayer({
   source: new VectorSource()
 });
 _that.map.addLayer(_that.flagLayer);
 // 循环添加feature
 for (let i = 0; i < this.coordinates.length; i++) {
   // 创建feature
   let feature = new Feature({
     geometry: new Point([_that.coordinates[i].x, _that.coordinates[i].y])
   });
   // 设置ID
   feature.setId(i + "xx");
   feature.setStyle(_that.getIcon());
   _that.features.push(feature);
 } // for 结束
 // 批量添加feature
 _that.flagLayer.getSource().addFeatures(_that.features);
},
```

上面就可以实现批量打点操作。我修改 data 的数据，希望实现点的实时更新操作

> 删除点，需要先从Feature里移除icon，然后再移除图层，如果不从Feature里移除icon而直接移除图层，则同一个实例化方法中icon一直存在，只是由于图层不存在而未在地图上显示出来。

删除点，删除图层代码

```js
this.flagLayer.getSource().removeFeature(this.features); //先默认移除icon的feature
this.map.removeLayer(this.flagLayer); //在移除图层
```

感觉上面的逻辑符合，但是往往会事与愿违！！！

下面我操作coordinates数据我删除了一个点，但是页面点的位置并没有消失，就是说移除点是错误的。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200311094528563.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)

`报错信息：VectorSource../node_modules/_ol@6.2.1@ol/source/Vector.js.VectorSource.removeFeature`

默认说forEach of undefined 但是上面数据显示数组存在两个值。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200311094254123.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)

经过N小时的摸索，终于找到了解决办法。

```js
let _that = this;
this.flagLayer
  .getSource()
  .getFeatures()
  .forEach(function(feature) {
    _that.flagLayer.getSource().removeFeature(feature);
  });
this.features = [];?
console.log(this.features);
// this.flagLayer.getSource().removeFeature(this.features); //错误写法
this.map.removeLayer(this.flagLayer);
```

> 感谢参考博文：https://blog.csdn.net/ZillahV06/article/details/80449044