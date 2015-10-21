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
Hi       2    DiffAdd
HiBright 2    StatusLine CursorLineNr Folded Pmenu Question MoreMsg StatusLineNC
HiRev    2    WildMenu PmenuSel Search IncSearch MatchParen
Hi       3    Keyword Type Flow User1
Hi       9    DiffDelete
HiBold   9    Error ErrorChar ErrorMsg SpellBad SpellCap SpellLocal SpellRare
HiBold   11   Todo Title WarningMsg
HiBright 11   DiffText
Hi       12   String Character Directory
Hi       13   PreProc SpecialChar
