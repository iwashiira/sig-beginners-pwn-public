#include <stdio.h>
#include <stdlib.h>

void call_shell()
{
	system("/bin/sh");
	exit(0);
}

int main()
{
	void **pointer;
	printf("Address is ");
	scanf("%p", &pointer);
	printf("Value is ");
	scanf("%p", pointer);
	puts("Missed GOT overwrite....");
	return 0;
}
