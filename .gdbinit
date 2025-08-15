define gef
    python import os
    python sys.path.insert(0, os.path.join(os.environ["HOME"], ".gef")); from gef import *; Gef.main()
end

define dbg
    source ~/pwn/Tools/pwndbg/gdbinit.py
end
