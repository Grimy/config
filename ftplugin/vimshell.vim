call vimshell#hook#add('chpwd', 'cdls', 'g:cdls')
silent! nunmap <buffer> <C-K>
nmap <buffer> a <Plug>(vimshell_append_end)
imap <buffer> <C-L> <Plug>(vimshell_clear)
imap <buffer> <C-J> <Plug>(vimshell_history_unite)
imap <buffer> <Home> <Plug>(vimshell_move_head)
imap <buffer> <C-K> <Esc><C-P>a
imap <buffer> <Up> <Esc><C-P>
nmap <buffer> <Up> <C-P>
nmap <buffer> <Down> <C-N>

" Vim shell hooks
function! g:cdls(args, context)
	call vimshell#execute('ls')
	execute 'Tcd' getcwd()
endfunction
