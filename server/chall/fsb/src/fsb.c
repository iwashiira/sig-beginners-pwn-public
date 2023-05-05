#include <stdio.h>

void func()
{
    char buf[0x20];
    puts("> ");
    scanf("%31s", buf);
    printf(buf);
    return;
}

int main()
{
    char buf[0x20];
    puts("> ");
    scanf("%31s", buf);
    printf(buf);
    func();
    return 0;
}
