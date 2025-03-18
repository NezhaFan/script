#!/bin/bash

# 选择请求方法
while true; do
  echo "请选择请求方法:"
  echo "1) GET"
  echo "2) POST (JSON)"
  echo "3) POST (Form)"
  echo "4) PUT"
  echo "5) HEAD"
  echo "6) DELETE"
  read -p "请选择方法 (1-6): " method_choice

  case $method_choice in
    1) method="GET"; break ;;
    2) method="POST"; content_type="application/json"; break ;;
    3) method="POST"; content_type="application/x-www-form-urlencoded"; break ;;
    4) method="PUT"; break ;;
    5) method="HEAD"; break ;;
    6) method="DELETE"; break ;;
    *) echo "无效选项，请重新选择" ;;
  esac
done

# 输入 URL
read -e -p "请输入 URL: " url
# 检查 URL 是否以 http 开头，如果不是则添加本地地址前缀
if [[ ! "$url" =~ ^https?:// ]]; then
  url="http://127.0.0.1$url"
fi

# 准备 curl 命令
if [ "$method" = "GET" ]; then 
  command="curl '$url'"
elif [ "$method" == "HEAD" ]; then 
  command="curl -I $method '$url'"
else
  command="curl -X $method '$url'"
fi

# 输入 Authorization（可选）
read -e -p "请输入 Authorization token: " auth_token
# 添加 Authorization header
if [ ! -z "$auth_token" ]; then
  command="$command -H 'Authorization: Bearer $auth_token'"
fi

if [ "$method" = "POST" -o "$method" = "PUT" ]; then 
  # 添加 Content-Type header
  if [ ! -z "$content_type" ]; then
    command="$command -H 'Content-Type: $content_type'"
  fi

  # 处理数据输入
  read -e -p "请输入数据或数据文件名: " data
  if [ ! -z "$data" ]; then
    # 检查是否是 .json 文件
    if [[ "$data" =~ \.json$ ]] && [ -f "$data" ]; then
      # 读取 JSON 文件内容
      file_content=$(cat "$data")
      command="$command -d '$file_content'"
    else
      command="$command -d '$data'"
    fi
  fi

fi

# 显示并执行命令
echo "按回车键执行命令..."
echo "$command"
read -p "" confirm
eval "$command && echo"

