#!/usr/bin/env python

import subprocess
# '-I/home/grimy/Core/TesteurSDK/Produits/QT-FC5/include',
# '-I/home/grimy/Core/TesteurSDK/Core/IHMQT',
# '-I/home/grimy/Core/TesteurSDK/Core/NoyauIGC/',

def FlagsForFile(filename, **kwargs):
	do_cache = True
	flags = ['-Weverything', '-Wno-unused-macros', '-Wno-newline-eof']
	flags += ['-xc', '-std=c99'] if filename.rsplit('.', 1)[1] == 'c' \
		else ['-xc++',  '-std=c++11']
	flags += subprocess.Popen(
		'grep CFLAGS $(git rev-parse --show-toplevel) | grep CFLAGS Makefile | cut -d= -f2 | head -n1',
		shell=True,
		stdout=subprocess.PIPE).communicate()[0].split()
	return locals()
