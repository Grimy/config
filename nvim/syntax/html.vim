runtime! syntax/xml.vim

syn region QuotelessString matchgroup=Normal start=/\v(^|\s)\_s*\k+\_s*\=\_s*\k@=/ end=/\>/ contained containedin=XMLTag
hi link QuotelessString String
syn region CSS matchgroup=Normal start=/\v\<style.{-}\>/ end='</style' contains=@CSS
syn include @CSS syntax/css.vim
syn region JS matchgroup=Normal start=/\v\<script.{-}\>/ end='</script' contains=@JS
syn include @JS syntax/js.vim
