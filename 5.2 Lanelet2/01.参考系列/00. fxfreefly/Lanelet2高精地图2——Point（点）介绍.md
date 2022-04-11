- [Lanelet2高精地图2——Point（点）介绍_fxfreefly的博客-CSDN博客_lanelet高精地图](https://blog.csdn.net/bhniunan/article/details/121796649)

 在Lanelet2高精地图中，Point由ID，3d坐标和属性组成，是唯一存储实际位置信息的元素，ID必须是唯一的。其他基本元素都是直接或者间接由Point组成的。在Lanelet2中，Point本身并不是有意义的对象，Point仅与Lanelet2中的其他对象一起使用有意义。

​    Point元素的组成如下表所示：

| 物理量        | 内容          | 类型                           |
| ------------- | ------------- | ------------------------------ |
| id            | 点的ID        | int                            |
| x             | X坐标（北向） | double                         |
| y             | Y坐标（东向） | double                         |
| z             | Z坐标（高程） | double                         |
| 属性（可选）* | Tags          | key=stringvalue=string, double |

\* 典型的点没有任何Tags信息，除非想表达独立的虚线时才会用到。key和value的取值范围如下：

| Tags |                       |
| ---- | --------------------- |
| key  | value                 |
| type | begin, end, pole, dot |

![img](https://img-blog.csdnimg.cn/2161066fe23143efb9c446c9a1e5e0ea.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAZnhmcmVlZmx5,size_20,color_FFFFFF,t_70,g_se,x_16)

 

*.osm**文件表达实例*

在.osm文件中，点以<[node](https://so.csdn.net/so/search?q=node&spm=1001.2101.3001.7020)/>来表达。	

```js
<node id='39624' visible='true' version='1' lat='49.00519014964' lon='8.43659654764' ele='1430.476' />
```

