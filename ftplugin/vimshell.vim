" Normal mode mappings
silent! nunmap <buffer> <C-K>
nmap <buffer> a <Plug>(vimshell_append_end)
nmap <buffer> <Up> <C-P>
nmap <buffer> <Down> <C-N>

" Insert mode mappings
imap <buffer> <C-L> <Plug>(vimshell_clear)
imap <buffer> <C-J> <Plug>(vimshell_history_unite)
imap <buffer> <Home> <Plug>(vimshell_move_head)
imap <buffer> <C-K> <Esc><C-P>a
imap <buffer> <Up> <Esc><C-P>

" Hooks
call vimshell#hook#add('chpwd', 'cdls', 'b:cdls')
call vimshell#hook#add('preexec', 'man', 'b:vimman')

function! b:cdls(args, context)
	call vimshell#execute('ls')
	execute 'Tcd' getcwd()
endfunction

function! b:vimman(command, context)
	if a:command[:3] ==# 'man '
		stopinsert
		tabnew
		" execute 'Man' a:command[4:]
		" wincmd o
		silent execute 'read !man ' . a:command[4:]
		1 delete
		setlocal filetype=man
		return 'echo 42'
	endif
	return a:command
endfunction
