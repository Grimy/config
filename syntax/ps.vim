let &l:commentstring='% %s'

function! BonusIndent(prev, cur) abort
	return (a:prev =~# '[{\[]$')
		\ - (a:cur =~# '\v^\s*[\]}]')
endfunction
