let g:did_load_filetypes = 1
let g:did_load_ftplugin  = 1
let g:ftmap = {
			\ 'asm': 'masm', 'inc': 'masm',
			\ 's': 'gas', 'S': 'gas',
			\ 'node': 'javascript', 'js': 'javascript',
			\ 'md': 'markdown', 'mkd': 'markdown',
			\ 'wiki': 'mediawiki',
			\ 'pl': 'perl',
			\ 'py': 'python', 'python2': 'python', 'python3': 'python',
			\ 'h': 'c',
			\ 'nvimrc': 'vim',
			\ 'Makefile': 'make', 'Tupfile': 'tup',
			\ 'COMMIT_EDITMSG': 'gitcommit',
			\ }

" Emulate default behaviour
augroup filetypedetect
	autocmd!
	autocmd CmdwinEnter * setf vim
	autocmd VimEnter,BufEnter,BufRead * if isdirectory(expand("<afile>")) | setf dir | endif
	autocmd BufNewFile,BufRead * call s:setft(substitute(expand("<afile>"), '\v.*[./]|\~', '', 'g'))
	autocmd BufNewFile,BufRead,BufWritePost * call s:detect_shebang()
	autocmd BufNewFile,BufRead,StdinReadPost * if getline(1) =~ '\v^(.+\(..?\)).*\1$' | setf man | endif
	autocmd BufNewFile,BufRead ~/.config/fish/fish_{read_,}history setf yaml
	autocmd BufNewFile,BufRead ~/.config/fish/fishd.* setlocal readonly
augroup END

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
	let groups = matchlist(getline(1), '\v^#!\f+/(\f+)\s*(\f*)')
	if len(groups)
		call s:setft(groups[1] ==# 'env' ? groups[2] : groups[1])
	endif
endfunction

function! s:setft(type)
	execute 'setf' get(g:ftmap, a:type, a:type)
endfunction

augroup UpdateFileType
	autocmd!
	autocmd FileType * call s:filetype(expand('<amatch>'))
augroup END
