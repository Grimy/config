set background=dark
highlight clear

function! s:hi(mode, bg, fg, ...)
	for group in a:000
		execute 'hi!' group 'cterm=NONE'.a:mode 'ctermfg='.a:fg 'ctermbg='.a:bg
	endfor
endfunction

command! -nargs=+ Hi       call s:hi('',         'NONE', <f-args>)
command! -nargs=+ HiBold   call s:hi(',bold',    'NONE', <f-args>)
command! -nargs=+ HiBright call s:hi('',         234, <f-args>)
command! -nargs=+ HiRev    call s:hi(',reverse', 234, <f-args>)

Hi       NONE Normal DiffChange Conceal
HiBright NONE ColorColumn CursorColumn CursorLine
HiBright 1    ErrorSign
Hi       1    DiffDelete Error ErrorChar ErrorMsg SpellBad
Hi       2    DiffAdd User1
HiBright 2    StatusLine CursorLineNr Folded Pmenu Question MoreMsg StatusLineNC
HiRev    2    WildMenu PmenuSel Search IncSearch MatchParen
Hi       7    Comment Special SpecialKey NonText EndOfBuffer
HiBright 7    LineNr SignColumn VertSplit
HiRev    7    Visual
HiBold   9    Todo Title WarningMsg
HiBright 9    DiffText
Hi       11   Keyword Type Flow
Hi       12   PreProc SpecialChar
Hi       14   String Character
