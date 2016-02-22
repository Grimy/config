Flow sub|if|unless|while|until|for else|elsif
Comments #

setlocal foldmarker=###,###
syn keyword Error elseif
syn keyword Flow goto or and next last return die croak confess
syn keyword Keyword require
syn keyword PreProc BEGIN use no package my our

syn match SpecialChar /\v\\e/
syn region String matchgroup=Normal start=/\v\z((['"])%(\1\1)?)/ end=/\v\z1/ contains=SpecialChar,ErrorChar
syn region String matchgroup=Normal start='/' skip='\\.' end='/' contains=SpecialChar oneline
