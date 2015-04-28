" Setup
highlight clear
syntax reset
let colors_name = 'rainbow'
set t_Co=16

let s:bg_base    = 'ctermbg=7'
let s:bg_bright  = 'ctermbg=6'

let s:fg_none    = 'ctermfg=NONE'
let s:fg_soft    = 'ctermfg=8'
let s:fg_orange  = 'ctermfg=9'
let s:fg_green   = 'ctermfg=10'
let s:fg_yellow  = 'ctermfg=11'
let s:fg_blue    = 'ctermfg=12'
let s:fg_purple  = 'ctermfg=13'
let s:fg_red     = 'ctermfg=14'
let s:fg_base    = 'ctermfg=15'

let s:fmt_none   = 'cterm=NONE'
let s:fmt_bold   = 'cterm=NONE,bold'
let s:fmt_rev    = 'cterm=NONE,reverse ctermbg=NONE'

" Syntax highlighting
exe "highlight! Comment"    s:fmt_none s:fg_soft
exe "highlight! Error"      s:fmt_bold s:fg_red
exe "highlight! Keyword"    s:fmt_none s:fg_yellow
exe "highlight! Normal"     s:fmt_none s:fg_base   s:bg_base
exe "highlight! PreProc"    s:fmt_none s:fg_purple
exe "highlight! String"     s:fmt_none s:fg_blue
exe "highlight! Todo"       s:fmt_bold s:fg_orange
highlight! link ErrorChar   Error
highlight! link Flow        Keyword
highlight! link Special     Comment
highlight! link SpecialChar PreProc
highlight! link Type        Keyword

" Specific
exe "highlight! DiffAdd"          s:fmt_none s:fg_green  s:bg_bright
highlight! link DiffChange        Normal
exe "highlight! DiffDelete"       s:fmt_none s:fg_red    s:bg_bright
exe "highlight! DiffText"         s:fmt_none s:fg_yellow s:bg_bright
highlight! link Directory         String
highlight! link YcmErrorSection   Error
highlight! link YcmWarningSection Error
highlight! link YcmWarningSign    Todo
highlight! link helpHyperTextJump helpHyperTextEntry

" UI colors
exe "highlight! EndOfBuffer"  s:fmt_none 'ctermfg=bg' s:bg_base
exe "highlight! ColorColumn"  s:fmt_none s:fg_none    s:bg_bright
exe "highlight! LineNr"       s:fmt_none s:fg_soft    s:bg_bright
exe "highlight! StatusLine"   s:fmt_none s:fg_green   s:bg_bright
exe "highlight! Visual"       s:fmt_rev  s:fg_soft    s:bg_bright
exe "highlight! WildMenu"     s:fmt_rev  s:fg_green   s:bg_bright
highlight! link CursorColumn  ColorColumn
highlight! link CursorLine    ColorColumn
highlight! link CursorLineNr  StatusLine
highlight! link ErrorMsg      Error
highlight! link Folded        StatusLine
highlight! link IncSearch     Search
highlight! link MatchParen    Search
highlight! link MoreMsg       Question
highlight! link NonText       Special
highlight! link Pmenu         StatusLine
highlight! link PmenuSel      WildMenu
highlight! link Question      StatusLine
highlight! link Search        WildMenu
highlight! link User1         Keyword
highlight! link SignColumn    LineNr
highlight! link SpecialKey    Comment
highlight! link SpellBad      Error
highlight! link SpellCap      SpellBad
highlight! link SpellLocal    SpellBad
highlight! link SpellRare     SpellBad
highlight! link StatusLineNC  StatusLine
highlight! link Title         Todo
highlight! link VertSplit     LineNr
highlight! link WarningMsg    Todo
