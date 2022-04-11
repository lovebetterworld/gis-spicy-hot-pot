- [自定义控件（Custom Interactions）](https://blog.csdn.net/qq_35732147/article/details/82842167)

# 一、示例概述

这个示例演示了通过ol/interactions/Pointer类创建一个自定义交互小部件（custom interaction）。
    
这个自定义小部件的功能是让用户能够在地图上面自由地拖动要素。
# 二、代码详解

## 2.1、派生自定义类Drag

为了实现这个自定义小部件，我们需要一个比ol/interactions/Pointer类具有更多属性的类，那么最好的方式就是继承ol/interactions/Pointer类，从而派生我们自己的类Drag。

```js
//定义一个命名空间app
var app = {};

app.Drag = function(){
    //借用构造函数，使app.Drag继承ol.interaction.Pointer
    ol.interaction.Pointer.call(this, {                         //寄生组合式继承第二次调用
        handleDownEvent: app.Drag.prototype.handleDownEvent,
        handleDragEvent: app.Drag.prototype.handleDragEvent,
        handleMoveEvent: app.Drag.prototype.handleMoveEvent,
        handleUpEvent: app.Drag.prototype.handleUpEvent
    });

    this.coordinate_ = null;                        //保存鼠标点击坐标

    this.cursor_ = 'pointer';                       //保存当前鼠标光标样式

    this.feature_ = null;                           //保存鼠标起始点击相交的要素

    this.previousCursor_ = undefined;               //保存上一次鼠标光标样式
};
//寄生式继承，使app.Drag继承ol.interaction.Pointer的原型方法
ol.inherits(app.Drag, ol.interaction.Pointer);                  //寄生组合式继承第一次调用
```

这里使用了JavaScript的寄生组合式继承的方式，使app.Drag继承了ol/interactions/Pointer类，所以app.Drag现在拥有Pointer类的所有属性与方法（不懂寄生组合式继承的同学必须先看懂这篇文章：JavaScript的继承）。

OpenLayers为我们提供了寄生组合式继承中寄生式继承需要用到的函数ol.interits()，查看它的源码如下：

```js
 * @param {!Function} childCtor Child constructor.
 * @param {!Function} parentCtor Parent constructor.
 * @function module:ol.inherits
 * @deprecated
 * @api
 */
export function inherits(childCtor, parentCtor) {
  childCtor.prototype = Object.create(parentCtor.prototype);
  childCtor.prototype.constructor = childCtor;
}
```

 其实很简单，就是简单的寄生式继承的写法，创建了一个parentCtor原型对象的副本并赋给childCtor的原型对象，相信了解寄生组合式继承的同学都能看懂，这里就不赘述了。

app.Drag除了继承Pointer类，还添加了4个新属性：

- coordinate_    ——    用于保存鼠标点击的坐标
- cursor_    ——    用于保存当前鼠标光标的样式
- feature_    ——    用于保存与鼠标点击坐标相交的要素
- previousCursor_    ——    用于保存上一次鼠标光标的样式

## 2.1、添加Drag类的原型方法

首先需要一个监听鼠标点击（不包括松开）地图时触发的事件处理函数handleDownEvent：

```js
//Function handling "down" events. 
//If the function returns true then a drag sequence is started.
app.Drag.prototype.handleDownEvent = function(evt){
    var map = evt.map;

    //返回鼠标点击相交的要素
    var feature = map.forEachFeatureAtPixel(evt.pixel, function(feature){
        return feature;
    });

    if(feature){
        this.coordinate_ = evt.coordinate;  //保存鼠标点击的坐标
        this.feature_ = feature;            //保存与鼠标点击的坐标相交的要素
    }

    return !!feature;   //相当于Boolean(feature)
};
```

 handleDownEvent函数会在鼠标点击地图时触发，如果鼠标点击了要素，就会：

- 将鼠标点击的地图坐标保存到app.Drag类的coordinate_属性
- _将被鼠标点击的要素保存到app.Drag类的feature_属性
- 返回true，开启拖拉要素

鼠标拖拉要素时触发的事件处理函数：

```js
//Function handling "drag" events. 
//This function is called on "move" events during a drag sequence.
app.Drag.prototype.handleDragEvent = function(evt){
    var deltaX = evt.coordinate[0] - this.coordinate_[0];
    var deltaY = evt.coordinate[1] - this.coordinate_[1];

    var geometry = this.feature_.getGeometry();
    geometry.translate(deltaX, deltaY);                     //使图形转移deltaX、deltaY

    //将鼠标所在新的坐标点保存到app.Drag的coordinate_属性中
    this.coordinate_[0] = evt.coordinate[0];                
    this.coordinate_[1] = evt.coordinate[1];
}
```

 鼠标拖拉要素时，该事件处理函数就会执行：

- 使拖拉的要素随鼠标光标一起移动
- 将鼠标所在新的坐标点保存到app.Drag的coordinate_属性中

 

  鼠标在地图上移动时触发的事件处理函数：

```js
//Function handling "move" events. 
//This function is called on "move" events, also during a drag sequence
//(so during a drag sequence both the handleDragEvent function and this function are called).
app.Drag.prototype.handleMoveEvent = function(evt){
    if(this.cursor_){
        var map = evt.map;
        var feature = map.forEachFeatureAtPixel(evt.pixel, function(feature){
            return feature;
        });
        var element = evt.map.getTargetElement();                 //获取地图的div元素容器
        if(feature){       
            //如果鼠标坐标点与某个要素相交                          
            if(element.style.cursor != this.cursor_){
                //如果地图上鼠标光标的样式与app.Drag的cursor_属性保存的鼠标样式不一样
                this.previousCursor_ = element.style.cursor;
                element.style.cursor = this.cursor_;             //转换光标
            }
        }else if(this.previousCursor_ !== undefined){
            //如果鼠标坐标点不与任何要素相交，且app.Drag的previousCursor_属性不是undefined
            element.style.cursor = this.previousCursor_;         //转换光标
            this.previousCursor_ = undefined;
        }
    }
};
```

  鼠标在地图上移动就会触发该事件处理函数。

- 如果鼠标坐标点与某个要素相交，就会将鼠标光标转换为手形。

- 如果鼠标坐标点不与任何要素相交，鼠标光标就仍是箭头形的。

这里值得注意的是，不管是否处于拖拉要素的状态，该事件处理函数都会触发，即鼠标只要在地图上移动，该事件处理函数就会触发。

 


鼠标在点击松开时触发的事件处理函数：

```js
//Function handling "up" events.
//If the function returns false then the current drag sequence is stopped.
app.Drag.prototype.handleUpEvent = function(){
    this.coordinate_ = null;
    this.feature_ = null;
    return false;
};
```

- app.Drag的coordinate_属性设置为null
- app.Drag的feature_属性设置为null
- 返回false，关闭拖拉要素

## 2.3、将自定义交互小部件添加到地图

```js
var map = new ol.Map({
    //实例化自定义交互小部件app.Drag，并将其添加到默认交互部件中。
    interactions: ol.interaction.defaults().extend([new app.Drag()]),
    layers: [
        new ol.layer.Tile({
            source: new ol.source.TileJSON({
                url: 'https://api.tiles.mapbox.com/v3/mapbox.geography-class.json?secure'
            })
        }),
        new ol.layer.Vector({
            source: new ol.source.Vector({
                features: [pointFeature, lineFeature, polygonFeature]
            }),
            style: new ol.style.Style({
                image: new ol.style.Icon({
                    anchor: [0.5, 46],
                    anchorXUnits: 'fraction',
                    anchorYUnits: 'pixels',
                    opacity: 0.95,
                    src: 'data/icon.png'
                }),
                stroke: new ol.style.Stroke({
                    width: 3,
                    color: [255, 0, 0, 1]
                }),
                fill: new ol.style.Fill({
                    color: [0, 0, 255, 0.6]
                })
            })
        })
    ],
    target: 'map',
    view: new ol.View({
        center: [0, 0],
        zoom: 2
    })
});
```

# 三、完整代码

```js
<!-- This example demonstrates creating a custom interaction by subclassing ol/interaction/Pointer.
Note that the built in interaction ol/interaction/Translate might be a better option for moving features -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Custom Interactions</title>
    <link href="ol_v5.0.0/css/ol.css" rel="stylesheet" type="text/css" />
    <script src="ol_v5.0.0/build/ol.js" type="text/javascript"></script>
</head>
<body>
    <div id="map" class="map"></div>
 
    <script>
        //定义一个命名空间app
        var app = {};
 
        app.Drag = function(){
            //借用构造函数，使app.Drag继承ol.interaction.Pointer
            ol.interaction.Pointer.call(this, {                         //寄生组合式继承第二次调用
                handleDownEvent: app.Drag.prototype.handleDownEvent,
                handleDragEvent: app.Drag.prototype.handleDragEvent,
                handleMoveEvent: app.Drag.prototype.handleMoveEvent,
                handleUpEvent: app.Drag.prototype.handleUpEvent
            });
 
            this.coordinate_ = null;                        //保存鼠标点击坐标
 
            this.cursor_ = 'pointer';                       //保存当前鼠标光标样式
 
            this.feature_ = null;                           //保存鼠标起始点击相交的要素
 
            this.previousCursor_ = undefined;               //保存上一次鼠标光标样式
        };
        //寄生式继承，使app.Drag继承ol.interaction.Pointer的原型方法
        ol.inherits(app.Drag, ol.interaction.Pointer);                  //寄生组合式继承第一次调用
 
        //以上代码使用寄生组合式继承的方式使app.Drag继承了ol/interaction.Pointer类，
        //并添加了额外的coordinate_, cursor_, feature_, previousCursor_ 4个新属性
 
        //Function handling "down" events. 
        //If the function returns true then a drag sequence is started.
        app.Drag.prototype.handleDownEvent = function(evt){
            var map = evt.map;
            
            //返回鼠标点击相交的要素
            var feature = map.forEachFeatureAtPixel(evt.pixel, function(feature){
                return feature;
            });
 
            if(feature){
                this.coordinate_ = evt.coordinate;  //保存鼠标点击的坐标
                this.feature_ = feature;            //保存与鼠标点击的坐标相交的要素
            }
 
            return !!feature;   //相当于Boolean(feature)
        };
 
        //Function handling "drag" events. 
        //This function is called on "move" events during a drag sequence.
        app.Drag.prototype.handleDragEvent = function(evt){
            var deltaX = evt.coordinate[0] - this.coordinate_[0];
            var deltaY = evt.coordinate[1] - this.coordinate_[1];
 
            var geometry = this.feature_.getGeometry();
            geometry.translate(deltaX, deltaY);                     //使图形转移deltaX、deltaY
            
            //将鼠标所在新的坐标点保存到app.Drag的coordinate_属性中
            this.coordinate_[0] = evt.coordinate[0];                
            this.coordinate_[1] = evt.coordinate[1];
        }
 
        //Function handling "move" events. 
        //This function is called on "move" events, also during a drag sequence
        //(so during a drag sequence both the handleDragEvent function and this function are called).
        app.Drag.prototype.handleMoveEvent = function(evt){
            if(this.cursor_){
                var map = evt.map;
                var feature = map.forEachFeatureAtPixel(evt.pixel, function(feature){
                    return feature;
                });
                var element = evt.map.getTargetElement();                 //获取地图的div元素容器
                if(feature){       
                    //如果鼠标坐标点与某个要素相交                          
                    if(element.style.cursor != this.cursor_){
                        //如果地图上鼠标光标的样式与app.Drag的cursor_属性保存的鼠标样式不一样
                        this.previousCursor_ = element.style.cursor;
                        element.style.cursor = this.cursor_;             //转换光标
                    }
                }else if(this.previousCursor_ !== undefined){
                    //如果鼠标坐标点不与任何要素相交，且app.Drag的previousCursor_属性不是undefined
                    element.style.cursor = this.previousCursor_;         //转换光标
                    this.previousCursor_ = undefined;
                }
            }
        };
 
        //Function handling "up" events.
        //If the function returns false then the current drag sequence is stopped.
        app.Drag.prototype.handleUpEvent = function(){
            this.coordinate_ = null;
            this.feature_ = null;
            return false;
        };
 
        var pointFeature = new ol.Feature(new ol.geom.Point([0, 0]));
        
        var lineFeature = new ol.Feature(
            new ol.geom.LineString([[-1e7, 1e6], [-1e6, 3e6]])
        );
 
        var polygonFeature = new ol.Feature(
            new ol.geom.Polygon([[[-3e6, -1e6], [-3e6, 1e6],
                [-1e6, 1e6], [-1e6, -1e6], [-3e6, -1e6]]])
        );
 
        var map = new ol.Map({
            //实例化自定义交互小部件app.Drag，并将其添加到默认交互部件中。
            interactions: ol.interaction.defaults().extend([new app.Drag()]),
            layers: [
                new ol.layer.Tile({
                    source: new ol.source.TileJSON({
                        url: 'https://api.tiles.mapbox.com/v3/mapbox.geography-class.json?secure'
                    })
                }),
                new ol.layer.Vector({
                    source: new ol.source.Vector({
                        features: [pointFeature, lineFeature, polygonFeature]
                    }),
                    style: new ol.style.Style({
                        image: new ol.style.Icon({
                            anchor: [0.5, 46],
                            anchorXUnits: 'fraction',
                            anchorYUnits: 'pixels',
                            opacity: 0.95,
                            src: 'data/icon.png'
                        }),
                        stroke: new ol.style.Stroke({
                            width: 3,
                            color: [255, 0, 0, 1]
                        }),
                        fill: new ol.style.Fill({
                            color: [0, 0, 255, 0.6]
                        })
                    })
                })
            ],
            target: 'map',
            view: new ol.View({
                center: [0, 0],
                zoom: 2
            })
        });
    </script>
</body>
</html>
```

# 四、总结

这个示例的难点是寄生组合式继承，不太了解JavaScript的这种继承方式的同学可能觉得比较复杂，但是多思考几遍还是能很熟练的掌握这种继承方式。
    
其次就是定义事件处理函数，可以说OpenLayers使用事件处理函数给我们提供了适当的接口，让我们自己去实现想要的功能。