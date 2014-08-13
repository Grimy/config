setlocal makeprg=go\ build

nnoremap <buffer> <Esc> :<C-U>cclose<CR>
nnoremap <buffer> !r :!go run %<CR>

" autocmd BufWritePre <buffer> normal! ma
" autocmd BufWritePre <buffer> silent %!gofmt 2>/dev/null || cat
" autocmd BufWritePre <buffer> silent! normal! `a

autocmd BufWritePost <buffer> silent make
autocmd BufWritePost <buffer> nested cwindow
autocmd BufWritePost <buffer> redraw!

