    .globl main
    .intel_syntax noprefix
main:
    push    rax
    push    rbx
    movaps  xmm1, qword[rsp]
    movaps  xmm2, qword[rsp+8]
    pop     rbx
    pop     rax
    ret
