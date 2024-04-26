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
	setvbuf(stdout, (char*) NULL, _IONBF, 0);
	printf("Address is > ");
	scanf("%p", &pointer);
	printf("Value is > ");
	scanf("%p", pointer);
	puts("Missed GOT overwrite....");
	return 0;
}
