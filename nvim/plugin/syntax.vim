" Map extensions / executable names to filetypes
let s:shebang = '\v^%(#!\s*%(\f+/)?|\<\?)%(env\s*)?\zs[a-z-]+'
let s:ftmap = {
	\ 'bash': 'sh', 'zshrc': 'sh', 'zshenv': 'sh',
	\ 'COMMIT_EDITMSG': 'gitcommit',
	\ 'Makefile': 'make',
	\ 'Tupfile': 'tup',
	\ 'asm': 'masm', 'inc': 'masm',
	\ 'h': 'c', 'cpp': 'c', 'ino': 'c',
	\ 'js': 'javascript', 'node': 'javascript',
	\ 'md': 'markdown', 'mkd': 'markdown',
	\ 'nvimrc': 'vim',
	\ 'pl': 'perl', 'pm': 'perl',
	\ 'py': 'python',
	\ 'rb': 'ruby', 'rake': 'ruby',
	\ 'rs': 'rust',
	\ 's': 'gas', 'S': 'gas',
	\ 'tt': 'html',
	\ 'wiki': 'mediawiki',
	\ 'yml': 'yaml', 'fish_history': 'yaml', 'fish_read_history': 'yaml',
	\ }

" Sets some common syntax and options, then sources syntax/&ft.vim
function! s:filetype(name)
	syn clear
	syn sync minlines=200
	syn keyword Todo TODO contained containedin=Comment
	syn match ErrorChar "\\." contained
	syn match SpecialChar /\v\\([bfnrt\\"]|\o{1,3})/ contained
	hi! link SingleEscape SpecialChar
	hi! link DoubleEscape SpecialChar
	setlocal formatoptions=croqljn iskeyword=@,48-57,_ synmaxcol=256
	setlocal comments=sr:/**,mb:*,ex:*/,sr:/*,mb:*,ex:*/
	let &l:expandtab = getline(search('\v^%(\t|  )', 'wn'))[0] ==# ' '
	exe 'runtime syntax/' . a:name . '.vim'
endfunction

function! s:setft(type)
	if a:type !=# ''
		let &filetype = get(s:ftmap, a:type, a:type)
	endif
endfunction

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
	let indent = indent(line) / &tabstop * &tabstop
	let prev = getline(line)
	let cur = getline('.')
	if (&commentstring ==# '// %s' && cur =~# '\v^\s*\*')
		return indent + 1
	endif
	let flow = (prev =~ b:indent_start) - (cur =~ b:indent_end)
	let cont = line == line('.') - 1 && prev =~# b:indent_conted
	let conted = getline(line - 1) =~# b:indent_conted
	return indent + &tabstop * (flow + cont - conted)
endfunction

augroup filetypedetect
	autocmd!
	autocmd CmdwinEnter * setf vim
	autocmd TermOpen * setf term
	autocmd BufNewFile,BufRead * call s:setft(substitute(expand("<afile>"), '\v.*[./]|\~', '', 'g'))
	autocmd BufRead,StdinReadPost,BufWritePost * call s:setft(matchstr(getline(1), s:shebang))
	autocmd FileType * call s:filetype(expand('<amatch>'))
augroup END
