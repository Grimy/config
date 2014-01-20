" Remove the ^H characters
silent %!col -b

" Presentation options
setlocal tabstop=8
setlocal synmaxcol&
setlocal nolist
setlocal nofoldenable nonumber

" The screen moves in sync with the cursor
setlocal scrolloff=999 scrolljump=1
autocmd CursorMoved <buffer> normal! M$

" Don’t save
setlocal buftype=nofile
setlocal bufhidden=hide
setlocal noswapfile
setlocal nomodifiable
