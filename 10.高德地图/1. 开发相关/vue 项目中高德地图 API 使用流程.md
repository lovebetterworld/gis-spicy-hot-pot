- [vue 项目中高德地图 API 使用流程_三个木马人的博客-CSDN博客_高德地图](https://blog.csdn.net/weixin_43299180/article/details/123269481)

## 一、在高德地图开放平台注册账号并登录、认证

1、网址：https://lbs.amap.com/api/jsapi-v2/summary/；

2、认证：认证方式分为个人认证和企业认证，这个需要根据自己的需要按照流程填写认证信息；

## 二、申请Key

在 **控制台 -> 应用管理 -> 我的应用** 点击 **创建新应用** 填写相关申请信息：
![在这里插入图片描述](https://img-blog.csdnimg.cn/d8ee33e47d8847689c08fb1789ac8f53.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5LiJ5Liq5pyo6ams5Lq6,size_20,color_FFFFFF,t_70,g_se,x_16#pic_left)
创建应用之后点击添加按钮：
![在这里插入图片描述](https://img-blog.csdnimg.cn/840ed87c44984c23b1ab5042080935bf.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5LiJ5Liq5pyo6ams5Lq6,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)
这里可以选择 “Web端(JS [API](https://so.csdn.net/so/search?q=API&spm=1001.2101.3001.7020))” 或者 “Web服务”，填写完信息之后就可以获取到 key 值；

## 三、项目使用

上一篇我写了百度地图在 vue 项目里的使用，地图的引入方式是通过 `<script>` 标签直接引入的，着一篇我打算换个引入方式：间接引入；

1、创建一个 AMap.js 文件

```cpp
/**
* 动态加载高德地图 api 函数
* @param {String} key 高德地图的key
*/
export default function AMapLoader (key) {
    return new Promise(function(resolve, reject) {
        if (typeof window.AMap !== 'undefined') {
            resolve(window.AMap)
            return true
        }
        window.initAMap = function() {
            resolve(window.AMap)
        }
        let script = document.createElement('script')
        script.type = 'text/javascript'
        script.src = 'http://webapi.amap.com/maps?v=1.4.11&callback=initAMap&key=key'
        script.onerror = reject
        document.head.appendChild(script)
    })
}
```

2、AMap 组件文件

```cpp
<!--地图组件-->
<template>
  <div class="main">
    <div id="container" style="height:500px; overflow:hidden;"></div>
  </div>
</template>
<script>
const key = '5187e3f6db9301694f086c16f4082c94'  //获取的Key值
import AMapLoader from '@/unils/js/AMap.js'
export default {
  name: 'AMap',
  data () {
    return {
      map: null
    }
  },
  async mounted () {
    //加载 api 
    await AMapLoader(key)
    this.initMap()
  },
  methods:{
    initMap(){
		let that = this
		that.map = new AMap.Map("container", {
			resizeEnable: true, //是否可缩放
			zoom:11,//级别（最低级别3，最高级别20）
        	center: [116.397428, 39.90923],//中心点坐标
        	viewMode:'3D'//使用3D视图
		})
		//逆向地理编码方法
		AMap.plugin('AMap.Geocoder', function() {
		  var geocoder = new AMap.Geocoder({
		    // city 指定进行编码查询的城市，支持传入城市名、adcode 和 citycode
		    city: '010'
		  })
		 
		  var lnglat = [116.396574, 39.992706]
		
		  geocoder.getAddress(lnglat, function(status, result) {
		    if (status === 'complete' && result.info === 'OK') {
		        // result为对应的地理位置详细信息
		    }
		  })
		})
	}
  }
}
</script>
```

## 最后

高德地图也提供了丰富的功能，差不多每个功能都可以绑定和解绑自定义事件；具体需求可以参考高德地图 api 官网；