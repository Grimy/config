Comments [ ]
Flow <> <>

function! InformIndent(prev, cur, blanks) abort
	if a:prev =~# '\v:$'
		return 1
	elseif a:cur =~# '\v^\s*else>'
		return -1
	elseif a:prev =~# '\v\."?$'
		return -9
	endif
endfunction
let b:indent_func = funcref('InformIndent')

syn match Todo /\v^%(Book|Chapter|Volume|Section)>.*/
syn region String matchgroup=Normal start='"' end='"'
syn region PreProc start='\[' end='\]' contained containedin=String
syn region Comment start='\[' end='\]' skip=/\v\[.{-}\]/
syn region Inform6 start='(-' end='-)'

Hi 6 Inform6
