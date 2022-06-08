- [openlayers设置黑色底图，自定义修改天地图颜色_Southejor的博客-CSDN博客_天地图样式修改](https://blog.csdn.net/linzi19900517/article/details/120307650)

# 前言

   由于项目需要大屏展示添加动态地图，大屏多数都是使用蓝黑色底图，目前天地图不提供蓝黑色瓦片，使用商用服务资源，需要转换坐标，比较麻烦。
   同事发现天地图api可以将普通瓦片转为蓝黑色，于是尝试获取瓦片，修改颜色来实现加载天地图蓝黑色底图。

------

以下是本篇文章正文内容，下面案例可供参考

# 一、尝试参照官方示例

参照官方示例 [Color Manipulation](https://openlayers.org/en/latest/examples/color-manipulation.html)。

尝试之后发现，可以实现效果，***但是卡顿明显***，不能满足项目需求。

# 二、代码改进

### 核心代码

代码如下（示例）：

```javascript
import LayerTile from 'ol/layer/Tile';
import ImageLayer from 'ol/layer/Image';
import {Raster as RasterSource} from 'ol/source';

  let layerOrigin = new LayerTile({
      name: "天地图矢量图层",
      source: 天地图source
  });
  //定义颜色转换方法
 let reverseFunc = function (pixelsTemp) {
      //蓝色
      for (var i = 0; i < pixelsTemp.length; i += 4) {
          var r = pixelsTemp[i];
          var g = pixelsTemp[i + 1];
          var b = pixelsTemp[i + 2];
          //运用图像学公式，设置灰度值
          var grey = r * 0.3 + g * 0.59 + b * 0.11;
          //将rgb的值替换为灰度值
          pixelsTemp[i] = grey;
          pixelsTemp[i + 1] = grey;
          pixelsTemp[i + 2] = grey;

          //基于灰色，设置为蓝色，这几个数值是我自己试出来的，可以根据需求调整
          pixelsTemp[i] = 55 - pixelsTemp[i];
          pixelsTemp[i + 1] = 255 - pixelsTemp[i + 1];
          pixelsTemp[i + 2] = 305 - pixelsTemp[i + 2];
      }
  };
 //openlayer 像素转换类，可以直接当做source使用
 const raster = new RasterSource({
     sources: [
         //传入图层，这里是天地图矢量图或者天地图矢量注记
         layerOrigin,
     ],
     //这里设置为image类型，与官方示例不同，优化速度
     operationType: 'image',
     operation: function (pixels, data) {
         //执行颜色转换方法，注意，这里的方法需要使用lib引入进来才可以使用
         reverseFunc(pixels[0].data)
         return pixels[0];
     },
     //线程数量
     threads: 10,
     //允许operation使用外部方法
     lib: {
         reverseFunc: reverseFunc,
     }
 });
 //创建新图层，注意，必须使用 ImageLayer
 let layer = new ImageLayer({
          name: "天地图矢量图层",
          source: raster
 });
 //添加到地图
 map.addLayer(layer)
```

### 效果展示

![蓝黑色底图](https://img-blog.csdnimg.cn/32850eb019e14037940574feb340c3f4.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAU291dGhlam9y,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)
墨绿色
![在这里插入图片描述](https://img-blog.csdnimg.cn/b75b37bc4da84950ae0c3df11683443c.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAU291dGhlam9y,size_20,color_FFFFFF,t_70,g_se,x_16)

### 工具类下载

嫌麻烦可以直接下载[工具类](https://download.csdn.net/download/linzi19900517/22992628)使用