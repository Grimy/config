setlocal iskeyword+=:,#
setlocal number
nnoremap <buffer> K :vert help <C-R><C-W><CR>

" Reload vim files after saving them
if expand('%:p:h:t') !~ '\v^(ftplugin|syntax|indent)$'
	autocmd BufWritePost <buffer> source %
endif
