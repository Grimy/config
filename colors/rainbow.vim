" Setup {{{1
highlight clear
syntax reset
let colors_name = 'rainbow'
set t_Co=16

let s:bg_none    = 'guibg=NONE    ctermbg=NONE'
let s:bg_base    = 'guibg=#002b36 ctermbg=7'
let s:bg_bright  = 'guibg=#073642 ctermbg=6'

let s:fg_none    = 'guifg=NONE    ctermfg=NONE'
let s:fg_soft    = 'guifg=#586e75 ctermfg=8'
let s:fg_orange  = 'guifg=#cb4b16 ctermfg=9'
let s:fg_green   = 'guifg=#719e07 ctermfg=10'
let s:fg_yellow  = 'guifg=#b58900 ctermfg=11'
let s:fg_blue    = 'guifg=#268bd2 ctermfg=12'
let s:fg_purple  = 'guifg=#6c71c4 ctermfg=13'
let s:fg_red     = 'guifg=#dc322f ctermfg=14'
let s:fg_base    = 'guifg=#839496 ctermfg=15'

let s:fmt_none   = 'gui=NONE cterm=NONE'
let s:fmt_bold   = 'gui=NONE,bold cterm=NONE,bold'
let s:fmt_line   = 'gui=NONE,underline cterm=NONE,underline'
let s:fmt_rev    = 'gui=NONE,reverse cterm=NONE,reverse'
let s:fmt_revb   = 'gui=NONE,reverse,bold cterm=NONE,reverse,bold'

" Syntax highlighting {{{1
exe "highlight! Normal"  s:fmt_none s:fg_base s:bg_base

exe "highlight! Comment" s:fmt_none s:fg_soft s:bg_none

exe "highlight! String"  s:fmt_none s:fg_blue s:bg_none
highlight! link Constant Normal
highlight! link Character Normal
highlight! link Number Normal
highlight! link Boolean Keyword
highlight! link Float Normal

highlight! link Identifier Normal
highlight! link Function Normal

highlight! link Statement Normal
highlight! link Conditional Keyword
highlight! link Repeat Keyword
highlight! link Label Keyword
highlight! link Operator Normal
exe "highlight! Keyword" s:fmt_none s:fg_yellow s:bg_none
highlight! link Exception Keyword

exe "highlight! PreProc" s:fmt_none s:fg_purple s:bg_none
highlight! link Include PreProc
highlight! link Define PreProc
highlight! link Macro PreProc
highlight! link PreCondit PreProc

highlight! link Type Keyword
highlight! link StorageClass Keyword
highlight! link Structure Keyword
highlight! link Typedef Keyword

highlight! link Special Comment
highlight! link SpecialChar PreProc
highlight! link Tag Underlined
highlight! link Delimiter Normal
highlight! link SpecialComment Comment
highlight! link Debug PreProc

exe "highlight! Underlined" s:fmt_line
exe "highlight! Error"      s:fmt_line s:fg_red    s:bg_none
exe "highlight! Todo"       s:fmt_bold s:fg_orange s:bg_none

" UI colors {{{1

exe "highlight! ColorColumn"    s:fmt_none   s:fg_none s:bg_bright
" exe 'highlight! Conceal'       s:fmt_none   s:fg_blue s:bg_none
" exe 'highlight! Cursor'        s:fmt_rev    s:fg_base
highlight! link CursorColumn ColorColumn
highlight! link CursorLine ColorColumn

exe "highlight! DiffAdd"        s:fmt_none s:fg_green  s:bg_none
exe "highlight! DiffChange"     s:fmt_bold s:fg_none   s:bg_bright
exe "highlight! DiffDelete"     s:fmt_none s:fg_red    s:bg_none
exe "highlight! DiffText"       s:fmt_bold s:fg_yellow s:bg_none
exe "highlight! Directory"      s:fmt_none s:fg_blue   s:bg_none
highlight! link ErrorMsg Error
exe "highlight! Folded"         s:fmt_bold s:fg_none   s:bg_bright
exe "highlight! IncSearch"      s:fmt_revb s:fg_orange s:bg_none
exe "highlight! LineNr"         s:fmt_none s:fg_soft   s:bg_bright
exe "highlight! CursorLineNr"   s:fmt_bold s:fg_yellow s:bg_bright
hi! link MatchParen IncSearch

exe "highlight! Pmenu"          s:fmt_revb s:fg_base   s:bg_none
exe "highlight! PmenuSel"       s:fmt_revb s:fg_soft   s:bg_none

exe "highlight! Question"       s:fmt_bold s:fg_yellow s:bg_none
highlight! link MoreMsg Question
highlight! link NonText Special

exe "highlight! Search"         s:fmt_rev  s:fg_yellow s:bg_none
highlight! link SpellBad Error
highlight! link SpellCap SpellBad
highlight! link SpellLocal SpellBad
highlight! link SpellRare SpellBad

exe "highlight! Title"          s:fmt_bold s:fg_orange s:bg_none
highlight! link VertSplit Normal
exe "highlight! Visual"         s:fmt_rev  s:fg_soft   s:bg_none
exe "highlight! WarningMsg"     s:fmt_bold s:fg_red    s:bg_none
exe "highlight! StatusLine"     s:fmt_revb s:fg_base   s:bg_bright
exe "highlight! WildMenu"       s:fmt_none s:fg_yellow s:bg_bright
highlight! link SignColumn LineNr
highlight! link SpecialKey Comment
highlight! link YcmErrorSection Error
highlight! link YcmWarningSection SpellBad
exe "highlight! YcmWarningSign" s:fmt_none s:fg_yellow s:bg_none
highlight! link helpHyperTextJump helpHyperTextEntry

" Obsolete
exe "highlight! PmenuSbar"      s:fmt_revb
exe "highlight! FoldColumn"     s:fmt_none s:fg_base   s:bg_bright
exe "highlight! StatusLineNC"   s:fmt_none s:fg_base   s:bg_bright s:fmt_revb
exe "highlight! TabLine"        s:fmt_line s:fg_base   s:bg_bright
exe "highlight! TabLineFill"    s:fmt_line s:fg_base   s:bg_bright
exe "highlight! TabLineSel"     s:fmt_revb s:fg_soft   s:bg_bright
exe "highlight! ModeMsg"        s:fmt_none s:fg_blue   s:bg_none
exe "highlight! PmenuThumb"     s:fmt_none s:fg_base   s:bg_bright s:fmt_revb

" Language-specific {{{1

highlight! link fishIdentifier PreProc

