#include <unistd.h>
#include <sys/syscall.h>
#include <stdio.h>

#define __NR_riscv_hello 463

int main() {
    printf("User: Calling system call 463...\n");
    // 使用 syscall 函数触发
    long ret = syscall(__NR_riscv_hello, "Student");
    
    if (ret == 0) {
        printf("User: System call returned successfully.\n");
    } else {
        perror("User: System call failed");
    }
    
    return 0;
}
