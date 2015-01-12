let b:match_words =
			\ '\<\%(if\|unless\|case\|while\|until\|for\|do\|class\|module\|def\|begin\)\>=\@!' .
			\ ':' .
			\ '\<\%(else\|elsif\|ensure\|when\|rescue\|break\|redo\|next\|retry\)\>' .
			\ ':' .
			\ '\<end\>' .
			\ ',{:},\[:\],(:)'

" See fo-table
setlocal formatoptions=caroqljn
" setlocal formatoptions=tcaroqljn

setlocal comments-=:// comments+=f://
setlocal comments-=b:# comments+=bf:#
