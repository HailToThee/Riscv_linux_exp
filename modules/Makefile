obj-m += hello_module.o

# 指向你的内核源码目录
KDIR := /home/hlt/Riscv_linux_exp/linux

all:
	make -C $(KDIR) M=$(PWD) ARCH=riscv CROSS_COMPILE=riscv64-unknown-linux-gnu- modules

clean:
	make -C $(KDIR) M=$(PWD) ARCH=riscv CROSS_COMPILE=riscv64-unknown-linux-gnu- clean
