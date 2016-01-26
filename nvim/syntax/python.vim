Flow if|for|while|try else|elif|except|finally ^$
Comments #

syn keyword Flow in and or try raise assert
syn keyword Flow return yield pass break continue
syn keyword Keyword print del exec with as is global class def
syn keyword Keyword True False None lambda not
syn keyword PreProc import from

syn region String matchgroup=Normal start=/\vr\z((['"])%(\1\1)?)/ end=/\v\z1/
syn region String matchgroup=Normal start=/\v\z((['"])%(\1\1)?)/ end=/\v\z1/ contains=SpecialChar,ErrorChar
syn region String matchgroup=Normal start='/' skip='\\.' end='/' contains=SpecialChar oneline

syn match SpecialChar /\v\\([aesv']|c.|[MC]-.|M-\\C-.|x\x{1,2}|u\x{4})/ contained
hi! link SingleEscape SpecialChar
