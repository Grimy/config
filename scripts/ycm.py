#!/usr/bin/env python

import os
# import ycm_core

FLAGS = [
	'-Wall', '-Wextra', '-Werror',
	'-std=c99', '-x', 'c',
	'-lm',
	'-I/home/grimy/Core/TesteurSDK/Produits/QT-FC5/include',
	'-I/home/grimy/Core/TesteurSDK/Core/IHMQT',
	'-I/home/grimy/Core/TesteurSDK/Core/NoyauIGC/',
]

def DirectoryOfThisScript():
	return os.path.dirname(os.path.abspath(__file__))

# This is the entry point; this function is called by ycmd to produce flags for a file.
def FlagsForFile(filename, **kwargs):
	return {
		'flags': FLAGS,  # GetCompilationInfoForFile(filename).compiler_flags_ if DATABASE else FLAGS,
		'do_cache': True,
	}
