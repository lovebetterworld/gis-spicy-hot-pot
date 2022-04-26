- [WebGIS开源方案中空间数据的入库、编辑、发布的操作流程](https://www.cnblogs.com/naaoveGIS/p/4193145.html)

## 1.前言

本开源方案的构架是：geoserver（服务器）+tomcat（中间件）+postgis(数据库)+uDig(desktop)。

本文将主要讲解如何将shp数据通过postgis导入到postgresql中，并且在uDig上进行展示和编辑，然后如何将postgresql中的图层数据通过geoserver进行发布。

## 2.通过postgis将shp数据入库

### 2.1环境

需装有postgresql+postgis。安装完成后，在程序目录中可以看到：

![img](https://images0.cnblogs.com/blog/656746/201412/301059393568142.png)            

### 2.2. 入库

a. 点击 ![img](https://images0.cnblogs.com/blog/656746/201412/301100061067036.png)此工具，会弹出对话框:

 ![img](https://images0.cnblogs.com/blog/656746/201412/301100151228716.png)

b.设置数据库的连接

点击connection，在弹出的对话框中设置连接属性：

 ![img](https://images0.cnblogs.com/blog/656746/201412/301100282165450.png)

连接成功会有以下日志：

 ![img](https://images0.cnblogs.com/blog/656746/201412/301100378255313.png)

**注意：**此处的database一定要是集成了postgis的数据库模板的数据库才行，否则空间数据无法导入。

c.选择要导入的shp数据

点击Add File，会弹出如下对话框：

 ![img](https://images0.cnblogs.com/blog/656746/201412/301100473092449.png)

选择要导入的shp数据，选择完后点击确定：

 ![img](https://images0.cnblogs.com/blog/656746/201412/301100568889555.png)

**注意：**shp所在的文件夹路径一定要是英文，否则在导入时会导入失败。

d.数据导入

注意：首先要点击Options，进行编码设置。根据我的测试，UTF-8的编码在图层中有中文属性时，导入会出现错误。这里建议将编码设置为：GBK。

点击Import，开始导入。导入成功后，会有如下日志：

 ![img](https://images0.cnblogs.com/blog/656746/201412/301101067471578.png)

e.在postgresql中查看导入的shp数据：

 ![img](https://images0.cnblogs.com/blog/656746/201412/301101155285328.png)

 ![img](https://images0.cnblogs.com/blog/656746/201412/301101262319990.png)

## 3.通过uDig查看和编辑postgresql中的shp数据

### 3.1环境

需装有uDig软件。安装成功后，在程序目录中可以看到：

 ![img](https://images0.cnblogs.com/blog/656746/201412/301101382633682.png)

### 3.2在uDig中查看postgis中的数据

a.点击Layer——>add，选择PostGIS：

 ![img](https://images0.cnblogs.com/blog/656746/201412/301101527313429.png)

b.填写连接属性：

 ![img](https://images0.cnblogs.com/blog/656746/201412/301102032169093.png)

c.将postgis中的图层添加到当前map中：

 ![img](https://images0.cnblogs.com/blog/656746/201412/301102180919782.png)

d.uDig中显示添加的图层:

 ![img](https://images0.cnblogs.com/blog/656746/201412/301102585595351.png)

### 3.3对图层进行编辑

 ![img](https://images0.cnblogs.com/blog/656746/201412/301103102476314.png)

编辑完后点击Enter：

 ![img](https://images0.cnblogs.com/blog/656746/201412/301103257318416.png)

**注意：**一定要点击工具栏中的![img](https://images0.cnblogs.com/blog/656746/201412/301104294191428.png) ，才能将编辑成功提交。

## 4.通过geoserver发布postgresql中的shp数据

### 4.1 环境

需发布一个geoserver服务。发布成功后，可以在浏览器中打开网页：

 ![img](https://images0.cnblogs.com/blog/656746/201412/301104498093697.png)

### 4.2 发布地图服务

a.点击stores——>add stores——>postGIS，在进入的页面中填写连接属性：

 ![img](https://images0.cnblogs.com/blog/656746/201412/301104592004562.png)

 

b.选择要发布的shp图层：

 ![img](https://images0.cnblogs.com/blog/656746/201412/301105086538940.png)

c.填写图层信息：

 ![img](https://images0.cnblogs.com/blog/656746/201412/301105226063544.png)

d.发布服务及查看：

点击save后，图层即发布成功。在layer preview中可以查看发布的图层：

 ![img](https://images0.cnblogs.com/blog/656746/201412/301105324664566.png)

**注意：**可以明显的看到通过uDig编辑后的要素已被成功保存。