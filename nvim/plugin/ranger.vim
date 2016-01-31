"""
let $EDITOR = 'python2 ' . expand('<sfile>:p')
augroup Ranger
	autocmd!
	autocmd BufEnter * if isdirectory(expand('<afile>')) | call termopen('ranger ' . expand('<afile>')) | endif
augroup END
finish
"""

import sys
import os
from neovim import socket_session, Nvim

Nvim.from_session(socket_session(os.environ['NVIM_LISTEN_ADDRESS'])).command('edit ' + sys.argv[-1])
