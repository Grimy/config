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
