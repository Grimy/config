function! subliminal#insert(regex) range
	execute 'silent! keeppatterns keepjumps %s/' . a:regex . "\\zs/\u2038"
	call subliminal#main()
endfunction

" Saves and restores the environment
function! subliminal#main()
	if !search("\u2038", 'w')
		startinsert
		return
	endif
	let save = [&eventignore, &cursorline, &cursorcolumn, &scrolloff, &gdefault]
	try
		set eventignore=all nocursorline nocursorcolumn scrolloff=0 nogdefault
		call s:input_loop()
	catch | finally
		echo
		let [&eventignore, &cursorline, &cursorcolumn, &scrolloff, &gdefault] = save
	endtry
endfunction

nnoremap <Plug>(subliminal_abs) a<BS>
inoremap <silent> <Plug>(subliminal_ok) <C-O>:let s:cursors += 1<CR><C-V>u2038
nnoremap <silent> <Plug>(subliminal_ok) <Nop>

function! s:input_loop()
	let s:cursors = 1
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

command! -range=% SubliminalStart  call subliminal#main()
command! -range=% SubliminalInsert call subliminal#insert('\v(%V@!.|^)%V')
command! -range=% SubliminalAppend call subliminal#insert('\v%V.(%V@!|$)')

nnoremap <C-_> i<C-V>u2038<Esc>
inoremap <C-_>  <C-V>u2038
cnoremap <C-_>  <C-V>u2038
nnoremap <C-LeftMouse> <LeftMouse>i<C-V>u2038<Esc>

nnoremap <silent> i :SubliminalStart<CR>
xnoremap <silent> I    :SubliminalInsert<CR>
xnoremap <silent> A    :SubliminalAppend<CR>
xnoremap <silent> c xgv:SubliminalInsert<CR>

xnoremap <BS>    :SubliminalInsert<CR><BS>
xnoremap <Del>   :SubliminalAppend<CR><Del>
xnoremap <C-U>   :SubliminalInsert<CR><C-U>
xnoremap <C-W>   :SubliminalInsert<CR><C-W>
xnoremap <C-A>   :SubliminalInsert<CR><C-A>
xnoremap <C-X>   :SubliminalInsert<CR><C-X>
xnoremap <C-Del> :SubliminalInsert<CR><C-Del>
xnoremap <C-Y>   :SubliminalInsert<CR><C-Y>
xnoremap <C-Q>   :SubliminalInsert<CR><C-Q>

augroup Subliminal
	autocmd!
	" Remove cursors before saving
	autocmd BufWritePre * execute "silent! keeppatterns %s/\u2038//g"

	" Conceal, don’t feel~
	autocmd FileType * execute "syntax match SubliminalCursor /\u2038\\ze./ conceal containedin=ALL"
	autocmd FileType * execute "syntax match SubliminalCursor /\u2038.\\?/ containedin=ALL"
	highlight! SubliminalCursor cterm=NONE,reverse
augroup END
