### 有的是 `bash` 脚本，所以最好使用 `bash` 执行脚本

### info.sh
- 功能：输出CPU核心数、总内存、可用内存、磁盘总量、可用磁盘

### curl.sh
- 功能：帮助快速生成curl命令
- 内容
  - 方法：支持 `GET、POST(JSON)、POST(FORM)、PUT、DELETE、HEAD`
  - 地址：支持非`http`开头则自动拼接`http://127.0.0.1`，例如直接输入`:8080/test`，便于本地调试使用
  - 可选的`Authorization`
  - 数据：`body` 里的数据可以手动输入，也支持输入 `xx.json` 文件名，放在文件里。

### ssh.sh
- 功能：自己管理多服务器时，便于按照名称登录。

### ubuntu_init.sh
- 功能：ubuntu初始化脚本
- 内容
  - `apt` 更新
  - 安装常用软件 `vim wget curl telnet lsof tar zip` ，可自己添加
  - 修改中国时区
  - 创建拥有 `sudo` 权限的新用户 `pi`