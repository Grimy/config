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
		" Remove the command from vimshell
		normal dd
		if winheight('.') > 50
			vnew
		else
			tabnew
		endif
		let $MANWIDTH = winwidth('.') + 2
		silent execute '.!man ' . a:command[4:]
		setlocal filetype=man
		return 'echo'
	endif
	return a:command
endfunction
