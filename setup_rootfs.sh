#!/bin/bash
set -e

ROOTFS_IMG="rootfs.img"
MOUNT_POINT="/mnt/rootfs"

# 检查是否为 root
if [ "$EUID" -ne 0 ]; then
  echo "请使用 sudo 运行此脚本"
  exit 1
fi

# 检查 rootfs.img 是否存在
if [ ! -f "$ROOTFS_IMG" ]; then
    echo "错误: $ROOTFS_IMG 不存在"
    exit 1
fi

# 创建挂载点
mkdir -p $MOUNT_POINT

# 挂载
echo "正在挂载 $ROOTFS_IMG 到 $MOUNT_POINT ..."
mount -o loop $ROOTFS_IMG $MOUNT_POINT

# 创建目录结构
echo "正在创建目录结构..."
mkdir -p $MOUNT_POINT/proc
mkdir -p $MOUNT_POINT/sys
mkdir -p $MOUNT_POINT/dev
mkdir -p $MOUNT_POINT/etc/init.d
mkdir -p $MOUNT_POINT/root

# 创建 rcS 脚本
echo "正在创建 /etc/init.d/rcS ..."
cat > $MOUNT_POINT/etc/init.d/rcS <<EOF
#!/bin/sh

# 挂载虚拟文件系统
mount -t proc none /proc
mount -t sysfs none /sys

# 使用 mdev 自动管理设备节点
/sbin/mdev -s

# 打印欢迎信息
echo "--------------------------------------"
echo "   Welcome to RISC-V Linux Lab System "
echo "--------------------------------------"

# 开启 shell
/bin/sh
EOF

chmod +x $MOUNT_POINT/etc/init.d/rcS

# 复制测试程序
if [ -f "syscall_test" ]; then
    echo "正在复制 syscall_test ..."
    cp syscall_test $MOUNT_POINT/bin/
else
    echo "警告: syscall_test 未找到，跳过复制"
fi

# 复制内核模块
if [ -f "modules/hello_module.ko" ]; then
    echo "正在复制 hello_module.ko ..."
    cp modules/hello_module.ko $MOUNT_POINT/root/
else
    echo "警告: modules/hello_module.ko 未找到，跳过复制"
fi

# 卸载
echo "正在卸载..."
umount $MOUNT_POINT

echo "RootFS 更新完成！"
