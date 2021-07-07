github链接：https://github.com/mrdoob/three.js

Three.js官网：https://threejs.org/

ThreeJS电子书：http://www.yanhuangxueyuan.com/Three.js/

掘进Three.js系列文章：https://juejin.cn/tag/three.js



Three.js是基于原生WebGL封装运行的三维引擎，在所有WebGL引擎中，Three.js是国内文资料最多、使用最广泛的三维引擎。

既然Threejs是一款WebGL三维引擎，那么它可以用来做什么想必你一定很关心。所以接下来内容会展示大量基于Threejs引擎或Threejs类似引擎开发的Web3D应用，以便大家了解。

# 相关库

下面表格列举了一些Three.js相关的开源库。

| 库                                                  | 功能                                                         |
| :-------------------------------------------------- | :----------------------------------------------------------- |
| [Physijs](https://github.com/chandlerprall/Physijs) | Physijs是一款物理引擎，可以协助基于原生WebGL或使用three.js创建模拟物理现象，比如重力下落、物体碰撞等物理现 |
| [stats.js](https://github.com/mrdoob/stats.js)      | JavaScript性能监控器，同样也可以测试webgl的渲染性能          |
| [dat.gui](https://github.com/dataarts/dat.gui)      | 轻量级的icon形用户界面框架，可以用来控制Javascript的变量，比如WebGL中一个物体的尺寸、颜色 |
| [tween.js](https://github.com/tweenjs/tween.js/)    | 借助tween.js快速创建补间动画，可以非常方便的控制机械、游戏角色运动 |
| [ThreeBSP](https://github.com/sshirokov/ThreeBSP)   | 可以作为three.js的插件，完成几何模型的布尔，各类三维建模软件基本都有布尔的概念 |



# 物联网3D可视化

在人与人之间联系的互联网时代，主要是满足人与人之间的交流，Web页面的交互界面主要呈现为2D的交互效果，比如按钮、输入框等。

随着物联网的发展,工业、建筑等各个领域与物联网相关Web项目网页交互界面都会呈现出3D化的趋势。物联网相比较传统互联网更强调的是人与物、物与物的联系，当人与物进行交互的时候，比如你通过网页页面远程控制工厂中的一台机器启动或关停，你可以在网页上通过div元素写一个按钮，然后表示机器设备的开关，当然你也可以把该设备以3D的形式展示在网页上，然后就像玩游戏一样直接点击模型上的开关按钮，这两种方式肯定是3D的方式更为直观，当然开发成本也比较大。

物联网粮仓3D可视化案例：http://www.yanhuangxueyuan.com/3D/liangcang/index.html

![img](http://www.yanhuangxueyuan.com/upload/threejs3粮仓.jpg)

# 产品720在线预览

在浏览器不支持WebGL技术的时代，如果你想在网页上展示一款产品往往是通过2D图片的形式实现。如果想3D展示一个产品，往往依赖于OpenGL技术，比如通过unity3D或ue4开发一个桌面应用，这样做往往很难随意传播，需要用户下载程序很麻烦，如果是通过Web的方式展示产品的三维模型，一个超链接就可以随意传播。

随着WebGL技术的持续推广，5G技术的持续推广，各种产品在线3D展示将会变得越来越普及，比如一家汽车公司的新款轿车可以在官网上在线预览，也许有一天一些电商平台会通过3D模型取代2D图片，现在你朋友推荐推荐给你一款新衣服，你会说发一张图片看看，也许将来你会说发来一个3D模型链接看看。

玉镯产品在线预览案例：http://www.yanhuangxueyuan.com/3D/liangcang/index.html

![img](http://www.yanhuangxueyuan.com/upload/threejs3玉镯.jpg)

沙发在线预览：http://app.xuanke3d.com/apps/trayton/#/show

服装在线预览：http://suit.xuantech.cn/

洗衣机在线交互预览：https://cdn.weshape3d.com/hir001/1021/web/index.html

# 数据可视化

与webgl相关的数据可视化主要是两方面，一方面是海量超大数据的可视化，另一方面是与3D相关的数据可视化。对于超大的海量数据而言，基于canvas、svg等方式进行web可视化，没有基于WebGL技术实现性能更好，对于3D相关的数据可视化基于WebGL技术，借助3D引擎Threejs可以很好的实现。

解析GeoJOSN数据中国GDP数据可视化：http://www.yanhuangxueyuan.com/3D/geojsonChina/index.html

![img](http://www.yanhuangxueyuan.com/upload/threejs3gdp.jpg)

3D直方图：https://www.echartsjs.com/examples/zh/editor.html?c=transparent-bar3d&gl=1

# H5/微信小游戏

非常火的微信小游戏跳一跳就是使用Three.js引擎开发的。 开发3D类的H5小游戏或者微信小游戏，Three.js引擎是非常好的选择。

通过Threejs开发的小游戏，可以直接部署在微信小程序或者web端，无需下载，方便传播，目前的生态非常和小游戏开发。

## 科教领域

在科教领域通过3D方式展示特定的知识相比较图像更为直观。

科研平台-蛋白质结构可视化案例：http://www.rcsb.org/3d-view/2JEN/1

化学相关——分子结构可视化：http://www.yanhuangxueyuan.com/3D/fenzi/index.html

地理天文相关——太阳系3D预览：http://www.yanhuangxueyuan.com/3D/solarSystem/index.html

![img](http://www.yanhuangxueyuan.com/upload/threejs3sun.jpg)

## 机械领域

机械模型在线预览demo：http://www.yanhuangxueyuan.com/3D/jixiezhuangpei/index.html

Onshape是一款机械领域的三维建模软件，如果熟悉Solidworks、UG等CAD软件，那么你可以把Onshape理解为云Solidworks。

## WebVR

对于现在比较火的VR、AR概念，WebGL技术的出现，也是一个好消息，如果你想预览一些VR内容，完全可以不下载一个VR相关的APP，通过threejs引擎实现VR内容发布，然后用户直接通过微信等社交方式推广，直接打开VR内容链接就可以观看。

VR与Web3D技术结合自然就衍生出来一个新的概念WebVR，也就是基于Web实现的VR内容。

## 家装室内设计相关

室内设计作品展示案例：http://www.yanhuangxueyuan.com/3D/houseDesign/index.html

![img](http://www.yanhuangxueyuan.com/upload/threejs3室内设计.jpg)

云装修平台酷家乐：https://www.kujiale.com/

## 三维模型在线预览平台

| 平台      | 国家 | 网址                    |
| :-------- | :--- | :---------------------- |
| sketchfab | 国外 | https://sketchfab.com/  |
| 动动三维  | 国内 | https://www.ddd.online/ |
| 琢刻      | 国内 | https://gizmohub.com/   |

## 室内逆向全景漫游平台

通过3D相机对室内空间进行逆向，在Web端以全景图的方式预览室内效果。

| 平台       | 国家 | 网址                    |
| :--------- | :--- | :---------------------- |
| 众趣科技   | 国内 | http://www.3dnest.cn/   |
| 贝壳       | 国内 | https://zz.ke.com//     |
| matterport | 国外 | https://matterport.com/ |