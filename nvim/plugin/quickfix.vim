augroup QuickFix
	autocmd!
	autocmd CursorMoved * call ShowError(getpos('.')[1], bufnr('%'))
	autocmd BufWritePost * call AsyncMake()
augroup END

sign define qf text=!! texthl=Error

nnoremap <CR> :<C-U>try<Bar>cnext<Bar>catch<Bar>cfirst<Bar>endtry<CR>zx

function! OnOutput(job_id, data, event_type) abort
	caddexpr a:data
endfunction

function! OnExit(job_id, data, event_type) abort
	let qflist = filter(getqflist(), 'v:val.bufnr')
	sign unplace *
	for qf in qflist
		execute 'sign place 1 name=qf' 'line='.qf.lnum 'buffer='.qf.bufnr
	endfor
	call setqflist(qflist)
	call ShowError(getpos('.')[1], bufnr('%'))
endfunction

function! AsyncMake() abort
	let argv = split(&makeprg)
	let argv[-1] = expand(argv[-1])
	call setqflist([])
	call jobstart(argv, {
		\ 'on_stdout': 'OnOutput',
		\ 'on_stderr': 'OnOutput',
		\ 'on_exit': 'OnExit'})
endfunction

function! ShowError(lnum, bufnr) abort
	for qf in getqflist()
		if qf.bufnr == a:bufnr && qf.lnum == a:lnum
			echo qf.text
			return
		endif
	endfor
endfunction
