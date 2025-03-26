#!/bin/sh

# 获取CPU数量
get_cpu_count() {
    # 使用nproc命令（如果可用）或者通过/proc/cpuinfo
    if command -v nproc >/dev/null 2>&1; then
        cpu_count=$(nproc)
    else
        cpu_count=$(grep -c '^processor' /proc/cpuinfo)
    fi
    echo "CPU数量: $cpu_count"
}

# 获取内存信息
get_memory_info() {
    # 获取内存信息（单位KB）
    total_mem_kb=$(grep 'MemTotal' /proc/meminfo | awk '{print $2}')
    free_mem_kb=$(grep 'MemAvailable' /proc/meminfo | awk '{print $2}')

    # 转换为MB
    total_mem_mb=$((total_mem_kb / 1024))
    free_mem_mb=$((free_mem_kb / 1024))

    # 输出结果
    echo "总内存: ${total_mem_mb}MB"
    echo "可用内存: ${free_mem_mb}MB"
}

# 获取磁盘信息
get_disk_info() {
    # 使用df命令获取磁盘信息（排除tmpfs等特殊文件系统）
    df_output=$(df -h -x tmpfs -x devtmpfs -x squashfs -x overlay --output=source,size,used 2>/dev/null | tail -n +2)

    echo "磁盘信息:"
    echo "$df_output" | while read -r source size used; do
        echo "设备: $source  总大小: $size  已用: $used"
    done
}

# 主函数
main() {
    echo "系统信息收集:"
    echo "------------------------"
    get_cpu_count
    echo "------------------------"
    get_memory_info
    echo "------------------------"
    get_disk_info
}

main
