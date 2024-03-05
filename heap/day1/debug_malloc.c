#include <stdlib.h>

int main()
{
    void* p1 = malloc(0x20);
    void* p2 = malloc(0x30);
    free(p1);
    free(p2);
    return 0;
}
