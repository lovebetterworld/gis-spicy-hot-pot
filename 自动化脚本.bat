@echo off

rem 仓库自动化脚本
title   Git Working
cls 

goto selectAll

pause

rem 选择函数
:selectAll
echo ----------------------------------------
echo    注意：请确保您的git命令可以直接在cmd中运行，如果不能运行，请查看path环境变量
echo    请选择你要进行的操作，然后按回车
echo ----------------------------------------
echo        1，仓库初始化
echo        2，提交仓库
echo        3，退出
set/p n=  请选择：

if "%n%"=="1" ( goto initfun ) else ( if "%n%"=="2" ( goto subfun )   else ( if "%n%"=="3" ( exit ) else ( goto selectAll )))


:subfun
echo    请选择要提交的数据，然后按回车
echo ----------------------------------------
echo        1，单个文件
echo        2，全部文件
echo        3，返回上一级
echo        4，退出
echo ----------------------------------------
set/p  f=  请选择：

if "%f%"=="1" ( goto one ) else ( if "%f%"=="2" ( goto all )  else ( if "%f%"=="3" ( goto selectAll )   else (if "%f%"=="4" ( goto exit ) else ( goto subfun ))))

:one
set/p  fo=  请输入要上传的文件：
git add "%fo%"
echo 正在进行提交中...
set/p  co=  请输入描述内容：
echo 正在进行对文件进行描述中...
git commit -m "%co%"
echo git单文件上传完成...
goto subfun

:all
echo 正在拉取远程仓库，请稍候...
git pull
echo 远程仓库已拉取成功，正在添加本地文件，请稍候...
git add .
echo 正在进行提交中...，请稍候...
set/p  ca=  请输入描述内容：
git commit -m "%ca%"
echo 正在进行对文件进行描述中...
Echo 
git push 
goto subfun

:initfun
echo 正在进行初始化中...
set/p  name=  请输入name：
   git config --global user.name "%name%"
set/p  email=  请输入email：
   git config --global user.email "%email%"
 git init
set/p giturl= git初始化已经完成，请输入仓库地址：
  git remote add origin %giturl%
echo 初始化已完成
cls  
goto selectAll