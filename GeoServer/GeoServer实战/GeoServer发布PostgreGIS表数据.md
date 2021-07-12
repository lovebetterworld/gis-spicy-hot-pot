- [Geoserver+Postgresql+PostGIS 进行数据发布](https://www.cnblogs.com/CityLcf/p/10054927.html)
- [Geoserver+Postgresql+PostGIS进行数据发布：geoserver使用postGis发布的数据](https://blog.csdn.net/weixin_41586161/article/details/108264157)



# 一、用GeoServer进行数据的发布

## 1.1 打开GeoServer首页

![img](https://img2018.cnblogs.com/blog/1458843/201812/1458843-20181202200039782-1382683149.png)

输入用户名 admin 密码geoserver 进行登录 登录后的界面如下图所示

![img](https://img2018.cnblogs.com/blog/1458843/201812/1458843-20181202200144031-2044058317.png)

## 1.2 创建一个新的工作区

![img](https://img2018.cnblogs.com/blog/1458843/201812/1458843-20181202201006494-1312507786.png)

填写工作区名称和访问路径uri

![img](https://img2018.cnblogs.com/blog/1458843/201812/1458843-20181202201107379-620257314.png)

## 1.3 添加postgis数据源

![img](https://img2018.cnblogs.com/blog/1458843/201812/1458843-20181202201226699-1912837379.png)

![img](https://img2018.cnblogs.com/blog/1458843/201812/1458843-20181202201303550-1800611117.png)

![img](https://img2018.cnblogs.com/blog/1458843/201812/1458843-20181202201516443-2048768901.png)

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200827165313539.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MTU4NjE2MQ==,size_16,color_FFFFFF,t_70#pic_center)

点击保存后，会跳出一个**新建图层**的界面，点击发布操作进行发布图层

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200827165547913.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MTU4NjE2MQ==,size_16,color_FFFFFF,t_70#pic_center)

可以更改图层的命名，标题以及摘要，添加关键字等等

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200827165623320.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MTU4NjE2MQ==,size_16,color_FFFFFF,t_70#pic_center)

最重要的一步是**计算出边界**，点击从数据中计算，两个都有数据生成后就可以点击保存。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200827165707941.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MTU4NjE2MQ==,size_16,color_FFFFFF,t_70#pic_center)

生成图层完成后，点击Layer Preview找到自己图层的名字

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200827165841248.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MTU4NjE2MQ==,size_16,color_FFFFFF,t_70#pic_center)

## 1.4 添加发布图层

![img](https://img2018.cnblogs.com/blog/1458843/201812/1458843-20181202201808585-1087576765.png)

![img](https://img2018.cnblogs.com/blog/1458843/201812/1458843-20181202201853332-1739275088.png)

## 1.5 通过Layer Preview预览图层

填写图层的范围，然后提交后 一个图层就算是发布成功 然后可以用layer Preview来进行查看

![img](https://img2018.cnblogs.com/blog/1458843/201812/1458843-20181202202124417-608108929.png)

![img](https://img2018.cnblogs.com/blog/1458843/201812/1458843-20181202202140988-1321563261.png)

效果图如下

![img](https://img2018.cnblogs.com/blog/1458843/201812/1458843-20181202202254081-1987555466.png)