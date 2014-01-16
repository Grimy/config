silent! nunmap <buffer> <Tab>
silent! nunmap <buffer> <C-J>
nmap <buffer> m          <Plug>(vimfiler_clipboard_move_file)
nmap <buffer> c          <Plug>(vimfiler_clipboard_copy_file)
nmap <buffer> p          <Plug>(vimfiler_clipboard_paste)y
nmap <buffer> <nowait> d <Plug>(vimfiler_delete_file)
nmap <buffer> <CR>       <Plug>(vimfiler_double_click)
nmap <buffer> x          <Plug>(vimfiler_execute)
