let s:lastcall = 0

function! Dragonfly(char, line) range abort
	let save = [ @", &clipboard, &virtualedit, &report ]
	set clipboard= virtualedit=all report=2147483647
	if b:changedtick == s:lastcall
		silent! undojoin
	endif

	normal! gv
	let keys = mode() ==# 'V' ? a:line : a:char
	if keys[1] ==# 'k' && line("'<") == 1
	elseif keys[1] ==# 'h' && col("'<") == 1
	else
		silent! call feedkeys(keys, 'xn')
	endif

	let [ @", &clipboard, &virtualedit, &report ] = save
	let s:lastcall = b:changedtick
endfunction

xnoremap <silent> H :call Dragonfly('dhPgvhoho', '<gv')<CR>
xnoremap <silent> J :call Dragonfly('djPgvjojo', ":m'>+\ngv=gv")<CR>
xnoremap <silent> K :call Dragonfly('dkPgvkoko', ":m'<--\ngv=gv")<CR>
xnoremap <silent> L :call Dragonfly('dlPgvlolo', '>gv')<CR>
xnoremap <silent> P :call Dragonfly('yPgv', 'yPgv')<CR>
