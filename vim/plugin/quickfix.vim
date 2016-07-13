augroup QuickFix
	autocmd!
	autocmd CursorMoved * call ShowError(getpos('.')[1], bufnr('%'))
	autocmd BufWritePost * call AsyncMake()
augroup END

sign define qf text=>< texthl=ErrorSign

nnoremap <CR> :<C-U>try<Bar>cnext<Bar>catch<Bar>cfirst<Bar>endtry<CR>zx

function! OnOutput(channel, data) abort
	caddexpr a:data
	let qflist = filter(getqflist(), 'v:val.bufnr')
	call setqflist(qflist)
	sign unplace *
	for qf in qflist
		execute 'sign place 1 name=qf' 'line='.qf.lnum 'buffer='.qf.bufnr
	endfor
	call ShowError(getpos('.')[1], bufnr('%'))
endfunction

function! AsyncMake() abort
	let argv = split(&makeprg)
	let argv[-1] = expand(argv[-1])
	call setqflist([])
	sign unplace *
	call job_start(argv, {'out_cb': 'OnOutput', 'err_cb': 'OnOutput'})
endfunction

function! ShowError(lnum, bufnr) abort
	for qf in getqflist()
		if qf.bufnr == a:bufnr && qf.lnum == a:lnum
			echo qf.text[0:&columns - 42]
			return
		endif
	endfor
	echo
endfunction
