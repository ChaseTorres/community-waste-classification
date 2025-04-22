@echo off
setlocal enabledelayedexpansion

REM 创建日志目录
if not exist "logs" mkdir logs

REM 设置应用名称和JAR文件路径
set APP_NAME=waste-classification
set JAR_FILE=target\%APP_NAME%-0.0.1-SNAPSHOT.jar

REM 检查JAR文件是否存在
if not exist "%JAR_FILE%" (
    echo 错误: JAR文件不存在，请先运行: mvn clean package -DskipTests
    exit /b 1
)

REM 检查是否有正在运行的实例
for /f "tokens=2" %%i in ('tasklist /fi "imagename eq java.exe" /fo list ^| findstr /c:"%JAR_FILE%"') do (
    set PID=%%i
)
if defined PID (
    echo 警告: 应用已经在运行中，PID: !PID!
    echo 如需重启，请先运行 stop.bat
    exit /b 1
)

REM 设置JVM参数
set JAVA_OPTS=-Xms512m -Xmx1024m -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=256m

REM 启动应用
echo 正在启动 %APP_NAME%...
start /B java %JAVA_OPTS% -jar %JAR_FILE% > logs\startup.log 2>&1
for /f "tokens=2" %%i in ('tasklist /fi "imagename eq java.exe" /fo list ^| findstr /c:"%JAR_FILE%"') do (
    set PID=%%i
)
echo !PID! > application.pid

REM 等待应用启动
echo 应用正在启动，请稍候...
timeout /t 5 /nobreak >nul

REM 检查应用是否成功启动
tasklist /fi "PID eq !PID!" | findstr /c:"!PID!" >nul
if %errorlevel% equ 0 (
    echo 应用启动成功! PID: !PID!
    echo 可以通过以下命令查看日志:
    echo   type logs\waste-classification.log
    echo   type logs\startup.log
) else (
    echo 应用启动失败，请检查 logs\startup.log 获取详细信息
    exit /b 1
)
