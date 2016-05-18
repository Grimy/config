augroup Subliminal
	autocmd!
	autocmd BufWritePre * execute "silent! keeppatterns %s/\u2038//g"
	autocmd FileType * execute "syntax match SubliminalCursor /\u2038\\ze./ conceal containedin=ALL"
	autocmd FileType * execute "syntax match SubliminalCursor /\u2038.\\?/ containedin=ALL"
augroup END

highlight! SubliminalCursor cterm=NONE,reverse

command! -range=% SubliminalInsert call subliminal#insert('\v(%V@!.|^)%V')
command! -range=% SubliminalAppend call subliminal#insert('\v%V.(%V@!|$)')

nnoremap <Plug>(subliminal_abs) a<BS>
inoremap <silent> <Plug>(subliminal_ok) <C-O>:let s:cursors += 1<CR><C-V>u2038
nnoremap <silent> <Plug>(subliminal_ok) <Nop>

xnoremap I       :SubliminalInsert<CR>
xnoremap A       :SubliminalAppend<CR>
xnoremap c       xgv:SubliminalInsert<CR>
xnoremap <BS>    :SubliminalInsert<CR><BS>
xnoremap <Del>   :SubliminalAppend<CR><Del>
xnoremap <C-U>   :SubliminalInsert<CR><C-U>
xnoremap <C-W>   :SubliminalInsert<CR><C-W>
xnoremap <C-Del> :SubliminalInsert<CR><C-Del>
xnoremap <C-Y>   :SubliminalInsert<CR><C-Y>
xnoremap <C-Q>   :SubliminalInsert<CR><C-Q>

function! subliminal#insert(regex) range
	execute 'silent! keeppatterns keepjumps %s/' . a:regex . "\\zs/\u2038"
	let save = [&eventignore, &cursorline, &cursorcolumn, &scrolloff, &gdefault]
	try
		set eventignore=all nocursorline nocursorcolumn scrolloff=0 nogdefault
		call s:input_loop()
	catch | finally
		echo
		let [&eventignore, &cursorline, &cursorcolumn, &scrolloff, &gdefault] = save
	endtry
endfunction

function! s:input_loop()
	let s:cursors = search("\u2038", 'w')
	call feedkeys("\<C-]>")
	while s:cursors
		redraw
		let char = getchar()
		let char = type(char) == 0 ? nr2char(char) : char
		silent! undojoin
		execute "silent! keeppatterns keepjumps %s/\u2038\\+/\u2039"
		let s:cursors = 0
		while search("\u2039", 'w')
			exec "normal \<Plug>(subliminal_abs)" . char . "\<Plug>(subliminal_ok)"
		endwhile
		echo 'Subliminal:' s:cursors 'cursors'
	endwhile
	silent! normal! `.
endfunction
