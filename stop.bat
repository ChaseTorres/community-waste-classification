@echo off
setlocal enabledelayedexpansion

set APP_NAME=waste-classification

REM 尝试从PID文件获取进程ID
set PID=
if exist "application.pid" (
    set /p PID=<application.pid
    tasklist /fi "PID eq !PID!" | findstr /c:"!PID!" >nul
    if !errorlevel! neq 0 (
        echo PID文件存在，但进程 !PID! 未运行
        set PID=
    )
)

REM 如果PID文件不存在或无效，尝试通过进程名查找
if "!PID!"=="" (
    for /f "tokens=2" %%i in ('tasklist /fi "imagename eq java.exe" /fo list ^| findstr /c:"%APP_NAME%-0.0.1-SNAPSHOT.jar"') do (
        set PID=%%i
    )
    if "!PID!"=="" (
        echo 没有找到正在运行的 %APP_NAME% 实例
        exit /b 0
    )
)

REM 停止应用
echo 正在停止 %APP_NAME%，PID: !PID!
taskkill /pid !PID! >nul

REM 等待应用停止
echo 等待应用停止...
set TIMEOUT=30
:wait_loop
tasklist /fi "PID eq !PID!" | findstr /c:"!PID!" >nul
if !errorlevel! equ 0 (
    if !TIMEOUT! gtr 0 (
        timeout /t 1 /nobreak >nul
        set /a TIMEOUT-=1
        goto wait_loop
    )
)

REM 如果应用仍在运行，强制结束进程
tasklist /fi "PID eq !PID!" | findstr /c:"!PID!" >nul
if !errorlevel! equ 0 (
    echo 应用未在规定时间内停止，正在强制结束进程...
    taskkill /f /pid !PID! >nul
    timeout /t 2 /nobreak >nul
)

REM 确认应用已停止
tasklist /fi "PID eq !PID!" | findstr /c:"!PID!" >nul
if !errorlevel! equ 0 (
    echo 停止应用失败，请手动检查并结束进程
    exit /b 1
) else (
    echo 应用已成功停止
    if exist "application.pid" (
        del application.pid
    )
    echo %date% %time% - 应用已停止 >> logs\shutdown.log
    exit /b 0
)
