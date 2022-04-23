        .globl main, big, compare
        .intel_syntax noprefix
main:
        mov     rax, 0xffffffffffffffff
        mov     al, 0xa
        mov     rax, 0xffffffffffffffff
        mov     ah, 0xb
        mov     rax, 0xffffffffffffffff
        mov     ax, 0xc
        mov     rax, 0xffffffffffffffff
        mov     eax, 0xd
        ret
