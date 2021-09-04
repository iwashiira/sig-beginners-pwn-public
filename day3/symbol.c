#include <stdio.h>

static int sta1, sta2 = 1;
int glo1, glo2 = 1;
const int glo3 = 1;
extern int ext3;
char * literal = "Hi";

void extfunc();

static void stafunc()
{
	sta1 = 2;
}

void glofunc()
{
	glo1 = 3;
	ext3 = 4;
}
