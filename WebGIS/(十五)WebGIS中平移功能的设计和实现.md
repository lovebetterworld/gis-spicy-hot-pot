- [(十五)WebGIS中平移功能的设计和实现](https://www.cnblogs.com/naaoveGIS/p/4098608.html)

## 1.前言

这一章我们将详细讲解WebGIS工具栏中另一个基础工具——平移工具（Pan）。在介绍命令模式时，我们已经知道了此工具为Tool型的。

这个工具主要有如下两个功能：

A.当切换到此工具上时，按下鼠标不放，移动鼠标时可以拖动地图。

B.当切换到此工具上时，点击鼠标（鼠标不做平移），可以使地图平移，以点击处为中心。

## 2.设计

### 2.1 原理

我们已经知道，WebGIS中图层的本质是Canvas。平移效果的实现，其实质就是改变各Canvas的左上角坐标。

这里我给出示意图：

​      ![img](https://images0.cnblogs.com/blog/656746/201411/150047509755224.png)      

### 2.2提一个问题

当我把栅格图层所对应的canvas也平移后（事实上，所有的栅格canvas都是一个母容器（mapCanvas）中的child，平移是直接操作mapCanvas），此时我们再将屏幕地理范围内的瓦片请求回来时，贴到已经平移后的canvas上，会不会出现瓦片显示错乱呢？

答案是：不会的。下面，我大致讲一下原因。

在我们做平移时，我们不是简单的只对canvas的原点做了平移，我们同时还会更具平移大小换算出真实的地理平移，然后对实际的屏幕地理范围进行相应的改变。这样便会导致一个这样的结果：加入栅格图层的canvas原点是A，平移后变成了A1，而平移后重新请求的瓦片，其每个瓦片的原点所对应的便是A1，而不再是A。这样，我们便解决了平移栅格图层后，重新请求瓦片而导致的瓦片错乱问题。

### 2.3 平移公式

mapCanvas.y=mapCanvas.y+moveY;

mapCanvas.x=mapCanvas.x+moveX;

screenGeoBounds.bottom=screenGeoBounds.bottom+(sliceLevelLength/tileSize)*(moveY);

screenGeoBounds.top=screenGeoBounds.top+(sliceLevelLength/tileSize)*(moveY);

screenGeoBounds.left=screenGeoBounds.left-(sliceLevelLength/tileSize)*(moveX);

screenGeoBounds.right=screenGeoBounds.right-(sliceLevelLength/tileSize)*(moveX);

其中，mapCanvas表示（栅格或矢量）图层,screenGeoBounds表示屏幕地理范围，slieceLevelLength表示地图当前级别中一个瓦片所代表的实际地理长度，tileSize表示的是一张瓦片的屏幕像素。

## 3.实现

### 3.1 拖拽平移的实现

A．当鼠标触发mouseDown事件时，给全局变量flag赋值true，表示鼠标已经点下，记录下startPoint。

B．当鼠标触发mouseMove事件时，判断flag是否为true，如果是，调用平移公式，使图层出现移动，算出屏幕像素的移动mouseX和mouseY。

这里还可以继续扩展，如果有其他图层或者功能需要监听到地图平移时间，可以抛出一个地图平移事件，抛出的参数可以设置为此时鼠标所在的地理坐标（通过鼠标的屏幕坐标转换而得），以及鼠标平移的地理长度（通过mouseX和mouseY转换而得）。屏幕坐标与地理坐标的转换可以参考这个系列的第十章。

C．当鼠标触发mouseUp事件时，判断屏幕地理范围加上移动的地理长度后，是否在整个瓦片请求的容差范围内，如果在的话不用触发瓦片请求；如果不在的话，则需触发瓦片请求。请求参数即为目前的屏幕地理范围加上容差范围。

### 3.2 点击平移的实现

A.当鼠标触发mouseDown事件时，给全局变量isClick赋值true,其他操作同上。

B.当鼠标触发mouseMove事件时，则将此isClick参数赋值false。

C.当鼠标触发mouseClick事件时，判断isClick是否为true，如果是true，则将地图平移到以startPoint为中心的地方。

## 4. 提两个问题

A．在地图平移后，矢量图层的canvas的XY都发生了变化，此时根据地理坐标转换为屏幕坐标公式得出的屏幕坐标，在canvas上能将要素正确显示吗？

B．矢量图层canvas的原点坐标XY有需要还原成初始的（0,0）的时候吗？

## 5.总结

对于第四节中的两个问题，我给出的答案分别是：不能和需要。解答这两个问题，我们必须将之前给出的地理坐标与屏幕坐标互转换公式和今天我们讲到的平移公式合起来看，才能做很好的回答。