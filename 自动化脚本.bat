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
echo        1，提交全部文件仓库
echo        2，退出
set/p n=  请选择：

if "%n%"=="1" ( goto all ) else ( if "%n%"=="2" ( exit ) else ( goto selectAll ))

:all
echo 正在拉取远程仓库，请稍候...
git pull
echo 远程仓库已拉取成功，正在添加本地文件，请稍候...
git add .
echo 正在进行提交中...，请稍候...
git commit -m "学习笔记"
echo 正在进行对文件进行描述中...
Echo 
git push 
goto selectAll