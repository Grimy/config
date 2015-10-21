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
Hi       7    EndOfBuffer
Hi       0    Comment Special SpecialKey NonText
HiBright 0    LineNr SignColumn VertSplit
HiRev    0    Visual
HiBold   9    Todo Title WarningMsg
Hi       10   DiffAdd
HiBright 10   StatusLine CursorLineNr Folded Pmenu Question MoreMsg StatusLineNC
HiRev    10   WildMenu PmenuSel Search IncSearch MatchParen
Hi       3    Keyword Type Flow User1
HiBright 11   DiffText
Hi       12   String Character Directory
Hi       13   PreProc SpecialChar
Hi       14   DiffDelete
HiBold   14   Error ErrorChar ErrorMsg SpellBad SpellCap SpellLocal SpellRare
Hi       15   Normal DiffChange
