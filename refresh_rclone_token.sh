#!/bin/bash
# 脚本名称: refresh_rclone_token.sh
# 可选命令：lsd   # 列出远程存储的根目录
#           about   # 查看远程存储的使用情况
#           size remote:/path  # 计算目录大小
# 配置参数
REMOTES=("google_drive" "onedrive" "dropbox")
LOG_DIR="/var/log/rclone"
MAX_LOG_DAYS=30

# 初始化日志目录
mkdir -p "$LOG_DIR"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="$LOG_DIR/refresh_${TIMESTAMP}.log"

# 记录开始时间
echo "===== Rclone 令牌刷新开始 [$(date)] =====" >> $LOG_FILE

# 遍历所有 remote
for remote in "${REMOTES[@]}"; do
  echo "正在刷新 Remote: $remote ..." >> $LOG_FILE
  rclone lsd "$remote": >> $LOG_FILE 2>&1
  if [ $? -eq 0 ]; then
    echo "成功: $remote 令牌已刷新" >> $LOG_FILE
  else
    echo "错误: $remote 刷新失败！请检查配置！" >> $LOG_FILE
  fi
done

# 清理旧日志
find "$LOG_DIR" -name "*.log" -mtime +$MAX_LOG_DAYS -exec rm {} \; >> $LOG_FILE 2>&1

# 记录结束时间
echo "===== 任务完成 [$(date)] =====" >> $LOG_FILE
