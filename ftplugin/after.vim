syn keyword Todo TODO contained containedin=Comment

let s:seps = split(&commentstring, '\s*%s\s*')
execute 'syn region Comment start=_\V' . (&ft ==# 'vim' ? '\^"' : s:seps[0]) . '_ end=_\V' . get(s:seps, 1, '\$') . '_'

syn match SpecialChar /\v\\([bfnrt\\"]|\o{1,3})/ contained

hi! link ErrorChar Error

" See fo-table
setlocal formatoptions=acroqljn
setlocal comments=sr:/**,mb:*,ex:*/,sr:/*,mb:*,ex:*/
setlocal smartindent

" Annoying mappings
silent! vunmap <buffer> K
