### 自定义命令
> 建议 export PATH="/xxx/script:$PATH" 
- xcurl
  - 系统：mac、linux
  - 功能：帮助快速生成curl命令
  - 内容
    - 方法：支持 `GET、POST(JSON)、POST(FORM)、PUT、DELETE、HEAD`
    - 地址：支持非`http`开头则自动拼接`http://127.0.0.1`，例如直接输入`:8080/test`，便于本地调试使用
    - 可选的`Authorization`
    - 数据：`body` 里的数据可以手动输入，也支持输入 `xx.json` 文件

- xinfo
  - 系统：linux
  - 功能：输出CPU核心数、总内存、可用内存、磁盘总量、可用磁盘



### 一次性脚本：在 `once`目录下

### init.sh
- 功能：初始化脚本。 包管理工具更新，安装常用软件 `vim wget curl telnet lsof tar zip` (可自己添加)，修改中国时区，

### adduser.sh
- 功能：添加用户

### cleanfile.sh
- 功能：增加每日一次的定时任务：定时清理指定文件夹下 超过参数天无修改 且 大小超过参数MB的文件。



### ssh.sh
- 功能：自己管理多服务器时，便于按照名称登录。

### trash.sh
- 功能：创建回收站 `~/.trash`；把 `rm` 命令替换成 `mv` 移到回收站。
