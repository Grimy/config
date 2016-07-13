highlight clear

function! s:hi(mode, bg, fg, ...)
	for group in a:000
		execute 'hi!' group 'cterm=NONE'.a:mode 'ctermfg='.a:fg 'ctermbg='.a:bg
	endfor
endfunction

command! -nargs=+ Hi       call s:hi('',         'NONE', <f-args>)
command! -nargs=+ HiBold   call s:hi(',bold',    'NONE', <f-args>)
command! -nargs=+ HiBright call s:hi('',         0, <f-args>)
command! -nargs=+ HiRev    call s:hi(',reverse', 0, <f-args>)

HiBright NONE ColorColumn CursorColumn CursorLine
Hi       NONE Normal DiffChange Conceal
HiBright 1    ErrorSign
Hi       1    DiffDelete Error ErrorChar ErrorMsg SpellBad
Hi       8    Comment Special SpecialKey NonText EndOfBuffer
HiBright 8    LineNr SignColumn VertSplit
HiRev    8    Visual
HiBold   9    Todo Title WarningMsg
HiBright 9    DiffText
Hi       10   DiffAdd User1 Green
HiBright 10   StatusLine CursorLineNr Folded Pmenu Question MoreMsg StatusLineNC
HiRev    10   WildMenu PmenuSel Search IncSearch MatchParen
Hi       11   Keyword Type
HiBold   11   Flow
Hi       12   String Character Directory
Hi       13   PreProc SpecialChar
