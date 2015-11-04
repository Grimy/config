function! s:match_pair()
	" Get the character under the cursor and check if it's in 'matchpairs'.
	let c = getline(line('.'))[col('.') - 1]
	let i = stridx(&matchpairs, c)

	if and(i, 1) || c ==# ''
		" c isn’t in 'matchpairs': abort
		return [0, 0]
	endif

	" Figure out the arguments for searchpairpos().
	let s_flags = and(i, 2) ? 'bnW' : 'nW'
	let c = '\M' . &matchpairs[and(i, 253)]
	let c2 = '\M' . &matchpairs[or(i, 2)]
	let cx = &matchpairs[xor(i, 2)]

	" When not in a string or comment ignore matches inside them.
	let s_skip ='synIDattr(synID(line("."), col("."), 0), "name") =~? "\\vstring|character|comment"'
	execute 'if' s_skip '| let s_skip = 0 | endif'

	" Limit the search to lines visible in the window.
	let stopline = and(i, 2) ? line('w0') : line('w$')
	return searchpairpos(c, '', c2, s_flags, s_skip, stopline)
endfunction

function! s:do_r()
	let c = nr2char(getchar())
	let i = xor(stridx(&matchpairs, c), 2)
	if and(i, 1) == 0
		call setline(w:lnum, substitute(getline(w:lnum), '\v%' . w:col . 'c.', &matchpairs[i], ''))
	endif
	execute 'normal! r' . c
endfunction

augroup MatchParen
	autocmd!
	autocmd CursorMoved,TextChanged * let [w:lnum, w:col] = s:match_pair()
	autocmd CursorMoved,TextChanged * exe '3match MatchParen /\v%(%' . w:lnum . 'l%' . w:col . 'c)/'
	autocmd InsertEnter * 3match none
augroup END

nnoremap r :<C-U>call <SID>do_r()<CR>
