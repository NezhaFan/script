#!/bin/sh

# 获取脚本的绝对路径
filename=$(readlink -f "$0")
 
# 执行该脚本，会把清理指定文件功能加入crontab定时任务执行

check_and_set_crontab() {
  # 检查 crontab 中是否已存在该任务
  if ! crontab -l 2>/dev/null | grep -q "$filename $folder_path $days $size"; then
    # 添加每天凌晨 2 点执行的定时任务
    (crontab -l 2>/dev/null; echo "0 2 * * * sh $filename $folder_path $days $size") | crontab -
    echo "已添加到 crontab 定时任务"
  fi
}

get_params() {
  # 如果没有提供参数，则交互式获取
  if [ -z "$folder_path" ]; then
    read -p "请输入要检查的文件夹路径: " folder_path
  fi

  if [ -z "$days" ]; then
    read -p "请输入天数: " days
  fi

  if [ -z "$size" ]; then
    read -p "请输入大小(MB): " size
  fi
}

# 从命令行参数获取值
folder_path=$1
days=$2
size=$3

# 如果参数不完整，则交互式获取
get_params

# 检查输入的天数是否为数字
case $days in
  ''|*[!0-9]*) 
    echo "错误：请输入有效的数字"
    exit 1
    ;;
esac

# 检查输入的文件大小是否为数字
case $size in
  ''|*[!0-9]*) 
    echo "错误：请输入有效的文件大小数字"
    exit 1
    ;;
esac

# 查找并删除文件（修改为同时判断时间和大小）
find "$folder_path" -type f -mtime +$days -size +"$size"M -exec rm -rf {} \;

echo "已删除 $folder_path 中超过 $days 天且大于 $size MB的文件"

# 检查并设置 crontab
check_and_set_crontab() {
  # 检查 crontab 中是否已存在该任务
  if ! crontab -l 2>/dev/null | grep -q "$filename $folder_path $days $size"; then
    # 添加每天凌晨 2 点执行的定时任务
    (crontab -l 2>/dev/null; echo "0 2 * * * sh $filename $folder_path $days $size") | crontab -
    echo "已添加到 crontab 定时任务"
  fi
}

# 检查并设置 crontab
check_and_set_crontab