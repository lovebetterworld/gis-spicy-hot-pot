- [高德地图+echarts 大屏项目](https://blog.csdn.net/qq_39503511/article/details/114493196)

# 概述

开发了一个高德地图视角实时更新的项目demo，先看视频效果

<iframe id="J2t3GEt4-1615169865727" src="https://live.csdn.net/v/embed/156522" allowfullscreen="true" data-mediaembed="csdn"></iframe>

高德地图+echarts 马拉松大屏项目

# 初始化地图

创建一个初始化地图的类ZMap, 写入initMap方法加载地图

```javascript
initMap(option) {
    let config = {
      resizeEnable: true,
      center: [116.479126, 39.998563],
      zoom: 20,
      pitch: 65,
      rotation: 4.509173845626157,
      viewMode: '3D', //开启3D视图,默认为关闭
      buildingAnimation: true, //楼块出现是否带动画
    }

    this.map = new AMap.Map(this.id, Object.assign(config, option));

    window.map = this.map;
  }
```

在场景中调用即可此方法即可
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210314131842202.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70)

# 创建马拉松路线

原理，根据起始点和终点获取中间经过的所有点，然后保存成数组，生成路线

```javascript
setDriving(start, end) {
    if (!this.driving) {
      let drivingOption = {}
      this.driving = new AMap.Driving(drivingOption);
    }
    return new Promise(resolve => {
      this.driving.search(start, end, function (status, result) {
        if (status === 'complete') {
          console.log(result);
          if (result.routes && result.routes[0].steps.length) {
            
            let path = [];
            let roads = [];
            result.routes[0].steps.forEach(item => {
              roads.push({
                roadName: item.road,
                position: [item.end_location.lng, item.end_location.lat]
              })
              item.path.forEach(step => {
                path.push([step.lng, step.lat])
              })
            });
            resolve({
              path,
              roads
            })
          }
        }
      });
    })
  }
```

输入两个坐标即可获取所有点，根据点数组画线和路标文本

```javascript
export function drawRoute(app, pathInfo) {
  app.loaderMarker({
    position: pathInfo.path[0]
  });

  app.loaderMarker({
    position: pathInfo.path[pathInfo.path.length - 1],
    icon: 'https://webapi.amap.com/theme/v1.3/markers/n/end.png'
  });

  app.loaderPolyline({path: pathInfo.path});

  pathInfo.roads.forEach(item => {
    if (item.roadName) {
      let text = app.loaderText({text: item.roadName, position: item.position})
      text.setMap(app.map);
    }
  });
}
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/2021031413213052.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70)
 接下来在创建一条线表示马拉松当前进行到的位置

```javascript
passedPolyline = app.loaderPolyline({
        strokeColor: "#AF5",
        strokeWeight: 8,
      });
marker = app.loaderMarker({
        icon: '',
        position: pathInfo.path[0],
      });
```

最后我们在给market绑定移动物体事件，在移动物体的时候更新marker的位置和设置线条即可，此处代码可以看博客中的高德地图3D轨迹回放 + 视野跟随功能此文章，有具体的代码写法
 左右两侧的报表是基于datav和echarts做的，很简单，这里就不介绍了，最后的效果
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210314132853956.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5NTAzNTEx,size_16,color_FFFFFF,t_70)

