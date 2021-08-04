- [Nginx+Geoserver部署所遇问题总结](https://www.cnblogs.com/naaoveGIS/p/8413818.html)

# 1.背景

  该问题的最终解决离不开公司大拿whs先生的指点，先表示感谢。

  某项目的geoserver发布在一台linux上，端口为8082。使用Nginx对该geoserver服务（包括其他服务）做了一个转发代理，Nginx监听的端口是8081。由于8082端口没有对外开放，所以用户只能访问该8081端口进行访问。

  由于系统与Geoserver的对接是直接基于OGC服务对接，所以一切正常，但是，用户依然发现对于Geoserver服务网站的访问却存在两个问题：

  a.通过8081代理端口访问Geoserver网站，图层无法直接预览。

 ![img](https://images2017.cnblogs.com/blog/656746/201802/656746-20180204180937185-1092547921.png)

  b.通过8081代理端口访问Geoserver时，如果不加上斜杠（/），则会报空指针异常错误。

  ![img](https://images2017.cnblogs.com/blog/656746/201802/656746-20180204180953029-188800292.png)

# 2.问题一：Geoserver服务无法预览问题

## 2.1问题排查过程

​    点击预览时录制脚本：

   ![img](https://images2017.cnblogs.com/blog/656746/201802/656746-20180204181021576-1402085843.png)

​    可见本应是8081端口请求变成了默认的80端口，导致样式等文件无法加载，从而出现预览为空。跟踪源码，发现URL的获取方式为：

 ![img](https://images2017.cnblogs.com/blog/656746/201802/656746-20180204181037123-2015306065.png)

​    再查看目前Nginx的配置为：

 ![img](https://images2017.cnblogs.com/blog/656746/201802/656746-20180204181121232-429952094.png)

​    可见，此处获取到的URL仅为浏览器输入地址的IP，而没有端口号，所以出现了脚本中默认80端口的问题。加上端口配置，重启Nginx服务，解决。

​    配置修改为：

 ![img](https://images2017.cnblogs.com/blog/656746/201802/656746-20180204181127592-380393456.png)

​    重启Nginx操作：

 ![img](https://images2017.cnblogs.com/blog/656746/201802/656746-20180204181134607-1682363733.png)

## 2.2关于proxy_set_header参数的理解

​    其语法规则为：

​    语法:proxy_set_header field value;默认值:

​    proxy_set_header Host $proxy_host;

​    proxy_set_header Connection close;

​    上下文:http, server, location

​    其作用为：

​    允许重新定义或者添加发往后端服务器的请求头。value可以包含文本、变量或者它们的组合。 当且仅当当前配置级别中没有定义proxy_set_header指令时，会从上面的级别继承配置。

​     对上面问题出现我们可以这样理解：当使用了nginx反向服务器后，在web端使用request.getRemoteAddr()（本质上就是获取$remote_addr），取得的是nginx的地址，即$remote_addr变量中封装的是nginx的地址，当然是没法获得用户的真实ip的。

 

# 3.问题二：浏览器输入首页访问地址不带斜杠报错问题（http://ip:8081/geoserver报错）

## 3.1.一个奇怪的现象

​    首先，我在本地单独发布了一个Geoserver测试该问题，发现即使我输入不带斜杠，访问时浏览器也会为我自动加上斜杠访问。而服务器上的Geoserver则不会。

​    最开始怀疑为浏览器自身补全功能，但是这又无法解释访问云上地址时不补全现象。最后通过查资料确定为如下情况导致：

​    以访问http://ip:8081/geoserver为例子，在windows 系统上，一般如果服务器识别根目录有文件夹为geoserver(没有文件名为geoserver)  时，他们会自动给目录加斜杠。但是，如果是linux 系统则不会，linux  系统会把它作为文件处理（不会以目录形式处理），直接就打开geoserver文件,所以不会加上斜杠。

​    因为服务器为linux系统，所以不会自动加上斜杠。

## 3.2从报错信息排查起

### 3.2.1正常情况下，带/时跳转的原理

​    Geoserver的web.xml中有如下配置：

  <welcome-file-list>

​    <welcome-file>/index.html</welcome-file>

  </welcome-file-list>

​    所以带上/时，会自动跳转至index.html页面，而

​    index.html中有：

 ![img](https://images2017.cnblogs.com/blog/656746/201802/656746-20180204181249467-312731882.png)

​    于是请求再度调转为：[http://192.168.**.**:8081/geoserver/web/](http://192.168.56.104:8081/geoserver/web/)，进入Geoserver首页。

### 3.2.2没有按照套路走，报错发生的原因在哪里

​    我们再看web.xml中的配置：

 ![img](https://images2017.cnblogs.com/blog/656746/201802/656746-20180204181257279-255892992.png)

   ![img](https://images2017.cnblogs.com/blog/656746/201802/656746-20180204181333295-1255490545.png)

　　此时因为匹配规则是/*，所以所有请求要先经过过滤器之后，才会走到欢迎页面设置，查看源码发现：

 　![img](https://images2017.cnblogs.com/blog/656746/201802/656746-20180204181348029-732967954.png)

 

## 3.3解决方法

​    经过认真思考，有两种解决方案：

​    一种是对Nginx配置进行针对性优化；

​    一种方案是对Geoserver升级。

​    以下分段进行分别描述。

# 4.针对问题二：Nginx配置优化

## 4.1需求描述

​    整理需求为：我们需要实现在直接访问Geoserver（不带/）时转发自动加上/。但是针对Geoserver/（带上/）时转发不再自动加上/（//现象会导致访问404问题）。

​    查找资料，Nginx的rewrite机制可以非常好的解决该需求：

​     和apache等web服务软件一样，Nginx的rewrite的组要功能是实现RUL地址的重定向。Nginx的rewrite功能需要PCRE软件的支持，即通过perl兼容正则表达式语句进行规则匹配的。默认参数编译nginx就会支持rewrite的模块，但是也必须要PCRE的支持。rewrite是实现URL重写的关键指令，根据regex（正则表达式）部分内容，重定向到replacement，结尾是flag标记。

## 4.2Nginx相关配置总结

### 4.2.1语法规则

​    其语法规则为：

​    rewrite  <regex>  <replacement>  [flag];

​     关键字    正则    替代内容    flag标记

 

​    关键字：其中关键字error_log不能改变

​    正则：perl兼容正则表达式语句进行规则匹配

​    替代内容：将正则匹配的内容替换成replacement

​    flag标记：rewrite支持的flag标记

​    flag标记说明：

​    last #本条规则匹配完成后，继续向下匹配新的location URI规则

​    break #本条规则匹配完成即终止，不再匹配后面的任何规则

​    redirect #返回302临时重定向，浏览器地址会显示跳转后的URL地址

​    permanent #返回301永久重定向，浏览器地址栏会显示跳转后的URL地址

### 4.2.2执行顺序

​    a.执行server块的rewrite指令(这里的块指的是server关键字后{}包围的区域，其它xx块类似)
​    b.执行location匹配
​    c.执行选定的location中的rewrite指令
​    如果其中某步URI被重写，则重新循环执行1-3，直到找到真实存在的文件

如果循环超过10次，则返回500 Internal Server Error错误

### 4.2.3正则表达式规则

​    . ： 匹配除换行符以外的任意字符

​    ? ： 重复0次或1次

​    \+ ： 重复1次或更多次

​    \* ： 重复0次或更多次

​    \d ：匹配数字

​    ^ ： 匹配字符串的开始

​    $ ： 匹配字符串的介绍

​    {n} ： 重复n次

​    {n,} ： 重复n次或更多次

​    [c] ： 匹配单个字符c

​    [a-z] ： 匹配a-z小写字母的任意一个

​    小括号()之间匹配的内容，可以在后面通过$1来引用，$2表示的是前面第二个()里的内容。正则里面容易让人困惑的是\转义特殊字符。

### 4.2.4常用变量

​    $args ： #这个变量等于请求行中的参数，同$query_string

​    $content_length ： 请求头中的Content-length字段。

​    $content_type ： 请求头中的Content-Type字段。

​    $document_root ： 当前请求在root指令中指定的值。

​    $host ： 请求主机头字段，否则为服务器名称。

​    $http_user_agent ： 客户端agent信息

​    $http_cookie ： 客户端cookie信息

​    $limit_rate ： 这个变量可以限制连接速率。

​    $request_method ： 客户端请求的动作，通常为GET或POST。

​    $remote_addr ： 客户端的IP地址。

​    $remote_port ： 客户端的端口。

​    $remote_user ： 已经经过Auth Basic Module验证的用户名。

​    $request_filename ： 当前请求的文件路径，由root或alias指令与URI请求生成。

​    $scheme ： HTTP方法（如http，https）。

​    $server_protocol ： 请求使用的协议，通常是HTTP/1.0或HTTP/1.1。

​    $server_addr ： 服务器地址，在完成一次系统调用后可以确定这个值。

​    $server_name ： 服务器名称。

​    $server_port ： 请求到达服务器的端口号。

​    $request_uri ： 包含请求参数的原始URI，不包含主机名，如：”/foo/bar.php?arg=baz”。

​    $uri ： 不带请求参数的当前URI，$uri不包含主机名，如”/foo/bar.html”。

​    $document_uri ： 与$uri相同。

### 4.2.5动态变量参数

​    $1-$9存放着正则表达式中最近的9个正则表达式的匹配结果，这些结果按照子匹配的出现顺序依次排列。
​    $1 代表的是匹配的第一个结果。
​    括号表示的是表达式定义的“组”（group），并且将匹配这个表达式的字符保存到一个临时区域（一个正则表达式中最多可以保存9个） 上面的表达式有2个匹配组 (\w+) 和 (.*) 所有后面可以用 $1 和 $2 来用
​    比如例子^/(\w+)/(.*)$ /$1/index.php last;
​    对应为：/abc123/bcdfda =>  /abc123/index.php

## 4.3解决该问题的最终配置

 ![img](https://images2017.cnblogs.com/blog/656746/201802/656746-20180204181412623-391685831.png)

# 5.针对问题二：Geoserver升级

​    进入Geoserver下载官网进行学习：http://geoserver.org/download/

 ![img](https://images2017.cnblogs.com/blog/656746/201802/656746-20180204181505092-736296830.png)

　　由于公司标准运行环境为jdk1.7.x，所以主要对Geoserver2.8.x和Geoserver2.9.x进行了对比研究，总结如下：

## 5.1.运行环境

​    a.  2.9.x系列虽然描述为compatible with Java 8，个人理解为jdk7和jdk8应该都可以运行。 但是，分别在jdk1.7._067和云上的1.7._079上测试过，不可运行：

 ![img](https://images2017.cnblogs.com/blog/656746/201802/656746-20180204181518092-925374003.png)

​    b.在2.8.X系列上进行了相关测试，均可以支持jdk1.7.x系列。

## 5.2.geoserver2.8.5版本的优点

 ![img](https://images2017.cnblogs.com/blog/656746/201802/656746-20180204181530232-324538593.png)

## 　![img](https://images2017.cnblogs.com/blog/656746/201802/656746-20180204181550060-2020685639.png)

​    总结优化即是：强化了三维服务支持、集成了更多（最新）的插件、针对某些特殊情况下的数据发布（如局域网共享文件安全机制）导致的闪退等问题进行了修复。

​    公司主要用到的基于本地矢量数据或者PG数据的WMS、WFS服务没有特殊说明的优化和改动。

​    但是geoserver的代码架构还是做了不少变化。

​    同时，针对不带斜杠访问报错问题，2.8.5上也做了优化：

 ![img](https://images2017.cnblogs.com/blog/656746/201802/656746-20180204181620170-956073265.png)

## 5.3.基于业务的测试

​    a.基于公司云上一键安装环境进行测试，目前部件展示、I查询、网格查询正常：

   ![img](https://images2017.cnblogs.com/blog/656746/201802/656746-20180204181636154-1635511411.png)

​    b基于PG测试，也是正常。

 ![img](https://images2017.cnblogs.com/blog/656746/201802/656746-20180204181649123-1705134198.png)

## 5.4.但是，有一个小缺点

​    整个2.8.x系列，在版本chrome 63.0.3239.132上，geoserver平台在某些弹出框上会出现内容为空。但是IE（9以上）没有这个问题。考虑到这类手动操作不常见，不影响工程同事使用。

 ![img](https://images2017.cnblogs.com/blog/656746/201802/656746-20180204181704576-468335222.png)

# 