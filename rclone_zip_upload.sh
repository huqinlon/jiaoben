#!/bin/bash

# 压缩文件夹
folder_path="/path"  # 需要压缩的文件夹路径

# 获取当前时间并格式化
current_time=$(date +"%Y%m%d-%H%M%S")

# 获取源文件夹名
source_folder_name=$(basename "$folder_path")

# 创建新的文件名，将当前时间添加到源文件夹名后
new_filename="${source_folder_name}_${current_time}.tar.gz"

# 压缩文件夹
tar -czvf "$new_filename" "$folder_path"

# 上传到OneDrive
rclone_config="rclone config"  # rclone配置信息，根据实际情况填写
onedrive_bucket="onedrive:/path"  # OneDrive存储桶名称
rclone_command="rclone copy $new_filename $onedrive_bucket --progress"
eval $rclone_command

# 删除本地压缩文件
rm "$new_filename"
