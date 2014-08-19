setlocal iskeyword+=:,#
setlocal number
nnoremap <buffer> K :vert help <C-R><C-W><CR>

" Reload vim files after saving them
if expand('%:p:h:t') !~ '\v^(ftplugin|syntax|indent)$'
	autocmd BufWritePost <buffer> source %
endif

" Set syntax of user defined commands
" redir => _
" silent! command
" redir END
" execute 'syntax keyword vimCommand' join(map(split(_, '\n')[1:],
			" \ "matchstr(v:val, '[!\"b]*\\s\\+\\zs\\u\\w*\\ze')"))
