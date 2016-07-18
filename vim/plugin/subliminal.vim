nnoremap <Plug>(subliminal_abs) a<BS>
inoremap <silent> <Plug>(subliminal_ok) <C-O>:let s:cursors += 1<CR><C-V>u2588
nnoremap <silent> <Plug>(subliminal_ok) <Nop>

" command! -range=% -nargs=1 Substitute execute 'silent! keeppatterns keepjumps'
command! -range=% -nargs=1 Subliminal <line1>,<line2>call subliminal#insert(<args>)
command! -range=% SubliminalInsert <line1>,<line2>call subliminal#insert('\v(%V@!.|^)%V')
command! -range=% SubliminalAppend <line1>,<line2>call subliminal#insert('\v%V.(%V@!|$)')

noremap  s     :Subliminal @/<CR>
xnoremap I     :SubliminalInsert<CR>
xnoremap A     :SubliminalAppend<CR>
xnoremap c     xgv:SubliminalInsert<CR>
xnoremap <BS>  :SubliminalInsert<CR><BS>
xnoremap <Del> :SubliminalAppend<CR><Del>
xnoremap <C-U> :SubliminalInsert<CR><C-U>
xnoremap <C-W> :SubliminalInsert<CR><C-W>
xnoremap <C-Y> :SubliminalInsert<CR><C-Y>
xnoremap <C-Q> :SubliminalInsert<CR><C-Q>

function! subliminal#insert(regex) range
	execute 'silent! keeppatterns keepjumps' a:firstline.','.a:lastline . 's/' . a:regex . "\\zs/\u2588"
	let save = [&eventignore, &cursorline, &cursorcolumn, &scrolloff, &gdefault]
	try
		set eventignore=all nocursorline nocursorcolumn scrolloff=0 nogdefault
		call s:input_loop()
	catch | finally
		echo
		let [&eventignore, &cursorline, &cursorcolumn, &scrolloff, &gdefault] = save
		execute "silent! keeppatterns keepjumps %s/\u2588//g"
	endtry
endfunction

function! s:input_loop()
	let s:cursors = search("\u2588", 'w')
	while s:cursors
		redraw
		let char = getchar()
		let char = type(char) == 0 ? nr2char(char) : char
		silent! undojoin
		execute "silent! keeppatterns keepjumps %s/\u2588\\+/\u2039"
		let s:cursors = 0
		while search("\u2039", 'w')
			exec "normal \<Plug>(subliminal_abs)" . char . "\<Plug>(subliminal_ok)"
		endwhile
		echo 'Subliminal:' s:cursors 'cursors'
	endwhile
	silent! normal! `.
endfunction
