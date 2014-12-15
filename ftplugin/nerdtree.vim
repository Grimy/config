function! TreeH()
	if stridx(getline('.'), '▾') >= 0
		return 'o'
	elseif strpart(getline('.'), 0, 1) ==# ' '
		return 'x'
	else
		return 'u'
	end
endfunction

nmap <buffer> l o
nmap <buffer> <expr> h TreeH()
nmap <buffer> r R
nmap <buffer> <CR> C
nmap <buffer> v s
silent! nunmap <buffer> <C-J>
silent! nunmap <buffer> <C-K>
