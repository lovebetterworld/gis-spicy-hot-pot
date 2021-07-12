# GeoServer 常见问题总结

## 1.忘记了GeoServer Web Admin Page的登陆用户名和密码怎么办？

​    存储位置：C:\Program Files\GeoServer 2.2.2\data_dir\security\users.properties.old    
 文件内容：admin=geoserver,ROLE_ADMINISTRATOR，其中admin是用户名，geoserver为密码。    
   

## 2.GeoServer的8080端口被占用了怎么办？如何修改GeoServer的端口？

​    GeoServer管理页面的登陆地址正常情况下为：http://localhost:8080/geoserver/web    
 如8080端口被占用，访问GeoServer Web Admin Page时会显示：Bad Request (Invalid Hostname)    
​    **解决方法：**    
 找到start geoserver的启动文件(MS-DOC批处理文件)：C:\Program Files\GeoServer 2.2.2\bin\startup.bat    
 用记事本打开，找到-DSTOP.KEY=geoserver -Djetty.port=8080，把8080改为其他端口，重新启动GeoServer，访问http://localhost:其他端口/geoserver/web就正常了。    
   

## 3.如何修改GeoServer的默认数据路径？

​    GeoServer的数据路径是由系统环境变量    **GEOSERVER_DATA_DIR**决定的，默认为C:\Program Files\GeoServer 2.2.2\data_dir。   

​    如要改变数据路径，首先重命名C:\Program Files\GeoServer 2.2.2\data_dir的文件夹，让geoserver找不到它，然后把系统变量GEOSERVER_DATA_DIR的值设置为其他路径即可。    
   

## 4.使用shp文件发布地图服务时，中文出现乱码、方块、问号等无法正常显示的情况怎么办？

​    Shp 文件字段内容为中文时，应将    **DBF charset** 设置为GBK 或 GB2312。    
 注意其所在 WORKSPACE 的    **Character Set** 需要设置为UTF-8，如果同样设置为 GBK  或 GB2312 则无法正常显示，原因不明。    
   

## 5.GeoServer中styles的中文显示乱码如何解决？

​    Style 文件xml encoding 属性和标注字体名称，必须为支持中文的编码。    
 如果xml encoding 设置了 GBK 或 GB2312，SLD中的font-family 必须为中文字体（宋体或其他），若为ARIAL等字体则显示为乱码、方块或问号等。示例如下   

```html
    宋体
    12.0
    normal
    normal
```

## 6.如何使用uDig加载GeoServer的WMS和WFS服务？

​    在uDig菜单中选择Layer >> Add...  选择服务类型，然后输入服务地址 http://localhost:8080/geoserver/wms  或 http://localhost:8080/geoserver/wfs 下一步即可。   

​    下图为加载WFS服务的效果：   

## 7.在uDig中配图，如何让图层只显示在一定的比例尺范围内？

​    与地图学上的比例尺大小正好相反，uDig中比例尺的大小是按照比例尺分母的大小来定的，即最大显示比例尺要设置为分母大。   

```html
1.0E6
2.0E7
```