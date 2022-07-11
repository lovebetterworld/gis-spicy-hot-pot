- [点到任意折线组的最短距离（及turf.js的实现解析） - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/368661485)

## 问题定义：

> 有一点 Pt，有一任意长度和形状的折线 L： [[P1,P2],[p2,p3],[p3,p4]…]
> 求 Pt 与折线 L 的最近距离 N

## 问题澄清：

> 注意：折线 L 上离 Pt 最近的点，必然在折线上

## 使用场景：

> 对行车轨迹进行贴路修正，轨迹点与路上最短的距离的点既是修正后的点。

## 问题分析：

假设我们还不知道最终答案，甚至还不知晓解题思路（已经知道的同学先不急，这个题其实的确很简单） 我们先画个图分析下可能的思路，按照题目，我们画一个比较“复杂的场景”

![img](https://pic2.zhimg.com/80/v2-39ef05053ae9cb25e40c98e983e00c3d_720w.jpg)



其实这个题简单的地方就是，当你把图画出来，基本靠人眼可以一眼判断出答案，如上图，L 中距离 Pt 最近的点很容易用肉眼找到。

![img](https://pic1.zhimg.com/80/v2-d34b456eb76e9ba7928e45eef57b8c18_720w.jpg)

事实上，要找出点到折线的最短距离，必然需要遍历整条折线，计算某条线段与点之间的距离，并取其中最小的值。 那如何判断一个点到一条线段的最小距离？这里其实是这道题目最核心的逻辑，基于刚才我们的提示，线段上距离点最近的点，必然在线段内，而不可超出线段之外，我们穷举下点和线段之间的位置关系，不难总结出来，点到线段的最短距离，有两种可能性，一个是点到线段的垂直距离，另一个是点到线段某个端点的距离，点和线段的最短距离必然是这两种情况之一，而且肯定是这两种情况的最小的那个值。

![img](https://pic1.zhimg.com/80/v2-74aa379edfc0a5a29fb5cb5c40322fa8_720w.jpg)

如果要给这两种情况一个定性的话（什么情况下取垂直距离，什么情况下取到端点的距离），我们可以观察下点在不同位置下，与线段端点连接起来的两个夹角，不难发现，如果最短距离是垂直距离，α和β都是锐角，如果最短距离是到某个端点的距离，则其中必然有一个角度是钝角（大于90°），当然还存在中间状态，是不是很有意思，不过我们的计算过程不会涉及这个特性，而是会采用三个距离对比的方式，在几何计算上会更快。

![img](https://pic1.zhimg.com/80/v2-6ffa20acfb172977e593cf14dff00ca8_720w.jpg)



问题转化：

到现在，问题转化成了两个小计算：

\1. 计算一个点到另一个点的距离，这个很容易，不说了。

\2. 计算一个点到线段的垂直距离，这个稍微复杂一些，其实用三角函数也不难。

![img](https://pic2.zhimg.com/80/v2-7215764fb2f4502d446a70f69b9c52b1_720w.jpg)

点到线段的垂直距离

COSα = (b² + a² - c²)/2ab（余弦定理）

sinα = N/a

N = a * sinα

其实这里有很多种解法，感兴趣可以去搜索一下。最后我们看一下 turf.js 里的实现把。

```js
function nearestPointOnLine<G extends LineString | MultiLineString>(
  lines: Feature<G> | G,
  pt: Coord,
  options: { units?: Units } = {}
): NearestPointOnLine {
  let closestPt: any = point([Infinity, Infinity], {
    dist: Infinity,
  });

  let length = 0.0;
  flattenEach(lines, function (line: any) {
    const coords: any = getCoords(line);

    for (let i = 0; i < coords.length - 1; i++) {
      //start
      const start = point(coords[i]);
      // 起点到 pt 点的距离
      start.properties.dist = distance(pt, start, options);
      //stop
      const stop = point(coords[i + 1]);
      // 终点到 pt 点的距离
      stop.properties.dist = distance(pt, stop, options);
      // sectionLength，起点到终点的距离
      const sectionLength = distance(start, stop, options);
      //perpendicular，pt到端点距离较长的那条
      const heightDistance = Math.max(
        start.properties.dist,
        stop.properties.dist
      );
      // 当前线段的角度（正北为0，顺时针增加）
      const direction = bearing(start, stop);
      // 从 pt 点开始以垂直于线段的方向画线，长度为pt到起点和终点中最长的那个，找到新的点
      const perpendicularPt1 = destination(
        pt,
        heightDistance,
        direction + 90,
        options
      );
      // 同上，反方向延伸
      const perpendicularPt2 = destination(
        pt,
        heightDistance,
        direction - 90,
        options
      );
      // 将上述取到的两个点，与当前线段取交点
      const intersect = lineIntersects(
        lineString([
          perpendicularPt1.geometry.coordinates,
          perpendicularPt2.geometry.coordinates,
        ]),
        lineString([start.geometry.coordinates, stop.geometry.coordinates])
      );

      let intersectPt = null;
      // 交点个数大于1，取第一个交点
      if (intersect.features.length > 0) {
        intersectPt = intersect.features[0];
        intersectPt.properties.dist = distance(pt, intersectPt, options);
        intersectPt.properties.location =
          length + distance(start, intersectPt, options);
      }
      // 分别用起点、终点、垂直交点，与之前最短的距离进行对比，取最小的值
      if (start.properties.dist < closestPt.properties.dist) {
        closestPt = start;
        closestPt.properties.index = i;
        closestPt.properties.location = length;
      }
      if (stop.properties.dist < closestPt.properties.dist) {
        closestPt = stop;
        closestPt.properties.index = i + 1;
        closestPt.properties.location = length + sectionLength;
      }
      if (
        intersectPt &&
        intersectPt.properties.dist < closestPt.properties.dist
      ) {
        closestPt = intersectPt;
        closestPt.properties.index = i;
      }
      // update length
      length += sectionLength;
    }
  });

  return closestPt;
}
```

这里其实不是所有计算的代码，里面涉及到几个方法，特别是 lineIntersects ，计算两条线的交点，然后计算交点到 Pt 的距离，即可计算出点到线段的垂直距离，至于这个方法内部实现，改天可以再聊，另外大家可以考虑下如何优化整个计算，是否需要遍历每条线段做完整的计算。