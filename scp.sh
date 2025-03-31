#!/bin/sh

user=root

# 定义服务器数组，格式为：IP地址:名称
servers=(
  "192.168.1.100:服务器1"
  "192.168.1.101:生产服务器2"
)

# 显示服务器列表
echo "请选择目标服务器："
index=1
for server in "${servers[@]}"; do
  ip=$(echo $server | cut -d: -f1)
  name=$(echo $server | cut -d: -f2)
  echo "$index) $name ($ip)"
  index=$((index + 1))
done
echo "$index) 其他（手动输入IP）"

# 获取用户选择
while true; do
  read -p "请输入序号: " choice
  if [ -z "$choice" ] || [ $choice -lt 1 ] || [ $choice -gt $((${#servers[@]} + 1)) ]; then
    echo "无效的选择，请重新输入"
    continue
  fi
  break
done

# 获取选中的服务器信息
if [ $choice -eq $((${#servers[@]} + 1)) ]; then
  read -p "请输入服务器IP: " server_ip
else
  selected=${servers[$((choice-1))]}
  server_ip=$(echo $selected | cut -d: -f1)
fi

# 获取要传输的文件
read -p "请输入要传输的文件: " source_file
if [ ! -e "$source_file" ]; then
  echo "文件或目录不存在"
  exit 1
fi

# 获取目标路径
read -p "请输入目标路径（默认为 /$user/）: " target_path
if [ -z "$target_path" ]; then
  target_path="/$user"
fi

# 执行传输
echo "正在传输到 $server_ip:$target_path ..."
if [ -d "$source_file" ]; then
  # 如果是目录，使用 -r 参数
  scp -r "$source_file" "$user@$server_ip:$target_path"
else
  # 如果是文件，使用普通的 scp
  scp "$source_file" "$user@$server_ip:$target_path"
fi

if [ $? -eq 0 ]; then
  echo "传输成功！"
else
  echo "传输失败！"
fi