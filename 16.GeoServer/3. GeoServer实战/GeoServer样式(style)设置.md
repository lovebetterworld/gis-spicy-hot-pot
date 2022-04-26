- [GeoServer样式(style)设置](https://blog.csdn.net/xtfge0915/article/details/85175094)



# GeoServer Style定义

GeoServer样式支持SLD、CSS、YSLD、MBStyle四种方式定义Style，默认支持的SLD方式，其它三种需要扩展，SLD通过xml标签定义style，虽然强大但也比较复杂，可读性差，代码量大，下面是一个定义了点的填充方式和大小的SLD Style

```xml
<?xml version="1.0" encoding="ISO-8859-1"?>
<StyledLayerDescriptor version="1.0.0"
    xsi:schemaLocation="http://www.opengis.net/sld StyledLayerDescriptor.xsd"
    xmlns="http://www.opengis.net/sld"
    xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <NamedLayer>
    <Name>Simple point</Name>
    <UserStyle>
      <Title>GeoServer SLD Cook Book: Simple point</Title>
      <FeatureTypeStyle>
        <Rule>
          <PointSymbolizer>
            <Graphic>
              <Mark>
                <WellKnownName>circle</WellKnownName>
                <Fill>
                  <CssParameter name="fill">#FF0000</CssParameter>
                </Fill>
              </Mark>
              <Size>6</Size>
            </Graphic>
          </PointSymbolizer>
        </Rule>
      </FeatureTypeStyle>
    </UserStyle>
  </NamedLayer>
</StyledLayerDescriptor>
```

这么长一段代码只实现了两个功能，而且根本看不懂干了什么，所以如果懂css，建议使用CSS Style，代码少，简单易读。

# CSS Style

## CSS Style安装

- 下载扩展包

```bash
wget https://sourceforge.net/projects/geoserver/files/GeoServer/2.14.1/extensions/geoserver-2.14.1-css-plugin.zip
```

ps:这里下载的2.14.1，其它版本请在官网找对应扩展

    解压并复制到$GEOSERVER_HOME/webapps/geoserver/WEB-INF/lib目录
    重启GeoServer

## CSS Style定义

比如我有一个中国省界数据，要给它定义一个Style。打开New Style页面（Data >Styles >add a new style）


![在这里插入图片描述](https://img-blog.csdnimg.cn/20181221215839508.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h0ZmdlMDkxNQ==,size_16,color_FFFFFF,t_70)

注意在Format中选择CSS

- 对于一个多边形来说，最直观的样式首先边界和填充色

```css
* {
      stroke: #000000;
      stroke-width: 0.5;
      fill: #0099cc;
   }
```

这里定义了多边形的边界颜色为黑色，宽度是0.5，填充色为蓝色
点击validate如果提示No validation errors.再点击Apply，此时页面上方多了三个选项卡，点击Layer Preview就可以选择图层对刚才定义的样式进行预览。

- CSS样式由选择器和属性构成，属性被包含在"{}“内，以上面的样式为例，选择器”*"，stroke: #000000， stroke-width: 0.5， fill: #0099cc都属于属性，属性由name和value组成，之间用":“分割，”{}“把它们括起来跟在”*“后面，说明它们都属于”*"这个选择器，如果你懂CSS，这些都不用解释，和网页设计中的CSS没有区别

![在这里插入图片描述](https://img-blog.csdnimg.cn/20181221220805645.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h0ZmdlMDkxNQ==,size_16,color_FFFFFF,t_70)

- 显示标签(label)

```css
* {
    stroke: #000000;
    stroke-width: 0.5;
    fill: #0099cc;
    label: [name];
    label-anchor: 0.5 0.5;
    font-family: "宋体";
    font-fill: #000000;
    font-size: 14;
}
```

- 也可以利用[CSQL](https://docs.geoserver.org/stable/en/user/tutorials/cql/cql_tutorial.html)作为选择器，比如要将北京市渲染为红色，把面积大于100的填充为黄色

```css
[name='北京市']{
  fill:#ff0000;
  fill-opacity: 0.7;
}
[shape_area>100]{
  fill:#f1f507;
  fill-opacity: 0.7;
}
```

- 虽然并不建议在GeoServer中设置图例，但是如果需要，可以用以下方法

```css
/* @title area>100 */
[shape_area>100]{
  fill:#f1f507;
  fill-opacity: 0.7;
} 
/* @title 北京市 */
[name='北京市']{
  fill:#ff0000;
  fill-opacity: 0.7;
}
/* @title 省界 */
* {
	stroke: #000000;
	stroke-width: 0.5;
	fill: #0099cc;
	label: [name];
	label-anchor: 0.5 0.5;
	font-family: "宋体";
	font-fill: #000000;
	font-size: 14;
	font-style: normal;
}
```

- 更多的属性请参考[CSS workshop](https://docs.geoserver.org/stable/en/user/styling/workshop/index.html)。如果对其它的Style定义方式感兴趣，请前往[官网](https://docs.geoserver.org/stable/en/user/styling/index.html#styling)

## 应用自定义样式

编辑图层，在Publishing标签中的Default Style中选择刚才定义的Style

最终样式是这样的

![在这里插入图片描述](https://img-blog.csdnimg.cn/20181221234556778.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h0ZmdlMDkxNQ==,size_16,color_FFFFFF,t_70)

利用其它软件配图并将Style导入GeoServer

对大部分人来说，不管是哪种Style定义方式，可能没有时间精力完全掌握，其效率都是比较低的，如果能用一个做图软件配好图再把样式导入GeoServer可能是一种更好的选择。
udig软件就可以满足这一需求，把Style导出为SLD文件，然后在GeoServer中导入，并且udig支持多种平台，下载地址http://udig.refractions.net/download/

# 利用udig

1. 定义样式并导出SLD文件
   样式设置好之后点击xml可以把设置好的样式保存为SLD文件

![在这里插入图片描述](https://img-blog.csdnimg.cn/20181222002755447.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h0ZmdlMDkxNQ==,size_16,color_FFFFFF,t_70)

2. 在GeoServer中导入SLD文件

![在这里插入图片描述](https://img-blog.csdnimg.cn/20181222003309449.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h0ZmdlMDkxNQ==,size_16,color_FFFFFF,t_70)

# 利用QGIS

[QGIS](https://qgis.org/en/site/forusers/download.html)是目前最好的开源GIS软件，支持多种平台，它可以将配置好的样式导出为SLD文件。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20181222005108505.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h0ZmdlMDkxNQ==,size_16,color_FFFFFF,t_70)