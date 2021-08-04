- [解决Geoserver请求跨域的几种思路](https://www.cnblogs.com/naaoveGIS/p/8418414.html)

# 1.背景描述

   跨域问题是浏览器同源安全制引起的特别常见的问题。不同前端语言针对跨域解决方法有所区别。比如Flex语言做跨域请求时，如果中间件存有跨域文件（crossdomain.xml）则可以轻松实现跨域。

  而JS开发的前端，针对GET请求则又可以通过JSONP方式解决。补充一下JSONP的原理：通过创建一个 script 标签，将  src 设置为目标请求，插入到  DOM中，服务器接受该请求并返回数据，数据通常被包裹在回调钩子中。根据JSONP的实现原理，我们可以看到其无法支持POST请求方式。

  回到我们文章的主题，使用tomcat发布了Geoserver，前端JS脚本通过常规JSONP的请求方式失效，此时如何实现跨域请求呢？

  这里我总结两种思路，一种是转发代理方案，另一种是中间件支持跨域共享机制（CORS）。

# 2.方案一：转发代理

## 2.1基于Nginx的代理

   假设有A服务器和B服务器，用户前端加载了A服务器的JS资源，然后该JS向B服务器后台发送请求，此时发生了跨域。基于Nginx的解决方案则是，在C（或者A或者B或者其他）服务器上搭建一个Nginx服务器，该服务器对A服务和B服务均做统一端口的代理，即前端通过同一IP：Port访问A上和B上的资源，从而避免浏览器的跨域问题。

  方案示意图为：

 ![img](https://images2017.cnblogs.com/blog/656746/201802/656746-20180205165754170-1608637761.png)

## 2.2自定义实现代理转发（基于A服务器）

### 2.2.1原理

  目前A服务器上的脚本想访问B服务器上的服务会引发跨域，如果我们将A服务器的脚本访问转移到A服务器上的后台对B服务器后台的访问，则可以规避跨域问题。

  方案示意图为：

 ![img](https://images2017.cnblogs.com/blog/656746/201802/656746-20180205165810560-827912474.png)

### 2.2.2具体实现

  如果我们的代码层面仅仅是单独针对某个请求让其转移至后台，则其他类似问题则无法通用此解决方案。这里我们可以设计一种通用型的解决方案：

  a.将所有需要走后台避免跨域的请求统一定义为[http://IP:Port/name/proxy?Url=BServerUrl](http://ip:Port/name/proxy?Url=BServerUrl)。

  b.后台对应的proxy方法中获取到Url后的参数，并且再次对Url后的参数进行传递参数的解析（BServerUrl中可以用&包含正常参数）。

  c.转发解析到的B请求，获取返回结果再返回至前端。

  注意，在实现中，我们还要同时考虑代理转发的Get请求和Post请求方式：

 ![img](https://images2017.cnblogs.com/blog/656746/201802/656746-20180205165825779-806101973.png)

# 3.方案二：中间件跨域共享机制（CORS）

## 3.1CORS原理简介

  出于安全原因，浏览器限制从脚本内发起的跨源HTTP请求。 例如，XMLHttpRequest和Fetch API遵循同源策略。 这意味着使用这些API的Web应用程序只能从加载应用程序的同一个域请求HTTP资源，除非使用CORS头文件。

  CORS的原理为：跨域资源共享标准新增了一组 HTTP 首部字段，允许服务器声明哪些源站有权限访问哪些资源。另外，规范要求，对那些可能对服务器数据产生副作用的 HTTP 请求方法（特别是 [GET](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Methods/GET) 以外的 HTTP 请求，或者搭配某些 MIME 类型的 [POST](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Methods/POST) 请求），浏览器必须首先使用 [OPTIONS](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Methods/OPTIONS) 方法发起一个预检请求（preflight request），从而获知服务端是否允许该跨域请求。服务器确认允许之后，才发起实际的 HTTP 请求。在预检请求的返回中，服务器端也可以通知客户端，是否需要携带身份凭证（包括 [Cookies ](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Cookies)和 HTTP 认证相关数据）。

  以上内容均摘抄于：https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Access_control_CORS。

## 3.2具体实现

  先下载CORS对应的Jar：

  <!-- cors-filter-->
    <dependency org="com.thetransactioncompany" name="java-property-utils" rev="1.10" conf="common-release->default;" />
   <dependency org="com.thetransactioncompany" name="cors-filter" rev="2.5" conf="common-release->default;"/>

![img](https://images2017.cnblogs.com/blog/656746/201802/656746-20180205165847623-1389423052.png)

  在Geoserver的Web.xml中加上如下配置：

 ![img](https://images2017.cnblogs.com/blog/656746/201802/656746-20180205165859107-819086943.png)

  重启Geoserver后测试。

  测试环境说明：在同一台机器上测试，系统采用8081端口，Geoserver服务采用8080端口，不同端口同样会导致跨域。测试结果为跨域成功。

 ![img](https://images2017.cnblogs.com/blog/656746/201802/656746-20180205165919295-896236913.png)

 