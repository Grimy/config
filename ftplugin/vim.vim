setlocal iskeyword+=:,#
setlocal number
nnoremap <buffer> K :vert help <C-R><C-W><CR>

" Always reload vim files after writing them
autocmd BufWritePost <buffer> source %

" Set syntax of user defined commands
redir => _
silent! command
redir END
execute 'syntax keyword vimCommand' join(map(split(_, '\n')[1:],
			\ "matchstr(v:val, '[!\"b]*\\s\\+\\zs\\u\\w*\\ze')"))
