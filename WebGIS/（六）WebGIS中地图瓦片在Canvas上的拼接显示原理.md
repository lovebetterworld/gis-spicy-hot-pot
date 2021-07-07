- [（六）WebGIS中地图瓦片在Canvas上的拼接显示原理](https://www.cnblogs.com/naaoveGIS/p/3917468.html)

## 1.前言

在之前的五个章节中，我们在第一章节里介绍了WebGIS的基本框架和技术，第二章节里介绍了什么是瓦片行列号以及计算它的原因，第三章节里介绍了如何通过地理范围计算出这个范围内瓦片的行列号，第四和第五章节里介绍了在得到瓦片行列号后如何获得离线和在线地图的URL，这个章节里，我们将介绍在通过URL得到瓦片后，如何将其显示在浏览器相对应的地方，拼接出整块地图。

## 2.左上角瓦片起始点屏幕坐标的计算

在第三章节中，我介绍了对于左上角瓦片起始点屏幕坐标的换算原理和方法，这里我再次给出这个公式：

offSetX = ((realMinX- minX )/resolution);

offSetY = ((maxY - realMaxY )/resolution);

英文代表如下意思：

realMinX、realMaxY:请求的左上角瓦片对应的真实地理坐标（geoX,geoY）。

minX、maxY:屏幕可视范围的左上角对应的真实地理坐标（geoScreenX,geoScreenY）。

resolution:当前地图级别里屏幕一像素代表的实际地理单位长度。

因为可视范围里，左上角屏幕坐标为（0,0）。

所以offSetX和offSetY便为左上角瓦片的起始点屏幕坐标（offSetX，offSetY）。

这里如果大家对以上参数的换算有不了解之处，请查看此系列中的第三章节——通过地理范围换算出行列号。

## 3．任意瓦片屏幕坐标的计算

同样，我首先给出相关的公式：

coord.x = offSetX + ( clipX - fixedTileLeftTopNumX)* tileSize;

coord.y = offSetY + ( clipY - fixedTileLeftTopNumY)* tileSize;   

英文代表如下意思：

offSetX、offSetY：最左上角瓦片的屏幕坐标

clipX、clipY：目前瓦片的行列号

fixedTileLeftTopNumY、fixedTileLeftTopNumY：最左上角瓦片的行列号

tileSize：瓦片大小（一张瓦片的像素）

coord:目前瓦片的屏幕坐标

这里的fixedTileLeftTopNumY和fixedTileLeftTopNumY，在第三章里我同样介绍了如何获得。

## 4.瓦片拼接流程

​     ![img](https://images0.cnblogs.com/i/656746/201408/171013152338728.png)

通过流程图可以看到，瓦片的拼接需要通过遍历X轴和Y轴。依次获取瓦片屏幕坐标后拼接。这里涉及到X轴和Y轴时的遍历个数，其实就是请求到的所有瓦片，在X轴上的个数以及Y轴上的个数。同样，在第三章里我对这个个数的换算有比较详细的讲解，这里不再累述。

## 5.前端地图显示整体流程

​     ![img](https://images0.cnblogs.com/i/656746/201408/171013391089588.png)

得到的地图效果图如下：

​        ![img](https://images0.cnblogs.com/i/656746/201408/171013595618104.png)

## 6.总结

至此，WebGIS中前端地图显示系列就告一段落了。我相信大家在这个系列里，或多或少都对WebGIS有了新的认识。我们知道图像分为栅格图像和矢量图像，这里我仅仅只是介绍了栅格图像在WebGIS中的加载，那么矢量图像怎么加载呢？同样，有了这些原理知识，我们该如何设计栅格图像类，以及以后的矢量图像类等等呢？在下一个系列里，我们将开始探索WebGIS中核心类的设计。