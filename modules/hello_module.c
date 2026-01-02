#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Student");
MODULE_DESCRIPTION("A simple RISC-V Kernel Module");

static int __init hello_init(void)
{
    unsigned long sstatus;
    asm volatile("csrr %0, sstatus" : "=r"(sstatus));
    
    printk(KERN_INFO "Hello Module: Loaded!\n");
    printk(KERN_INFO "Hello Module: Current sstatus = 0x%lx\n", sstatus);
    return 0;
}

static void __exit hello_exit(void)
{
    printk(KERN_INFO "Hello Module: Unloaded. Goodbye!\n");
}

module_init(hello_init);
module_exit(hello_exit);
