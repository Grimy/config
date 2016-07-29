augroup ViDir
	autocmd!
	autocmd BufNew * if isdirectory(expand('<afile>')) | call s:setup_dir() | endif
augroup END

function! s:setup_dir() abort
	autocmd ViDir BufReadCmd  <buffer=abuf> lch <afile> | call s:read_dir()
	autocmd ViDir BufWriteCmd <buffer=abuf> lch <afile> | call s:write_dir()
endfunction

function! s:read_dir() abort
	%!ls -Ap
	let b:files = getline(1, '$')
endfunction

function! s:write_dir() abort
	let pos = getcurpos()
	let deletions = 0

	for i in range(len(b:files))
		let old_name = b:files[i]
		let new_name = getline(i + 1 - deletions)
		let index = index(b:files, new_name, i)

		if index == i
			continue
		elseif index > 0 && index - i <= len(b:files) - line('$')
			let deletions += 1
			let new_name = &backupdir . '/' . old_name
		elseif len(glob(new_name))
			echoerr 'Error: ' new_name 'already exists'
		endif

		if rename(old_name, new_name)
			echoerr 'Error renaming' old_name 'to' new_name
		endif
	endfor

	silent! undojoin | call s:read_dir()
	set nomodified
	call setpos('.', pos)
endfunction
