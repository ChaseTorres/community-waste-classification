#!/bin/bash

# 创建日志目录
mkdir -p logs

# 设置应用名称和JAR文件路径
APP_NAME="waste-classification"
JAR_FILE="target/${APP_NAME}-0.0.1-SNAPSHOT.jar"

# 检查JAR文件是否存在
if [ ! -f "$JAR_FILE" ]; then
  echo "错误: JAR文件不存在，请先运行: mvn clean package -DskipTests"
  exit 1
fi

# 检查是否有正在运行的实例
PID=$(pgrep -f ${APP_NAME})
if [ -n "$PID" ]; then
  echo "警告: 应用已经在运行中，PID: $PID"
  echo "如需重启，请先运行 ./stop.sh"
  exit 1
fi

# 设置JVM参数
JAVA_OPTS="-Xms512m -Xmx1024m -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=256m"

# 启动应用
echo "正在启动 ${APP_NAME}..."
nohup java ${JAVA_OPTS} -jar ${JAR_FILE} > logs/startup.log 2>&1 &

# 获取进程ID
PID=$!
echo $PID > application.pid

# 等待应用启动
echo "应用正在启动，请稍候..."
sleep 5

# 检查应用是否成功启动
if ps -p $PID > /dev/null; then
  echo "应用启动成功! PID: $PID"
  echo "可以通过以下命令查看日志:"
  echo "  tail -f logs/waste-classification.log"
  echo "  tail -f logs/startup.log"
else
  echo "应用启动失败，请检查 logs/startup.log 获取详细信息"
  exit 1
fi 