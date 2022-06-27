- [openlayers学习——4、openlayers弹出框popup弹出层Overlay_WangConvey的博客-CSDN博客_openlayers popup](https://blog.csdn.net/weixin_43390116/article/details/122350894)

**openlayers核心：Map对象、View视图、Layer图层、Source来源、Feature特征等**

*在地图DOM同级别设置弹出框DOM*

```html
<!-- 这里随意设置，没有什么规则，就像普通盒子模型一样，主要是css设置 -->
<div id="popup" class="ol-popup">
  <a href="#" id="popup-closer" class="ol-popup-closer" @click="removePopup" />
  <div id="popup-content" />
</div>

```

```css
// 核心就是绝对定位
.ol-popup {
  position: absolute;
  background-color: white;
  box-shadow: 0 1px 4px rgba(0,0,0,0.2);
  padding: 15px;
  border-radius: 10px;
  border: 1px solid #cccccc;
  bottom: 12px;
  left: -50px;
  min-width: 280px;
}
.ol-popup:after, .ol-popup:before {
  top: 100%;
  border: solid transparent;
  content: " ";
  height: 0;
  width: 0;
  position: absolute;
  pointer-events: none;
}
.ol-popup:after {
  border-top-color: white;
  border-width: 10px;
  left: 48px;
  margin-left: -10px;
}
.ol-popup:before {
  border-top-color: #cccccc;
  border-width: 11px;
  left: 48px;
  margin-left: -11px;
}
.ol-popup-closer {
  text-decoration: none;
  position: absolute;
  top: 2px;
  right: 8px;
}
.ol-popup-closer:after {
  content: "✖";
}
```

```js
import Overlay from 'ol/Overlay'
// 核心思想：创建弹出层对象、绑定DOM、编辑弹出层内容、添加到map中、设置位置
// 弹出框
addPopup (ctn = [118.339408, 32.261271]) {
  this.removePopup()
  // 获取弹出层DOM
  const container = document.getElementById('popup')
  const content = document.getElementById('popup-content')
  if (this.overlay) {
  } else {
    // 创建Overlay弹出层绑定DOM
    this.overlay = new Overlay({
      element: container,
      autoPan: {
        animation: {
          duration: 250
        }
      }
    })
    // 添加到map
    this.map.addOverlay(this.overlay)
  }
  // 弹出层内容
  content.innerHTML = `
                      <b style='color: blue'>弹出层信息</b>
                      <br/>
                      <table>
                        <tr>
                          <th>信息1：</th>
                          <td>XXXXXXXXX</td>
                        </tr>
                        <tr>
                          <th>信息2：</th>
                          <td>XXXXXXXXX</td>
                        </tr>
                      </table>
                      `
  // 设置弹出层位置即可出现
  this.overlay.setPosition(ctn)
},
// 清除弹出框
removePopup () {
  if (this.overlay) {
    // 设置位置undefined可达到隐藏清除弹出框
    this.overlay.setPosition(undefined)
  }
}
```

最后效果

![在这里插入图片描述](https://img-blog.csdnimg.cn/ade1ca8cd4c441a2862869942f8f54e9.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAV2FuZ0NvbnZleQ==,size_20,color_FFFFFF,t_70,g_se,x_16)