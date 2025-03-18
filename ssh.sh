#!/bin/bash

user=root

servers=(
  "1 美服 1.1.1.1"
  "2 国服 2.2.2.2"
)

echo "以下是可用的服务器选项："
for server in "${servers[@]}"; do
  echo "$server"
done

read -p "请输入数字选项以选择服务器：" choice

selected_server=""
for server in "${servers[@]}"; do
  if [[ ${server:0:1} == $choice ]]; then
    selected_server=${server:2}
    ip_address=$(echo "$selected_server" | awk '{print $2}')
    break
  fi
done

if [ -n "$ip_address" ]; then
  echo "连接${ip_address}中..."
  ssh "${user}@${ip_address}"
else
  echo "无效的选择。"
fi
