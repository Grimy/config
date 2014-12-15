function! TreeH()
	return stridx(getline('.'), '▾') >= 0 ? 'o' : strpart(getline('.'), 0, 1) ==# ' ' ? 'x' : 'u'
endfunction

nmap <buffer> l oj
nmap <buffer> e o
nmap <buffer> <expr> h TreeH()
nmap <buffer> r R
nmap <buffer> <CR> C
nmap <buffer> v s
silent! nunmap <buffer> <C-J>
silent! nunmap <buffer> <C-K>
