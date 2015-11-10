" Map extensions / executable names to filetypes
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
	syntax clear
	augroup FileTypePlugin
		autocmd!
		execute 'runtime syntax/common.vim'
		execute 'runtime syntax/'   . a:name . '.vim'
		execute 'runtime indent/'   . a:name . '.vim'
		execute 'runtime ftplugin/' . a:name . '.vim'
	augroup END
endfunction

function! s:detect_shebang()
	call s:setft(matchstr(getline(1), '\v^%(#!%(\f+/)?|\<\?)%(env\s*)?\zs\f+'))
endfunction

function! s:setft(type)
	if a:type !=# ''
		let &filetype = get(s:ftmap, a:type, a:type)
	endif
endfunction

augroup filetypedetect
	autocmd!

	" Filetype detection
	autocmd CmdwinEnter * setf vim
	autocmd TermOpen * setf term
	autocmd BufNewFile,BufRead * call s:setft(substitute(expand("<afile>"), '\v.*[./]|\~', '', 'g'))
	autocmd BufRead,StdinReadPost,BufWritePost * call s:detect_shebang()

	" Indent-style detection
	autocmd BufRead,StdinReadPost * let &l:expandtab = getline(search('^\s', 'wn'))[0] == ' '

	" Execute filetype plugins
	autocmd FileType * call s:filetype(expand('<amatch>'))
augroup END
