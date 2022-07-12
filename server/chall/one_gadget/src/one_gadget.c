#include <stdio.h>
#include <stdlib.h>

int main(){

    void **pointer;
    printf("System Address is %p\n", system);
    printf("Stack Address is %p\n", &pointer);
    puts("Address is >");
    scanf("%p", &pointer);
    puts("Value is >");
    scanf("%p", pointer);
    return 0;
}
