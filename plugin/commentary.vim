function! s:go(...) abort
	let lnum1 = a:0 > 1 ? a:1 : line("'[")
	let lnum2 = a:0 > 1 ? a:2 : line("']")
	let [l, r] = split(&commentstring, '\s*%s\s*', 1)
	let pattern = '\v^%((\s*)' . l . '\s*(.{-})\s*' . r . '\s*\n)'
	let uncomment = 2
	for lnum in range(lnum1, lnum2)
		let line = matchstr(getline(lnum), '\S.*\s\@<!')
		if line !=# '' && line !~# pattern
			let uncomment = 0
			break
		endif
	endfor
	for lnum in range(lnum1, lnum2)
		let line = getline(lnum)
		if strlen(r) > 2 && l.r !~# '\\'
			let line = substitute(line,
						\'\M'.r[0:-2].'\zs\d\*\ze'.r[-1:-1].'\|'.l[0].'\zs\d\*\ze'.l[1:-1],
						\'\=substitute(submatch(0)+1-uncomment,"^0$\\|^-\\d*$","","")', 'g')
		endif
		let line = substitute(line, uncomment ? pattern : '\S\@=', uncomment ? '\1' : l . ' ', '')
		call setline(lnum, line)
	endfor
endfunction

function! s:textobject() abort
	let [l, r] = split(&commentstring, '\s*%s\s*', 1)
	let pattern = '\v^%((\s*)' . l . '\s*(.{-})\s*' . r . '\s*\n)'
	if search(pattern . pattern . '@!', 'We') == 0 | return | endif
	normal! V
	call search(pattern . '@<!', 'Wb')
endfunction

xnoremap <silent> <C-C> :<C-U>call <SID>go(line("'<"), line("'>"))<CR>
onoremap <silent> <C-C> lj
nnoremap <silent> <C-C> :<C-U>set opfunc=<SID>go<CR>g@
inoremap <silent> <C-C> <C-O>:<C-U>call <SID>go(line("."), line("."))<CR><Down>
onoremap <silent> q :<C-U>call <SID>textobject()<CR>
