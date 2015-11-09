" Smart indent detection
let &l:expandtab = getline(search('^%(\t|  )', 'wn'))[0] == ' '

" Handle non-ASCII word charcacters
execute 'setlocal iskeyword+=' . (&fenc == 'utf-8' ? '128-167,224-235' : '192-255')
setlocal iskeyword=@,48-57

" Common syntax
syn sync minlines=200
syn keyword Todo TODO contained containedin=Comment
syn match Comment /\v#.*/

function! s:comments(begin, ...)
	let &l:commentstring = a:begin . join([' %s'] + a:000)
	let begin = (len(a:begin) == 1 ? '\^\s\*' : '') . a:begin
	let end = a:0 ? a:1 : '\$'
	execute 'syn region Comment start=_\V' . begin . '_ end=_\V' . end . '_'
endfunction
command! -nargs=* Comments call s:comments(<f-args>)

syn match ErrorChar "\\." contained
syn match SpecialChar /\v\\([bfnrt\\"]|\o{1,3})/ contained

" Common options
setlocal formatoptions=croqljn nrformats-=octal
setlocal comments=sr:/**,mb:*,ex:*/,sr:/*,mb:*,ex:*/ autoindent

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

set conceallevel=1 concealcursor+=i
syntax match Operator '<=' conceal cchar=≤
syntax match Operator '>=' conceal cchar=≥
syntax match Operator '::' conceal cchar=∷
