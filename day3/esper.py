from pwn import *

elf = ELF('./esper')
io = process('./esper')
