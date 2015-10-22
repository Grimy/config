highlight clear

function! s:hi(mode, bg, fg, ...)
	for group in a:000
		execute 'hi!' group 'cterm=NONE'.a:mode 'ctermfg='.a:fg 'ctermbg='.a:bg
	endfor
endfunction

command! -nargs=+ Hi       call s:hi('',         'NONE', <f-args>)
command! -nargs=+ HiBold   call s:hi(',bold',    'NONE', <f-args>)
command! -nargs=+ HiBright call s:hi('',         8, <f-args>)
command! -nargs=+ HiRev    call s:hi(',reverse', 8, <f-args>)

HiBright NONE ColorColumn CursorColumn CursorLine
Hi       NONE Normal DiffChange
Hi       0    Comment Special SpecialKey NonText EndOfBuffer
HiBright 0    LineNr SignColumn VertSplit
HiRev    0    Visual
Hi       1    DiffDelete
Hi       1    Error ErrorChar ErrorMsg SpellBad SpellCap SpellLocal SpellRare
HiBold   9    Todo Title WarningMsg
HiBright 9    DiffText
Hi       10   DiffAdd
HiBright 10   StatusLine CursorLineNr Folded Pmenu Question MoreMsg StatusLineNC
HiRev    10   WildMenu PmenuSel Search IncSearch MatchParen
Hi       11   Keyword Type
HiBold   11   Flow User1
Hi       12   String Character Directory
Hi       13   PreProc SpecialChar
