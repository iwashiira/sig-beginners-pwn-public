#include <stdlib.h>
#include <string.h>

int main()
{
    void* p1 = malloc(0x20);
    void* p2 = malloc(0x30);
    void* p3 = malloc(0x20);
    strcpy(p1,"Hello World!\n");
    free(p1);
    free(p2);
    free(p3);
    return 0;
}
