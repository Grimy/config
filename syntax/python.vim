syn keyword Flow if elif else for in while and or
syn keyword Flow try raise except finally assert
syn keyword Flow return yield pass break continue
syn match Flow /:$/
syn keyword Keyword print del exec with as is global class def
syn keyword Keyword True False None lambda not
syn keyword PreProc import from

let b:indent_conted = '\v[\[({\\,]$'
let b:indent_start  = '\v:$'
let b:indent_end    = '\v^[\t }]*<%(elif|else|except|finally)>|^\s*\}'

syn region String matchgroup=Normal start="'" end="'" contains=SingleEscape
syn region String matchgroup=Normal start='"' end='"' contains=SpecialChar,ErrorChar
syn region String matchgroup=Normal start="'''" end="'''" contains=SingleEscape
syn region String matchgroup=Normal start='"""' end='"""' contains=SpecialChar,ErrorChar
syn region String matchgroup=Normal start='/' skip='\\.' end='/' contains=SpecialChar oneline

syn match SingleEscape /\\[\\']/ contained
hi! link SingleEscape SpecialChar
syn match ErrorChar /\\./
syn match SpecialChar /\v\\([aesv]|c.|[MC]-.|M-\\C-.|x\x{1,2}|u\x{4})/ contained

setlocal synmaxcol=242
syntax sync minlines=42
