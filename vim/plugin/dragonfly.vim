let s:mincol  = 0
let s:maxcol  = 0
let s:minline = 0
let s:maxline = 0

function! dragonfly#init(v, h)
	" Save registers and options so we can restore them later
	let s:save = [ @", &clipboard, &virtualedit, &report ]
	set clipboard=
	set virtualedit=all
	set report=2147483647 " Completely disable reports

	" Reselect the visual selection
	normal! gvygv

	" Merge consecutive movements in the undo history
	if [ line("'<"), line("'>") ] == [  s:minline, s:maxline ]
			\ && ([ virtcol("'<"), virtcol("'>") ] == [ s:mincol, s:maxcol ]
			\ || mode() ==# 'V')
		silent! undojoin
	endif

	let s:indent = mode() ==# 'V' && a:v

	" Expand tabs, but only in the selected block
	call setreg('"', substitute(@", "\t", repeat(' ', &tabstop), 'g'), getregtype())

	let s:minline = line("'<")
	let s:maxline = line("'>")
	let s:mincol  = min([virtcol("'<"), virtcol("'>")])
	let s:maxcol  = s:mincol + stridx(@" . "\n", "\n")
	" Fix off-by-one errors due to inclusive selections
	let s:maxcol -= &selection !~# 'exclusive'

	normal! p
	call s:reselect()

	let s:minline += a:v
	let s:maxline += a:v
	let s:mincol  += a:h
	let s:maxcol  += a:h
	if s:mincol <= 0
		let s:maxcol += 1 - s:mincol
		let s:mincol = 1
	endif
	if s:minline <= 0
		let s:maxline += 1 - s:minline
		let s:minline = 1
	endif
	while s:maxline >= line('$')
	    call append('$', '')
	endwhile
endfunction

" Restore registers and options
function! dragonfly#after()
	call dragonfly#fix_spaces(range(s:minline, s:maxline))
	call s:reselect()
	if s:indent
		normal! =gv
	endif
	let [ @", &clipboard, &virtualedit, &report ] = s:save
endfunction

function! s:reselect()
	execute 'normal!' . s:minline . 'G' . s:mincol . '|' . getregtype()[0]
				\     . s:maxline . 'G' . s:maxcol . '|'
endfunction

function! dragonfly#fix_spaces(lines)
	for lnum in a:lines
		if &expandtab
			let indent  = repeat(' ',  indent(lnum))
		else
			let indent  = repeat("\t", indent(lnum) / &tabstop)
			let indent .= repeat(' ',  indent(lnum) % &tabstop)
		endif
		let line = getline(lnum)
		let line = substitute(line, '^\s*', indent, '')
		let line = substitute(line, '\s*$', '', '')
		if (line !=# getline(lnum))
			call setline(lnum, line)
		endif
	endfor
endfunction

function! dragonfly#move(v, h) range
	call dragonfly#init(a:v, mode() ==# 'V' ? 0 : a:h)

	if mode() ==# 'V' && a:h
		execute 'normal! ' a:h > 0 ? a:h . '>' : -a:h . '<'
	elseif mode() !=# 'v'
		normal! d
		call dragonfly#fix_spaces(range(line("'<"), line("'>")))
		execute 'normal! ' . s:minline . 'G' . s:mincol . '|'
		normal! P
	endif

	call dragonfly#after()
endfunction

function! dragonfly#copy(times) range
	normal! gvyv
	call dragonfly#init(getregtype() ==# 'V' ? line("'>") - line("'<") + 1 : 0,
				\ str2nr(getregtype()[1:]))
	execute 'normal! y' . s:minline . 'G' . s:mincol . '|' . a:times . 'P'
	call dragonfly#after()
endfunction

xnoremap <silent> H :call dragonfly#move(0, -v:count1)<CR>
xnoremap <silent> K :call dragonfly#move(-v:count1, 0)<CR>
xnoremap <silent> J :call dragonfly#move(+v:count1, 0)<CR>
xnoremap <silent> L :call dragonfly#move(0, +v:count1)<CR>
xnoremap <silent> P :call dragonfly#copy(v:count1)<CR>
