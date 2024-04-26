#include <stdio.h>
#include <stdlib.h>

int main()
{
	char buf[30];
	setvbuf(stdout, (char*) NULL, _IONBF, 0);
	printf("System() Address is %p\n", system);
	printf("> ");
	scanf("%s", buf);
	puts(buf);
	return 0;
}
