silent! iunmap <buffer> <C-E>

inoremap <buffer> <silent> <Tab> <Esc><C-W>w
inoremap <buffer> <silent> <Esc> <Esc>:bwipeout<CR>
imap <buffer> <silent> <C-J> <Plug>(unite_select_next_line)
imap <buffer> <silent> <C-K> <Plug>(unite_select_previous_line)

autocmd BufEnter <buffer> startinsert!
