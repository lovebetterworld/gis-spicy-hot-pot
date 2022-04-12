- [vue+OpenLayers项目实践（三）：Cluster设置集群 - 掘金 (juejin.cn)](https://juejin.cn/post/7026578356699136036)

## 一、前言

由于最近项目需要，需要在**vue**项目中使用**OpenLayers**来进行 GIS 地图的开发，网上对 OpenLayers 文章并不算太大，借此机会分享下自己在项目中实际使用的一些心得。

本系列将陆续分享项目过程中实现的一些功能点。 往期目录:

1. [vue+OpenLayers项目实践（一）：基本绘制与点击弹窗](https://juejin.cn/post/7025529005214269470)
2. [vue+OpenLayers项目实践（二）：多地图切换](https://juejin.cn/post/7026229212725903374)

实际项目中，我们往往需要在地图上批量绘制大量的坐标标记，如果标记过多的话，必然会造成渲染时间过长等一系列问题，而且在zoom比较小的时候也不利于查看，所以官方提供了一个集群API：**Cluster**，本文就简单讲述下该功能的使用过程。

[可以参考官方提供的example](https://link.juejin.cn?target=https%3A%2F%2Fopenlayers.org%2Fen%2Flatest%2Fexamples%2Fcluster.html)

## 二、具体实现

首先分析咱们需要实现的功能：

1. 绘制大量的坐标点；
2. 设置集群，通过缩放能展示不同的集群ui；
3. 通过点击集群点能够进行放大展示；
4. 其他优化；

### 1、绘制坐标点

这里只使用几个临近的点来做演示效果，更改之前的Home.vue代码

```js
// data添加
data() {
    return {
        ...
        markerLayer: null, // 坐标标记层
        markerSource: null, // 坐标数据源
    };
},
```

将获取点数据以及获取VectorSource封装出来，添加getPoints方法及setMarkerSource方法：

```js
// 演示直接静态返回坐标数组，实际项目中可改成接口获取数据
getPoints() {
    return [
        [108.945951, 34.465262],
        [109.04724, 34.262504],
        [108.580321, 34.076162],
        [110.458983, 35.071209],
        [105.734862, 35.49272],
    ];
},
    setMarkerSource() {
        let _style = new Style({
            image: new sCircle({
                radius: 10,
                stroke: new Stroke({
                    color: "#fff",
                }),
                fill: new Fill({
                    color: "#3399CC",
                }),
            }),
        });
        let _points = this.getPoints();
        let _features = _points.reduce((list, item) => {
            let _feature = new Feature({
                geometry: new Point(olProj.fromLonLat(item)),
            });
            _feature.setStyle(_style);
            list.push(_feature);
            return list;
        }, []);
        this.markerSource = new VectorSource({
            features: _features,
        });
    }
```

修改之前的setMarker方法：

```js
setMarker() {
    this.setMarkerSource();
    this.markerLayer = new VectorLayer({
        source: this.markerSource,
    });
    this.openMap.addLayer(this.markerLayer);
}
```

此时在地图上就成功绘制了5个坐标点

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/dd5d9ff9e3b34cd6a024692f87a9f05a~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp?)

### 2、设置集群

在这里我们添加Cluster集群，首先更改之前的setMarkerSource方法

```js
setMarkerSource() {
    ...
    this.markerSource = new Cluster({
        distance: 100,
        source: new VectorSource({
            features: _features,
        }),
    });
}
```

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/84cade73d83246c0ac1894b886369ef4~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp?) 刷新后可以看到聚合功能已经实现，但是之前的点位的样式丢失了，我们还需要调整下点位的样式。新建一个样式方法setClusterStyle：

```js
setClusterStyle() {
    const styleCache = {};
    const _style = (feature) => {
        const size = feature.get("features").length;
        let style = styleCache[size];
        if (!style) {
            style = new Style({
                image: new sCircle({
                    radius: 10,
                    stroke: new Stroke({
                        color: "#fff",
                    }),
                    fill: new Fill({
                        color: "#3399CC",
                    }),
                }),
                text: new Text({
                    text: size.toString(),
                    fill: new Fill({
                        color: "#fff",
                    }),
                }),
            });
            styleCache[size] = style;
        }
        return style;
    };
    return _style;
},
```

这里采用了闭包的形式，将size缓存起来。下面修改setMarker方法，添加样式，同时删除setMarkerSource方法中的样式设置：

```js
setMarker() {
    this.setMarkerSource();
    let _style = this.setClusterStyle();
    this.markerLayer = new VectorLayer({
        source: this.markerSource,
        style: _style,
    });
    this.openMap.addLayer(this.markerLayer);
}
```

![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/5232ca774c334780b52f98e505660a2b~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp?) ok，样式添加成功，但是这里我们希望非聚合的点，不显示数字，同时样式跟聚合的点也不一样，修改代码：

```js
setClusterStyle() {
    const styleCache = {};
    const _style = (feature) => {
        const size = feature.get("features").length;
        let style = styleCache[size];
        if (!style) {
            if (size > 1) {
                style = new Style({
                    image: new sCircle({
                        radius: 20,
                        stroke: new Stroke({
                            color: "#fff",
                        }),
                        fill: new Fill({
                            color: "#3399CC",
                        }),
                    }),
                    text: new Text({
                        text: size.toString(),
                        fill: new Fill({
                            color: "#fff",
                        }),
                    }),
                });
            } else {
                style = new Style({
                    image: new sCircle({
                        radius: 15,
                        stroke: new Stroke({
                            color: "#fff",
                        }),
                        fill: new Fill({
                            color: "#e9b626",
                        }),
                    }),
                });
            }
            styleCache[size] = style;
        }
        return style;
    };
    return _style;
}
```

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/cb81af8f41834812a83faa1a96b4ee3b~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp?) 这里直接通过size去判断是否是聚合，然后分别设置了不同的样式。

如果是需要更多个性化设置，在聚合时需要判断feature，并且你需要在每一个点的feature创建时使用feature.set("key","value","boolean")的方式把你的自定义信息写入，然后通过item.get("key")判断分别设置，可自行去研究。

### 3、集群点击事件

OK，接下来我们需要点击聚合点的时候进行放大，需要修改之前的点击事件singleclick

```js
singleclick() {
    // 点击
    this.openMap.on("singleclick", (e) => {
        this.markerLayer.getFeatures(e.pixel).then((clickedFeatures) => {
            if (clickedFeatures.length) {
                const features = clickedFeatures[0].get("features");
                if (features.length > 1) {
                    const extent = boundingExtent(
                        features.map((r) => r.getGeometry().getCoordinates())
                    );
                    this.openMap
                        .getView()
                        .fit(extent, { duration: 1000, padding: [200, 200, 200, 200] });
                } else {
                    this.shopPopup = true;
                    // 设置弹窗位置
                    let coordinates = features[0].getGeometry().getCoordinates();
                    this.popup.setPosition(coordinates);
                }
            } else {
                this.shopPopup = false;
            }
        });
    });
},
```

这里引用了一个新的类boundingExtent，该类为获取多边形的边界，参数为通过`features.map((r) => r.getGeometry().getCoordinates())`获取的坐标数组，然后通过fit()方法进行缩放，即缩放至最大化的展示聚合内部的所有点位，同时边界保留200的padding。

而非聚合的点位点击还是展示我们之前的弹窗。

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/2143569360de45e5a5274da1daa7a7d7~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp?)

### 4、其他优化

此时我们发现，当我们点击展示弹窗后进行缩放的话，弹窗并未消失，效果并不理想，所以需要监听缩放然后将弹窗隐藏。在getView()上添加监听change:resolution

```js
resolutionChange() {
    // 监听缩放
    this.openMap.getView().on("change:resolution", (e) => {
        console.log(e);
        this.shopPopup = false;
    });
}
```

## 最后

[gitee地址](https://link.juejin.cn?target=https%3A%2F%2Fgitee.com%2Fshtao_056%2Fvue-openlayers%2Ftree%2Fpart3)