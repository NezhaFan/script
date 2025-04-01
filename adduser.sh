
#!/bin/sh

# 获取用户名输入
echo -n "请输入要创建的用户名："
read -r username

# 检查并创建用户
if ! getent passwd $username > /dev/null 2>&1; then
  echo "$username 用户不存在，开始创建..."
  echo -n "请输入 $username 用户的密码："
  stty -echo
  read -r password
  stty echo
  echo
  echo -n "请再次输入密码确认："
  stty -echo
  read -r password2
  stty echo
  echo
  
  if [ "$password" != "$password2" ]; then
    echo "两次密码输入不一致，退出..."
    exit 1
  fi
  
  # 创建用户并设置密码
  useradd -m -s /bin/bash $username
  echo "$username:$password" | chpasswd
  
  # 询问是否添加 sudo 权限
  echo "是否将 $username 添加到 sudo 组？(y/n)"
  read -r add_sudo
  if [ "$add_sudo" = "y" ] || [ "$add_sudo" = "Y" ]; then
    usermod -aG sudo $username
    echo "$username 用户创建成功，并已添加到 sudo 组"
  else
    echo "$username 用户创建成功"
  fi
else
  echo "$username 用户已存在，无需创建"
  exit 1
fi