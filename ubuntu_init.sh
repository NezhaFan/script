#!/bin/sh

# 更新包列表
echo "正在更新包列表..."
sudo apt update

# 安装工具
echo "开始检查并安装基础工具..."
tools="vim wget curl telnet lsof tar zip"

# 使用 for 循环遍历空格分隔的字符串
for tool in $tools
do
  if command -v $tool > /dev/null 2>&1
  then
    echo "$tool 已经安装，跳过..."
  else
    echo "正在安装 $tool..."
    sudo apt install -y $tool
  fi
done

# 验证安装
echo "验证安装结果："
for tool in $tools
do
  if command -v $tool > /dev/null 2>&1
  then
    echo "$tool 安装成功"
  else
    echo "$tool 安装失败"
  fi
done

# 检查时区
echo "检查系统时区..."
current_timezone=$(date +%Z)
if [ "$current_timezone" != "CST" ]; then
  echo "当前时区不是中国时区，正在设置..."
  sudo ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
  echo "Asia/Shanghai" | sudo tee /etc/timezone
  echo "时区已设置为中国时区"
else
  echo "当前已是中国时区 (CST)"
fi


# 检查并创建 pi 用户
echo "检查 pi 用户是否存在..."
if ! getent passwd pi > /dev/null 2>&1; then
  echo "pi 用户不存在，开始创建..."
  echo "请输入 pi 用户的密码："
  stty -echo
  read password
  stty echo
  echo
  echo "请再次输入密码确认："
  stty -echo
  read password2
  stty echo
  echo
  
  if [ "$password" != "$password2" ]; then
    echo "两次密码输入不一致，退出..."
    exit 1
  fi
  
  # 创建用户并设置密码
  sudo useradd -m -s /bin/bash pi
  echo "pi:$password" | sudo chpasswd
  
  # 添加 sudo 权限
  sudo usermod -aG sudo pi
  echo "pi 用户创建成功，并已添加到 sudo 组"
else
  echo "pi 用户已存在"
fi
