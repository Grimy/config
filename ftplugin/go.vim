setlocal makeprg=go\ build

nnoremap <buffer> <Esc> :<C-U>cclose<CR>
nnoremap <buffer> !r :!go run %<CR>

autocmd BufWritePost <buffer> silent make
autocmd BufWritePost <buffer> nested cwindow
autocmd BufWritePost <buffer> redraw!
