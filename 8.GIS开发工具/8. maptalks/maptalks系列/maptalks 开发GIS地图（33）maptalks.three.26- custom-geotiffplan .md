- [maptalks 开发GIS地图（33）maptalks.three.26- custom-geotiffplan  ](https://www.cnblogs.com/googlegis/p/14736002.html)

1. 在地图上添加一个GeoTIFF的图片。

2. 主要使用了 GeoTIFF 和 GeoTiffPlane 对象。

3. 加载完成后为image图片，并使用material进行渲染。

```js
fetch('https://gw.alipayobjects.com/os/rmsportal/XKgkjjGaAzRyKupCBiYW.dat').then(res => res.arrayBuffer()).then(arrayBuffer => {
    GeoTIFF.fromArrayBuffer(arrayBuffer).then(tiff => {
        return tiff.getImage();
    }).then(image => {
        const width = image.getWidth();
        const height = image.getHeight();
        image.readRasters({}).then(data => {
            const time = 'time';
            console.time(time);
            const plane = new GeoTiffPlane([73.482190241, 9.62501784112, 134.906618732, 60.4300459963], {
                imageWidth: width,
                imageHeight: height,
                imageData: data[0]
            }, material, threeLayer);
            console.timeEnd(time);
            threeLayer.addMesh(plane);
            lines.push(plane);
        })
    })
    // const image = tiff.getImage();
    // const width = image.getWidth();
    // const height = image.getHeight();
    // const values = image.readRasters();
})
```

4. 页面显示

![img](https://img2020.cnblogs.com/blog/59231/202105/59231-20210506170958209-207779395.png)

