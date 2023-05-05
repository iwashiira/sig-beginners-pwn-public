#!/bin/bash

# No RELRO
gcc -o got_no got.c -Wl,-z,norelro,-z,now
# No RELRO Lazy Binding
gcc -o got_no_lazy got.c -Wl,-z,norelro,-z,lazy

# Partial RELRO
gcc -o got_partial got.c -Wl,-z,relro,-z,lazy
# Full RELRO
gcc -o got_full got.c -Wl,-z,relro,-z,now
