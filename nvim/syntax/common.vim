" Common options
setlocal formatoptions=croqljn iskeyword=@,48-57,_
setlocal comments=sr:/**,mb:*,ex:*/,sr:/*,mb:*,ex:*/
let &l:expandtab = getline(search('^%(\t|  )', 'wn'))[0] == ' '

" Common syntax
syn sync minlines=200
syn keyword Todo TODO contained containedin=Comment
syn match ErrorChar "\\." contained
syn match SpecialChar /\v\\([bfnrt\\"]|\o{1,3})/ contained

" set conceallevel=1 concealcursor+=i
" syn match Operator '<=' conceal cchar=≤
" syn match Operator '>=' conceal cchar=≥
" syn match Operator '::' conceal cchar=∷

function! s:comments(begin, ...)
	let &l:commentstring = a:begin . join([' %s'] + a:000)
	let begin = (len(a:begin) == 1 ? '\^\s\*' : '') . a:begin
	let end = a:0 ? a:1 : '\$'
	execute 'syn region Comment start=_\V' . begin . '_ end=_\V' . end . '_'
endfunction
command! -nargs=* Comments call s:comments(<f-args>)

function! s:flow(...) abort
	setlocal number indentexpr=Indent()
	let braces = a:0 == 2 || &filetype ==# 'sh'
	let b:indent_start = '\v^[\t }]*<%(' . a:1 . '|' . a:2 .')>' . (braces ? '|\{$' : '')
	let b:indent_conted = '\v[\[(\\,' . (braces ? '' : '{') . ']$'
	let b:indent_end = '\v^[\t }]*<%(' . a:2 . (a:0 == 3 ? '|' . a:3 : '') . ')>' . (braces ? '|^\s*\}' : '')
	let any = split(join(a:000, '|'), '|')
	execute 'syn keyword Flow' join(any)
	let &l:indentkeys='0),0},0],o,O,=' . join(any, ',=')
endfunction
command! -nargs=* Flow call s:flow(<f-args>)

function! Indent() abort
	if synIDattr(synID(line('.'), 1, 0), 'name') ==# 'String'
		return indent('.')
	endif
	let line = line('.') - 1
	while empty(getline(line))
		if line == 0
			return 0
		endif
		let line -= 1
	endwhile
	let indent = indent(line)
	let prev = getline(line)
	let cur = getline('.')
	if (&commentstring == '// %s')
		if cur =~# '\v^\s*/\*'
			let indent -= &ts
		endif
		if prev =~# '\v^\s*/\*'
			let indent += 1 + (prev =~# '\v^\s*/\*\*')
		endif
		if prev =~# '\v\*/$'
			let indent += &ts
			let indent -= indent % &ts
		endif
	endif
	return indent + &ts * ((prev =~ b:indent_start) - (cur =~ b:indent_end)
		\ + (line == line('.') - 1 && prev =~# b:indent_conted)
		\ - (getline(line - 1) =~# b:indent_conted))
endfunction
