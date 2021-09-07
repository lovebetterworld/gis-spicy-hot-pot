- [如何创建 mapbox 精灵图](https://juejin.cn/post/6917840412493381640)



## 缘起

前面文章介绍了[如何在本地发布OSM数据](https://link.juejin.cn?target=http%3A%2F%2Fgisarmory.xyz%2Fblog%2Findex.html%3Fblog%3DOSMVectorTiles)，并使用 maputnik 自定义 mapbox 格式的地图样式。在使用 maputnik 配图时，如果想要使用自己的图片作为地图符号，就需要制作精灵图。

精灵图的制作工具有很多，在线网站就有一大堆，但普遍存在一个问题，maputnik 对精灵图的要求是要有精灵图和说明精灵图中图片信息的json配置文件，而这些在线网站的工具，只能生成精灵图，没有json配置文件。

## mapbox精灵图工具

mapbox开源了一个精灵图制作工具 [spritezero](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2Fmapbox%2Fspritezero)，这个工具可以生成精灵图和对应的json文件。spritezero 的输入文件是svg文件，输出文件是指定比例的精灵图和对应的json文件。

我自己在安装 spritezero 这个工具时总报错，翻看它的 issues 发现很多人都碰到了这个[问题](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2Fmapbox%2Fspritezero%2Fissues%2F84)。原因是用到的一个类库太老了，我最终解决办法是另辟蹊径，找了一个它的docker库 [spritezero-docker](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2Fmacteo%2Fspritezero-docker) ， 这个docker库里已经把 spritezero 的环境配置好了，直接用就行。

## spritezero-docker 使用方法

下面的操作步骤是基于linux系统

1. 克隆库

   ```
   docker pull dolomate/spritezero
   复制代码
   ```

2. 在当前目录创建 `./data/sprites/_svg`  文件夹

3. 把svg文件放在 `./data/sprites/_svg` 文件夹中，svg文件的名称不要太随意，名称会被写入json配置文件，后续使用时会用到。 ![img](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/8da07550e0964f10be7da9f789516e0a~tplv-k3u1fbpfcp-watermark.image)

4. 在当前目录执行命令，生成精灵图：

   ```
   docker run -it -e FOLDER=_svg -e THEME=sprites -v ${PWD}/data:/data dolomate/spritezero
   复制代码
   ```

5. 生成的精灵图会存放在 `./data/sprites` 文件夹中

## 精灵图黑框问题

查看生成的精灵图，你可能会碰上下图中的问题：只有黑色轮廓 ![img](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/38c4a9aa8d554948a8c4cf11824708e3~tplv-k3u1fbpfcp-watermark.image)

一通排查，发现上面问题的原因是：在svg代码中，style的写法问题。style单独写不行，需要内嵌到dom元素中，如下图：

![img](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/bce39704b1854cc38ade2807b46d60b7~tplv-k3u1fbpfcp-watermark.image)

![img](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/e404bb9e7532421bb3677f7546750782~tplv-k3u1fbpfcp-watermark.image)

解决方法，用 AI（Adobe Illustrator） 软件导出SVG文件时，CSS属性栏选择“样式属性”，style就会内嵌到dom元素中了。下图是导出时的正确选项，更深入的可以参考[这篇文章](https://link.juejin.cn?target=https%3A%2F%2Fcloud.tencent.com%2Fdeveloper%2Farticle%2F1007666)

![img](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/e057e1ef614844619b9f03199aea9169~tplv-k3u1fbpfcp-watermark.image)

## 在 maputnik 中使用生成的精灵图

1. 把生成的精灵图用web服务器发布出来，我用的tomcat。记得解决web服务器的跨域问题，不然调用时会报错。
2. 配置精灵图发布的路径，如下图

![img](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/390409ca9baa4a04a748b5cc634e62fa~tplv-k3u1fbpfcp-watermark.image)

1. 选择一个symbol类型的符号，在 Image 选项的下拉框中，会直接显示精灵图中的图片名称，这个图片名称就是前面让大家起名不要太随意的SVG文件名称。

   ![img](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/fc7fe788599c43dfafeae13b44cb0256~tplv-k3u1fbpfcp-watermark.image)

## 总结：

1. 在用 maputnik 配图时，如果想自定义地图符号，就要自己制作精灵图
2. 网上的精灵图制作工具，普遍只能生成精灵图，没有json配置文件，而 maputnik 需要json配置文件
3. mapbox开源了一个精灵图制作工具 spritezero ，生成的精灵图有json配置文件
4. spritezero 在安装时会报错，原因是用到的一个库太老了
5. spritezero-docker 是spritezero的docker库，已经解决了安装环境问题
6. 介绍了如何使用 spritezero-docker 生成精灵图
7. 生成精灵图时，如果出现黑框问题，多半是因为style的写法问题。style需要内嵌到dom元素中
8. 介绍了如何在 maputnik 中使用生成的精灵图

## 相关连接：

1. *如何在本地发布OSM数据：[gisarmory.xyz/blog/index.…](https://link.juejin.cn?target=http%3A%2F%2Fgisarmory.xyz%2Fblog%2Findex.html%3Fblog%3DOSMVectorTiles)*
2. *spritezero库github地址：[github.com/mapbox/spri…](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2Fmapbox%2Fspritezero)*
3. *spritezero库安装报错的问题：[github.com/mapbox/spri…](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2Fmapbox%2Fspritezero%2Fissues%2F84)*
4. *spritezero-docker库github地址：[github.com/macteo/spri…](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2Fmacteo%2Fspritezero-docker)*
5. *如何正确用AI导出SVG文件：[cloud.tencent.com/developer/a…](https://link.juejin.cn?target=https%3A%2F%2Fcloud.tencent.com%2Fdeveloper%2Farticle%2F1007666)*