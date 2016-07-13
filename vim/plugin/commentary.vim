function! s:escape(str) abort
	return '\V' . substitute(a:str, ' ', ' \\?', 'g') . '\v'
endfunction

function! s:go(...) abort
	let lnum1 = line(a:0 > 1 ? a:1 : "'[")
	let lnum2 = line(a:0 > 1 ? a:2 : "']")
	let [l, r] = split(&commentstring, '%s', 1)
	let pattern = '\v^%((\s*)' . s:escape(l) . '(.{-})' . s:escape(r) . ')'
	let uncomment = 1
	for lnum in range(lnum1, lnum2)
		let line = getline(lnum)
		if line !=# '' && line !~# pattern
			let uncomment = 0
			break
		endif
	endfor
	for lnum in range(lnum1, lnum2)
		let line = getline(lnum)
		if uncomment
			let line = substitute(line, pattern, '\1\2', '')
		else
			let line = substitute(line, '\v\S.*', l . '\0' . r, '')
		endif
		call setline(lnum, line)
	endfor
endfunction

function! s:textobject() abort
	let [l, r] = split(&commentstring, '%s', 1)
	let pattern = '\v^%((\s*)' . s:escape(l) . '(.{-})' . s:escape(r) . ')'
	if search(pattern . pattern . '@!', 'We')
		normal! V
		call search(pattern . '@<!', 'Wb')
	endif
endfunction

xnoremap <silent> <C-C> :<C-U>call <SID>go("'<", "'>")<CR>
onoremap <silent> <C-C> lj
nnoremap <silent> <C-C> :<C-U>set opfunc=<SID>go<CR>g@
inoremap <silent> <C-C> <C-O>:<C-U>call <SID>go(".", ".")<CR><Down>
onoremap <silent> q :<C-U>call <SID>textobject()<CR>
