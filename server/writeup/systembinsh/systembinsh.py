from pwn import *

elf = ELF('./systembinsh')

io = remote('localhost', 30000)
io.interactive()
