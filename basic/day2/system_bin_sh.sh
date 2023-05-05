#!/bin/bash
gcc -o system_bin_sh ./system_bin_sh.c
gcc -c ./system_bin_sh.c
gcc -S -masm=intel ./system_bin_sh.c
