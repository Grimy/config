setlocal iskeyword+=:,#
setlocal number
nnoremap <buffer> K :vert help <C-R><C-W><CR>

" Reload vim files after saving them
if expand('%:p:h:t') !~ '\v^(ftplugin|syntax|indent)$'
	autocmd BufWritePost <buffer> source %
endif

function! s:abbr(lhs, rhs)
	return a:lhs . ' ' . a:lhs . '<End><CR>' . a:rhs . '<Up><End>'
endfunction

command! -nargs=+ Abbr execute 'inoreabbrev <buffer>' s:abbr(<f-args>)
Abbr if endif
Abbr function endfunction
Abbr for endfor
