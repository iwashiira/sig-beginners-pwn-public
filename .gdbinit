define pwngdb
    source ~/pwn/Tools/peda/peda.py
    source ~/pwn/Tools/Pwngdb/pwngdb.py
    source ~/pwn/Tools/Pwngdb/angelheap/gdbinit.py
    python import angelheap
    python angelheap.init_angelheap()
end
