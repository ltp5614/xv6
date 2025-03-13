#include "user.h"

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Error\n");
        exit(1);
    }

    int num = atoi(argv[1]);

    hello(num);
    exit(0);
}