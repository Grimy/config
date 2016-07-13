#!/usr/bin/python2
"""
let $EDITOR = expand('<sfile>:p')
augroup Ranger
	autocmd!
	autocmd BufEnter * if isdirectory(expand('<afile>')) | call termopen('ranger ' . expand('<afile>')) | setf term | endif
augroup END
finish
"""

import sys
import os
from neovim import socket_session, Nvim

nvim = Nvim.from_session(socket_session(os.environ['NVIM_LISTEN_ADDRESS']))
nvim.command('edit ' + sys.argv[2])
nvim.command(sys.argv[1][1:])
