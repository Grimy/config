function! Subliminal(range, regex) abort
	let save = [&eventignore, &cursorline, &cursorcolumn, &scrolloff, &gdefault]
	set eventignore=all nocursorline nocursorcolumn scrolloff=0 gdefault
	exec 'keepjumps keeppatterns' a:range . 's/' . a:regex . "\\zs/\u258d"

	while search("\u258d", 'wn')
		redraw
		exec "keepjumps keeppatterns %s/\u258d\\+/\u258c"
		let char = getchar()
		let char = type(char) == 0 ? nr2char(char) : char
		undojoin
		while search("\u258c", 'w')
			exec 'normal cl' . char . "\u258d"
		endwhile
	endwhile

	let [&eventignore, &cursorline, &cursorcolumn, &scrolloff, &gdefault] = save
endfunction

command! -range=% -nargs=1 Subliminal call Subliminal('<line1>,<line2>', <args>)
xnoremap <silent> I :Subliminal '\v(%V@!.<Bar>^)%V'<CR>
xnoremap <silent> A :Subliminal '\v%V.(%V@!<Bar>$)'<CR>
xnoremap <silent> c "_x:Subliminal '\v(%V@!.<Bar>^)%V'<CR>
noremap  <silent> s :Subliminal @/<CR>

xmap <BS>  I<BS>
xmap <Del> I<Del>
xmap <C-U> I<C-U>
xmap <C-W> I<C-W>
xmap <C-Y> I<C-Y>
xmap <C-E> I<C-E>
