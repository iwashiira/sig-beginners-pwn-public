from pwn import *

elf = ELF('./easy_bof')

io = remote('chall.ctf.iwashiira.com', 30001)
#io = process('./easy_bof')

p64(getshell_addr)

io.interactive()
