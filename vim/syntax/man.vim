let $COLUMNS = &columns

syn match Keyword /\v\W\zs--?(\k|-)+/ containedin=ALL
syn match String /\f\+([1-9][a-z]\=)/
syn match Todo /^\v%(   )?\u.*/
syn region C matchgroup=Todo start=/SYNOPSIS/ end=/\v\n\n\u+$/ contains=@C keepend
syn include @C syntax/c.vim

setlocal iskeyword+=. nonumber nolist buftype=nofile bufhidden=hide
