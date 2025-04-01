#!/bin/sh

# 在文件开头添加跟踪变量
envfile="$HOME/.profile"
env_modified=0

# 默认环境变量文件 ~/.profile
if [ ! -d "$envfile" ]; then
  echo "添加环境变量文件 $envfile"
  touch "$envfile"
fi

# 检测包管理器
if which apt >/dev/null 2>&1; then
  pkg_manager="apt"
  install_cmd="apt install -y"
elif which yum >/dev/null 2>&1; then
  pkg_manager="yum"
  install_cmd="yum install -y"
elif which dnf >/dev/null 2>&1; then
  pkg_manager="dnf"
  install_cmd="dnf install -y"
elif which apk >/dev/null 2>&1; then
  pkg_manager="apk"
  install_cmd="apk add"
else
  echo "未找到支持的包管理器"
  exit 1
fi

# 更新包列表
# echo "正在更新包列表..."
# if [ "$pkg_manager" = "apt" ]; then
#   apt update
# elif [ "$pkg_manager" = "yum" ] || [ "$pkg_manager" = "dnf" ]; then
#   $pkg_manager check-update
# elif [ "$pkg_manager" = "apk" ]; then
#   apk update
# fi

# 安装工具
echo "开始检查并安装基础工具..."
# tools="vim wget curl telnet lsof tar zip"
tools="vim"


# 使用 for 循环遍历空格分隔的字符串
for tool in $tools
do
  if command -v $tool > /dev/null 2>&1
  then
    # echo "$tool 已经安装，跳过..."
  else
    echo "正在安装 $tool..."
    $install_cmd $tool
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

# 检查并配置 vim 设置
vimrc="$HOME/.vimrc"
if [ ! -f "$vimrc" ]; then
  echo "set encoding=utf-8" >> "$vimrc"
  echo "set tabstop=2" >> "$vimrc"
  echo "syntax on" >> "$vimrc"
  echo "set autoindent" >> "$vimrc"
fi

# 默认编辑器 vim
if ! grep -q "export EDITOR" "$envfile"; then
  echo "export EDITOR=vim" >> "$envfile"
  env_modified=1
fi

# 检查时区
echo "检查系统时区..."
current_timezone=$(date +%Z)
# 在时区设置部分
if [ "$current_timezone" != "CST" ]; then
  echo "当前时区不是中国时区，设为中国时区"
  ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
  echo "Asia/Shanghai" | tee /etc/timezone
  # 更改日期显示格式
  echo "alias date='date \"+%Y-%m-%d %H:%M:%S %Z\"'" >> "$envfile"
  env_modified=1
fi

# 在文件最后添加提示
if [ $env_modified -eq 1 ]; then
  echo "\n环境变量已更新，请执行以下命令使其生效："
  echo "source $envfile"
fi
