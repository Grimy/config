#!/usr/bin/env python

import subprocess
# '-I/home/grimy/Core/TesteurSDK/Produits/QT-FC5/include',
# '-I/home/grimy/Core/TesteurSDK/Core/IHMQT',
# '-I/home/grimy/Core/TesteurSDK/Core/NoyauIGC/',

def FlagsForFile(filename, **kwargs):
	do_cache = False
	flags = ['-Weverything', '-Wno-newline-eof']
	flags += {
		'c': ['-std=c99', '-xc'],
		'cpp': ['-xc++',  '-std=c++11', '-stdlib=libc++']
	}[filename.rsplit('.', 1)[1]]
	flags += subprocess.Popen(
		'grep CFLAGS $(git rev-parse --show-toplevel) | grep CFLAGS Makefile | cut -d= -f2 | head -n1',
		shell=True,
		stdout=subprocess.PIPE).communicate()[0].split(' ')
	return locals()
