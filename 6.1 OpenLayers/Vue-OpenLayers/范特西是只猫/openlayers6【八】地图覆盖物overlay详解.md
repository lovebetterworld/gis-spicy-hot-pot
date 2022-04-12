- [openlayers6【八】地图覆盖物overlay详解_范特西是只猫的博客-CSDN博客_openlayers覆盖物](https://xiehao.blog.csdn.net/article/details/106377784)

## 1. overlay 简述

overlay是覆盖物的意思，顾名思义就是在地图上以另外一种形式浮现在地图上，这里很多同学会跟图层layers搞混淆，主要是放置一些和地图位置相关的元素，常见的地图覆盖物为这三种类型，如：`popup 弹窗`、`label标注信息`、`text文本信息`等，而这些覆盖物都是和html中的element等价的，通过overlay的属性element和html元素绑定同时设定坐标参数——达到将html元素放到地图上的位置，在平移缩放的时候html元素也会随着地图的移动而移动。

下面我们在看下官网的描述，其实map默认是存在这个属性，跟前面写的文章，图层，控件，交互都一个性质，都是`默认加载地图的情况下是允许设置默认的overlay覆盖物`，也可以在某个事件或者方法触发的时候去单独添加覆盖物。这里可以看下前面的文章描述，具体不进行详细阐述。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200605164535169.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2NDEwNzk1,size_16,color_FFFFFF,t_70)

## 2. overlay 属性

> overlay初始化时可以接受很多的配置参数，这些配置参数是一个个的键值对，共同构成一个对象字面量（options），然后传递给其“构造函数”，如`new ol.Overlay(options)`，此处的 options 便是参数键值对构成的对象字面量。可配置的键值对，定义如下：(红色为常用属性)

- `id`，为对应的 overlay 设置一个 id，便于使用 ol.Map 的 getOverlayById 方法取得相应的 overlay；
- `element`，overlay 包含的 DOM element；
- `offset`，偏移量，像素为单位，overlay 相对于放置位置（position）的偏移量，默认值是 [0, 0]，正值分别向右和向下偏移；
- `position`，在地图所在的坐标系框架下，overlay 放置的位置；
- `positioning`，overlay 对于 position 的相对位置，可能的值包括 bottom-left、bottom-center、bottom-right 、center-left、center-center、center-right、top-left、top-center、top-right，默认是 top-left，也就是 element 左上角与 position 重合；
- `stopEvent`，地图的事件传播是否停止，默认是 true，即阻止传播，可能不太好理解，举个例子，当鼠标滚轮在地图上滚动时，会触发地图缩放事件，如果在 overlay 之上滚动滚轮，并不会触发缩放事件，如果想鼠标在 overlay 之上也支持缩放，那么将该属性设置为 false 即可；
- insertFirst，overlay 是否应该先添加到其所在的容器（container），当 stopEvent 设置为 true 时，overlay 和 openlayers 的控件（controls）是放于一个容器的，此时将 insertFirst 设置为 true ，overlay 会首先添加到容器，这样，overlay 默认在控件的下一层（CSS z-index），所以，当 stopEvent 和insertFirst 都采用默认值时，overlay 默认在 控件的下一层
- `autoPan`，当触发 overlay setPosition 方法时触发，当 overlay 超出地图边界时，地图自动移动，以保证 overlay 全部可见；
- autoPanAnimation，设置 autoPan 的效果动画，参数类型是 olx.animation.panOptions
- autoPanMargin，地图自动平移时，地图边缘与 overlay 的留白（空隙），单位是像素，默认是 20像素；

后面案例中使用。

## 2. overlay 事件

> 支持的事件主要是继承 `ol.Object` 而来的 `change` 事件，当 overlay 相关属性或对象变化时触发：

- change，当引用计数器增加时，触发；
- change:element，overlay 对应的 element 变化时触发；
- change:map，overlay 对应的 map 变化时触发；
- change:offset，overlay 对应的 offset 变化时触发；
- change:position，overlay 对应的 position 变化时触发；
- change:positioning，overlay 对应的 positioning 变化时触发；
- propertychange，overlay 对应的属性变化时触发；
  那么怎么绑定相应的事件呢？openlayers 绑定事件遵循一般的 dom 事件绑定规则，包括 DOM 2 级事件绑定，以下是一个例子，这个例子说明了 overlay 的位置变化时在浏览器的控制台输出字符串的例子。

```js
var overlay = new ol.Overlay({
    // 创建 overlay ...省略
});
// 事件
overlay.on("change:position", function(){
    console.log("位置改变！");
})
```

## 4. overlay 方法

> 支持的方法这里我们只介绍 overlay 特有的方法，就不介绍其继承而来的方法了，主要是针对 overlay 的属性及其相关联对象的 `get`和 `set`方法。

- getElement，取得包含 overlay 的 DOM 元素；
- getId，取得 overlay 的 id；
- getMap，获取与 overlay 关联的 map对象；
- getOffset，获取 offset 属性；
- getPosition，获取 position 属性；
- getPositioning，获取 positioning 属性；
- setElement；设置 overlay 的 element；
- setMap，设置与 overlay 的 map 对象；
- setOffset，设置 offset；
- setPosition，设置 position 属性；
- setPositioning，设置 positioning 属性。

## 5. 写到最后

开篇我们提到了 overlay 有三种常见的用法 `popup 弹窗`、`label标注信息`、`text文本信息`

详细内容参考此篇文章 [openlayers6【八】地图覆盖物overlay三种常用用法 popup弹窗，marker标注，text文本](https://editor.csdn.net/md/?articleId=106425363)