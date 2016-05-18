" make on save
autocmd BufWritePost * call AsyncMake()

sign define qf text=!! texthl=Error

function! OnOutput(job_id, data, event_type) abort
	caddexpr a:data
endfunction

function! OnExit(job_id, data, event_type) abort
	let list = []
	sign unplace *
	for qf in getqflist()
		if !qf.bufnr
			continue
		endif
		call add(list, qf)
		execute 'sign' 'place' string(len(list)) 'name=qf' 'line='.qf.lnum 'buffer='.qf.bufnr
	endfor
	call setqflist(list)
	call ShowError()
endfunction

function! AsyncMake() abort
	let argv = split(&makeprg)
	let argv[-1] = expand(argv[-1])
	call setqflist([])
	call jobstart(argv, {
		\ 'on_stdout': function('OnOutput'),
		\ 'on_stderr': function('OnOutput'),
		\ 'on_exit': function('OnExit')})
endfunction

function! ShowError() abort
	let lnum = getpos('.')[1]
	let bufnr = bufnr('%')
	for qf in getqflist()
		if qf.bufnr == bufnr && qf.lnum == lnum
			echo qf.text
			return
		endif
	endfor
endfunction
autocmd CursorMoved * call ShowError()
