#!/usr/bin/env python

# '-I/home/grimy/Core/TesteurSDK/Produits/QT-FC5/include',
# '-I/home/grimy/Core/TesteurSDK/Core/IHMQT',
# '-I/home/grimy/Core/TesteurSDK/Core/NoyauIGC/',

def FlagsForFile(filename, **kwargs):
	do_cache = True
	flags = ['-Weverything', '-Wno-gnu', '-Wno-unused-macros']
	flags += {
		'c': ['-std=c99', '-xc'],
		'cpp': ['-xc++',  '-std=c++11', '-stdlib=libc++']
	}[filename.rsplit('.', 1)[1]]
	# flags += ['-I' + dir for dir in
	return locals()
