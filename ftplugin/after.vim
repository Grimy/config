syn keyword Todo TODO contained containedin=Comment
syn match SpecialChar /\v\\([bfnrt\\"]|\o{1,3})/ contained
hi! link ErrorChar Error

let b:match_words =
			\ '\<\%(if\|unless\|case\|while\|until\|for\|do\|class\|module\|def\|begin\)\>=\@!' .
			\ ':\<\%(else\|elsif\|ensure\|when\|rescue\|break\|redo\|next\|retry\)\>' .
			\ ':\<end\>,{:},\[:\],(:)'
let b:match_skip = 's:comment\|string\|character'

" See fo-table
setlocal formatoptions=acroqljn
setlocal comments=sr:/**,mb:*,ex:*/,sr:/*,mb:*,ex:*/

" Annoying mappings
silent! vunmap <buffer> K
