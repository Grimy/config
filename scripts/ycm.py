#!/usr/bin/env python

import os
# import ycm_core

FLAGS = [
	'-Wall', '-Wextra', '-Werror',
	'-std=c++03', '-x', 'c++',
	'-I/home/grimy/Core/TesteurSDK/Produits/QT-FC5/include',
	'-I/home/grimy/Core/TesteurSDK/Core/IHMQT',
	'-I/home/grimy/Core/TesteurSDK/Core/NoyauIGC/',
]

# See http://clang.llvm.org/docs/JSONCompilationDatabase.html
# DATABASE = ycm_core.CompilationDatabase('') if os.path.exists('') else None

# def GetCompilationInfoForFile(filename):
# 	extension = os.path.splitext(filename)[1]
# 	if extension in ['.h', '.hxx', '.hpp', '.hh']:
# 		basename = os.path.splitext(filename)[0]
# 		for extension in ['.cpp', '.cxx', '.cc', '.c', '.m', '.mm']:
# 			replacement_file = basename + extension
# 			if os.path.exists(replacement_file):
# 				compilation_info = DATABASE.GetCompilationInfoForFile(
# 					replacement_file)
# 				if compilation_info.compiler_flags_:
# 					return compilation_info
# 		return None
# 	return DATABASE.GetCompilationInfoForFile(filename)

def DirectoryOfThisScript():
	return os.path.dirname(os.path.abspath(__file__))

# This is the entry point; this function is called by ycmd to produce flags for a file.
def FlagsForFile(filename, **kwargs):
	return {
		'flags': FLAGS,  # GetCompilationInfoForFile(filename).compiler_flags_ if DATABASE else FLAGS,
		'do_cache': True,
	}
