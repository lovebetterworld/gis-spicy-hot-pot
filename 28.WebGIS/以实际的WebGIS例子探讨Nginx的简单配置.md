- [以实际的WebGIS例子探讨Nginx的简单配置](https://www.cnblogs.com/naaoveGIS/p/5482635.html)

## 1.背景

以实际项目中的一个例子来详细讲解Nginx中的一般配置，其中涉及到部分正则表达式的内容。在这个实际例子中，我们要做的是使用Nginx为WebGIS中常用的离散瓦片做一个伺服器。关于Nginx的下载、与tomcat的组合配置、测试例子可以参考我的上一篇博客http://www.cnblogs.com/naaoveGIS/p/5478208.html。

## 2.Nginx中的简单配置

### 2.1配置一般代理路径

 ![img](https://images2015.cnblogs.com/blog/656746/201605/656746-20160511170733874-1997642295.png)           

让Nginx监听8010端口，一般情况下均转发到localhost:8080端口下。

### 2.2 配置瓦片资源代理路径

 ![img](https://images2015.cnblogs.com/blog/656746/201605/656746-20160511170742812-624915361.png)

包含GISV14，以png等结尾的请求均在ROOT文件夹下寻找资源。

切记，此时需要将所有瓦片也转移到该文件夹下：

 ![img](https://images2015.cnblogs.com/blog/656746/201605/656746-20160511170753109-924019232.png)

### 2.3 增加过滤配置

以上配置对所有png结尾的请求均作了代理转发地址。但是很多样式文件中的png图片也被转发了，这里需要做一个过滤进行规避：

 ![img](https://images2015.cnblogs.com/blog/656746/201605/656746-20160511170800468-847156985.png)

即GISV14/library/的请求还是转发至localhost:8080下。

### 2.4检查Nginx的配置后重新加载

 ![img](https://images2015.cnblogs.com/blog/656746/201605/656746-20160511170836921-779307424.png)

正确后，则重新加载配置。

 ![img](https://images2015.cnblogs.com/blog/656746/201605/656746-20160511170843624-2093931001.png)

## 3.结果展示

下图为前端展示效果：

 ![img](https://images2015.cnblogs.com/blog/656746/201605/656746-20160511170905452-871022564.png)

其后台瓦片资源请求如下：

 ![img](https://images2015.cnblogs.com/blog/656746/201605/656746-20160511170912702-2041278463.png)

## 4.Nginx中的常见正则表达式

Linux环境下，要使用nginx提供的正则表达式名字，那么在编译安装nginx时必须首先安装Perl编程语言正则表达式(PCRE)。

### 4.1常见规则

~ 区分大小写匹配。

~* 不区分大小写匹配。

!~和!~*分别为区分大小写不匹配及不区分大小写不匹配。

^ 以什么开头的匹配。

$ 以什么结尾的匹配。

. 匹配除换行符 \n之外的任何单字符。要匹配 .，请使用 \。

\* 匹配前面的子表达式零次或多次。要匹配 * 字符，请使用 \*。

? 匹配前面的子表达式零次或一次，或指明一个非贪婪限定符。要匹配 ? 字符，请使用 \?。

\+ 匹配前面的子表达式一次或多次。要匹配 + 字符，请使用 \+。

### 4.2注意

a.为了使用正则表达式，在服务器名字开始之前使用一个波浪号字符“~”，否则，就会被作为准确的名字来对待。

b.如果在表达式中包含一个星号（*），那么就会被作为一个通配符名字(最有可能成为无效的名字)。

c.不要忘记设置锚符号“^” 和“$”，它们不需要在语法，而是在逻辑上。

d.在域名中的点号“.”要使用反斜线进行转义。

## 5.location中配置的匹配顺序

 ![img](https://images2015.cnblogs.com/blog/656746/201605/656746-20160511170923718-1843941519.png)

如图，我们在config中配置了两个匹配路径，那么当路径为/GISV14/library/test.png这种情况下，哪个匹配路径的优先级更高呢？

这里我先给出匹配顺序的规则:

a.标识符“=”的location会最先进行匹配，如果请求uri匹配这个location，将对请求使用这个location的配置。
b.进行字符串匹配，如果匹配到的location有^~这个标识符，匹配停止返回这个location的配置。
c.按照配置文件中定义的顺序进行正则表达式匹配。最早匹配的location将返回里面的配置。
d.如果正则表达式能够匹配到请求的uri，将使用这个正则对应的location，如果没有，则使用第二条匹配的结果。

根据规则中的b、c两个规则，都是指向转发tomcat服务器这个配置。

## 6.其他相关知识

### 6.1 逻辑关键字

Nginx中还包含了其他关键字，可以进行一定的程序化逻辑判断。比如包含了：if、break、rewrite,redirect等。这里贴出一个例子：

 ![img](https://images2015.cnblogs.com/blog/656746/201605/656746-20160511170931624-1508289574.png)

### 6.2全局变量

$args
$content_length
$content_type
$document_root
$document_uri
$host
$http_user_agent
$http_cookie
$limit_rate
$request_body_file
$request_method
$remote_addr
$remote_port
$remote_user
$request_filename
$request_uri
$query_string
$scheme
$server_protocol
$server_addr
$server_name
$server_port
$uri