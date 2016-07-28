function! s:match_pair()
	" Get the character under the cursor and check if it's in 'matchpairs'.
	let c = getline('.')[col('.') - 1]
	let i = stridx(&matchpairs, c)
	if and(i, 1) || c ==# ''
		3match none
		return
	endif

	" Figure out the arguments for searchpairpos().
	let flags = and(i, 2) ? 'bnW' : 'nW'
	let stopline = and(i, 2) ? line('w0') : line('w$')
	let start = '\V' . &matchpairs[and(i, 253)]
	let end = '\V' . &matchpairs[or(i, 2)]
	let skip = 'synIDattr(synID(line("."), col("."), 0), "name") =~? "\\vstring|character|comment"'
	execute 'if' skip '| let skip = 0 | endif'

	let [lnum, col] = searchpairpos(start, '', end, flags, skip, stopline)
	execute '3match MatchParen /\v%(%' . lnum . 'l%' . col . 'c)/'
endfunction

function! s:do_r()
	let old = getline('.')[col('.') - 1]
	let new = nr2char(getchar())
	let i = xor(stridx(&matchpairs, new), 2)
	let match = i >= 0 && and(i - stridx(&matchpairs, old), 3) == 2
	return match ? '%%r' . new . '``r' . &matchpairs[i] . '%' : 'r' . new
endfunction

augroup MatchParen
	autocmd!
	autocmd CursorMoved,TextChanged * call s:match_pair()
	autocmd InsertEnter * 3match none
augroup END

nnoremap <expr> r <SID>do_r()
