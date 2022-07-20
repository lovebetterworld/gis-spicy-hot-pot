- [QGIS：生成网格的步骤_慢-慢的博客-CSDN博客_qgis添加经纬度网格](https://blog.csdn.net/u011147706/article/details/109624091)

第一步：打开工具箱中的“创建[网格](https://so.csdn.net/so/search?q=网格&spm=1001.2101.3001.7020)”

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201111153223685.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTExNDc3MDY=,size_16,color_FFFFFF,t_70#pic_center)

第二步：按照自己的需求设置参数

*特别说明：

1、网格类型要选 矩形，默认是点；

2、网格范围可以自己定义范围（右边倒三角点开第三个）

3、间隔设置不能超过网格范围，单位跟选择的坐标参考系相关联，mercator坐标对应的是米，WGS 84 对应的是度。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201111153355861.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTExNDc3MDY=,size_16,color_FFFFFF,t_70#pic_center)

第三步 网格颜色设置

默认创建的是带填充的网格，需要自己更改网格样式
![在这里插入图片描述](https://img-blog.csdnimg.cn/20201111154000741.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTExNDc3MDY=,size_16,color_FFFFFF,t_70#pic_center)
设置步骤：1、点开属性设置，找到符号化 2、选中简单填充 3、在符号图层类型点开下拉栏选中“简单线条”

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201111154232588.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTExNDc3MDY=,size_16,color_FFFFFF,t_70#pic_center)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20201111154358551.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTExNDc3MDY=,size_16,color_FFFFFF,t_70#pic_center)

完成上述配置后的效果图

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201111154446513.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTExNDc3MDY=,size_16,color_FFFFFF,t_70#pic_center)