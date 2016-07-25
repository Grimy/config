function! s:comments(begin, ...)
	let &l:commentstring = a:begin . join([' %s'] + a:000)
	let &l:foldmarker = repeat(a:begin[0], 3) . ',' . repeat(a:begin[0], 3)
	let begin = (len(a:begin) == 1 ? '\%(\^\|  \)\s\*' : '') . a:begin
	let end = a:0 ? a:1 : '\$'
	execute 'syn region Comment start=_\V' . begin . '_ end=_\V' . end . '_'
endfunction

function! s:flow(...) abort
	setlocal number indentexpr=Indent()
	let braces = a:0 == 2 || &filetype ==# 'sh'
	let b:indent_start = '\v^[\t }]*%(' . a:1 . '|' . a:2 .')\k@!' . (braces ? '|\{$' : '')
	let b:indent_cont = '\v<>'
	let b:indent_conted = '\v[\[(\\,' . (braces ? '' : '{') . ']$'
	let b:indent_end = '\v^[\t }]*%(' . a:2 . (a:0 == 3 ? '|' . a:3 : '') . ')\k@!' . (braces ? '|^\s*\}' : '')
	let any = split(join(a:000, '|'), '|')
	execute 'syn keyword Flow' join(any)
	let &l:indentkeys='0),0},0],o,O,=' . join(any, ',=')
endfunction

function! Indent() abort
	let line = line('.') - 1
	while empty(getline(line))
		if line == 0
			return 0
		endif
		let line -= 1
	endwhile
	let indent = indent(line) / &tabstop * &tabstop
	let prev = getline(line)
	let cur = getline('.')
	if (&commentstring ==# '// %s' && cur =~# '\v^\s*\*')
		return indent + 1
	endif
	let flow = (prev =~ b:indent_start) - (cur =~ b:indent_end)
	let cont = cur =~ b:indent_cont || (line == line('.') - 1 && prev =~# b:indent_conted)
	let conted = prev =~# b:indent_cont || getline(line - 1) =~# b:indent_conted
	return indent + &tabstop * (flow + cont - conted)
endfunction

command! -nargs=* Comments call s:comments(<f-args>)
command! -nargs=* Flow call s:flow(<f-args>)
