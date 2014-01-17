let g:repeat_tick = -1
let g:repeat_reg = ['', '']

" Special function to avoid spurious repeats in a related, naturally repeating
" mapping when your repeatable mapping doesn't increase b:changedtick.
function! repeat#invalidate()
	let g:repeat_tick = -1
endfunction

function! repeat#set(sequence,...)
	let g:repeat_sequence = a:sequence
	let g:repeat_count = a:0 ? a:1 : v:count
	let g:repeat_tick = b:changedtick
	augroup repeat_custom_motion
		autocmd!
		autocmd CursorMoved <buffer> let g:repeat_tick = b:changedtick
		autocmd CursorMoved <buffer> autocmd! repeat_custom_motion
	augroup END
endfunction

function! repeat#setreg(sequence,register)
	let g:repeat_reg = [a:sequence, a:register]
endfunction

function! repeat#run(count)
	if g:repeat_tick == b:changedtick
		let r = ''
		if g:repeat_reg[0] ==# g:repeat_sequence && !empty(g:repeat_reg[1])
			if g:repeat_reg[1] ==# '='
				" This causes a re-evaluation of the expression on repeat, which
				" is what we want.
				let r = '"=' . getreg('=', 1) . "\<CR>"
			else
				let r = '"' . g:repeat_reg[1]
			endif
		endif

		let c = g:repeat_count
		let s = g:repeat_sequence
		let cnt = c == -1 ? "" : (a:count ? a:count : (c ? c : ''))
		call feedkeys(r . cnt, 'n')
		call feedkeys(s)
	else
		call feedkeys((a:count ? a:count : '') . '.', 'n')
	endif
endfunction

function! repeat#wrap(command,count)
	let preserve = (g:repeat_tick == b:changedtick)
	execute 'normal! ' a:command . (&foldopen =~# 'undo' ? 'zv' : '')
	if preserve
		let g:repeat_tick = b:changedtick
	endif
endfunction

nnoremap <silent> . :<C-U>call repeat#run(v:count)<CR>
xnoremap <silent> . :<C-U>call repeat#run(v:count)<CR>gv

nnoremap <silent> u :<C-U>call repeat#wrap('u', v:count1)<CR>
nnoremap <silent> U :<C-U>call repeat#wrap('<C-V><C-R>', v:count1)<CR>

augroup repeatPlugin
	autocmd!
	autocmd BufLeave,BufWritePre,BufReadPre * let g:repeat_tick =
				\ g:repeat_tick != b:changedtick && g:repeat_tick != 0
	autocmd BufEnter,BufWritePost * if g:repeat_tick
	autocmd BufEnter,BufWritePost *     let g:repeat_tick = b:changedtick
	autocmd BufEnter,BufWritePost * endif
augroup END

