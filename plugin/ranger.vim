"""
let $EDITOR = 'python ' . expand('<sfile>:p')
function! s:ranger(dir) abort
	if isdirectory(a:dir)
		call termopen('ranger ' . a:dir)
	endif
endfunction

augroup Ranger
	autocmd!
	autocmd BufEnter,BufNewFile * call s:ranger(expand('<afile>'))
augroup END
finish
"""

import sys
import os
from neovim import socket_session, Nvim

NVIM = Nvim.from_session(socket_session(os.environ['NVIM_LISTEN_ADDRESS']))
NVIM.command('edit ' + sys.argv[1])
