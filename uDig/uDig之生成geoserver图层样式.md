# uDig之生成geoserver图层样式

geoserver图层样式可通过xml数据定义，但是样式xml编写复杂，可通过uDig工具生成样式。

![img](https://img2020.cnblogs.com/blog/1015208/202004/1015208-20200416192103341-1398570341.png)

 

**生成步骤：**

1.将shp图层拖拽至软件layer中

2.右键选择change Style...，进入界面

![img](https://img2020.cnblogs.com/blog/1015208/202004/1015208-20200416192448345-431902641.png)

3.配置样式后Apply应用可显示

4.样式xml代码在XML选项中，可直接粘贴至geoserver中使用

![img](https://img2020.cnblogs.com/blog/1015208/202004/1015208-20200416192747130-1246006116.png)

注意：

样式可指定唯一值样式，在样式配置页面中的Theme中，具体配置如下：

![img](https://img2020.cnblogs.com/blog/1015208/202004/1015208-20200416192944155-2061107000.png)