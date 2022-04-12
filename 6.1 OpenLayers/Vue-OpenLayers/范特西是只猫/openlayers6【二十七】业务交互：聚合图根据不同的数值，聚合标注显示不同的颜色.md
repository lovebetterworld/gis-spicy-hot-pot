- [openlayers6【二十七】业务交互：聚合图根据不同的数值，聚合标注显示不同的颜色_范特西是只猫的博客-CSDN博客](https://xiehao.blog.csdn.net/article/details/119949457)

## 1. 实现效果

实现聚合上图文章： [openlayers6【二十】vue Cluster类实现聚合标注效果](https://xiehao.blog.csdn.net/article/details/107467701)

![请添加图片描述](https://img-blog.csdnimg.cn/b5eefee815c04419aade32b0ab8c20e7.gif)

实现聚合上图文章： [openlayers6【二十】vue Cluster类实现聚合标注效果](https://xiehao.blog.csdn.net/article/details/107467701)

## 2. 根据缩放聚合值 修改标注颜色代码

```js
// 根据值大小判断颜色
getColor(val) {
  if (val < 100) return "blue";
  else if (val >= 100 && val < 500) return "yellow";
  else if (val >= 500) return "red";
},
clusterStyle() {
  return (feature) => {
    var total = 0;
    feature.get("features").forEach((value, index) => {
      total += value.get("value");
    });
    var style = new Style({
      image: new CircleStyle({
        radius: 15,
        stroke: new Stroke({
          color: this.getColor(total),
        }),
        fill: new Fill({
          color: this.getColor(total),
        }),
      }),
      text: new Text({
        text: total.toString(),
        fill: new Fill({
          color: "#000",
        }),
        font: "12px Calibri,sans-serif",
        stroke: new Stroke({
          color: "#fff",
          width: 5,
        }),
      }),
    });
    return style;
  };
},
```