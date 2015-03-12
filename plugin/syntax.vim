" Map extensions / executable names to filetypes
let s:ftmap = {
			\ 'COMMIT_EDITMSG': 'gitcommit',
			\ 'Makefile': 'make',
			\ 'Tupfile': 'tup',
			\ 'Xresources': 'xdefaults',
			\ 'asm': 'masm', 'inc': 'masm',
			\ 'h': 'c', 'cpp': 'c',
			\ 'js': 'javascript', 'node': 'javascript',
			\ 'md': 'markdown', 'mkd': 'markdown',
			\ 'nvimrc': 'vim',
			\ 'pl': 'perl',
			\ 'py': 'python', 'python2': 'python', 'python3': 'python',
			\ 'rb': 'ruby', 'rake': 'ruby',
			\ 's': 'gas', 'S': 'gas',
			\ 'wiki': 'mediawiki',
			\ 'yml': 'yaml', 'fish_history': 'yaml', 'fish_read_history': 'yaml',
			\ }

function! s:filetype(name)
	syntax clear
	augroup FileTypePlugin
		autocmd!
		execute 'runtime syntax/'   . a:name . '.vim'
		execute 'runtime indent/'   . a:name . '.vim'
		execute 'runtime ftplugin/' . a:name . '.vim'
		execute 'runtime ftplugin/after.vim'
	augroup END
endfunction

function! s:detect_shebang()
	let groups = matchlist(getline(1), '\v^%(#!\f+/|\<\?)(\f+)\s*(\f*)')
	if len(groups)
		call s:setft(groups[1] ==# 'env' ? groups[2] : groups[1])
	endif
endfunction

function! s:setft(type)
	if a:type !=# ''
		execute 'setf' get(s:ftmap, a:type, a:type)
	endif
endfunction

augroup filetypedetect
	autocmd!
	autocmd CmdwinEnter * setf vim
	autocmd VimEnter,BufEnter,BufRead * if isdirectory(expand("<afile>")) | setf dir | endif
	autocmd BufNewFile,BufRead,StdinReadPost * if getline(1) =~ '\v^(.+\(..?\)).*\1$' | setf man | endif
	autocmd BufNewFile,BufRead,BufWritePost * call s:detect_shebang()
	autocmd BufNewFile,BufRead * call s:setft(substitute(expand("<afile>"), '\v.*[./]|\~', '', 'g'))
augroup END

augroup UpdateFileType
	autocmd!
	autocmd FileType * call s:filetype(expand('<amatch>'))
augroup END
