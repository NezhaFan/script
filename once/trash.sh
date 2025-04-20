#!/bin/sh

# 增加垃圾箱，把 rm 改为 mv 进垃圾桶

envfile="$HOME/.profile"
# 环境变量目录
if [ ! -d "$envfile" ]; then
  touch "$envfile"
fi

# 定义垃圾桶目录
trash="$HOME/.trash"

# 创建垃圾桶目录（如果不存在）
if [ ! -d "$trash" ]; then
  echo "建立垃圾桶 $trash"
  mkdir -p "$trash"
fi

# 检查是否已有 rm 别名，如果没有则添加
if ! grep -q "alias rm=" "$envfile"; then
  echo "把 rm 改为移入垃圾桶"
  echo "trash() {
  str1=\$@ ;
  str2=\${str1##-* } ;
  mv \$str2 \"$trash\" ;
}" >> "$envfile"
  echo "alias rmrm=/usr/bin/rm" >> "$envfile"
  echo "alias rm=trash" >> "$envfile"
  echo "请手动重加载: source $envfile"
fi