- [openlayers学习——12、openlayers图层透明度_WangConvey的博客-CSDN博客_openlayers 图层透明度](https://blog.csdn.net/weixin_43390116/article/details/122449702)

**openlayers核心：Map对象、View视图、Layer图层、Source来源、Feature特征等**

***注：图层如何添加请参考 [openlayers学习——7、openlayers加图层](https://blog.csdn.net/weixin_43390116/article/details/122366149)
这里不做过多展示和代码描述***

透明度控件DOM

```html
<input
  id="opacity-input" type="range" min="0" max="1"
  step="0.01" value="1" style="width: 150px;display: inline-block;margin-right: 10px;margin-left: 8px;vertical-align: bottom;"
>

```

监听该DOM

```javascript
mounted () {
  // 改变了就触发，鼠标不用松开，change事件，鼠标需要松开才能触发
  document.getElementById('opacity-input').addEventListener('input', this.opacityChange)
}
```

设置透明度处理函数

```javascript
// 透明度处理函数
// 核心就是图层对象的setOpacity方法
opacityChange () {
  if (this.layer) {
    this.layer.setOpacity(parseFloat(document.getElementById('opacity-input').value))
  }
}
```

效果如下

![在这里插入图片描述](https://img-blog.csdnimg.cn/be3e79b7ff99422e997153b8657affb7.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAV2FuZ0NvbnZleQ==,size_20,color_FFFFFF,t_70,g_se,x_16)