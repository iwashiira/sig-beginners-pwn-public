#include <stdio.h>
#include <stdlib.h>
void getshell()
{
	system("/bin/sh");
	exit(0);
}

int main()
{
	char buf[30];
	scanf("%s", buf);
	puts(buf);
	return 0;
}
