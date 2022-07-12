#include <stdio.h>
#include <stdlib.h>

int main()
{
	char buf[30];
	printf("System() Address is %p\n", system);
	puts("> ");
	scanf("%s", buf);
	puts(buf);
	return 0;
}
