nnoremap <buffer> <CR> K
let $COLUMNS = &columns

setlocal tabstop=8 colorcolumn= iskeyword+=.
setlocal nolist nowrap nofoldenable nonumber
setlocal buftype=nofile bufhidden=hide noswapfile

autocmd BufEnter <buffer> set scrolloff=999 scrolljump=1
autocmd BufLeave <buffer> set scrolloff=20  scrolljump=4

syn match Keyword /\v\W\zs--?(\k|-)+/ containedin=ALL
syn match String /\f\+([1-9][a-z]\=)/
syn match Todo /^\v%(   )?\u.*/
syn region C matchgroup=Todo start=/SYNOPSIS/ end=/\v\n\n\u+$/ contains=@C keepend
syn include @C syntax/c.vim
