- [openlayer画线显示移动轨迹_孤独旋转的博客-CSDN博客_openlayer 轨迹](https://blog.csdn.net/weixin_43763952/article/details/113500900)
- [openlayers6【二十三】vue LineString 实现地图轨迹路线，设置起点和终点的标注信息详解_范特西是只猫的博客-CSDN博客_openlayers 绘制轨迹](https://blog.csdn.net/qq_36410795/article/details/119205448)

- 画线：使用包`ol/interaction/Draw`
- 显示移动轨迹：通过定时器不停的移动元素feature，在拐角的地方转动图片的角度（只要设置的时间够短，就不会卡顿），位移的距离和转动的角度根据点与点之间的像素来计算（不推荐用他们的经纬度计算，因为地球是圆的，画的线是直的）。

- 示例图
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/2021020113485425.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80Mzc2Mzk1Mg==,size_16,color_FFFFFF,t_70)
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210201135000369.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80Mzc2Mzk1Mg==,size_16,color_FFFFFF,t_70#pic_center)

### 1、使用的包和全局变量

- 使用的包如下所示：

```javascript
import VectorLayer from 'ol/layer/Vector';
import VectorSource from 'ol/source/Vector';
import Feature from 'ol/Feature';
import { Draw } from 'ol/interaction';
import { Style, Fill, Stroke, Circle, Icon } from 'ol/style';
import { transform, fromLonLat, toLonLat } from 'ol/proj';
import { Point } from 'ol/geom';
import CAR from '@/static/car.png';//我的小车图片
```

- 为了方便变量的全局使用，在data中定义变量，后面的this都指向其中的变量（学过vue的都知道-_-!）
  - coors存放的是你在画线时的点的经纬度，即路的转折点
  - carPoint是小车的轨迹点，用来存放计算小车的下一个位置

```javascript
data() {
    return {
      map: this.$route.params.map,//地图，我的是路由参数传递
      layer: null,//图层
      interaction: null,//draw交互
      source: null,//数据源
      feature: null,//元素
      coors: [],//路的转折点
      carPoint: [],//车的轨迹点
      index: 0,//当前小车所在的路段
      timer: null,//定时器
      follow: true,//是否聚焦小车
    }
  },
```

### 2、创建图层

- 创建地图进来的应该都会，不会的看官网例子，就不啰嗦了

```javascript
this.source = new VectorSource({ wrapX: false });
this.layer = new VectorLayer({
  source: this.source,
  style: new Style({
    stroke: new Stroke({
      color: '#0099ff',
      width: 2,
    }),
    image: new Circle({
      radius: 7,
      fill: new Fill({
        color: '#0099ff'
      })
    })
  }),
});
```

### 3、增加交互

- 增加Draw交互

```javascript
this.interaction = new Draw({
  source: this.source,
  type: 'LineString',
});
this.map.addInteraction(this.interaction);
this.interaction.on('drawend', e => {
  //防止双击放大地图
  e.stopPropagation();
  let line = e.feature.getGeometry();
  this.coors = line.getCoordinates().map(item => {
    return transform(
      item,
      'EPSG:3857',
      'EPSG:4326',
    );
  });
  this.interaction.setActive(false);//画完之后不能再画
  //画完之后立即开始动画
  this.moveStart();
});
```

### 4、开始移动

- 开始移动函数

```javascript
moveStart() {
 //如果已经在移动，则删除元素，移除定时器
 if(this.feature) {
   this.layer.getSource().removeFeature(this.feature);
   this.feature = null;
   clearInterval(this.timer);
   this.timer = null;
 }
 this.index = 0;
 //深复制车的位置，不在原数组改变，方便重新播放
 this.carPoint = JSON.parse(JSON.stringify(this.coors));
 this.feature = new Feature({
   geometry: new Point(fromLonLat(this.carPoint[0])),
 })
 this.feature.setStyle(new Style({
   image: new Icon({
     src: CAR,
     anchor: [0.5, 0.5],
     rotation: this.countRotate(),//下面有这个方法
   })
 }));
 //增加车辆元素
 this.layer.getSource().addFeature(this.feature);
 this.timeStart();//下面有这个方法
},
```

- 计时器开始

```javascript
timeStart() {
  this.timer = setInterval(() => {
  	//到达终点
    if(this.index + 1 >= this.carPoint.length) {
      //最后加1，控制暂停键隐藏
      this.index++;
      clearInterval(this.timer);
      this.timer = null;
      return ;
    }
    //到转折点旋转角度
    if(this.nextPoint() === this.carPoint[this.index + 1]) {
      this.index++;
      this.feature.getStyle().getImage()
        .setRotation(this.countRotate());
    }
    this.feature.getGeometry().setCoordinates(fromLonLat(this.carPoint[this.index]));
    //是否聚焦小车
    if(this.follow) {
      this.map.getView().setCenter(fromLonLat(this.carPoint[this.index]))
    }
  }, 10);
},
```

- 计算两点之间的角度

```javascript
countRotate() {
  let i= this.index, j = i + 1;
  if(j === this.carPoint.length) {
    i--;
    j--;
  }
  let p1 = this.map.getPixelFromCoordinate(fromLonLat(this.coors[i]));
  let p2 = this.map.getPixelFromCoordinate(fromLonLat(this.coors[j]));
  return Math.atan2(p2[1] - p1[1], p2[0] - p1[0]);
},
```

- 计算下一个点的位置

```javascript
nextPoint() {
 let index = this.index;
 let p1 = this.map.getPixelFromCoordinate(fromLonLat(this.carPoint[index]));
 let p2 = this.map.getPixelFromCoordinate(fromLonLat(this.carPoint[index + 1]));
 let dx = p2[0] - p1[0];
 let dy = p2[1] - p1[1];
 let distance = Math.sqrt(dx * dx + dy * dy)
 if(distance <= 1) {
   return this.carPoint[index + 1];
 } else {
   let x = p1[0] + dx / distance;
   let y = p1[1] + dy / distance;
   let coor = transform(
     this.map.getCoordinateFromPixel([x, y]),
     'EPSG:3857',
     'EPSG:4326'
   );
   this.carPoint[index] = coor;
   return this.carPoint[index];
 }
},
```

### 5、小结

- 之前我计算转折点和下一个点的位置的时候，使用的是点的经纬度进行计算，结果出来的画面有如下缺点：
  1. 高纬度旋转的角度不对
  2. 高纬度的速度过快
  3. 小车不沿着直线行走（应该是因为地球是球状的缘故）
- 后来了解到有`getPixelFromCoordinate`和`getCoordinateFromPixel`这两个接口可以让经纬度和像素之间转换，这里的转化需要转换成`EPSG:3857`坐标系，至于为什么用`transfrom`而不用`toLonLat` 的原因可以看我这篇博客 [openlayer提供的tranform与fromLonLat、toLonLat的区别](https://blog.csdn.net/weixin_43763952/article/details/113499481)

## 源码

- 该功能源码已上传[github](https://github.com/zhuo-zx/testOL/blob/master/src/components/TrailAnimate.vue)
- 还有其他的常用功能可以学习，[github/README](https://github.com/zhuo-zx/testOL)