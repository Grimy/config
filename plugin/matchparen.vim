augroup matchparen
	autocmd!
	autocmd CursorMoved,TextChanged * call s:Highlight_Matching_Pair()
	autocmd InsertEnter * 3match none
augroup END

function! s:Highlight_Matching_Pair()
	" Remove any previous match.
	if exists('w:paren_hl_on') && w:paren_hl_on
		3match none
		let w:paren_hl_on = 0
	endif

	" Avoid that we remove the popup menu.
	" Return when there are no colors (looks like the cursor jumps).
	if pumvisible() || (&t_Co < 8 && !has("gui_running"))
		return
	endif

	" Get the character under the cursor and check if it's in 'matchpairs'.
	let c_lnum = line('.')
	let c_col = col('.')

	let c = getline(c_lnum)[c_col - 1]
	let plist = split(&matchpairs, '.\zs[:,]')
	let i = index(plist, c)
	if i < 0
			" not found, nothing to do
			return
	endif

	" Figure out the arguments for searchpairpos().
	if i % 2 == 0
		let s_flags = 'nW'
		let c2 = plist[i + 1]
	else
		let s_flags = 'nbW'
		let c2 = c
		let c = plist[i - 1]
	endif
	if c == '['
		let c = '\['
		let c2 = '\]'
	endif

	" When not in a string or comment ignore matches inside them.
	" We match "escape" for special items, such as lispEscapeSpecial.
	let s_skip ='synIDattr(synID(line("."), col("."), 0), "name") ' .
	\ '=~? "string\\|character\\|singlequote\\|escape\\|comment"'
	execute 'if' s_skip '| let s_skip = 0 | endif'

	" Limit the search to lines visible in the window.
	let stoplinebottom = line('w$')
	let stoplinetop = line('w0')
	let stopline = i % 2 == 0 ? stoplinebottom : stoplinetop
	let [m_lnum, m_col] = searchpairpos(c, '', c2, s_flags, s_skip, stopline)

	" If a match is found setup match highlighting.
	if m_lnum > 0 && m_lnum >= stoplinetop && m_lnum <= stoplinebottom 
		exe '3match MatchParen /\(\%' . c_lnum . 'l\%' . (c_col) .
		\ 'c\)\|\(\%' . m_lnum . 'l\%' . m_col . 'c\)/'
		let w:paren_hl_on = 1
	endif
endfunction
