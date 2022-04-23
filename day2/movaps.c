#include <stdio.h>
#include <stdlib.h>

int main(){
    system("/bin/ls\x00");
    asm(".intel_syntax noprefix;sub rsp, 8;.att_syntax");
    system("/bin/ls\x00");
    return 0;
}
