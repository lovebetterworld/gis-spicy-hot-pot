- [Vue + OpenLayers 动态增加和删除标记](https://blog.csdn.net/weixin_39340061/article/details/108147709)



# 前言

一个简单的示例，用于动态向 Openlayers 地图添加标记。

# 1. 动画演示

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200821152732653.gif#pic_center)

# 2. 代码

```js
	<template>
	  <div>
	    <img src="@/assets/logo-03.png" />
	    <div id="map" class="map"></div>
	    <button @click="addRandomFeature">add</button>
	    <button @click="removeRandomFeature">remove</button>
	  </div>
	</template>
	
	<script>
	import "ol/ol.css";
	import Feature from "ol/Feature";
	import Map from "ol/Map";
	import Point from "ol/geom/Point";
	import TileJSON from "ol/source/TileJSON";
	import VectorSource from "ol/source/Vector";
	import View from "ol/View";
	import { Icon, Style } from "ol/style";
	import { Tile as TileLayer, Vector as VectorLayer } from "ol/layer";
	import { fromLonLat } from "ol/proj";
	
	var london = new Feature({
	  geometry: new Point(fromLonLat([-0.12755, 51.507222]))
	});
	
	var madrid = new Feature({
	  geometry: new Point(fromLonLat([-3.683333, 40.4]))
	});
	var paris = new Feature({
	  geometry: new Point(fromLonLat([2.353, 48.8566]))
	});
	var berlin = new Feature({
	  geometry: new Point(fromLonLat([13.3884, 52.5169]))
	});
	
	london.setStyle(
	  new Style({
	    image: new Icon({
	      color: "#4271AE",
	      crossOrigin: "anonymous",
	      src: "https://openlayers.org/en/latest/examples/data/bigdot.png",
	      scale: 0.2
	    })
	  })
	);
	
	madrid.setStyle(
	  new Style({
	    image: new Icon({
	      crossOrigin: "anonymous",
	      src: "https://openlayers.org/en/latest/examples/data/bigdot.png",
	      scale: 0.2
	    })
	  })
	);
	
	paris.setStyle(
	  new Style({
	    image: new Icon({
	      color: "#8959A8",
	      crossOrigin: "anonymous",
	      // For Internet Explorer 11
	      imgSize: [20, 20],
	      src: "https://openlayers.org/en/latest/examples/data/bigdot.png"
	    })
	  })
	);
	
	berlin.setStyle(
	  new Style({
	    image: new Icon({
	      crossOrigin: "anonymous",
	      // For Internet Explorer 11
	      imgSize: [20, 20],
	      src: "https://openlayers.org/en/latest/examples/data/bigdot.png"
	    })
	  })
	);
	var vectorSource = new VectorSource({
	  features: [london, madrid, paris, berlin]
	});
	
	var vectorLayer = new VectorLayer({
	  source: vectorSource
	});
	
	var rasterLayer = new TileLayer({
	  source: new TileJSON({
	    url: "https://a.tiles.mapbox.com/v3/aj.1x1-degrees.json?secure=1",
	    crossOrigin: ""
	  })
	});
	
	export default {
	  data() {
	    return {
	      map: {},
	      i: 0
	    };
	  },
	  mounted() {
	    this.map = new Map({
	      layers: [rasterLayer, vectorLayer],
	      target: document.getElementById("map"),
	      view: new View({
	        center: fromLonLat([2.896372, 44.6024]),
	        zoom: 0.1
	      })
	    });
	  },
	  methods: {
	    removeRandomFeature() {
	      if (this.i > 0) {
	        vectorSource.removeFeature(vectorSource.getFeatureById("a" + this.i));
	        this.i = this.i - 1;
	      }
	    },
	    addRandomFeature() {
	      vectorSource.forEachFeature(function(e) {
	        console.log(e.getId());
	      });
	
	      var x = Math.random() * 50;
	      var y = Math.random() * 50;
	      var geom = new Point(fromLonLat([x, y]));
	      var rome = new Feature(geom);
	      
	      this.i = this.i + 1;
	      rome.setId("a" + this.i);
	      
	      rome.setStyle(
	        new Style({
	          image: new Icon({
	            color: "#BADA55",
	            crossOrigin: "anonymous",
	            // For Internet Explorer 11
	            src:
	              "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACEAAAAgCAYAAACcuBHKAAAACXBIWXMAAAsSAAALEgHS3X78AAAD6klEQVRYhaWXzYscRRTAX71XXdOjwg5ZNmvEMK3gYc0aO9Gbws4pogd3DgrenAbx4h4mkAQ8mHRyEwUjeJKFHcU/YPYg4m1WAoLophVJDjk4A0FNspFdkqBmp6uk+sve+ezuefB4Nc10vV+9eu9VNVNKwSzyO5u3nlB3u7PMgTMB8PkGEPwW2BmkcCT+WJzTjjdSj5wjt/ZaReYqBPHn0mODAAnI49fv5wbJDXHr5fI4gARk8crfuUByQdxeFdMAEpDDmw8zg2SGuPsuzwqQgMx/3s8Ekgli72JugARk7sJ0kKkQD9apKEAC8ug7/kSQiRD/foOzAiQgpVflWJCxEL7HBgF6AOBF2o10UCoAYAOABQA1AKimQchWI0FGQqQAtgBAv9ghW+Vuzb7HYhg938o4kCGICEC/6KYdHz7xQU0i2X6g3JJIoK2PVPWR9xTnXTIF8LLwuCn0uLO7vuoNALnRglrTIKzY+dFjZ+oSqeEjaYA5Hzn4SCAj65O24ZgJA3i5BNwUQGURWF4We2QabSqJ1k33pU40v0228iZCaLGWmg3F0JWIepUgGUXOY8cUOY+giAOWAqchSDkcR5EJwUyxRabh3njvuc7E7bCWmnaUA89LhoHTMOyxTUfiYDQOAqRABqFMY5OE0fjlrepu7BfTqweAqxpgdJqxxCbYjIXPWUoxrQgMGTDSioBcK61iiXdf+Pq2FU/DRzscK7pMO1F5DoUVWFCacUWsAIvZWQLNEAER59AgOy7zBKJ7/XLLWmrCiObUi7ao/deP5z3IKAvNbyugVB0UuKBUNQifVKCkBOlLZ/vUfHtkTqS2ZUMy7Ekk9+avHxW6qByY88Mf6twUl8kUVTIN59rbz0wu0UmycPKC7hN1H7m2FaktcV26e5K4R2Wxyx8pebws2ve+fONA1J7++KcKmUbtxtrx9qCLqRBHl89UfEZNibwRNqawJJPqiCuFCMj8vxK4KXq8LNydz16b7RStPnvakow6MnY+VKYjGla6WYX9YfPOp6/UJ0FMvG33rn3SZaBcAKVpAVRoA4VIg98SUCmQfT/U/VD9/T74D/eHwp8rErE8uXy2IZE2ogj87CO1JVJnKCpINWYYNTLFCjcNoJLh3PvqzemJrSGy6JHlc/bi8fetLP+lU+u2eP2LRta5C135D714qR6cqExXCNkSqesjdSUjr//d2tTwD0puiIUT54OtkYjBwZacLcE4OG+e6m+t5bp75P4MvHP1Uosp6cQJGSSl1InpAyrp5AUoBKFlZ/tiC6V0MKiKRJ1/rpwu1F0LfxDvbLthRMIoOPe/P1e8vWfN4HF66KSbqWLGqlLwH3IPiQMTpkz5AAAAAElFTkSuQmCC"
	          })
	        })
	      );
	      vectorSource.addFeature(rome);
	    }
	  }
	};
	</script>
	<style>
	.map {
	  width: 100%;
	  height: 600px;
	}
	</style>

```

# 3. OpenLayers 标签添加文字

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200827144301416.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl8zOTM0MDA2MQ==,size_16,color_FFFFFF,t_70#pic_center)

```js
      var berlin = new Feature({
        geometry: new Point([Math.random() * 1087, Math.random() * 749]),
        name: "abc"
      });

      berlin.setStyle(
        new Style({
          image: new Circle({
            radius: 5,
            fill: new Fill({
              color: "blue"
            })
          }),
          text: new Text({
            font: "15px Microsoft YaHei",
            text: "老子 No.1",
            offsetX: 0,
            offsetY: 15,
            fill: new Fill({
              color: "#ff0000"
            })
          })
        })
      );

      vectorSource.addFeature(berlin);
```

# 4. OpenLayers 动态修改样式

![在这里插入图片描述](https://img-blog.csdnimg.cn/2020082715045043.gif#pic_center)

```js
    change() {
      this.feature
        .getStyle()
        .getText()
        .setText("哈哈哈");
        
      this.feature.changed();
    }
```

为了是更改后的样式生效， 必须调用 this.feature.changed();
总结

- OpenLayers 通常使用 VectorLayer 图层来添加标签（ICON）
- 添加标签的方法是向 VectorLayer 的数据源 VectorSource 添加 Feature来完成。
- Feature 有两个重要的属性：geometry 和 style，分别用来控制图形和样式。

    A vector object for geographic features with a geometry and other attribute properties, similar to the features in vector file formats like GeoJSON.
    Features can be styled individually with setStyle; otherwise they use the style of their vector layer.
    Note that attribute properties are set as module:ol/Object properties on the feature object, so they are observable, and have get/set accessors.
API 文档地址：https://openlayers.org/en/latest/apidoc/module-ol_Feature-Feature.html