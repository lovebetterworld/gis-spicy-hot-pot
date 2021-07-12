- [GeoServer style中文乱码解决方法](https://www.cnblogs.com/ssjxx98/p/12539445.html)

一是创建New style时，网页中文本框内的内容才是最终会应用到GeoServer的sld内容，这与本地sld文件没有关系。

二是xml的encoding定义的编码不一定和文件编码（文件的字符编码）一致，详情可以参考：

[XML乱码问题和encoding的理解](https://blog.csdn.net/sxhlovehmm/article/details/41351387)

![2345截图20200321143633](https://img-blog.csdnimg.cn/20200321145636953.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2RmMTQ0NQ==,size_16,color_FFFFFF,t_70)

三是我使用的geoserver版本为2.16.2，因此该乱码问题的解决思路可能不适用于某些低版本的geoserver。据我所知，低版本geoserver（例如2.8.2），不论使用什么方法向网页中输入sld，只要sld文本中存在中文就不行，估计低版本是对中文的支持性不太好，因此如果遇到类似情况，建议使用较高版本。

#### 乱码问题的解决思路主要有如下三点：

##### 1.sld通过文件上传时出现乱码，说明sld文件的字符编码方式不为UTF-8。因为GeoServer工作区的字符集默认为UTF-8，上传文件的字符编码应当与它保持一致。

此时上传的sld内容已经乱码（即GeoServer接受到的文本已经乱码不能识别了，跟现在的encoding和字符编码都没多大关系了），修改本地sld文件并不能改变网页文本框的内容。

此时，需要将本地的sld文件字符编码设置成UTF-8再进行一次上传，直到文本框内容不出现乱码。

或者，更推荐的是，**直接复制**sld文档内容到网页文本框内，这样不会出现乱码。因为在不明确编码方式时，默认假定xml内容采用UTF-8编码。

![Snipaste_2020-03-21_10-46-16](https://img-blog.csdnimg.cn/20200321145713773.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2RmMTQ0NQ==,size_16,color_FFFFFF,t_70)

##### 2.shp数据中含有中文字符时，需要在数据源中将DBF字符集编码设置为GBK或GB2312

![Snipaste_2020-03-21_11-08-58](https://img-blog.csdnimg.cn/20200321145740112.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2RmMTQ0NQ==,size_16,color_FFFFFF,t_70)

##### 3.sld文件中含有中文字符时，编码方式encoding应该设置为GBK或GB2312，与数据源的编码方式对应。

![Snipaste_2020-03-21_14-23-17](https://img-blog.csdnimg.cn/20200321145812146.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2RmMTQ0NQ==,size_16,color_FFFFFF,t_70)