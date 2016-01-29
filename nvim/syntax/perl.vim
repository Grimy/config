Flow sub|if|unless|while|until|for else|elsif
Comments #

syn keyword Error elseif
syn keyword PreProc use
syn keyword Flow or and next last return

syn match SpecialChar /\v\\e/
syn region String matchgroup=Normal start=/\v\z((['"])%(\1\1)?)/ end=/\v\z1/ contains=SpecialChar,ErrorChar
syn region String matchgroup=Normal start='/' skip='\\.' end='/' contains=SpecialChar oneline
