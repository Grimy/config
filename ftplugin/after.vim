let b:match_words =
			\ '\<\%(if\|unless\|case\|while\|until\|for\|do\|class\|module\|def\|begin\)\>=\@!' .
			\ ':\<\%(else\|elsif\|ensure\|when\|rescue\|break\|redo\|next\|retry\)\>' .
			\ ':\<end\>,{:},\[:\],(:)'

" See fo-table
setlocal formatoptions=acroqljn
setlocal comments=sr:/**,mb:*,ex:*/,sr:/*,mb:*,ex:*/
