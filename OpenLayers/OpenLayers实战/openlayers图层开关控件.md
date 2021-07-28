- [openlayers图层开关控件](https://blog.csdn.net/u012413551/article/details/97425304)

# 1、目标

1）图层开关： 在控件上选中图层，对应的图层显示；取消选中，对应的图层关闭；
2）图层增删联动： 当map中的图层有增删时，控件随之改动。

# 2、控件开发

## 1）继承

图层开关控件类:ol.control.LayerSwitch
父类：ol.control.Control

```js
ol.control.LayerSwitch = function(opt_options){
    var options = opt_options ? opt_options : {};
    this.element = document.createElement('div');
    var defaultControlClassName = 'ol-unselectable ol-control';
    var className = 'ol-control-layerswitch';
    this.element.className = defaultControlClassName + ' ' + className;
    ol.control.Control.call(this, {
        element: this.element,
        target: options.target
    })
}
ol.inherits(ol.control.LayerSwitch, ol.control.Control);
```

## 2）控件属性

主要有三给属性
 1、初始化控件：用来实现控件初始化时的UI设置；
 2、增加图层选项：添加图层时自动触发
 3、移除图层选项：移除图层时自动触发

初始化：

```js
ol.control.LayerSwitch.prototype.init = function(){
    var layers = this.getMap().getLayers();
    layers.forEach(element => {
        this.addLayerItem(element);
    });
}
```

增加图层选项：

```js

/**
 * 添加选项
 * @param {ol.layer.Layer} layer
 */
ol.control.LayerSwitch.prototype.addLayerItem = function(layer){
    var div = document.createElement('div');
    div.className = 'ol-control-layerswitch-opt';
    div.setAttribute('layerid', ol.getUid(layer).toString());

    var child = document.createElement('input');
    child.setAttribute('type', 'checkbox');
    child.onclick = function(evt){
        layer.setVisible(evt.target.checked);
    };
    child.checked = true;
    div.appendChild(child);

    var label = document.createElement('span');
    label.innerText = layer.get('title');//以图层的title属性作为显示内容
    
    div.appendChild(label);

    this.element.appendChild(div);
}
```

移除图层选项：

```js
/**
 * 移除选项
 * @param {ol.layer.Layer} layer
 */
ol.control.LayerSwitch.prototype.removeLayerItem = function(layer){
    var childs = this.element.getElementsByClassName('ol-control-layerswitch-opt')
    for (let index = 0; index < childs.length; index++) {
        const divChild = childs[index];
        if(divChild.getAttribute('layerid') === ol.getUid(layer).toString()){
            this.element.removeChild(divChild);
        }
    }
}
```

# 3、示例

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190727203711357.gif)

# 4、存在的问题

ol.getUid(layer)报错
添加或者增删图层时，用ol.getUid(layer)来获取到图层的ID，作为唯一标识，但是发现引用ttps://openlayers.org/en/v4.6.5/build/ol.js这个js时，ol没有这个方法，在官网API中也没找到。但是引用下载到本地的openlayers的v.4.6.5版本中的ol-debug.js，是可以的。
openlayers5中ol已经增加了gitUid方法。
