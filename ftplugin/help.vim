nnoremap <buffer> K :vert help <C-R><C-W><CR>
setlocal iskeyword+=:,#
autocmd BufEnter <buffer> set scrolloff=999 scrolljump=1
autocmd BufLeave <buffer> set scrolloff=20  scrolljump=4
