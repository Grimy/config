if has('gui_running')
	let s:colors = map(['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'], "'guifg=' . v:val")
else
	let s:colors = map(['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'], "'ctermfg=' . v:val")
endif
let s:parentheses = ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/']
let s:maxlvl = len(s:colors)

function! rainbow#load()
	let def_rg = 'syn region %s matchgroup=%s containedin=%s contains=%s %s'

	for paren in s:parentheses
		for lvl in range(s:maxlvl)
			exec lvl == 0 ? printf(def_rg, 'rainbow_r0', 'rainbow_p0', 'rainbow_r'.(s:maxlvl - 1), 'TOP', paren)
						\ : printf(def_rg, 'rainbow_r'.lvl, 'rainbow_p'.lvl.(' contained'),
						\ 'rainbow_r'.((lvl + s:maxlvl - 1) % s:maxlvl), 'TOP', paren)
		endfor
	endfor
	syn match Error /[])}]/
endfunction

function! rainbow#toggle()
	let b:rainbow_visible = !get(b:, 'rainbow_visible', 0)
	for id in range(s:maxlvl)
		if b:rainbow_visible
			let color = s:colors[id % len(s:colors)]
			exe 'hi default rainbow_p' . id color
			exe 'hi default rainbow_o' . id color
		else
			exe 'hi clear rainbow_p' . id
			exe 'hi clear rainbow_o' . id
		endif
	endfor
endfunction

augroup Rainbow
	autocmd!
	autocmd Syntax,Colorscheme * call rainbow#load()
augroup END
