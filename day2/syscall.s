	.globl main
	.intel_syntax noprefix
main:
	mov	r8, 0x0a21646c72
	push	r8
	mov	rbx, 0x6f77206f6c6c6548
	push	rbx
	mov	rax, 1
	mov	rdi, 1
	mov	rsi, rsp
	mov	rdx, 13
	syscall

	mov	rax, 60
	mov	rdi, 0
	syscall
