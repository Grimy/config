" Map extensions / executable names to filetypes
let s:shebang = '\v^%(#!%(\f+/)?|\<\?)%(env\s*)?\zs\f+'
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
	\ 'pl': 'perl',
	\ 'py': 'python', 'python2.6': 'python',
	\ 'rb': 'ruby', 'rake': 'ruby',
	\ 'rs': 'rust',
	\ 's': 'gas', 'S': 'gas',
	\ 'wiki': 'mediawiki',
	\ 'yml': 'yaml', 'fish_history': 'yaml', 'fish_read_history': 'yaml',
	\ }

function! s:filetype(name)
	syn clear
	augroup FileTypePlugin
		autocmd!
		runtime syntax/common.vim
		exe 'runtime syntax/'   . a:name . '.vim'
		exe 'runtime indent/'   . a:name . '.vim'
		exe 'runtime ftplugin/' . a:name . '.vim'
	augroup END
endfunction

function! s:setft(type)
	if a:type !=# ''
		let &filetype = get(s:ftmap, a:type, a:type)
	endif
endfunction

augroup filetypedetect
	autocmd!
	autocmd CmdwinEnter * setf vim
	autocmd TermOpen * setf term
	autocmd BufNewFile,BufRead * call s:setft(substitute(expand("<afile>"), '\v.*[./]|\~', '', 'g'))
	autocmd BufRead,StdinReadPost,BufWritePost * call s:setft(matchstr(getline(1), s:shebang))
	autocmd FileType * call s:filetype(expand('<amatch>'))
augroup END
