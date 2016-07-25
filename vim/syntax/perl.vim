Flow sub|if|unless|while|until|for else|elsif
Comments #

let &l:makeprg = 'perl -cw %'
set errorformat=%m\ at\ %f\ line\ %l%s

syn keyword Error elseif
syn keyword Flow goto or and next last do redo return die croak confess
syn keyword Keyword require
syn keyword PreProc BEGIN use no package my our

syn match SpecialChar /\v\\e/
syn region Comment start=/\v^\=/ end=/\v^\=cut/
syn region String matchgroup=Normal start=/\v\z((['"])%(\1\1)?)/ end=/\v\z1/ contains=SpecialChar,ErrorChar
syn region String matchgroup=Normal start='/' skip='\\.' end='/' contains=SpecialChar oneline
