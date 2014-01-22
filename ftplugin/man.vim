" Remove the ^H characters
silent %!col -bx

" Presentation options
setlocal tabstop=8
setlocal synmaxcol&
setlocal nolist
setlocal nowrap
setlocal nofoldenable nonumber

" The screen moves in sync with the cursor
autocmd BufEnter <buffer> set scrolloff=999 scrolljump=1
autocmd BufLeave <buffer> set scrolloff=20  scrolljump=4
normal! M0

" Don’t save
setlocal buftype=nofile
setlocal bufhidden=hide
setlocal noswapfile
setlocal nomodifiable
