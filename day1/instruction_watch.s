        .globl main, big, compare
        .intel_syntax noprefix
main:
        mov     rax, rsp
        mov     rbx, 100
        mov     ecx, 0x20
        #mov    QWORD PTR [0x600000], rcx
        #mov    edx, DWORD PTR [0x600000]
        lea     rax, [0x600000]
        lea     rbx, [rax+rcx*8]
        add     rax, 10
        add     rax, rcx
        #add    ecx, DWORD PTR [0x600000]
        sub     rax, 10
        mov     rax, 10
        mov     rbx, 8
        mul     rbx
        div     rbx
        mov     rcx, 7
        and     rbx, rcx
        or      rbx, rcx
        xor     rbx, rcx
        not     rbx
        mov     rbx, 8
        mov     rcx, 7
        push    rbx
        push    rcx
        mov     rdx, QWORD PTR [rsp]
        add     rdx, 40
        mov     DWORD PTR [rsp], edx
        pop     rbx
        pop     rcx
        jmp     compare
big:
        sub     rax, 5
compare:
        cmp     rax, 7
        jge     big
        test    rax, rax
        jnz     big
        ret
