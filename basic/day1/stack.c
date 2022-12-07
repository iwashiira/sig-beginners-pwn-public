#include <stdio.h>
#include <stdlib.h>

int sum(int a, int b, int c, int d, int e, int f, int g, int h, int i, int j)
{
	int s = 0;
	printf("%d\n", s);
	s = a + b + c + d + e + f + g + h + i + j;
	return s;
}

int main()
{
	int ans;
	ans = sum(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
	printf("%d\n", ans);
	return 0;
}
