highlight clear

function! s:hi(mode, bg, fg, ...)
	for group in a:000
		execute 'hi!' group 'cterm=NONE'.a:mode 'ctermfg='.a:fg 'ctermbg='.a:bg
	endfor
endfunction

command! -nargs=+ Hi       call s:hi('',         7, <f-args>)
command! -nargs=+ HiBold   call s:hi(',bold',    7, <f-args>)
command! -nargs=+ HiBright call s:hi('',         6, <f-args>)
command! -nargs=+ HiRev    call s:hi(',reverse', 6, <f-args>)

HiBright NONE ColorColumn CursorColumn CursorLine
Hi       7    EndOfBuffer
Hi       8    Comment Special SpecialKey NonText
HiBright 8    LineNr SignColumn VertSplit
HiRev    8    Visual
HiBold   9    Todo Title WarningMsg
Hi       10   DiffAdd
HiBright 10   StatusLine CursorLineNr Folded Pmenu Question MoreMsg StatusLineNC
HiRev    10   WildMenu PmenuSel Search IncSearch MatchParen
Hi       11   Keyword Type Flow User1
HiBright 11   DiffText
Hi       12   String Character Directory
Hi       13   PreProc SpecialChar
Hi       14   DiffDelete
HiBold   14   Error ErrorChar ErrorMsg SpellBad SpellCap SpellLocal SpellRare
Hi       15   Normal DiffChange

let s:colors = map(['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'], "'ctermfg=' . v:val")
let s:parentheses = ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/']
let s:maxlvl = len(s:colors)

" function! colors#load()
	" let def_rg = 'syn region %s matchgroup=%s containedin=%s contains=%s %s'

	" for paren in s:parentheses
		" for lvl in range(s:maxlvl)
			" exec lvl == 0 ? printf(def_rg, 'rainbow_r0', 'rainbow_p0', 'rainbow_r'.(s:maxlvl - 1), 'TOP', paren)
						" \ : printf(def_rg, 'rainbow_r'.lvl, 'rainbow_p'.lvl.(' contained'),
						" \ 'rainbow_r'.((lvl + s:maxlvl - 1) % s:maxlvl), 'TOP', paren)
		" endfor
	" endfor
	" syn match Error /[])}]/
" endfunction

" function! colors#toggle()
	" let b:rainbow_visible = !get(b:, 'rainbow_visible', 0)
	" for id in range(s:maxlvl)
		" if b:rainbow_visible
			" let color = s:colors[id % len(s:colors)]
			" exe 'hi default rainbow_p' . id color
			" exe 'hi default rainbow_o' . id color
		" else
			" exe 'hi clear rainbow_p' . id
			" exe 'hi clear rainbow_o' . id
		" endif
	" endfor
" endfunction

" augroup Rainbow
	" autocmd!
	" autocmd Syntax,Colorscheme * call rainbow#load()
" augroup END
