#include <stdio.h>
#include <stdlib.h>

int main(){

    void **pointer;
    setvbuf(stdout, (char*) NULL, _IONBF, 0);
    printf("System Address is %p\n", system);
    printf("Stack Address is %p\n", &pointer);
    printf("Address is > ");
    scanf("%p", &pointer);
    printf("Value is > ");
    scanf("%p", pointer);
    return 0;
}
