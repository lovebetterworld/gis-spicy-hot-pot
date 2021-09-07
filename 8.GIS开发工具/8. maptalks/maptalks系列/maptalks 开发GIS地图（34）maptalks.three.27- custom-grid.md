- [maptalks 开发GIS地图（34）maptalks.three.27- custom-grid](https://www.cnblogs.com/googlegis/p/14736095.html)

1. 大数据量的grid栅格。其中使用了d3.min.js 和 turf 的函数。

2. Grid 数据

```js
const geohashlen = 5;
function Grid(geojson) {
    let minLng = Infinity, minLat = Infinity, maxLng = -Infinity, maxLat = -Infinity;
    const coordinates = geojson.geometry.coordinates[0];
    for (let i = 0, len = coordinates.length; i < len; i++) {
        const [lng, lat] = coordinates[i];
        minLng = Math.min(lng, minLng);
        minLat = Math.min(lat, minLat);
        maxLng = Math.max(lng, maxLng);
        maxLat = Math.max(lat, maxLat);
    }
    this.minLng = minLng;
    this.minLat = minLat;
    this.maxLng = maxLng;
    this.maxLat = maxLat;
    this.count = 0;
    this.altitude = 0;
    this.radius = 1000;
    this.color = '#fff';
    this.center = this.getCenter();
    const [lng, lat] = this.center;
    this.geohash = geohash.encode(lat, lng, geohashlen);
}
```

3. 处理 csv 数据。

```js
var bars = [];
function addBars(scene) {
    d3.csv('https://gw.alipayobjects.com/os/basement_prod/7359a5e9-3c5e-453f-b207-bc892fb23b84.csv', (error, response) => {
        let minLng = 63.34425210104371, minLat = 13.50923035548422, maxLng = 146.75790830392293, maxLat = 57.69160333787326;

        for (let i = 0, len = response.length; i < len; i++) {
            let lng = response[i].lng, lat = response[i].lat;
            lng = parseFloat(lng);
            lat = parseFloat(lat);
            // minLng = Math.min(lng, minLng);
            // minLat = Math.min(lat, minLat);
            // maxLng = Math.max(lng, maxLng);
            // maxLat = Math.max(lat, maxLat);
            if (minLng <= lng && lng <= maxLng && lat >= minLat && lat <= maxLat) {
                lnglats.push([lng, lat, geohash.encode(lat, lng, geohashlen)]);
            }
        }
        // minLng = Math.max(minLng, 63.34425210104371);
        // minLat = Math.max(minLat, 13.50923035548422);
        // maxLng = Math.min(maxLng, 146.75790830392293);
        // maxLat = Math.min(maxLat, 57.69160333787326);

        const center = new maptalks.Coordinate((minLng + maxLng) / 2, (minLat + maxLat) / 2);
        const size = 10000;
        const cells = turf.squareGrid([minLng, minLat, maxLng, maxLat], size / 1000, { unit: '' });
        const grids = [], radius = size / 2;
        for (let i = 0, len = cells.features.length; i < len; i++) {
            const grid = new Grid(cells.features[i]);
            grid.radius = radius;
            gridMap[grid.geohash] = grid;
            grids.push(grid);
        }
        console.log(grids);
        const notfinds = [];

        for (let i = 0, len = lnglats.length; i < len; i++) {
            let [lng, lat, key] = lnglats[i];
            if (minLng <= lng && lng <= maxLng && lat >= minLat && lat <= maxLat) {
                if (gridMap[key]) {
                    gridMap[key].count++;
                } else {
                    // notfinds.push(key);
                }
            }
        }

        // console.log(notfinds);
        const timer = 'time';
        console.time(timer);
        let max = -Infinity;
        const filterGrids = [];
        for (let i = 0, len = grids.length; i < len; i++) {
            if (grids[i].count > 0) {
                const grid = grids[i];
                max = Math.max(max, grid.count);
                const color = getColor(grid.count);
                grid.color = color;
                filterGrids.push(grid);
            }
        }

        console.timeEnd(timer);
        console.log(max);
        const boxs = new Boxs(filterGrids, { center: center }, material, threeLayer);
        threeLayer.addMesh(boxs);
        console.log(boxs);
        bars.push(boxs);
    });

    initGui();
    animation();
}
```

4. 页面显示

![img](https://img2020.cnblogs.com/blog/59231/202105/59231-20210506172557929-733920479.png)

