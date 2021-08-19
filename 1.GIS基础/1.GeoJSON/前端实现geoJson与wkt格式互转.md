- [前端实现geoJson与wkt格式互转](https://hanbo.blog.csdn.net/article/details/109630850)

geoJson与wkt都是WebGIS开发中经常用到的格式，很多时候WebGIS前端开发人员需要在二者之间进行互相转换。去让后端开发人员写个接口，太浪费时间，可以尝试用[terraformer-wkt-parser](https://www.npmjs.com/package/terraformer-wkt-parser)进行一下二者的转换。虽然很简单，网上有些地方对其用法说的却不对。

这里我说一下，这个插件主要有两个函数

- ```
  parse(string)   wkt转为geojson
  ```

- ```
  convert(string)  geojson转wkt
  ```

### 插件的安装

```
npm install terraformer-wkt-parser --save
```

### 代码测试

```javascript
import WKT from "terraformer-wkt-parser"


let wkts = "POLYGON((102.797302689433 36.5936423859273,105.519115206186 29.4789248520356,100.346180647351 19.9699202912212))";
let geojson={
      "type": "Polygon",
      "coordinates": [
        [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0] ],
        [ [100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8], [100.2, 0.2] ]
      ]
    }
    
console.log("wkt转geojson",WKT.parse(wkts))
console.log("geojson转wkt",WKT.convert( geojson))
```

### 打印结果

![img](https://img-blog.csdnimg.cn/20201111204832507.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0dJU3V1c2Vy,size_16,color_FFFFFF,t_70)