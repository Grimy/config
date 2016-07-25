let s:shebang = '\v^%(#!\s*%(\f+/)?|\<\?)%(env\s*)?\zs[a-z-]+'
let s:ftmap = {
	\ 'bash': 'sh', 'zshrc': 'sh', 'zshenv': 'sh',
	\ 'COMMIT_EDITMSG': 'gitcommit',
	\ 'mk': 'make', 'Makefile': 'make',
	\ 'h': 'c', 'cpp': 'c', 'ino': 'c',
	\ 'js': 'javascript', 'node': 'javascript',
	\ 'pl': 'perl', 'pm': 'perl',
	\ 'py': 'python',
	\ 'rb': 'ruby', 'rake': 'ruby',
	\ 'rs': 'rust',
	\ 'tt': 'html',
	\ 'svg': 'xml',
	\ 'yml': 'yaml',
	\ }

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

augroup FileTypeDetect
	autocmd!
	autocmd BufNewFile,BufRead * call s:setft(substitute(expand('%'), '\v.*[./]|\~', '', 'g'))
	autocmd BufRead,StdinReadPost,BufWritePost * call s:setft(matchstr(getline(1), s:shebang))
	autocmd FileType * call s:filetype(expand('<amatch>'))
augroup END
