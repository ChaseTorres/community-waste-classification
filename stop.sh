#!/bin/bash

# 设置应用名称
APP_NAME="waste-classification"

# 尝试从PID文件获取进程ID
if [ -f "application.pid" ]; then
  PID=$(cat application.pid)
  if ! ps -p $PID > /dev/null; then
    echo "PID文件存在，但进程 $PID 未运行"
    PID=""
  fi
fi

# 如果PID文件不存在或无效，尝试通过进程名查找
if [ -z "$PID" ]; then
  PID=$(pgrep -f ${APP_NAME})
  if [ -z "$PID" ]; then
    echo "没有找到正在运行的 ${APP_NAME} 实例"
    exit 0
  fi
fi

# 停止应用
echo "正在停止 ${APP_NAME}，PID: $PID"
kill $PID

# 等待应用停止
echo "等待应用停止..."
TIMEOUT=30
while ps -p $PID > /dev/null && [ $TIMEOUT -gt 0 ]; do
  sleep 1
  TIMEOUT=$((TIMEOUT - 1))
done

# 如果应用仍在运行，强制结束进程
if ps -p $PID > /dev/null; then
  echo "应用未在规定时间内停止，正在强制结束进程..."
  kill -9 $PID
  sleep 2
fi

# 确认应用已停止
if ps -p $PID > /dev/null; then
  echo "停止应用失败，请手动检查并结束进程"
  exit 1
else
  echo "应用已成功停止"
  # 删除PID文件
  if [ -f "application.pid" ]; then
    rm application.pid
  fi
  
  # 记录关闭时间到日志
  echo "$(date '+%Y-%m-%d %H:%M:%S') - 应用已停止" >> logs/shutdown.log
  exit 0
fi 