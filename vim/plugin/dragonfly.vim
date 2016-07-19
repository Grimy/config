let s:lastcall = 0

function! s:before() range abort
	let s:save = [ @", &clipboard, &virtualedit, &report ]
	set clipboard= virtualedit=all report=2147483647
	if b:changedtick == s:lastcall
		silent! undojoin
	endif
	normal! gv
endfunction

function! s:after() range abort
	let [ @", &clipboard, &virtualedit, &report ] = s:save
	let s:lastcall = b:changedtick
	normal! gv
endfunction

xnoremap <silent> H :call <SID>before()<CR>dhP:call <SID>after()<CR>hoho
xnoremap <silent> L :call <SID>before()<CR>dlP:call <SID>after()<CR>lolo
xnoremap <silent> J :call <SID>before()<CR>djP:call <SID>after()<CR>jojo
xnoremap <silent> K :call <SID>before()<CR>dkP:call <SID>after()<CR>koko
xnoremap <silent> P :call <SID>before()<CR>yP:call <SID>after()<CR>
