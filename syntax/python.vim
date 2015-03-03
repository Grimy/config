syn keyword Boolean True False and or not
syn keyword Conditional if : elif else
syn keyword Exception try raise except finally
syn keyword Keyword print del exec with as is
syn keyword PreProc import from assert
syn keyword Label return yield pass break continue
syn keyword Repeat for in while
syn keyword StorageClass global
syn keyword Structure class def lambda

syn region String matchgroup=Normal start="'" end="'" contains=SingleEscape
syn region String matchgroup=Normal start='"' end='"' contains=SpecialChar,ErrorChar
syn region String matchgroup=Normal start="'''" end="'''" contains=SingleEscape
syn region String matchgroup=Normal start='"""' end='"""' contains=SpecialChar,ErrorChar
syn region String matchgroup=Normal start='/' skip='\\.' end='/' contains=SpecialChar oneline

syn match SingleEscape /\\[\\']/ contained
hi! link SingleEscape SpecialChar
syn match ErrorChar /\\./
syn match SpecialChar /\v\\([aesv]|c.|[MC]-.|M-\\C-.|x\x{1,2}|u\x{4})/ contained
