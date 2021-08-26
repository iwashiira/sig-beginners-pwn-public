#include <stdio.h>
#include <stdlib.h>

int func1(int x, int y)
{
	char scream[20] = "I am in func1!";
	int t = 10;
	int z = 20;
	t = t + z;
	printf("%s\n", scream);
	return x + y + t;
}

int main()
{
	int a;
	int b = 1;
	int c = 2;
	char finish[20] = "Finished!";
	a = b;
	b = func1(a, c);
	if (b > 20) {
		printf("%d\n", b-1);
	} else {
		printf("%d\n", b);
	}
	printf("%s\n", finish);
	return 0;
}
