#include <stdio.h>

void func()
{
    char buf[0x20];
    printf("> ");
    scanf("%31s", buf);
    printf(buf);
    return;
}

int main()
{
    char buf[0x20];
    setvbuf(stdout, (char*) NULL, _IONBF, 0);
    printf("> ");
    scanf("%31s", buf);
    printf(buf);
    func();
    return 0;
}
