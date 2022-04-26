- [maptalks 开发GIS地图（25）maptalks.three.18 - custom-billboard](https://www.cnblogs.com/googlegis/p/14735045.html)

1. 广告牌的效果，关键是每个的样式和颜色可以自定义。

2. 从代码中可以看出，使用了 canvas ，并将对应的 canvas 转化为image。

自己的功力不够，只能看出来这一点，还不知道对不对。等回来找本 ThreeJS 的书看。

3. 初始化数据

```js
function initData() {
            data.forEach(element => {
                const style = {
                    x: width * Math.random(),
                    y: height * Math.random(),
                    text: element.text,
                    // width: 50,
                    height: 50,
                    textFill: element.color,
                    // scale fontSize 18*2
                    textFont: '36px Microsoft Yahei',
                    textBackgroundColor: '#2A2523',
                    textPadding: [10, 15],
                    textShadowColor: '#fff',
                    textShadowBlur: 2
                };
                const text = new zrender.Text({
                    style
                });
                zr.add(text);
                const rect = getRect(text.getBoundingRect());
                createZr(element, rect, style, function () {
                    if (list.length === data.length) {
                        addSprites();
                    }
                });
            });
        }
```

4. 使用 canvas 描述本文对象

```js
function getRect(bound) {
            const { width, height, x, y } = bound;
            const w = Math.max(2, THREE.Math.ceilPowerOfTwo(width));
            const h = Math.max(2, THREE.Math.ceilPowerOfTwo(height));
            return {
                width, height, w, h
            };
        }

        function createZr(d, rect, style, callback) {
            const { w, h, width, height } = rect;
            let canvas = document.createElement('canvas');
            canvas.width = w;
            canvas.height = h;

            const zr = zrender.init(canvas, {
                width: w,
                height: h
            });
            const options = Object.assign({}, style);
            options.x = (w / 2 - width / 2);
            options.y = (h / 2 - height / 2);
            const text = new zrender.Text({
                style: options
            });
            zr.add(text);
            zr.on('rendered', () => {
                d.image = canvas.toDataURL();
                d.rect = rect;
                list.push(d);
                callback();
                zr.dispose();
                canvas = null;
            })

        }
```

5. 页面显示

![img](https://img2020.cnblogs.com/blog/59231/202105/59231-20210506141815942-425549854.png)