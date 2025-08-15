define gef
python
import os
if os.geteuid() != 0:
    tmpdir = os.path.join(os.environ["HOME"], ".gef-tmp")
    os.makedirs(tmpdir, exist_ok=True)
    os.environ["TMPDIR"] = tmpdir
sys.path.insert(0, os.path.join(os.environ["HOME"], ".gef"))
from gef import *
Gef.main()
end
end

define dbg
    source ~/pwn/Tools/pwndbg/gdbinit.py
end
