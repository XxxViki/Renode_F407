@echo off
REM ==============================================
REM  Renode_F4 一键仿真启动脚本
REM  双击此文件启动 Renode 仿真
REM ==============================================
cd /d "%~dp0"
echo.
echo Starting Renode with Renode_F4.resc...
echo.
"D:\Renode\renode.exe" Renode_F4.resc
pause
