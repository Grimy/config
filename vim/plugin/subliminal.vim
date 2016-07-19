let s:keepall = 'silent! keeppatterns keepjumps'
nnoremap <Plug>(subliminal_abs) a<BS>
inoremap <silent> <Plug>(subliminal_ok) <C-O>:let s:cursors += 1<CR><C-V>u2588
nnoremap <silent> <Plug>(subliminal_ok) <Nop>

function! s:input_loop()
	let s:cursors = search("\u2588", 'w')
	while s:cursors
		redraw
		let char = getchar()
		let char = type(char) == 0 ? nr2char(char) : char
		silent! undojoin
		execute s:keepall "%s/\u2588\\+/\u258c"
		let s:cursors = 0
		while search("\u258c", 'w')
			exec "normal \<Plug>(subliminal_abs)" . char . "\<Plug>(subliminal_ok)"
		endwhile
		echo 'Subliminal:' s:cursors 'cursors'
	endwhile
endfunction

function! Subliminal(regex) range
	execute s:keepall a:firstline.','.a:lastline . 's/' . a:regex . "\\zs/\u2588"
	let save = [&eventignore, &cursorline, &cursorcolumn, &scrolloff, &gdefault]
	try
		set eventignore=all nocursorline nocursorcolumn scrolloff=0 gdefault
		call s:input_loop()
	catch | finally
		echo
		let [&eventignore, &cursorline, &cursorcolumn, &scrolloff, &gdefault] = save
		execute s:keepall "%s/\u2588//g"
	endtry
endfunction

command! -range=% -nargs=1 Subliminal <line1>,<line2>call Subliminal(<args>)
noremap  <silent> s :Subliminal @/<CR>
xnoremap <silent> I :Subliminal '\v(%V@!.<Bar>^)%V'<CR>
xnoremap <silent> A :Subliminal '\v%V.(%V@!<Bar>$)'<CR>
xnoremap <silent> c "_xgv:Subliminal '\v(%V@!.<Bar>^)%V'<CR>
xmap <BS>  I<BS>
xmap <C-U> I<C-U>
xmap <C-W> I<C-W>
