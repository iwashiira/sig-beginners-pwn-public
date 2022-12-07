#include <stdio.h>

static int sta1, sta2 = 1;
int glo1 = 0, glo2 = 1;
const int glo3 = 1;
char * literal = "Hi";

static void stafunc()
{
	sta1 = 2;
}

void glofunc()
{
	glo1 = 3;
}
