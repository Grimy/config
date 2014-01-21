silent! iunmap <buffer> <C-E>

inoremap <buffer> <silent> <Tab> <Esc><C-W>w
imap <buffer> <silent> <Esc> <C-\><C-N><Plug>(unite_all_exit)
imap <buffer> <silent> <C-J> <Plug>(unite_select_next_line)
imap <buffer> <silent> <C-K> <Plug>(unite_select_previous_line)

autocmd BufEnter <buffer> startinsert!
