function! Subliminal(regex) range
	let save = [&eventignore, &cursorline, &cursorcolumn, &scrolloff, &gdefault]
	set eventignore=all nocursorline nocursorcolumn scrolloff=0 gdefault
	let keep = 'keeppatterns keepjumps'
	exec keep a:firstline.','.a:lastline . 's/' . a:regex . "\\zs/\u2588"

	try | while 1
		redraw
		exec keep "%s/\u2588/\u258c"
		let char = getchar()
		let char = type(char) == 0 ? nr2char(char) : char
		silent! undojoin
		while search("\u258c", 'w')
			call feedkeys('cl' . char . "\u2588", 'x')
		endwhile
	endwhile | catch
		silent! exec keep "%s/\u258c"
		let [&eventignore, &cursorline, &cursorcolumn, &scrolloff, &gdefault] = save
		redraw
	endtry
endfunction

command! -range=% -nargs=1 Subliminal <line1>,<line2>call Subliminal(<args>)
noremap  <silent> s :noh<Bar>Subliminal @/<CR>
xnoremap <silent> I :Subliminal '\v(%V@!.<Bar>^)%V'<CR>
xnoremap <silent> A :Subliminal '\v%V.(%V@!<Bar>$)'<CR>
xnoremap <silent> c "_xgv:Subliminal '\v(%V@!.<Bar>^)%V'<CR>
xmap <BS>  I<BS>
xmap <C-U> I<C-U>
xmap <C-W> I<C-W>
