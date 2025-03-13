#include "kernel/sysinfo.h"
#include "kernel/types.h"
#include "user.h"

int main() {
    struct sysinfo info;

    if (sysinfo(&info) < 0) {
        printf("Sysinfo failed\n");
        exit(1);
    }

    printf("Free memory: %ld bytes\n", info.freemem);
    printf("Number of processes: %ld\n", info.nproc);
    printf("Number of open files: %ld\n", info.nopenfiles);

    exit(0);
}
