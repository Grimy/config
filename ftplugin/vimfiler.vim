silent! nunmap <buffer> <Tab>
silent! nunmap <buffer> <C-J>

nmap <buffer> m          <Plug>(vimfiler_clipboard_move_file)
nmap <buffer> c          <Plug>(vimfiler_clipboard_copy_file)
nmap <buffer> p          <Plug>(vimfiler_clipboard_paste)y
nmap <buffer> <nowait> d <Plug>(vimfiler_delete_file)
nmap <buffer> <CR>       <Plug>(vimfiler_execute)
nmap <buffer> <Left>     <Plug>(vimfiler_smart_h)
nmap <buffer> <Right>    <Plug>(vimfiler_smart_l)

