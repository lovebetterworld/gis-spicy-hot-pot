- [为什么说shp不适合在企业级WebGIS中使用 (qq.com)](https://mp.weixin.qq.com/s/f_VHZUX4edoWEow5p3k7lw)

## **一 背景**

但凡是有GIS背景的系统开发，数据处理工程师，都不会对shp格式文件感到陌生，可以说，shp格式简直就是所有gis软件的“最大公约数”，无论你是在用ArcMap还是用QGIS，是用postgis还是oracle spatial，是用geoserver还是mapserver，几乎所有gis软件或中间件都原生支持shp，堪称“业界宠儿”。但没有任何格式是完美的，shp有好的一面，但也有坏的一面，不区分场景的滥用会导致其坏的一面放大。目前，在企业级WebGIS场景下也有大量业务系统存在过度使用shp的问题，本文就该主题讨论下shp为什么不适合在企业级WebGIS中使用。

## **二 企业级WebGIS数据需求**

讨论某种技术、规范、格式适不适合某种场景，是要看具体业务需求的，shp本身是种数据格式，讨论其是否适合的话首先要明确业务场景，通常企业级WebGIS是典型的BS三层架构，每层的业务需求枚举如下图：

![图片](https://mmbiz.qpic.cn/mmbiz_png/ecdPM5hZnoib0gJwFVsuwzxX7MQnASVxaDcibGUfC6TQPhywn7LWV6Ca9F8RAz4yovcZRhApDXAC5oRIOcE4lVfw/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

## **三 shp对业务场景力度**

### **3.1 存储层**

空间存储：由于.shp文件（图形）和.dbf文件（属性）不能超过2G，那么等于说明shp文件存储的空间数据<4G（实际更小），而很多空间业务数据是很大的数据量，超过3，4G的企业级数据是很常见的，因此，shp自身的限制决定了其不具备系统存储层的通用性。

属性查询：很常用的业务要求，即根据某个字段过滤查询，在一般关系型数据库中，就是一行简单的sql的问题，如果性能不行，可以加个索引优化；而shp如果自己写个查询服务，肯定首先要在内存里读取数据，然后遍历数据进行过滤，要写代码很麻烦，如果不想自己写代码就用geoserver发布个地理服务，根据ogc的wfs规范去查询，写起来是简单了，但是查询性能有很大问题，且shp不能像数据库那样建立字段索引。这里贴几个早年性能测试情况，数据规模约8.7万个点，使用 name='xx镇' 作为属性查询条件：

shp属性查询 16s：（基于geoserver的wfs）

![图片](https://mmbiz.qpic.cn/mmbiz/ecdPM5hZnoib0gJwFVsuwzxX7MQnASVxab45ebm4ibBqC9JRNicYGqAsODE961b3MY9Iy4qscnagMaF5eKEwIazDg/640?wx_fmt=other&wxfrom=5&wx_lazy=1&wx_co=1)

shp导入postgis不建立索引 0.1s：

![图片](https://mmbiz.qpic.cn/mmbiz/ecdPM5hZnoib0gJwFVsuwzxX7MQnASVxa2NYG7wawh2iaaD44mFUQo2dzdnKibncfFB9PibfHicRslxamzXHTKV1GsQ/640?wx_fmt=other&wxfrom=5&wx_lazy=1&wx_co=1)

shp导入postgis对name建立索引 0.05s:

![图片](https://mmbiz.qpic.cn/mmbiz/ecdPM5hZnoib0gJwFVsuwzxX7MQnASVxaJW6mGKHjkJ9Uwab6VeH2KBRzqdhlmpuo0jKd0zdaMP1wPfVEZxdgNQ/640?wx_fmt=other&wxfrom=5&wx_lazy=1&wx_co=1)

性能测试对比如下”

![图片](https://mmbiz.qpic.cn/mmbiz_png/ecdPM5hZnoib0gJwFVsuwzxX7MQnASVxaticZzYpndOopTbWOmKT08vFwYcjEFxfh8jdXb8N4dnWSvocceNPB54A/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)



从开发简洁性，还是条件查询性能上，shp都太不够看了，根本不具备企业级数据查询的要求。

联表join：shp导入数据库就是普通的关系表，只不过多了个图形字段，与其他业务表join是没问题的，但是shp本身不能和数据库通信，也就谈不上join的能力了。印象里arcmap里的shp可以和属性表关联，但是和数据库关联没做过不知道是否可以，就算支持性能也跟不上，而其他开源的中间件都不支持shp和表的join。

空间分析：以叠加分析为例。

shp空间分析 1s：

![图片](https://mmbiz.qpic.cn/mmbiz/ecdPM5hZnoib0gJwFVsuwzxX7MQnASVxa2WbxPV9KvZ3fCLbNmpib91zj9uX1SCVpYKiaq0GrJgCxibl5fgAaiaHqHw/640?wx_fmt=other&wxfrom=5&wx_lazy=1&wx_co=1)

shp导入postgis空间分析 0.15s：

![图片](https://mmbiz.qpic.cn/mmbiz/ecdPM5hZnoib0gJwFVsuwzxX7MQnASVxa38Gpd0blaBKDDSslOHaxw0xTFS5libaO7eozuricPUMR1z4IHmtHKUicA/640?wx_fmt=other&wxfrom=5&wx_lazy=1&wx_co=1)

shp第一次查询有点慢，第二次查询会快很多，原因是，gis server（如geoserver）首先要把数据load到内存里，然后根据shp元数据构建空间索引，这个耗时较多；而第二次查询时，server并未把数据从内存卸载，因此就没有这个load耗时了。由于shp是自带空间索引的，所以第二次的查询耗时可以理解成是真实的空间查询耗时，这个耗时贴近postgis的空间查询。那么可以理解成shp还是postgis都有空间索引，查询性能几乎一致，但是shp有个初次查询load到内存的io耗时，而数据库根据空间索引查，并不用把数据全部load到内存，所以有较小的io开销，更好的体验。

除此之外，shp文件里字段太长会强制截取的限制，很容易破坏数据的完整性。

此外，数据规模极端大的情况，数据库可以扩展分布式等，shp只能定位在很小的业务场景里。

综述：无论从任何一点看，企业级WebGIS都不可能用shp做数据存储的。

### **3.2 服务层**

gis服务端其实是很尴尬的存在，通常是啥也不干，也干不了太多。因为大量数据查询分析是走数据库引擎，少量数据查询和处理前端就够了。因此，尴尬的服务端大多数情况下，只是负责把数据库的数据搬运给前端，那么这个搬运过程称为数据查询，数据查询的话，shp的表现并不能满足业务需求，见上一章节的测试。

另一方面，查询的矢量数据结果以geojson、gml、topojson格式传给前端是很自然的选择，但是如果数据太大，就会形成网络瓶颈，等很久才能传输到前端，用户体验会非常糟糕。这种情况下，假设我们用postgis的话，可以使用postgis的矢量切片和并行计算等特性，快速把结果传到前端，详情参考早前一篇postgis可视化的文章：

> https://mp.weixin.qq.com/s?__biz=Mzg2OTUxMzM2MA==&mid=2247483754&idx=1&sn=228e788c3f846ffa5f75fd763e5bafd7&chksm=ce9aa095f9ed2983df2d418750ef1ea0124f6041b404e27c3920511d91a9587008c2a5246eed&token=1367148883&lang=zh_CN#rd

如果使用shp做数据源的话，绝大部分普通的人会躺下了，已经这样了，还能怎么办咧？少部分“聪明”人可能比如使用geoserver，一开始就把shp切成矢量切片，前端查询时，只是把不符合条件的数据不渲染，符合条件的数据渲染，但是这其实就是在欺骗自己的不规范行为，因为实际上服务端并没有响应查询，仅仅客户端调整样式蒙混过去。极少部分的技术极客，可能自己把数据load到内存，建立空间索引，加到内存的话可以自己设计一些索引再做关联查询，再把结果转矢量切片压缩形式传回客户端，一整套下来，很可能重新设计了一个空间数据库。。。好吧，这么辛苦，不如当初直接入库了。。。

服务层没啥好说的，就是优化空间有限或者代价太大。。。

### **3.3 客户端**

客户端最常见的骚操作就是支持用户上传shp，这个需求实质上非常坑爹，一般不是内行人设计出来的需求，其实客户要求的应该是支持上传自定义gis数据，反应到开发那就成了支持上传shp数据，这样的“需求变更”会生成一系列问题。

首先，shp文件通常有.shp、.dbf、.prj等多个文件组成，那么支持上传的时候，常见做法是打个压缩包，那么是打成.zip还是.tar还是.7zip？打包的路径是包括文件夹还是不包括文件夹啊等等，毕竟打包是很任性的一种行为，客户根据格式和文件路径能排列组合成好多形式，你支持哪一种？

其次，shp文件如果很大，几十M？几百M？几个G大小系统需要控制吗？

这么大明显不能传过来啊，太占带宽了不是？断点还续传？好容易传过来，还要解析吧，解析完渲染卡了咋办？还得自己将线面拆webgl的三角形？再webgl自定义图层渲染？一顿操作猛如虎？每个步骤都要命！

有人说我会控制上传文件的大小，如果太大我就不支持，我还要求打包格式，还要求打包路径，还要求。。。稍等下，客户只想简单的传个东西显示，你这么多要求，是不是明显已经伤害了客户的感情？是不是他惹不起你干脆不用你这个功能？毕竟软件中每多个步骤就少50%的用户，你要求这么多，用户不想记住那干脆不用了，成功过关？况且如果数据真的只有200k这么小，我shp上传这么麻烦干嘛？我直接上传geojson不香吗？

可能用户不会转geojson，在线网站，ogr2ogr等命令都能很轻松的将shp转json，培训一些简单操作给客户，他转好再上传你系统，对客户来说，操作简单，对开发来说，实现简单，双赢的局面为什么不好好沟通下？

实际上上传shp就不是一个严谨的，重视体验的系统应该有的功能，彼此伤害的一个伪需求，由不懂的客户发起，不懂的技术leader拍板，不懂的开发暴力上线，大家都在混才会有这个需求。。。

### **3.4 小结**

shp的表现在WebGIS任何一端，都是麻烦的制造者，不具备扩展性，不具备性能和功能，不具备系统开发的简洁高效，不具备用户体验。。。那么作为项目的决策者，直接裸奔shp上系统，可能真是“无知者无畏”啊。。。

## **三.Shp实际应用场景**

上文把shp说的一无是处？错了，shp并不是一无是处，只是被不懂的人用错了地方。

shp真正的用途绝对不是在企业WebGIS系统里，这类系统必然上空间数据库，这就是当年esri推的sde的缘故，大家都懂的道理，外行人乱用而已，如之奈何。本章节就正本清源的说下shp究竟用在哪里。

- **最牛的数据中介商**：任何一个gis软件都会支持shp的导入导出，比如你可以把oracle,mysql的图形表导出为shp，再把shp导入到postgis中，比如想对图形表在某cs软件中预览，可他不支持数据库，那么先从数据库导出为shp，再在cs中打开。利用好shp的行业最大公约数特性，可以让你能有信心处理任何空间数据的导入导出数据转换数据预览等等场景。总比给你一个陌生的没见过的格式要友善的多不是？
- **静态底图**：例如geoserver里发布几个shp图层，组个图层组，要么配色配好，然后图片切图给前端用，要么切矢量切片给前端用，主要做个简单的底图，这种场景下马马虎虎可以用吧，但是前端用的是shp？还是切片？恐怕已经和shp没关系了吧？



本想写点别的用途，发现没有了，shp就是停留在这了，一份中介性质的数据格式，便于人与人，人与软件的数据交换使用，在这个场景下，shp是绝对的王者，因此，**请不要再在webgis系统中直接上shp数据源**。