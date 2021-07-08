- [PostgreSql+PostGIS和uDig的安装](https://www.cnblogs.com/naaoveGIS/p/4188097.html)

## 1.前言

总体来说，这两款开源软件均是很好安装的，一般按照提示一步一步点击next等，就可以装好。当然，也有需要注意的地方。下面我大致介绍下两款软件的安装流程。

## 2.PostgreSql+PostGIS的安装

### 2.1下载地址

在官网http://www.postgresql.org/download/处可以下载到最新的PG版本。

### 2.2PostgreSql的安装流程

a.点击安装包exe

 ![img](https://images0.cnblogs.com/blog/656746/201412/271038578583250.png)            

b.点击开始安装

 ![img](https://images0.cnblogs.com/blog/656746/201412/271039085939669.png)

c.设置安装路径

 ![img](https://images0.cnblogs.com/blog/656746/201412/271039189835363.png)

d.设置用户名和密码以及监听端口

 ![img](https://images0.cnblogs.com/blog/656746/201412/271039262965128.png)

![img](https://images0.cnblogs.com/blog/656746/201412/271039521242639.png)

 e. 选择运行时语言环境

![img](https://images0.cnblogs.com/blog/656746/201412/271039416247447.png)

 网上有人说：在选择语言环境时，若选择"default locale"会导致安装不正确；同时，PostgreSQL 不支持 GBK 和  GB18030 作为字符集，如果选择其它四个中文字符集：中文繁体 香港（Chinese[Traditional], Hong Kong  S.A.R.）、中文简体 新加坡（Chinese[Simplified], Singapore）、中文繁体  台湾（Chinese[Traditional], Taiwan）和中文繁体 澳门（Chinese[Traditional], Marco  S.A.R.），会导致查询结果和排序效果不正确。建议选择"C"，即不使用区域。
也有人说：选择了default localt，安装正确；建议选择default localt。

我个人安装时，选择的是C。大家可以都尝试下，如果不行，可以卸载再装，代价不大。

f.开始安装

 ![img](https://images0.cnblogs.com/blog/656746/201412/271040145306793.png)

g.安装完成

 ![img](https://images0.cnblogs.com/blog/656746/201412/271040225776402.png)

### 2.3PostGIS的安装流程

安装完PostgreSql后，有一个扩展选择项。选中postGIS后，会将最新的postGIS安装包下载到本地。

 ![img](https://images0.cnblogs.com/blog/656746/201412/271040345624107.png)

下载完后，直接点击安装即可。无特殊注意点。

### 2.4安装成功后的效果

安装成功后，在开始菜单栏里可以看到以下菜单：

 ![img](https://images0.cnblogs.com/blog/656746/201412/271040471879682.png)

点击pgAdminIII后可以看到postgreSQL的可视化管理工具：

 ![img](https://images0.cnblogs.com/blog/656746/201412/271040593743561.png)

## 3.uDig的安装

### 3.1下载地址

uDig的官网下载地址为：http://udig.refractions.net/download/。

### 3.2uDig的安装流程

a.点击安装文件exe

 ![img](https://images0.cnblogs.com/blog/656746/201412/271041104685936.png)

b.点击next开始安装

点击next后程序开始安装，稍等一会儿后就自动装好了。

 ![img](https://images0.cnblogs.com/blog/656746/201412/271041214524515.png)

### 3.3安装成功后的效果

安装成功后在开始菜单栏会出现以下菜单：

 ![img](https://images0.cnblogs.com/blog/656746/201412/271041336555920.png)

点击uDig后：

![img](https://images0.cnblogs.com/blog/656746/201412/271041447186539.png)

​    