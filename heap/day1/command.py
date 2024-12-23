import gdb

gdb.execute('gef')
gdb.execute('set substitute-path . ../../glibc/glibc-2.35')
gdb.execute('b debug_bins.c:24')
#gdb.execute('set verbose on')
gdb.execute('r')
